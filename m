Return-Path: <linux-kernel-owner+w=401wt.eu-S935416AbXGTRKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416AbXGTRKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935526AbXGTRJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:09:24 -0400
Received: from mercury.realtime.net ([205.238.132.86]:34931 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935303AbXGTRJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:09:21 -0400
In-Reply-To: <200707201317.58025.rjw@sisk.pl>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <200707192228.05136.rjw@sisk.pl> <Pine.LNX.4.64.0707191542430.28721@asgard.lang.hm> <200707201317.58025.rjw@sisk.pl>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f29402c6050f9c3ff5d83a59cea2de58@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Ying Huang <ying.huang@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Fri, 20 Jul 2007 11:56:43 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 20, 2007, at 6:17 AM, Rafael J. Wysocki wrote:
> On Friday, 20 July 2007 01:07, david@lang.hm wrote:
>> On Thu, 19 Jul 2007, Rafael J. Wysocki wrote:
>>> On Thursday, 19 July 2007 17:46, Milton Miller wrote:
>>>> The currently identified problems under discussion include:
>>>> (1) how to interact with acpi to enter into S4.
>>>> (2) how to identify which memory needs to be saved
>>>> (3) how to communicate where to save the memory
>>>> (4) what state should devices be in when switching kernels
>>>> (5) the complicated setup required with the current patch
>>>> (6) what code restores the image
>>>
>>> (7) how to avoid corrupting filesystems mounted by the hibernated 
>>> kernel
>>
>> I didn't realize this was a discussion item. I thought the options 
>> were
>> clear, for some filesystem types you can mount them read-only, but for
>> ext3 (and possilby other less common ones) you just plain cannot touch
>> them.
>
> That's correct.  And since you cannot thouch ext3, you need either to 
> assume
> that you won't touch filesystems at all, or to have a code to 
> recognize the
> filesystem you're dealing with.

Or add a small bit of infrastructure that errors writes at make_request 
if you don't have a magic "i am a direct block device write from 
userspace" flag on the bio.

The hibernate may fail, but you don't corrupt the media.

If you don't get the image out, resume back to the "this is resume" 
instead of the power-down path.

>>>>> (2) Upon start-up (by which I mean what happens after the user has
>>>>> pressed
>>>>>     the power button or something like that):
>>>>>   * check if the image is present (and valid) _without_ enabling 
>>>>> ACPI
>>>>> (we don't
>>>>>     do that now, but I see no reason for not doing it in the new
>>>>> framework)
>>>>>   * if the image is present (and valid), load it
>>>>>   * turn on ACPI (unless already turned on by the BIOS, that is)
>>>>>   * execute the _BFS global control method
>>>>>   * execute the _WAK global control method
>>>>>   * continue
>>>>>   Here, the first two things should be done by the image-loading
>>>>> kernel, but
>>>>>   the remaining operations have to be carried out by the restored
>>>>> kernel.
>>>>
>>>> Here I agree.
>>>>
>>>> Here is my proposal.  Instead of trying to both write the image and
>>>> suspend, I think this all becomes much simpler if we limit the scope
>>>> the work of the second kernel.  Its purpose is to write the image.
>>>> After that its done.   The platform can be powered off if we are 
>>>> going
>>>> to S5.   However, to support suspend to ram and suspend to disk, we
>>>> return to the first kernel.
>>>
>>> We can't do this unless we have frozen tasks (this way, or another) 
>>> before
>>> carrying out the entire operation.  In that case, however, the 
>>> kexec-based
>>> approach would have only one advantage over the current one.  
>>> Namely, it
>>> would allow us to create bigger images.
>>
>> we all agree that tasks cannot run during the suspend-to-ram state, 
>> but
>> the disagreement is over what this means
>>
>> at one extreme it could mean that you would need the full freezer as 
>> per
>> the current suspend projects.
>>
>> at the other extreme it could mean that all that's needed is to 
>> invoke the
>> suspend-to-ram routine before anything else on the suspended kernel 
>> on the
>> return from the save and restore kernel.
>>
>> we just need to figure out which it is (or if it's somewhere in 
>> between).
>
> Well, I think that the "invoke the suspend-to-ram routine before 
> anything else
> on the suspended kernel" thing won't be easy to implement in practice.

Why?  You don't expect suspend-to-ram in drivers to be implemented?  We 
need more speperation of the quiesce drivers from power-down devices?

Note that we are just talking about "suspend devices and put their 
state in ram", not actually invoking the platform to suspend to ram.

And I'm actually saying we free memory and maybe allocate disk blocks 
for the save before we suspend (see below).

>>>> Message-ID: <200707151433.34625.rjw@sisk.pl>
>>>> On Sun Jul 15 05:27:03 2007, Rafael J. Wysocki wrote:
>>>>> (1) Filesystems mounted before the hibernation are untouchable
>>>>
>>>> This is because some file systems do a fsck or other activity even 
>>>> when
>>>> mounted read only.  For the kexec case, however, this should be 
>>>> "file
>>>> systems mounted by the hibernated system must not be written".   As 
>>>> has
>>>> been mentioned in the past, we should be able to use something like 
>>>> dm
>>>> snapshot to allow fsck and the file system to see the cleaned copy
>>>> while not actually writing the media.
>>>
>>> We can't _require_ users to use the dm snapshot in order for the 
>>> hibernation
>>> to work, sorry.
>>>
>>> And by _reading_ from a filesystem you generally update metadata.
>>
>> not if the filesystem is mounted read-only (except on ext3)
>
> Well, if the filesystem in question is a journaling one and the 
> hibernated
> kernel has mounted this fs read-write, this seems to be tricky anyway.

Yes.  I would argue writing to existing blocks of a file (not thorugh 
the filesystem, just getting their blocsk from the file system) should 
be safe, but it occurs to me that may not be the case if your fsck and 
bmap move data blocks from some update log to the file system.

But we know the (maximum) image size.   So we could allocate the blocks 
in the first image before suspending the drivers and memory 
allocations, and supplying the list to the second kernel.  We could 
even write to the first block with a signature "suspend to here", or 
even the whole block list to the beginning (it will have to be saved to 
disk for restore anyways).

>>>> The kjump kernel must not have any knowledge retained if we reuse 
>>>> it.
>>>>
>>>>> (2) Swap space in use before the hibernation must be handled with 
>>>>> care
>>>>
>>>> Yes.  Actually, even though they have been used by the write-in-the
>>>> kernel users, they will be among the most difficult devices to use 
>>>> for
>>>> snapshots by a userspace second kernel.

If we use the "write to these blocks" then this is as easy as writing 
to a file in a mounted filesystem.

>>>>> (4) The user should be able to limit the size of a hibernation 
>>>>> image
>>>>
>>>> This means the suspending kernel must arrange to reduce its active
>>>> memory.  The limited save can be done by providing a limited list in
>>>> (3).
>>>
>>> It seems to me that you don't understand the problem here.
>>>
>>> Assume you have 90% of RAM allocated before the hibernation and the 
>>> user has
>>> requested the image to be not greater than 50% of RAM.  In that case 
>>> you have
>>> to free some memory _before_ identifying memory to save and you must 
>>> not
>>> race with applications that attempt to allocate memory while you're 
>>> doing it.
>>
>> I disagree a little bit.
>>
>> first off, only the suspending kernel can know what can be freed and 
>> what
>> is needed to do so (remember this is kernel internals, it can change 
>> from
>> patch to patch, let alone version to version)
>>
>> second, if you have a lot of memory to free, and you can't just throw 
>> away
>> caches to do so, you don't know what is going to be involved in 
>> freeing
>> the memory, it's very possilbe that it is going to involve userspace, 
>> so
>> you can't freeze any significant portion of the system, so you can't
>> eliminate all chance of races
>>
>> what you can do is
>>
>> 1. try to free stuff
>> 2. stop the system and account for memory, is enough free
>> if not goto 1
>>
>> if userspace is dirtying memory fast enough, or is just useing enough
>> memory that you can't meet your limit you just won't be able to 
>> suspend.
>
> This means unreliable hibernation for some workloads.  While I agree 
> that
> shouldn't be a problem in a common case, there are users who will 
> complain. ;-)

With my allocate memory as a task and don't save that task's memory 
approach, we can get to this point while userspace is running.   It 
could be controllled by userspace, or even be userspace 
(sys_do_not_save_me() waits for resume, and dies as the kernel 
resumes).

>> but under any other conditions you will eventually get enough memory 
>> free.
>>
>> so try several times and if you still fail tell the user they have too
>> much stuff running and they need to kill something.
>
> Well, with the freezer that's much simpler (and more reliable, I'd 
> say): you
> freeze tasks and _then_ you shrink memory.

It means you are committed to suspend before you try to shrink memory.  
What happens when the user requested a smaller image that memory in 
use?

>>>>> =(8) Hibernation and restore should not be too slow
>>>>
>>>> We control the added code.   We are using full runtime drivers and 
>>>> will
>>>> run at hardware speeds.
>>>
>>> That may not be enough.  If you're going to save, say, 80% of RAM on 
>>> a 2 GB
>>> machine, then you'll have to be using image compression.
>>
>> this doesn't make sense, 20% of 2G is 400M, if you can't make a 
>> kernel and
>> userspace that can run in 400M you have a serious problem.
>
> I was talking about the _speed_ of writing and reading.

Yes.  As I said, adding a compress as we copy the pages into the saving 
kernel for writeout should be easy.

>> even if you wanted to save 99% of RAM on a 2G system, you have 20M of 
>> ram
>> to play with, which should easily be enough.
>>
>> remember, linux runs on really small systems as well, and while you do
>> have to load some drivers for the big system, there are a lot of other
>> things that aren't needed.
>>
>>> All in all, we have three different and working implementation of the
>>> image-writing and image-reading code at our disposal.  Why would you 
>>> want to
>>> break the open doors?
>>
>> becouse you say that the current methods won't work without ACPI 
>> support.
>
> I didn't say that.  [Or if I did, please point me to this message.]
>
> Anyway, this wouldn't be true even if I did.
>
> What I've been trying to say from the very beginning is that the 
> current
> frameworks _support_ hibernation a la ACPI S4 (although that's not 
> exactly
> ACPI S4) and if we are going to introduce a new framework, then it 
> should
> be designed to _support_ ACPI S4 fully _from_ _the_ _start_.
>
> This DOESN'T mean that the non-ACPI hibernation should be unsupported 
> and
> it DOESN"T mean that the non-ACPI hibernation is not supported 
> currently.
> IT IS SUPPORTED.
>

As I said, I see kjump as a way to solve the "ok i am at a save point, 
now how do I write this image to media without allowing any other io".  
As you know by now, my solution for ACPI support is after the image is 
written we go back to the kernel that started the suspend and it puts 
the machine in S4.

If this works, we get down to 1 hibernate implementation in the kernel 
:-).

milton

