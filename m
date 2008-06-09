Return-Path: <linux-kernel-owner+w=401wt.eu-S1762511AbYFIWam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762511AbYFIWam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761800AbYFIW1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:27:39 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47274 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbYFIW1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:27:38 -0400
Date: Tue, 10 Jun 2008 01:26:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "H. Peter Anvin" <hpa@kernel.org>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       Onur =?utf-8?B?S8O8w6fDvGs=?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fat/dir.c: switch to struct __fat_fs_dirent
Message-ID: <20080609222644.GY1987@cs181133002.pp.htv.fi>
References: <200806082116.50355.caglar@pardus.org.tr> <20080608184310.GD4048@cs181133002.pp.htv.fi> <87prqrn4d8.fsf@duaron.myhome.or.jp> <484C83D9.2020402@kernel.org> <87iqwjmekq.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87iqwjmekq.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 01:12:37PM +0900, OGAWA Hirofumi wrote:
> "H. Peter Anvin" <hpa@kernel.org> writes:
> 
> > The other thing about this header that needs to be fixed is the 
> > definition of the following ioctls:
> >
> > #define VFAT_IOCTL_READDIR_BOTH         _IOR('r', 1, struct dirent [2])
> > #define VFAT_IOCTL_READDIR_SHORT        _IOR('r', 2, struct dirent [2])
> >
> > "struct dirent" is a kernel type here, but is a **different type** in 
> > userspace!  This means both the structure and the IOCTL number is wrong!
> >
> > We need to make this either __kernel_dirent_t[*] or something like 
> > struct __msdos_fs_dirent.
> 
> I see. "struct dirent" in linux/dirent.h has very few users in kernel,
> and probably userland doesn't use it, so it seems it should be renamed.
> 
> Well, the patch is like this (sorry, other cleanup is in this patch)?
>...

Can you apply the patch below after your patch?

Since fat was the only user of struct dirent in the kernel (there's an 
unused JFS #define I'll also kill) we can then get rid of the 
conflicting structs.

> Thanks.
>...

cu
Adrian


<--  snip  -->


struct __fat_fs_dirent is what was formerly the kernel struct dirent
(that was different from the userspace struct dirent).

Converting all fat users to struct __fat_fs_dirent will allow us to get 
rid of the conflicting struct dirent definition.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/fat/dir.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

b8c595b4b225c2485d8dbc7ff4cbcdc8e6113672 diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 486725e..041a112 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
-#include <linux/dirent.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
@@ -715,7 +714,7 @@ efault:									   \
 	return -EFAULT;							   \
 }
 
-FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, dirent)
+FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_fs_dirent)
 
 static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
 			     void __user *dirent, filldir_t filldir,
@@ -741,7 +740,7 @@ static int fat_ioctl_readdir(struct inode *inode, struct file *filp,
 static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 			 unsigned int cmd, unsigned long arg)
 {
-	struct dirent __user *d1 = (struct dirent __user *)arg;
+	struct __fat_fs_dirent __user *d1 = (struct __fat_fs_dirent __user *)arg;
 	int short_only, both;
 
 	switch (cmd) {
@@ -757,7 +756,7 @@ static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 		return fat_generic_ioctl(inode, filp, cmd, arg);
 	}
 
-	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct dirent[2])))
+	if (!access_ok(VERIFY_WRITE, d1, sizeof(struct __fat_fs_dirent[2])))
 		return -EFAULT;
 	/*
 	 * Yes, we don't need this put_user() absolutely. However old

