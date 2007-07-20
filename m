Return-Path: <linux-kernel-owner+w=401wt.eu-S937852AbXGTPoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937852AbXGTPoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761865AbXGTPn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:43:56 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:47956
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbXGTPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:43:55 -0400
Date: Fri, 20 Jul 2007 08:35:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Milton Miller <miltonm@bga.com>,
       linux-pm <linux-pm@lists.linuxfoundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707201317.58025.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707200746491.19248@asgard.lang.hm>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
 <200707192228.05136.rjw@sisk.pl> <Pine.LNX.4.64.0707191542430.28721@asgard.lang.hm>
 <200707201317.58025.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Rafael J. Wysocki wrote:

> On Friday, 20 July 2007 01:07, david@lang.hm wrote:
>> On Thu, 19 Jul 2007, Rafael J. Wysocki wrote:
>>
>>> On Thursday, 19 July 2007 17:46, Milton Miller wrote:
>>>>
>>>> The currently identified problems under discussion include:
>>>> (1) how to interact with acpi to enter into S4.
>>>> (2) how to identify which memory needs to be saved
>>>> (3) how to communicate where to save the memory
>>>> (4) what state should devices be in when switching kernels
>>>> (5) the complicated setup required with the current patch
>>>> (6) what code restores the image
>>>
>>> (7) how to avoid corrupting filesystems mounted by the hibernated kernel
>>
>> I didn't realize this was a discussion item. I thought the options were
>> clear, for some filesystem types you can mount them read-only, but for
>> ext3 (and possilby other less common ones) you just plain cannot touch
>> them.
>
> That's correct.  And since you cannot thouch ext3, you need either to assume
> that you won't touch filesystems at all, or to have a code to recognize the
> filesystem you're dealing with.

filesystem detection routines are already available

however, I'm the type to say that in a case like this where it matters you 
should explicitly give the filesystem type anyway.

or the userspace helper functions that setup the instructions for the 
hibernate warn you if you are telling it to mount a filesystem that it 
knows is ext3 and is in use by the system going to sleep.

in any case there needs to be a big warning about this issue, but that's 
different from saying "can't touch any filesystem that was mounted"


>> but under any other conditions you will eventually get enough memory free.
>>
>> so try several times and if you still fail tell the user they have too
>> much stuff running and they need to kill something.
>
> Well, with the freezer that's much simpler (and more reliable, I'd say): you
> freeze tasks and _then_ you shrink memory.

this only works if you don't need tasks to do anything to free the memory.

>>>>> (6) State of devices from before hibernation should be restored, if
>>>>> possible
>>>>
>>>> related to suspend should be transparent ... yes.
>>>>
>>>>> (7) On ACPI systems special platform-related actions have to be
>>>>> carried out at
>>>>>     the right points, so that the platform works correctly after the
>>>>> restore
>>>>
>>>> I believe I have explained my suggestion.
>>>>
>>>>> (8) Hibernation and restore should not be too slow
>>>>
>>>> We control the added code.   We are using full runtime drivers and will
>>>> run at hardware speeds.
>>>
>>> That may not be enough.  If you're going to save, say, 80% of RAM on a 2 GB
>>> machine, then you'll have to be using image compression.
>>
>> this doesn't make sense, 20% of 2G is 400M, if you can't make a kernel and
>> userspace that can run in 400M you have a serious problem.
>
> I was talking about the _speed_ of writing and reading.

if you are just talking about the I/O time for writing 2G of data, I 
wouldn't worry about it. suspend isn't supposed to change the capabilities 
of the system. if it takes a long time to do the I/O then that's how long 
it takes.

being able to do compression or send the data elsewhere is a good thing, 
but that's not something that is required to be supported in order to meet 
some performance goal or consider the approach a failure.

>>> All in all, we have three different and working implementation of the
>>> image-writing and image-reading code at our disposal.  Why would you want to
>>> break the open doors?
>>
>> becouse you say that the current methods won't work without ACPI support.
>
> I didn't say that.  [Or if I did, please point me to this message.]

I may have misunderstood you (I have deleted 90% of the messages in this 
thread so I won't try to go back and find where I thought you said this)

> Anyway, this wouldn't be true even if I did.
>
> What I've been trying to say from the very beginning is that the current
> frameworks _support_ hibernation a la ACPI S4 (although that's not exactly
> ACPI S4) and if we are going to introduce a new framework, then it should
> be designed to _support_ ACPI S4 fully _from_ _the_ _start_.

here is where there is some disagreement (although it may just be 
misunderstanding on the 'fully support' phrase)

it sounds like you are saying that the ACPI support requires a lot of work 
(the phrase I've seen some people use is a requirement to 'fix all the 
drivers'). we aren't wanting to have this work prevent the non-ACPI 
hibernation from progressing.

this isn't that we don't want the ACPI support eventually, it's in the 
spirit of 'perfection is the enemy of good enough'

David Lang

> This DOESN'T mean that the non-ACPI hibernation should be unsupported and
> it DOESN"T mean that the non-ACPI hibernation is not supported currently.
> IT IS SUPPORTED.
