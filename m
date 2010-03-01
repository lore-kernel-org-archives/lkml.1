Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0CAUYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:24:22 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:59638 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0CAUYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:cc:in-reply-to;
        b=r49fheBgVUfkocckzFS7FWA26coCGmRn42K9+1sXyYVxku+YRVzPqJ0KoDao5Q29eC
         uT3JIUtjgevtK2hav617PKBvVI9Qn1gi7Yg4mVIaQoVXuHHPAolaa0kmZmeVNSSuuPua
         tdkik7k7dS8GCZdMzyuV0lhcEJMae8Ai/yyI4=
Message-ID: <4b8c226e.0aa1660a.67e2.6fdc@mx.google.com>
Date: Mon, 01 Mar 2010 12:24:14 -0800 (PST)
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>,
       "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>,
       Vojtech Pavlik <vojtech@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B8B901E.4050302@ladisch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Many thanks; I had planned to do something like this, but never found
> the time.

You're welcome. It's not completely coincidental: I read an old discussion
you had with someone else trying to solve this problem and this is the method
you recommended.

> This driver was written before the high-resolution timer API was
> available, so the only actual use case, besides backwards compatibility,
> is the ability to read the timer register directly without a syscall.
>
> A ioctl to read the main counter would just duplicate clock_gettime(),
> but I cannot see any benefit over that.

In fact for my situation I attempted using clock_gettime first and found it
unsuitable. Specifically, my case is finding a substitute for RDTSC as a
constant-rate counter for use in correcting real-time clock drift. This is for
a CPU without constant TSC, as many are; and I was patching DJ Bernstein's
excellent program clockspeed to be workable in such a case.

Calculating the real time tick rate of clock_gettime using CLOCK_MONOTONIC
suspiciously yielded a rate almost exactly 1GHz, which seemed to imply some
feedback relative to real time was happening and thus wouldn't be reliably
constant rate in the face of slewing the clock. Whatever the reason, in fact
it wasn't and trying to depend on it as a constant rate timer while using
adjtime quickly led to inaccuracies... Which led me to HPET as a solution,
which worked swimmingly.

I do now see there's another clockid, CLOCK_MONOTONIC_RAW, whose name implies
it might work for me. I'll try it and see.

> Your mailer killed tabs and wrapped lines.

Whoops. Here I'm resubmitting the patch, avoiding the Gmail web client.

Signed-off-by: Magnus Lynch <maglyx@gmail.com>

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e481c59..8991227 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -244,16 +244,40 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 
 static int hpet_open(struct inode *inode, struct file *file)
 {
-	struct hpet_dev *devp;
 	struct hpets *hpetp;
-	int i;
 
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
+	hpetp = hpets;
+	/* starting with timer-neutral instance */
+	file->private_data = &hpetp->hp_dev[hpetp->hp_ntimer];
+
+	return 0;
+}
+
+static int hpet_alloc_timer(struct file *file)
+{
+	struct hpet_dev *devp;
+	struct hpets *hpetp;
+	int i;
+
+	/* once acquired, will remain */
+	devp = file->private_data;
+	if (devp->hd_timer)
+		return 0;
+
 	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
+	/* check for race acquiring */
+	devp = file->private_data;
+	if (devp->hd_timer) {
+		spin_unlock_irq(&hpet_lock);
+		unlock_kernel();
+		return 0;
+	}
+
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
 			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
@@ -384,6 +408,10 @@ static int hpet_fasync(int fd, struct file *file, int on)
 {
 	struct hpet_dev *devp;
 
+	int r = hpet_alloc_timer(file);
+	if (r < 0)
+		return r;
+
 	devp = file->private_data;
 
 	if (fasync_helper(fd, file, on, &devp->hd_async_queue) >= 0)
@@ -401,6 +429,9 @@ static int hpet_release(struct inode *inode, struct file *file)
 	devp = file->private_data;
 	timer = devp->hd_timer;
 
+	if (!timer)
+		goto out;
+
 	spin_lock_irq(&hpet_lock);
 
 	writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
@@ -425,7 +456,7 @@ static int hpet_release(struct inode *inode, struct file *file)
 
 	if (irq)
 		free_irq(irq, devp);
-
+out:
 	file->private_data = NULL;
 	return 0;
 }
@@ -438,6 +469,17 @@ hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 {
 	struct hpet_dev *devp;
 
+	switch (cmd) {
+	case HPET_INFO:
+		break;
+	default:
+		{
+			int r = hpet_alloc_timer(file);
+			if (r < 0)
+				return r;
+		}
+	}
+
 	devp = file->private_data;
 	return hpet_ioctl_common(devp, cmd, arg, 0);
 }
@@ -570,6 +612,9 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 		break;
 	case HPET_IE_ON:
 		return hpet_ioctl_ieon(devp);
+	case HPET_ALLOC_TIMER:
+		/* nothing to do */
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -598,10 +643,16 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
 					hpet_time_div(hpetp, devp->hd_ireqfreq);
 			else
 				info.hi_ireqfreq = 0;
-			info.hi_flags =
-			    readq(&timer->hpet_config) & Tn_PER_INT_CAP_MASK;
+			if (timer) {
+				info.hi_flags =
+					readq(&timer->hpet_config) &
+					Tn_PER_INT_CAP_MASK;
+				info.hi_timer = devp - hpetp->hp_dev;
+			} else {
+				info.hi_flags = 0;
+				info.hi_timer = -1;
+			}
 			info.hi_hpet = hpetp->hp_which;
-			info.hi_timer = devp - hpetp->hp_dev;
 			if (kernel)
 				memcpy((void *)arg, &info, sizeof(info));
 			else
@@ -794,7 +845,11 @@ int hpet_alloc(struct hpet_data *hdp)
 		return 0;
 	}
 
-	siz = sizeof(struct hpets) + ((hdp->hd_nirqs - 1) *
+	/*
+	 * last hpet_dev will have null timer pointer, gives timer-neutral
+	 * representation of block
+	 */
+	siz = sizeof(struct hpets) + ((hdp->hd_nirqs) *
 				      sizeof(struct hpet_dev));
 
 	hpetp = kzalloc(siz, GFP_KERNEL);
@@ -860,13 +915,16 @@ int hpet_alloc(struct hpet_data *hdp)
 		writeq(mcfg, &hpet->hpet_config);
 	}
 
-	for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer; i++, devp++) {
+	for (i = 0, devp = hpetp->hp_dev; i < hpetp->hp_ntimer + 1;
+	     i++, devp++) {
 		struct hpet_timer __iomem *timer;
 
-		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
-
 		devp->hd_hpets = hpetp;
 		devp->hd_hpet = hpet;
+		if (i == hpetp->hp_ntimer)
+			continue;
+
+		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
 		devp->hd_timer = timer;
 
 		/*
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 219ca4f..d690c0f 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -125,6 +125,7 @@ struct hpet_info {
 #define	HPET_EPI	_IO('h', 0x04)	/* enable periodic */
 #define	HPET_DPI	_IO('h', 0x05)	/* disable periodic */
 #define	HPET_IRQFREQ	_IOW('h', 0x6, unsigned long)	/* IRQFREQ usec */
+#define	HPET_ALLOC_TIMER _IO('h', 0x7)
 
 #define MAX_HPET_TBS	8		/* maximum hpet timer blocks */
 
