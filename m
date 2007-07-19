Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbXGSXPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbXGSXPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbXGSXPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:15:30 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34949
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765106AbXGSXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:15:27 -0400
Date: Thu, 19 Jul 2007 16:07:47 -0700 (PDT)
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
In-Reply-To: <200707192228.05136.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707191542430.28721@asgard.lang.hm>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
 <200707172320.16279.rjw@sisk.pl> <ea7a437ca4038d408ac544bbc3c2434a@bga.com>
 <200707192228.05136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Rafael J. Wysocki wrote:

> On Thursday, 19 July 2007 17:46, Milton Miller wrote:
>>
>> The currently identified problems under discussion include:
>> (1) how to interact with acpi to enter into S4.
>> (2) how to identify which memory needs to be saved
>> (3) how to communicate where to save the memory
>> (4) what state should devices be in when switching kernels
>> (5) the complicated setup required with the current patch
>> (6) what code restores the image
>
> (7) how to avoid corrupting filesystems mounted by the hibernated kernel

I didn't realize this was a discussion item. I thought the options were 
clear, for some filesystem types you can mount them read-only, but for 
ext3 (and possilby other less common ones) you just plain cannot touch 
them.

>>> (2) Upon start-up (by which I mean what happens after the user has
>>> pressed
>>>     the power button or something like that):
>>>   * check if the image is present (and valid) _without_ enabling ACPI
>>> (we don't
>>>     do that now, but I see no reason for not doing it in the new
>>> framework)
>>>   * if the image is present (and valid), load it
>>>   * turn on ACPI (unless already turned on by the BIOS, that is)
>>>   * execute the _BFS global control method
>>>   * execute the _WAK global control method
>>>   * continue
>>>   Here, the first two things should be done by the image-loading
>>> kernel, but
>>>   the remaining operations have to be carried out by the restored
>>> kernel.
>>
>> Here I agree.
>>
>> Here is my proposal.  Instead of trying to both write the image and
>> suspend, I think this all becomes much simpler if we limit the scope
>> the work of the second kernel.  Its purpose is to write the image.
>> After that its done.   The platform can be powered off if we are going
>> to S5.   However, to support suspend to ram and suspend to disk, we
>> return to the first kernel.
>
> We can't do this unless we have frozen tasks (this way, or another) before
> carrying out the entire operation.  In that case, however, the kexec-based
> approach would have only one advantage over the current one.  Namely, it
> would allow us to create bigger images.

we all agree that tasks cannot run during the suspend-to-ram state, but 
the disagreement is over what this means

at one extreme it could mean that you would need the full freezer as per 
the current suspend projects.

at the other extreme it could mean that all that's needed is to invoke the 
suspend-to-ram routine before anything else on the suspended kernel on the 
return from the save and restore kernel.

we just need to figure out which it is (or if it's somewhere in between).

>>> It's selectively stopping kernel threads, which is just about right.
>>> If you
>>> that _this_ is a main problem with the freezer, then think again.
>>>
>>>> with kexec you don't need to let any portion of the origional kernel
>>>> or
>>>> userspace operate so you don't have a problem.
>>>
>>> In fact, the main problem with the freezer is that it is a
>>> coarse-grained
>>> solution.  Therefore, what I believe we should do is to evolve in the
>>> directoin
>>> of more fine-grained solutions and gradually phase out the freezer.
>>>
>>> The kexec-based approach is an attempt to replace one coarse-grained
>>> solution
>>> (the freezer) with even more coarse-grained solution (stopping the
>>> entire
>>> kernel with everything), which IMO doesn't address the main problem.
>>>
>>
>> I think this addresses teh problem.   Its probably a bit harder than
>> powermac because we have to fully quiesce devices; we can't cheat by
>> leaving interrupts off.   But once the drivers save the state of their
>> devices and stop their queues, it should be easy to audit the paths to
>> powerdown devices and call the platform suspend and ram wakeup paths.
>>
>>
>> Going back to the requirements document that started this thread:
>>
>> Message-ID: <200707151433.34625.rjw@sisk.pl>
>> On Sun Jul 15 05:27:03 2007, Rafael J. Wysocki wrote:
>>> (1) Filesystems mounted before the hibernation are untouchable
>>
>> This is because some file systems do a fsck or other activity even when
>> mounted read only.  For the kexec case, however, this should be "file
>> systems mounted by the hibernated system must not be written".   As has
>> been mentioned in the past, we should be able to use something like dm
>> snapshot to allow fsck and the file system to see the cleaned copy
>> while not actually writing the media.
>
> We can't _require_ users to use the dm snapshot in order for the hibernation
> to work, sorry.
>
> And by _reading_ from a filesystem you generally update metadata.

not if the filesystem is mounted read-only (except on ext3)

>> The kjump kernel must not have any knowledge retained if we reuse it.
>>
>>> (2) Swap space in use before the hibernation must be handled with care
>>
>> Yes.  Actually, even though they have been used by the write-in-the
>> kernel users, they will be among the most difficult devices to use for
>> snapshots by a userspace second kernel.
>>
>>> (3) There are memory regions that must not be saved or restored
>>
>> because they may not exist.   This means that we must identify the
>> memory to be saved and restored in a format to be passed between the
>> kernel.
>>
>>> (4) The user should be able to limit the size of a hibernation image
>>
>> This means the suspending kernel must arrange to reduce its active
>> memory.  The limited save can be done by providing a limited list in
>> (3).
>
> It seems to me that you don't understand the problem here.
>
> Assume you have 90% of RAM allocated before the hibernation and the user has
> requested the image to be not greater than 50% of RAM.  In that case you have
> to free some memory _before_ identifying memory to save and you must not
> race with applications that attempt to allocate memory while you're doing it.

I disagree a little bit.

first off, only the suspending kernel can know what can be freed and what 
is needed to do so (remember this is kernel internals, it can change from 
patch to patch, let alone version to version)

second, if you have a lot of memory to free, and you can't just throw away 
caches to do so, you don't know what is going to be involved in freeing 
the memory, it's very possilbe that it is going to involve userspace, so 
you can't freeze any significant portion of the system, so you can't 
eliminate all chance of races

what you can do is

1. try to free stuff
2. stop the system and account for memory, is enough free
if not goto 1

if userspace is dirtying memory fast enough, or is just useing enough 
memory that you can't meet your limit you just won't be able to suspend.

but under any other conditions you will eventually get enough memory free.

so try several times and if you still fail tell the user they have too 
much stuff running and they need to kill something.

>>> (6) State of devices from before hibernation should be restored, if
>>> possible
>>
>> related to suspend should be transparent ... yes.
>>
>>> (7) On ACPI systems special platform-related actions have to be
>>> carried out at
>>>     the right points, so that the platform works correctly after the
>>> restore
>>
>> I believe I have explained my suggestion.
>>
>>> (8) Hibernation and restore should not be too slow
>>
>> We control the added code.   We are using full runtime drivers and will
>> run at hardware speeds.
>
> That may not be enough.  If you're going to save, say, 80% of RAM on a 2 GB
> machine, then you'll have to be using image compression.

this doesn't make sense, 20% of 2G is 400M, if you can't make a kernel and 
userspace that can run in 400M you have a serious problem.

even if you wanted to save 99% of RAM on a 2G system, you have 20M of ram 
to play with, which should easily be enough.

remember, linux runs on really small systems as well, and while you do 
have to load some drivers for the big system, there are a lot of other 
things that aren't needed.

> All in all, we have three different and working implementation of the
> image-writing and image-reading code at our disposal.  Why would you want to
> break the open doors?

becouse you say that the current methods won't work without ACPI support.

David Lang
