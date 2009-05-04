Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZEDLwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZEDLwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZEDLwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:52:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZEDLwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:52:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: compat ioctl32 for /dev/snapshot?
Date: Mon, 4 May 2009 13:52:18 +0200
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
References: <49FEB572.4010909@msgid.tls.msk.ru> <87prepgqhc.fsf@basil.nowhere.org> <49FEC98E.4050906@msgid.tls.msk.ru>
In-Reply-To: <49FEC98E.4050906@msgid.tls.msk.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905041352.18428.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/BqeYrO+9zdYFLmjIaL4xvHh8upeGVTVpwaso
 TOcl3aV/R0ODyir8K4SOJvW0e6sxnY9FKZaY5qktfP+GgEtXnu
 D94PH/xVcMLy7tkqemT2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, Michael Tokarev wrote:
> Is the following patch ok?  I just pulled all the SNAPSHOT_* stuff from
> include/linux/suspend_ioctls.h and added them into fs/compat_ioctl.c.
> The ioctls are:
>   o argument-less (most of them are)

Some of the ones that do not take a pointer argument actually do
take an integer argument, in particular SNAPSHOT_PREF_IMAGE_SIZE and
SNAPSHOT_PLATFORM_SUPPORT, which you need to list as ULONG_IOCTL
rather than COMPAT_IOCTL if you want to add them to compat_ioctl.c.

>   o have single loff_t argument (other ioctls with the same argument are
>     marked as COMPAT_IOCTL
>   o have single int argument - they's also marked as COMPAT_IOCTL,

right.

>   o and one othem, SNAPSHOT_SET_SWAP_AREA, has argument pointing to
>     the following structure (include/linux/suspend_ioctls.h):
>      struct resume_swap_area {
>          loff_t offset;
>          u_int32_t dev;
>      } __attribute__((packed));
>     so I think it also does not need any translation layer.


this one would be compat_ioctl as well, because the
__attribute__((packed)) turns it into a well-defined size of
12 bytes on any architecture (without the attribute, it would
be 16 bytes on most architectures, but not i386. The recommended
way to do this for new architectures would be explicit padding
rather than packed attribute.).

You are however missing support for deprecated ioctls in your
code: SNAPSHOT_SET_SWAP_FILE and SNAPSHOT_PMOPS are trivial
(COMPATIBLE_IOCTL), but you also need to add support for
these

#define SNAPSHOT_ATOMIC_SNAPSHOT32 _IOW(SNAPSHOT_IOC_MAGIC, 3, compat_uptr_t)
#define SNAPSHOT_SET_IMAGE_SIZE32 _IOW(SNAPSHOT_IOC_MAGIC, 6, compat_ulong)
#define SNAPSHOT_AVAIL_SWAP32 _IOR(SNAPSHOT_IOC_MAGIC, 7, compat_uptr_t)
#define SNAPSHOT_GET_SWAP_PAGE32 _IOR(SNAPSHOT_IOC_MAGIC, 8, compat_uptr_t)

> I can't test it so far, because uswsusp tools are broken in mixed
> 32/64bit case in other places.  But at least it compiles fine and
> does not complain anymore.

I try to reduce the size of compat_ioctl.c. A better implementation
would be to add a ->compat_ioctl() operation to the file_operations
and list the compatible ioctl numbers as well.

Please try this patch instead:

suspend: Add compat_ioctl for snapshot device

All of the ioctl numbers in here are compatible, but for some of
the deprecated numbers, we need to add aliases.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -51,6 +51,10 @@
 #define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
 #define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
 #define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
+#define SNAPSHOT_ATOMIC_SNAPSHOT32	_IOW(SNAPSHOT_IOC_MAGIC, 3, compat_uptr_t)
+#define SNAPSHOT_SET_IMAGE_SIZE32	_IOW(SNAPSHOT_IOC_MAGIC, 6, compat_ulong)
+#define SNAPSHOT_AVAIL_SWAP32		_IOR(SNAPSHOT_IOC_MAGIC, 7, compat_uptr_t)
+#define SNAPSHOT_GET_SWAP_PAGE32	_IOR(SNAPSHOT_IOC_MAGIC, 8, compat_uptr_t)
 
 
 #define SNAPSHOT_MINOR	231
@@ -249,6 +253,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 
 	case SNAPSHOT_CREATE_IMAGE:
 	case SNAPSHOT_ATOMIC_SNAPSHOT:
+#ifdef CONFIG_COMPAT
+	case SNAPSHOT_ATOMIC_SNAPSHOT32:
+#endif
 		if (data->mode != O_RDONLY || !data->frozen  || data->ready) {
 			error = -EPERM;
 			break;
@@ -278,6 +285,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 
 	case SNAPSHOT_PREF_IMAGE_SIZE:
 	case SNAPSHOT_SET_IMAGE_SIZE:
+#ifdef CONFIG_COMPAT
+	case SNAPSHOT_SET_IMAGE_SIZE32:
+#endif
 		image_size = arg;
 		break;
 
@@ -293,6 +303,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 
 	case SNAPSHOT_AVAIL_SWAP_SIZE:
 	case SNAPSHOT_AVAIL_SWAP:
+#ifdef CONFIG_COMPAT
+	case SNAPSHOT_AVAIL_SWAP32:
+#endif
 		size = count_swap_pages(data->swap, 1);
 		size <<= PAGE_SHIFT;
 		error = put_user(size, (loff_t __user *)arg);
@@ -300,6 +313,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 
 	case SNAPSHOT_ALLOC_SWAP_PAGE:
 	case SNAPSHOT_GET_SWAP_PAGE:
+#ifdef CONFIG_COMPAT
+	case SNAPSHOT_GET_SWAP_PAGE32:
+#endif
 		if (data->swap < 0 || data->swap >= MAX_SWAPFILES) {
 			error = -ENODEV;
 			break;
@@ -436,6 +452,9 @@ static const struct file_operations snapshot_fops = {
 	.write = snapshot_write,
 	.llseek = no_llseek,
 	.unlocked_ioctl = snapshot_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = snapshot_ioctl,
+#endif
 };
 
 static struct miscdevice snapshot_device = {
