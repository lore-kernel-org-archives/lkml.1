Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbXHPXSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbXHPXSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXHPXSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:18:01 -0400
Received: from smtpout.mac.com ([17.250.248.175]:63056 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbXHPXR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:17:59 -0400
In-Reply-To: <46C4689C.8020702@cfl.rr.com>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com> <46C4689C.8020702@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5D526964-3F46-4B6D-A12A-437A7EF5E0D8@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Thu, 16 Aug 2007 19:17:47 -0400
To: Phillip Susi <psusi@cfl.rr.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 16, 2007, at 11:09:16, Phillip Susi wrote:
> Kyle Moffett wrote:
>> Let me repeat myself here:  Algorithmically you fundamentally  
>> CANNOT implement inheritance-based ACLs without one of the  
>> following (although if you have some other algorithm in mind, I'm  
>> listening):
>>   (A) Some kind of recursive operation *every* time you change an  
>> inheritable permission
>>   (B) A unified "starting point" from which you begin *every*  
>> access-control lookup (or one "starting point" per useful semantic  
>> grouping, like a namespace).
>> The "(A)" is presently done in userspace and that's what you want  
>> to avoid.  As to (B), I will attempt to prove below that you  
>> cannot implement "(B)" without breaking existing assumptions and  
>> restricting a very nice VFS model.
>
> No recursion is needed because only one acl exists, so that is the  
> only one you need to update.  At least on disk.  Any cached acls in  
> memory of descendant objects would need updated, but the number of  
> those should be relatively small.  The starting point would be the  
> directory you start the lookup from.  That may be the root, or it  
> may be some other directory that you have a handle to, and thus,  
> already has its effective acl computed.

Problem 1: "updating cached acls of descendent objects":  How do you  
find out what a 'descendent object' is?  Answer:  You can't without  
recursing through the entire in-memory dentry tree.  Such recursion  
is lock-intensive and has poor performance.  Furthermore, you have to  
do the entire recursion as an atomic operation; other cross-directory  
renames or ACL changes would invalidate your results halfway through  
and cause race conditions.

Oh, and by the way, the kernel has no real way to go from a dentry to  
a (process, fd) pair.  That data simply is not maintained because it  
is unnecessary and inefficent to do so.  Without that data you  
*can't* determine what is "dependent".  Furthermore, even if you  
could it still wouldn't work because you can't even tell which path  
the file was originally opened via.  Say you run:
   mount --bind /mnt/cdrom /cdrom
   umount /mnt/cdrom

Now any process which had a cwd or open directory handle in "/cdrom"  
is STILL USING THE ACLs from when it was mounted as "/mnt/cdrom".  If  
you have the same volume bind-mounted in two places you can't easily  
distinguish between them.  Caching permission data at the vfsmount  
won't even help you because you can move around vfsmounts as long as  
they are in subdirectories:
   mkdir -p /a/b/foo
   mount -t tmpfs tmpfs /a/b/foo
   mv /a/b /quux
   umount /quux/foo

At this point you would also have to look at vfsmounts during your  
recursive traversal and update their cached ACLs too.

Problem 2:  "Some other directory that you have a handle to":  When  
you are given this relative path and this cwd ACL, how do you  
determine the total ACL of the parent directory:
path: ../foo/bar
cached cwd total-ACL:
   root rwx (inheritable)
   bob rwx (inheritable)
   somegroup rwx (inheritable)
   jane rwx
".." partial-ACL
   root +rwx (inheritable)
   somegroup +rx (inheritable)

Answer:  you can't.  For example, if "/" had the permission 'root  
+rwx (inheritable)', and nothing else had subtractive permissions,  
then the "root +rwx (inheritable)" in the parent dir would be a no- 
op, but you can't tell that without storing a complete parent  
directory history.

Now assume that I "mkdir /foo && set-some-inheritable-acl-on /foo &&  
mv /home /foo/home".  Say I'm running all sorts of X apps and GIT and  
a number of other programs and have some conservative 5k FDs open on / 
home.  This is actually something I've done before (without the  
ACLs), albeit accidentally.  With your proposal, the kernel would  
first have to identify all of the thousands of FDs with cached ACL  
data across a very large cache-hot /home directory.  For each FD, it  
would have to store an updated copy of the partial-ACL states down  
its entire path.  Oh, and you can't do any other ACL or rename  
operations in the entire subtree while this is going on, because that  
would lead to the first update reporting incorrect results and racing  
with the second.  You are also extremely slow, deadlock-prone, and  
memory hungry, since you have to take an enormous pile of dentry  
locks while doing the recursion.  Nobody can even open files with  
relative paths while this is going on because the cached ACLs are in  
an intermediate and inconsistent state: they're updated but the  
directory isn't in its new position yet.

>> Unsolvable problems with each option:
>> (1.a.I)
>> You just broke all sorts of chrooted daemons.  When I start bind  
>> in its chroot jail, it does the following:
>>   chdir("/private/bind9");
>>   chroot(".");
>>   setgid(...);
>>   setuid(...);
>> The "/private" directory is readable only by root, since root is  
>> the only one who will be navigating you into these chroots for any  
>> reason.  You only switch UID/GID after the chroot() call, at which  
>> point you are inside of a sub-context and your cwd is fully  
>> accessible.  If you stick an inheritable ACL on "/private", then  
>> the "cwd" ACL will not allow access by anybody but root and my  
>> bind won't be able to read any config files.
>
> If you want the directory to be root accessible but the files  
> inside to have wider access then you set the acl on the directory  
> to have one ace granting root access to the directory, and one ace  
> that is inheritable granting access to bind.  This latter ace does  
> not apply to the directory itself, only to its children.

This is completely opposite the way that permissions currently  
operate in Linux.  When I am chrooted, I don't care about the  
permissions of *anything* outside of the chroot, because it simply  
doesn't exist.  Furthermore you still don't answer the "computing ACL  
of parent directory requires lots of space" problem.


>> You also break relative paths and directory-moving.  Say a process  
>> does chdir("/foo/bar").  Now the ACL data in "cwd" is appropriate  
>> for /foo/bar.  If you later chdir("../quux"), how do you unapply  
>> the changes made when you switched into that directory?  For  
>> inheritable ACLs, you can't "unapply" such an ACL state change  
>> unless you save state for all the parent directories, except...   
>> What happens when you are in "/foo/bar" and another process does  
>> "mv /foo/bar /foobar/quux"?  Suddenly any "cwd" ACL data you have  
>> is completely invalid and you have to rebuild your ACLs from  
>> scratch.  Moreover, if the directory you are in was moved to a  
>> portion of the filesystem not accessible from your current  
>> namespace then how do you deal with it?
>
> Yes, if /foo/quux is not already cached in memory, you would have  
> to walk the tree to build its acl.  /foo should already be cached  
> in memory so this work is minimal.  Is this so horrible of a problem?
>
> As for moving, it is handled the same way as any other event that  
> makes cwd go away, such as deleting it or revoking your access; cwd  
> is now invalid.

No, you aren't getting it:  YOUR CWD DOES NOT GO AWAY WHEN YOU MOVE  
IT OR UMOUNT -L IT.  NEITHER DO OPEN DIRECTORY HANDLES.  Sorry for  
yelling but this is the crux of the point I am trying to make.  Any  
permissions system which cannot handle a *completely* discontiguous  
filesystem space cannot work on Linux; end of story.  The primary  
reason behind that is all sorts of filesystem operations are  
internally discontiguous because it makes them much more efficient.   
By attempting to "force" the VFS to pretend like everything is  
contiguous you are going to break horribly in a thousand different  
corner cases that simply don't exist at the moment.


>> For example:
>> NS1 has the / root dir of /dev/sdb1 mounted on /mnt
>> NS2 has the /bar subdir of /dev/sdb1 mounted on /mnt
>> Your process is in NS2 and does chdir("/mnt/quux").  A user in NS1  
>> does: "mv /mnt/bar/quux /mnt/quux".  Now your "cwd" is in a  
>> directory on a filesystem you have mounted, but it does not  
>> correspond *AT ALL* to any path available from your namespace.
>
> Which would be no different than if they just deleted the entire  
> thing.  Your cwd no longer exists.

No, your cwd still exists and is full of files.  You can still  
navigate around in it (same with any open directory handle).  You can  
still open files, chdir, move files, etc.  There isn't even a way for  
the process in NS1 to tell the processes in NS2 that its directories  
were rearranged, so even a simple "NS1# mv /mnt/bar/a/somedir /mnt/ 
bar/b/somedir" is not going to work.


>> Another example:
>> Your process has done dirfd=open("/media/cdrom/somestuff") when  
>> the admin does "umount -l /media/cdrom".  You still have the CD- 
>> ROM open and accessible but IT HAS NO PATH.  It isn't even mounted  
>> in *any* namespace, it's just kind of dangling waiting for its  
>> last users to go away.  You can still do fchdir(dirfd), openat 
>> (dirfd, "foo/bar", ...), open("./foo"), etc.
>
> What's this got to do with acls?  If you are asking what effect the  
> umount thas on the acls of the cdrom, the answer is none.  The acls  
> are on the disc and nothing on the disc has changed.

But you said above  "Yes, if /foo/quux is not already cached in  
memory, then you would have to walk the tree to build it's ACL".  Now  
assume that instead of "/foo/quux", you are one directory deep in the  
now-unmounted CDROM and you try to open "../baz/quux".  In order to  
get at the ACL of the parent directory it has to have an absolute  
path somewhere, but at that point it doesn't.


>> No, this is correct because in the root directory "/", the ".."  
>> entry is just another link to the root directory.  So the absolute  
>> path "/../../../../../.." is just a fancy name for the root  
>> directory.  The above jail-escape-as-root exploit is possible  
>> because it is impossible to determine whether a directory is or is  
>> not a subentry of another directory without an exhaustive search.   
>> So when your "cwd" points to a path outside of the chroot, the one  
>> special case in the code for the "root" directory does not ever  
>> match and you can "chdir" all the way up to the real root.  You  
>> can even do an fstat() after every iteration to figure out whether  
>> you're there or not!
>
> Ohh, I see... yes... that is a very clever way for root to misuse  
> chroot().  What does it have to do with this discussion?

What it "has to do" is it is part of the Linux ABI and as such you  
can't just break it because it's "inconvenient" for inheritable  
ACLs.  You also can't make a previously O(1) operation take lots of  
time, as that's also considered "major breakage".


>> With this you just got into the big-ugly-nasty-recursive-behavior  
>> again.  Say I untar 20 kernel source trees and then have my  
>> program open all 1000 available FDs to various directories in the  
>> kernel source tree.  Now I run 20 copies of this program, one for  
>> each tree, still well within my ulimits even on a conservative  
>> box.  Now run "mv dir_full_of_kernel_sources some/new/dir".  The  
>> only thing you can do to find all of the FDs is to iterate down  
>> the entire subdirectory tree looking for open files and updating  
>> their contexts one-by-one.  Except you have 20,000 directory FDs  
>> to update.  Ouch.
>
> Ok, so you found a pedantic corner case that is slow.  So?  And it  
> is still going to be faster than chmod -R.ee

"Pedantic corner case"?  You could do the same thing even *WITHOUT*  
all the processes holding open FDs, you would still have to iterate  
over the entire in-cache portion of the subtree in order to verify  
that there are no open FDs on it.  Yet again you would also run into  
the problem that we don't have *ANY* dentry-to-filehandle mapping in  
the kernel.


>> To sum up, when doing access control the only values you can  
>> safely and efficiently get at are:
>> (A)  The dentry/inode
>> (B)  The superblock
>> (C)  *Maybe* the vfsmount if those patches get accepted
>> Any access control model which tries to poke other values is just  
>> going to have a shitload of corner cases where it just falls over.
>
> If by falls over you mean takes some time, then yes.... so what?

Converting a previously O(1) operation into an O(number-of-subdirs)  
operation is also known as "a major regression which we don't do a  
release till we get it fixed".  For boxes where O(number-of-subdirs)  
numbers in the millions that would make it slow to a painful crawl.

By the way, I'm done with this discussion since you don't seem to be  
paying attention at all.  Don't bother replying unless you've  
actually written testable code you want people on the list to look  
at.  I'll eat my own words if you actually come up with an algorithm  
which works efficiently without introducing regressions.

Cheers,
Kyle Moffett

