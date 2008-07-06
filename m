Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbYGFRhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbYGFRhp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbYGFRex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:34:53 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:50837 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbYGFReq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=U/HKJPcOtc+c/I0CnWYhbCffKSgtuDeXlEqxFAVbCxsu6GBQTmxdqf9+bgMva4bN/U
         M/CJoSCZx+JrRmbvh80ni1yHxme/I/LH/Xa4YpnnpuwJehFSExX6rFbd0CZlHGuyGKb6
         2TjdMO7cQqTSEKEIAxg2RJzEEL3p91EqE8TBU=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:16 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/50] ide: add ->dev and ->host_priv fields to struct ide_host
Content-Disposition: inline; filename=ide-add-dev-and-host_priv-fields-to-struct-ide_host.patch
Message-ID: <48710233.1ade660a.3458.6275@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'struct device *dev[2]' and 'void *host_priv' fields
  to struct ide_host.

* Set ->dev[] in ide_host_alloc_all()/ide_setup_pci_device[s]().

* Pass 'void *priv' argument to ide_setup_pci_device[s]()
  and use it to set ->host_priv.

* Set PCI dev's ->driver_data to point to the struct ide_host
  instance if PCI host driver wants to use ->host_priv.

* Rename ide_setup_pci_device[s]() to ide_pci_init_{one,two}().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c        |    3 ++
 drivers/ide/pci/aec62xx.c      |    2 -
 drivers/ide/pci/alim15x3.c     |    2 -
 drivers/ide/pci/amd74xx.c      |    2 -
 drivers/ide/pci/atiixp.c       |    2 -
 drivers/ide/pci/cmd64x.c       |    2 -
 drivers/ide/pci/cs5530.c       |    2 -
 drivers/ide/pci/cs5535.c       |    2 -
 drivers/ide/pci/cy82c693.c     |    2 -
 drivers/ide/pci/generic.c      |    2 -
 drivers/ide/pci/hpt34x.c       |    2 -
 drivers/ide/pci/hpt366.c       |    4 +--
 drivers/ide/pci/it8213.c       |    2 -
 drivers/ide/pci/it821x.c       |    2 -
 drivers/ide/pci/jmicron.c      |    2 -
 drivers/ide/pci/ns87415.c      |    2 -
 drivers/ide/pci/opti621.c      |    2 -
 drivers/ide/pci/pdc202xx_new.c |    4 +--
 drivers/ide/pci/pdc202xx_old.c |    2 -
 drivers/ide/pci/piix.c         |    2 -
 drivers/ide/pci/rz1000.c       |    2 -
 drivers/ide/pci/sc1200.c       |    2 -
 drivers/ide/pci/serverworks.c  |    2 -
 drivers/ide/pci/siimage.c      |    2 -
 drivers/ide/pci/sis5513.c      |    2 -
 drivers/ide/pci/sl82c105.c     |    2 -
 drivers/ide/pci/slc90e66.c     |    2 -
 drivers/ide/pci/tc86c001.c     |    2 -
 drivers/ide/pci/triflex.c      |    2 -
 drivers/ide/pci/trm290.c       |    2 -
 drivers/ide/pci/via82cxxx.c    |    2 -
 drivers/ide/setup-pci.c        |   52 +++++++++++++++++++++++++++++++++++------
 include/linux/ide.h            |    7 +++--
 33 files changed, 85 insertions(+), 41 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1608,6 +1608,9 @@ struct ide_host *ide_host_alloc_all(cons
 		return NULL;
 	}
 
+	if (hws[0])
+		host->dev[0] = hws[0]->dev;
+
 	return host;
 }
 EXPORT_SYMBOL_GPL(ide_host_alloc_all);
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -273,7 +273,7 @@ static int __devinit aec62xx_init_one(st
 		}
 	}
 
-	err = ide_setup_pci_device(dev, &d);
+	err = ide_pci_init_one(dev, &d, NULL);
 	if (err)
 		pci_disable_device(dev);
 
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -565,7 +565,7 @@ static int __devinit alim15x3_init_one(s
 	if (idx == 0)
 		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -302,7 +302,7 @@ static int __devinit amd74xx_probe(struc
 			 d.name, pci_name(dev), dev->revision,
 			 amd_dma[fls(d.udma_mask) - 1]);
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id amd74xx_pci_tbl[] = {
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -167,7 +167,7 @@ static const struct ide_port_info atiixp
 
 static int __devinit atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &atiixp_pci_info[id->driver_data]);
+	return ide_pci_init_one(dev, &atiixp_pci_info[id->driver_data], NULL);
 }
 
 static const struct pci_device_id atiixp_pci_tbl[] = {
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -507,7 +507,7 @@ static int __devinit cmd64x_init_one(str
 		}
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id cmd64x_pci_tbl[] = {
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -256,7 +256,7 @@ static const struct ide_port_info cs5530
 
 static int __devinit cs5530_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &cs5530_chipset);
+	return ide_pci_init_one(dev, &cs5530_chipset, NULL);
 }
 
 static const struct pci_device_id cs5530_pci_tbl[] = {
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -180,7 +180,7 @@ static const struct ide_port_info cs5535
 static int __devinit cs5535_init_one(struct pci_dev *dev,
 					const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &cs5535_chipset);
+	return ide_pci_init_one(dev, &cs5535_chipset, NULL);
 }
 
 static const struct pci_device_id cs5535_pci_tbl[] = {
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -419,7 +419,7 @@ static int __devinit cy82c693_init_one(s
 	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	    PCI_FUNC(dev->devfn) == 1) {
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
-		ret = ide_setup_pci_devices(dev, dev2, &cy82c693_chipset);
+		ret = ide_pci_init_two(dev, dev2, &cy82c693_chipset, NULL);
 		/* We leak pci refs here but thats ok - we can't be unloaded */
 	}
 	return ret;
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -139,7 +139,7 @@ static int __devinit generic_init_one(st
 			goto out;
 		}
 	}
-	ret = ide_setup_pci_device(dev, d);
+	ret = ide_pci_init_one(dev, d, NULL);
 out:
 	return ret;
 }
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -156,7 +156,7 @@ static int __devinit hpt34x_init_one(str
 
 	d = &hpt34x_chipsets[(pcicmd & PCI_COMMAND_MEMORY) ? 1 : 0];
 
-	return ide_setup_pci_device(dev, d);
+	return ide_pci_init_one(dev, d, NULL);
 }
 
 static const struct pci_device_id hpt34x_pci_tbl[] = {
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1608,13 +1608,13 @@ static int __devinit hpt366_init_one(str
 				d.host_flags &= ~IDE_HFLAG_NON_BOOTABLE;
 		}
 
-		ret = ide_setup_pci_devices(dev, dev2, &d);
+		ret = ide_pci_init_two(dev, dev2, &d, NULL);
 		if (ret < 0)
 			pci_dev_put(dev2);
 		return ret;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -184,7 +184,7 @@ static const struct ide_port_info it8213
 
 static int __devinit it8213_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &it8213_chipsets[id->driver_data]);
+	return ide_pci_init_one(dev, &it8213_chipsets[id->driver_data], NULL);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -658,7 +658,7 @@ static int __devinit it821x_init_one(str
 
 	pci_set_drvdata(dev, itdevs);
 
-	return ide_setup_pci_device(dev, &it821x_chipsets[id->driver_data]);
+	return ide_pci_init_one(dev, &it821x_chipsets[id->driver_data], NULL);
 }
 
 static const struct pci_device_id it821x_pci_tbl[] = {
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -121,7 +121,7 @@ static const struct ide_port_info jmicro
 
 static int __devinit jmicron_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &jmicron_chipset);
+	return ide_pci_init_one(dev, &jmicron_chipset, NULL);
 }
 
 /* All JMB PATA controllers have and will continue to have the same
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -328,7 +328,7 @@ static int __devinit ns87415_init_one(st
 		d.tp_ops = &superio_tp_ops;
 	}
 #endif
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -209,7 +209,7 @@ static const struct ide_port_info opti62
 
 static int __devinit opti621_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &opti621_chipset);
+	return ide_pci_init_one(dev, &opti621_chipset, NULL);
 }
 
 static const struct pci_device_id opti621_pci_tbl[] = {
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -524,7 +524,7 @@ static int __devinit pdc202new_init_one(
 		dev2 = pdc20270_get_dev2(dev);
 
 		if (dev2) {
-			int ret = ide_setup_pci_devices(dev, dev2, d);
+			int ret = ide_pci_init_two(dev, dev2, d, NULL);
 			if (ret < 0)
 				pci_dev_put(dev2);
 			return ret;
@@ -540,7 +540,7 @@ static int __devinit pdc202new_init_one(
 		return -ENODEV;
 	}
 
-	return ide_setup_pci_device(dev, d);
+	return ide_pci_init_one(dev, d, NULL);
 }
 
 static const struct pci_device_id pdc202new_pci_tbl[] = {
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -412,7 +412,7 @@ static int __devinit pdc202xx_init_one(s
 		}
 	}
 
-	return ide_setup_pci_device(dev, d);
+	return ide_pci_init_one(dev, d, NULL);
 }
 
 static const struct pci_device_id pdc202xx_pci_tbl[] = {
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -394,7 +394,7 @@ static const struct ide_port_info piix_p
  
 static int __devinit piix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &piix_pci_info[id->driver_data]);
+	return ide_pci_init_one(dev, &piix_pci_info[id->driver_data], NULL);
 }
 
 /**
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -48,7 +48,7 @@ static const struct ide_port_info rz1000
 
 static int __devinit rz1000_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &rz1000_chipset);
+	return ide_pci_init_one(dev, &rz1000_chipset, NULL);
 }
 
 static const struct pci_device_id rz1000_pci_tbl[] = {
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -317,7 +317,7 @@ static const struct ide_port_info sc1200
 
 static int __devinit sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &sc1200_chipset);
+	return ide_pci_init_one(dev, &sc1200_chipset, NULL);
 }
 
 static const struct pci_device_id sc1200_pci_tbl[] = {
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -422,7 +422,7 @@ static int __devinit svwks_init_one(stru
 			d.host_flags &= ~IDE_HFLAG_SINGLE;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id svwks_pci_tbl[] = {
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -795,7 +795,7 @@ static int __devinit siimage_init_one(st
 		d.host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id siimage_pci_tbl[] = {
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -583,7 +583,7 @@ static int __devinit sis5513_init_one(st
 
 	d.udma_mask = udma_rates[chipset_family];
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id sis5513_pci_tbl[] = {
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -335,7 +335,7 @@ static int __devinit sl82c105_init_one(s
 		d.host_flags &= ~IDE_HFLAG_SERIALIZE_DMA;
 	}
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id sl82c105_pci_tbl[] = {
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -144,7 +144,7 @@ static const struct ide_port_info slc90e
 
 static int __devinit slc90e66_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &slc90e66_chipset);
+	return ide_pci_init_one(dev, &slc90e66_chipset, NULL);
 }
 
 static const struct pci_device_id slc90e66_pci_tbl[] = {
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -215,7 +215,7 @@ static const struct ide_port_info tc86c0
 static int __devinit tc86c001_init_one(struct pci_dev *dev,
 				       const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &tc86c001_chipset);
+	return ide_pci_init_one(dev, &tc86c001_chipset, NULL);
 }
 
 static const struct pci_device_id tc86c001_pci_tbl[] = {
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -104,7 +104,7 @@ static const struct ide_port_info trifle
 static int __devinit triflex_init_one(struct pci_dev *dev, 
 		const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &triflex_device);
+	return ide_pci_init_one(dev, &triflex_device, NULL);
 }
 
 static const struct pci_device_id triflex_pci_tbl[] = {
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -340,7 +340,7 @@ static const struct ide_port_info trm290
 
 static int __devinit trm290_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	return ide_setup_pci_device(dev, &trm290_chipset);
+	return ide_pci_init_one(dev, &trm290_chipset, NULL);
 }
 
 static const struct pci_device_id trm290_pci_tbl[] = {
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -466,7 +466,7 @@ static int __devinit via_init_one(struct
 
 	d.udma_mask = via_config->udma_mask;
 
-	return ide_setup_pci_device(dev, &d);
+	return ide_pci_init_one(dev, &d, NULL);
 }
 
 static const struct pci_device_id via_pci_tbl[] = {
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -524,8 +524,10 @@ out:
 	return ret;
 }
 
-int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+int ide_pci_init_one(struct pci_dev *dev, const struct ide_port_info *d,
+		     void *priv)
 {
+	struct ide_host *host;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
 
@@ -535,6 +537,19 @@ int ide_setup_pci_device(struct pci_dev 
 
 	ide_pci_setup_ports(dev, d, 0, &hw[0], &hws[0]);
 
+	host = ide_host_alloc(d, hws);
+	if (host == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	host->dev[0] = &dev->dev;
+
+	host->host_priv = priv;
+
+	if (priv)
+		pci_set_drvdata(dev, host);
+
 	ret = do_ide_setup_pci_device(dev, d, 1);
 	if (ret < 0)
 		goto out;
@@ -542,16 +557,19 @@ int ide_setup_pci_device(struct pci_dev 
 	/* fixup IRQ */
 	hw[1].irq = hw[0].irq = ret;
 
-	ret = ide_host_add(d, hws, NULL);
+	ret = ide_host_register(host, d, hws);
+	if (ret)
+		ide_host_free(host);
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ide_setup_pci_device);
+EXPORT_SYMBOL_GPL(ide_pci_init_one);
 
-int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
-			  const struct ide_port_info *d)
+int ide_pci_init_two(struct pci_dev *dev1, struct pci_dev *dev2,
+		     const struct ide_port_info *d, void *priv)
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
+	struct ide_host *host;
 	int ret, i;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
@@ -561,7 +579,25 @@ int ide_setup_pci_devices(struct pci_dev
 			goto out;
 
 		ide_pci_setup_ports(pdev[i], d, 0, &hw[i*2], &hws[i*2]);
+	}
 
+	host = ide_host_alloc(d, hws);
+	if (host == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	host->dev[0] = &dev1->dev;
+	host->dev[1] = &dev2->dev;
+
+	host->host_priv = priv;
+
+	if (priv) {
+		pci_set_drvdata(pdev[0], host);
+		pci_set_drvdata(pdev[1], host);
+	}
+
+	for (i = 0; i < 2; i++) {
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
 
 		/*
@@ -575,8 +611,10 @@ int ide_setup_pci_devices(struct pci_dev
 		hw[i*2 + 1].irq = hw[i*2].irq = ret;
 	}
 
-	ret = ide_host_add(d, hws, NULL);
+	ret = ide_host_register(host, d, hws);
+	if (ret)
+		ide_host_free(host);
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ide_setup_pci_devices);
+EXPORT_SYMBOL_GPL(ide_pci_init_two);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -611,6 +611,8 @@ typedef struct hwif_s {
 struct ide_host {
 	ide_hwif_t	*ports[MAX_HWIFS];
 	unsigned int	n_ports;
+	struct device	*dev[2];
+	void		*host_priv;
 };
 
 /*
@@ -1186,8 +1188,9 @@ struct ide_port_info {
 	u8			udma_mask;
 };
 
-int ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *);
-int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, const struct ide_port_info *);
+int ide_pci_init_one(struct pci_dev *, const struct ide_port_info *, void *);
+int ide_pci_init_two(struct pci_dev *, struct pci_dev *,
+		     const struct ide_port_info *, void *);
 
 void ide_map_sg(ide_drive_t *, struct request *);
 void ide_init_sg_cmd(ide_drive_t *, struct request *);

-- 

