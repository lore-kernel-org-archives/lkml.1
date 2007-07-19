Return-Path: <linux-kernel-owner+w=401wt.eu-S940912AbXGSRjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940912AbXGSRjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939244AbXGSRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:39:35 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:38110
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763292AbXGSRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:39:33 -0400
Date: Thu, 19 Jul 2007 10:31:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Milton Miller <miltonm@bga.com>
cc: linux-pm <linux-pm@lists.linuxfoundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <ea7a437ca4038d408ac544bbc3c2434a@bga.com>
Message-ID: <Pine.LNX.4.64.0707191018520.28721@asgard.lang.hm>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
 <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
 <200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
 <200707151433.34625.rjw@sisk.pl> <200707172320.16279.rjw@sisk.pl>
 <ea7a437ca4038d408ac544bbc3c2434a@bga.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Milton Miller wrote:

>>  (2) Upon start-up (by which I mean what happens after the user has pressed
>>      the power button or something like that):
>>    * check if the image is present (and valid) _without_ enabling ACPI (we
>>  don't
>>      do that now, but I see no reason for not doing it in the new
>>  framework)
>>    * if the image is present (and valid), load it
>>    * turn on ACPI (unless already turned on by the BIOS, that is)
>>    * execute the _BFS global control method
>>    * execute the _WAK global control method
>>    * continue
>>    Here, the first two things should be done by the image-loading
>>  kernel, but
>>    the remaining operations have to be carried out by the restored kernel.
>
> Here I agree.
>
> Here is my proposal.  Instead of trying to both write the image and suspend, 
> I think this all becomes much simpler if we limit the scope the work of the 
> second kernel.  Its purpose is to write the image.   After that its done. 
> The platform can be powered off if we are going to S5.   However, to support 
> suspend to ram and suspend to disk, we return to the first kernel.
>
> This means that the first kernel will need to know why it got resumed.  Was 
> the system powered off, and this is the resume from the user?   Or was it 
> restarted because the image has been saved, and its now time to actually 
> suspend until woken up?  If you look at it, this is the same interface we 
> have with the magic arch_suspend hook -- did we just suspend and its time to 
> write the image, or did we just resume and its time to wake everything up.
>
> I think this can be easily solved by giving the image saving kernel two 
> resume points: one for the image has been written, and one for we rebooted 
> and have restored the image.  I'm not familiar with ACPI.  Perhaps we need a 
> third to differentiate we read the image from S4 instead of from S5, but that 
> information must be available to the OS because it needs that to know if it 
> should resume from hibernate.

are we sure that there are only 2-3 possible actions? or should this be 
made into a simple jump table so that it's extendable?

> As noted in  the thread
>
> Message-ID: <873azxwqhr.fsf@jbms.ath.cx>
> Subject: [linux-pm] Re: hibernation/snapshot design
> on Mon Jul  9 08:23:53 2007, Jeremy Maitin-Shepard wrote:
>
>>  (3) how to communicate where to save the memory
>
> This is an intresting topic.  The suspended kernel has most IO and disk 
> space.  It also knows how much space is to be occupied by the kernel.   So 
> communicating a block map to the second kernel would be the obvious choice. 
> But the second kernel must be able to find the image to restore it, and it 
> must have drivers for the media.  Also, this is not feasible for storing to 
> nfs.
>
> I think we will end up with several methods.
>
> One would be supply a list of blocks, and implement a file system that reads 
> the file by reading the scatter list from media.  The restore kernel then 
> only needs to read an anchor, and can build upon that until the image is read 
> into memory.  Or do this in userspace.
>
> I don't know how this compares to the current restore path.   I wasn't able 
> to identify the code that creates the on disk structure in my 10 minute 
> perusal of kernel/power/.
>
> A second method will be to supply a device and file that will be mounted by 
> the save kernel, then unmounted and restored.  This would require a partition 
> that is not mounted or open by the suspended kernel (or use nfs or a similar 
> protocol that is designed for multiple client concurrent access).
>
> A third method would be to allocate a file with the first kernel, and make 
> sure the blocks are flushed to disk.  The save and restore kernels map the 
> file system using a snapshot device.  Writing would map the blocks and use 
> the block offset to write to the real device using the method from the first 
> option; reading could be done directly from the snapshot device.
>
> The first and third option are dead on log based file systems (where the data 
> is stored in the log).

remember that the save and restore kernel can access the memory of the 
suspending kernel, so as long as the data is in a known format and there 
is a pointer to the data in a known location, the save and restore kernel 
can retreive the data from memory, there's no need to involve media.

> Simplifying kjump: the proposal for v3.
>
> The current code is trying to use crash dump area as a safe, reserved area to 
> run the second kernel.   However, that means that the kernel has to be linked 
> specially to run in the reserved area.   I think we need to finish separating 
> kexec_jump from the other code paths.

on x86 at least it's possible to compile a relocateable kernel, so it 
doesn't need to be compiled specificly for a particular reserved area. 
This would allow you to use the same kernel build as the suspending kernel 
if you wanted to (I think that the config of the save and restore kernel 
is going to be trivial enough to consider auto-configuring and building a 
specific kernel for each box a real possibility)

> As a first stage of suspend and resume, we can save to dedicated partitions 
> all memory (as supplied to crash_dump) that is not marked nosave and not part 
> of the save kernel's image.   The fancy block lists and memory lists can be 
> added later.

if the suspending kernel needs to tell the save and restore kernel what 
memory is not marked nosave have it do so useing a memory list of some 
kind. you need to setup a mechanism for communicating the data anyway, 
setup a mechansim that's useable in the long term.

> If we want to keep the second kernel booted, then we need to add a save area 
> for the booted jump target.   Note that the save and restore lists to 
> relocate_new_kernel can be computed once and saved.   Longer term we could 
> implement sys_kexec_load(UNLOAD) that would retrieve the saved list back to 
> application space to save to disk in a file.   This means you could save the 
> booted save kernel, it just couldn't have any shared storage open.

since the kexec to the second kernel needs to handle the device 
intialization, do you really save much by doing this? from a reliability 
point of view it would seem simpler (and therefor more reliable) to 
initialize the save and restore kernel each time it's used, so that it 
always does the same thing (as opposed to carrying state from one use to 
the next)

David Lang

