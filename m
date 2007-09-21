Return-Path: <linux-kernel-owner+w=401wt.eu-S1764477AbXIUWNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764477AbXIUWNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbXIUWMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:12:53 -0400
Received: from lixom.net ([66.141.50.11]:50131 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbXIUWMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:12:51 -0400
Date: Fri, 21 Sep 2007 17:15:16 -0500
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org, hch@lst.de,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v2] pcmcia: Convert io_req_t to use kio_addr_t
Message-ID: <20070921221516.GA7926@lixom.net>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914034854.1658a9cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the io_req_t members to kio_addr_t, to allow use on machines with
more than 16 bits worth of IO ports (i.e. secondary busses on ppc64, etc).
    
I've also gone through the drivers, changed the few occurrances of
ioaddr_t to kio_addr_t where relevant, and changed format strings for
printk() and friends.
    
There are still places where a kio_addr_t is casted to an int, but at
the moment that's not causing problems. It should be cleaned up at some
point in the future though.

    
Signed-off-by: Olof Johansson <olof@lixom.net>


---

On Fri, Sep 14, 2007 at 03:48:54AM -0700, Andrew Morton wrote:
> On Wed, 5 Sep 2007 09:27:43 -0500 Olof Johansson <olof@lixom.net> wrote:
> 
> > Convert the io_req_t members to kio_addr_t, to allow use on machines with
> > more than 16 bits worth of IO port address space (ppc64 in this case,
> > but it applies to others as well).
> 
> drivers/usb/host/sl811_cs.c: In function 'sl811_cs_config':
> drivers/usb/host/sl811_cs.c:263: warning: format '%04x' expects type 'unsigned int', but argument 2 has type 'kio_addr_t'
> drivers/usb/host/sl811_cs.c:263: warning: format '%04x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
> 
> That's not just a cosmetic thing - the printk can print junk and if there's
> a %s in the control string after the %x's, printk() will crash.
> 
> I don't know how many instances of this are in the tree, but they'll all
> need to be found and fixed.

I think I caught them all by now.


Thanks,

-Olof


diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 4177f6d..b4f6036 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -308,7 +308,7 @@ static unsigned int calc_baudv(unsigned char fidi)
 	return (wcrcf / wbrcf);
 }
 
-static unsigned short io_read_num_rec_bytes(ioaddr_t iobase, unsigned short *s)
+static unsigned short io_read_num_rec_bytes(kio_addr_t iobase, unsigned short *s)
 {
 	unsigned short tmp;
 
@@ -426,7 +426,7 @@ static struct card_fixup card_fixups[] = {
 static void set_cardparameter(struct cm4000_dev *dev)
 {
 	int i;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	kio_addr_t iobase = dev->p_dev->io.BasePort1;
 	u_int8_t stopbits = 0x02; /* ISO default */
 
 	DEBUGP(3, dev, "-> set_cardparameter\n");
@@ -459,7 +459,7 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 	unsigned short num_bytes_read;
 	unsigned char pts_reply[4];
 	ssize_t rc;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	kio_addr_t iobase = dev->p_dev->io.BasePort1;
 
 	rc = 0;
 
@@ -610,7 +610,7 @@ exit_setprotocol:
 	return rc;
 }
 
-static int io_detect_cm4000(ioaddr_t iobase, struct cm4000_dev *dev)
+static int io_detect_cm4000(kio_addr_t iobase, struct cm4000_dev *dev)
 {
 
 	/* note: statemachine is assumed to be reset */
@@ -671,7 +671,7 @@ static void terminate_monitor(struct cm4000_dev *dev)
 static void monitor_card(unsigned long p)
 {
 	struct cm4000_dev *dev = (struct cm4000_dev *) p;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	kio_addr_t iobase = dev->p_dev->io.BasePort1;
 	unsigned short s;
 	struct ptsreq ptsreq;
 	int i, atrc;
@@ -933,7 +933,7 @@ static ssize_t cmm_read(struct file *filp, __user char *buf, size_t count,
 			loff_t *ppos)
 {
 	struct cm4000_dev *dev = filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	kio_addr_t iobase = dev->p_dev->io.BasePort1;
 	ssize_t rc;
 	int i, j, k;
 
@@ -1054,7 +1054,7 @@ static ssize_t cmm_write(struct file *filp, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	struct cm4000_dev *dev = (struct cm4000_dev *) filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	kio_addr_t iobase = dev->p_dev->io.BasePort1;
 	unsigned short s;
 	unsigned char tmp;
 	unsigned char infolen;
@@ -1408,7 +1408,7 @@ static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		     unsigned long arg)
 {
 	struct cm4000_dev *dev = filp->private_data;
-	ioaddr_t iobase = dev->p_dev->io.BasePort1;
+	kio_addr_t iobase = dev->p_dev->io.BasePort1;
 	struct pcmcia_device *link;
 	int size;
 	int rc;
diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index b24a3e7..3ecfc33 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -586,7 +586,7 @@ static int reader_config(struct pcmcia_device *link, int devno)
 	dev->node.minor = devno;
 	dev->node.next = &dev->node;
 
-	DEBUGP(2, dev, "device " DEVICE_NAME "%d at 0x%.4x-0x%.4x\n", devno,
+	DEBUGP(2, dev, "device " DEVICE_NAME "%d at 0x%.4lx-0x%.4lx\n", devno,
 	      link->io.BasePort1, link->io.BasePort1+link->io.NumPorts1);
 	DEBUGP(2, dev, "<- reader_config (succ)\n");
 
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 2b88931..7be068f 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -665,7 +665,7 @@ static int mgslpc_config(struct pcmcia_device *link)
     if (link->conf.Attributes & CONF_ENABLE_IRQ)
 	    printk(", irq %d", link->irq.AssignedIRQ);
     if (link->io.NumPorts1)
-	    printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+	    printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
 		   link->io.BasePort1+link->io.NumPorts1-1);
     printk("\n");
     return 0;
diff --git a/drivers/isdn/hardware/avm/avm_cs.c b/drivers/isdn/hardware/avm/avm_cs.c
index a5b941c..820853a 100644
--- a/drivers/isdn/hardware/avm/avm_cs.c
+++ b/drivers/isdn/hardware/avm/avm_cs.c
@@ -211,7 +211,7 @@ static int avmcs_config(struct pcmcia_device *link)
 		link->io.BasePort1 = cf->io.win[0].base;
 		link->io.NumPorts1 = cf->io.win[0].len;
 		link->io.NumPorts2 = 0;
-                printk(KERN_INFO "avm_cs: testing i/o %#x-%#x\n",
+                printk(KERN_INFO "avm_cs: testing i/o %#lx-%#lx\n",
 			link->io.BasePort1,
 		        link->io.BasePort1+link->io.NumPorts1-1);
 		i = pcmcia_request_io(link, &link->io);
@@ -288,7 +288,7 @@ found_port:
         case AVM_CARDTYPE_B1: addcard = b1pcmcia_addcard_b1; break;
     }
     if ((i = (*addcard)(link->io.BasePort1, link->irq.AssignedIRQ)) < 0) {
-        printk(KERN_ERR "avm_cs: failed to add AVM-%s-Controller at i/o %#x, irq %d\n",
+        printk(KERN_ERR "avm_cs: failed to add AVM-%s-Controller at i/o %#lx, irq %d\n",
 		dev->node.dev_name, link->io.BasePort1, link->irq.AssignedIRQ);
 	avmcs_release(link);
 	return -ENODEV;
diff --git a/drivers/isdn/hisax/avma1_cs.c b/drivers/isdn/hisax/avma1_cs.c
index fc6cc2c..6a75ba6 100644
--- a/drivers/isdn/hisax/avma1_cs.c
+++ b/drivers/isdn/hisax/avma1_cs.c
@@ -233,7 +233,7 @@ static int avma1cs_config(struct pcmcia_device *link)
 		link->io.BasePort1 = cf->io.win[0].base;
 		link->io.NumPorts1 = cf->io.win[0].len;
 		link->io.NumPorts2 = 0;
-		printk(KERN_INFO "avma1_cs: testing i/o %#x-%#x\n",
+		printk(KERN_INFO "avma1_cs: testing i/o %#lx-%#lx\n",
 			link->io.BasePort1,
 			link->io.BasePort1+link->io.NumPorts1 - 1);
 		i = pcmcia_request_io(link, &link->io);
@@ -285,7 +285,7 @@ found_port:
 	return -ENODEV;
     }
 
-    printk(KERN_NOTICE "avma1_cs: checking at i/o %#x, irq %d\n",
+    printk(KERN_NOTICE "avma1_cs: checking at i/o %#lx, irq %d\n",
 				link->io.BasePort1, link->irq.AssignedIRQ);
 
     icard.para[0] = link->irq.AssignedIRQ;
@@ -295,7 +295,7 @@ found_port:
     
     i = hisax_init_pcmcia(link, &busy, &icard);
     if (i < 0) {
-    	printk(KERN_ERR "avma1_cs: failed to initialize AVM A1 PCMCIA %d at i/o %#x\n", i, link->io.BasePort1);
+    	printk(KERN_ERR "avma1_cs: failed to initialize AVM A1 PCMCIA %d at i/o %#lx\n", i, link->io.BasePort1);
 	avma1cs_release(link);
 	return -ENODEV;
     }
diff --git a/drivers/isdn/hisax/elsa_cs.c b/drivers/isdn/hisax/elsa_cs.c
index db7e644..6d2b338 100644
--- a/drivers/isdn/hisax/elsa_cs.c
+++ b/drivers/isdn/hisax/elsa_cs.c
@@ -296,10 +296,10 @@ static int elsa_cs_config(struct pcmcia_device *link)
     if (link->conf.Attributes & CONF_ENABLE_IRQ)
         printk(", irq %d", link->irq.AssignedIRQ);
     if (link->io.NumPorts1)
-        printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+        printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
                link->io.BasePort1+link->io.NumPorts1-1);
     if (link->io.NumPorts2)
-        printk(" & 0x%04x-0x%04x", link->io.BasePort2,
+        printk(" & 0x%04lx-0x%04lx", link->io.BasePort2,
                link->io.BasePort2+link->io.NumPorts2-1);
     printk("\n");
 
@@ -310,7 +310,7 @@ static int elsa_cs_config(struct pcmcia_device *link)
     
     i = hisax_init_pcmcia(link, &(((local_info_t*)link->priv)->busy), &icard);
     if (i < 0) {
-    	printk(KERN_ERR "elsa_cs: failed to initialize Elsa PCMCIA %d at i/o %#x\n",
+    	printk(KERN_ERR "elsa_cs: failed to initialize Elsa PCMCIA %d at i/o %#lx\n",
     		i, link->io.BasePort1);
     	elsa_cs_release(link);
     } else
diff --git a/drivers/isdn/hisax/sedlbauer_cs.c b/drivers/isdn/hisax/sedlbauer_cs.c
index 439cb53..fdead4c 100644
--- a/drivers/isdn/hisax/sedlbauer_cs.c
+++ b/drivers/isdn/hisax/sedlbauer_cs.c
@@ -381,10 +381,10 @@ static int sedlbauer_config(struct pcmcia_device *link)
     if (link->conf.Attributes & CONF_ENABLE_IRQ)
 	printk(", irq %d", link->irq.AssignedIRQ);
     if (link->io.NumPorts1)
-	printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+	printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
 	       link->io.BasePort1+link->io.NumPorts1-1);
     if (link->io.NumPorts2)
-	printk(" & 0x%04x-0x%04x", link->io.BasePort2,
+	printk(" & 0x%04lx-0x%04lx", link->io.BasePort2,
 	       link->io.BasePort2+link->io.NumPorts2-1);
     if (link->win)
 	printk(", mem 0x%06lx-0x%06lx", req.Base,
@@ -398,7 +398,7 @@ static int sedlbauer_config(struct pcmcia_device *link)
     
     last_ret = hisax_init_pcmcia(link, &(((local_info_t*)link->priv)->stop), &icard);
     if (last_ret < 0) {
-    	printk(KERN_ERR "sedlbauer_cs: failed to initialize SEDLBAUER PCMCIA %d at i/o %#x\n",
+    	printk(KERN_ERR "sedlbauer_cs: failed to initialize SEDLBAUER PCMCIA %d at i/o %#lx\n",
     		last_ret, link->io.BasePort1);
     	sedlbauer_release(link);
 	return -ENODEV;
diff --git a/drivers/isdn/hisax/teles_cs.c b/drivers/isdn/hisax/teles_cs.c
index ab4bd45..e492bd2 100644
--- a/drivers/isdn/hisax/teles_cs.c
+++ b/drivers/isdn/hisax/teles_cs.c
@@ -286,10 +286,10 @@ static int teles_cs_config(struct pcmcia_device *link)
     if (link->conf.Attributes & CONF_ENABLE_IRQ)
         printk(", irq %d", link->irq.AssignedIRQ);
     if (link->io.NumPorts1)
-        printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+        printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
                link->io.BasePort1+link->io.NumPorts1-1);
     if (link->io.NumPorts2)
-        printk(" & 0x%04x-0x%04x", link->io.BasePort2,
+        printk(" & 0x%04lx-0x%04lx", link->io.BasePort2,
                link->io.BasePort2+link->io.NumPorts2-1);
     printk("\n");
 
@@ -300,7 +300,7 @@ static int teles_cs_config(struct pcmcia_device *link)
     
     i = hisax_init_pcmcia(link, &(((local_info_t*)link->priv)->busy), &icard);
     if (i < 0) {
-    	printk(KERN_ERR "teles_cs: failed to initialize Teles PCMCIA %d at i/o %#x\n",
+    	printk(KERN_ERR "teles_cs: failed to initialize Teles PCMCIA %d at i/o %#lx\n",
     		i, link->io.BasePort1);
     	teles_cs_release(link);
 	return -ENODEV;
diff --git a/drivers/net/pcmcia/com20020_cs.c b/drivers/net/pcmcia/com20020_cs.c
index ea9414c..f5351c0 100644
--- a/drivers/net/pcmcia/com20020_cs.c
+++ b/drivers/net/pcmcia/com20020_cs.c
@@ -259,7 +259,7 @@ static int com20020_config(struct pcmcia_device *link)
 
     DEBUG(0, "com20020_config(0x%p)\n", link);
 
-    DEBUG(1,"arcnet: baseport1 is %Xh\n", link->io.BasePort1);
+    DEBUG(1,"arcnet: baseport1 is %lXh\n", link->io.BasePort1);
     i = !CS_SUCCESS;
     if (!link->io.BasePort1)
     {
diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index f123553..2a3544f 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -356,10 +356,10 @@ static int airo_config(struct pcmcia_device *link)
 	if (link->conf.Attributes & CONF_ENABLE_IRQ)
 		printk(", irq %d", link->irq.AssignedIRQ);
 	if (link->io.NumPorts1)
-		printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+		printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
 		       link->io.BasePort1+link->io.NumPorts1-1);
 	if (link->io.NumPorts2)
-		printk(" & 0x%04x-0x%04x", link->io.BasePort2,
+		printk(" & 0x%04lx-0x%04lx", link->io.BasePort2,
 		       link->io.BasePort2+link->io.NumPorts2-1);
 	if (link->win)
 		printk(", mem 0x%06lx-0x%06lx", req.Base,
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 30e723f..93c6b0b 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -721,10 +721,10 @@ static int prism2_config(struct pcmcia_device *link)
 	if (link->conf.Attributes & CONF_ENABLE_IRQ)
 		printk(", irq %d", link->irq.AssignedIRQ);
 	if (link->io.NumPorts1)
-		printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+		printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
 		       link->io.BasePort1+link->io.NumPorts1-1);
 	if (link->io.NumPorts2)
-		printk(" & 0x%04x-0x%04x", link->io.BasePort2,
+		printk(" & 0x%04lx-0x%04lx", link->io.BasePort2,
 		       link->io.BasePort2+link->io.NumPorts2-1);
 	printk("\n");
 
diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco_cs.c
index d1e5022..80bd2f6 100644
--- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -332,7 +332,7 @@ orinoco_cs_config(struct pcmcia_device *link)
 
 	/* Finally, report what we've done */
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "
-	       "0x%04x-0x%04x\n", dev->name, dev->dev.parent->bus_id,
+	       "0x%04lx-0x%04lx\n", dev->name, dev->dev.parent->bus_id,
 	       link->irq.AssignedIRQ, link->io.BasePort1,
 	       link->io.BasePort1 + link->io.NumPorts1 - 1);
 
diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/spectrum_cs.c
index af70460..b87185e 100644
--- a/drivers/net/wireless/spectrum_cs.c
+++ b/drivers/net/wireless/spectrum_cs.c
@@ -806,7 +806,7 @@ spectrum_cs_config(struct pcmcia_device *link)
 
 	/* Finally, report what we've done */
 	printk(KERN_DEBUG "%s: " DRIVER_NAME " at %s, irq %d, io "
-	       "0x%04x-0x%04x\n", dev->name, dev->dev.parent->bus_id,
+	       "0x%04lx-0x%04lx\n", dev->name, dev->dev.parent->bus_id,
 	       link->irq.AssignedIRQ, link->io.BasePort1,
 	       link->io.BasePort1 + link->io.NumPorts1 - 1);
 
diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 802a81d..17a4cfb 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -203,7 +203,7 @@ static int parport_config(struct pcmcia_device *link)
 			      &link->dev);
     if (p == NULL) {
 	printk(KERN_NOTICE "parport_cs: parport_pc_probe_port() at "
-	       "0x%3x, irq %u failed\n", link->io.BasePort1,
+	       "0x%3lx, irq %u failed\n", link->io.BasePort1,
 	       link->irq.AssignedIRQ);
 	goto failed;
     }
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 0ce39de..585c14b 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -65,8 +65,8 @@ extern int ds_pc_debug;
  * Special stuff for managing IO windows, because they are scarce
  */
 
-static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
-			  ioaddr_t num, u_int lines)
+static int alloc_io_space(struct pcmcia_socket *s, u_int attr, kio_addr_t *base,
+			  kio_addr_t num, u_int lines)
 {
 	int i;
 	kio_addr_t try, align;
@@ -74,14 +74,14 @@ static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
 	align = (*base) ? (lines ? 1<<lines : 0) : 1;
 	if (align && (align < num)) {
 		if (*base) {
-			ds_dbg(s, 0, "odd IO request: num %#x align %#lx\n",
+			ds_dbg(s, 0, "odd IO request: num %#lx align %#lx\n",
 			       num, align);
 			align = 0;
 		} else
 			while (align && (align < num)) align <<= 1;
 	}
 	if (*base & ~(align-1)) {
-		ds_dbg(s, 0, "odd IO request: base %#x align %#lx\n",
+		ds_dbg(s, 0, "odd IO request: base %#lx align %#lx\n",
 		       *base, align);
 		align = 0;
 	}
@@ -132,8 +132,8 @@ static int alloc_io_space(struct pcmcia_socket *s, u_int attr, ioaddr_t *base,
 } /* alloc_io_space */
 
 
-static void release_io_space(struct pcmcia_socket *s, ioaddr_t base,
-			     ioaddr_t num)
+static void release_io_space(struct pcmcia_socket *s, kio_addr_t base,
+			     kio_addr_t num)
 {
 	int i;
 
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 4b82b20..42611e6 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -160,7 +160,7 @@ static int fdomain_config(struct pcmcia_device *link)
     release_region(link->io.BasePort1, link->io.NumPorts1);
 
     /* Set configuration options for the fdomain driver */
-    sprintf(str, "%d,%d", link->io.BasePort1, link->irq.AssignedIRQ);
+    sprintf(str, "%ld,%d", link->io.BasePort1, link->irq.AssignedIRQ);
     fdomain_setup(str);
 
     host = __fdomain_16x0_detect(&fdomain_driver_template);
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 445cfbb..7e9a897 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1896,11 +1896,11 @@ static int nsp_cs_config(struct pcmcia_device *link)
 		printk(", irq %d", link->irq.AssignedIRQ);
 	}
 	if (link->io.NumPorts1) {
-		printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+		printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
 		       link->io.BasePort1+link->io.NumPorts1-1);
 	}
 	if (link->io.NumPorts2)
-		printk(" & 0x%04x-0x%04x", link->io.BasePort2,
+		printk(" & 0x%04lx-0x%04lx", link->io.BasePort2,
 		       link->io.BasePort2+link->io.NumPorts2-1);
 	if (link->win)
 		printk(", mem 0x%06lx-0x%06lx", req.Base,
diff --git a/drivers/usb/host/sl811_cs.c b/drivers/usb/host/sl811_cs.c
index 5da63f5..062fba6 100644
--- a/drivers/usb/host/sl811_cs.c
+++ b/drivers/usb/host/sl811_cs.c
@@ -259,7 +259,7 @@ next_entry:
 	if (link->conf.Vpp)
 		printk(", Vpp %d.%d", link->conf.Vpp/10, link->conf.Vpp%10);
 	printk(", irq %d", link->irq.AssignedIRQ);
-	printk(", io 0x%04x-0x%04x", link->io.BasePort1,
+	printk(", io 0x%04lx-0x%04lx", link->io.BasePort1,
 	       link->io.BasePort1+link->io.NumPorts1-1);
 	printk("\n");
 
diff --git a/include/pcmcia/cs.h b/include/pcmcia/cs.h
index d5838c3..657d653 100644
--- a/include/pcmcia/cs.h
+++ b/include/pcmcia/cs.h
@@ -147,11 +147,11 @@ typedef struct config_req_t {
 
 /* For RequestIO and ReleaseIO */
 typedef struct io_req_t {
-    ioaddr_t	BasePort1;
-    ioaddr_t	NumPorts1;
+    kio_addr_t	BasePort1;
+    kio_addr_t	NumPorts1;
     u_int	Attributes1;
-    ioaddr_t	BasePort2;
-    ioaddr_t	NumPorts2;
+    kio_addr_t	BasePort2;
+    kio_addr_t	NumPorts2;
     u_int	Attributes2;
     u_int	IOAddrLines;
 } io_req_t;
