Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbXHPEo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbXHPEo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 00:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXHPEot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 00:44:49 -0400
Received: from smtpout.mac.com ([17.250.248.176]:49677 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXHPEor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 00:44:47 -0400
In-Reply-To: <46C37AD4.5060006@cfl.rr.com>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Thu, 16 Aug 2007 00:44:25 -0400
To: Phillip Susi <psusi@cfl.rr.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mmm, slow-as-dirt hotel wireless.  What fun...

On Aug 15, 2007, at 18:14:44, Phillip Susi wrote:
> Kyle Moffett wrote:
>>> I am well aware of that, I'm simply saying that sucks.  Doing a  
>>> recursive chmod or setfacl on a large directory tree is slow as  
>>> all hell.
>>
>> Doing it in the kernel won't make it any faster.
>
> Right... I'm talking about getting rid of it entirely.

Let me repeat myself here:  Algorithmically you fundamentally CANNOT  
implement inheritance-based ACLs without one of the following  
(although if you have some other algorithm in mind, I'm listening):
   (A) Some kind of recursive operation *every* time you change an  
inheritable permission
   (B) A unified "starting point" from which you begin *every* access- 
control lookup (or one "starting point" per useful semantic grouping,  
like a namespace).

The "(A)" is presently done in userspace and that's what you want to  
avoid.  As to (B), I will attempt to prove below that you cannot  
implement "(B)" without breaking existing assumptions and restricting  
a very nice VFS model.

>> Not necessarily.  When I do "vim some-file-in-current-directory",  
>> for example, the kernel does *NOT* look up the path of my current  
>> directory.  It does (in pseudocode):
>> if (starts_with_slash(filename)) {
>>     entry = task->cwd;
>> } else {
>>     entry = task->root;
>> }
>> while (have_components_left(filename)
>>     entry = lookup_next_component(filename);
>> return entry;
>
> Right.... and task->cwd would have the effective acl in memory,  
> ready to be combined with any acl set on the file.

What ACL would "task->cwd" use?

Options:
(1.a) Use the one calculated during the original chdir() call.
(1.b) Navigate "up" task->cwd building an ACL backwards.
(1.c) $CAN_YOU_THINK_OF_SOMETHING_ELSE_HERE

Unsolvable problems with each option:

(1.a.I)
You just broke all sorts of chrooted daemons.  When I start bind in  
its chroot jail, it does the following:
   chdir("/private/bind9");
   chroot(".");
   setgid(...);
   setuid(...);
The "/private" directory is readable only by root, since root is the  
only one who will be navigating you into these chroots for any  
reason.  You only switch UID/GID after the chroot() call, at which  
point you are inside of a sub-context and your cwd is fully  
accessible.  If you stick an inheritable ACL on "/private", then the  
"cwd" ACL will not allow access by anybody but root and my bind won't  
be able to read any config files.

You also break relative paths and directory-moving.  Say a process  
does chdir("/foo/bar").  Now the ACL data in "cwd" is appropriate  
for /foo/bar.  If you later chdir("../quux"), how do you unapply the  
changes made when you switched into that directory?  For inheritable  
ACLs, you can't "unapply" such an ACL state change unless you save  
state for all the parent directories, except...  What happens when  
you are in "/foo/bar" and another process does "mv /foo/bar /foobar/ 
quux"?  Suddenly any "cwd" ACL data you have is completely invalid  
and you have to rebuild your ACLs from scratch.  Moreover, if the  
directory you are in was moved to a portion of the filesystem not  
accessible from your current namespace then how do you deal with it?

For example:
NS1 has the / root dir of /dev/sdb1 mounted on /mnt
NS2 has the /bar subdir of /dev/sdb1 mounted on /mnt

Your process is in NS2 and does chdir("/mnt/quux").  A user in NS1  
does: "mv /mnt/bar/quux /mnt/quux".  Now your "cwd" is in a directory  
on a filesystem you have mounted, but it does not correspond *AT ALL*  
to any path available from your namespace.

Another example:
Your process has done dirfd=open("/media/cdrom/somestuff") when the  
admin does "umount -l /media/cdrom".  You still have the CD-ROM open  
and accessible but IT HAS NO PATH.  It isn't even mounted in *any*  
namespace, it's just kind of dangling waiting for its last users to  
go away.  You can still do fchdir(dirfd), openat(dirfd, "foo/ 
bar", ...), open("./foo"), etc.

In Linux the ONLY distinction between "relative" and "absolute" paths  
is that the "absolute" path begins with a magic slash which implies  
that you start at the hidden "root" fd the kernel manages.

More detail on problems with the "building the ACL from scratch" part:
>> That's not even paying attention to functions like "fchdir" or  
>> their interactions with "chroot" and namespaces.  I can probably  
>> have an open directory handle to a volume in a completely  
>> different namespace, a volume which isn't even *MOUNTED* in my  
>> current fs namespace.  Using that file-handle I believe I can  
>> "fchdir", "openat", etc, in a completely different namespace.  I  
>> can do the same thing with a chroot, except there I can even  
>> "escape":
>>   /* Switch into chroot.  Doesn't drop root privs */
>>   chdir("/some/dir/somewhere");
>>   chroot(".");
>>   /* Malicious code later on */
>>   chdir("/");
>>   chroot("another_dir");
>>   chdir("../../../../../../../../..");
>>   chroot(".");
>>   /* Now I'm back in the real root filesystem */
>
> I don't see what this has to do with this discussion, and I also  
> can't believe that is correct... the chdir( "../../../../.." )  
> should fail because there is no such directory.

No, this is correct because in the root directory "/", the ".." entry  
is just another link to the root directory.  So the absolute path  
"/../../../../../.." is just a fancy name for the root directory.   
The above jail-escape-as-root exploit is possible because it is  
impossible to determine whether a directory is or is not a subentry  
of another directory without an exhaustive search.  So when your  
"cwd" points to a path outside of the chroot, the one special case in  
the code for the "root" directory does not ever match and you can  
"chdir" all the way up to the real root.  You can even do an fstat()  
after every iteration to figure out whether you're there or not!

And yes, this has been exploited before, although not often as chroot 
()-ed uid=0 daemons aren't all that common.

So, pray tell, when this code runs and you do the "chroot" call, what  
ACL do you think should get stuck on "cwd"?  It doesn't reference  
anything available relative to the chroot.


>> The locking penalty is because the path-lookup is *not* implied.   
>> The above chroot example shows that in detail.  If you have to do  
>> the lookup in *reverse* on every open operation then you have to  
>> either:
>>   (A) Store lots of security context with every open directory  
>> (cwd included).  When a directory you have open is moved, you  
>> still have full access to everything inside it since your handle's  
>> data hasn't changed.
>
> Yes, the effective acl of the open directory is kept in memory, but  
> in the directory itself, not the handle to it, thus when the  
> directory is moved, it's acl is recomputed for the new location and  
> updated immediately.  It is like using fcntl to set a file to non  
> blocking... it is the file you set, not the handle to it, so it  
> effects other processes that have inherited or duplicated the file.

With this you just got into the big-ugly-nasty-recursive-behavior  
again.  Say I untar 20 kernel source trees and then have my program  
open all 1000 available FDs to various directories in the kernel  
source tree.  Now I run 20 copies of this program, one for each tree,  
still well within my ulimits even on a conservative box.  Now run "mv  
dir_full_of_kernel_sources some/new/dir".  The only thing you can do  
to find all of the FDs is to iterate down the entire subdirectory  
tree looking for open files and updating their contexts one-by-one.   
Except you have 20,000 directory FDs to update.  Ouch.

To sum up, when doing access control the only values you can safely  
and efficiently get at are:
(A)  The dentry/inode
(B)  The superblock
(C)  *Maybe* the vfsmount if those patches get accepted

Any access control model which tries to poke other values is just  
going to have a shitload of corner cases where it just falls over.

Cheers,
Kyle Moffett

