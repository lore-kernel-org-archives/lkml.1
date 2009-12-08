Return-Path: <linux-kernel-owner+w=401wt.eu-S965868AbZLHTdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868AbZLHTdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:33:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965889AbZLHTdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:33:10 -0500
Received: from kroah.org ([198.145.64.141]:58233 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965866AbZLHTc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:32:56 -0500
Date: Tue, 8 Dec 2009 11:32:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.40
Message-ID: <20091208193207.GB20016@kroah.com>
References: <20091208193148.GA20016@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208193148.GA20016@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 2361e50..4e55a63 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .39
+EXTRAVERSION = .40
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
index 7c074ee..94c25fa 100644
--- a/arch/x86/kernel/acpi/processor.c
+++ b/arch/x86/kernel/acpi/processor.c
@@ -78,7 +78,8 @@ void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
 	struct cpuinfo_x86 *c = &cpu_data(pr->id);
 
 	pr->pdc = NULL;
-	if (c->x86_vendor == X86_VENDOR_INTEL)
+	if (c->x86_vendor == X86_VENDOR_INTEL ||
+	    c->x86_vendor == X86_VENDOR_CENTAUR)
 		init_intel_pdc(pr, c);
 
 	return;
diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index d883e1b..a24bdd9 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -28,7 +28,7 @@
 #include <linux/device.h>
 #include <linux/dca.h>
 
-#define DCA_VERSION "1.4"
+#define DCA_VERSION "1.8"
 
 MODULE_VERSION(DCA_VERSION);
 MODULE_LICENSE("GPL");
@@ -60,16 +60,17 @@ int dca_add_requester(struct device *dev)
 {
 	struct dca_provider *dca;
 	int err, slot = -ENODEV;
+	unsigned long flags;
 
 	if (!dev)
 		return -EFAULT;
 
-	spin_lock(&dca_lock);
+	spin_lock_irqsave(&dca_lock, flags);
 
 	/* check if the requester has not been added already */
 	dca = dca_find_provider_by_dev(dev);
 	if (dca) {
-		spin_unlock(&dca_lock);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return -EEXIST;
 	}
 
@@ -78,19 +79,21 @@ int dca_add_requester(struct device *dev)
 		if (slot >= 0)
 			break;
 	}
-	if (slot < 0) {
-		spin_unlock(&dca_lock);
+
+	spin_unlock_irqrestore(&dca_lock, flags);
+
+	if (slot < 0)
 		return slot;
-	}
 
 	err = dca_sysfs_add_req(dca, dev, slot);
 	if (err) {
-		dca->ops->remove_requester(dca, dev);
-		spin_unlock(&dca_lock);
+		spin_lock_irqsave(&dca_lock, flags);
+		if (dca == dca_find_provider_by_dev(dev))
+			dca->ops->remove_requester(dca, dev);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return err;
 	}
 
-	spin_unlock(&dca_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dca_add_requester);
@@ -103,25 +106,25 @@ int dca_remove_requester(struct device *dev)
 {
 	struct dca_provider *dca;
 	int slot;
+	unsigned long flags;
 
 	if (!dev)
 		return -EFAULT;
 
-	spin_lock(&dca_lock);
+	spin_lock_irqsave(&dca_lock, flags);
 	dca = dca_find_provider_by_dev(dev);
 	if (!dca) {
-		spin_unlock(&dca_lock);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
 	slot = dca->ops->remove_requester(dca, dev);
-	if (slot < 0) {
-		spin_unlock(&dca_lock);
+	spin_unlock_irqrestore(&dca_lock, flags);
+
+	if (slot < 0)
 		return slot;
-	}
 
 	dca_sysfs_remove_req(dca, slot);
 
-	spin_unlock(&dca_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dca_remove_requester);
@@ -135,17 +138,18 @@ u8 dca_common_get_tag(struct device *dev, int cpu)
 {
 	struct dca_provider *dca;
 	u8 tag;
+	unsigned long flags;
 
-	spin_lock(&dca_lock);
+	spin_lock_irqsave(&dca_lock, flags);
 
 	dca = dca_find_provider_by_dev(dev);
 	if (!dca) {
-		spin_unlock(&dca_lock);
+		spin_unlock_irqrestore(&dca_lock, flags);
 		return -ENODEV;
 	}
 	tag = dca->ops->get_tag(dca, dev, cpu);
 
-	spin_unlock(&dca_lock);
+	spin_unlock_irqrestore(&dca_lock, flags);
 	return tag;
 }
 
@@ -217,11 +221,16 @@ static BLOCKING_NOTIFIER_HEAD(dca_provider_chain);
 int register_dca_provider(struct dca_provider *dca, struct device *dev)
 {
 	int err;
+	unsigned long flags;
 
 	err = dca_sysfs_add_provider(dca, dev);
 	if (err)
 		return err;
+
+	spin_lock_irqsave(&dca_lock, flags);
 	list_add(&dca->node, &dca_providers);
+	spin_unlock_irqrestore(&dca_lock, flags);
+
 	blocking_notifier_call_chain(&dca_provider_chain,
 				     DCA_PROVIDER_ADD, NULL);
 	return 0;
@@ -234,9 +243,15 @@ EXPORT_SYMBOL_GPL(register_dca_provider);
  */
 void unregister_dca_provider(struct dca_provider *dca)
 {
+	unsigned long flags;
+
 	blocking_notifier_call_chain(&dca_provider_chain,
 				     DCA_PROVIDER_REMOVE, NULL);
+
+	spin_lock_irqsave(&dca_lock, flags);
 	list_del(&dca->node);
+	spin_unlock_irqrestore(&dca_lock, flags);
+
 	dca_sysfs_remove_provider(dca);
 }
 EXPORT_SYMBOL_GPL(unregister_dca_provider);
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index c620b20..f29ed05 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -1017,7 +1017,7 @@ static int __init it87_find(unsigned short *address,
 		int reg;
 
 		superio_select(GPIO);
-		if (chip_type == it8718)
+		if (sio_data->type == it8718)
 			sio_data->vid_value = superio_inb(IT87_SIO_VID_REG);
 
 		reg = superio_inb(IT87_SIO_PINX2_REG);
diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index 8df889b..5b6b828 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -818,8 +818,8 @@ collect_rx_frame(usb_fifo * fifo, __u8 * data, int len, int finish)
 	}
 	/* we have a complete hdlc packet */
 	if (finish) {
-		if ((!fifo->skbuff->data[fifo->skbuff->len - 1])
-		    && (fifo->skbuff->len > 3)) {
+		if (fifo->skbuff->len > 3 &&
+				!fifo->skbuff->data[fifo->skbuff->len - 1]) {
 
 			if (fifon == HFCUSB_D_RX) {
 				DBG(HFCUSB_DBG_DCHANNEL,
diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index 93063c6..35df2e2 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -595,13 +595,13 @@ static int tda18271_rf_tracking_filters_init(struct dvb_frontend *fe, u32 freq)
 		case RF2:
 			map[i].rf_a1 = (prog_cal[RF2] - prog_tab[RF2] -
 					prog_cal[RF1] + prog_tab[RF1]) /
-				((rf_freq[RF2] - rf_freq[RF1]) / 1000);
+				(s32)((rf_freq[RF2] - rf_freq[RF1]) / 1000);
 			map[i].rf2   = rf_freq[RF2] / 1000;
 			break;
 		case RF3:
 			map[i].rf_a2 = (prog_cal[RF3] - prog_tab[RF3] -
 					prog_cal[RF2] + prog_tab[RF2]) /
-				((rf_freq[RF3] - rf_freq[RF2]) / 1000);
+				(s32)((rf_freq[RF3] - rf_freq[RF2]) / 1000);
 			map[i].rf_b2 = prog_cal[RF2] - prog_tab[RF2];
 			map[i].rf3   = rf_freq[RF3] / 1000;
 			break;
@@ -927,12 +927,12 @@ static int tda18271_set_analog_params(struct dvb_frontend *fe,
 	struct tda18271_std_map_item *map;
 	char *mode;
 	int ret;
-	u32 freq = params->frequency * 62500;
+	u32 freq = params->frequency * 125 *
+		((params->mode == V4L2_TUNER_RADIO) ? 1 : 1000) / 2;
 
 	priv->mode = TDA18271_ANALOG;
 
 	if (params->mode == V4L2_TUNER_RADIO) {
-		freq = freq / 1000;
 		map = &std_map->fm_radio;
 		mode = "fm";
 	} else if (params->std & V4L2_STD_MN) {
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 1a0142e..78f710d 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -1343,6 +1343,11 @@ struct dvb_frontend * dib7000p_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr,
 	if (dib7000p_identify(st) != 0)
 		goto error;
 
+	/* FIXME: make sure the dev.parent field is initialized, or else
+	request_firmware() will hit an OOPS (this should be moved somewhere
+	more common) */
+	st->i2c_master.gated_tuner_i2c_adap.dev.parent = i2c_adap->dev.parent;
+
 	dibx000_init_i2c_master(&st->i2c_master, DIB7000P, st->i2c_adap, st->i2c_addr);
 
 	dib7000p_demod_reset(st);
diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index ac3292d..95f77b6 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -365,6 +365,11 @@ static int snd_em28xx_hw_capture_free(struct snd_pcm_substream *substream)
 
 static int snd_em28xx_prepare(struct snd_pcm_substream *substream)
 {
+	struct em28xx *dev = snd_pcm_substream_chip(substream);
+
+	dev->adev.hwptr_done_capture = 0;
+	dev->adev.capture_transfer_done = 0;
+
 	return 0;
 }
 
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 92b83fe..83f0bca 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -578,11 +578,6 @@ static int s2255_got_frame(struct s2255_dev *dev, int chn)
 	buf = list_entry(dma_q->active.next,
 			 struct s2255_buffer, vb.queue);
 
-	if (!waitqueue_active(&buf->vb.done)) {
-		/* no one active */
-		rc = -1;
-		goto unlock;
-	}
 	list_del(&buf->vb.queue);
 	do_gettimeofday(&buf->vb.ts);
 	dprintk(100, "[%p/%d] wakeup\n", buf, buf->vb.i);
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index 1a551a8..d3ade96 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -5042,7 +5042,7 @@ static int brightness_write(char *buf)
 	 * Doing it this way makes the syscall restartable in case of EINTR
 	 */
 	rc = brightness_set(level);
-	return (rc == -EINTR)? ERESTARTSYS : rc;
+	return (rc == -EINTR)? -ERESTARTSYS : rc;
 }
 
 static struct ibm_struct brightness_driver_data = {
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 822d521..4015499 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2912,7 +2912,7 @@ static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr)
         eindex = handle;
     estr->event_source = 0;
 
-    if (eindex >= MAX_EVENTS) {
+    if (eindex < 0 || eindex >= MAX_EVENTS) {
         spin_unlock_irqrestore(&ha->smp_lock, flags);
         return eindex;
     }
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 8bec02c..c0c6895 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -89,6 +89,7 @@ static int ohci_restart (struct ohci_hcd *ohci);
 #ifdef CONFIG_PCI
 static void quirk_amd_pll(int state);
 static void amd_iso_dev_put(void);
+static void sb800_prefetch(struct ohci_hcd *ohci, int on);
 #else
 static inline void quirk_amd_pll(int state)
 {
@@ -98,6 +99,10 @@ static inline void amd_iso_dev_put(void)
 {
 	return;
 }
+static inline void sb800_prefetch(struct ohci_hcd *ohci, int on)
+{
+	return;
+}
 #endif
 
 
diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index a9c2ae3..2969fc1 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -177,6 +177,13 @@ static int ohci_quirk_amd700(struct usb_hcd *hcd)
 		return 0;
 
 	pci_read_config_byte(amd_smbus_dev, PCI_REVISION_ID, &rev);
+
+	/* SB800 needs pre-fetch fix */
+	if ((rev >= 0x40) && (rev <= 0x4f)) {
+		ohci->flags |= OHCI_QUIRK_AMD_PREFETCH;
+		ohci_dbg(ohci, "enabled AMD prefetch quirk\n");
+	}
+
 	if ((rev > 0x3b) || (rev < 0x30)) {
 		pci_dev_put(amd_smbus_dev);
 		amd_smbus_dev = NULL;
@@ -262,6 +269,19 @@ static void amd_iso_dev_put(void)
 
 }
 
+static void sb800_prefetch(struct ohci_hcd *ohci, int on)
+{
+	struct pci_dev *pdev;
+	u16 misc;
+
+	pdev = to_pci_dev(ohci_to_hcd(ohci)->self.controller);
+	pci_read_config_word(pdev, 0x50, &misc);
+	if (on == 0)
+		pci_write_config_word(pdev, 0x50, misc & 0xfcff);
+	else
+		pci_write_config_word(pdev, 0x50, misc | 0x0300);
+}
+
 /* List of quirks for OHCI */
 static const struct pci_device_id ohci_pci_quirks[] = {
 	{
diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index c2d80f8..2c7409b 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -49,9 +49,12 @@ __acquires(ohci->lock)
 	switch (usb_pipetype (urb->pipe)) {
 	case PIPE_ISOCHRONOUS:
 		ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs--;
-		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0
-				&& quirk_amdiso(ohci))
-			quirk_amd_pll(1);
+		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0) {
+			if (quirk_amdiso(ohci))
+				quirk_amd_pll(1);
+			if (quirk_amdprefetch(ohci))
+				sb800_prefetch(ohci, 0);
+		}
 		break;
 	case PIPE_INTERRUPT:
 		ohci_to_hcd(ohci)->self.bandwidth_int_reqs--;
@@ -680,9 +683,12 @@ static void td_submit_urb (
 				data + urb->iso_frame_desc [cnt].offset,
 				urb->iso_frame_desc [cnt].length, urb, cnt);
 		}
-		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0
-				&& quirk_amdiso(ohci))
-			quirk_amd_pll(0);
+		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0) {
+			if (quirk_amdiso(ohci))
+				quirk_amd_pll(0);
+			if (quirk_amdprefetch(ohci))
+				sb800_prefetch(ohci, 1);
+		}
 		periodic = ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs++ == 0
 			&& ohci_to_hcd(ohci)->self.bandwidth_int_reqs == 0;
 		break;
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index faf622e..3babb17 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -402,6 +402,7 @@ struct ohci_hcd {
 #define	OHCI_QUIRK_FRAME_NO	0x80			/* no big endian frame_no shift */
 #define	OHCI_QUIRK_HUB_POWER	0x100			/* distrust firmware power/oc setup */
 #define	OHCI_QUIRK_AMD_ISO	0x200			/* ISO transfers*/
+#define	OHCI_QUIRK_AMD_PREFETCH	0x400			/* pre-fetch for ISO transfer */
 	// there are also chip quirks/bugs in init logic
 
 	struct work_struct	nec_work;	/* Worker for NEC quirk */
@@ -433,6 +434,10 @@ static inline int quirk_amdiso(struct ohci_hcd *ohci)
 {
 	return ohci->flags & OHCI_QUIRK_AMD_ISO;
 }
+static inline int quirk_amdprefetch(struct ohci_hcd *ohci)
+{
+	return ohci->flags & OHCI_QUIRK_AMD_PREFETCH;
+}
 #else
 static inline int quirk_nec(struct ohci_hcd *ohci)
 {
@@ -446,6 +451,10 @@ static inline int quirk_amdiso(struct ohci_hcd *ohci)
 {
 	return 0;
 }
+static inline int quirk_amdprefetch(struct ohci_hcd *ohci)
+{
+	return 0;
+}
 #endif
 
 /* convert between an hcd pointer and the corresponding ohci_hcd */
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 79ea98c..7ee5903 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -362,7 +362,7 @@ static int aircable_attach(struct usb_serial *serial)
 	return 0;
 }
 
-static void aircable_shutdown(struct usb_serial *serial)
+static void aircable_release(struct usb_serial *serial)
 {
 
 	struct usb_serial_port *port = serial->port[0];
@@ -373,7 +373,6 @@ static void aircable_shutdown(struct usb_serial *serial)
 	if (priv) {
 		serial_buf_free(priv->tx_buf);
 		serial_buf_free(priv->rx_buf);
-		usb_set_serial_port_data(port, NULL);
 		kfree(priv);
 	}
 }
@@ -598,7 +597,7 @@ static struct usb_serial_driver aircable_device = {
 	.num_ports =		1,
 	.attach =		aircable_attach,
 	.probe =		aircable_probe,
-	.shutdown =		aircable_shutdown,
+	.release =		aircable_release,
 	.write =		aircable_write,
 	.write_room =		aircable_write_room,
 	.write_bulk_callback =	aircable_write_bulk_callback,
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 2ebe06c..5f77c61 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -90,7 +90,7 @@ static int debug;
 
 /* function prototypes for a Belkin USB Serial Adapter F5U103 */
 static int  belkin_sa_startup(struct usb_serial *serial);
-static void belkin_sa_shutdown(struct usb_serial *serial);
+static void belkin_sa_release(struct usb_serial *serial);
 static int  belkin_sa_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static void belkin_sa_close(struct tty_struct *tty,
@@ -143,7 +143,7 @@ static struct usb_serial_driver belkin_device = {
 	.tiocmget =		belkin_sa_tiocmget,
 	.tiocmset =		belkin_sa_tiocmset,
 	.attach =		belkin_sa_startup,
-	.shutdown =		belkin_sa_shutdown,
+	.release =		belkin_sa_release,
 };
 
 
@@ -198,14 +198,13 @@ static int belkin_sa_startup(struct usb_serial *serial)
 }
 
 
-static void belkin_sa_shutdown(struct usb_serial *serial)
+static void belkin_sa_release(struct usb_serial *serial)
 {
 	struct belkin_sa_private *priv;
 	int i;
 
 	dbg("%s", __func__);
 
-	/* stop reads and writes on all ports */
 	for (i = 0; i < serial->num_ports; ++i) {
 		/* My special items, the standard routines free my urbs */
 		priv = usb_get_serial_port_data(serial->port[i]);
diff --git a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
index 69e6687..64d3874 100644
--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -50,7 +50,7 @@ static int cp2101_tiocmset(struct tty_struct *, struct file *,
 		unsigned int, unsigned int);
 static void cp2101_break_ctl(struct tty_struct *, int);
 static int cp2101_startup(struct usb_serial *);
-static void cp2101_shutdown(struct usb_serial *);
+static void cp2101_disconnect(struct usb_serial *);
 
 
 static int debug;
@@ -125,7 +125,7 @@ static struct usb_serial_driver cp2101_device = {
 	.tiocmget 		= cp2101_tiocmget,
 	.tiocmset		= cp2101_tiocmset,
 	.attach			= cp2101_startup,
-	.shutdown		= cp2101_shutdown,
+	.disconnect		= cp2101_disconnect,
 };
 
 /* Config request types */
@@ -727,7 +727,7 @@ static int cp2101_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static void cp2101_shutdown(struct usb_serial *serial)
+static void cp2101_disconnect(struct usb_serial *serial)
 {
 	int i;
 
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index 7b3df8e..4443821 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -58,7 +58,8 @@ static int debug;
 
 /* Function prototypes */
 static int cyberjack_startup(struct usb_serial *serial);
-static void cyberjack_shutdown(struct usb_serial *serial);
+static void cyberjack_disconnect(struct usb_serial *serial);
+static void cyberjack_release(struct usb_serial *serial);
 static int  cyberjack_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static void cyberjack_close(struct tty_struct *tty,
@@ -95,7 +96,8 @@ static struct usb_serial_driver cyberjack_device = {
 	.id_table =		id_table,
 	.num_ports =		1,
 	.attach =		cyberjack_startup,
-	.shutdown =		cyberjack_shutdown,
+	.disconnect =		cyberjack_disconnect,
+	.release =		cyberjack_release,
 	.open =			cyberjack_open,
 	.close =		cyberjack_close,
 	.write =		cyberjack_write,
@@ -148,17 +150,25 @@ static int cyberjack_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static void cyberjack_shutdown(struct usb_serial *serial)
+static void cyberjack_disconnect(struct usb_serial *serial)
 {
 	int i;
 
 	dbg("%s", __func__);
 
-	for (i = 0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i)
 		usb_kill_urb(serial->port[i]->interrupt_in_urb);
+}
+
+static void cyberjack_release(struct usb_serial *serial)
+{
+	int i;
+
+	dbg("%s", __func__);
+
+	for (i = 0; i < serial->num_ports; ++i) {
 		/* My special items, the standard routines free my urbs */
 		kfree(usb_get_serial_port_data(serial->port[i]));
-		usb_set_serial_port_data(serial->port[i], NULL);
 	}
 }
 
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 7eb473b..d8c76b2 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -171,7 +171,7 @@ struct cypress_buf {
 static int  cypress_earthmate_startup(struct usb_serial *serial);
 static int  cypress_hidcom_startup(struct usb_serial *serial);
 static int  cypress_ca42v2_startup(struct usb_serial *serial);
-static void cypress_shutdown(struct usb_serial *serial);
+static void cypress_release(struct usb_serial *serial);
 static int  cypress_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static void cypress_close(struct tty_struct *tty,
@@ -215,7 +215,7 @@ static struct usb_serial_driver cypress_earthmate_device = {
 	.id_table =			id_table_earthmate,
 	.num_ports =			1,
 	.attach =			cypress_earthmate_startup,
-	.shutdown =			cypress_shutdown,
+	.release =			cypress_release,
 	.open =				cypress_open,
 	.close =			cypress_close,
 	.write =			cypress_write,
@@ -241,7 +241,7 @@ static struct usb_serial_driver cypress_hidcom_device = {
 	.id_table =			id_table_cyphidcomrs232,
 	.num_ports =			1,
 	.attach =			cypress_hidcom_startup,
-	.shutdown =			cypress_shutdown,
+	.release =			cypress_release,
 	.open =				cypress_open,
 	.close =			cypress_close,
 	.write =			cypress_write,
@@ -267,7 +267,7 @@ static struct usb_serial_driver cypress_ca42v2_device = {
 	.id_table =			id_table_nokiaca42v2,
 	.num_ports =			1,
 	.attach =			cypress_ca42v2_startup,
-	.shutdown =			cypress_shutdown,
+	.release =			cypress_release,
 	.open =				cypress_open,
 	.close =			cypress_close,
 	.write =			cypress_write,
@@ -612,7 +612,7 @@ static int cypress_ca42v2_startup(struct usb_serial *serial)
 } /* cypress_ca42v2_startup */
 
 
-static void cypress_shutdown(struct usb_serial *serial)
+static void cypress_release(struct usb_serial *serial)
 {
 	struct cypress_private *priv;
 
@@ -625,7 +625,6 @@ static void cypress_shutdown(struct usb_serial *serial)
 	if (priv) {
 		cypress_buf_free(priv->buf);
 		kfree(priv);
-		usb_set_serial_port_data(serial->port[0], NULL);
 	}
 }
 
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 657fc25..0d7e539 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -460,7 +460,8 @@ static void digi_close(struct tty_struct *tty, struct usb_serial_port *port,
 	struct file *filp);
 static int digi_startup_device(struct usb_serial *serial);
 static int digi_startup(struct usb_serial *serial);
-static void digi_shutdown(struct usb_serial *serial);
+static void digi_disconnect(struct usb_serial *serial);
+static void digi_release(struct usb_serial *serial);
 static void digi_read_bulk_callback(struct urb *urb);
 static int digi_read_inb_callback(struct urb *urb);
 static int digi_read_oob_callback(struct urb *urb);
@@ -522,7 +523,8 @@ static struct usb_serial_driver digi_acceleport_2_device = {
 	.tiocmget =			digi_tiocmget,
 	.tiocmset =			digi_tiocmset,
 	.attach =			digi_startup,
-	.shutdown =			digi_shutdown,
+	.disconnect =			digi_disconnect,
+	.release =			digi_release,
 };
 
 static struct usb_serial_driver digi_acceleport_4_device = {
@@ -548,7 +550,8 @@ static struct usb_serial_driver digi_acceleport_4_device = {
 	.tiocmget =			digi_tiocmget,
 	.tiocmset =			digi_tiocmset,
 	.attach =			digi_startup,
-	.shutdown =			digi_shutdown,
+	.disconnect =			digi_disconnect,
+	.release =			digi_release,
 };
 
 
@@ -1586,16 +1589,23 @@ static int digi_startup(struct usb_serial *serial)
 }
 
 
-static void digi_shutdown(struct usb_serial *serial)
+static void digi_disconnect(struct usb_serial *serial)
 {
 	int i;
-	dbg("digi_shutdown: TOP, in_interrupt()=%ld", in_interrupt());
+	dbg("digi_disconnect: TOP, in_interrupt()=%ld", in_interrupt());
 
 	/* stop reads and writes on all ports */
 	for (i = 0; i < serial->type->num_ports + 1; i++) {
 		usb_kill_urb(serial->port[i]->read_urb);
 		usb_kill_urb(serial->port[i]->write_urb);
 	}
+}
+
+
+static void digi_release(struct usb_serial *serial)
+{
+	int i;
+	dbg("digi_release: TOP, in_interrupt()=%ld", in_interrupt());
 
 	/* free the private data structures for all ports */
 	/* number of regular ports + 1 for the out-of-band port */
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index 28ee28c..341f3e4 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -92,7 +92,6 @@ static int  empeg_chars_in_buffer(struct tty_struct *tty);
 static void empeg_throttle(struct tty_struct *tty);
 static void empeg_unthrottle(struct tty_struct *tty);
 static int  empeg_startup(struct usb_serial *serial);
-static void empeg_shutdown(struct usb_serial *serial);
 static void empeg_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
 static void empeg_write_bulk_callback(struct urb *urb);
@@ -126,7 +125,6 @@ static struct usb_serial_driver empeg_device = {
 	.throttle =		empeg_throttle,
 	.unthrottle =		empeg_unthrottle,
 	.attach =		empeg_startup,
-	.shutdown =		empeg_shutdown,
 	.set_termios =		empeg_set_termios,
 	.write =		empeg_write,
 	.write_room =		empeg_write_room,
@@ -429,12 +427,6 @@ static int  empeg_startup(struct usb_serial *serial)
 }
 
 
-static void empeg_shutdown(struct usb_serial *serial)
-{
-	dbg("%s", __func__);
-}
-
-
 static void empeg_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c3089c9..39d16c0 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -708,7 +708,6 @@ static const char *ftdi_chip_name[] = {
 /* function prototypes for a FTDI serial converter */
 static int  ftdi_sio_probe(struct usb_serial *serial,
 					const struct usb_device_id *id);
-static void ftdi_shutdown(struct usb_serial *serial);
 static int  ftdi_sio_port_probe(struct usb_serial_port *port);
 static int  ftdi_sio_port_remove(struct usb_serial_port *port);
 static int  ftdi_open(struct tty_struct *tty,
@@ -764,7 +763,6 @@ static struct usb_serial_driver ftdi_sio_device = {
 	.ioctl =		ftdi_ioctl,
 	.set_termios =		ftdi_set_termios,
 	.break_ctl =		ftdi_break_ctl,
-	.shutdown =		ftdi_shutdown,
 };
 
 
@@ -1442,18 +1440,6 @@ static int ftdi_mtxorb_hack_setup(struct usb_serial *serial)
 	return 0;
 }
 
-/* ftdi_shutdown is called from usbserial:usb_serial_disconnect
- *   it is called when the usb device is disconnected
- *
- *   usbserial:usb_serial_disconnect
- *      calls __serial_close for each open of the port
- *      shutdown is called then (ie ftdi_shutdown)
- */
-static void ftdi_shutdown(struct usb_serial *serial)
-{
-	dbg("%s", __func__);
-}
-
 static int ftdi_sio_port_remove(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index d860071..7ebef38 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1527,7 +1527,7 @@ static int garmin_attach(struct usb_serial *serial)
 }
 
 
-static void garmin_shutdown(struct usb_serial *serial)
+static void garmin_disconnect(struct usb_serial *serial)
 {
 	struct usb_serial_port *port = serial->port[0];
 	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
@@ -1536,8 +1536,17 @@ static void garmin_shutdown(struct usb_serial *serial)
 
 	usb_kill_urb(port->interrupt_in_urb);
 	del_timer_sync(&garmin_data_p->timer);
+}
+
+
+static void garmin_release(struct usb_serial *serial)
+{
+	struct usb_serial_port *port = serial->port[0];
+	struct garmin_data *garmin_data_p = usb_get_serial_port_data(port);
+
+	dbg("%s", __func__);
+
 	kfree(garmin_data_p);
-	usb_set_serial_port_data(port, NULL);
 }
 
 
@@ -1556,7 +1565,8 @@ static struct usb_serial_driver garmin_device = {
 	.throttle            = garmin_throttle,
 	.unthrottle          = garmin_unthrottle,
 	.attach              = garmin_attach,
-	.shutdown            = garmin_shutdown,
+	.disconnect          = garmin_disconnect,
+	.release             = garmin_release,
 	.write               = garmin_write,
 	.write_room          = garmin_write_room,
 	.write_bulk_callback = garmin_write_bulk_callback,
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index aa7f08b..12ed41a 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -63,7 +63,8 @@ struct usb_serial_driver usb_serial_generic_device = {
 	.id_table =		generic_device_ids,
 	.usb_driver = 		&generic_driver,
 	.num_ports =		1,
-	.shutdown =		usb_serial_generic_shutdown,
+	.disconnect =		usb_serial_generic_disconnect,
+	.release =		usb_serial_generic_release,
 	.throttle =		usb_serial_generic_throttle,
 	.unthrottle =		usb_serial_generic_unthrottle,
 	.resume =		usb_serial_generic_resume,
@@ -419,7 +420,7 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 	}
 }
 
-void usb_serial_generic_shutdown(struct usb_serial *serial)
+void usb_serial_generic_disconnect(struct usb_serial *serial)
 {
 	int i;
 
@@ -430,3 +431,7 @@ void usb_serial_generic_shutdown(struct usb_serial *serial)
 		generic_cleanup(serial->port[i]);
 }
 
+void usb_serial_generic_release(struct usb_serial *serial)
+{
+	dbg("%s", __func__);
+}
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 183045a..167c2f1 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -225,7 +225,8 @@ static int  edge_tiocmget(struct tty_struct *tty, struct file *file);
 static int  edge_tiocmset(struct tty_struct *tty, struct file *file,
 					unsigned int set, unsigned int clear);
 static int  edge_startup(struct usb_serial *serial);
-static void edge_shutdown(struct usb_serial *serial);
+static void edge_disconnect(struct usb_serial *serial);
+static void edge_release(struct usb_serial *serial);
 
 #include "io_tables.h"	/* all of the devices that this driver supports */
 
@@ -3178,21 +3179,16 @@ static int edge_startup(struct usb_serial *serial)
 
 
 /****************************************************************************
- * edge_shutdown
+ * edge_disconnect
  *	This function is called whenever the device is removed from the usb bus.
  ****************************************************************************/
-static void edge_shutdown(struct usb_serial *serial)
+static void edge_disconnect(struct usb_serial *serial)
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
-	int i;
 
 	dbg("%s", __func__);
 
 	/* stop reads and writes on all ports */
-	for (i = 0; i < serial->num_ports; ++i) {
-		kfree(usb_get_serial_port_data(serial->port[i]));
-		usb_set_serial_port_data(serial->port[i],  NULL);
-	}
 	/* free up our endpoint stuff */
 	if (edge_serial->is_epic) {
 		usb_kill_urb(edge_serial->interrupt_read_urb);
@@ -3203,9 +3199,24 @@ static void edge_shutdown(struct usb_serial *serial)
 		usb_free_urb(edge_serial->read_urb);
 		kfree(edge_serial->bulk_in_buffer);
 	}
+}
+
+
+/****************************************************************************
+ * edge_release
+ *	This function is called when the device structure is deallocated.
+ ****************************************************************************/
+static void edge_release(struct usb_serial *serial)
+{
+	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
+	int i;
+
+	dbg("%s", __func__);
+
+	for (i = 0; i < serial->num_ports; ++i)
+		kfree(usb_get_serial_port_data(serial->port[i]));
 
 	kfree(edge_serial);
-	usb_set_serial_data(serial, NULL);
 }
 
 
diff --git a/drivers/usb/serial/io_tables.h b/drivers/usb/serial/io_tables.h
index 7eb9d67..9241d31 100644
--- a/drivers/usb/serial/io_tables.h
+++ b/drivers/usb/serial/io_tables.h
@@ -117,7 +117,8 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.throttle		= edge_throttle,
 	.unthrottle		= edge_unthrottle,
 	.attach			= edge_startup,
-	.shutdown		= edge_shutdown,
+	.disconnect		= edge_disconnect,
+	.release		= edge_release,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
@@ -145,7 +146,8 @@ static struct usb_serial_driver edgeport_4port_device = {
 	.throttle		= edge_throttle,
 	.unthrottle		= edge_unthrottle,
 	.attach			= edge_startup,
-	.shutdown		= edge_shutdown,
+	.disconnect		= edge_disconnect,
+	.release		= edge_release,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
@@ -173,7 +175,8 @@ static struct usb_serial_driver edgeport_8port_device = {
 	.throttle		= edge_throttle,
 	.unthrottle		= edge_unthrottle,
 	.attach			= edge_startup,
-	.shutdown		= edge_shutdown,
+	.disconnect		= edge_disconnect,
+	.release		= edge_release,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
@@ -200,7 +203,8 @@ static struct usb_serial_driver epic_device = {
 	.throttle		= edge_throttle,
 	.unthrottle		= edge_unthrottle,
 	.attach			= edge_startup,
-	.shutdown		= edge_shutdown,
+	.disconnect		= edge_disconnect,
+	.release		= edge_release,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 0d744f0..3ff4895 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2652,7 +2652,7 @@ cleanup:
 	return -ENOMEM;
 }
 
-static void edge_shutdown(struct usb_serial *serial)
+static void edge_disconnect(struct usb_serial *serial)
 {
 	int i;
 	struct edgeport_port *edge_port;
@@ -2662,12 +2662,22 @@ static void edge_shutdown(struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; ++i) {
 		edge_port = usb_get_serial_port_data(serial->port[i]);
 		edge_remove_sysfs_attrs(edge_port->port);
+	}
+}
+
+static void edge_release(struct usb_serial *serial)
+{
+	int i;
+	struct edgeport_port *edge_port;
+
+	dbg("%s", __func__);
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		edge_port = usb_get_serial_port_data(serial->port[i]);
 		edge_buf_free(edge_port->ep_out_buf);
 		kfree(edge_port);
-		usb_set_serial_port_data(serial->port[i], NULL);
 	}
 	kfree(usb_get_serial_data(serial));
-	usb_set_serial_data(serial, NULL);
 }
 
 
@@ -2904,7 +2914,8 @@ static struct usb_serial_driver edgeport_1port_device = {
 	.throttle		= edge_throttle,
 	.unthrottle		= edge_unthrottle,
 	.attach			= edge_startup,
-	.shutdown		= edge_shutdown,
+	.disconnect		= edge_disconnect,
+	.release		= edge_release,
 	.port_probe		= edge_create_sysfs_attrs,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
@@ -2933,7 +2944,8 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.throttle		= edge_throttle,
 	.unthrottle		= edge_unthrottle,
 	.attach			= edge_startup,
-	.shutdown		= edge_shutdown,
+	.disconnect		= edge_disconnect,
+	.release		= edge_release,
 	.port_probe		= edge_create_sysfs_attrs,
 	.ioctl			= edge_ioctl,
 	.set_termios		= edge_set_termios,
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index ae0b0ff..c4aa904 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -79,7 +79,6 @@ static int  ipaq_open(struct tty_struct *tty,
 static void ipaq_close(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static int  ipaq_startup(struct usb_serial *serial);
-static void ipaq_shutdown(struct usb_serial *serial);
 static int ipaq_write(struct tty_struct *tty, struct usb_serial_port *port,
 			const unsigned char *buf, int count);
 static int ipaq_write_bulk(struct usb_serial_port *port,
@@ -581,7 +580,6 @@ static struct usb_serial_driver ipaq_device = {
 	.open =			ipaq_open,
 	.close =		ipaq_close,
 	.attach =		ipaq_startup,
-	.shutdown =		ipaq_shutdown,
 	.write =		ipaq_write,
 	.write_room =		ipaq_write_room,
 	.chars_in_buffer =	ipaq_chars_in_buffer,
@@ -957,11 +955,6 @@ static int ipaq_startup(struct usb_serial *serial)
 	return usb_reset_configuration(serial->dev);
 }
 
-static void ipaq_shutdown(struct usb_serial *serial)
-{
-	dbg("%s", __func__);
-}
-
 static int __init ipaq_init(void)
 {
 	int retval;
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index d6da4c9..1b7729b 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -122,8 +122,8 @@ static int iuu_startup(struct usb_serial *serial)
 	return 0;
 }
 
-/* Shutdown function */
-static void iuu_shutdown(struct usb_serial *serial)
+/* Release function */
+static void iuu_release(struct usb_serial *serial)
 {
 	struct usb_serial_port *port = serial->port[0];
 	struct iuu_private *priv = usb_get_serial_port_data(port);
@@ -1171,7 +1171,7 @@ static struct usb_serial_driver iuu_device = {
 	.tiocmget = iuu_tiocmget,
 	.tiocmset = iuu_tiocmset,
 	.attach = iuu_startup,
-	.shutdown = iuu_shutdown,
+	.release = iuu_release,
 };
 
 static int __init iuu_init(void)
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 704716f..d4e0227 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2678,7 +2678,7 @@ static int keyspan_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static void keyspan_shutdown(struct usb_serial *serial)
+static void keyspan_disconnect(struct usb_serial *serial)
 {
 	int				i, j;
 	struct usb_serial_port		*port;
@@ -2718,6 +2718,17 @@ static void keyspan_shutdown(struct usb_serial *serial)
 			usb_free_urb(p_priv->out_urbs[j]);
 		}
 	}
+}
+
+static void keyspan_release(struct usb_serial *serial)
+{
+	int				i;
+	struct usb_serial_port		*port;
+	struct keyspan_serial_private 	*s_priv;
+
+	dbg("%s", __func__);
+
+	s_priv = usb_get_serial_data(serial);
 
 	/*  dbg("Freeing serial->private."); */
 	kfree(s_priv);
diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
index 38b4582..4961c26 100644
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -42,7 +42,8 @@ static void keyspan_close		(struct tty_struct *tty,
 					 struct usb_serial_port *port,
 					 struct file *filp);
 static int  keyspan_startup		(struct usb_serial *serial);
-static void keyspan_shutdown		(struct usb_serial *serial);
+static void keyspan_disconnect		(struct usb_serial *serial);
+static void keyspan_release		(struct usb_serial *serial);
 static int  keyspan_write_room		(struct tty_struct *tty);
 
 static int  keyspan_write		(struct tty_struct *tty,
@@ -569,7 +570,8 @@ static struct usb_serial_driver keyspan_1port_device = {
 	.tiocmget		= keyspan_tiocmget,
 	.tiocmset		= keyspan_tiocmset,
 	.attach			= keyspan_startup,
-	.shutdown		= keyspan_shutdown,
+	.disconnect		= keyspan_disconnect,
+	.release		= keyspan_release,
 };
 
 static struct usb_serial_driver keyspan_2port_device = {
@@ -589,7 +591,8 @@ static struct usb_serial_driver keyspan_2port_device = {
 	.tiocmget		= keyspan_tiocmget,
 	.tiocmset		= keyspan_tiocmset,
 	.attach			= keyspan_startup,
-	.shutdown		= keyspan_shutdown,
+	.disconnect		= keyspan_disconnect,
+	.release		= keyspan_release,
 };
 
 static struct usb_serial_driver keyspan_4port_device = {
@@ -609,7 +612,8 @@ static struct usb_serial_driver keyspan_4port_device = {
 	.tiocmget		= keyspan_tiocmget,
 	.tiocmset		= keyspan_tiocmset,
 	.attach			= keyspan_startup,
-	.shutdown		= keyspan_shutdown,
+	.disconnect		= keyspan_disconnect,
+	.release		= keyspan_release,
 };
 
 #endif
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 040040a..f9a1824 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -789,7 +789,7 @@ static int keyspan_pda_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static void keyspan_pda_shutdown(struct usb_serial *serial)
+static void keyspan_pda_release(struct usb_serial *serial)
 {
 	dbg("%s", __func__);
 
@@ -847,7 +847,7 @@ static struct usb_serial_driver keyspan_pda_device = {
 	.tiocmget =		keyspan_pda_tiocmget,
 	.tiocmset =		keyspan_pda_tiocmset,
 	.attach =		keyspan_pda_startup,
-	.shutdown =		keyspan_pda_shutdown,
+	.release =		keyspan_pda_release,
 };
 
 
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index b84dddc..e0219bd 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -73,7 +73,8 @@ static int debug;
  * Function prototypes
  */
 static int  klsi_105_startup(struct usb_serial *serial);
-static void klsi_105_shutdown(struct usb_serial *serial);
+static void klsi_105_disconnect(struct usb_serial *serial);
+static void klsi_105_release(struct usb_serial *serial);
 static int  klsi_105_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static void klsi_105_close(struct tty_struct *tty,
@@ -132,7 +133,8 @@ static struct usb_serial_driver kl5kusb105d_device = {
 	.tiocmget =          klsi_105_tiocmget,
 	.tiocmset =          klsi_105_tiocmset,
 	.attach =	     klsi_105_startup,
-	.shutdown =	     klsi_105_shutdown,
+	.disconnect =	     klsi_105_disconnect,
+	.release =	     klsi_105_release,
 	.throttle =	     klsi_105_throttle,
 	.unthrottle =	     klsi_105_unthrottle,
 };
@@ -314,7 +316,7 @@ err_cleanup:
 } /* klsi_105_startup */
 
 
-static void klsi_105_shutdown(struct usb_serial *serial)
+static void klsi_105_disconnect(struct usb_serial *serial)
 {
 	int i;
 
@@ -324,33 +326,36 @@ static void klsi_105_shutdown(struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; ++i) {
 		struct klsi_105_private *priv =
 				usb_get_serial_port_data(serial->port[i]);
-		unsigned long flags;
 
 		if (priv) {
 			/* kill our write urb pool */
 			int j;
 			struct urb **write_urbs = priv->write_urb_pool;
-			spin_lock_irqsave(&priv->lock, flags);
 
 			for (j = 0; j < NUM_URBS; j++) {
 				if (write_urbs[j]) {
-					/* FIXME - uncomment the following
-					 * usb_kill_urb call when the host
-					 * controllers get fixed to set
-					 * urb->dev = NULL after the urb is
-					 * finished.  Otherwise this call
-					 * oopses. */
-					/* usb_kill_urb(write_urbs[j]); */
-					kfree(write_urbs[j]->transfer_buffer);
+					usb_kill_urb(write_urbs[j]);
 					usb_free_urb(write_urbs[j]);
 				}
 			}
-			spin_unlock_irqrestore(&priv->lock, flags);
-			kfree(priv);
-			usb_set_serial_port_data(serial->port[i], NULL);
 		}
 	}
-} /* klsi_105_shutdown */
+} /* klsi_105_disconnect */
+
+
+static void klsi_105_release(struct usb_serial *serial)
+{
+	int i;
+
+	dbg("%s", __func__);
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		struct klsi_105_private *priv =
+				usb_get_serial_port_data(serial->port[i]);
+
+		kfree(priv);
+	}
+} /* klsi_105_release */
 
 static int  klsi_105_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 5326c59..d586af0 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -69,7 +69,7 @@ static int debug;
 
 /* Function prototypes */
 static int  kobil_startup(struct usb_serial *serial);
-static void kobil_shutdown(struct usb_serial *serial);
+static void kobil_release(struct usb_serial *serial);
 static int  kobil_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static void kobil_close(struct tty_struct *tty, struct usb_serial_port *port,
@@ -118,7 +118,7 @@ static struct usb_serial_driver kobil_device = {
 	.id_table =		id_table,
 	.num_ports =		1,
 	.attach =		kobil_startup,
-	.shutdown =		kobil_shutdown,
+	.release =		kobil_release,
 	.ioctl =		kobil_ioctl,
 	.set_termios =		kobil_set_termios,
 	.tiocmget =		kobil_tiocmget,
@@ -202,17 +202,13 @@ static int kobil_startup(struct usb_serial *serial)
 }
 
 
-static void kobil_shutdown(struct usb_serial *serial)
+static void kobil_release(struct usb_serial *serial)
 {
 	int i;
 	dbg("%s - port %d", __func__, serial->port[0]->number);
 
-	for (i = 0; i < serial->num_ports; ++i) {
-		while (serial->port[i]->port.count > 0)
-			kobil_close(NULL, serial->port[i], NULL);
+	for (i = 0; i < serial->num_ports; ++i)
 		kfree(usb_get_serial_port_data(serial->port[i]));
-		usb_set_serial_port_data(serial->port[i], NULL);
-	}
 }
 
 
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 0ded8bd..b8f4f58 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -92,7 +92,7 @@ static int debug;
  * Function prototypes
  */
 static int  mct_u232_startup(struct usb_serial *serial);
-static void mct_u232_shutdown(struct usb_serial *serial);
+static void mct_u232_release(struct usb_serial *serial);
 static int  mct_u232_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static void mct_u232_close(struct tty_struct *tty,
@@ -148,7 +148,7 @@ static struct usb_serial_driver mct_u232_device = {
 	.tiocmget =	     mct_u232_tiocmget,
 	.tiocmset =	     mct_u232_tiocmset,
 	.attach =	     mct_u232_startup,
-	.shutdown =	     mct_u232_shutdown,
+	.release =	     mct_u232_release,
 };
 
 
@@ -401,7 +401,7 @@ static int mct_u232_startup(struct usb_serial *serial)
 } /* mct_u232_startup */
 
 
-static void mct_u232_shutdown(struct usb_serial *serial)
+static void mct_u232_release(struct usb_serial *serial)
 {
 	struct mct_u232_private *priv;
 	int i;
@@ -411,12 +411,9 @@ static void mct_u232_shutdown(struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; ++i) {
 		/* My special items, the standard routines free my urbs */
 		priv = usb_get_serial_port_data(serial->port[i]);
-		if (priv) {
-			usb_set_serial_port_data(serial->port[i], NULL);
-			kfree(priv);
-		}
+		kfree(priv);
 	}
-} /* mct_u232_shutdown */
+} /* mct_u232_release */
 
 static int  mct_u232_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 1c2402d..b987808 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1547,19 +1547,16 @@ static int mos7720_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static void mos7720_shutdown(struct usb_serial *serial)
+static void mos7720_release(struct usb_serial *serial)
 {
 	int i;
 
 	/* free private structure allocated for serial port */
-	for (i = 0; i < serial->num_ports; ++i) {
+	for (i = 0; i < serial->num_ports; ++i)
 		kfree(usb_get_serial_port_data(serial->port[i]));
-		usb_set_serial_port_data(serial->port[i], NULL);
-	}
 
 	/* free private structure allocated for serial device */
 	kfree(usb_get_serial_data(serial));
-	usb_set_serial_data(serial, NULL);
 }
 
 static struct usb_driver usb_driver = {
@@ -1584,7 +1581,7 @@ static struct usb_serial_driver moschip7720_2port_driver = {
 	.throttle		= mos7720_throttle,
 	.unthrottle		= mos7720_unthrottle,
 	.attach			= mos7720_startup,
-	.shutdown		= mos7720_shutdown,
+	.release		= mos7720_release,
 	.ioctl			= mos7720_ioctl,
 	.set_termios		= mos7720_set_termios,
 	.write			= mos7720_write,
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 8befcbb..e8a3938 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2643,16 +2643,16 @@ error:
 }
 
 /****************************************************************************
- * mos7840_shutdown
+ * mos7840_disconnect
  *	This function is called whenever the device is removed from the usb bus.
  ****************************************************************************/
 
-static void mos7840_shutdown(struct usb_serial *serial)
+static void mos7840_disconnect(struct usb_serial *serial)
 {
 	int i;
 	unsigned long flags;
 	struct moschip_port *mos7840_port;
-	dbg("%s \n", " shutdown :entering..........");
+	dbg("%s\n", " disconnect :entering..........");
 
 	if (!serial) {
 		dbg("%s", "Invalid Handler \n");
@@ -2670,10 +2670,41 @@ static void mos7840_shutdown(struct usb_serial *serial)
 		mos7840_port->zombie = 1;
 		spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
 		usb_kill_urb(mos7840_port->control_urb);
-		kfree(mos7840_port->ctrl_buf);
-		kfree(mos7840_port->dr);
-		kfree(mos7840_port);
-		mos7840_set_port_private(serial->port[i], NULL);
+	}
+
+	dbg("%s\n", "Thank u ::");
+
+}
+
+/****************************************************************************
+ * mos7840_release
+ *	This function is called when the usb_serial structure is freed.
+ ****************************************************************************/
+
+static void mos7840_release(struct usb_serial *serial)
+{
+	int i;
+	struct moschip_port *mos7840_port;
+	dbg("%s\n", " release :entering..........");
+
+	if (!serial) {
+		dbg("%s", "Invalid Handler");
+		return;
+	}
+
+	/* check for the ports to be closed,close the ports and disconnect */
+
+	/* free private structure allocated for serial port  *
+	 * stop reads and writes on all ports                */
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		mos7840_port = mos7840_get_port_private(serial->port[i]);
+		dbg("mos7840_port %d = %p", i, mos7840_port);
+		if (mos7840_port) {
+			kfree(mos7840_port->ctrl_buf);
+			kfree(mos7840_port->dr);
+			kfree(mos7840_port);
+		}
 	}
 
 	dbg("%s\n", "Thank u :: ");
@@ -2714,7 +2745,8 @@ static struct usb_serial_driver moschip7840_4port_device = {
 	.tiocmget = mos7840_tiocmget,
 	.tiocmset = mos7840_tiocmset,
 	.attach = mos7840_startup,
-	.shutdown = mos7840_shutdown,
+	.disconnect = mos7840_disconnect,
+	.release = mos7840_release,
 	.read_bulk_callback = mos7840_bulk_in_callback,
 	.read_int_callback = mos7840_interrupt_callback,
 };
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index ae8e227..355250c 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -73,7 +73,8 @@ static void omninet_write_bulk_callback(struct urb *urb);
 static int  omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
 				const unsigned char *buf, int count);
 static int  omninet_write_room(struct tty_struct *tty);
-static void omninet_shutdown(struct usb_serial *serial);
+static void omninet_disconnect(struct usb_serial *serial);
+static void omninet_release(struct usb_serial *serial);
 static int omninet_attach(struct usb_serial *serial);
 
 static struct usb_device_id id_table[] = {
@@ -109,7 +110,8 @@ static struct usb_serial_driver zyxel_omninet_device = {
 	.write_room =		omninet_write_room,
 	.read_bulk_callback =	omninet_read_bulk_callback,
 	.write_bulk_callback =	omninet_write_bulk_callback,
-	.shutdown =		omninet_shutdown,
+	.disconnect =		omninet_disconnect,
+	.release =		omninet_release,
 };
 
 
@@ -342,13 +344,22 @@ static void omninet_write_bulk_callback(struct urb *urb)
 }
 
 
-static void omninet_shutdown(struct usb_serial *serial)
+static void omninet_disconnect(struct usb_serial *serial)
 {
 	struct usb_serial_port *wport = serial->port[1];
-	struct usb_serial_port *port = serial->port[0];
+
 	dbg("%s", __func__);
 
 	usb_kill_urb(wport->write_urb);
+}
+
+
+static void omninet_release(struct usb_serial *serial)
+{
+	struct usb_serial_port *port = serial->port[0];
+
+	dbg("%s", __func__);
+
 	kfree(usb_get_serial_port_data(port));
 }
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index faa30ad..850c628 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -48,7 +48,8 @@ static int  option_open(struct tty_struct *tty, struct usb_serial_port *port,
 static void option_close(struct tty_struct *tty, struct usb_serial_port *port,
 							struct file *filp);
 static int  option_startup(struct usb_serial *serial);
-static void option_shutdown(struct usb_serial *serial);
+static void option_disconnect(struct usb_serial *serial);
+static void option_release(struct usb_serial *serial);
 static int  option_write_room(struct tty_struct *tty);
 
 static void option_instat_callback(struct urb *urb);
@@ -62,6 +63,8 @@ static int  option_tiocmget(struct tty_struct *tty, struct file *file);
 static int  option_tiocmset(struct tty_struct *tty, struct file *file,
 				unsigned int set, unsigned int clear);
 static int  option_send_setup(struct tty_struct *tty, struct usb_serial_port *port);
+static int  option_suspend(struct usb_serial *serial, pm_message_t message);
+static int  option_resume(struct usb_serial *serial);
 
 /* Vendor and product IDs */
 #define OPTION_VENDOR_ID			0x0AF0
@@ -511,6 +514,8 @@ static struct usb_driver option_driver = {
 	.name       = "option",
 	.probe      = usb_serial_probe,
 	.disconnect = usb_serial_disconnect,
+	.suspend    = usb_serial_suspend,
+	.resume     = usb_serial_resume,
 	.id_table   = option_ids,
 	.no_dynamic_id = 	1,
 };
@@ -537,8 +542,11 @@ static struct usb_serial_driver option_1port_device = {
 	.tiocmget          = option_tiocmget,
 	.tiocmset          = option_tiocmset,
 	.attach            = option_startup,
-	.shutdown          = option_shutdown,
+	.disconnect        = option_disconnect,
+	.release           = option_release,
 	.read_int_callback = option_instat_callback,
+	.suspend           = option_suspend,
+	.resume            = option_resume,
 };
 
 static int debug;
@@ -809,10 +817,10 @@ static void option_instat_callback(struct urb *urb)
 				req_pkt->bRequestType, req_pkt->bRequest);
 		}
 	} else
-		dbg("%s: error %d", __func__, status);
+		err("%s: error %d", __func__, status);
 
 	/* Resubmit urb so we continue receiving IRQ data */
-	if (status != -ESHUTDOWN) {
+	if (status != -ESHUTDOWN && status != -ENOENT) {
 		urb->dev = serial->dev;
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err)
@@ -831,7 +839,6 @@ static int option_write_room(struct tty_struct *tty)
 
 	portdata = usb_get_serial_port_data(port);
 
-
 	for (i = 0; i < N_OUT_URB; i++) {
 		this_urb = portdata->out_urbs[i];
 		if (this_urb && !test_bit(i, &portdata->out_busy))
@@ -1090,14 +1097,12 @@ bail_out_error:
 	return 1;
 }
 
-static void option_shutdown(struct usb_serial *serial)
+static void stop_read_write_urbs(struct usb_serial *serial)
 {
 	int i, j;
 	struct usb_serial_port *port;
 	struct option_port_private *portdata;
 
-	dbg("%s", __func__);
-
 	/* Stop reading/writing urbs */
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
@@ -1107,6 +1112,22 @@ static void option_shutdown(struct usb_serial *serial)
 		for (j = 0; j < N_OUT_URB; j++)
 			usb_kill_urb(portdata->out_urbs[j]);
 	}
+}
+
+static void option_disconnect(struct usb_serial *serial)
+{
+	dbg("%s", __func__);
+
+	stop_read_write_urbs(serial);
+}
+
+static void option_release(struct usb_serial *serial)
+{
+	int i, j;
+	struct usb_serial_port *port;
+	struct option_port_private *portdata;
+
+	dbg("%s", __func__);
 
 	/* Now free them */
 	for (i = 0; i < serial->num_ports; ++i) {
@@ -1137,6 +1158,66 @@ static void option_shutdown(struct usb_serial *serial)
 	}
 }
 
+static int option_suspend(struct usb_serial *serial, pm_message_t message)
+{
+	dbg("%s entered", __func__);
+	stop_read_write_urbs(serial);
+
+	return 0;
+}
+
+static int option_resume(struct usb_serial *serial)
+{
+	int err, i, j;
+	struct usb_serial_port *port;
+	struct urb *urb;
+	struct option_port_private *portdata;
+
+	dbg("%s entered", __func__);
+	/* get the interrupt URBs resubmitted unconditionally */
+	for (i = 0; i < serial->num_ports; i++) {
+		port = serial->port[i];
+		if (!port->interrupt_in_urb) {
+			dbg("%s: No interrupt URB for port %d\n", __func__, i);
+			continue;
+		}
+		port->interrupt_in_urb->dev = serial->dev;
+		err = usb_submit_urb(port->interrupt_in_urb, GFP_NOIO);
+		dbg("Submitted interrupt URB for port %d (result %d)", i, err);
+		if (err < 0) {
+			err("%s: Error %d for interrupt URB of port%d",
+				 __func__, err, i);
+			return err;
+		}
+	}
+
+	for (i = 0; i < serial->num_ports; i++) {
+		/* walk all ports */
+		port = serial->port[i];
+		portdata = usb_get_serial_port_data(port);
+		mutex_lock(&port->mutex);
+
+		/* skip closed ports */
+		if (!port->port.count) {
+			mutex_unlock(&port->mutex);
+			continue;
+		}
+
+		for (j = 0; j < N_IN_URB; j++) {
+			urb = portdata->in_urbs[j];
+			err = usb_submit_urb(urb, GFP_NOIO);
+			if (err < 0) {
+				mutex_unlock(&port->mutex);
+				err("%s: Error %d for bulk URB %d",
+					 __func__, err, i);
+				return err;
+			}
+		}
+		mutex_unlock(&port->mutex);
+	}
+	return 0;
+}
+
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_VERSION(DRIVER_VERSION);
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 81db571..6697a0c 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -160,7 +160,7 @@ static int oti6858_tiocmget(struct tty_struct *tty, struct file *file);
 static int oti6858_tiocmset(struct tty_struct *tty, struct file *file,
 				unsigned int set, unsigned int clear);
 static int oti6858_startup(struct usb_serial *serial);
-static void oti6858_shutdown(struct usb_serial *serial);
+static void oti6858_release(struct usb_serial *serial);
 
 /* functions operating on buffers */
 static struct oti6858_buf *oti6858_buf_alloc(unsigned int size);
@@ -195,7 +195,7 @@ static struct usb_serial_driver oti6858_device = {
 	.write_room =		oti6858_write_room,
 	.chars_in_buffer =	oti6858_chars_in_buffer,
 	.attach =		oti6858_startup,
-	.shutdown =		oti6858_shutdown,
+	.release =		oti6858_release,
 };
 
 struct oti6858_private {
@@ -833,7 +833,7 @@ static int oti6858_ioctl(struct tty_struct *tty, struct file *file,
 }
 
 
-static void oti6858_shutdown(struct usb_serial *serial)
+static void oti6858_release(struct usb_serial *serial)
 {
 	struct oti6858_private *priv;
 	int i;
@@ -845,7 +845,6 @@ static void oti6858_shutdown(struct usb_serial *serial)
 		if (priv) {
 			oti6858_buf_free(priv->buf);
 			kfree(priv);
-			usb_set_serial_port_data(serial->port[i], NULL);
 		}
 	}
 }
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1ede144..70536c1 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -905,7 +905,7 @@ static void pl2303_break_ctl(struct tty_struct *tty, int break_state)
 		dbg("%s - error sending break = %d", __func__, result);
 }
 
-static void pl2303_shutdown(struct usb_serial *serial)
+static void pl2303_release(struct usb_serial *serial)
 {
 	int i;
 	struct pl2303_private *priv;
@@ -917,7 +917,6 @@ static void pl2303_shutdown(struct usb_serial *serial)
 		if (priv) {
 			pl2303_buf_free(priv->buf);
 			kfree(priv);
-			usb_set_serial_port_data(serial->port[i], NULL);
 		}
 	}
 }
@@ -1145,7 +1144,7 @@ static struct usb_serial_driver pl2303_device = {
 	.write_room =		pl2303_write_room,
 	.chars_in_buffer =	pl2303_chars_in_buffer,
 	.attach =		pl2303_startup,
-	.shutdown =		pl2303_shutdown,
+	.release =		pl2303_release,
 };
 
 static int __init pl2303_init(void)
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 639328b..28d66d3 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -677,7 +677,7 @@ static int sierra_startup(struct usb_serial *serial)
 	return 0;
 }
 
-static void sierra_shutdown(struct usb_serial *serial)
+static void sierra_disconnect(struct usb_serial *serial)
 {
 	int i, j;
 	struct usb_serial_port *port;
@@ -696,10 +696,29 @@ static void sierra_shutdown(struct usb_serial *serial)
 		for (j = 0; j < N_IN_URB; j++) {
 			usb_kill_urb(portdata->in_urbs[j]);
 			usb_free_urb(portdata->in_urbs[j]);
-			kfree(portdata->in_buffer[j]);
 		}
+	}
+}
+
+static void sierra_release(struct usb_serial *serial)
+{
+	int i, j;
+	struct usb_serial_port *port;
+	struct sierra_port_private *portdata;
+
+	dev_dbg(&serial->dev->dev, "%s\n", __func__);
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (!port)
+			continue;
+		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
+
+		for (j = 0; j < N_IN_URB; j++)
+			kfree(portdata->in_buffer[j]);
 		kfree(portdata);
-		usb_set_serial_port_data(port, NULL);
 	}
 }
 
@@ -721,7 +740,8 @@ static struct usb_serial_driver sierra_device = {
 	.tiocmget          = sierra_tiocmget,
 	.tiocmset          = sierra_tiocmset,
 	.attach            = sierra_startup,
-	.shutdown          = sierra_shutdown,
+	.disconnect        = sierra_disconnect,
+	.release           = sierra_release,
 	.read_int_callback = sierra_instat_callback,
 };
 
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 283cf6b..af54f0b 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -356,7 +356,7 @@ cleanup:
 }
 
 /* call when the device plug out. free all the memory alloced by probe */
-static void spcp8x5_shutdown(struct usb_serial *serial)
+static void spcp8x5_release(struct usb_serial *serial)
 {
 	int i;
 	struct spcp8x5_private *priv;
@@ -366,7 +366,6 @@ static void spcp8x5_shutdown(struct usb_serial *serial)
 		if (priv) {
 			free_ringbuf(priv->buf);
 			kfree(priv);
-			usb_set_serial_port_data(serial->port[i] , NULL);
 		}
 	}
 }
@@ -1041,7 +1040,7 @@ static struct usb_serial_driver spcp8x5_device = {
 	.write_bulk_callback	= spcp8x5_write_bulk_callback,
 	.chars_in_buffer 	= spcp8x5_chars_in_buffer,
 	.attach 		= spcp8x5_startup,
-	.shutdown 		= spcp8x5_shutdown,
+	.release 		= spcp8x5_release,
 };
 
 static int __init spcp8x5_init(void)
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 55b9d67..efe3bf2 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -148,7 +148,7 @@ struct ti_device {
 /* Function Declarations */
 
 static int ti_startup(struct usb_serial *serial);
-static void ti_shutdown(struct usb_serial *serial);
+static void ti_release(struct usb_serial *serial);
 static int ti_open(struct tty_struct *tty, struct usb_serial_port *port,
 		struct file *file);
 static void ti_close(struct tty_struct *tty, struct usb_serial_port *port,
@@ -271,7 +271,7 @@ static struct usb_serial_driver ti_1port_device = {
 	.id_table		= ti_id_table_3410,
 	.num_ports		= 1,
 	.attach			= ti_startup,
-	.shutdown		= ti_shutdown,
+	.release		= ti_release,
 	.open			= ti_open,
 	.close			= ti_close,
 	.write			= ti_write,
@@ -299,7 +299,7 @@ static struct usb_serial_driver ti_2port_device = {
 	.id_table		= ti_id_table_5052,
 	.num_ports		= 2,
 	.attach			= ti_startup,
-	.shutdown		= ti_shutdown,
+	.release		= ti_release,
 	.open			= ti_open,
 	.close			= ti_close,
 	.write			= ti_write,
@@ -506,7 +506,7 @@ free_tdev:
 }
 
 
-static void ti_shutdown(struct usb_serial *serial)
+static void ti_release(struct usb_serial *serial)
 {
 	int i;
 	struct ti_device *tdev = usb_get_serial_data(serial);
@@ -519,12 +519,10 @@ static void ti_shutdown(struct usb_serial *serial)
 		if (tport) {
 			ti_buf_free(tport->tp_write_buf);
 			kfree(tport);
-			usb_set_serial_port_data(serial->port[i], NULL);
 		}
 	}
 
 	kfree(tdev);
-	usb_set_serial_data(serial, NULL);
 }
 
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 579796a..4f5ee74 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -140,6 +140,14 @@ static void destroy_serial(struct kref *kref)
 	if (serial->minor != SERIAL_TTY_NO_MINOR)
 		return_serial(serial);
 
+	serial->type->release(serial);
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (port)
+			put_device(&port->dev);
+	}
+
 	/* If this is a "fake" port, we have to clean it up here, as it will
 	 * not get cleaned up in port_release() as it was never registered with
 	 * the driver core */
@@ -147,9 +155,8 @@ static void destroy_serial(struct kref *kref)
 		for (i = serial->num_ports;
 					i < serial->num_port_pointers; ++i) {
 			port = serial->port[i];
-			if (!port)
-				continue;
-			port_free(port);
+			if (port)
+				port_free(port);
 		}
 	}
 
@@ -1061,10 +1068,6 @@ void usb_serial_disconnect(struct usb_interface *interface)
 	serial->disconnected = 1;
 	mutex_unlock(&serial->disc_mutex);
 
-	/* Unfortunately, many of the sub-drivers expect the port structures
-	 * to exist when their shutdown method is called, so we have to go
-	 * through this awkward two-step unregistration procedure.
-	 */
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		if (port) {
@@ -1075,14 +1078,7 @@ void usb_serial_disconnect(struct usb_interface *interface)
 			device_del(&port->dev);
 		}
 	}
-	serial->type->shutdown(serial);
-	for (i = 0; i < serial->num_ports; ++i) {
-		port = serial->port[i];
-		if (port) {
-			put_device(&port->dev);
-			serial->port[i] = NULL;
-		}
-	}
+	serial->type->disconnect(serial);
 
 	/* let the last holder of this object
 	 * cause it to be cleaned up */
@@ -1246,7 +1242,8 @@ static void fixup_generic(struct usb_serial_driver *device)
 	set_to_generic_if_null(device, chars_in_buffer);
 	set_to_generic_if_null(device, read_bulk_callback);
 	set_to_generic_if_null(device, write_bulk_callback);
-	set_to_generic_if_null(device, shutdown);
+	set_to_generic_if_null(device, disconnect);
+	set_to_generic_if_null(device, release);
 	set_to_generic_if_null(device, resume);
 }
 
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index ec33fa5..b538017 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -48,7 +48,7 @@ static void visor_unthrottle(struct tty_struct *tty);
 static int  visor_probe(struct usb_serial *serial,
 					const struct usb_device_id *id);
 static int  visor_calc_num_ports(struct usb_serial *serial);
-static void visor_shutdown(struct usb_serial *serial);
+static void visor_release(struct usb_serial *serial);
 static void visor_write_bulk_callback(struct urb *urb);
 static void visor_read_bulk_callback(struct urb *urb);
 static void visor_read_int_callback(struct urb *urb);
@@ -203,7 +203,7 @@ static struct usb_serial_driver handspring_device = {
 	.attach =		treo_attach,
 	.probe =		visor_probe,
 	.calc_num_ports =	visor_calc_num_ports,
-	.shutdown =		visor_shutdown,
+	.release =		visor_release,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
 	.write_bulk_callback =	visor_write_bulk_callback,
@@ -228,7 +228,7 @@ static struct usb_serial_driver clie_5_device = {
 	.attach =		clie_5_attach,
 	.probe =		visor_probe,
 	.calc_num_ports =	visor_calc_num_ports,
-	.shutdown =		visor_shutdown,
+	.release =		visor_release,
 	.write =		visor_write,
 	.write_room =		visor_write_room,
 	.write_bulk_callback =	visor_write_bulk_callback,
@@ -916,7 +916,7 @@ static int clie_5_attach(struct usb_serial *serial)
 	return generic_startup(serial);
 }
 
-static void visor_shutdown(struct usb_serial *serial)
+static void visor_release(struct usb_serial *serial)
 {
 	struct visor_private *priv;
 	int i;
@@ -925,10 +925,7 @@ static void visor_shutdown(struct usb_serial *serial)
 
 	for (i = 0; i < serial->num_ports; i++) {
 		priv = usb_get_serial_port_data(serial->port[i]);
-		if (priv) {
-			usb_set_serial_port_data(serial->port[i], NULL);
-			kfree(priv);
-		}
+		kfree(priv);
 	}
 }
 
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 3a9d143..12ea829 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -144,7 +144,7 @@ static int  whiteheat_firmware_attach(struct usb_serial *serial);
 
 /* function prototypes for the Connect Tech WhiteHEAT serial converter */
 static int  whiteheat_attach(struct usb_serial *serial);
-static void whiteheat_shutdown(struct usb_serial *serial);
+static void whiteheat_release(struct usb_serial *serial);
 static int  whiteheat_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp);
 static void whiteheat_close(struct tty_struct *tty,
@@ -190,7 +190,7 @@ static struct usb_serial_driver whiteheat_device = {
 	.id_table =		id_table_std,
 	.num_ports =		4,
 	.attach =		whiteheat_attach,
-	.shutdown =		whiteheat_shutdown,
+	.release =		whiteheat_release,
 	.open =			whiteheat_open,
 	.close =		whiteheat_close,
 	.write =		whiteheat_write,
@@ -600,7 +600,7 @@ no_command_buffer:
 }
 
 
-static void whiteheat_shutdown(struct usb_serial *serial)
+static void whiteheat_release(struct usb_serial *serial)
 {
 	struct usb_serial_port *command_port;
 	struct usb_serial_port *port;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index fd03330..1695c2e 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -398,6 +398,9 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry, int mode,
 	if (fc->no_create)
 		return -ENOSYS;
 
+	if (flags & O_DIRECT)
+		return -EINVAL;
+
 	forget_req = fuse_get_req(fc);
 	if (IS_ERR(forget_req))
 		return PTR_ERR(forget_req);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 0c92f15..afdde60 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1005,7 +1005,8 @@ static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 				break;
 		}
 	}
-	fuse_put_request(fc, req);
+	if (!IS_ERR(req))
+		fuse_put_request(fc, req);
 	if (res > 0) {
 		if (write)
 			fuse_write_update_size(inode, pos);
diff --git a/fs/jffs2/read.c b/fs/jffs2/read.c
index cfe05c1..3f39be1 100644
--- a/fs/jffs2/read.c
+++ b/fs/jffs2/read.c
@@ -164,12 +164,15 @@ int jffs2_read_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 
 	/* XXX FIXME: Where a single physical node actually shows up in two
 	   frags, we read it twice. Don't do that. */
-	/* Now we're pointing at the first frag which overlaps our page */
+	/* Now we're pointing at the first frag which overlaps our page
+	 * (or perhaps is before it, if we've been asked to read off the
+	 * end of the file). */
 	while(offset < end) {
 		D2(printk(KERN_DEBUG "jffs2_read_inode_range: offset %d, end %d\n", offset, end));
-		if (unlikely(!frag || frag->ofs > offset)) {
+		if (unlikely(!frag || frag->ofs > offset ||
+			     frag->ofs + frag->size <= offset)) {
 			uint32_t holesize = end - offset;
-			if (frag) {
+			if (frag && frag->ofs > offset) {
 				D1(printk(KERN_NOTICE "Eep. Hole in ino #%u fraglist. frag->ofs = 0x%08x, offset = 0x%08x\n", f->inocache->ino, frag->ofs, offset));
 				holesize = min(holesize, frag->ofs - offset);
 			}
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 655341d..9d8ca87 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -177,8 +177,10 @@ static inline void usb_set_serial_data(struct usb_serial *serial, void *data)
  *	This will be called when the struct usb_serial structure is fully set
  *	set up.  Do any local initialization of the device, or any private
  *	memory structure allocation at this point in time.
- * @shutdown: pointer to the driver's shutdown function.  This will be
- *	called when the device is removed from the system.
+ * @disconnect: pointer to the driver's disconnect function.  This will be
+ *	called when the device is unplugged or unbound from the driver.
+ * @release: pointer to the driver's release function.  This will be called
+ *	when the usb_serial data structure is about to be destroyed.
  * @usb_driver: pointer to the struct usb_driver that controls this
  *	device.  This is necessary to allow dynamic ids to be added to
  *	the driver from sysfs.
@@ -208,7 +210,8 @@ struct usb_serial_driver {
 	int (*attach)(struct usb_serial *serial);
 	int (*calc_num_ports) (struct usb_serial *serial);
 
-	void (*shutdown)(struct usb_serial *serial);
+	void (*disconnect)(struct usb_serial *serial);
+	void (*release)(struct usb_serial *serial);
 
 	int (*port_probe)(struct usb_serial_port *port);
 	int (*port_remove)(struct usb_serial_port *port);
@@ -288,7 +291,8 @@ extern void usb_serial_generic_read_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_write_bulk_callback(struct urb *urb);
 extern void usb_serial_generic_throttle(struct tty_struct *tty);
 extern void usb_serial_generic_unthrottle(struct tty_struct *tty);
-extern void usb_serial_generic_shutdown(struct usb_serial *serial);
+extern void usb_serial_generic_disconnect(struct usb_serial *serial);
+extern void usb_serial_generic_release(struct usb_serial *serial);
 extern int usb_serial_generic_register(int debug);
 extern void usb_serial_generic_deregister(void);
 
diff --git a/sound/arm/aaci.c b/sound/arm/aaci.c
index b0a4744..07b0f65 100644
--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -504,6 +504,10 @@ static int aaci_pcm_hw_params(struct snd_pcm_substream *substream,
 	int err;
 
 	aaci_pcm_hw_free(substream);
+	if (aacirun->pcm_open) {
+		snd_ac97_pcm_close(aacirun->pcm);
+		aacirun->pcm_open = 0;
+	}
 
 	err = devdma_hw_alloc(NULL, substream,
 			      params_buffer_bytes(params));
@@ -517,7 +521,7 @@ static int aaci_pcm_hw_params(struct snd_pcm_substream *substream,
 	else
 		err = snd_ac97_pcm_open(aacirun->pcm, params_rate(params),
 					params_channels(params),
-					aacirun->pcm->r[1].slots);
+					aacirun->pcm->r[0].slots);
 
 	if (err)
 		goto out;
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 7191d82..c456004 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -209,7 +209,7 @@ struct snd_usb_midi_endpoint_info {
 /*
  */
 
-#define combine_word(s)    ((*s) | ((unsigned int)(s)[1] << 8))
+#define combine_word(s)    ((*(s)) | ((unsigned int)(s)[1] << 8))
 #define combine_triple(s)  (combine_word(s) | ((unsigned int)(s)[2] << 16))
 #define combine_quad(s)    (combine_triple(s) | ((unsigned int)(s)[3] << 24))
 
