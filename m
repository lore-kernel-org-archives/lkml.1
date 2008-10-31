Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYJaX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYJaX2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 19:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYJaX2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 19:28:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52342 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYJaX2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 19:28:32 -0400
Date: Fri, 31 Oct 2008 23:28:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC][PATCH] saner FASYNC handling on file close
Message-ID: <20081031232830.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	As it is, all instances of ->release() for files that have
->fasync() need to remember to evict file from fasync lists; forgetting
that creates a hole and we actually have a bunch that *does* forget.

	So let's keep our lives simple - let __fput() check FASYNC in
file->f_flags and call ->fasync() there if it's been set.  And lose
that crap in ->release() instances - leaving it there is still valid,
but we don't have to bother anymore.

Comments?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index ada4605..6543a55 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -1995,11 +1995,6 @@ pfm_close(struct inode *inode, struct file *filp)
 		return -EBADF;
 	}
 
-	if (filp->f_flags & FASYNC) {
-		DPRINT(("cleaning up async_queue=%p\n", ctx->ctx_async_queue));
-		pfm_do_fasync(-1, filp, ctx, 0);
-	}
-
 	PROTECT_CTX(ctx, flags);
 
 	state     = ctx->ctx_state;
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 408f5f9..53fdc7f 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -427,9 +427,6 @@ static int hpet_release(struct inode *inode, struct file *file)
 	if (irq)
 		free_irq(irq, devp);
 
-	if (file->f_flags & FASYNC)
-		hpet_fasync(-1, file, 0);
-
 	file->private_data = NULL;
 	return 0;
 }
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 1d7b429..41fc11d 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -162,8 +162,6 @@ static int ipmi_release(struct inode *inode, struct file *file)
 	if (rv)
 		return rv;
 
-	ipmi_fasync (-1, file, 0);
-
 	/* FIXME - free the messages in the list. */
 	kfree(priv);
 
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 235fab0..a4d57e3 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -870,7 +870,6 @@ static int ipmi_close(struct inode *ino, struct file *filep)
 		clear_bit(0, &ipmi_wdog_open);
 	}
 
-	ipmi_fasync(-1, filep, 0);
 	expect_close = 0;
 
 	return 0;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 705a839..675076f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1139,18 +1139,12 @@ static int random_fasync(int fd, struct file *filp, int on)
 	return fasync_helper(fd, filp, on, &fasync);
 }
 
-static int random_release(struct inode *inode, struct file *filp)
-{
-	return fasync_helper(-1, filp, 0, &fasync);
-}
-
 const struct file_operations random_fops = {
 	.read  = random_read,
 	.write = random_write,
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
-	.release = random_release,
 };
 
 const struct file_operations urandom_fops = {
@@ -1158,7 +1152,6 @@ const struct file_operations urandom_fops = {
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
-	.release = random_release,
 };
 
 /***************************************************************
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 32dc897..20d6efb 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -788,8 +788,6 @@ static int rtc_release(struct inode *inode, struct file *file)
 	}
 	spin_unlock_irq(&rtc_lock);
 
-	if (file->f_flags & FASYNC)
-		rtc_fasync(-1, file, 0);
 no_irq:
 #endif
 
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 85e0eb7..2457b07 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -898,7 +898,6 @@ static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 
 static int sonypi_misc_release(struct inode *inode, struct file *file)
 {
-	sonypi_misc_fasync(-1, file, 0);
 	mutex_lock(&sonypi_device.lock);
 	sonypi_device.open_count--;
 	mutex_unlock(&sonypi_device.lock);
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 0d46627..78eeed5 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -406,8 +406,6 @@ int drm_release(struct inode *inode, struct file *filp)
 	if (dev->driver->driver_features & DRIVER_GEM)
 		drm_gem_release(dev, file_priv);
 
-	drm_fasync(-1, filp, 0);
-
 	mutex_lock(&dev->ctxlist_mutex);
 	if (!list_empty(&dev->ctxlist)) {
 		struct drm_ctx_list *pos, *n;
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 3ac3207..83e851a 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -242,8 +242,6 @@ static int hiddev_release(struct inode * inode, struct file * file)
 	struct hiddev_list *list = file->private_data;
 	unsigned long flags;
 
-	hiddev_fasync(-1, file, 0);
-
 	spin_lock_irqsave(&list->hiddev->list_lock, flags);
 	list_del(&list->node);
 	spin_unlock_irqrestore(&list->hiddev->list_lock, flags);
diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index 2f83543..965cfdb 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -1828,9 +1828,6 @@ static int dv1394_release(struct inode *inode, struct file *file)
 	/* OK to free the DMA buffer, no more mappings can exist */
 	do_dv1394_shutdown(video, 1);
 
-	/* clean up async I/O users */
-	dv1394_fasync(-1, file, 0);
-
 	/* give someone else a turn */
 	clear_bit(0, &video->open);
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index d85af1b..eb36a81 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -358,8 +358,6 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 	}
 	spin_unlock_irq(&file->lock);
 
-	ib_uverbs_event_fasync(-1, filp, 0);
-
 	if (file->is_async) {
 		ib_unregister_event_handler(&file->uverbs_file->event_handler);
 		kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 3524bef..1070db3 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -235,7 +235,6 @@ static int evdev_release(struct inode *inode, struct file *file)
 		evdev_ungrab(evdev, client);
 	mutex_unlock(&evdev->mutex);
 
-	evdev_fasync(-1, file, 0);
 	evdev_detach_client(evdev, client);
 	kfree(client);
 
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 65d7077..a85b148 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -244,7 +244,6 @@ static int joydev_release(struct inode *inode, struct file *file)
 	struct joydev_client *client = file->private_data;
 	struct joydev *joydev = client->joydev;
 
-	joydev_fasync(-1, file, 0);
 	joydev_detach_client(joydev, client);
 	kfree(client);
 
diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index 82ec6b1..216a559 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -71,7 +71,6 @@ static int hp_sdc_rtc_ioctl(struct inode *inode, struct file *file,
 static unsigned int hp_sdc_rtc_poll(struct file *file, poll_table *wait);
 
 static int hp_sdc_rtc_open(struct inode *inode, struct file *file);
-static int hp_sdc_rtc_release(struct inode *inode, struct file *file);
 static int hp_sdc_rtc_fasync (int fd, struct file *filp, int on);
 
 static int hp_sdc_rtc_read_proc(char *page, char **start, off_t off,
@@ -414,17 +413,6 @@ static int hp_sdc_rtc_open(struct inode *inode, struct file *file)
         return 0;
 }
 
-static int hp_sdc_rtc_release(struct inode *inode, struct file *file)
-{
-	/* Turn off interrupts? */
-
-        if (file->f_flags & FASYNC) {
-                hp_sdc_rtc_fasync (-1, file, 0);
-        }
-
-        return 0;
-}
-
 static int hp_sdc_rtc_fasync (int fd, struct file *filp, int on)
 {
         return fasync_helper (fd, filp, on, &hp_sdc_rtc_async_queue);
@@ -680,7 +668,6 @@ static const struct file_operations hp_sdc_rtc_fops = {
         .poll =		hp_sdc_rtc_poll,
         .ioctl =	hp_sdc_rtc_ioctl,
         .open =		hp_sdc_rtc_open,
-        .release =	hp_sdc_rtc_release,
         .fasync =	hp_sdc_rtc_fasync,
 };
 
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 8137e50..d8c056f 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -519,7 +519,6 @@ static int mousedev_release(struct inode *inode, struct file *file)
 	struct mousedev_client *client = file->private_data;
 	struct mousedev *mousedev = client->mousedev;
 
-	mousedev_fasync(-1, file, 0);
 	mousedev_detach_client(mousedev, client);
 	kfree(client);
 
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 470770c..06bbd0e 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -135,7 +135,6 @@ static int serio_raw_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&serio_raw_mutex);
 
-	serio_raw_fasync(-1, file, 0);
 	serio_raw_cleanup(serio_raw);
 
 	mutex_unlock(&serio_raw_mutex);
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index f5233f3..b89f476 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -559,12 +559,6 @@ mptctl_fasync(int fd, struct file *filep, int mode)
 	return ret;
 }
 
-static int
-mptctl_release(struct inode *inode, struct file *filep)
-{
-	return fasync_helper(-1, filep, 0, &async_queue);
-}
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *  MPT ioctl handler
@@ -2706,7 +2700,6 @@ mptctl_hp_targetinfo(unsigned long arg)
 static const struct file_operations mptctl_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.release =	mptctl_release,
 	.fasync = 	mptctl_fasync,
 	.unlocked_ioctl = mptctl_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index a3fabdb..f3384c3 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -1097,28 +1097,17 @@ static int cfg_fasync(int fd, struct file *fp, int on)
 static int cfg_release(struct inode *inode, struct file *file)
 {
 	ulong id = (ulong) file->private_data;
-	struct i2o_cfg_info *p1, *p2;
+	struct i2o_cfg_info *p, **q;
 	unsigned long flags;
 
 	lock_kernel();
-	p1 = p2 = NULL;
-
 	spin_lock_irqsave(&i2o_config_lock, flags);
-	for (p1 = open_files; p1;) {
-		if (p1->q_id == id) {
-
-			if (p1->fasync)
-				cfg_fasync(-1, file, 0);
-			if (p2)
-				p2->next = p1->next;
-			else
-				open_files = p1->next;
-
-			kfree(p1);
+	for (q = &open_files; (p = *q) != NULL; q = &p->next) {
+		if (p->q_id == id) {
+			*q = p->next;
+			kfree(p);
 			break;
 		}
-		p2 = p1;
-		p1 = p1->next;
 	}
 	spin_unlock_irqrestore(&i2o_config_lock, flags);
 	unlock_kernel();
diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index f483c42..06f07e1 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -1920,7 +1920,6 @@ static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 
 static int sonypi_misc_release(struct inode *inode, struct file *file)
 {
-	sonypi_misc_fasync(-1, file, 0);
 	atomic_dec(&sonypi_compat.open_count);
 	return 0;
 }
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6daea0c..33b6d1b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1070,8 +1070,6 @@ static int tun_chr_close(struct inode *inode, struct file *file)
 
 	DBG(KERN_INFO "%s: tun_chr_close\n", tun->dev->name);
 
-	tun_chr_fasync(-1, file, 0);
-
 	rtnl_lock();
 
 	/* Detach from net device */
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 079e9ed..ecdea44 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -446,9 +446,6 @@ static int rtc_dev_release(struct inode *inode, struct file *file)
 	if (rtc->ops->release)
 		rtc->ops->release(rtc->dev.parent);
 
-	if (file->f_flags & FASYNC)
-		rtc_dev_fasync(-1, file, 0);
-
 	clear_bit_unlock(RTC_DEV_BUSY, &rtc->flags);
 	return 0;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index afe1de9..a454f94 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -2988,17 +2988,6 @@ static int megasas_mgmt_open(struct inode *inode, struct file *filep)
 }
 
 /**
- * megasas_mgmt_release - char node "release" entry point
- */
-static int megasas_mgmt_release(struct inode *inode, struct file *filep)
-{
-	filep->private_data = NULL;
-	fasync_helper(-1, filep, 0, &megasas_async_queue);
-
-	return 0;
-}
-
-/**
  * megasas_mgmt_fasync -	Async notifier registration from applications
  *
  * This function adds the calling process to a driver global queue. When an
@@ -3345,7 +3334,6 @@ megasas_mgmt_compat_ioctl(struct file *file, unsigned int cmd,
 static const struct file_operations megasas_mgmt_fops = {
 	.owner = THIS_MODULE,
 	.open = megasas_mgmt_open,
-	.release = megasas_mgmt_release,
 	.fasync = megasas_mgmt_fasync,
 	.unlocked_ioctl = megasas_mgmt_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9adf35b..5103855 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -327,7 +327,6 @@ sg_release(struct inode *inode, struct file *filp)
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
-	sg_fasync(-1, filp, 0);	/* remove filp from async notification list */
 	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
 		if (!sdp->detached) {
 			scsi_device_put(sdp->device);
diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index 0b33773..cf8b01b 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -1633,9 +1633,6 @@ static int me4000_release(struct inode *inode_p, struct file *file_p)
 
 		free_irq(ext_int_context->irq, ext_int_context);
 
-		/* Delete the fasync structure and free memory */
-		me4000_ext_int_fasync(0, file_p, 0);
-
 		/* Mark as unused */
 		ext_int_context->in_use = 0;
 	} else {
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 41b6530..a913efc 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -2328,7 +2328,6 @@ static int ixj_release(struct inode *inode, struct file *file_p)
 	j->rec_codec = j->play_codec = 0;
 	j->rec_frame_size = j->play_frame_size = 0;
 	j->flags.cidsent = j->flags.cidring = 0;
-	ixj_fasync(-1, file_p, 0);	/* remove from list of async notification */
 
 	if(j->cardtype == QTI_LINEJACK && !j->readers && !j->writers) {
 		ixj_set_port(j, PORT_PSTN);
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f9b4647..2d2440c 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -367,9 +367,6 @@ static int uio_release(struct inode *inode, struct file *filep)
 		ret = idev->info->release(idev->info, inode);
 
 	module_put(idev->owner);
-
-	if (filep->f_flags & FASYNC)
-		ret = uio_fasync(-1, filep, 0);
 	kfree(listener);
 	return ret;
 }
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index f4585d3..eeb26c0 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1251,7 +1251,6 @@ dev_release (struct inode *inode, struct file *fd)
 	 * alternatively, all host requests will time out.
 	 */
 
-	fasync_helper (-1, fd, 0, &dev->fasync);
 	kfree (dev->buf);
 	dev->buf = NULL;
 	put_dev (dev);
diff --git a/fs/file_table.c b/fs/file_table.c
index efc06fa..5ad0eca 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -269,6 +269,10 @@ void __fput(struct file *file)
 	eventpoll_release(file);
 	locks_remove_flock(file);
 
+	if (unlikely(file->f_flags & FASYNC)) {
+		if (file->f_op && file->f_op->fasync)
+			file->f_op->fasync(-1, file, 0);
+	}
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 87250b6..b723614 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1056,7 +1056,6 @@ static int fuse_dev_release(struct inode *inode, struct file *file)
 		end_requests(fc, &fc->pending);
 		end_requests(fc, &fc->processing);
 		spin_unlock(&fc->lock);
-		fasync_helper(-1, file, 0, &fc->fasync);
 		fuse_conn_put(fc);
 	}
 
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index d85c7d9..d367e9b 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -537,9 +537,6 @@ static int inotify_release(struct inode *ignored, struct file *file)
 		inotify_dev_event_dequeue(dev);
 	mutex_unlock(&dev->ev_mutex);
 
-	if (file->f_flags & FASYNC)
-		inotify_fasync(-1, file, 0);
-
 	/* free this device: the put matching the get in inotify_init() */
 	put_inotify_dev(dev);
 
diff --git a/fs/pipe.c b/fs/pipe.c
index fcba654..7aea8b8 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -717,14 +717,12 @@ pipe_rdwr_fasync(int fd, struct file *filp, int on)
 static int
 pipe_read_release(struct inode *inode, struct file *filp)
 {
-	pipe_read_fasync(-1, filp, 0);
 	return pipe_release(inode, 1, 0);
 }
 
 static int
 pipe_write_release(struct inode *inode, struct file *filp)
 {
-	pipe_write_fasync(-1, filp, 0);
 	return pipe_release(inode, 0, 1);
 }
 
@@ -733,7 +731,6 @@ pipe_rdwr_release(struct inode *inode, struct file *filp)
 {
 	int decr, decw;
 
-	pipe_rdwr_fasync(-1, filp, 0);
 	decr = (filp->f_mode & FMODE_READ) != 0;
 	decw = (filp->f_mode & FMODE_WRITE) != 0;
 	return pipe_release(inode, decr, decw);
diff --git a/net/socket.c b/net/socket.c
index 2b7a4b5..57550c3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -990,7 +990,6 @@ static int sock_close(struct inode *inode, struct file *filp)
 		printk(KERN_DEBUG "sock_close: NULL inode\n");
 		return 0;
 	}
-	sock_fasync(-1, filp, 0);
 	sock_release(SOCKET_I(inode));
 	return 0;
 }
diff --git a/sound/core/control.c b/sound/core/control.c
index b0bf426..636b3b5 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -113,7 +113,6 @@ static int snd_ctl_release(struct inode *inode, struct file *file)
 	unsigned int idx;
 
 	ctl = file->private_data;
-	fasync_helper(-1, file, 0, &ctl->fasync);
 	file->private_data = NULL;
 	card = ctl->card;
 	write_lock_irqsave(&card->ctl_files_rwlock, flags);
diff --git a/sound/core/init.c b/sound/core/init.c
index ef2352c..b47ff8b 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -264,8 +264,11 @@ static int snd_disconnect_release(struct inode *inode, struct file *file)
 	}
 	spin_unlock(&shutdown_lock);
 
-	if (likely(df))
+	if (likely(df)) {
+		if ((file->f_flags & FASYNC) && df->disconnected_f_op->fasync)
+			df->disconnected_f_op->fasync(-1, file, 0);
 		return df->disconnected_f_op->release(inode, file);
+	}
 
 	panic("%s(%p, %p) failed!", __func__, inode, file);
 }
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index aef1868..a789efc 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2169,7 +2169,6 @@ static int snd_pcm_release(struct inode *inode, struct file *file)
 	if (snd_BUG_ON(!substream))
 		return -ENXIO;
 	pcm = substream->pcm;
-	fasync_helper(-1, file, 0, &substream->runtime->fasync);
 	mutex_lock(&pcm->open_mutex);
 	snd_pcm_release_substream(substream);
 	kfree(pcm_file);
diff --git a/sound/core/timer.c b/sound/core/timer.c
index e582fac..c584408 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1263,7 +1263,6 @@ static int snd_timer_user_release(struct inode *inode, struct file *file)
 	if (file->private_data) {
 		tu = file->private_data;
 		file->private_data = NULL;
-		fasync_helper(-1, file, 0, &tu->fasync);
 		if (tu->timeri)
 			snd_timer_close(tu->timeri);
 		kfree(tu->queue);
