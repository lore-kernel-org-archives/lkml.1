Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbZJ2Iel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbZJ2Iel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZJ2Iek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:34:40 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:64930 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZJ2Iej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:34:39 -0400
Date: Thu, 29 Oct 2009 09:34:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: arndbergmann@googlemail.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       Ankit Jain <me@ankitjain.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091029083415.GA6639@osiris.boeblingen.de.ibm.com>
References: <200910281313.32827.arnd@arndb.de>
 <20091028.051631.212225494.davem@davemloft.net>
 <200910281640.18491.arnd@arndb.de>
 <20091028.224157.92041844.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028.224157.92041844.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 10:41:57PM -0700, David Miller wrote:
> From: Arnd Bergmann <arndbergmann@googlemail.com>
> Date: Wed, 28 Oct 2009 16:40:18 +0100
> 
> > I'm pretty sure it was ok when we started adding the compat_ioctl
> > handlers years ago. I think most people just ignored these for
> > the majority of drivers that can't possibly run on s390. Even
> > on s390, gcc will always do the right thing if you call call ioctl
> > with a pointer to a normal object in the .data section, heap or stack,
> > but hand-written assembly or other compilers may not.
> 
> Arnd, even compat_sys_ioctl() itself has constructs like:
> 
> 	case FS_IOC_RESVSP:
> 	case FS_IOC_RESVSP64:
> 		error = ioctl_preallocate(filp, (void __user *)arg);
> 		goto out_fput;

That's broken, but it's quite new code. In general it looks like we don't
have many compat ioctl problems on s390. At least I don't remember when
we faced the last bug.
We did have some compat syscall issues when SLES11 testing started.
The lack of bug reports is probably just a lack of 32 bit userspace ;)

This should fix at least the bug above:

Subject: [PATCH] fs: add missing compat_ptr handling for FS_IOC_RESVSP ioctl

From: Heiko Carstens <heiko.carstens@de.ibm.com>

For FS_IOC_RESVSP and FS_IOC_RESVSP64 compat_sys_ioctl() uses its
arg argument as a pointer to userspace. However it is missing a
a call to compat_ptr() which will do a proper pointer conversion.

This was introduced with 3e63cbb1 "fs: Add new pre-allocation ioctls
to vfs for compatibility with legacy xfs ioctls".

Cc: Ankit Jain <me@ankitjain.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>
Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/compat_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f91fd51..d84e705 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1800,7 +1800,7 @@ struct space_resv_32 {
 /* just account for different alignment */
 static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
 {
-	struct space_resv_32	__user *p32 = (void __user *)arg;
+	struct space_resv_32	__user *p32 = compat_ptr(arg);
 	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
 
 	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
@@ -2802,7 +2802,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 #else
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		error = ioctl_preallocate(filp, (void __user *)arg);
+		error = ioctl_preallocate(filp, compat_ptr(arg));
 		goto out_fput;
 #endif
 
