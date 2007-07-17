Return-Path: <linux-kernel-owner+w=401wt.eu-S933611AbXGQI7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbXGQI7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXGQI7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:59:22 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:33238 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765996AbXGQI7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:59:20 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 17 Jul 2007 14:52:22 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
In-Reply-To: <Pine.LNX.4.64.0707170306200.2005@cselinux1.cse.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0707171134540.2005@cselinux1.cse.iitk.ac.in>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in>
 <20070716204523.GJ21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707170306200.2005@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ok, last overview of this thing. ]


On Tue, 17 Jul 2007, Satyam Sharma wrote:
> On Mon, 16 Jul 2007, Al Viro wrote:
> > On Tue, Jul 17, 2007 at 01:00:42AM +0530, Satyam Sharma wrote:
> > > > 	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> > > > 
> > > > test is a rather common test, and in fact, arguably, every time you see 
> > > > one part of it, you should probably see the other. Would it make sense to 
> > > > make a helper inline function to do this, and replace all users? Doing a
> > > > 
> > > > 	git grep 'fsuid.*\<i_uid\>'
> > > > 
> > > > seems to show quite a few cases of this pattern..
> > > 
> > > Yes, I thought of writing a helper function for this myself. The semantics
> > > of CAP_FOWNER sort of justify that, but probably better to get Al's views
> > > on this first.
> > 
> > Helper makes sense (and most of these places will become its call), but...
> > E.g. IIRC the change of UID requires CAP_CHOWN; CAP_FOWNER is not enough.
> > Ditto for change of GID.


Al, you were was *spot* on here. In fact CAP_FOWNER has no role to
play in chown(2), I think.

I did try force-fitting CAP_FOWNER to this thing, and even produced
a patch, but note that bullet one and (especially) two of DESCRIPTION in
(http://www.opengroup.org/onlinepubs/009695399/functions/chown.html):

"Changing the group ID is permitted to a process with an effective user
ID equal to the user ID of the file, but without appropriate privileges,
if and only if owner is equal to the file's user ID or ( uid_t)-1 and
group is equal either to the calling process' effective group ID or to
one of its supplementary group IDs."

pretty much rules out any role for CAP_FOWNER. CAP_CHOWN is clearly
the "appropriate privileges" in question here, and force-fitting
CAP_FOWNER to "with an effective user ID equal to the user ID of the
file, but *without* appropriate privileges" sounds almost sinful.

And, the part about "group is equal either to the *calling* process'
effective group ID or to one of its supplementary group IDs" is the
last straw, as follows:

This lead to the following behaviour when I tested with that patch
(to force-fit CAP_FOWNER into this) applied: a process carrying
CAP_FOWNER (say with fsuid == userA) could change the i_gid of a file
(say owned by userB) to a supplementary group of userA (calling process)
such that userB (the original owner) may not even necessarily be a
member of that supplementary group (the new i_gid).

This looked like undesirable behaviour to me, so I decided to discard
that patch, and stick to our current behaviour which seems correct.


> > setlease() is using CAP_LEASE and that appears
> > to be intentional (no idea what relevant standards say here)...


I agree here as well, in principle. There is surprisingly little
open documentation available about CAP_LEASE, so someone might need
to check that up, but I would classify this similar to the CAP_CHOWN
case and continue to keep CAP_FOWNER out of it, as it presently is.


> > I'd suggest converting the obvious cases with new helper and taking the
> > rest one-by-one after that.  Some of those might want CAP_FOWNER added,
> > some not...
> 
> There aren't too many negative results, here's a little audit:
> 
> fs/attr.c:32:
> fs/attr.c:38:
> 
> -> Both are from inode_change_ok(). [ for chown(2) and chgrp(2) ]
> -> CAP_FOWNER is not checked for either case, I think it should be.
> -> CAP_CHOWN is anyway checked for explicitly later in that condition.


So this one was not converted.


> fs/namei.c:186: if (current->fsuid == inode->i_uid)
> 
> -> generic_permission().
> -> I wonder if CAP_FOWNER processes should ever even be calling into
>    this function in the first place (?)
> -> So best to keep CAP_FOWNER out of this condition (?)
> 
> fs/namei.c:438: if (current->fsuid == inode->i_uid)
> 
> -> exec_permission_lite().
> -> This is a clone function of the previous one, so again CAP_FOWNER
>    out of this (?)


Neither these. Seeing from capabilities(7) man page:

CAP_FOWNER
	Bypass permission checks on operations that normally require
	the file system UID of the process to match the UID of the file
	(e.g., chmod(2), utime(2)), excluding those operations covered
	by the CAP_DAC_OVERRIDE and CAP_DAC_READ_SEARCH; [...]

I think generic_permission() and exec_permission_lite() are precisely
the "operations covered by CAP_DAC_OVERRIDE and CAP_DAC_READ_SEARCH"
being mentioned here. So no modification here either.


> fs/reiserfs/ioctl.c:54:
> fs/xattr.c:63:
> -> False positives, CAP_FOWNER checked on line below.
> -> Helper would help for both cases.


Another thing: I relaxed the grep regexp there a bit and caught a couple
more users in XFS. After some trying-to-audit the 5000-line files
containing 1000-line functions using non-standard inode structures and
weird macros, I can vouch that the the ownership / permission checks
there are just fine :-)

So, to summarize: the do_utimes() change was the only problematic point
in the kernel. All other points that _exclude_ a capable(CAP_FOWNER) check
do so for good reasons.


> Anwyay, so I'm thinking of adding:
> 
> struct inode;
> 
> int is_not_owner(struct inode *)
> {
> 	return ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER));
> }
> 
> to linux/capability.h inside the __KERNEL__ #ifdef, asm/current.h is
> included in there already.

On second thoughts, I decided it was much more tasteful to keep this
function in include/linux/fs.h. This also meant we have a macro now,
and not an inline function (sadly) because of header file issues that
caused build breakage. I could've avoided the breakage by #include'ing
sched.h from fs.h, but decided against it. (Probably explains why
get_fs_excl() and friends are also macros and not inline functions in
that file.)

Also, named it "is_owner_or_cap(inode)". Patch follows next.

Satyam
