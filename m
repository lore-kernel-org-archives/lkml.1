Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXI1Wty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXI1Wty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXI1Wtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:49:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47885 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbXI1Wtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:49:46 -0400
From: Maarten Bressers <mbres@gentoo.org>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: On Fri, 28 Sep 2007 14:48:53 -0700
Message-Id: <20070928224945.3E6D36519C@smtp.gentoo.org>
Date: Fri, 28 Sep 2007 22:49:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 28 Sep 2007 20:56:30 +0000 (UTC) Maarten Bressers wrote:
> 
> > This (trivial) patch fixes two compiler warnings for 2.6.23-rc8 on x86_64,
> > use of deprecated function pci_find_device() and a section mismatch.
> > Build log and .config file included.
> > 
> > Signed-off by: Maarten Bressers <mbres@gentoo.org>
> 
> Please include the text from section mismatch warnings in the patch
> description.
> 
Sorry I left that out, will remember to include that in the description.

> > diff --git a/arch/x86_64/kernel/smpboot.c b/arch/x86_64/kernel/smpboot.c
> > index 32f5078..7c872df 100644
> > --- a/arch/x86_64/kernel/smpboot.c
> > +++ b/arch/x86_64/kernel/smpboot.c
> > @@ -532,7 +532,7 @@ struct create_idle {
> >  	int cpu;
> >  };
> >  
> > -void do_fork_idle(struct work_struct *work)
> > +static void __cpuinit do_fork_idle(struct work_struct *work)
> >  {
> >  	struct create_idle *c_idle =
> >  		container_of(work, struct create_idle, work);
> > diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> > index c6e79d0..0eb7e9e 100644
> > --- a/drivers/pci/search.c
> > +++ b/drivers/pci/search.c
> > @@ -96,7 +96,7 @@ pci_find_slot(unsigned int bus, unsigned int devfn)
> >  {
> >  	struct pci_dev *dev = NULL;
> >  
> > -	while ((dev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
> > +	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
> >  		if (dev->bus->number == bus && dev->devfn == devfn)
> >  			return dev;
> >  	}
> > @@ -434,8 +434,6 @@ int pci_dev_present(const struct pci_device_id *ids)
> >  EXPORT_SYMBOL(pci_dev_present);
> >  EXPORT_SYMBOL(pci_find_present);
> >  
> > -EXPORT_SYMBOL(pci_find_device);
> > -EXPORT_SYMBOL(pci_find_slot);
> 
> There are still about 30 and 14 respetively users of pci_find_devic()
> and pci_find_slot() in 2.6.23-rc8.  Will you be fixing them?
> 
I'm attaching a patch here that I think will clean up all uses of 
pci_find_device(), except one in drivers/net/skfp/drvfbi.c:1248. I'm not 
sure what to make of that one, do you have any suggestions?

Is this patch what you had in mind, Randy? Any comments are appreciated.

> >  /* For boot time work */
> >  EXPORT_SYMBOL(pci_find_bus);
> >  EXPORT_SYMBOL(pci_find_next_bus);
> 
> ---
> ~Randy
> Phaedrus says that Quality is about caring.


diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index b04a178..86e0236 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -789,8 +789,8 @@ setup_avm_pcipnp(struct IsdnCard *card)
 	}
 #endif
 #ifdef CONFIG_PCI
-	if ((dev_avm = pci_find_device(PCI_VENDOR_ID_AVM,
-		PCI_DEVICE_ID_AVM_A1,  dev_avm))) {
+	if ((dev_avm = pci_get_device(PCI_VENDOR_ID_AVM,
+		PCI_DEVICE_ID_AVM_A1, dev_avm))) {
 		if (pci_enable_device(dev_avm))
 			return(0);
 		cs->irq = dev_avm->irq;
diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index 3d1bdc8..b5e761d 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -340,7 +340,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 	} else
 		return (0);
 
-	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
+	while ((dev_a4t = pci_get_device(PCI_VENDOR_ID_ZORAN,
 		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
 		ret = a4t_pci_probe(dev_a4t, cs, &found, &pci_memaddr);
 		if (!ret)
diff --git a/drivers/isdn/hisax/bkm_a8.c b/drivers/isdn/hisax/bkm_a8.c
index 6339bb4..340313f 100644
--- a/drivers/isdn/hisax/bkm_a8.c
+++ b/drivers/isdn/hisax/bkm_a8.c
@@ -309,7 +309,7 @@ setup_sct_quadro(struct IsdnCard *card)
 		(sub_vendor_id != PCI_VENDOR_ID_BERKOM)))
 		return (0);
 	if (cs->subtyp == SCT_1) {
-		while ((dev_a8 = pci_find_device(PCI_VENDOR_ID_PLX,
+		while ((dev_a8 = pci_get_device(PCI_VENDOR_ID_PLX,
 			PCI_DEVICE_ID_PLX_9050, dev_a8))) {
 			
 			sub_vendor_id = dev_a8->subsystem_vendor;
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 6eebeb4..8c7b03e 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -1047,21 +1047,21 @@ setup_diva(struct IsdnCard *card)
 #endif
 #ifdef CONFIG_PCI
 		cs->subtyp = 0;
-		if ((dev_diva = pci_find_device(PCI_VENDOR_ID_EICON,
+		if ((dev_diva = pci_get_device(PCI_VENDOR_ID_EICON,
 			PCI_DEVICE_ID_EICON_DIVA20, dev_diva))) {
 			if (pci_enable_device(dev_diva))
 				return(0);
 			cs->subtyp = DIVA_PCI;
 			cs->irq = dev_diva->irq;
 			cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
-		} else if ((dev_diva_u = pci_find_device(PCI_VENDOR_ID_EICON,
+		} else if ((dev_diva_u = pci_get_device(PCI_VENDOR_ID_EICON,
 			PCI_DEVICE_ID_EICON_DIVA20_U, dev_diva_u))) {
 			if (pci_enable_device(dev_diva_u))
 				return(0);
 			cs->subtyp = DIVA_PCI;
 			cs->irq = dev_diva_u->irq;
 			cs->hw.diva.cfg_reg = pci_resource_start(dev_diva_u, 2);
-		} else if ((dev_diva201 = pci_find_device(PCI_VENDOR_ID_EICON,
+		} else if ((dev_diva201 = pci_get_device(PCI_VENDOR_ID_EICON,
 			PCI_DEVICE_ID_EICON_DIVA201, dev_diva201))) {
 			if (pci_enable_device(dev_diva201))
 				return(0);
@@ -1071,7 +1071,7 @@ setup_diva(struct IsdnCard *card)
 				(ulong) ioremap(pci_resource_start(dev_diva201, 0), 4096);
 			cs->hw.diva.cfg_reg =
 				(ulong) ioremap(pci_resource_start(dev_diva201, 1), 4096);
-		} else if ((dev_diva202 = pci_find_device(PCI_VENDOR_ID_EICON,
+		} else if ((dev_diva202 = pci_get_device(PCI_VENDOR_ID_EICON,
 			PCI_DEVICE_ID_EICON_DIVA202, dev_diva202))) {
 			if (pci_enable_device(dev_diva202))
 				return(0);
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index fab3e4e..2932755 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -1021,7 +1021,7 @@ setup_elsa(struct IsdnCard *card)
 	} else if (cs->typ == ISDN_CTYPE_ELSA_PCI) {
 #ifdef CONFIG_PCI
 		cs->subtyp = 0;
-		if ((dev_qs1000 = pci_find_device(PCI_VENDOR_ID_ELSA,
+		if ((dev_qs1000 = pci_get_device(PCI_VENDOR_ID_ELSA,
 			PCI_DEVICE_ID_ELSA_MICROLINK, dev_qs1000))) {
 			if (pci_enable_device(dev_qs1000))
 				return(0);
@@ -1029,7 +1029,7 @@ setup_elsa(struct IsdnCard *card)
 			cs->irq = dev_qs1000->irq;
 			cs->hw.elsa.cfg = pci_resource_start(dev_qs1000, 1);
 			cs->hw.elsa.base = pci_resource_start(dev_qs1000, 3);
-		} else if ((dev_qs3000 = pci_find_device(PCI_VENDOR_ID_ELSA,
+		} else if ((dev_qs3000 = pci_get_device(PCI_VENDOR_ID_ELSA,
 			PCI_DEVICE_ID_ELSA_QS3000, dev_qs3000))) {
 			if (pci_enable_device(dev_qs3000))
 				return(0);
diff --git a/drivers/isdn/hisax/enternow_pci.c b/drivers/isdn/hisax/enternow_pci.c
index b73027f..1be5a2b 100644
--- a/drivers/isdn/hisax/enternow_pci.c
+++ b/drivers/isdn/hisax/enternow_pci.c
@@ -406,7 +406,7 @@ setup_enternow_pci(struct IsdnCard *card)
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
 			ret = en_pci_probe(dev_netjet, cs);
 			if (!ret)
diff --git a/drivers/isdn/hisax/gazel.c b/drivers/isdn/hisax/gazel.c
index 3efa719..24aa5be 100644
--- a/drivers/isdn/hisax/gazel.c
+++ b/drivers/isdn/hisax/gazel.c
@@ -546,7 +546,7 @@ setup_gazelpci(struct IsdnCardState *cs)
 	found = 0;
 	seekcard = PCI_DEVICE_ID_PLX_R685;
 	for (nbseek = 0; nbseek < 4; nbseek++) {
-		if ((dev_tel = pci_find_device(PCI_VENDOR_ID_PLX,
+		if ((dev_tel = pci_get_device(PCI_VENDOR_ID_PLX,
 					seekcard, dev_tel))) {
 			if (pci_enable_device(dev_tel))
 				return 1;
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 077080a..c6b3e4a 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -1660,9 +1660,9 @@ setup_hfcpci(struct IsdnCard *card)
 
 	i = 0;
 	while (id_list[i].vendor_id) {
-		tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
-					     id_list[i].device_id,
-					     dev_hfcpci);
+		tmp_hfcpci = pci_get_device(id_list[i].vendor_id,
+					    id_list[i].device_id,
+					    dev_hfcpci);
 		i++;
 		if (tmp_hfcpci) {
 			if (pci_enable_device(tmp_hfcpci))
diff --git a/drivers/isdn/hisax/niccy.c b/drivers/isdn/hisax/niccy.c
index e5918c6..18f52db 100644
--- a/drivers/isdn/hisax/niccy.c
+++ b/drivers/isdn/hisax/niccy.c
@@ -302,9 +302,9 @@ int __devinit setup_niccy(struct IsdnCard *card)
 #ifdef CONFIG_PCI
 		u_int pci_ioaddr;
 		cs->subtyp = 0;
-		if ((niccy_dev = pci_find_device(PCI_VENDOR_ID_SATSAGEM,
-						 PCI_DEVICE_ID_SATSAGEM_NICCY,
-						 niccy_dev))) {
+		if ((niccy_dev = pci_get_device(PCI_VENDOR_ID_SATSAGEM,
+						PCI_DEVICE_ID_SATSAGEM_NICCY,
+						niccy_dev))) {
 			if (pci_enable_device(niccy_dev))
 				return 0;
 			/* get IRQ */
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index fa2db87..3535378 100644
--- a/drivers/isdn/hisax/nj_s.c
+++ b/drivers/isdn/hisax/nj_s.c
@@ -277,7 +277,7 @@ setup_netjet_s(struct IsdnCard *card)
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
 			ret = njs_pci_probe(dev_netjet, cs);
 			if (!ret)
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index f017d38..1ab471d 100644
--- a/drivers/isdn/hisax/nj_u.c
+++ b/drivers/isdn/hisax/nj_u.c
@@ -240,7 +240,7 @@ setup_netjet_u(struct IsdnCard *card)
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
 			ret = nju_pci_probe(dev_netjet, cs);
 			if (!ret)
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index ad06f3c..cbd506e 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -624,7 +624,7 @@ setup_sedlbauer(struct IsdnCard *card)
 #endif
 /* Probe for Sedlbauer speed pci */
 #ifdef CONFIG_PCI
-		if ((dev_sedl = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_sedl = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 				PCI_DEVICE_ID_TIGERJET_100, dev_sedl))) {
 			if (pci_enable_device(dev_sedl))
 				return(0);
diff --git a/drivers/isdn/hisax/telespci.c b/drivers/isdn/hisax/telespci.c
index d09f6d0..248c307 100644
--- a/drivers/isdn/hisax/telespci.c
+++ b/drivers/isdn/hisax/telespci.c
@@ -300,7 +300,7 @@ setup_telespci(struct IsdnCard *card)
 	if (cs->typ != ISDN_CTYPE_TELESPCI)
 		return (0);
 #ifdef CONFIG_PCI
-	if ((dev_tel = pci_find_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
+	if ((dev_tel = pci_get_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
 		if (pci_enable_device(dev_tel))
 			return(0);
 		cs->irq = dev_tel->irq;
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index 3aeceaf..55c6eb7 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -1011,9 +1011,9 @@ setup_w6692(struct IsdnCard *card)
 		return (0);
 #ifdef CONFIG_PCI
 	while (id_list[id_idx].vendor_id) {
-		dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
-					    id_list[id_idx].device_id,
-					    dev_w6692);
+		dev_w6692 = pci_get_device(id_list[id_idx].vendor_id,
+					   id_list[id_idx].device_id,
+					   dev_w6692);
 		if (dev_w6692) {
 			if (pci_enable_device(dev_w6692))
 				continue;
diff --git a/drivers/isdn/hysdn/hysdn_init.c b/drivers/isdn/hysdn/hysdn_init.c
index 9e01748..d89664a 100644
--- a/drivers/isdn/hysdn/hysdn_init.c
+++ b/drivers/isdn/hysdn/hysdn_init.c
@@ -76,8 +76,8 @@ search_cards(void)
 
 	card_root = NULL;
 	card_last = NULL;
-	while ((akt_pcidev = pci_find_device(PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
-					     akt_pcidev)) != NULL) {
+	while ((akt_pcidev = pci_get_device(PCI_VENDOR_ID_HYPERCOPE, PCI_DEVICE_ID_HYPERCOPE_PLX,
+					    akt_pcidev)) != NULL) {
 		if (pci_enable_device(akt_pcidev))
 			continue;
 
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index c6e79d0..66a566a 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -96,7 +96,7 @@ pci_find_slot(unsigned int bus, unsigned int devfn)
 {
 	struct pci_dev *dev = NULL;
 
-	while ((dev = pci_find_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		if (dev->bus->number == bus && dev->devfn == devfn)
 			return dev;
 	}
@@ -434,7 +434,6 @@ int pci_dev_present(const struct pci_device_id *ids)
 EXPORT_SYMBOL(pci_dev_present);
 EXPORT_SYMBOL(pci_find_present);
 
-EXPORT_SYMBOL(pci_find_device);
 EXPORT_SYMBOL(pci_find_slot);
 /* For boot time work */
 EXPORT_SYMBOL(pci_find_bus);
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 79c0b6e..ee82a0e 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -18864,7 +18864,7 @@ static int __init advansys_detect(struct scsi_host_template *tpnt)
 					while (pci_device_id_cnt <
 					       ASC_PCI_DEVICE_ID_CNT) {
 						if ((pdev =
-						     pci_find_device
+						     pci_get_device
 						     (PCI_VENDOR_ID_ASP,
 						      pci_device_id
 						      [pci_device_id_cnt],
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 55e4d2d..1b91379 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -894,7 +894,7 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
           *cnt, vendor, device));
 
     pdev = NULL;
-    while ((pdev = pci_find_device(vendor, device, pdev)) 
+    while ((pdev = pci_get_device(vendor, device, pdev)) 
            != NULL) {
         if (pci_enable_device(pdev))
             continue;
