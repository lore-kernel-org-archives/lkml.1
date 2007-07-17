Return-Path: <linux-kernel-owner+w=401wt.eu-S935456AbXGQVu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456AbXGQVu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbXGQVuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:50:18 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53321
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbXGQVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:50:16 -0400
Date: Tue, 17 Jul 2007 14:42:58 -0700 (PDT)
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
In-Reply-To: <200707172337.24683.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707171430050.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
 <200707172257.22959.rjw@sisk.pl> <Pine.LNX.4.64.0707171345270.2467@asgard.lang.hm>
 <200707172337.24683.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:

> On Tuesday, 17 July 2007 22:53, david@lang.hm wrote:
>> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
>>
>>> On Tuesday, 17 July 2007 22:18, david@lang.hm wrote:
>>>> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
>>>>
>>>>> Now, with that in mind, ACPI requires us to make the system enter the S4 sleep
>>>>> state as a result of the hibernation procedure.  In my opinion this may be done
>>>>> after saving the image, but still this means, for example, that the
>>>>> image-saving kernel needs to support ACPI.
>>>>>
>>>>> Next, during the restore, we should first check if the image is present (and
>>>>> valid) _without_ turning ACPI on (note that this is not done by the current
>>>>> hibernation code and that leads to strange problems on some systems).  Then,
>>>>> if the image is present (and valid), we should first load it, jump to the
>>>>> hibernated kernel and _then_ turn ACPI on and execute the _BFS and
>>>>> _WAK ACPI global methods (again, this is not done by the current code in that
>>>>> order, which is wrong).  Only after that is the hibernated kernel supposed to
>>>>> continue.
>>>>>
>>>>> [Please refer to section 15.3 of the 3.0b ACPI spec for details.]
>>>>
>>>> you are starting from the assumption that ACPI S4 mode should be used.
>>>>
>>>> I'm saying that a suspend that uses ACPI S4 mode is fundamentally
>>>> different from one that does a power off instead.
>>>
>>> It is different, but not fundamentally.
>>>
>>>> from my point of view the ACPI S4 sleep mode has far more in common with
>>>> suspend-to-ram then with the suspend-to-disk that I'm talking about
>>>>
>>>> non-ACPI hibernate
>>>>
>>>>    since the box powers off
>>>>      it uses zero power while suspended
>>>>      another OS could be run before a resume
>>>>      hardware can be swapped, suspend image could be sent around the world to be restored on another system.
>>>>      restore makes no assumptions about the state of the hardware when it is restored
>>>>      restore is slower (full BIOS boot is required)
>>>>    should be able to work on just about any hardware (the limit is the ability to initialize the devices)
>>>>
>>>>
>>>> ACPI suspends
>>>>
>>>>    since the box never completely powers off:
>>>>      a complete power failure breaks the suspend
>>>>      the OS must remain in control so other uses must be prevented.
>>>>      hardware must remain in the ACPI state from suspend until restore.
>>>>      restore can be faster (some initialization may be able to be skipped)
>>>>    requires ACPI hardware support
>>>>
>>>> under the catagory of ACPI suspends you have
>>>>
>>>>    fast suspend-to-ram (stop scheduling, put the CPU to sleep, as long as
>>>> the memory keeps getting refreshed)
>>>>    slow suspend-to-ram (stop scheduling, put as much of the hardware as
>>>> possible to sleep, including spinning down disks and other things that
>>>> take a while to undo)
>>>>    suspend-to-disk (stop scheduleing, copy the ram somewhere so that it
>>>> doesn't need to be refreshed, put everything into low-power mode)
>>>>
>>>>    and there are probably quite a few others as well. but they are all in
>>>> the same family in that you have to worry about ACPI states, and they all
>>>> have the same restrictions on what can happen between suspend and resume
>>>>
>>>> the non-ACPI hibernate behaves very differently, and for some people (and
>>>> I think I am one of them) it will meet their needs better then _any_ of
>>>> the ACPI suspends.
>>>
>>> OTOH, there are many people who would want the ACPI suspends to be handled
>>> and they don't really care for the power-off-only hibernation.
>>>
>>> If you aren't going to support the ACPI hibernation, your framework will be
>>> incomplete and therefore not generally useful.
>>
>> if you make the framework limited by the ACPI requriement, your framework
>> will not be able to be used in all cases and is therefor incomplete and
>> not generally useful.
>>
>> see, I can make authoritative sounding declarations too. :-)
>
> Well, being able to support ACPI need not imply being unable to work in the
> other cases.  Conversely, being able to work in non-ACPI cases need not imply
> being unable to support ACPI.  Hence, you can support ACPI and be able to
> work in the other cases at the same time.
>
> Try again. ;-)

I thought it was you who was saying that the restore operation requried 
ACPI if you used ACPI at all.

>> I agree that some people want ACPI suspends, but you don't seem to allow
>> the fact that some people don't,
>
> No, I do.
>
> What I'm trying to say is that we should support the ACPI S4 transition and
> resume, which DOES NOT MEAN that we should support ONLY that.

it has sounded like you are saying that if you support ACPI S4 sleep then 
it's incompatible with powering off.

>> and those people don't want to have the ACPI based limits.
>
> There are NO ACPI LIMITS!  There only are things that you need to implement
> if you're going to support ACPI, but they need not be used ALWAYS, no?

yes there are limits. the fact that you can't remove the battery in S4 
mode without messing things up is a limit, the fact that it's against ACPI 
specs to boot another OS before resume is a limit. you seem to keep 
pointing out requirements of ACPI that limit what can be done. I do not 
disagree about these being requirements _if you are useing ACPI_, but if 
you don't need ACPI they should not limit you.

>> they _especially_ don't want those limits when it appears as if supporting
>> those limits is what's preventing their much simpler case from working
>> reliably.
>>
>> I strongly suspect that the majority of users don't care about ACPI, they
>> want to be able to pause and resume their machine. they may want a couple
>> options for how fast the resume is (trading resume speed against how much
>> power the system eats), but the deep sleep modes (suspend-to-disk,
>> hibernate) probably have restore times that are close enough to each other
>> that very few people would care enough to opt for a ACPI S4 mode that
>> won't survive a loss of battery power over a non-ACPI mode that would.
>
> Please don't argue like that, these are not arguments for avoiding the ACPI
> support.  Arguably, you can support _both_ ACPI and non-ACPI hibernation, so
> design for being able to support both.  End of story (as far as I'm concerned).

I wish I understood how you are saying this, becouse it does not match 
what I thought I have been reading for the last few days.

David Lang
