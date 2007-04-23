Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXDWHMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXDWHMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXDWHMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:12:36 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:35952
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753395AbXDWHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:12:35 -0400
Date: Mon, 23 Apr 2007 09:15:37 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: emoenke@gwdg.de, minyard@wf-rch.cirr.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] use mutex instead of binary semaphore in CDU-31A driver
Message-ID: <20070423071537.GA10339@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	emoenke@gwdg.de, minyard@wf-rch.cirr.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use mutex instead of binary semaphore in CDU-31A driver

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/cdrom/cdu31a.c b/drivers/cdrom/cdu31a.c
index 2157c58..d3649e4 100644
--- a/drivers/cdrom/cdu31a.c
+++ b/drivers/cdrom/cdu31a.c
@@ -263,7 +263,7 @@ static int sony_toc_read = 0;	/* Has the TOC been read for
 static struct s_sony_subcode last_sony_subcode;	/* Points to the last
 						   subcode address read */
 
-static DECLARE_MUTEX(sony_sem);		/* Semaphore for drive hardware access */
+static DEFINE_MUTEX(sony_mtx);		/* Mutex for drive hardware access */
 
 static int is_double_speed = 0;	/* does the drive support double speed ? */
 
@@ -339,11 +339,11 @@ static int scd_drive_status(struct cdrom_device_info *cdi, int slot_nr)
 		return -EINVAL;
 	if (sony_spun_up)
 		return CDS_DISC_OK;
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	if (scd_spinup() == 0)
 		sony_spun_up = 1;
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return sony_spun_up ? CDS_DISC_OK : CDS_DRIVE_NOT_READY;
 }
 
@@ -452,7 +452,7 @@ static int scd_reset(struct cdrom_device_info *cdi)
 {
 	unsigned long retry_count;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	reset_drive();
 
@@ -461,7 +461,7 @@ static int scd_reset(struct cdrom_device_info *cdi)
 		sony_sleep();
 	}
 
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return 0;
 }
 
@@ -655,10 +655,10 @@ static int scd_select_speed(struct cdrom_device_info *cdi, int speed)
 	else
 		sony_speed = speed - 1;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	set_drive_params(sony_speed);
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return 0;
 }
 
@@ -673,10 +673,10 @@ static int scd_lock_door(struct cdrom_device_info *cdi, int lock)
 	} else {
 		is_auto_eject = 0;
 	}
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	set_drive_params(sony_speed);
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return 0;
 }
 
@@ -1143,7 +1143,7 @@ static void handle_abort_timeout(unsigned long data)
 {
 	pr_debug(PFX "Entering %s\n", __FUNCTION__);
 	/* If it is in use, ignore it. */
-	if (down_trylock(&sony_sem) == 0) {
+	if (mutex_trylock(&sony_mtx) == 0) {
 		/* We can't use abort_read(), because it will sleep
 		   or schedule in the timer interrupt.  Just start
 		   the operation, finish it on the next access to
@@ -1154,7 +1154,7 @@ static void handle_abort_timeout(unsigned long data)
 
 		sony_blocks_left = 0;
 		abort_read_started = 1;
-		up(&sony_sem);
+		mutex_unlock(&sony_mtx);
 	}
 	pr_debug(PFX "Leaving %s\n", __FUNCTION__);
 }
@@ -1300,7 +1300,7 @@ static void do_cdu31a_request(request_queue_t * q)
 	pr_debug(PFX "Entering %s\n", __FUNCTION__);
 
 	spin_unlock_irq(q->queue_lock);
-	if (down_interruptible(&sony_sem)) {
+	if (mutex_lock_interruptible(&sony_mtx)) {
 		spin_lock_irq(q->queue_lock);
 		return;
 	}
@@ -1435,7 +1435,7 @@ static void do_cdu31a_request(request_queue_t * q)
 	add_timer(&cdu31a_abort_timer);
 #endif
 
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	spin_lock_irq(q->queue_lock);
 	pr_debug(PFX "Leaving %s at %d\n", __FUNCTION__, __LINE__);
 }
@@ -1906,10 +1906,10 @@ static int scd_get_last_session(struct cdrom_device_info *cdi,
 		return 1;
 
 	if (!sony_toc_read) {
-		if (down_interruptible(&sony_sem))
+		if (mutex_lock_interruptible(&sony_mtx))
 			return -ERESTARTSYS;
 		sony_get_toc();
-		up(&sony_sem);
+		mutex_unlock(&sony_mtx);
 	}
 
 	ms_info->addr_format = CDROM_LBA;
@@ -1988,11 +1988,11 @@ scd_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 	unsigned int res_size;
 
 	memset(mcn->medium_catalog_number, 0, 14);
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	do_sony_cd_cmd(SONY_REQ_UPC_EAN_CMD,
 		       NULL, 0, resbuffer, &res_size);
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	if ((res_size < 2) || ((resbuffer[0] & 0xf0) == 0x20));
 	else {
 		/* packed bcd to single ASCII digits */
@@ -2207,7 +2207,7 @@ static int read_audio(struct cdrom_read_audio *ra)
 	unsigned int res_size;
 	unsigned int cframe;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	if (!sony_spun_up)
 		scd_spinup();
@@ -2343,7 +2343,7 @@ static int read_audio(struct cdrom_read_audio *ra)
 	}
 
  out_up:
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 
 	return retval;
 }
@@ -2373,7 +2373,7 @@ static int scd_tray_move(struct cdrom_device_info *cdi, int position)
 {
 	int retval;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	if (position == 1 /* open tray */ ) {
 		unsigned char res_reg[12];
@@ -2392,7 +2392,7 @@ static int scd_tray_move(struct cdrom_device_info *cdi, int position)
 			sony_spun_up = 1;
 		retval = 0;
 	}
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return retval;
 }
 
@@ -2407,7 +2407,7 @@ static int scd_audio_ioctl(struct cdrom_device_info *cdi,
 	unsigned char params[7];
 	int i, retval;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	switch (cmd) {
 	case CDROMSTART:	/* Spin up the drive */
@@ -2665,7 +2665,7 @@ static int scd_audio_ioctl(struct cdrom_device_info *cdi,
 		retval = -EINVAL;
 		break;
 	}
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return retval;
 }
 
@@ -2675,7 +2675,7 @@ static int scd_read_audio(struct cdrom_device_info *cdi,
 	void __user *argp = (void __user *)arg;
 	int retval;
 
-	if (down_interruptible(&sony_sem))
+	if (mutex_lock_interruptible(&sony_mtx))
 		return -ERESTARTSYS;
 	switch (cmd) {
 	case CDROMREADAUDIO:	/* Read 2352 byte audio tracks and 2340 byte
@@ -2749,7 +2749,7 @@ static int scd_read_audio(struct cdrom_device_info *cdi,
 	default:
 		retval = -EINVAL;
 	}
-	up(&sony_sem);
+	mutex_unlock(&sony_mtx);
 	return retval;
 }
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

            Nothing is more despicable than respect based on fear
                              (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
