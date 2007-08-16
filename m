Return-Path: <linux-kernel-owner+w=401wt.eu-S1763345AbXHPPJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763345AbXHPPJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbXHPPJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:09:11 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:19507 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754367AbXHPPJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:09:09 -0400
Message-ID: <46C4689C.8020702@cfl.rr.com>
Date: Thu, 16 Aug 2007 11:09:16 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com>
In-Reply-To: <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Aug 2007 15:09:18.0015 (UTC) FILETIME=[6A91ACF0:01C7E017]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15366.000
X-TM-AS-Result: No--6.433700-5.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Let me repeat myself here:  Algorithmically you fundamentally CANNOT 
> implement inheritance-based ACLs without one of the following (although 
> if you have some other algorithm in mind, I'm listening):
>   (A) Some kind of recursive operation *every* time you change an 
> inheritable permission
>   (B) A unified "starting point" from which you begin *every* 
> access-control lookup (or one "starting point" per useful semantic 
> grouping, like a namespace).
> 
> The "(A)" is presently done in userspace and that's what you want to 
> avoid.  As to (B), I will attempt to prove below that you cannot 
> implement "(B)" without breaking existing assumptions and restricting a 
> very nice VFS model.

No recursion is needed because only one acl exists, so that is the only 
one you need to update.  At least on disk.  Any cached acls in memory of 
descendant objects would need updated, but the number of those should be 
relatively small.  The starting point would be the directory you start 
the lookup from.  That may be the root, or it may be some other 
directory that you have a handle to, and thus, already has its effective 
acl computed.

> What ACL would "task->cwd" use?
> 
> Options:
> (1.a) Use the one calculated during the original chdir() call.
> (1.b) Navigate "up" task->cwd building an ACL backwards.
> (1.c) $CAN_YOU_THINK_OF_SOMETHING_ELSE_HERE

1.a

> Unsolvable problems with each option:
> 
> (1.a.I)
> You just broke all sorts of chrooted daemons.  When I start bind in its 
> chroot jail, it does the following:
>   chdir("/private/bind9");
>   chroot(".");
>   setgid(...);
>   setuid(...);
> The "/private" directory is readable only by root, since root is the 
> only one who will be navigating you into these chroots for any reason.  
> You only switch UID/GID after the chroot() call, at which point you are 
> inside of a sub-context and your cwd is fully accessible.  If you stick 
> an inheritable ACL on "/private", then the "cwd" ACL will not allow 
> access by anybody but root and my bind won't be able to read any config 
> files.

If you want the directory to be root accessible but the files inside to 
have wider access then you set the acl on the directory to have one ace 
granting root access to the directory, and one ace that is inheritable 
granting access to bind.  This latter ace does not apply to the 
directory itself, only to its children.

> You also break relative paths and directory-moving.  Say a process does 
> chdir("/foo/bar").  Now the ACL data in "cwd" is appropriate for 
> /foo/bar.  If you later chdir("../quux"), how do you unapply the changes 
> made when you switched into that directory?  For inheritable ACLs, you 
> can't "unapply" such an ACL state change unless you save state for all 
> the parent directories, except...  What happens when you are in 
> "/foo/bar" and another process does "mv /foo/bar /foobar/quux"?  
> Suddenly any "cwd" ACL data you have is completely invalid and you have 
> to rebuild your ACLs from scratch.  Moreover, if the directory you are 
> in was moved to a portion of the filesystem not accessible from your 
> current namespace then how do you deal with it?

Yes, if /foo/quux is not already cached in memory, you would have to 
walk the tree to build its acl.  /foo should already be cached in memory 
so this work is minimal.  Is this so horrible of a problem?

As for moving, it is handled the same way as any other event that makes 
cwd go away, such as deleting it or revoking your access; cwd is now 
invalid.

> For example:
> NS1 has the / root dir of /dev/sdb1 mounted on /mnt
> NS2 has the /bar subdir of /dev/sdb1 mounted on /mnt
> 
> Your process is in NS2 and does chdir("/mnt/quux").  A user in NS1 does: 
> "mv /mnt/bar/quux /mnt/quux".  Now your "cwd" is in a directory on a 
> filesystem you have mounted, but it does not correspond *AT ALL* to any 
> path available from your namespace.

Which would be no different than if they just deleted the entire thing. 
  Your cwd no longer exists.

> Another example:
> Your process has done dirfd=open("/media/cdrom/somestuff") when the 
> admin does "umount -l /media/cdrom".  You still have the CD-ROM open and 
> accessible but IT HAS NO PATH.  It isn't even mounted in *any* 
> namespace, it's just kind of dangling waiting for its last users to go 
> away.  You can still do fchdir(dirfd), openat(dirfd, "foo/bar", ...), 
> open("./foo"), etc.

What's this got to do with acls?  If you are asking what effect the 
umount thas on the acls of the cdrom, the answer is none.  The acls are 
on the disc and nothing on the disc has changed.

> No, this is correct because in the root directory "/", the ".." entry is 
> just another link to the root directory.  So the absolute path 
> "/../../../../../.." is just a fancy name for the root directory.  The 
> above jail-escape-as-root exploit is possible because it is impossible 
> to determine whether a directory is or is not a subentry of another 
> directory without an exhaustive search.  So when your "cwd" points to a 
> path outside of the chroot, the one special case in the code for the 
> "root" directory does not ever match and you can "chdir" all the way up 
> to the real root.  You can even do an fstat() after every iteration to 
> figure out whether you're there or not!

Ohh, I see... yes... that is a very clever way for root to misuse 
chroot().  What does it have to do with this discussion?

> And yes, this has been exploited before, although not often as 
> chroot()-ed uid=0 daemons aren't all that common.
> 
> So, pray tell, when this code runs and you do the "chroot" call, what 
> ACL do you think should get stuck on "cwd"?  It doesn't reference 
> anything available relative to the chroot.

Same root abuse, same result.  The acl on the cwd would still be exactly 
what it was before the chroot.

> With this you just got into the big-ugly-nasty-recursive-behavior 
> again.  Say I untar 20 kernel source trees and then have my program open 
> all 1000 available FDs to various directories in the kernel source 
> tree.  Now I run 20 copies of this program, one for each tree, still 
> well within my ulimits even on a conservative box.  Now run "mv 
> dir_full_of_kernel_sources some/new/dir".  The only thing you can do to 
> find all of the FDs is to iterate down the entire subdirectory tree 
> looking for open files and updating their contexts one-by-one.  Except 
> you have 20,000 directory FDs to update.  Ouch.

Ok, so you found a pedantic corner case that is slow.  So?  And it is 
still going to be faster than chmod -R.

> To sum up, when doing access control the only values you can safely and 
> efficiently get at are:
> (A)  The dentry/inode
> (B)  The superblock
> (C)  *Maybe* the vfsmount if those patches get accepted
> 
> Any access control model which tries to poke other values is just going 
> to have a shitload of corner cases where it just falls over.

If by falls over you mean takes some time, then yes.... so what?

