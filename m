Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXGTTfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXGTTfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbXGTTfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:35:05 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57998
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742AbXGTTfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:35:02 -0400
Date: Fri, 20 Jul 2007 12:26:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Milton Miller <miltonm@bga.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <f29402c6050f9c3ff5d83a59cea2de58@bga.com>
Message-ID: <Pine.LNX.4.64.0707201219260.5166@asgard.lang.hm>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
 <200707192228.05136.rjw@sisk.pl> <Pine.LNX.4.64.0707191542430.28721@asgard.lang.hm>
 <200707201317.58025.rjw@sisk.pl> <f29402c6050f9c3ff5d83a59cea2de58@bga.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Milton Miller wrote:

> On Jul 20, 2007, at 6:17 AM, Rafael J. Wysocki wrote:
>>  On Friday, 20 July 2007 01:07, david@lang.hm wrote:
>> >  On Thu, 19 Jul 2007, Rafael J. Wysocki wrote:
>> > >  On Thursday, 19 July 2007 17:46, Milton Miller wrote:
>> > > >  The currently identified problems under discussion include:
>> > > >  (1) how to interact with acpi to enter into S4.
>> > > >  (2) how to identify which memory needs to be saved
>> > > >  (3) how to communicate where to save the memory
>> > > >  (4) what state should devices be in when switching kernels
>> > > >  (5) the complicated setup required with the current patch
>> > > >  (6) what code restores the image
>> > > 
>> > >  (7) how to avoid corrupting filesystems mounted by the hibernated 
>> > >  kernel
>> > 
>> >  I didn't realize this was a discussion item. I thought the options were
>> >  clear, for some filesystem types you can mount them read-only, but for
>> >  ext3 (and possilby other less common ones) you just plain cannot touch
>> >  them.
>>
>>  That's correct.  And since you cannot thouch ext3, you need either to
>>  assume
>>  that you won't touch filesystems at all, or to have a code to recognize
>>  the
>>  filesystem you're dealing with.
>
> Or add a small bit of infrastructure that errors writes at make_request if 
> you don't have a magic "i am a direct block device write from userspace" flag 
> on the bio.

the problem is that the filesystem code will replay the journal when you 
mount the partition, even if you mount it read-only (I seem to remember 
that you could avoid this if you put the entire block device into 
read-only mode, but that doesn't help in this case)

> The hibernate may fail, but you don't corrupt the media.
>
> If you don't get the image out, resume back to the "this is resume" instead 
> of the power-down path.
>
>> > > > >  (2) Upon start-up (by which I mean what happens after the user has
>> > > > >  pressed
>> > > > >      the power button or something like that):
>> > > > >    * check if the image is present (and valid) _without_ enabling 
>> > > > >  ACPI
>> > > > >  (we don't
>> > > > >      do that now, but I see no reason for not doing it in the new
>> > > > >  framework)
>> > > > >    * if the image is present (and valid), load it
>> > > > >    * turn on ACPI (unless already turned on by the BIOS, that is)
>> > > > >    * execute the _BFS global control method
>> > > > >    * execute the _WAK global control method
>> > > > >    * continue
>> > > > >    Here, the first two things should be done by the image-loading
>> > > > >  kernel, but
>> > > > >    the remaining operations have to be carried out by the restored
>> > > > >  kernel.
>> > > > 
>> > > >  Here I agree.
>> > > > 
>> > > >  Here is my proposal.  Instead of trying to both write the image and
>> > > >  suspend, I think this all becomes much simpler if we limit the scope
>> > > >  the work of the second kernel.  Its purpose is to write the image.
>> > > >  After that its done.   The platform can be powered off if we are 
>> > > >  going
>> > > >  to S5.   However, to support suspend to ram and suspend to disk, we
>> > > >  return to the first kernel.
>> > > 
>> > >  We can't do this unless we have frozen tasks (this way, or another) 
>> > >  before
>> > >  carrying out the entire operation.  In that case, however, the 
>> > >  kexec-based
>> > >  approach would have only one advantage over the current one.  Namely, 
>> > >  it
>> > >  would allow us to create bigger images.
>> > 
>> >  we all agree that tasks cannot run during the suspend-to-ram state, but
>> >  the disagreement is over what this means
>> > 
>> >  at one extreme it could mean that you would need the full freezer as per
>> >  the current suspend projects.
>> > 
>> >  at the other extreme it could mean that all that's needed is to invoke 
>> >  the
>> >  suspend-to-ram routine before anything else on the suspended kernel on 
>> >  the
>> >  return from the save and restore kernel.
>> > 
>> >  we just need to figure out which it is (or if it's somewhere in 
>> >  between).
>>
>>  Well, I think that the "invoke the suspend-to-ram routine before anything
>>  else
>>  on the suspended kernel" thing won't be easy to implement in practice.
>
> Why?  You don't expect suspend-to-ram in drivers to be implemented?  We need 
> more speperation of the quiesce drivers from power-down devices?
>
> Note that we are just talking about "suspend devices and put their state in 
> ram", not actually invoking the platform to suspend to ram.

I thought we were talking about actually invoking the suspend-to-ram

>> > > >  Message-ID: <200707151433.34625.rjw@sisk.pl>
>> > > >  On Sun Jul 15 05:27:03 2007, Rafael J. Wysocki wrote:
>> > > > >  (1) Filesystems mounted before the hibernation are untouchable
>> > > > 
>> > > >  This is because some file systems do a fsck or other activity even 
>> > > >  when
>> > > >  mounted read only.  For the kexec case, however, this should be 
>> > > >  "file
>> > > >  systems mounted by the hibernated system must not be written".   As 
>> > > >  has
>> > > >  been mentioned in the past, we should be able to use something like 
>> > > >  dm
>> > > >  snapshot to allow fsck and the file system to see the cleaned copy
>> > > >  while not actually writing the media.
>> > > 
>> > >  We can't _require_ users to use the dm snapshot in order for the 
>> > >  hibernation
>> > >  to work, sorry.
>> > > 
>> > >  And by _reading_ from a filesystem you generally update metadata.
>> > 
>> >  not if the filesystem is mounted read-only (except on ext3)
>>
>>  Well, if the filesystem in question is a journaling one and the hibernated
>>  kernel has mounted this fs read-write, this seems to be tricky anyway.
>
> Yes.  I would argue writing to existing blocks of a file (not thorugh the 
> filesystem, just getting their blocsk from the file system) should be safe, 
> but it occurs to me that may not be the case if your fsck and bmap move data 
> blocks from some update log to the file system.

right, and the answer is that the filesystem blocks allocated for the 
suspend image are not allowed to be accessed in any way from the main 
system.

this is a good argument for saving the data somewhere else ;-)

> But we know the (maximum) image size.   So we could allocate the blocks in 
> the first image before suspending the drivers and memory allocations, and 
> supplying the list to the second kernel.  We could even write to the first 
> block with a signature "suspend to here", or even the whole block list to the 
> beginning (it will have to be saved to disk for restore anyways).

no, you want to make the blocks that are allocated for the suspend image 
be like the blocks allocated to the journal, alloate them once and never 
touch them again

you especially do not want to try and write something to them from the 
main system just before suspending, you don't know enough about what it 
takes to get the data to the media to be absolutly sure that it's there 
when the save-and-restore kernel goes to look.

>> > > >  The kjump kernel must not have any knowledge retained if we reuse 
>> > > >  it.
>> > > > 
>> > > > >  (2) Swap space in use before the hibernation must be handled with 
>> > > > >  care
>> > > > 
>> > > >  Yes.  Actually, even though they have been used by the write-in-the
>> > > >  kernel users, they will be among the most difficult devices to use 
>> > > >  for
>> > > >  snapshots by a userspace second kernel.
>
> If we use the "write to these blocks" then this is as easy as writing to a 
> file in a mounted filesystem.

and keep in mind that "write to these blocks" can be done in userspace, it 
doesn't require the kernel to do this.

David Lang
