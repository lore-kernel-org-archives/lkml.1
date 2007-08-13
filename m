Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXHMECo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXHMECo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 00:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXHMECh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 00:02:37 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:56626 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXHMECg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 00:02:36 -0400
Date: Mon, 13 Aug 2007 00:02:33 -0400
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>
Subject: [PATCH 2 of 5 ] /drivers/char/agp ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070813040234.44A89DA838@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc2 and this set is an audit of 
/drivers/char/a* 
through drivers/char .   

this corrects missing ioremap return checks and balancing on 
iounmap calls..

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-
k7-agp.c
index df0ddf1..ad946fd 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -223,7 +223,9 @@ static int amd_irongate_configure(void)
 	pci_read_config_dword(agp_bridge->dev, AMD_MMBASE, &temp);
 	temp = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 	amd_irongate_private.registers = (volatile u8 __iomem *) 
ioremap(temp, 4096);
-
+	if (!amd_irongate_private.registers) 
+		return -ENOMEM;
+	
 	/* Write out the address of the gatt table */
 	writel(agp_bridge->gatt_bus_addr, 
amd_irongate_private.registers+AMD_ATTBASE);
 	readl(amd_irongate_private.registers+AMD_ATTBASE);	/* PCI 
Posting. */
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index da7513d..95200f8 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -213,6 +213,9 @@ static int ati_configure(void)
 	temp = (temp & 0xfffff000);
 	ati_generic_private.registers = (volatile u8 __iomem *) 
ioremap(temp, 4096);
 
+	if (!ati_generic_private.registers) 
+		return -ENOMEM;
+
 	if (is_r200())
 		pci_write_config_dword(agp_bridge->dev, ATI_RS100_IG_AGPMODE, 
0x20000);
 	else
diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index bcdb149..313a133 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -221,6 +221,7 @@ hp_zx1_lba_init (u64 hpa)
 	if (cap != PCI_CAP_ID_AGP) {
 		printk(KERN_ERR PFX "Invalid capability ID 0x%02x at 0x%x\n",
 		       cap, hp->lba_cap_offset);
+		iounmap(hp->lba_regs);
 		return -ENODEV;
 	}
 
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-
agp.c
index 53354bf..75d2aca 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -249,6 +249,10 @@ static int i460_create_gatt_table (struct 
agp_bridge_data *bridge)
 	num_entries = A_SIZE_8(temp)->num_entries;
 
 	i460.gatt = ioremap(INTEL_I460_ATTBASE, PAGE_SIZE << page_order);
+	if (!i460.gatt) {
+		printk(KERN_ERR PFX "ioremap failed\n");
+		return -ENOMEM;
+	}
 
 	/* These are no good, the should be removed from the agp_bridge 
strucure... */
 	agp_bridge->gatt_table_real = NULL;
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-
agp.c
index 294cdbf..ffa7cdf 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -930,8 +930,10 @@ static int intel_i915_create_gatt_table(struct 
agp_bridge_data *bridge)
 	temp &= 0xfff80000;
 
 	intel_private.registers = ioremap(temp,128 * 4096);
-	if (!intel_private.registers)
+	if (!intel_private.registers) {
+		iounmap(intel_private.gtt);
 		return -ENOMEM;
+	}
 
 	temp = readl(intel_private.registers+I810_PGETBL_CTL) & 
0xfffff000;
 	global_cache_flush();	/* FIXME: ? */
@@ -985,13 +987,15 @@ static int 
intel_i965_create_gatt_table(struct agp_bridge_data *bridge)
        temp &= 0xfff00000;
        intel_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 
1024);
 
-       if (!intel_private.gtt)
-               return -ENOMEM;
+	if (!intel_private.gtt)
+		return -ENOMEM;
 
 
        intel_private.registers = ioremap(temp,128 * 4096);
-       if (!intel_private.registers)
-               return -ENOMEM;
+       if (!intel_private.registers) {
+		iounmap(intel_private.gtt);
+		return -ENOMEM;
+	}
 
        temp = readl(intel_private.registers+I810_PGETBL_CTL) & 
0xfffff000;
        global_cache_flush();   /* FIXME: ? */
diff --git a/drivers/char/agp/nvidia-agp.c 
b/drivers/char/agp/nvidia-agp.c
index 6cd7373..225ed2a 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -157,6 +157,9 @@ static int nvidia_configure(void)
 	nvidia_private.aperture =
 		(volatile u32 __iomem *) ioremap(apbase, 33 * PAGE_SIZE);
 
+	if (!nvidia_private.aperture)
+		return -ENOMEM;
+
 	return 0;
 }
 


