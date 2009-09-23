Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbZIWPuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbZIWPuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZIWPuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:50:19 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:42326 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZIWPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:50:18 -0400
Date: Wed, 23 Sep 2009 17:49:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] fs: change sys_truncate/sys_ftruncate length parameter
 type
Message-ID: <20090923154955.GA17895@osiris.boeblingen.de.ibm.com>
References: <20090923150326.GB23595@osiris.boeblingen.de.ibm.com>
 <alpine.LFD.2.01.0909230808130.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909230808130.4950@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 08:13:47AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 23 Sep 2009, Heiko Carstens wrote:
> > 
> > For both system calls user space passes a signed long length parameter,
> > while the kernel side takes an unsigned long parameter and converts it
> > later to signed long again.
> 
> No it doesn't.
> 
> Look at sys_ftruncate() again. It doesn't convert it to signed long at 
> all. It converts it to 'loff_t' which is something different entirely.
> 
> Now, it may be that we _should_ convert it to 'long' like your patch does, 
> but this is definitely not a "no changes" patch as far as I can tell. It 
> limits ftruncate to 31 bits on 32-bit architectures, in ways it didn't use 
> to be limited.
> 
> [ Note the "small" logic and the interaction with O_LARGEFILE. On a 32-bit 
>   architecture, if you open with O_LARGEFILE, ftruncate() gets the full 
>   32-bit range, and that's the part your patch broke. ]
> 
> So NAK. Not without some serious explanations on why I'm wrong and am just 
> being unnecessarily difficult and a pinhead.

Yes, you're right. That would be a user space visible change. I was too much
focused on the man page + the power pc patch.
So it's only the truncate part that would make sense:

Subject: [PATCH] fs: change sys_truncate length parameter type

From: Heiko Carstens <heiko.carstens@de.ibm.com>

For this system call user space passes a signed long length parameter,
while the kernel side takes an unsigned long parameter and converts it
later to signed long again.
As far as I can see there is no point in doing the unsigned -> signed
conversion.
But it has led to bugs in compat wrappers see e.g.
dd90bbd5 "powerpc: Add compat_sys_truncate".
The s390 compat wrapper for this functions is broken as well
since it also performs zero extension instead of sign extension
for the length parameter.

In addition if hpa comes up with an automated way of generating
compat wrappers it would generate a wrong one here.

So change the length parameter from unsigned long to long.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/open.c                |    5 ++---
 include/linux/syscalls.h |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c
+++ linux-2.6/fs/open.c
@@ -290,10 +290,9 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE2(truncate, const char __user *, path, unsigned long, length)
+SYSCALL_DEFINE2(truncate, const char __user *, path, long, length)
 {
-	/* on 32-bit boxen it will cut the range 2^31--2^32-1 off */
-	return do_sys_truncate(path, (long)length);
+	return do_sys_truncate(path, length);
 }
 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
@@ -460,8 +460,7 @@ asmlinkage long sys_mount(char __user *d
 				void __user *data);
 asmlinkage long sys_umount(char __user *name, int flags);
 asmlinkage long sys_oldumount(char __user *name);
-asmlinkage long sys_truncate(const char __user *path,
-				unsigned long length);
+asmlinkage long sys_truncate(const char __user *path, long length);
 asmlinkage long sys_ftruncate(unsigned int fd, unsigned long length);
 asmlinkage long sys_stat(char __user *filename,
 			struct __old_kernel_stat __user *statbuf);
