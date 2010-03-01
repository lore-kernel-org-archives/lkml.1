Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab0CAFaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:30:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42149 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0CAFaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:30:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Hciqz6X5mvSMOJUS6A3L2NVp0BeZbu1FApW2mbxP23aldAh3MYSLW9r6Q1+2YYmZ0n
         JQK6AY15leB0Fwxbi2asQ/ulumk+RP76MTRb1zU5XWbgLHbj6KeI/RcfOTKGWScVSlii
         jaEAqQUlVUThToJ1LTxD1qQE63RiHz+U73l+c=
MIME-Version: 1.0
Date: Sun, 28 Feb 2010 21:30:12 -0800
Message-ID: <be233a491002282130m3c637cfbw6648a77548241a64@mail.gmail.com>
Subject: [PATCH] hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>
To: clemens@ladisch.de, venkatesh.pallipadi@intel.com, vojtech@suse.cz,
       bob.picco@hp.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of the /dev/hpet driver couples opening the
device with allocating one of the (scarce) timers (aka comparators).
This is a limitation in that the main counter may be valuable to
applications seeking a high-resolution timer who have no use for the
interrupt generating functionality of the comparators.

This patch alters the open semantics so that when the device is
opened, no timer is allocated. Operations that depend on a timer being
in context implicitly attempt allocating a timer, to maintain backward
compatibility. There is also an IOCTL (HPET_ALLOC_TIMER _IO) added so
that the allocation may be done explicitly. (I prefer the explicit
open then allocate pattern but don't know how practical it would be to
require all existing code to be changed.)

I also have changes for adding IOCTLs to get the main counter
value--which is more straightforward than mmaping and reading the
registers directly, and possibly necessary if mmap is ifdef'd
away--but have separated that logically into another patch. I'll wait
to post that until any issues with this are hashed out.

Signed-off-by: Magnus Lynch <maglyx@gmail.com>
---
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e481c59..8991227 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -244,16 +244,40 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)

 static int hpet_open(struct inode *inode, struct file *file)
 {
-       struct hpet_dev *devp;
       struct hpets *hpetp;
-       int i;

       if (file->f_mode & FMODE_WRITE)
               return -EINVAL;

+       hpetp = hpets;
+       /* starting with timer-neutral instance */
+       file->private_data = &hpetp->hp_dev[hpetp->hp_ntimer];
+
+       return 0;
+}
+
+static int hpet_alloc_timer(struct file *file)
+{
+       struct hpet_dev *devp;
+       struct hpets *hpetp;
+       int i;
+
+       /* once acquired, will remain */
+       devp = file->private_data;
+       if (devp->hd_timer)
+               return 0;
+
       lock_kernel();
       spin_lock_irq(&hpet_lock);

+       /* check for race acquiring */
+       devp = file->private_data;
+       if (devp->hd_timer) {
+               spin_unlock_irq(&hpet_lock);
+               unlock_kernel();
+               return 0;
+       }
+
       for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
               for (i = 0; i < hpetp->hp_ntimer; i++)
                       if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
@@ -384,6 +408,10 @@ static int hpet_fasync(int fd, struct file *file, int on)
 {
       struct hpet_dev *devp;

+       int r = hpet_alloc_timer(file);
+       if (r < 0)
+               return r;
+
       devp = file->private_data;

       if (fasync_helper(fd, file, on, &devp->hd_async_queue) >= 0)
@@ -401,6 +429,9 @@ static int hpet_release(struct inode *inode,
struct file *file)
       devp = file->private_data;
       timer = devp->hd_timer;

+       if (!timer)
+               goto out;
+
       spin_lock_irq(&hpet_lock);

       writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
@@ -425,7 +456,7 @@ static int hpet_release(struct inode *inode,
struct file *file)

       if (irq)
               free_irq(irq, devp);
-
+out:
       file->private_data = NULL;
       return 0;
 }
@@ -438,6 +469,17 @@ hpet_ioctl(struct inode *inode, struct file
*file, unsigned int cmd,
 {
       struct hpet_dev *devp;

+       switch (cmd) {
+       case HPET_INFO:
+               break;
+       default:
+               {
+                       int r = hpet_alloc_timer(file);
+                       if (r < 0)
+                               return r;
+               }
+       }
+
       devp = file->private_data;
       return hpet_ioctl_common(devp, cmd, arg, 0);
 }
@@ -570,6 +612,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd,
unsigned long arg, int kernel)
               break;
       case HPET_IE_ON:
               return hpet_ioctl_ieon(devp);
+       case HPET_ALLOC_TIMER:
+               /* nothing to do */
+               return 0;
       default:
               return -EINVAL;
       }
@@ -598,10 +643,16 @@ hpet_ioctl_common(struct hpet_dev *devp, int
cmd, unsigned long arg, int kernel)
                                       hpet_time_div(hpetp, devp->hd_ireqfreq);
                       else
                               info.hi_ireqfreq = 0;
-                       info.hi_flags =
-                           readq(&timer->hpet_config) & Tn_PER_INT_CAP_MASK;
+                       if (timer) {
+                               info.hi_flags =
+                                       readq(&timer->hpet_config) &
+                                       Tn_PER_INT_CAP_MASK;
+                               info.hi_timer = devp - hpetp->hp_dev;
+                       } else {
+                               info.hi_flags = 0;
+                               info.hi_timer = -1;
+                       }
                       info.hi_hpet = hpetp->hp_which;
-                       info.hi_timer = devp - hpetp->hp_dev;
                       if (kernel)
                               memcpy((void *)arg, &info, sizeof(info));
                       else
@@ -794,7 +845,11 @@ int hpet_alloc(struct hpet_data *hdp)
               return 0;
       }

-       siz = sizeof(struct hpets) + ((hdp->hd_nirqs - 1) *
+       /*
+        * last hpet_dev will have null timer pointer, gives timer-neutral
+        * representation of block
+        */
+       siz = sizeof(struct hpets) + ((hdp->hd_nirqs) *
                                     sizeof(struct hpet_dev));

       hpetp = kzalloc(siz, GFP_KERNEL);
@@ -860,13 +915,16 @@ int hpet_alloc(struct hpet_data *hdp)
               writeq(mcfg, &hpet->hpet_config);
       }

-       for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer; i++, devp++) {
+       for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer + 1;
+            i++, devp++) {
               struct hpet_timer __iomem *timer;

-               timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
-
               devp->hd_hpets = hpetp;
               devp->hd_hpet = hpet;
+               if (i == hpetp->hp_ntimer)
+                       continue;
+
+               timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
               devp->hd_timer = timer;

               /*
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 219ca4f..d690c0f 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -125,6 +125,7 @@ struct hpet_info {
 #define        HPET_EPI        _IO('h', 0x04)  /* enable periodic */
 #define        HPET_DPI        _IO('h', 0x05)  /* disable periodic */
 #define        HPET_IRQFREQ    _IOW('h', 0x6, unsigned long)   /*
IRQFREQ usec */
+#define        HPET_ALLOC_TIMER _IO('h', 0x7)

 #define MAX_HPET_TBS   8               /* maximum hpet timer blocks */
