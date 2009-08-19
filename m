Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZHSUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZHSUxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZHSUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:53:18 -0400
Received: from www84.your-server.de ([213.133.104.84]:56549 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZHSUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:53:17 -0400
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <1250714990.13476.3.camel@wall-e>
References: <1250714990.13476.3.camel@wall-e>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 22:53:09 +0200
Message-Id: <1250715189.13476.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pointer to the spinlock out of struct kfifo. Most
users in tree do not actually use a spinlock, so the few
exceptions now have to call kfifo_{get,put}_locked, which takes
an extra argument to a spinlock.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/char/nozomi.c                       |    2 
 drivers/char/sonypi.c                       |   21 ++++---
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   36 +++++++------
 drivers/media/video/meye.c                  |   35 +++++++-----
 drivers/net/wireless/libertas/main.c        |    2 
 drivers/platform/x86/fujitsu-laptop.c       |   18 +++---
 drivers/platform/x86/sony-laptop.c          |   22 ++++----
 drivers/scsi/libiscsi.c                     |    2 
 drivers/scsi/libiscsi_tcp.c                 |    2 
 drivers/scsi/libsrp.c                       |    9 +--
 drivers/usb/host/fhci.h                     |    2 
 include/linux/kfifo.h                       |   76 ++++++++++++----------------
 kernel/kfifo.c                              |   17 ++----
 net/dccp/probe.c                            |    6 +-
 14 files changed, 126 insertions(+), 124 deletions(-)

diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/char/nozomi.c linux-2.6.31-rc4-kfifo2/drivers/char/nozomi.c
--- linux-2.6.31-rc4-kfifo1/drivers/char/nozomi.c	2009-08-16 21:25:14.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/char/nozomi.c	2009-08-11 12:46:56.000000000 +0200
@@ -685,7 +685,7 @@
 
 		for (i = PORT_MDM; i < MAX_PORT; i++) {
 			kfifo_alloc(&dc->port[i].fifo_ul,
-				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC, NULL);
+				FIFO_BUFFER_SIZE_UL, GFP_ATOMIC);
 			memset(&dc->port[i].ctrl_dl, 0, sizeof(struct ctrl_dl));
 			memset(&dc->port[i].ctrl_ul, 0, sizeof(struct ctrl_ul));
 		}
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/char/sonypi.c linux-2.6.31-rc4-kfifo2/drivers/char/sonypi.c
--- linux-2.6.31-rc4-kfifo1/drivers/char/sonypi.c	2009-08-16 21:22:46.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/char/sonypi.c	2009-08-11 12:56:44.000000000 +0200
@@ -776,8 +776,9 @@
 {
 	struct sonypi_keypress kp;
 
-	while (kfifo_get(&sonypi_device.input_fifo, (unsigned char *)&kp,
-			 sizeof(kp)) == sizeof(kp)) {
+	while (kfifo_get_locked(&sonypi_device.input_fifo, (unsigned char *)&kp,
+			 sizeof(kp), &sonypi_device.input_fifo_lock)
+			== sizeof(kp)) {
 		msleep(10);
 		input_report_key(kp.dev, kp.key, 0);
 		input_sync(kp.dev);
@@ -826,8 +827,9 @@
 	if (kp.dev) {
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
-		kfifo_put(&sonypi_device.input_fifo,
-			  (unsigned char *)&kp, sizeof(kp));
+		kfifo_put_locked(&sonypi_device.input_fifo,
+			(unsigned char *)&kp, sizeof(kp),
+			&sonypi_device.input_fifo_lock);
 		schedule_work(&sonypi_device.input_work);
 	}
 }
@@ -879,7 +881,8 @@
 		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
 #endif
 
-	kfifo_put(&sonypi_device.fifo, (unsigned char *)&event, sizeof(event));
+	kfifo_put_locked(&sonypi_device.fifo, (unsigned char *)&event,
+			sizeof(event), &sonypi_device.fifo_lock);
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_device.fifo_proc_list);
 
@@ -928,7 +931,8 @@
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get(&sonypi_device.fifo, &c, sizeof(c)) == sizeof(c))) {
+	       (kfifo_get_locked(&sonypi_device.fifo, &c, sizeof(c),
+				 &sonypi_device.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
 		ret++;
@@ -1312,8 +1316,7 @@
 			"http://www.linux.it/~malattia/wiki/index.php/Sony_drivers\n");
 
 	spin_lock_init(&sonypi_device.fifo_lock);
-	error = kfifo_alloc(&sonypi_device.fifo, SONYPI_BUF_SIZE, GFP_KERNEL,
-					 &sonypi_device.fifo_lock);
+	error = kfifo_alloc(&sonypi_device.fifo, SONYPI_BUF_SIZE, GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
 		return error;
@@ -1393,7 +1396,7 @@
 
 		spin_lock_init(&sonypi_device.input_fifo_lock);
 		error = kfifo_alloc(&sonypi_device.input_fifo, SONYPI_BUF_SIZE,
-				GFP_KERNEL, &sonypi_device.input_fifo_lock);
+				GFP_KERNEL);
 		if (error) {
 			printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
 			goto err_inpdev_unregister;
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/infiniband/hw/cxgb3/cxio_resource.c linux-2.6.31-rc4-kfifo2/drivers/infiniband/hw/cxgb3/cxio_resource.c
--- linux-2.6.31-rc4-kfifo1/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-08-16 21:20:12.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/infiniband/hw/cxgb3/cxio_resource.c	2009-08-11 12:47:57.000000000 +0200
@@ -55,7 +55,7 @@
 	u32 rarray[16];
 	spin_lock_init(fifo_lock);
 
-	if (kfifo_alloc(fifo, nr * sizeof(u32), GFP_KERNEL, fifo_lock))
+	if (kfifo_alloc(fifo, nr * sizeof(u32), GFP_KERNEL))
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
@@ -86,7 +86,8 @@
 			__kfifo_put(fifo, (unsigned char *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_get(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_get_locked(fifo, (unsigned char *) &entry,
+				sizeof(u32), fifo_lock);
 	return 0;
 }
 
@@ -113,8 +114,7 @@
 	spin_lock_init(&rdev_p->rscp->qpid_fifo_lock);
 
 	if (kfifo_alloc(&rdev_p->rscp->qpid_fifo, T3_MAX_NUM_QP * sizeof(u32),
-					      GFP_KERNEL,
-					      &rdev_p->rscp->qpid_fifo_lock))
+					      GFP_KERNEL))
 		return -ENOMEM;
 
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
@@ -177,33 +177,37 @@
 /*
  * returns 0 if no resource available
  */
-static u32 cxio_hal_get_resource(struct kfifo *fifo)
+static u32 cxio_hal_get_resource(struct kfifo *fifo, spinlock_t * lock)
 {
 	u32 entry;
-	if (kfifo_get(fifo, (unsigned char *) &entry, sizeof(u32)))
+	if (kfifo_get_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock))
 		return entry;
 	else
 		return 0;	/* fifo emptry */
 }
 
-static void cxio_hal_put_resource(struct kfifo *fifo, u32 entry)
+static void cxio_hal_put_resource(struct kfifo *fifo, spinlock_t * lock,
+		u32 entry)
 {
-	BUG_ON(kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32)) == 0);
+	BUG_ON(
+	kfifo_put_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock)
+	== 0);
 }
 
 u32 cxio_hal_get_stag(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(&rscp->tpt_fifo);
+	return cxio_hal_get_resource(&rscp->tpt_fifo, &rscp->tpt_fifo_lock);
 }
 
 void cxio_hal_put_stag(struct cxio_hal_resource *rscp, u32 stag)
 {
-	cxio_hal_put_resource(&rscp->tpt_fifo, stag);
+	cxio_hal_put_resource(&rscp->tpt_fifo, &rscp->tpt_fifo_lock, stag);
 }
 
 u32 cxio_hal_get_qpid(struct cxio_hal_resource *rscp)
 {
-	u32 qpid = cxio_hal_get_resource(&rscp->qpid_fifo);
+	u32 qpid = cxio_hal_get_resource(&rscp->qpid_fifo,
+			&rscp->qpid_fifo_lock);
 	PDBG("%s qpid 0x%x\n", __func__, qpid);
 	return qpid;
 }
@@ -211,27 +215,27 @@
 void cxio_hal_put_qpid(struct cxio_hal_resource *rscp, u32 qpid)
 {
 	PDBG("%s qpid 0x%x\n", __func__, qpid);
-	cxio_hal_put_resource(&rscp->qpid_fifo, qpid);
+	cxio_hal_put_resource(&rscp->qpid_fifo, &rscp->qpid_fifo_lock, qpid);
 }
 
 u32 cxio_hal_get_cqid(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(&rscp->cqid_fifo);
+	return cxio_hal_get_resource(&rscp->cqid_fifo, &rscp->cqid_fifo_lock);
 }
 
 void cxio_hal_put_cqid(struct cxio_hal_resource *rscp, u32 cqid)
 {
-	cxio_hal_put_resource(&rscp->cqid_fifo, cqid);
+	cxio_hal_put_resource(&rscp->cqid_fifo, &rscp->cqid_fifo_lock, cqid);
 }
 
 u32 cxio_hal_get_pdid(struct cxio_hal_resource *rscp)
 {
-	return cxio_hal_get_resource(&rscp->pdid_fifo);
+	return cxio_hal_get_resource(&rscp->pdid_fifo, &rscp->pdid_fifo_lock);
 }
 
 void cxio_hal_put_pdid(struct cxio_hal_resource *rscp, u32 pdid)
 {
-	cxio_hal_put_resource(&rscp->pdid_fifo, pdid);
+	cxio_hal_put_resource(&rscp->pdid_fifo, &rscp->pdid_fifo_lock, pdid);
 }
 
 void cxio_hal_destroy_resource(struct cxio_hal_resource *rscp)
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/media/video/meye.c linux-2.6.31-rc4-kfifo2/drivers/media/video/meye.c
--- linux-2.6.31-rc4-kfifo1/drivers/media/video/meye.c	2009-08-16 21:14:20.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/media/video/meye.c	2009-08-09 11:40:34.000000000 +0200
@@ -799,8 +799,8 @@
 		return IRQ_HANDLED;
 
 	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
-		if (kfifo_get(&meye.grabq, (unsigned char *)&reqnr,
-			      sizeof(int)) != sizeof(int)) {
+		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			return IRQ_HANDLED;
 		}
@@ -810,7 +810,8 @@
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put(&meye.doneq, (unsigned char *)&reqnr, sizeof(int));
+		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	} else {
 		int size;
@@ -819,8 +820,8 @@
 			mchip_free_frame();
 			goto again;
 		}
-		if (kfifo_get(&meye.grabq, (unsigned char *)&reqnr,
-			      sizeof(int)) != sizeof(int)) {
+		if (kfifo_get_locked(&meye.grabq, (unsigned char *)&reqnr,
+			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			goto again;
 		}
@@ -830,7 +831,8 @@
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_put(&meye.doneq, (unsigned char *)&reqnr, sizeof(int));
+		kfifo_put_locked(&meye.doneq, (unsigned char *)&reqnr,
+				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	}
 	mchip_free_frame();
@@ -932,7 +934,8 @@
 		mchip_cont_compression_start();
 
 	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_put(&meye.grabq, (unsigned char *)nb, sizeof(int));
+	kfifo_put_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
+			 &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
 	return 0;
@@ -964,7 +967,8 @@
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		kfifo_get(&meye.doneq, (unsigned char *)&unused, sizeof(int));
+		kfifo_get_locked(&meye.doneq, (unsigned char *)&unused,
+				sizeof(int), &meye.doneq_lock);
 	}
 	*i = meye.grab_buffer[*i].size;
 	mutex_unlock(&meye.lock);
@@ -1451,7 +1455,8 @@
 	buf->flags |= V4L2_BUF_FLAG_QUEUED;
 	buf->flags &= ~V4L2_BUF_FLAG_DONE;
 	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_put(&meye.grabq, (unsigned char *)&buf->index, sizeof(int));
+	kfifo_put_locked(&meye.grabq, (unsigned char *)&buf->index,
+			sizeof(int), &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
 	return 0;
@@ -1477,8 +1482,8 @@
 		return -EINTR;
 	}
 
-	if (!kfifo_get(&meye.doneq, (unsigned char *)&reqnr,
-		       sizeof(int))) {
+	if (!kfifo_get_locked(&meye.doneq, (unsigned char *)&reqnr,
+		       sizeof(int), &meye.doneq_lock)) {
 		mutex_unlock(&meye.lock);
 		return -EBUSY;
 	}
@@ -1745,14 +1750,14 @@
 	}
 
 	spin_lock_init(&meye.grabq_lock);
-	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-				 &meye.grabq_lock)) {
+	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS,
+				GFP_KERNEL)) {
 		printk(KERN_ERR "meye: fifo allocation failed\n");
 		goto outkfifoalloc1;
 	}
 	spin_lock_init(&meye.doneq_lock);
-	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS, GFP_KERNEL,
-				 &meye.doneq_lock)) {
+	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS,
+				GFP_KERNEL)) {
 		printk(KERN_ERR "meye: fifo allocation failed\n");
 		goto outkfifoalloc2;
 	}
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/net/wireless/libertas/main.c linux-2.6.31-rc4-kfifo2/drivers/net/wireless/libertas/main.c
--- linux-2.6.31-rc4-kfifo1/drivers/net/wireless/libertas/main.c	2009-08-16 21:25:46.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/net/wireless/libertas/main.c	2009-08-11 12:45:53.000000000 +0200
@@ -1121,7 +1121,7 @@
 	priv->resp_len[0] = priv->resp_len[1] = 0;
 
 	/* Create the event FIFO */
-	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL, NULL);
+	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL);
 	if (ret) {
 		lbs_pr_err("Out of memory allocating event FIFO buffer\n");
 		goto out;
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/platform/x86/fujitsu-laptop.c linux-2.6.31-rc4-kfifo2/drivers/platform/x86/fujitsu-laptop.c
--- linux-2.6.31-rc4-kfifo1/drivers/platform/x86/fujitsu-laptop.c	2009-08-16 21:01:06.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/platform/x86/fujitsu-laptop.c	2009-08-11 22:46:08.000000000 +0200
@@ -834,7 +834,7 @@
 	/* kfifo */
 	spin_lock_init(&fujitsu_hotkey->fifo_lock);
 	error = kfifo_alloc(&fujitsu_hotkey->fifo, RINGBUFFERSIZE * sizeof(int),
-			GFP_KERNEL, &fujitsu_hotkey->fifo_lock);
+			GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR "kfifo_alloc failed\n");
 		goto err_stop;
@@ -1007,9 +1007,10 @@
 				vdbg_printk(FUJLAPTOP_DBG_TRACE,
 					"Push keycode into ringbuffer [%d]\n",
 					keycode);
-				status = kfifo_put(&fujitsu_hotkey->fifo,
+				status = kfifo_put_locked(&fujitsu_hotkey->fifo,
 						   (unsigned char *)&keycode,
-						   sizeof(keycode));
+						   sizeof(keycode),
+						   &fujitsu_hotkey->fifo_lock);
 				if (status != sizeof(keycode)) {
 					vdbg_printk(FUJLAPTOP_DBG_WARN,
 					    "Could not push keycode [0x%x]\n",
@@ -1020,11 +1021,12 @@
 				}
 			} else if (keycode == 0) {
 				while ((status =
-					kfifo_get
-					(&fujitsu_hotkey->fifo, (unsigned char *)
-					 &keycode_r,
-					 sizeof
-					 (keycode_r))) == sizeof(keycode_r)) {
+					kfifo_get_locked(
+					 &fujitsu_hotkey->fifo,
+					 (unsigned char *) &keycode_r,
+					 sizeof(keycode_r),
+					 &fujitsu_hotkey->fifo_lock))
+					 == sizeof(keycode_r)) {
 					input_report_key(input, keycode_r, 0);
 					input_sync(input);
 					vdbg_printk(FUJLAPTOP_DBG_TRACE,
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/platform/x86/sony-laptop.c linux-2.6.31-rc4-kfifo2/drivers/platform/x86/sony-laptop.c
--- linux-2.6.31-rc4-kfifo1/drivers/platform/x86/sony-laptop.c	2009-08-16 21:11:55.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/platform/x86/sony-laptop.c	2009-08-11 12:49:23.000000000 +0200
@@ -300,8 +300,9 @@
 {
 	struct sony_laptop_keypress kp;
 
-	while (kfifo_get(&sony_laptop_input.fifo, (unsigned char *)&kp,
-			 sizeof(kp)) == sizeof(kp)) {
+	while (kfifo_get_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
+			sizeof(kp), &sony_laptop_input.fifo_lock)
+			== sizeof(kp)) {
 		msleep(10);
 		input_report_key(kp.dev, kp.key, 0);
 		input_sync(kp.dev);
@@ -362,8 +363,9 @@
 		/* we emit the scancode so we can always remap the key */
 		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
 		input_sync(kp.dev);
-		kfifo_put(&sony_laptop_input.fifo,
-			  (unsigned char *)&kp, sizeof(kp));
+		kfifo_put_locked(&sony_laptop_input.fifo,
+			  (unsigned char *)&kp, sizeof(kp),
+			  &sony_laptop_input.fifo_lock);
 
 		if (!work_pending(&sony_laptop_release_key_work))
 			queue_work(sony_laptop_input.wq,
@@ -386,8 +388,7 @@
 	/* kfifo */
 	spin_lock_init(&sony_laptop_input.fifo_lock);
 	error =
-	 kfifo_alloc(&sony_laptop_input.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
-			    &sony_laptop_input.fifo_lock);
+	 kfifo_alloc(&sony_laptop_input.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
 		goto err_dec_users;
@@ -2143,7 +2144,8 @@
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_get(&sonypi_compat.fifo, &c, sizeof(c)) == sizeof(c))) {
+	       (kfifo_get_locked(&sonypi_compat.fifo, &c, sizeof(c),
+			  &sonypi_compat.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
 		ret++;
@@ -2322,7 +2324,8 @@
 
 static void sonypi_compat_report_event(u8 event)
 {
-	kfifo_put(&sonypi_compat.fifo, (unsigned char *)&event, sizeof(event));
+	kfifo_put_locked(&sonypi_compat.fifo, (unsigned char *)&event,
+			sizeof(event), &sonypi_compat.fifo_lock);
 	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
 }
@@ -2333,8 +2336,7 @@
 
 	spin_lock_init(&sonypi_compat.fifo_lock);
 	error =
-	 kfifo_alloc(&sonypi_compat.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
-					 &sonypi_compat.fifo_lock);
+	 kfifo_alloc(&sonypi_compat.fifo, SONY_LAPTOP_BUF_SIZE, GFP_KERNEL);
 	if (error) {
 		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
 		return error;
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/scsi/libiscsi.c linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi.c
--- linux-2.6.31-rc4-kfifo1/drivers/scsi/libiscsi.c	2009-08-16 21:29:03.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi.c	2009-08-09 16:15:00.000000000 +0200
@@ -2121,7 +2121,7 @@
 	if (q->pool == NULL)
 		return -ENOMEM;
 
-	kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*), NULL);
+	kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*));
 
 	for (i = 0; i < max; i++) {
 		q->pool[i] = kzalloc(item_size, GFP_KERNEL);
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/scsi/libiscsi_tcp.c linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi_tcp.c
--- linux-2.6.31-rc4-kfifo1/drivers/scsi/libiscsi_tcp.c	2009-08-16 21:24:53.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/scsi/libiscsi_tcp.c	2009-08-11 22:41:11.000000000 +0200
@@ -1128,7 +1128,7 @@
 
 		/* R2T xmit queue */
 		if (kfifo_alloc(&tcp_task->r2tqueue,
-		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL, NULL)) {
+		      session->max_r2t * 4 * sizeof(void*), GFP_KERNEL)) {
 			iscsi_pool_free(&tcp_task->r2tpool);
 			goto r2t_alloc_fail;
 		}
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/scsi/libsrp.c linux-2.6.31-rc4-kfifo2/drivers/scsi/libsrp.c
--- linux-2.6.31-rc4-kfifo1/drivers/scsi/libsrp.c	2009-08-16 21:29:13.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/scsi/libsrp.c	2009-08-09 16:18:53.000000000 +0200
@@ -58,8 +58,7 @@
 		goto free_pool;
 
 	spin_lock_init(&q->lock);
-	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *),
-			      &q->lock);
+	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
 		__kfifo_put(&q->queue, (void *) &iue, sizeof(void *));
@@ -164,7 +163,8 @@
 {
 	struct iu_entry *iue = NULL;
 
-	kfifo_get(&target->iu_queue.queue, (void *) &iue, sizeof(void *));
+	kfifo_get_locked(&target->iu_queue.queue, (void *) &iue,
+			sizeof(void *), &target->iu_queue.lock);
 	if (!iue)
 		return iue;
 	iue->target = target;
@@ -176,7 +176,8 @@
 
 void srp_iu_put(struct iu_entry *iue)
 {
-	kfifo_put(&iue->target->iu_queue.queue, (void *) &iue, sizeof(void *));
+	kfifo_put_locked(&iue->target->iu_queue.queue, (void *) &iue,
+			sizeof(void *), &iue->target->iu_queue.lock);
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
 
diff -u -N -r linux-2.6.31-rc4-kfifo1/drivers/usb/host/fhci.h linux-2.6.31-rc4-kfifo2/drivers/usb/host/fhci.h
--- linux-2.6.31-rc4-kfifo1/drivers/usb/host/fhci.h	2009-08-16 21:25:35.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/drivers/usb/host/fhci.h	2009-08-11 12:46:08.000000000 +0200
@@ -495,7 +495,7 @@
 /* fifo of pointers */
 static inline int cq_new(struct kfifo *fifo, int size)
 {
-	return kfifo_alloc(fifo, size * sizeof(void *), GFP_KERNEL, NULL);
+	return kfifo_alloc(fifo, size * sizeof(void *), GFP_KERNEL);
 }
 
 static inline void cq_delete(struct kfifo *kfifo)
diff -u -N -r linux-2.6.31-rc4-kfifo1/include/linux/kfifo.h linux-2.6.31-rc4-kfifo2/include/linux/kfifo.h
--- linux-2.6.31-rc4-kfifo1/include/linux/kfifo.h	2009-08-16 22:14:30.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/include/linux/kfifo.h	2009-08-16 22:18:26.000000000 +0200
@@ -30,13 +30,12 @@
 	unsigned int size;	/* the size of the allocated buffer */
 	unsigned int in;	/* data is added at offset (in % size) */
 	unsigned int out;	/* data is extracted from off. (out % size) */
-	spinlock_t *lock;	/* protects concurrent modifications */
 };
 
 extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
-			unsigned int size, spinlock_t *lock);
+			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
-			gfp_t gfp_mask, spinlock_t *lock);
+			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int __kfifo_put(struct kfifo *fifo,
 				const unsigned char *buffer, unsigned int len);
@@ -58,58 +57,67 @@
  */
 static inline void kfifo_reset(struct kfifo *fifo)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(fifo->lock, flags);
-
 	__kfifo_reset(fifo);
+}
+
+/**
+ * __kfifo_len - returns the number of bytes available in the FIFO
+ * @fifo: the fifo to be used.
+ */
+static inline unsigned int __kfifo_len(struct kfifo *fifo)
+{
+	register unsigned int	out;
 
-	spin_unlock_irqrestore(fifo->lock, flags);
+	out = fifo->out;
+	smp_rmb();
+	return fifo->in - out;
 }
 
 /**
- * kfifo_put - puts some data into the FIFO
+ * kfifo_put_locked - puts some data into the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
- * @buffer: the data to be added.
+ * @from: the data to be added.
  * @len: the length of the data to be added.
+ * @lock: pointer to the spinlock to use for locking.
  *
- * This function copies at most @len bytes from the @buffer into
+ * This function copies at most @len bytes from the @from buffer into
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  */
-static inline unsigned int kfifo_put(struct kfifo *fifo,
-				const unsigned char *buffer, unsigned int len)
+static inline __must_check unsigned int kfifo_put_locked(struct kfifo *fifo,
+		const unsigned char *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(fifo->lock, flags);
+	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_put(fifo, buffer, len);
+	ret = __kfifo_put(fifo, from, n);
 
-	spin_unlock_irqrestore(fifo->lock, flags);
+	spin_unlock_irqrestore(lock, flags);
 
 	return ret;
 }
 
 /**
- * kfifo_get - gets some data from the FIFO
+ * kfifo_get_locked - gets some data from the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
- * @buffer: where the data must be copied.
+ * @to: where the data must be copied.
  * @len: the size of the destination buffer.
+ * @lock: pointer to the spinlock to use for locking.
  *
  * This function copies at most @len bytes from the FIFO into the
- * @buffer and returns the number of copied bytes.
+ * @to buffer and returns the number of copied bytes.
  */
-static inline unsigned int kfifo_get(struct kfifo *fifo,
-				     unsigned char *buffer, unsigned int len)
+static inline __must_check unsigned int kfifo_get_locked(struct kfifo *fifo,
+	unsigned char *to, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
 
-	spin_lock_irqsave(fifo->lock, flags);
+	spin_lock_irqsave(lock, flags);
 
-	ret = __kfifo_get(fifo, buffer, len);
+	ret = __kfifo_get(fifo, to, n);
 
 	/*
 	 * optimization: if the FIFO is empty, set the indices to 0
@@ -118,36 +126,18 @@
 	if (fifo->in == fifo->out)
 		fifo->in = fifo->out = 0;
 
-	spin_unlock_irqrestore(fifo->lock, flags);
+	spin_unlock_irqrestore(lock, flags);
 
 	return ret;
 }
 
 /**
- * __kfifo_len - returns the number of bytes available in the FIFO, no locking version
- * @fifo: the fifo to be used.
- */
-static inline unsigned int __kfifo_len(struct kfifo *fifo)
-{
-	return fifo->in - fifo->out;
-}
-
-/**
  * kfifo_len - returns the number of bytes available in the FIFO
  * @fifo: the fifo to be used.
  */
 static inline unsigned int kfifo_len(struct kfifo *fifo)
 {
-	unsigned long flags;
-	unsigned int ret;
-
-	spin_lock_irqsave(fifo->lock, flags);
-
-	ret = __kfifo_len(fifo);
-
-	spin_unlock_irqrestore(fifo->lock, flags);
-
-	return ret;
+	return __kfifo_len(fifo);
 }
 
 #endif
diff -u -N -r linux-2.6.31-rc4-kfifo1/kernel/kfifo.c linux-2.6.31-rc4-kfifo2/kernel/kfifo.c
--- linux-2.6.31-rc4-kfifo1/kernel/kfifo.c	2009-08-16 21:34:51.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/kernel/kfifo.c	2009-08-16 22:08:37.000000000 +0200
@@ -28,11 +28,10 @@
 #include <linux/log2.h>
 
 static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
-		unsigned int size, spinlock_t *lock)
+		unsigned int size)
 {
 	fifo->buffer = buffer;
 	fifo->size = size;
-	fifo->lock = lock;
 
 	kfifo_reset(fifo);
 }
@@ -42,16 +41,14 @@
  * @fifo: the fifo to assign the buffer
  * @buffer: the preallocated buffer to be used.
  * @size: the size of the internal buffer, this have to be a power of 2.
- * @lock: the lock to be used to protect the fifo buffer
  *
  */
-void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size,
-			spinlock_t *lock)
+void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
 {
 	/* size must be a power of 2 */
 	BUG_ON(!is_power_of_2(size));
 
-	_kfifo_init(fifo, buffer, size, lock);
+	_kfifo_init(fifo, buffer, size);
 }
 EXPORT_SYMBOL(kfifo_init);
 
@@ -60,7 +57,6 @@
  * @fifo: the fifo to assign then new buffer
  * @size: the size of the buffer to be allocated, this have to be a power of 2.
  * @gfp_mask: get_free_pages mask, passed to kmalloc()
- * @lock: the lock to be used to protect the fifo buffer
  *
  * This function dynamically allocates a new fifo internal buffer
  *
@@ -68,8 +64,7 @@
  * The buffer will be release with kfifo_free().
  * Return 0 if no error, otherwise the an error code
  */
-int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask,
-			spinlock_t *lock)
+int kfifo_alloc(struct kfifo *fifo, unsigned int size, gfp_t gfp_mask)
 {
 	unsigned char *buffer;
 
@@ -84,11 +79,11 @@
 
 	buffer = kmalloc(size, gfp_mask);
 	if (!buffer) {
-		_kfifo_init(fifo, 0, 0, NULL);
+		_kfifo_init(fifo, 0, 0);
 		return -ENOMEM;
 	}
 
-	_kfifo_init(fifo, buffer, size, lock);
+	_kfifo_init(fifo, buffer, size);
 
 	return 0;
 }
diff -u -N -r linux-2.6.31-rc4-kfifo1/net/dccp/probe.c linux-2.6.31-rc4-kfifo2/net/dccp/probe.c
--- linux-2.6.31-rc4-kfifo1/net/dccp/probe.c	2009-08-16 21:24:04.000000000 +0200
+++ linux-2.6.31-rc4-kfifo2/net/dccp/probe.c	2009-08-11 12:50:28.000000000 +0200
@@ -67,7 +67,7 @@
 	len += vscnprintf(tbuf+len, sizeof(tbuf)-len, fmt, args);
 	va_end(args);
 
-	kfifo_put(&dccpw.fifo, tbuf, len);
+	kfifo_put_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	wake_up(&dccpw.wait);
 }
 
@@ -136,7 +136,7 @@
 	if (error)
 		goto out_free;
 
-	cnt = kfifo_get(&dccpw.fifo, tbuf, len);
+	cnt = kfifo_get_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
 	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:
@@ -157,7 +157,7 @@
 
 	init_waitqueue_head(&dccpw.wait);
 	spin_lock_init(&dccpw.lock);
-	if (kfifo_alloc(&dccpw.fifo, bufsize, GFP_KERNEL, &dccpw.lock))
+	if (kfifo_alloc(&dccpw.fifo, bufsize, GFP_KERNEL))
 		return ret;
 	if (!proc_net_fops_create(&init_net, procname, S_IRUSR, &dccpprobe_fops))
 		goto err0;


