Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXGOWtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXGOWtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXGOWsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:48:52 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51783
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXGOWsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:48:51 -0400
Date: Sun, 15 Jul 2007 15:42:10 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
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
In-Reply-To: <200707160047.28420.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707151538130.25614@asgard.lang.hm>
References: <200707151433.34625.rjw@sisk.pl> <Pine.LNX.4.64.0707151253141.25614@asgard.lang.hm>
 <200707160047.28420.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Rafael J. Wysocki wrote:

> On Sunday, 15 July 2007 22:13, david@lang.hm wrote:
>> On Sun, 15 Jul 2007, Rafael J. Wysocki wrote:
>>
>>> Hi,
>>>
>>> Since many alternative approaches to hibernation are now being considered and
>>> discussed, I thought it might be a good idea to list some things that in my not
>>> so humble opinion should be taken care of by any hibernation framework.  They
>>> are listed below, not in any particular order, because I think they all are
>>> important.  Still, I might have forgotten something, so everyone with
>>> experience in implementing hibernation, especially Pavel and Nigel, please
>>> check if the list is complete.
>>>
>>> (1) Filesystems mounted before the hibernation are untouchable
>>>
>>>    When there's a memory snapshot, either in the form of a hibernation image,
>>>    or in the form of the "old" kernel and processes available to the "new"
>>>    kexeced kernel responsible for saving their memory, the filesystems mounted
>>>    before the hibernation should not be accessed, even for reading, because
>>>    that would cause their on-disk state to be inconsistent with the snapshot
>>>    and might lead to a filesystem corruption.
>>
>> AFAIK this is only the case with ext3, all other filesystems could be
>> accessed read-only safely
>>
>> this is arguably a bug with ext3 (and has been discussed as such), but
>> right now the ext3 team has decided not to change this bahavior so
>> hibernate needs to work around it. but don't mistake a work-around for a
>> single (admittedly very popular) filesystem with a hard and fast
>> directive.
>>
>>> (2) Swap space in use before the hibernation must be handled with care
>>>
>>>    If swap space is used for saving the memory snapshot, the snapshot-saving
>>>    application (or kernel) must be careful enough not to overwrite swap pages
>>>    that contain valid memory contents stored in there before the hibernation.
>>
>> true, in fact, given that many distros and live-CD's autodetect swap
>> partitions and consider them fair game, I would argue that the best thing
>> to do would be to have the main system free up it's swap partitions before
>> going into hibernation.
>>
>> however, this could be a decision of the particular hibernate routines.
>>
>> for the kexec approach the mapping of what swap pages are in use is one
>> more chunk of data that needs to be assembled and made available through a
>> defined interface.
>>
>>> (4) The user should be able to limit the size of a hibernation image
>>>
>>>    There are a couple of reasons of that.  For example, the storage space
>>>    used for saving the image may be smaller than the entire RAM or the user
>>>    may want the image to be saved quickier.
>>
>> it may make sense for this to be split into hard and soft limits.
>>
>> if you try to save more then the storage space can hold you cannot
>> continue, but if you are just a little over the arbatrary size limit that
>> was set to make things fast you are better off saving things as-is then
>> punting, going back to the system, trying to free more ram, and trying a
>> hibernate again.
>>
>> with the kexec approach the enforcment of these limits is also split into
>> two sections.
>>
>> when the hibernate command is given in the main kernel, it's userspace
>> needs to follow some policy to decide how much (if any) memory to free.
>
> How are you going to achieve this without (a) having hibernation-aware
> user space or (b) the freezer?

the hibernate command is a userspace command, but the fact that other 
things in userspace are running at the same time is exactly why this is 
only an estimate and best-effort as I said in the paragraph below.

>> but since the kexec command and the preporation of the devices can change
>> the memory, the estimates done by the first kernel's userspace are just
>> that, estimates.
>>
>>> (7) On ACPI systems special platform-related actions have to be carried out at
>>>    the right points, so that the platform works correctly after the restore
>>>
>>>    The ACPI specification requires us to invoke some global ACPI methods
>>>    during the hibernation and during the restore.  Moreover, the ordering of
>>>    code related to these ACPI methods may not be arbitrary (eg. some of
>>>    them have to be executed after devices are put into low power states etc.).
>>
>> for a pure hibernate mode, you will be powering off the box after saving
>> the suspend image. why are there any special ACPI modes involved?
>
> Because, for example, on my machine the status of power supply (present
> vs not present) is not updated correctly after the restore if ACPI callbacks
> aren't used during the hibernation.  That's just experience and it's in line
> with the ACPI spec.

so if a machine is actually powered off the /dev/suspend process won't 
work?

remember that the system may run a different OS between the hibernate and 
the resume, makeing any assumptions about what state the hardware is in 
when you start the resume is a problem.

David Lang

>> now, for suspend-to-ram you need to be aware of every possible power
>> saving option you have and the cost of each of them, and here the ACPI
>> modes are heavily used.
>>
>> I think this is mixing suspend and hibernate still.
>
> Yes, it is, but that's not we who's mixing.  We just need to handle some
> systems built with ACPI in mind.
>
> Greetings,
> Rafael
>
>
>
