Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbXGMDKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbXGMDKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbXGMDKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:10:18 -0400
Received: from 192.pool85-58-10.dynamic.orange.es ([85.58.10.192]:39940 "EHLO
	cafe.aluzina.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbXGMDKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:10:14 -0400
X-Greylist: delayed 1672 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 23:10:14 EDT
Message-ID: <4696E67E.4020100@aluzina.org>
Date: Fri, 13 Jul 2007 04:42:06 +0200
From: =?ISO-8859-1?Q?Zeus_G=F3mez_Marmolejo?= <zeus@aluzina.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: New LSM security operation
References: <883505.60477.qm@web36609.mail.mud.yahoo.com>
In-Reply-To: <883505.60477.qm@web36609.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> An application that is careful not to destroy existing information
> would not be able to prevent itself from doing so if the file is
> hidden. Its pretty important to avoid defeating programs that are
> trying to behave properly.
> 

It's true what you are saying... But I think the best way to know if 
there is an existing file with that name is by the stat() syscall, not 
reading the contents of the directory, by the way is very inefficient if 
there are a lot of files in that directory.

For example, the editor "vi" when editing a file "p1.c" and saving with 
":w p2.c" it searches first if this file exists with:

stat64("p2.c", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0

(... just verified it with strace). I think doing this is the best way, 
and most programs do that in this way.

On the other hand, I'm only talking about modifying the: "sys_readdir", 
"sys_getdents" and "sys_getdents64" system calls, all implemented in the 
"fs/readdir.c" file.

In fact, I've tried to code it, and I think it's best done in the 
"filldir()" callback, called each time that an entry in the directory is 
found by the underlying filesystem walk. Just check if this entry is 
permitted to list and then return without adding it into the buffer. I 
tried this (in fs/readdir.c, filldir64()):

static int filldir64(void * __buf, const char * name, int namlen,
                      loff_t offset, u64 ino, unsigned int d_type)
{
   struct linux_dirent64 __user *dirent;
   struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
   int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
+ int res;
+
+ res = security_inode_list( buf->i_dir, iget(buf->sb, ino) );
+ if (res)
+   return 0;

   buf->error = -EINVAL;   /* only used if we fail.. */
   ...
}

Adding two members in the callback structure (sb and i_dir) with the 
superblock and inode of the parent directory.

This works in all filesystems with a superblock, but for example in 
sysfs, the operation iget() segfaults because can't search for an inode 
using the superblock operations, because it doesn't have the 
read_inode() operation.

Is there any other way to obtain the "struct inode *" from the inode 
number, without using the superblock operations!?

> 
> In the open-for-read case returning an error other than ENOENT gives
> away the existance of the file. Returning ENOENT is a lie, so is just
> wrong.
> 

OK. But maybe is what the administrator wants to return to the user. If 
the file is not readable or writable and not listable by some user, then 
for him simply doesn't exist... But, I don't care... if we are 
consistent with what we are doing, the correct thing is to return an 
EACCES because of the forbidding read.

> 
> Sounds to me like the problem you're out to solve is specific to
> ls under SELinux. Fixing* ls is straitforward, don't say anything
> about directory entries you don't have access to rather than the
> current annoying error messages. Fixing* SELinux may be an option,
> you may even be able to achieve what you're after using the current
> mechanisms. The SELinux mailing list might be worth cross-posting.
> 


I don't think this is a "ls" problem. The fact is if some user wants to 
know the pid names or some other directory entries, he just have to 
compile his version of "ls" and would get all this names because the 
getdents() system call is showing them.

I think they are different policies, one is getting the attributes of a 
given file (that is what SELinux can forbid) and then this is why "ls 
-l" complains about showing them. But the other policy is just not 
showing the file, but you may get the permissions if you really know the 
name: "ls -l /etc/abadbad", this is not possible with SELinux nor with 
other security module because the Linux SM framework just lack the hook 
to avoid doing this listing.

Thank you for your comments!!


Zeus.
