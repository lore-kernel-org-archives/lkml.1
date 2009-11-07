Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZKGUxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZKGUxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 15:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZKGUxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 15:53:05 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:4542 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752877AbZKGUxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 15:53:00 -0500
X-Greylist: delayed 999 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Nov 2009 15:53:00 EST
Message-ID: <4AF5DA33.804@shipmail.org>
Date: Sat, 07 Nov 2009 21:36:03 +0100
From: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Jerome Glisse <glisse@freedesktop.org>
CC: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org, bskeggs@redhat.com,
       Dave Airlie <airlied@gmail.com>
Subject: Re: RFC: TTM
References: <1257436124.6064.64.camel@localhost>
In-Reply-To: <1257436124.6064.64.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse wrote:
> Hi,
>
> I would like to do some modification for 2.6.33, so i figure it's good
> time to talk about them. I have 2 aims :
> 1) add flexibility to bo placement
> 2) simplify bo move code
> 3) avoid sub optimal move scenario
> 4) Allow support of GPU with unmappable memory
>
> 1) i think the core idea is to take memory placement table as
> an argument rather than having one static table. Here are the API
> change (code change is pretty straight forward):
>
>         int ttm_buffer_object_validate(struct ttm_buffer_object *bo,
>                                        uint32_t proposed_placement,
>                                        uint32_t *mem_type_prio,
>                                        uint32_t num_mem_type_prio,
>                                        bool interruptible, bool no_wait)
>
>         int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
> 			       uint32_t proposed_placement,
>                                uint32_t *mem_type_prio,
>                                uint32_t num_mem_type_prio,
> 	                       bool interruptible, bool no_wait);
>         
>         int ttm_bo_mem_space(struct ttm_buffer_object *bo,
>                              uint32_t proposed_placement,
>                              struct ttm_mem_reg *mem,
>                              uint32_t *mem_type_prio,
>                              uint32_t num_mem_type_prio,
>                              bool interruptible, bool no_wait);
>
> Drive conversion in first pass could be as easy as supplying the current
> fixed table. Then driver can take advantage of this feature. For
> instance a big texture can have such priority tables: [vram, gart],
> while a small texture or a temporary one or vertex buffer could have
> [gart, vram].
>
>
> 2 & 3 can be achieve by the following change
>       New driver callback :
>           - bo_move
>           - mem_copy
>       Remove the old move callback
> All core ttm replace call to ttm_bo_move_buffer by a driver callback to
> bo_move. Driver bo_move callback should then call ttm_bo_move_buffer
> several time until achieving the wanted result. Example of a bo_move
> callback :
> int radeon_bo_move(struct ttm_buffer_object *bo,
>                    uint32_t proposed_placement,
>                    uint32_t *mem_type_prio,
>                    uint32_t num_mem_type_prio,
>                    bool interruptible, bool no_wait)
> {
> 	int ret;
>
> 	if (new|old.type == VRAM && new|old.type == SYSTEM) {
> 	        ret = ttm_bo_move_buffer(bo, GTT, ...)
>         }
> 	ret = ttm_bo_move_buffer(bo, proposed_placement, ...)
> }
>
> The mem_copy is just their to copy data btw 2 valid gpu address.
> This change would simplify quite a bit the driver code while not
> needing much change to ttm :
>         -ttm_bo_handle_move_mem need to call mem_copy and 
>          ttm_bo_move_accel_cleanup
> 	-evict path need to be adapted to use the driver callback
>          bo_move
> 	-s/ttm_bo_move/driver->bo_move
>
> Beside simplifying driver code it allows to kill unoptimal pattern.
> For instance nowadays on radeon when we get move a BO from VRAM to
> system here is what happen (evil AGP case) :
> 	-ttm_bo_handle_move_mem allocate ttm for system, cached
>          memory
> 	        -radeon move callback changes the memory to uncached
> 	         allocate tmp mem block in GTT to do the copy cleanup
>                  its mess
>
> New scheme:
> 	-call radeon move_bo
> 		-call ttm_bo_handle_move_mem VRAM->GTT which allocate
>                  uncached memory for ttm and thus can use pool allocator
> 		 also ttm_bo_handle_move_mem now do the cleanup
>                 -call ttm_bo_handle_move_mem GTT->SYSTEM call
>                  ttm_bo_move_ttm and then ttm_bo_handle_move_mem
> Less code in the driver and not that much more in the ttm, also if we
> ever have to support a gpu with bigger move dependency chain it would
> be a lot easier with this scheme. For instance a GPU with VRAM0, VRAM1
> and GTT where VRAM1 can only communicate with VRAM0, and VRAM0 can
> communicate with VRAM1 & GTT.
>
>
> 4) haven't looked much at the code for this one thus my solution might
> not be doable. TTM would have man->io_size != man->size. TTM would
> evict|move buffer to a somewhere CPU can access if userspace calls mmap
> or read/write on the buffer. TTM would also need a new flag to force
> placement in visible area for some buffer (like scanout). Driver would
> be responsible to pass some kind of hint to ttm to only place buffer
> with unfrequent CPU access into the unvisible area.
>
>
> Thomas what's your feeling on those change ? I plan to do 3 patches, one
> for the priority stuff, one for changing the move path and last one for
> the unvisible memory. These would need driver update but i think beside
> radeon, nouveau and new poulsbo driver there isn't much user of TTM
> nowadays.
>   
Jerome,
A quick answer:

1, and 2 looks ok. For 3, I'd like to dig a little deeper to understand 
why Radon needs that suboptimal move path, but in general I have nothing 
against a fix if needed.

For 4) the trivial solution would be to add a callback from the 
ttm_bo_vm_fault() method when the bo has been reserved, and, when trying 
to fault a page of a bo, validate it into the mappable memory type. Also 
with your new api that allows you to validate a buffer into an offset 
range you strictly don't need two VRAM memory types: In the driver 
fault() method, just make sure you validate the bo into a mappable 
offset range.

Note, however, that if you need to take a driver global mutex in the 
driver fault() method to stop multiple threads from validating at the 
same time, you might end up with locking order inversions wrt the 
mmap_sem. You probably need to take the same driver global mutex that 
you use for command submission to prevent bo reserve deadlocks. We use 
the ttm lock for this (not upstream yet).

For other TTM users, there's hopefully an upcoming VMware driver not too 
far away, and of course the new openChrome driver that I'd like to 
upstream at some point. If you make patches to core TTM We'll bring 
those drivers up-to-date.

/Thomas.

> Ben what's your thought on those change ? I don't think it would be too
> much work for nouveau driver. I will have a look but i suspect second
> patch would allow similar simplification in nouveau as in radeon.
>
> Cheers,
> Jerome
>
>   



