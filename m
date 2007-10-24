Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbXJXQyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbXJXQyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761601AbXJXQiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:38:16 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:56055 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762914AbXJXQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:38:13 -0400
Message-ID: <471F74F2.4060209@tiscali.nl>
Date: Wed, 24 Oct 2007 18:38:10 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/?] Unlock when sn_oemdata can't be extended
References: <471E9322.1030408@tiscali.nl> <471F1C48.1000803@tiscali.nl>
In-Reply-To: <471F1C48.1000803@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This includes some that I think I have reported earlier:
in drivers/media/dvb/dvb-usb/au6610.c
and drivers/media/dvb/dvb-usb/gl861.c
--
      Some more unlocking issues
      Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/char/drm/sis_mm.c b/drivers/char/drm/sis_mm.c
index 6be1c57..a6b7ccd 100644
--- a/drivers/char/drm/sis_mm.c
+++ b/drivers/char/drm/sis_mm.c
@@ -134,6 +134,7 @@ static int sis_drm_alloc(struct drm_device *dev, struct drm_file *file_priv,
 		      dev_priv->agp_initialized)) {
 		DRM_ERROR
 		    ("Attempt to allocate from uninitialized memory manager.\n");
+		mutex_unlock(&dev->struct_mutex);
 		return -EINVAL;
 	}
 
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 755570c..d607c9e 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -397,6 +397,7 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
 	default:
 		dev_err(&client->dev,
 			"illegal value for fan divider (%d)\n", div);
+		mutex_unlock(&data->update_lock);
 		return -EINVAL;
 	}
 
diff --git a/drivers/macintosh/macio-adb.c b/drivers/macintosh/macio-adb.c
index 79119f5..bd6da7a 100644
--- a/drivers/macintosh/macio-adb.c
+++ b/drivers/macintosh/macio-adb.c
@@ -155,6 +155,7 @@ static int macio_adb_reset_bus(void)
 	while ((in_8(&adb->ctrl.r) & ADB_RST) != 0) {
 		if (--timeout == 0) {
 			out_8(&adb->ctrl.r, in_8(&adb->ctrl.r) & ~ADB_RST);
+			spin_unlock_irqrestore(&macio_lock, flags);
 			return -1;
 		}
 	}
diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
index 18e0b16..f3ff813 100644
--- a/drivers/media/dvb/dvb-usb/au6610.c
+++ b/drivers/media/dvb/dvb-usb/au6610.c
@@ -79,12 +79,12 @@ static int au6610_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
-
 	if (num > 2)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
 	for (i = 0; i < num; i++) {
 		/* write/read request */
 		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
diff --git a/drivers/media/dvb/dvb-usb/gl861.c b/drivers/media/dvb/dvb-usb/gl861.c
index f01d99c..6b99d9f 100644
--- a/drivers/media/dvb/dvb-usb/gl861.c
+++ b/drivers/media/dvb/dvb-usb/gl861.c
@@ -56,12 +56,12 @@ static int gl861_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	int i;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
-
 	if (num > 2)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
 	for (i = 0; i < num; i++) {
 		/* write/read request */
 		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index edd6828..5478549 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -1476,6 +1476,7 @@ e100_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			e100_set_duplex(dev, autoneg);
 			break;
 		default:
+			spin_unlock(&np->lock);
 			return -EINVAL;
 	}
 	spin_unlock(&np->lock);
diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
index d1131a8..716f532 100644
--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -496,6 +496,7 @@ static int mdc800_usb_probe (struct usb_interface *intf,
 
 	retval = usb_register_dev(intf, &mdc800_class);
 	if (retval) {
+		mutex_unlock(&mdc800->io_lock);
 		err ("Not able to get a minor for this device.");
 		return -ENODEV;
 	}
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index cd5a565..185c093 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -300,6 +300,7 @@ static int iTCO_wdt_start(void)
 
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
+		spin_unlock(&iTCO_wdt_private.io_lock);
 		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
 		return -EIO;
 	}
diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 006fc64..37bdef1 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -153,8 +153,10 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	mutex_lock(&bb->mutex);
 
 	/* need attr_sd for attr, its parent for kobj */
-	if (!sysfs_get_active_two(attr_sd))
+	if (!sysfs_get_active_two(attr_sd)) {
+		mutex_unlock(&bb->mutex);
 		return -ENODEV;
+	}
 
 	rc = -EINVAL;
 	if (attr->mmap)
diff --git a/net/9p/mux.c b/net/9p/mux.c
index f140147..c9f0805 100644
--- a/net/9p/mux.c
+++ b/net/9p/mux.c
@@ -222,8 +222,10 @@ static int p9_mux_poll_start(struct p9_conn *m)
 	}
 
 	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
-		if (vptlast == NULL)
+		if (vptlast == NULL) {
+			mutex_unlock(&p9_mux_task_lock);
 			return -ENOMEM;
+		}
 
 		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
 		list_add(&m->mux_list, &vptlast->mux_list);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 817169e..b09c499 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -282,8 +282,10 @@ find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
 		return NULL;
 
 	list_for_each_entry(e, head, list) {
-		if (strcmp(e->name, name) == 0)
+		if (strcmp(e->name, name) == 0) {
+			mutex_unlock(mutex);
 			return e;
+		}
 	}
 	*error = -ENOENT;
 	mutex_unlock(mutex);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9be1826..cf18097 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1079,7 +1079,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 						    CTA_TUPLE_MASTER,
 						    u3);
 			if (err < 0)
-				return err;
+				goto out_unlock;
 
 			master_h = __nf_conntrack_find(&master, NULL);
 			if (master_h == NULL) {
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 509defe..859fdc0 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -750,8 +750,10 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 
 	rose->neighbour = rose_get_neigh(&addr->srose_addr, &cause,
 					 &diagnostic);
-	if (!rose->neighbour)
-		return -ENETUNREACH;
+	if (!rose->neighbour) {
+		err = -ENETUNREACH;
+		goto out_release;
+	}
 
 	rose->lci = rose_new_lci(rose->neighbour);
 	if (!rose->lci) {
diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index 23018a7..5b0e9bd 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -1833,12 +1833,16 @@ au1550_open(struct inode *inode, struct file *file)
 	}
 
 	if (file->f_mode & FMODE_READ) {
-		if ((ret = prog_dmabuf_adc(s)))
+		if ((ret = prog_dmabuf_adc(s))) {
+			mutex_unlock(&s->open_mutex);
 			return ret;
+		}
 	}
 	if (file->f_mode & FMODE_WRITE) {
-		if ((ret = prog_dmabuf_dac(s)))
+		if ((ret = prog_dmabuf_dac(s))) {
+			mutex_unlock(&s->open_mutex);
 			return ret;
+		}
 	}
 
 	s->open_mode |= file->f_mode & (FMODE_READ | FMODE_WRITE);
diff --git a/sound/oss/dmasound/dmasound_atari.c b/sound/oss/dmasound/dmasound_atari.c
index 285239d..d23a089 100644
--- a/sound/oss/dmasound/dmasound_atari.c
+++ b/sound/oss/dmasound/dmasound_atari.c
@@ -1276,6 +1276,7 @@ static irqreturn_t AtaInterrupt(int irq, void *dummy)
 		 * (almost) like on the TT.
 		 */
 		write_sq_ignore_int = 0;
+		spin_unlock(&dmasound.lock);
 		return IRQ_HANDLED;
 	}
 
@@ -1284,6 +1285,7 @@ static irqreturn_t AtaInterrupt(int irq, void *dummy)
 		 * the sq variables, so better don't do anything here.
 		 */
 		WAKE_UP(write_sq.sync_queue);
+		spin_unlock(&dmasound.lock);
 		return IRQ_HANDLED;
 	}
 
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 880b824..2f62ad6 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -608,6 +608,7 @@ static int snd_mixart_hw_params(struct snd_pcm_substream *subs,
 	/* set the format to the board */
 	err = mixart_set_format(stream, format);
 	if(err < 0) {
+		mutex_unlock(&mgr->setup_mutex);
 		return err;
 	}
 
