Return-Path: <linux-kernel-owner+w=401wt.eu-S966662AbXJSHao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966662AbXJSHao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762485AbXJSHae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:30:34 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51678 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762348AbXJSHad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:30:33 -0400
Date: Fri, 19 Oct 2007 03:30:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] parport: Remove unused 'irq' argument from parport irq
	functions
Message-ID: <20071019073032.GB5611@havoc.gtf.org>
References: <20071019072914.GA5591@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019072914.GA5591@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit ed58d6e0a6e1ad61a7dde232de7a4891ebc99f61
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 02:54:26 2007 -0400

    [PARPORT] Remove unused 'irq' argument from parport irq functions
    
    None of the drivers with a struct pardevice's ->irq_func() hook ever
    used the 'irq' argument passed to it, so remove it.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/ppdev.c              |    4 ++--
 drivers/input/serio/parkbd.c      |    2 +-
 drivers/net/hamradio/baycom_epp.c |    8 +-------
 drivers/net/hamradio/baycom_par.c |    4 ++--
 drivers/net/plip.c                |    6 +++---
 drivers/parport/daisy.c           |   13 ++-----------
 drivers/parport/probe.c           |    3 +--
 drivers/parport/share.c           |    2 +-
 include/linux/parport.h           |   12 ++++--------
 sound/drivers/mts64.c             |    2 +-
 sound/drivers/portman2x4.c        |    2 +-
 11 files changed, 19 insertions(+), 39 deletions(-)

ed58d6e0a6e1ad61a7dde232de7a4891ebc99f61
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index efe2f5c..3aab837 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -267,9 +267,9 @@ static ssize_t pp_write (struct file * file, const char __user * buf,
 	return bytes_written;
 }
 
-static void pp_irq (int irq, void * private)
+static void pp_irq (void *private)
 {
-	struct pp_struct * pp = (struct pp_struct *) private;
+	struct pp_struct *pp = private;
 
 	if (pp->irqresponse) {
 		parport_write_control (pp->pdev->port, pp->irqctl);
diff --git a/drivers/input/serio/parkbd.c b/drivers/input/serio/parkbd.c
index 688610e..b089977 100644
--- a/drivers/input/serio/parkbd.c
+++ b/drivers/input/serio/parkbd.c
@@ -102,7 +102,7 @@ static int parkbd_write(struct serio *port, unsigned char c)
 	return 0;
 }
 
-static void parkbd_interrupt(int irq, void *dev_id)
+static void parkbd_interrupt(void *dev_id)
 {
 
 	if (parkbd_writing) {
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 1a5a75a..dde9c7e 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -325,12 +325,6 @@ static int eppconfig(struct baycom_state *bc)
 
 /* ---------------------------------------------------------------------- */
 
-static void epp_interrupt(int irq, void *dev_id)
-{
-}
-
-/* ---------------------------------------------------------------------- */
-
 static inline void do_kiss_params(struct baycom_state *bc,
 				  unsigned char *data, unsigned long len)
 {
@@ -871,7 +865,7 @@ static int epp_open(struct net_device *dev)
 	}
 	memset(&bc->modem, 0, sizeof(bc->modem));
         bc->pdev = parport_register_device(pp, dev->name, NULL, epp_wakeup, 
-					epp_interrupt, PARPORT_DEV_EXCL, dev);
+					   NULL, PARPORT_DEV_EXCL, dev);
 	parport_put_port(pp);
         if (!bc->pdev) {
                 printk(KERN_ERR "%s: cannot register parport at 0x%lx\n", bc_drvname, pp->base);
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 5930aeb..2e6fc4d 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -270,9 +270,9 @@ static __inline__ void par96_rx(struct net_device *dev, struct baycom_state *bc)
 
 /* --------------------------------------------------------------------- */
 
-static void par96_interrupt(int irq, void *dev_id)
+static void par96_interrupt(void *dev_id)
 {
-	struct net_device *dev = (struct net_device *)dev_id;
+	struct net_device *dev = dev_id;
 	struct baycom_state *bc = netdev_priv(dev);
 
 	baycom_int_freq(bc);
diff --git a/drivers/net/plip.c b/drivers/net/plip.c
index b5e9981..5071fcd 100644
--- a/drivers/net/plip.c
+++ b/drivers/net/plip.c
@@ -143,7 +143,7 @@ static void plip_bh(struct work_struct *work);
 static void plip_timer_bh(struct work_struct *work);
 
 /* Interrupt handler */
-static void plip_interrupt(int irq, void *dev_id);
+static void plip_interrupt(void *dev_id);
 
 /* Functions for DEV methods */
 static int plip_tx_packet(struct sk_buff *skb, struct net_device *dev);
@@ -380,7 +380,7 @@ plip_timer_bh(struct work_struct *work)
 		container_of(work, struct net_local, timer.work);
 
 	if (!(atomic_read (&nl->kill_timer))) {
-		plip_interrupt (-1, nl->dev);
+		plip_interrupt (nl->dev);
 
 		schedule_delayed_work(&nl->timer, 1);
 	}
@@ -897,7 +897,7 @@ plip_error(struct net_device *dev, struct net_local *nl,
 
 /* Handle the parallel port interrupts. */
 static void
-plip_interrupt(int irq, void *dev_id)
+plip_interrupt(void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct net_local *nl;
diff --git a/drivers/parport/daisy.c b/drivers/parport/daisy.c
index 5bbff20..3c8f06c 100644
--- a/drivers/parport/daisy.c
+++ b/drivers/parport/daisy.c
@@ -199,11 +199,6 @@ void parport_daisy_fini(struct parport *port)
  *	parport_open - find a device by canonical device number
  *	@devnum: canonical device number
  *	@name: name to associate with the device
- *	@pf: preemption callback
- *	@kf: kick callback
- *	@irqf: interrupt handler
- *	@flags: registration flags
- *	@handle: driver data
  *
  *	This function is similar to parport_register_device(), except
  *	that it locates a device by its number rather than by the port
@@ -214,10 +209,7 @@ void parport_daisy_fini(struct parport *port)
  *	for parport_register_device().
  **/
 
-struct pardevice *parport_open(int devnum, const char *name,
-				int (*pf) (void *), void (*kf) (void *),
-				void (*irqf) (int, void *),
-				int flags, void *handle)
+struct pardevice *parport_open(int devnum, const char *name)
 {
 	struct daisydev *p = topology;
 	struct parport *port;
@@ -237,8 +229,7 @@ struct pardevice *parport_open(int devnum, const char *name,
 	port = parport_get_port(p->port);
 	spin_unlock(&topology_lock);
 
-	dev = parport_register_device(port, name, pf, kf,
-				       irqf, flags, handle);
+	dev = parport_register_device(port, name, NULL, NULL, NULL, 0, NULL);
 	parport_put_port(port);
 	if (!dev)
 		return NULL;
diff --git a/drivers/parport/probe.c b/drivers/parport/probe.c
index ea83b70..853a15f 100644
--- a/drivers/parport/probe.c
+++ b/drivers/parport/probe.c
@@ -255,8 +255,7 @@ static ssize_t parport_read_device_id (struct parport *port, char *buffer,
 ssize_t parport_device_id (int devnum, char *buffer, size_t count)
 {
 	ssize_t retval = -ENXIO;
-	struct pardevice *dev = parport_open (devnum, "Device ID probe",
-					      NULL, NULL, NULL, 0, NULL);
+	struct pardevice *dev = parport_open (devnum, "Device ID probe");
 	if (!dev)
 		return -ENXIO;
 
diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index d0b353c..a8a62bb 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -524,7 +524,7 @@ void parport_remove_port(struct parport *port)
 struct pardevice *
 parport_register_device(struct parport *port, const char *name,
 			int (*pf)(void *), void (*kf)(void *),
-			void (*irq_func)(int, void *), 
+			void (*irq_func)(void *), 
 			int flags, void *handle)
 {
 	struct pardevice *tmp;
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 557c37d..d1ad546 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -230,7 +230,7 @@ struct pardevice {
 	int (*preempt)(void *);
 	void (*wakeup)(void *);
 	void *private;
-	void (*irq_func)(int, void *);
+	void (*irq_func)(void *);
 	unsigned int flags;
 	struct pardevice *next;
 	struct pardevice *prev;
@@ -383,7 +383,7 @@ extern void parport_put_port (struct parport *);
 struct pardevice *parport_register_device(struct parport *port, 
 			  const char *name,
 			  int (*pf)(void *), void (*kf)(void *),
-			  void (*irq_func)(int, void *), 
+			  void (*irq_func)(void *), 
 			  int flags, void *handle);
 
 /* parport_unregister unlinks a device from the chain. */
@@ -507,11 +507,7 @@ extern size_t parport_ieee1284_epp_read_addr (struct parport *,
 /* IEEE1284.3 functions */
 extern int parport_daisy_init (struct parport *port);
 extern void parport_daisy_fini (struct parport *port);
-extern struct pardevice *parport_open (int devnum, const char *name,
-				       int (*pf) (void *),
-				       void (*kf) (void *),
-				       void (*irqf) (int, void *),
-				       int flags, void *handle);
+extern struct pardevice *parport_open (int devnum, const char *name);
 extern void parport_close (struct pardevice *dev);
 extern ssize_t parport_device_id (int devnum, char *buffer, size_t len);
 extern void parport_daisy_deselect_all (struct parport *port);
@@ -523,7 +519,7 @@ static inline void parport_generic_irq(struct parport *port)
 	parport_ieee1284_interrupt (port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
-		port->cad->irq_func(port->irq, port->cad->private);
+		port->cad->irq_func(port->cad->private);
 	read_unlock(&port->cad_lock);
 }
 
diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
index 911c159..dcc90f9 100644
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -830,7 +830,7 @@ static int __devinit snd_mts64_rawmidi_create(struct snd_card *card)
 /*********************************************************************
  * parport stuff
  *********************************************************************/
-static void snd_mts64_interrupt(int irq, void *private)
+static void snd_mts64_interrupt(void *private)
 {
 	struct mts64 *mts = ((struct snd_card*)private)->private_data;
 	u16 ret;
diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
index 0eb9b5c..e065b2a 100644
--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -611,7 +611,7 @@ static int __devinit snd_portman_rawmidi_create(struct snd_card *card)
 /*********************************************************************
  * parport stuff
  *********************************************************************/
-static void snd_portman_interrupt(int irq, void *userdata)
+static void snd_portman_interrupt(void *userdata)
 {
 	unsigned char midivalue = 0;
 	struct portman *pm = ((struct snd_card*)userdata)->private_data;
