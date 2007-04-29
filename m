Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXD2SO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXD2SO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXD2SO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:14:29 -0400
Received: from relais.videotron.ca ([24.201.245.36]:12366 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXD2SO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:14:28 -0400
Date: Sun, 29 Apr 2007 14:14:29 -0400 (EDT)
From: Bart Oldeman <bartoldeman@users.sourceforge.net>
Subject: [PATCH] [FAT] fix VFAT compat ioctls on 64-bit systems
X-X-Sender: enbeo@localhost.localdomain
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org
Message-id: <Pine.LNX.4.64.0704291342180.18631@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

if you compile and run the below test case in an msdos or vfat directory 
on an x86-64 system with -m32 you'll get garbage in the kernel_dirent 
struct followed by a SIGSEGV.

The patch below fixes this. It's a minimal patch -- I haven't converted 
spaces to tabs or added extra put_user checks.

The problems:
* d_ino/d_off are undefined for de[0]. Random values from the kernel stack
   are copied here into user space.
* d_name, for both de[0] and de[1], is not zero terminated.
* if the long filename in de[1] is empty, d_ino/d_off are also undefined
   for de[1].

Signed-off-by: Bart Oldeman <bartoldeman@users.sourceforge.net>

testcase:

#include <sys/types.h>
#include <sys/ioctl.h>
#include <dirent.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
struct kernel_dirent {
         long            d_ino;
         long		d_off;
         unsigned short  d_reclen;
         char            d_name[256]; /* We must not include limits.h! */
};
#define VFAT_IOCTL_READDIR_BOTH  _IOR('r', 1, struct kernel_dirent [2])
#define VFAT_IOCTL_READDIR_SHORT  _IOR('r', 2, struct kernel_dirent [2])

int main(void)
{
         int fd = open(".", O_RDONLY);
         struct kernel_dirent de[2];

         while (1) {
                 int i = ioctl(fd, VFAT_IOCTL_READDIR_BOTH, (long)de);
                 if (i == -1) break;
                 if (de[0].d_reclen == 0) break;
                 printf("SFN: reclen=%2d off=%d ino=%d, %-12s",
 		       de[0].d_reclen, de[0].d_off, de[0].d_ino, de[0].d_name);
 		if (de[1].d_reclen)
 		  printf("\tLFN: reclen=%2d off=%d ino=%d, %s",
 		    de[1].d_reclen, de[1].d_off, de[1].d_ino, de[1].d_name);
 		printf("\n");
         }
         return 0;
}


Patch:

--- linux-2.6/fs/fat/dir.c.orig	2007-04-29 12:41:04.000000000 -0400
+++ linux-2.6/fs/fat/dir.c	2007-04-29 13:59:45.000000000 -0400
@@ -749,14 +749,23 @@ static int fat_dir_ioctl(struct inode *
  static long fat_compat_put_dirent32(struct dirent *d,
  				    struct compat_dirent __user *d32)
  {
-        if (!access_ok(VERIFY_WRITE, d32, sizeof(struct compat_dirent)))
+	if (!access_ok(VERIFY_WRITE, d32, sizeof(struct compat_dirent[2])))
                  return -EFAULT;

-        __put_user(d->d_ino, &d32->d_ino);
-        __put_user(d->d_off, &d32->d_off);
          __put_user(d->d_reclen, &d32->d_reclen);
+	__put_user(0, d32->d_name + d->d_reclen);
          if (__copy_to_user(d32->d_name, d->d_name, d->d_reclen))
  		return -EFAULT;
+	d++;
+	d32++;
+	__put_user(d->d_reclen, &d32->d_reclen);
+	__put_user(0, d32->d_name + d->d_reclen);
+	if (d->d_reclen) {
+		__put_user(d->d_ino, &d32->d_ino);
+		__put_user(d->d_off, &d32->d_off);
+		if (__copy_to_user(d32->d_name, d->d_name, d->d_reclen))
+			return -EFAULT;
+	}

          return 0;
  }
@@ -787,8 +796,7 @@ static long fat_compat_dir_ioctl(struct
  	unlock_kernel();
  	set_fs(oldfs);
  	if (ret >= 0) {
-		ret |= fat_compat_put_dirent32(&d[0], p);
-		ret |= fat_compat_put_dirent32(&d[1], p + 1);
+		ret |= fat_compat_put_dirent32(d, p);
  	}
  	return ret;
  }
