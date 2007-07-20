Return-Path: <linux-kernel-owner+w=401wt.eu-S939317AbXGTP5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939317AbXGTP5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937044AbXGTP5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:57:18 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:40047
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbXGTP5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:57:17 -0400
Date: Fri, 20 Jul 2007 08:44:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Milton Miller <miltonm@bga.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm <linux-pm@lists.linuxfoundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <86863e635f75f5b0e3746202893cb231@bga.com>
Message-ID: <Pine.LNX.4.64.0707200837530.19248@asgard.lang.hm>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
 <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
 <200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
 <200707151433.34625.rjw@sisk.pl> <200707172320.16279.rjw@sisk.pl>
 <ea7a437ca4038d408ac544bbc3c2434a@bga.com> <Pine.LNX.4.64.0707191018520.28721@asgard.lang.hm>
 <86863e635f75f5b0e3746202893cb231@bga.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Milton Miller wrote:

> On Jul 19, 2007, at 12:31 PM, david@lang.hm wrote:
>>  On Thu, 19 Jul 2007, Milton Miller wrote:
>> > 
>> >  This means that the first kernel will need to know why it got resumed. 
>> >  Was the system powered off, and this is the resume from the user?   Or 
>> >  was it restarted because the image has been saved, and its now time to 
>> >  actually suspend until woken up?  If you look at it, this is the same 
>> >  interface we have with the magic arch_suspend hook -- did we just 
>> >  suspend and its time to write the image, or did we just resume and its 
>> >  time to wake everything up.
>> > 
>> >  I think this can be easily solved by giving the image saving kernel two 
>> >  resume points: one for the image has been written, and one for we 
>> >  rebooted and have restored the image.  I'm not familiar with ACPI. 
>> >  Perhaps we need a third to differentiate we read the image from S4 
>> >  instead of from S5, but that information must be available to the OS 
>> >  because it needs that to know if it should resume from hibernate.
>>
>>  are we sure that there are only 2-3 possible actions? or should this be
>>  made into a simple jump table so that it's extendable?
>
> At 2 I don't think we need a jump table.   Even if we had a table, we have to 
> identify what each entry means.  If we start getting more then we can change 
> from command line to table.

Ok, I was just looking to future-proof things so that these features can 
work on older kernels (as opposed to having two interfaces and when we 
switch from one to the next kernels older then that can't be used)

>>  remember that the save and restore kernel can access the memory of the
>>  suspending kernel, so as long as the data is in a known format and there
>>  is a pointer to the data in a known location, the save and restore kernel
>>  can retreive the data from memory, there's no need to involve media.
>
> I agree that the the save kernel can read the list from the being-saved 
> kernel.
>
> However, when restoring, the being-saved (being-restored) kernel is not 
> accessable, so the save list has to be stored as part of the image.

at that point it's less a save list then just the record of where the 
memory pages belong. you can use the same list, but you can store it along 
with the memory image. there's still no need for the suspending kernel to 
save it to permanent media.

>> >  Simplifying kjump: the proposal for v3.
>> > 
>> >  The current code is trying to use crash dump area as a safe, reserved 
>> >  area to run the second kernel.   However, that means that the kernel has 
>> >  to be linked specially to run in the reserved area.   I think we need to 
>> >  finish separating kexec_jump from the other code paths.
>>
>>  on x86 at least it's possible to compile a relocateable kernel, so it
>>  doesn't need to be compiled specificly for a particular reserved area.
>>  This would allow you to use the same kernel build as the suspending kernel
>>  if you wanted to (I think that the config of the save and restore kernel
>>  is going to be trivial enough to consider auto-configuring and building a
>>  specific kernel for each box a real possibility)
>
> Yes, one *can* build x86 relocatable.  But there are funny restrictions like 
> it has to be a bzImage or be loaded by kexec or something.   And not all 
> architectures have relocatable support.  I think making the lists for the 
> exsiting code to swap memory will not be that difficult and it will make the 
> solution have less restrictions.  Maybe I should shut up and write some code 
> this weekend.
>
> Actually, I think we can have the dedicated area as an option.  If you 
> suspend frequently keep a relocated kernel booted.  If you need more ram or 
> suspend infrequently allocate the pages on the fly.

for the proof of concept that we are trying for now there's no need to 
implement the capability to free memory to make room for the kexec kernel. 
after we show that this can work that can be added.

>
>> >  As a first stage of suspend and resume, we can save to dedicated 
>> >  partitions all memory (as supplied to crash_dump) that is not marked 
>> >  nosave and not part of the save kernel's image.   The fancy block lists 
>> >  and memory lists can be added later.
>>
>>  if the suspending kernel needs to tell the save and restore kernel what
>>  memory is not marked nosave have it do so useing a memory list of some
>>  kind. you need to setup a mechanism for communicating the data anyway,
>>  setup a mechansim that's useable in the long term.
>
> I'm saying we can have people start to test by the simple save all ram to 
> dedicated while we figure out what the long term list looks like.

the only problem with this is that Rafael is saying that if you try to 
save all the ram you will fail (in some cases becouse you are trying to 
save ram that doesn't exist). so at the very least we need to get a list 
that tells us what _can_ be saved.

David Lang
