Return-Path: <linux-kernel-owner+w=401wt.eu-S1030401AbXBTVLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbXBTVLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030399AbXBTVLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:11:04 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:4506 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030406AbXBTVLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:11:01 -0500
Date: Tue, 20 Feb 2007 22:10:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [patch/rfc 2.6.20-git] parport reports physical devices
Message-Id: <20070220221043.ead0b744.khali@linux-fr.org>
In-Reply-To: <200702190840.30643.david-b@pacbell.net>
References: <200702182108.08217.david-b@pacbell.net>
	<20070219151847.853c7035.khali@linux-fr.org>
	<200702190840.30643.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 19 Feb 2007 08:40:30 -0800, David Brownell wrote:
> On Monday 19 February 2007 6:18 am, Jean Delvare wrote:
> > Hi David,
> > 
> > On Sun, 18 Feb 2007 21:08:07 -0800, David Brownell wrote:
> > > Currently a parport_driver can't get a handle on the device node for the
> > > underlying parport (PNPACPI, PCI, etc).  That prevents correct placement
> > > of sysfs child nodes, which can affect things like power management.
> > > 
> > > This patch resolves that issue for non-legacy configurations:
> > > 
> > >     * "struct parport" now has a field pointing to that device node,
> > >       and non-legacy port drivers now initialize that device pointer:
> > > 	- parport_mfc3 (can't test or build; no Amiga + Zorro here)
> > > 	- parport_pc (and stop using only pci_device internally)
> > 
> > Only in the PCI and PNP cases. Super-I/O and legacy cases still don't
> > have a valid device pointer to pass. This annoys me because the laptop
> > I'm using for my daily work has such a legacy parallel port, 
> 
> And SuperIO precludes PNP support?  I guess that's one of the Mysteries.

I don't think I have a Super-I/O chip in this laptop, and no PNP
either (not for parport at least.) Most probably it has a totally
legacy parallel port.

> Well, as I said, "non-legacy" configs.  One must start somewhere, and
> I have no (working) legacy hardware to even try!

Sure, the parport stuff is such a mess (showing its age I guess) that
we can't hope to fix everything at once, and your patch is definitely a
move in the right direction.

> > Tested on my other machine with has a PNP parallel port too, and it
> > worked fine. Great :)
> 
> Good!  Did you happen to try parport printing, with DMA?

(/me looks at his brand new HP LaserJet P2015n network printer.)

Parallel-port printers are soooo 20th century! ;)

Seriously, no, the only parallel port devices I have are hardware
monitoring evaluation boards. I can't test much advanced parport
functionalities with these, I fear.

> > > --- g26.orig/drivers/i2c/busses/i2c-parport.c	2006-12-12 19:25:43.000000000 -0800
> > > +++ g26/drivers/i2c/busses/i2c-parport.c	2007-02-18 09:13:34.000000000 -0800
> > > @@ -143,7 +143,7 @@ static struct i2c_algo_bit_data parport_
> > >  
> > >  /* ----- I2c and parallel port call-back functions and structures --------- */
> > >  
> > > -static struct i2c_adapter parport_adapter = {
> > > +static const struct i2c_adapter parport_adapter = {
> > >  	.owner		= THIS_MODULE,
> > >  	.class		= I2C_CLASS_HWMON,
> > >  	.id		= I2C_HW_B_LP,
> > 
> > This change doesn't belong to this patch at all, although it is
> > correct. I'll be happy to apply it if you send it to me separately.
> > 
> > (Or it might be even better to get rid of this static structure
> > altogether and intialize the fields of the dynamically allocated
> > structure individually instead. This would make the driver smaller.)
> 
> Smaller is better.  ;)

Patch written, I'll post it on the i2c list in a moment.

> > Which means that I will have to fix the legacy parport_pc case right
> > now, otherwise I will no longer be able to use i2c-parport and this
> > isn't an option for me.
> 
> I admire your enthusiasm.  :)
> 
> 
> > What do you think would be the right way to do 
> > it? A platform driver I guess, and we create a platform device for
> > every successful call to parport_pc_probe_port() with a NULL dev
> > pointer? That would be a fake driver, as the probe() and remove()
> > methods would do nothing as far as I can see, but that's all I can
> > think of at the moment.
> 
> Yes, a platform_driver ... and ideally, moving all that hardware probing
> and scanning code into a separate file.  Probe/scan steps shouldn't really
> be part of *any* driver.

I fear I don't have the spare cycles to fulfill the "ideally" part.
Here is the naive patch I have come up with. It does the job, even
though it is not clean by any means. But as you said, it's certainly not
worse than the current state, so I hope we can still apply it.

* * * * *

Give legacy parallel ports a platform device in the device tree.
This is a quick and dirty implementation, it doesn't actually convert
the legacy parport code to the device driver model, but at least
parallel port device drivers will have a device to work with.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/parport/parport_pc.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- linux-2.6.21-pre.orig/drivers/parport/parport_pc.c	2007-02-19 12:03:44.000000000 +0100
+++ linux-2.6.21-pre/drivers/parport/parport_pc.c	2007-02-19 18:15:41.000000000 +0100
@@ -53,6 +53,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/pnp.h>
+#include <linux/platform_device.h>
 #include <linux/sysctl.h>
 
 #include <asm/io.h>
@@ -2156,6 +2157,17 @@ struct parport *parport_pc_probe_port (u
 	struct resource *base_res;
 	struct resource	*ECR_res = NULL;
 	struct resource	*EPP_res = NULL;
+	struct platform_device *pdev = NULL;
+
+	if (!dev) {
+		/* We need a physical device to attach to, but none was
+		   provided. Create our own. */
+		pdev = platform_device_register_simple("parport_pc",
+						       base, NULL, 0);
+		if (IS_ERR(pdev))
+			return NULL;
+		dev = &pdev->dev;
+	}
 
 	ops = kmalloc(sizeof (struct parport_operations), GFP_KERNEL);
 	if (!ops)
@@ -2359,6 +2371,8 @@ out3:
 out2:
 	kfree (ops);
 out1:
+	if (pdev)
+		platform_device_unregister(pdev);
 	return NULL;
 }
 
@@ -3106,6 +3120,21 @@ static struct pnp_driver parport_pc_pnp_
 };
 
 
+static int __devinit parport_pc_platform_probe(struct platform_device *pdev)
+{
+	/* Always succeed, the actual probing is done in
+	   parport_pc_probe_port(). */
+	return 0;
+}
+
+static struct platform_driver parport_pc_platform_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "parport_pc",
+	},
+	.probe		= parport_pc_platform_probe,
+};
+
 /* This is called by parport_pc_find_nonpci_ports (in asm/parport.h) */
 static int __devinit __attribute__((unused))
 parport_pc_find_isa_ports (int autoirq, int autodma)
@@ -3381,9 +3410,15 @@ __setup("parport_init_mode=",parport_ini
 
 static int __init parport_pc_init(void)
 {
+	int err;
+
 	if (parse_parport_params())
 		return -EINVAL;
 
+	err = platform_driver_register(&parport_pc_platform_driver);
+	if (err)
+		return err;
+
 	if (io[0]) {
 		int i;
 		/* Only probe the ports we were given. */
@@ -3408,6 +3443,7 @@ static void __exit parport_pc_exit(void)
 		pci_unregister_driver (&parport_pc_pci_driver);
 	if (pnp_registered_parport)
 		pnp_unregister_driver (&parport_pc_pnp_driver);
+	platform_driver_unregister(&parport_pc_platform_driver);
 
 	spin_lock(&ports_lock);
 	while (!list_empty(&ports_list)) {
@@ -3416,6 +3452,9 @@ static void __exit parport_pc_exit(void)
 		priv = list_entry(ports_list.next,
 				  struct parport_pc_private, list);
 		port = priv->port;
+		if (port->dev && port->dev->bus == &platform_bus_type)
+			platform_device_unregister(
+				to_platform_device(port->dev));
 		spin_unlock(&ports_lock);
 		parport_pc_unregister_port(port);
 		spin_lock(&ports_lock);

* * * * *

> There are probably good reasons (== deep hardware braindamage on older
> systems that are now hard to find) for the strange init sequencing in
> that code, but I can't see why they should prevent splitting out
> 
> 	(a) device discovery via probing, PNP, or whatever; from
> 
> 	(b) the driver itself, getting handed a device node that's
> 	    pre-configured with the resources reported by discovery.
> 
> Maybe the maintainers of the parport stack will have comments.  Though
> the info in MAINTAINERS seems dated, if not obsolete.

Phil Blundell and Tim Waugh did not reply to me last time I sent a
parport cleanup patch to them. I suspect they are indeed no longer
maintaining parport in practice.

-- 
Jean Delvare
