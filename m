Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbXKTJvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbXKTJvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbXKTJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:51:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbXKTJvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:51:25 -0500
Subject: [PATCH 2/3] PNP cleanups - Unify the pnp macros to access
	resources in the pnp resource table
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 10:51:23 +0100
Message-Id: <1195552283.23700.166.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unify the pnp macros to access resources in the pnp resource table

port, mem, dma and irq resource macros are now all used in the same
way. This is the basis (or makes it at least easier) for changing how
the resources are allocated for memory optimizations.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/ata/pata_isapnp.c             |    2 -
 drivers/char/tpm/tpm_tis.c            |    2 -
 drivers/ide/ide-pnp.c                 |    2 -
 drivers/input/serio/i8042-x86ia64io.h |    4 +--
 drivers/isdn/hisax/asuscom.c          |    2 -
 drivers/isdn/hisax/avm_pci.c          |    2 -
 drivers/isdn/hisax/diva.c             |    2 -
 drivers/isdn/hisax/elsa.c             |    2 -
 drivers/isdn/hisax/hfc_sx.c           |    2 -
 drivers/isdn/hisax/hfcscard.c         |    2 -
 drivers/isdn/hisax/hisax_fcpcipnp.c   |    2 -
 drivers/isdn/hisax/isurf.c            |    2 -
 drivers/isdn/hisax/ix1_micro.c        |    2 -
 drivers/isdn/hisax/niccy.c            |    2 -
 drivers/isdn/hisax/sedlbauer.c        |    2 -
 drivers/isdn/hisax/teles3.c           |    2 -
 drivers/mmc/host/wbsd.c               |    4 +--
 drivers/net/3c509.c                   |    2 -
 drivers/net/3c515.c                   |    4 +--
 drivers/net/irda/nsc-ircc.c           |    4 +--
 drivers/net/irda/smsc-ircc2.c         |    4 +--
 drivers/net/ne.c                      |    2 -
 drivers/net/sb1000.c                  |    2 -
 drivers/net/smc-ultra.c               |    2 -
 drivers/parport/parport_pc.c          |    4 +--
 drivers/scsi/aha152x.c                |    2 -
 drivers/scsi/g_NCR5380.c              |    4 +--
 drivers/scsi/sym53c416.c              |    2 -
 drivers/serial/8250_pnp.c             |    2 -
 include/linux/pnp.h                   |    2 -
 sound/drivers/mpu401/mpu401.c         |    2 -
 sound/isa/ad1816a/ad1816a.c           |    8 +++---
 sound/isa/als100.c                    |    8 +++---
 sound/isa/azt2320.c                   |    8 +++---
 sound/isa/cmi8330.c                   |   10 +++----
 sound/isa/cs423x/cs4236.c             |   11 ++++----
 sound/isa/dt019x.c                    |    6 ++--
 sound/isa/es18xx.c                    |   12 ++++-----
 sound/isa/gus/interwave.c             |    6 ++--
 sound/isa/opl3sa2.c                   |    6 ++--
 sound/isa/opti9xx/opti92x-ad1848.c    |    8 +++---
 sound/isa/sb/es968.c                  |    4 +--
 sound/isa/sb/sb16.c                   |    6 ++--
 sound/isa/sscape.c                    |    8 +++---
 sound/isa/wavefront/wavefront.c       |   10 +++----
 sound/oss/ad1848.c                    |    6 ++--
 sound/oss/sb_card.c                   |   44 +++++++++++++++++-----------------
 47 files changed, 118 insertions(+), 119 deletions(-)

Index: linux-2.6.24-rc2/include/linux/pnp.h
===================================================================
--- linux-2.6.24-rc2.orig/include/linux/pnp.h
+++ linux-2.6.24-rc2/include/linux/pnp.h
@@ -55,7 +55,6 @@ struct pnp_dev;
 	 (pnp_mem_end((dev),(bar)) -		\
 	  pnp_mem_start((dev),(bar)) + 1))
 
-#define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
 #define pnp_irq_start(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
 #define pnp_irq_end(dev,bar)	 ((dev)->res.irq_resource[(bar)].end)
 #define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
@@ -63,7 +62,6 @@ struct pnp_dev;
 	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
 		== IORESOURCE_IRQ)
 
-#define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
 #define pnp_dma_start(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
 #define pnp_dma_end(dev,bar)	 ((dev)->res.dma_resource[(bar)].end)
 #define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
Index: linux-2.6.24-rc2/drivers/input/serio/i8042-x86ia64io.h
===================================================================
--- linux-2.6.24-rc2.orig/drivers/input/serio/i8042-x86ia64io.h
+++ linux-2.6.24-rc2/drivers/input/serio/i8042-x86ia64io.h
@@ -295,7 +295,7 @@ static int i8042_pnp_kbd_probe(struct pn
 		i8042_pnp_command_reg = pnp_port_start(dev, 1);
 
 	if (pnp_irq_valid(dev,0))
-		i8042_pnp_kbd_irq = pnp_irq(dev, 0);
+		i8042_pnp_kbd_irq = pnp_irq_start(dev, 0);
 
 	strncpy(i8042_pnp_kbd_name, did->id, sizeof(i8042_pnp_kbd_name));
 	if (strlen(pnp_dev_name(dev))) {
@@ -316,7 +316,7 @@ static int i8042_pnp_aux_probe(struct pn
 		i8042_pnp_command_reg = pnp_port_start(dev, 1);
 
 	if (pnp_irq_valid(dev, 0))
-		i8042_pnp_aux_irq = pnp_irq(dev, 0);
+		i8042_pnp_aux_irq = pnp_irq_start(dev, 0);
 
 	strncpy(i8042_pnp_aux_name, did->id, sizeof(i8042_pnp_aux_name));
 	if (strlen(pnp_dev_name(dev))) {
Index: linux-2.6.24-rc2/drivers/ata/pata_isapnp.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/ata/pata_isapnp.c
+++ linux-2.6.24-rc2/drivers/ata/pata_isapnp.c
@@ -115,7 +115,7 @@ static int isapnp_init_one(struct pnp_de
 		      (unsigned long long)pnp_port_start(idev, 1));
 
 	/* activate */
-	return ata_host_activate(host, pnp_irq(idev, 0), ata_interrupt, 0,
+	return ata_host_activate(host, pnp_irq_start(idev, 0), ata_interrupt, 0,
 				 &isapnp_sht);
 }
 
Index: linux-2.6.24-rc2/drivers/isdn/hisax/asuscom.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/asuscom.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/asuscom.c
@@ -350,7 +350,7 @@ setup_asuscom(struct IsdnCard *card)
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
-					card->para[0] = pnp_irq(pnp_d, 0);
+					card->para[0] = pnp_irq_start(pnp_d, 0);
 					if (!card->para[0] || !card->para[1]) {
 						printk(KERN_ERR "AsusPnP:some resources are missing %ld/%lx\n",
 							card->para[0], card->para[1]);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/avm_pci.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/avm_pci.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/avm_pci.c
@@ -802,7 +802,7 @@ static int __devinit avm_pnp_setup(struc
 			}
 			cs->hw.avm.cfg_reg =
 				pnp_port_start(pnp_avm_d, 0);
-			cs->irq = pnp_irq(pnp_avm_d, 0);
+				cs->irq = pnp_irq_start(pnp_avm_d, 0);
 			if (!cs->irq) {
 				printk(KERN_ERR "FritzPnP:No IRQ\n");
 				return(0);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/diva.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/diva.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/diva.c
@@ -1092,7 +1092,7 @@ static int __devinit setup_diva_isapnp(s
 					return(0);
 				}
 				card->para[1] = pnp_port_start(pnp_d, 0);
-				card->para[0] = pnp_irq(pnp_d, 0);
+						card->para[0] = pnp_irq_start(pnp_d, 0);
 				if (!card->para[0] || !card->para[1]) {
 					printk(KERN_ERR "Diva PnP:some resources are missing %ld/%lx\n",
 						card->para[0], card->para[1]);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/elsa.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/elsa.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/elsa.c
@@ -941,7 +941,7 @@ setup_elsa_isapnp(struct IsdnCard *card)
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
-					card->para[0] = pnp_irq(pnp_d, 0);
+						card->para[0] = pnp_irq_start(pnp_d, 0);
 
 					if (!card->para[0] || !card->para[1]) {
 						printk(KERN_ERR "Elsa PnP:some resources are missing %ld/%lx\n",
Index: linux-2.6.24-rc2/drivers/isdn/hisax/hfc_sx.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/hfc_sx.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/hfc_sx.c
@@ -1424,7 +1424,7 @@ setup_hfcsx(struct IsdnCard *card)
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
-					card->para[0] = pnp_irq(pnp_d, 0);
+					card->para[0] = pnp_irq_start(pnp_d, 0);
 					if (!card->para[0] || !card->para[1]) {
 						printk(KERN_ERR "HFC PnP:some resources are missing %ld/%lx\n",
 							card->para[0], card->para[1]);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/hfcscard.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/hfcscard.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/hfcscard.c
@@ -198,7 +198,7 @@ setup_hfcs(struct IsdnCard *card)
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
-					card->para[0] = pnp_irq(pnp_d, 0);
+					card->para[0] = pnp_irq_start(pnp_d, 0);
 					if (!card->para[0] || !card->para[1]) {
 						printk(KERN_ERR "HFC PnP:some resources are missing %ld/%lx\n",
 							card->para[0], card->para[1]);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/hisax_fcpcipnp.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -940,7 +940,7 @@ static int __devinit fcpnp_probe(struct 
 		goto err_free;
 	}
 	adapter->io = pnp_port_start(pdev, 0);
-	adapter->irq = pnp_irq(pdev, 0);
+	adapter->irq = pnp_irq_start(pdev, 0);
 
 	printk(KERN_INFO "hisax_fcpcipnp: found adapter %s at IO %#x irq %d\n",
 	       (char *) dev_id->driver_data, adapter->io, adapter->irq);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/isurf.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/isurf.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/isurf.c
@@ -235,7 +235,7 @@ setup_isurf(struct IsdnCard *card)
 				err = pnp_activate_dev(pnp_d);
 				cs->hw.isurf.reset = pnp_port_start(pnp_d, 0);
 				cs->hw.isurf.phymem = pnp_mem_start(pnp_d, 1);
-				cs->irq = pnp_irq(pnp_d, 0);
+				cs->irq = pnp_irq_start(pnp_d, 0);
 				if (!cs->irq || !cs->hw.isurf.reset || !cs->hw.isurf.phymem) {
 					printk(KERN_ERR "ISurfPnP:some resources are missing %d/%x/%lx\n",
 						cs->irq, cs->hw.isurf.reset, cs->hw.isurf.phymem);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/ix1_micro.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/ix1_micro.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/ix1_micro.c
@@ -257,7 +257,7 @@ setup_ix1micro(struct IsdnCard *card)
 						return(0);
 					}
 					card->para[1] = pnp_port_start(pnp_d, 0);
-					card->para[0] = pnp_irq(pnp_d, 0);
+					card->para[0] = pnp_irq_start(pnp_d, 0);
 					if (!card->para[0] || !card->para[1]) {
 						printk(KERN_ERR "ITK PnP:some resources are missing %ld/%lx\n",
 							card->para[0], card->para[1]);
Index: linux-2.6.24-rc2/drivers/isdn/hisax/niccy.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/niccy.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/niccy.c
@@ -261,7 +261,7 @@ int __devinit setup_niccy(struct IsdnCar
 			}
 			card->para[1] = pnp_port_start(pnp_d, 0);
 			card->para[2] = pnp_port_start(pnp_d, 1);
-			card->para[0] = pnp_irq(pnp_d, 0);
+			card->para[0] = pnp_irq_start(pnp_d, 0);
 			if (!card->para[0] || !card->para[1] ||
 					!card->para[2]) {
 				printk(KERN_ERR "NiccyPnP:some resources are "
Index: linux-2.6.24-rc2/drivers/isdn/hisax/sedlbauer.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/sedlbauer.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/sedlbauer.c
@@ -559,7 +559,7 @@ setup_sedlbauer_isapnp(struct IsdnCard *
 					return(0);
 				}
 				card->para[1] = pnp_port_start(pnp_d, 0);
-				card->para[0] = pnp_irq(pnp_d, 0);
+						card->para[0] = pnp_irq_start(pnp_d, 0);
 
 				if (!card->para[0] || !card->para[1]) {
 					printk(KERN_ERR "Sedlbauer PnP:some resources are missing %ld/%lx\n",
Index: linux-2.6.24-rc2/drivers/isdn/hisax/teles3.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/isdn/hisax/teles3.c
+++ linux-2.6.24-rc2/drivers/isdn/hisax/teles3.c
@@ -307,7 +307,7 @@ setup_teles3(struct IsdnCard *card)
 					card->para[3] = pnp_port_start(pnp_d, 2);
 					card->para[2] = pnp_port_start(pnp_d, 1);
 					card->para[1] = pnp_port_start(pnp_d, 0);
-					card->para[0] = pnp_irq(pnp_d, 0);
+					card->para[0] = pnp_irq_start(pnp_d, 0);
 					if (!card->para[0] || !card->para[1] || !card->para[2]) {
 						printk(KERN_ERR "Teles PnP:some resources are missing %ld/%lx/%lx\n",
 							card->para[0], card->para[1], card->para[2]);
Index: linux-2.6.24-rc2/drivers/mmc/host/wbsd.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/mmc/host/wbsd.c
+++ linux-2.6.24-rc2/drivers/mmc/host/wbsd.c
@@ -1791,9 +1791,9 @@ wbsd_pnp_probe(struct pnp_dev *pnpdev, c
 	 * Get resources from PnP layer.
 	 */
 	io = pnp_port_start(pnpdev, 0);
-	irq = pnp_irq(pnpdev, 0);
+	irq = pnp_irq_start(pnpdev, 0);
 	if (pnp_dma_valid(pnpdev, 0))
-		dma = pnp_dma(pnpdev, 0);
+		dma = pnp_dma_start(pnpdev, 0);
 	else
 		dma = -1;
 
Index: linux-2.6.24-rc2/drivers/net/3c509.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/3c509.c
+++ linux-2.6.24-rc2/drivers/net/3c509.c
@@ -409,7 +409,7 @@ __again:
 				pnp_device_detach(idev);
 				return -EBUSY;
 			}
-			irq = pnp_irq(idev, 0);
+			irq = pnp_irq_start(idev, 0);
 			if (el3_debug > 3)
 				printk ("ISAPnP reports %s at i/o 0x%x, irq %d\n",
 					(char*) el3_isapnp_adapters[i].driver_data, ioaddr, irq);
Index: linux-2.6.24-rc2/drivers/net/3c515.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/3c515.c
+++ linux-2.6.24-rc2/drivers/net/3c515.c
@@ -524,7 +524,7 @@ static struct net_device *corkscrew_scan
 				continue;
 			}
 			ioaddr = pnp_port_start(idev, 0);
-			irq = pnp_irq(idev, 0);
+			irq = pnp_irq_start(idev, 0);
 			if (!check_device(ioaddr)) {
 				pnp_device_detach(idev);
 				continue;
@@ -572,7 +572,7 @@ static int corkscrew_setup(struct net_de
 	DECLARE_MAC_BUF(mac);
 
 	if (idev) {
-		irq = pnp_irq(idev, 0);
+		irq = pnp_irq_start(idev, 0);
 		vp->dev = &idev->dev;
 	} else {
 		irq = inw(ioaddr + 0x2002) & 15;
Index: linux-2.6.24-rc2/drivers/net/irda/nsc-ircc.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/irda/nsc-ircc.c
+++ linux-2.6.24-rc2/drivers/net/irda/nsc-ircc.c
@@ -934,11 +934,11 @@ static int nsc_ircc_pnp_probe(struct pnp
 
 	if (pnp_irq_valid(dev, 0) &&
 		!(pnp_irq_flags(dev, 0) & IORESOURCE_DISABLED))
-		pnp_info.irq = pnp_irq(dev, 0);
+		pnp_info.irq = pnp_irq_start(dev, 0);
 
 	if (pnp_dma_valid(dev, 0) &&
 		!(pnp_dma_flags(dev, 0) & IORESOURCE_DISABLED))
-		pnp_info.dma = pnp_dma(dev, 0);
+		pnp_info.dma = pnp_dma_start(dev, 0);
 
 	IRDA_DEBUG(0, "%s() : From PnP, found firbase 0x%03X ; irq %d ; dma %d.\n",
 		   __FUNCTION__, pnp_info.fir_base, pnp_info.irq, pnp_info.dma);
Index: linux-2.6.24-rc2/drivers/net/irda/smsc-ircc2.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/irda/smsc-ircc2.c
+++ linux-2.6.24-rc2/drivers/net/irda/smsc-ircc2.c
@@ -388,8 +388,8 @@ static int __init smsc_ircc_pnp_probe(st
 
 	sirbase = pnp_port_start(dev, 0);
 	firbase = pnp_port_start(dev, 1);
-	dma = pnp_dma(dev, 0);
-	irq = pnp_irq(dev, 0);
+	dma = pnp_dma_start(dev, 0);
+	irq = pnp_irq_start(dev, 0);
 
 	if (smsc_ircc_open(firbase, sirbase, dma, irq))
 		return -ENODEV;
Index: linux-2.6.24-rc2/drivers/net/ne.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/ne.c
+++ linux-2.6.24-rc2/drivers/net/ne.c
@@ -261,7 +261,7 @@ static int __init ne_probe_isapnp(struct
 			}
 			/* found it */
 			dev->base_addr = pnp_port_start(idev, 0);
-			dev->irq = pnp_irq(idev, 0);
+			dev->irq = pnp_irq_start(idev, 0);
 			printk(KERN_INFO "ne.c: ISAPnP reports %s at i/o %#lx, irq %d.\n",
 				(char *) isapnp_clone_list[i].driver_data,
 				dev->base_addr, dev->irq);
Index: linux-2.6.24-rc2/drivers/net/sb1000.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/sb1000.c
+++ linux-2.6.24-rc2/drivers/net/sb1000.c
@@ -157,7 +157,7 @@ sb1000_probe_one(struct pnp_dev *pdev, c
 	ioaddr[0] = pnp_port_start(pdev, 0);
 	ioaddr[1] = pnp_port_start(pdev, 0);
 
-	irq = pnp_irq(pdev, 0);
+	irq = pnp_irq_start(pdev, 0);
 
 	if (!request_region(ioaddr[0], 16, "sb1000"))
 		goto out_disable;
Index: linux-2.6.24-rc2/drivers/net/smc-ultra.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/net/smc-ultra.c
+++ linux-2.6.24-rc2/drivers/net/smc-ultra.c
@@ -342,7 +342,7 @@ static int __init ultra_probe_isapnp(str
 				goto __again;
                         /* found it */
 			dev->base_addr = pnp_port_start(idev, 0);
-			dev->irq = pnp_irq(idev, 0);
+			dev->irq = pnp_irq_start(idev, 0);
                         printk(KERN_INFO "smc-ultra.c: ISAPnP reports %s at i/o %#lx, irq %d.\n",
                                 (char *) ultra_device_ids[i].driver_data,
                                 dev->base_addr, dev->irq);
Index: linux-2.6.24-rc2/drivers/parport/parport_pc.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/parport/parport_pc.c
+++ linux-2.6.24-rc2/drivers/parport/parport_pc.c
@@ -3077,13 +3077,13 @@ static int parport_pc_pnp_probe(struct p
 
 	if (pnp_irq_valid(dev,0) &&
 		!(pnp_irq_flags(dev,0) & IORESOURCE_DISABLED)) {
-		irq = pnp_irq(dev,0);
+		irq = pnp_irq_start(dev,0);
 	} else
 		irq = PARPORT_IRQ_NONE;
 
 	if (pnp_dma_valid(dev,0) &&
 		!(pnp_dma_flags(dev,0) & IORESOURCE_DISABLED)) {
-		dma = pnp_dma(dev,0);
+		dma = pnp_dma_start(dev,0);
 	} else
 		dma = PARPORT_DMA_NONE;
 
Index: linux-2.6.24-rc2/drivers/scsi/aha152x.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/scsi/aha152x.c
+++ linux-2.6.24-rc2/drivers/scsi/aha152x.c
@@ -3800,7 +3800,7 @@ static int __init aha152x_init(void)
 			}
 
 			setup[setup_count].io_port     = pnp_port_start(dev, 0);
-			setup[setup_count].irq         = pnp_irq(dev, 0);
+			setup[setup_count].irq         = pnp_irq_start(dev, 0);
 			setup[setup_count].scsiid      = 7;
 			setup[setup_count].reconnect   = 1;
 			setup[setup_count].parity      = 1;
Index: linux-2.6.24-rc2/drivers/scsi/g_NCR5380.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/scsi/g_NCR5380.c
+++ linux-2.6.24-rc2/drivers/scsi/g_NCR5380.c
@@ -337,11 +337,11 @@ int __init generic_NCR5380_detect(struct
 				continue;
 			}
 			if (pnp_irq_valid(dev, 0))
-				overrides[count].irq = pnp_irq(dev, 0);
+				overrides[count].irq = pnp_irq_start(dev, 0);
 			else
 				overrides[count].irq = SCSI_IRQ_NONE;
 			if (pnp_dma_valid(dev, 0))
-				overrides[count].dma = pnp_dma(dev, 0);
+				overrides[count].dma = pnp_dma_start(dev, 0);
 			else
 				overrides[count].dma = DMA_NONE;
 			overrides[count].NCR5380_map_name = (NCR5380_map_type) pnp_port_start(dev, 0);
Index: linux-2.6.24-rc2/drivers/scsi/sym53c416.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/scsi/sym53c416.c
+++ linux-2.6.24-rc2/drivers/scsi/sym53c416.c
@@ -669,7 +669,7 @@ int __init sym53c416_detect(struct scsi_
 
 			i[0] = 2;
 			i[1] = pnp_port_start(idev, 0);
- 			i[2] = pnp_irq(idev, 0);
+ 			i[2] = pnp_irq_start(idev, 0);
 
 			printk(KERN_INFO "sym53c416: ISAPnP card found and configured at 0x%X, IRQ %d.\n",
 				i[1], i[2]);
Index: linux-2.6.24-rc2/sound/drivers/mpu401/mpu401.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/drivers/mpu401/mpu401.c
+++ linux-2.6.24-rc2/sound/drivers/mpu401/mpu401.c
@@ -178,7 +178,7 @@ static int __devinit snd_mpu401_pnp(int 
 		snd_printk(KERN_WARNING "no PnP irq, using polling\n");
 		irq[dev] = -1;
 	} else {
-		irq[dev] = pnp_irq(device, 0);
+		irq[dev] = pnp_irq_start(device, 0);
 	}
 	return 0;
 }
Index: linux-2.6.24-rc2/sound/isa/ad1816a/ad1816a.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/ad1816a/ad1816a.c
+++ linux-2.6.24-rc2/sound/isa/ad1816a/ad1816a.c
@@ -158,9 +158,9 @@ static int __devinit snd_card_ad1816a_pn
 
 	port[dev] = pnp_port_start(pdev, 2);
 	fm_port[dev] = pnp_port_start(pdev, 1);
-	dma1[dev] = pnp_dma(pdev, 0);
-	dma2[dev] = pnp_dma(pdev, 1);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma1[dev] = pnp_dma_start(pdev, 0);
+	dma2[dev] = pnp_dma_start(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
 
 	if (acard->devmpu == NULL) {
 		kfree(cfg);
@@ -183,7 +183,7 @@ static int __devinit snd_card_ad1816a_pn
 		acard->devmpu = NULL;
 	} else {
 		mpu_port[dev] = pnp_port_start(pdev, 0);
-		mpu_irq[dev] = pnp_irq(pdev, 0);
+		mpu_irq[dev] = pnp_irq_start(pdev, 0);
 	}
 
 	kfree(cfg);
Index: linux-2.6.24-rc2/sound/isa/als100.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/als100.c
+++ linux-2.6.24-rc2/sound/isa/als100.c
@@ -146,9 +146,9 @@ static int __devinit snd_card_als100_pnp
 		return err;
 	}
 	port[dev] = pnp_port_start(pdev, 0);
-	dma8[dev] = pnp_dma(pdev, 1);
-	dma16[dev] = pnp_dma(pdev, 0);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma8[dev] = pnp_dma_start(pdev, 1);
+	dma16[dev] = pnp_dma_start(pdev, 0);
+	irq[dev] = pnp_irq_start(pdev, 0);
 
 	pdev = acard->devmpu;
 	if (pdev != NULL) {
@@ -163,7 +163,7 @@ static int __devinit snd_card_als100_pnp
 		if (err < 0)
 			goto __mpu_error;
 		mpu_port[dev] = pnp_port_start(pdev, 0);
-		mpu_irq[dev] = pnp_irq(pdev, 0);
+		mpu_irq[dev] = pnp_irq_start(pdev, 0);
 	} else {
 	     __mpu_error:
 	     	if (pdev) {
Index: linux-2.6.24-rc2/sound/isa/azt2320.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/azt2320.c
+++ linux-2.6.24-rc2/sound/isa/azt2320.c
@@ -163,9 +163,9 @@ static int __devinit snd_card_azt2320_pn
 	port[dev] = pnp_port_start(pdev, 0);
 	fm_port[dev] = pnp_port_start(pdev, 1);
 	wss_port[dev] = pnp_port_start(pdev, 2);
-	dma1[dev] = pnp_dma(pdev, 0);
-	dma2[dev] = pnp_dma(pdev, 1);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma1[dev] = pnp_dma_start(pdev, 0);
+	dma2[dev] = pnp_dma_start(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
 
 	pdev = acard->devmpu;
 	if (pdev != NULL) {
@@ -180,7 +180,7 @@ static int __devinit snd_card_azt2320_pn
 		if (err < 0)
 			goto __mpu_error;
 		mpu_port[dev] = pnp_port_start(pdev, 0);
-		mpu_irq[dev] = pnp_irq(pdev, 0);
+		mpu_irq[dev] = pnp_irq_start(pdev, 0);
 	} else {
 	     __mpu_error:
 	     	if (pdev) {
Index: linux-2.6.24-rc2/sound/isa/cmi8330.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/cmi8330.c
+++ linux-2.6.24-rc2/sound/isa/cmi8330.c
@@ -322,8 +322,8 @@ static int __devinit snd_cmi8330_pnp(int
 		return -EBUSY;
 	}
 	wssport[dev] = pnp_port_start(pdev, 0);
-	wssdma[dev] = pnp_dma(pdev, 0);
-	wssirq[dev] = pnp_irq(pdev, 0);
+	wssdma[dev] = pnp_dma_start(pdev, 0);
+	wssirq[dev] = pnp_irq_start(pdev, 0);
 
 	/* allocate SB16 resources */
 	pdev = acard->play;
@@ -347,9 +347,9 @@ static int __devinit snd_cmi8330_pnp(int
 		return -EBUSY;
 	}
 	sbport[dev] = pnp_port_start(pdev, 0);
-	sbdma8[dev] = pnp_dma(pdev, 0);
-	sbdma16[dev] = pnp_dma(pdev, 1);
-	sbirq[dev] = pnp_irq(pdev, 0);
+	sbdma8[dev] = pnp_dma_start(pdev, 0);
+	sbdma16[dev] = pnp_dma_start(pdev, 1);
+	sbirq[dev] = pnp_irq_start(pdev, 0);
 
 	kfree(cfg);
 	return 0;
Index: linux-2.6.24-rc2/sound/isa/cs423x/cs4236.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/cs423x/cs4236.c
+++ linux-2.6.24-rc2/sound/isa/cs423x/cs4236.c
@@ -300,9 +300,10 @@ static int __devinit snd_cs423x_pnp_init
 	if (fm_port[dev] > 0)
 		fm_port[dev] = pnp_port_start(pdev, 1);
 	sb_port[dev] = pnp_port_start(pdev, 2);
-	irq[dev] = pnp_irq(pdev, 0);
-	dma1[dev] = pnp_dma(pdev, 0);
-	dma2[dev] = pnp_dma(pdev, 1) == 4 ? -1 : (int)pnp_dma(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
+	dma1[dev] = pnp_dma_start(pdev, 0);
+	dma2[dev] = pnp_dma_start(pdev, 1) == 4 ? -1 :
+		(int)pnp_dma_start(pdev, 1);
 	snd_printdd("isapnp WSS: wss port=0x%lx, fm port=0x%lx, sb port=0x%lx\n",
 			port[dev], fm_port[dev], sb_port[dev]);
 	snd_printdd("isapnp WSS: irq=%i, dma1=%i, dma2=%i\n",
@@ -354,8 +355,8 @@ static int __devinit snd_cs423x_pnp_init
 	} else {
 		mpu_port[dev] = pnp_port_start(pdev, 0);
 		if (mpu_irq[dev] >= 0 &&
-		    pnp_irq_valid(pdev, 0) && pnp_irq(pdev, 0) >= 0) {
-			mpu_irq[dev] = pnp_irq(pdev, 0);
+		    pnp_irq_valid(pdev, 0) && pnp_irq_start(pdev, 0) >= 0) {
+			mpu_irq[dev] = pnp_irq_start(pdev, 0);
 		} else {
 			mpu_irq[dev] = -1;	/* disable interrupt */
 		}
Index: linux-2.6.24-rc2/sound/isa/dt019x.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/dt019x.c
+++ linux-2.6.24-rc2/sound/isa/dt019x.c
@@ -129,8 +129,8 @@ static int __devinit snd_card_dt019x_pnp
 	}
 
 	port[dev] = pnp_port_start(pdev, 0);
-	dma8[dev] = pnp_dma(pdev, 0);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma8[dev] = pnp_dma_start(pdev, 0);
+	irq[dev] = pnp_irq_start(pdev, 0);
 	snd_printdd("dt019x: found audio interface: port=0x%lx, irq=0x%x, dma=0x%x\n",
 			port[dev],irq[dev],dma8[dev]);
 
@@ -151,7 +151,7 @@ static int __devinit snd_card_dt019x_pnp
 			goto __mpu_error;
 		}
 		mpu_port[dev] = pnp_port_start(pdev, 0);
-		mpu_irq[dev] = pnp_irq(pdev, 0);
+		mpu_irq[dev] = pnp_irq_start(pdev, 0);
 		snd_printdd("dt019x: found MPU-401: port=0x%lx, irq=0x%x\n",
 			 	mpu_port[dev],mpu_irq[dev]);
 	} else {
Index: linux-2.6.24-rc2/sound/isa/es18xx.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/es18xx.c
+++ linux-2.6.24-rc2/sound/isa/es18xx.c
@@ -2067,18 +2067,18 @@ static int __devinit snd_audiodrive_pnp_
 	/* skip csn and logdev initialization - already done in isapnp_configure */
 	if (pnp_device_is_isapnp(pdev)) {
 		isapnp_cfg_begin(isapnp_card_number(pdev), isapnp_csn_number(pdev));
-		isapnp_write_byte(0x27, pnp_irq(pdev, 0));	/* Hardware Volume IRQ Number */
+		isapnp_write_byte(0x27, pnp_irq_start(pdev, 0));	/* Hardware Volume IRQ Number */
 		if (mpu_port[dev] != SNDRV_AUTO_PORT)
-			isapnp_write_byte(0x28, pnp_irq(pdev, 0)); /* MPU-401 IRQ Number */
-		isapnp_write_byte(0x72, pnp_irq(pdev, 0));	/* second IRQ */
+			isapnp_write_byte(0x28, pnp_irq_start(pdev, 0)); /* MPU-401 IRQ Number */
+		isapnp_write_byte(0x72, pnp_irq_start(pdev, 0));	/* second IRQ */
 		isapnp_cfg_end();
 	}
 	port[dev] = pnp_port_start(pdev, 0);
 	fm_port[dev] = pnp_port_start(pdev, 1);
 	mpu_port[dev] = pnp_port_start(pdev, 2);
-	dma1[dev] = pnp_dma(pdev, 0);
-	dma2[dev] = pnp_dma(pdev, 1);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma1[dev] = pnp_dma_start(pdev, 0);
+	dma2[dev] = pnp_dma_start(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
 	snd_printdd("PnP ES18xx: port=0x%lx, fm port=0x%lx, mpu port=0x%lx\n", port[dev], fm_port[dev], mpu_port[dev]);
 	snd_printdd("PnP ES18xx: dma1=%i, dma2=%i, irq=%i\n", dma1[dev], dma2[dev], irq[dev]);
 	return 0;
Index: linux-2.6.24-rc2/sound/isa/gus/interwave.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/gus/interwave.c
+++ linux-2.6.24-rc2/sound/isa/gus/interwave.c
@@ -608,10 +608,10 @@ static int __devinit snd_interwave_pnp(i
 		return -ENOENT;
 	}
 	port[dev] = pnp_port_start(pdev, 0);
-	dma1[dev] = pnp_dma(pdev, 0);
+	dma1[dev] = pnp_dma_start(pdev, 0);
 	if (dma2[dev] >= 0)
-		dma2[dev] = pnp_dma(pdev, 1);
-	irq[dev] = pnp_irq(pdev, 0);
+		dma2[dev] = pnp_dma_start(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
 	snd_printdd("isapnp IW: sb port=0x%llx, gf1 port=0x%llx, codec port=0x%llx\n",
 			(unsigned long long)pnp_port_start(pdev, 0),
 			(unsigned long long)pnp_port_start(pdev, 1),
Index: linux-2.6.24-rc2/sound/isa/opl3sa2.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/opl3sa2.c
+++ linux-2.6.24-rc2/sound/isa/opl3sa2.c
@@ -650,9 +650,9 @@ static int __devinit snd_opl3sa2_pnp(int
 	fm_port[dev] = pnp_port_start(pdev, 2);
 	midi_port[dev] = pnp_port_start(pdev, 3);
 	port[dev] = pnp_port_start(pdev, 4);
-	dma1[dev] = pnp_dma(pdev, 0);
-	dma2[dev] = pnp_dma(pdev, 1);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma1[dev] = pnp_dma_start(pdev, 0);
+	dma2[dev] = pnp_dma_start(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
 	snd_printdd("%sPnP OPL3-SA: sb port=0x%lx, wss port=0x%lx, fm port=0x%lx, midi port=0x%lx\n",
 		pnp_device_is_pnpbios(pdev) ? "BIOS" : "ISA", sb_port[dev], wss_port[dev], fm_port[dev], midi_port[dev]);
 	snd_printdd("%sPnP OPL3-SA: control port=0x%lx, dma1=%i, dma2=%i, irq=%i\n",
Index: linux-2.6.24-rc2/sound/isa/opti9xx/opti92x-ad1848.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/opti9xx/opti92x-ad1848.c
+++ linux-2.6.24-rc2/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1748,10 +1748,10 @@ static int __devinit snd_card_opti9xx_pn
 		port = pnp_port_start(pdev, 1);
 	fm_port = pnp_port_start(pdev, 2) + 8;
 #endif	/* OPTi93X */
-	irq = pnp_irq(pdev, 0);
-	dma1 = pnp_dma(pdev, 0);
+	irq = pnp_irq_start(pdev, 0);
+	dma1 = pnp_dma_start(pdev, 0);
 #if defined(CS4231) || defined(OPTi93X)
-	dma2 = pnp_dma(pdev, 1);
+	dma2 = pnp_dma_start(pdev, 1);
 #endif	/* CS4231 || OPTi93X */
 
 	pdev = chip->devmpu;
@@ -1772,7 +1772,7 @@ static int __devinit snd_card_opti9xx_pn
 			chip->devmpu = NULL;
 		} else {
 			mpu_port = pnp_port_start(pdev, 0);
-			mpu_irq = pnp_irq(pdev, 0);
+			mpu_irq = pnp_irq_start(pdev, 0);
 		}
 	}
 	kfree(cfg);
Index: linux-2.6.24-rc2/sound/isa/sb/es968.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/sb/es968.c
+++ linux-2.6.24-rc2/sound/isa/sb/es968.c
@@ -116,8 +116,8 @@ static int __devinit snd_card_es968_pnp(
 		return err;
 	}
 	port[dev] = pnp_port_start(pdev, 0);
-	dma8[dev] = pnp_dma(pdev, 1);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma8[dev] = pnp_dma_start(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
 
 	kfree(cfg);
 	return 0;
Index: linux-2.6.24-rc2/sound/isa/sb/sb16.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/sb/sb16.c
+++ linux-2.6.24-rc2/sound/isa/sb/sb16.c
@@ -300,9 +300,9 @@ static int __devinit snd_card_sb16_pnp(i
 	port[dev] = pnp_port_start(pdev, 0);
 	mpu_port[dev] = pnp_port_start(pdev, 1);
 	fm_port[dev] = pnp_port_start(pdev, 2);
-	dma8[dev] = pnp_dma(pdev, 0);
-	dma16[dev] = pnp_dma(pdev, 1);
-	irq[dev] = pnp_irq(pdev, 0);
+	dma8[dev] = pnp_dma_start(pdev, 0);
+	dma16[dev] = pnp_dma_start(pdev, 1);
+	irq[dev] = pnp_irq_start(pdev, 0);
 	snd_printdd("pnp SB16: port=0x%lx, mpu port=0x%lx, fm port=0x%lx\n",
 			port[dev], mpu_port[dev], fm_port[dev]);
 	snd_printdd("pnp SB16: dma1=%i, dma2=%i, irq=%i\n",
Index: linux-2.6.24-rc2/sound/isa/wavefront/wavefront.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/wavefront/wavefront.c
+++ linux-2.6.24-rc2/sound/isa/wavefront/wavefront.c
@@ -187,9 +187,9 @@ snd_wavefront_pnp (int dev, snd_wavefron
 
 	cs4232_pcm_port[dev] = pnp_port_start(pdev, 0);
 	fm_port[dev] = pnp_port_start(pdev, 1);
-	dma1[dev] = pnp_dma(pdev, 0);
-	dma2[dev] = pnp_dma(pdev, 1);
-	cs4232_pcm_irq[dev] = pnp_irq(pdev, 0);
+	dma1[dev] = pnp_dma_start(pdev, 0);
+	dma2[dev] = pnp_dma_start(pdev, 1);
+	cs4232_pcm_irq[dev] = pnp_irq_start(pdev, 0);
 
 	/* Synth initialization */
 
@@ -215,7 +215,7 @@ snd_wavefront_pnp (int dev, snd_wavefron
 	}
 
 	ics2115_port[dev] = pnp_port_start(pdev, 0);
-	ics2115_irq[dev] = pnp_irq(pdev, 0);
+	ics2115_irq[dev] = pnp_irq_start(pdev, 0);
 
 	/* CS4232 MPU initialization. Configure this only if
 	   explicitly requested, since its physically inaccessible and
@@ -241,7 +241,7 @@ snd_wavefront_pnp (int dev, snd_wavefron
 			cs4232_mpu_port[dev] = SNDRV_AUTO_PORT;
 		} else {
 			cs4232_mpu_port[dev] = pnp_port_start(pdev, 0);
-			cs4232_mpu_irq[dev] = pnp_irq(pdev, 0);
+			cs4232_mpu_irq[dev] = pnp_irq_start(pdev, 0);
 		}
 
 		snd_printk (KERN_INFO "CS4232 MPU: port=0x%lx, irq=%i\n", 
Index: linux-2.6.24-rc2/sound/oss/ad1848.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/oss/ad1848.c
+++ linux-2.6.24-rc2/sound/oss/ad1848.c
@@ -2910,10 +2910,10 @@ static struct pnp_dev __init *ad1848_ini
 		if((ad1848_dev = activate_dev(ad1848_isapnp_list[slot].name, "ad1848", ad1848_dev)))
 		{
 			hw_config->io_base 	= pnp_port_start(ad1848_dev, ad1848_isapnp_list[slot].mss_io);
-			hw_config->irq 		= pnp_irq(ad1848_dev, ad1848_isapnp_list[slot].irq);
-			hw_config->dma 		= pnp_dma(ad1848_dev, ad1848_isapnp_list[slot].dma);
+			hw_config->irq 		= pnp_irq_start(ad1848_dev, ad1848_isapnp_list[slot].irq);
+			hw_config->dma 		= pnp_dma_start(ad1848_dev, ad1848_isapnp_list[slot].dma);
 			if(ad1848_isapnp_list[slot].dma2 != -1)
-				hw_config->dma2 = pnp_dma(ad1848_dev, ad1848_isapnp_list[slot].dma2);
+				hw_config->dma2 = pnp_dma_start(ad1848_dev, ad1848_isapnp_list[slot].dma2);
 			else
 				hw_config->dma2 = -1;
                         hw_config->card_subtype = ad1848_isapnp_list[slot].type;
Index: linux-2.6.24-rc2/sound/oss/sb_card.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/oss/sb_card.c
+++ linux-2.6.24-rc2/sound/oss/sb_card.c
@@ -178,58 +178,58 @@ static void sb_dev2cfg(struct pnp_dev *d
 	   different logical devices for the MPU */
 	if(!strncmp("CTL",scc->card_id,3)) {
 		scc->conf.io_base   = pnp_port_start(dev,0);
-		scc->conf.irq       = pnp_irq(dev,0);
-		scc->conf.dma       = pnp_dma(dev,0);
-		scc->conf.dma2      = pnp_dma(dev,1);
+		scc->conf.irq       = pnp_irq_start(dev,0);
+		scc->conf.dma       = pnp_dma_start(dev,0);
+		scc->conf.dma2      = pnp_dma_start(dev,1);
 		scc->mpucnf.io_base = pnp_port_start(dev,1);
 		return;
 	}
 	if(!strncmp("tBA",scc->card_id,3)) {
 		scc->conf.io_base   = pnp_port_start(dev,0);
-		scc->conf.irq       = pnp_irq(dev,0);
-		scc->conf.dma       = pnp_dma(dev,0);
-		scc->conf.dma2      = pnp_dma(dev,1);
+		scc->conf.irq       = pnp_irq_start(dev,0);
+		scc->conf.dma       = pnp_dma_start(dev,0);
+		scc->conf.dma2      = pnp_dma_start(dev,1);
 		return;
 	}
 	if(!strncmp("ESS",scc->card_id,3)) {
 		scc->conf.io_base   = pnp_port_start(dev,0);
-		scc->conf.irq       = pnp_irq(dev,0);
-		scc->conf.dma       = pnp_dma(dev,0);
-		scc->conf.dma2      = pnp_dma(dev,1);
+		scc->conf.irq       = pnp_irq_start(dev,0);
+		scc->conf.dma       = pnp_dma_start(dev,0);
+		scc->conf.dma2      = pnp_dma_start(dev,1);
 	       	scc->mpucnf.io_base = pnp_port_start(dev,2);
 		return;
 	}
 	if(!strncmp("CMI",scc->card_id,3)) {
 		scc->conf.io_base = pnp_port_start(dev,0);
-		scc->conf.irq     = pnp_irq(dev,0);
-		scc->conf.dma     = pnp_dma(dev,0);
-		scc->conf.dma2    = pnp_dma(dev,1);
+		scc->conf.irq     = pnp_irq_start(dev,0);
+		scc->conf.dma     = pnp_dma_start(dev,0);
+		scc->conf.dma2    = pnp_dma_start(dev,1);
 		return;
 	}
 	if(!strncmp("RWB",scc->card_id,3)) {
 		scc->conf.io_base = pnp_port_start(dev,0);
-		scc->conf.irq     = pnp_irq(dev,0);
-		scc->conf.dma     = pnp_dma(dev,0);
+		scc->conf.irq     = pnp_irq_start(dev,0);
+		scc->conf.dma     = pnp_dma_start(dev,0);
 		return;
 	}
 	if(!strncmp("ALS",scc->card_id,3)) {
 		if(!strncmp("ALS0007",scc->card_id,7)) {
 			scc->conf.io_base = pnp_port_start(dev,0);
-			scc->conf.irq     = pnp_irq(dev,0);
-			scc->conf.dma     = pnp_dma(dev,0);
+			scc->conf.irq     = pnp_irq_start(dev,0);
+			scc->conf.dma     = pnp_dma_start(dev,0);
 		} else {
 			scc->conf.io_base = pnp_port_start(dev,0);
-			scc->conf.irq     = pnp_irq(dev,0);
-			scc->conf.dma     = pnp_dma(dev,1);
-			scc->conf.dma2    = pnp_dma(dev,0);
+			scc->conf.irq     = pnp_irq_start(dev,0);
+			scc->conf.dma     = pnp_dma_start(dev,1);
+			scc->conf.dma2    = pnp_dma_start(dev,0);
 		}
 		return;
 	}
 	if(!strncmp("RTL",scc->card_id,3)) {
 		scc->conf.io_base = pnp_port_start(dev,0);
-		scc->conf.irq     = pnp_irq(dev,0);
-		scc->conf.dma     = pnp_dma(dev,1);
-		scc->conf.dma2    = pnp_dma(dev,0);
+		scc->conf.irq     = pnp_irq_start(dev,0);
+		scc->conf.dma     = pnp_dma_start(dev,1);
+		scc->conf.dma2    = pnp_dma_start(dev,0);
 	}
 }
 
Index: linux-2.6.24-rc2/drivers/ide/ide-pnp.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/ide/ide-pnp.c
+++ linux-2.6.24-rc2/drivers/ide/ide-pnp.c
@@ -39,7 +39,7 @@ static int idepnp_probe(struct pnp_dev *
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, pnp_port_start(dev, 0),
 				pnp_port_start(dev, 1));
-	hw.irq = pnp_irq(dev, 0);
+	hw.irq = pnp_irq_start(dev, 0);
 
 	index = ide_register_hw(&hw, NULL, 1, &hwif);
 
Index: linux-2.6.24-rc2/sound/isa/sscape.c
===================================================================
--- linux-2.6.24-rc2.orig/sound/isa/sscape.c
+++ linux-2.6.24-rc2/sound/isa/sscape.c
@@ -1479,15 +1479,15 @@ static int __devinit sscape_pnp_detect(s
 	 * Read the correct parameters off the ISA PnP bus ...
 	 */
 	port[idx] = pnp_port_start(dev, 0);
-	irq[idx] = pnp_irq(dev, 0);
-	mpu_irq[idx] = pnp_irq(dev, 1);
-	dma[idx] = pnp_dma(dev, 0) & 0x03;
+	irq[idx] = pnp_irq_start(dev, 0);
+	mpu_irq[idx] = pnp_irq_start(dev, 1);
+	dma[idx] = pnp_dma_start(dev, 0) & 0x03;
 	if (sscape->type == SSCAPE_PNP) {
 		dma2[idx] = dma[idx];
 		wss_port[idx] = CODEC_IO(port[idx]);
 	} else {
 		wss_port[idx] = pnp_port_start(dev, 1);
-		dma2[idx] = pnp_dma(dev, 1);
+		dma2[idx] = pnp_dma_start(dev, 1);
 	}
 
 	ret = create_sscape(idx, card);
Index: linux-2.6.24-rc2/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6.24-rc2/drivers/char/tpm/tpm_tis.c
@@ -600,7 +600,7 @@ static int __devinit tpm_tis_pnp_init(st
 	len = pnp_mem_len(pnp_dev, 0);
 
 	if (pnp_irq_valid(pnp_dev, 0))
-		irq = pnp_irq(pnp_dev, 0);
+		irq = pnp_irq_start(pnp_dev, 0);
 	else
 		interrupts = 0;
 
Index: linux-2.6.24-rc2/drivers/serial/8250_pnp.c
===================================================================
--- linux-2.6.24-rc2.orig/drivers/serial/8250_pnp.c
+++ linux-2.6.24-rc2/drivers/serial/8250_pnp.c
@@ -440,7 +440,7 @@ serial_pnp_probe(struct pnp_dev *dev, co
 
 	memset(&port, 0, sizeof(struct uart_port));
 	if (pnp_irq_valid(dev, 0))
-		port.irq = pnp_irq(dev, 0);
+		port.irq = pnp_irq_start(dev, 0);
 	if (pnp_port_valid(dev, 0)) {
 		port.iobase = pnp_port_start(dev, 0);
 		port.iotype = UPIO_PORT;


