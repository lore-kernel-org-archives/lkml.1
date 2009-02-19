Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZBSWMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZBSWMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZBSWMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:12:03 -0500
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:51358 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbZBSWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:12:01 -0500
X-Greylist: delayed 4167 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 17:12:01 EST
Message-ID: <499DC8EC.3000806@shipmail.org>
Date: Thu, 19 Feb 2009 22:02:36 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081231)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Eric Anholt <eric@anholt.net>, Wang Chen <wangchen@cn.fujitsu.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and	struct_mutex.
References: <1234918786-854-1-git-send-email-eric@anholt.net> <1234969734.4637.111.camel@laptop>
In-Reply-To: <1234969734.4637.111.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 16:59 -0800, Eric Anholt wrote:
>   
>> The basic problem was
>> mmap_sem (do_mmap()) -> struct_mutex (drm_gem_mmap(), i915_gem_fault())
>> struct_mutex (i915_gem_execbuffer()) -> mmap_sem (copy_from/to_user())
>>     
>
> That's not the only problem, there's also:
>
> dup_mmap()
>   down_write(mmap_sem)
>   vm_ops->open() -> drm_vm_open()
>     mutex_lock(struct_mutex);
>
>   
>> We have plenty of places where we want to hold device state the same
>> (struct_mutex) while we move a non-trivial amount of data
>> (copy_from/to_user()), such as i915_gem_pwrite().  Solve this by moving the
>> easy things that needed struct_mutex with mmap_sem held to using a lock to
>> cover just those data structures (offset hash and offset manager), and do
>> trylock and reschedule in fault.
>>     
>
> So we establish,
>
>   mmap_sem
>     offset_mutex
>
>   i915_gem_mmap_gtt_ioctl()
>     mutex_lock(struct_mutex)
>     i915_gem_create_mmap_offset()
>       mutex_lock(offset_mutex)
>
> However we still have
>
>   struct_mutex
>     mmap_sem
>
> in basically every copy_*_user() case
>
> But you cannot seem to switch ->fault() to use offset_mutex, which would
> work out the inversion because you then have:
>
>   struct_mutex
>     mmap_sem
>       offset_mutex
>
> So why bother with the offset_mutex? Instead you make your ->fault()
> fail randomly.
>
> I'm not sure what Wang Chen sees after this patch, but I should not be
> the exact same splat, still it would not at all surprise me if there's
> plenty left.
>
> The locking looks very fragile and I don't think this patch is helping
> anything, sorry.
>
>   
It looks to me like the driver preferred locking order is

object_mutex (which happens to be the device global struct_mutex)
  mmap_sem
     offset_mutex.

So if one could avoid using the struct_mutex for object bookkeeping (A 
separate lock) then
vm_open() and vm_close() would adhere to that locking order as well, 
simply by not taking the struct_mutex at all.

So only fault() remains, in which that locking order is reversed. 
Personally I think the trylock ->reschedule->retry method with proper 
commenting is a good solution. It will be the _only_ place where locking 
order is reversed and it is done in a deadlock-safe manner. Note that 
fault() doesn't really fail, but requests a retry from user-space with 
rescheduling to give the process holding the struct_mutex time to 
release it.

/Thomas





