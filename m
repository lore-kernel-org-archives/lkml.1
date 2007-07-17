Return-Path: <linux-kernel-owner+w=401wt.eu-S935363AbXGQUbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363AbXGQUbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764137AbXGQUaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:30:24 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58627
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933307AbXGQUaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:30:22 -0400
Date: Tue, 17 Jul 2007 13:18:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <200707172150.44417.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
 <200707171802.30903.rjw@sisk.pl> <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
 <200707172150.44417.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:

> On Tuesday, 17 July 2007 19:06, david@lang.hm wrote:
>> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
>>
>>> On Tuesday, 17 July 2007 17:29, david@lang.hm wrote:
>>>> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
>>>>
>>>>> On Tuesday, 17 July 2007 16:15, Alan Stern wrote:
>>>>>> On Mon, 16 Jul 2007 david@lang.hm wrote:
>>>>>>
>>>>>>>> I agree, it would be good to have a non-ACPI-specific hibernation mode,
>>>>>>>> something which would look to ACPI like a normal shutdown.  But I'm not
>>>>>>>> so sure this is possible.
>>>>>>>
>>>>>>> why would it not be possible?
>>>>>>
>>>>>>> I can't think of anything much more frustrating then thinking that I
>>>>>>> suspended a system and then discovering that becouse the battery went dead
>>>>>>> (a complete power loss) that the system wouldn't boot up properly. to me
>>>>>>> this would be a fairly common condition (when I'm mobile I use the machine
>>>>>>> until I am out of battery, then stop and it may be a long time (days)
>>>>>>> before I can charge the thing up again) this would not be a reliable
>>>>>>> suspend as far as I'm concerned.
>>>>>>>
>>>>>>> for suspend-to-ram you have to worry about ACPI states and what you are
>>>>>>> doing with them, for suspend-to-disk you can ignore them and completely
>>>>>>> power the system off instead.
>>>>>>
>>>>>> If the only problem with doing this would be lack of wakeup support
>>>>>> then I'm all for it.  There must be a lot of people who would like
>>>>>> their computers to hibernate with power drain as close to 0 as possible
>>>>>> and who don't care about remote wakeup.  In fact they might even prefer
>>>>>> not to have wakeup support, so the computer doesn't resume at
>>>>>> unexpected times.
>>>>>
>>>>> I'm afraid of one thing, though.
>>>>>
>>>>> If we create a framework without ACPI (well, ACPI needs to be enabled in the
>>>>> kernel anyway for other reasons, like the ability to suspend to RAM) and then
>>>>> it turns out that we have to add some ACPI hooks to it, that might be difficult
>>>>> to do cleanly.
>>>>
>>>> doing suspend-to-ram should be orthoginal to doing hibernate-to-disk. some
>>>> people will want both, some won't.
>>>>
>>>> at the moment kexec doesn't work with ACPI, that is a limitation that
>>>> should be fixed, but makeing it able to work with ACPI enabled doesn't
>>>> mean that it needs to be changed to depend on ACPI and it especially
>>>> doesn't mean that it should pick up the limitations of the existing ACPI
>>>> based hibernation approaches.
>>>>
>>>> if there is no ACPI on the system it should work, if ther is ACPI on the
>>>> system it should still work.
>>>>
>>>>> Thus, it seems reasonable to think of the ACPI handling in advance.
>>>>
>>>> but don't become dependant on ACPI.
>>>
>>> Not dependent, but with the possibility of ACPI support taken into account.
>>>
>>> Arguably you can create a framework that, for example, will not allow the user
>>> to adjust the size of the image, but then adding such a functionality may
>>> require you to change the entire design.  Same thing with ACPI.
>>>
>>> I would rather avoid such pitfalls, if I could.
>>
>> Ok, what is it that you think ACPI fundamentally changes in this process?
>>
>> keep in mind that we are not makeing the assumption that the hardware
>> will remain powered (even a little bit), or the assumption that nothing
>> else will run on the hardware (eliminating any possibility that the
>> hardware is in a known ACPI state)
>
> Well, first, the fact is that _some_ systems _will_ be powered while in
> hibernation (the majority of notebooks, for example) and you should assume
> that the platform _may_ retain some information accross the hibernation/restore
> cycle.  In that case you _should_ _not_ trash the information retained by the
> platform.

no, systems that remain powered while asleep are a different type of 
suspend then ones that don't.

> Now, with that in mind, ACPI requires us to make the system enter the S4 sleep
> state as a result of the hibernation procedure.  In my opinion this may be done
> after saving the image, but still this means, for example, that the
> image-saving kernel needs to support ACPI.
>
> Next, during the restore, we should first check if the image is present (and
> valid) _without_ turning ACPI on (note that this is not done by the current
> hibernation code and that leads to strange problems on some systems).  Then,
> if the image is present (and valid), we should first load it, jump to the
> hibernated kernel and _then_ turn ACPI on and execute the _BFS and
> _WAK ACPI global methods (again, this is not done by the current code in that
> order, which is wrong).  Only after that is the hibernated kernel supposed to
> continue.
>
> [Please refer to section 15.3 of the 3.0b ACPI spec for details.]

you are starting from the assumption that ACPI S4 mode should be used.

I'm saying that a suspend that uses ACPI S4 mode is fundamentally 
different from one that does a power off instead.

from my point of view the ACPI S4 sleep mode has far more in common with 
suspend-to-ram then with the suspend-to-disk that I'm talking about

non-ACPI hibernate

   since the box powers off
     it uses zero power while suspended
     another OS could be run before a resume
     hardware can be swapped, suspend image could be sent around the world to be restored on another system.
     restore makes no assumptions about the state of the hardware when it is restored
     restore is slower (full BIOS boot is required)
   should be able to work on just about any hardware (the limit is the ability to initialize the devices)


ACPI suspends

   since the box never completely powers off:
     a complete power failure breaks the suspend
     the OS must remain in control so other uses must be prevented.
     hardware must remain in the ACPI state from suspend until restore.
     restore can be faster (some initialization may be able to be skipped)
   requires ACPI hardware support

under the catagory of ACPI suspends you have

   fast suspend-to-ram (stop scheduling, put the CPU to sleep, as long as 
the memory keeps getting refreshed)
   slow suspend-to-ram (stop scheduling, put as much of the hardware as 
possible to sleep, including spinning down disks and other things that 
take a while to undo)
   suspend-to-disk (stop scheduleing, copy the ram somewhere so that it 
doesn't need to be refreshed, put everything into low-power mode)

   and there are probably quite a few others as well. but they are all in 
the same family in that you have to worry about ACPI states, and they all 
have the same restrictions on what can happen between suspend and resume

the non-ACPI hibernate behaves very differently, and for some people (and 
I think I am one of them) it will meet their needs better then _any_ of 
the ACPI suspends.

David Lang

