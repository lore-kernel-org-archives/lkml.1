Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbXHWDUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbXHWDUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXHWDU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:20:28 -0400
Received: from n7a.bullet.mail.re3.yahoo.com ([68.142.236.45]:48051 "HELO
	n7a.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752762AbXHWDU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:20:27 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 89946.20981.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=BSC9H7an255haVyONMY9qGRxr+FJrJVlsqN0j036L+onxkczSDhtdQagl29zN1ZyQq/mQelvFJc5lcgDCqesOGHCU+A+JiD6egD4ZD4//4YDHhwvZZemph3UW43ca5pP2tTUecOeAwGuKnXo9E+ImWUxq0xymIaRdDcwz6JN8nY=;
Date: Wed, 22 Aug 2007 20:20:25 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 2 of 5 resend ] /drivers/char/agp ioremap balancing/ returncode check
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <416748.85586.qm@web44901.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc3.  
corrects missing ioremap return checks and balancing on iounmap calls, integrated changes per list
recommendations on the original set of patches..

Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
portions of ioremap audit.

This patch had been submitted previously but hushmail client caused wordwrap issues, resending
with different mail client.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index df0ddf1..ad946fd 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -223,7 +223,9 @@ static int amd_irongate_configure(void)
 	pci_read_config_dword(agp_bridge->dev, AMD_MMBASE, &temp);
 	temp = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 	amd_irongate_private.registers = (volatile u8 __iomem *) ioremap(temp, 4096);
-
+	if (!amd_irongate_private.registers) 
+		return -ENOMEM;
+	
 	/* Write out the address of the gatt table */
 	writel(agp_bridge->gatt_bus_addr, amd_irongate_private.registers+AMD_ATTBASE);
 	readl(amd_irongate_private.registers+AMD_ATTBASE);	/* PCI Posting. */
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index da7513d..95200f8 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -213,6 +213,9 @@ static int ati_configure(void)
 	temp = (temp & 0xfffff000);
 	ati_generic_private.registers = (volatile u8 __iomem *) ioremap(temp, 4096);
 
+	if (!ati_generic_private.registers) 
+		return -ENOMEM;
+
 	if (is_r200())
 		pci_write_config_dword(agp_bridge->dev, ATI_RS100_IG_AGPMODE, 0x20000);
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
 
diff --git a/drivers/char/agp/i460-agp.c b/drivers/char/agp/i460-agp.c
index 53354bf..75d2aca 100644
--- a/drivers/char/agp/i460-agp.c
+++ b/drivers/char/agp/i460-agp.c
@@ -249,6 +249,10 @@ static int i460_create_gatt_table (struct agp_bridge_data *bridge)
 	num_entries = A_SIZE_8(temp)->num_entries;
 
 	i460.gatt = ioremap(INTEL_I460_ATTBASE, PAGE_SIZE << page_order);
+	if (!i460.gatt) {
+		printk(KERN_ERR PFX "ioremap failed\n");
+		return -ENOMEM;
+	}
 
 	/* These are no good, the should be removed from the agp_bridge strucure... */
 	agp_bridge->gatt_table_real = NULL;
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 294cdbf..2c9ca2c 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -930,8 +930,10 @@ static int intel_i915_create_gatt_table(struct agp_bridge_data *bridge)
 	temp &= 0xfff80000;
 
 	intel_private.registers = ioremap(temp,128 * 4096);
-	if (!intel_private.registers)
+	if (!intel_private.registers) {
+		iounmap(intel_private.gtt);
 		return -ENOMEM;
+	}
 
 	temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
 	global_cache_flush();	/* FIXME: ? */
@@ -985,13 +987,15 @@ static int intel_i965_create_gatt_table(struct agp_bridge_data
        temp &= 0xfff00000;
        intel_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 1024);
 
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
 
        temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
        global_cache_flush();   /* FIXME: ? */
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
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
 


       
____________________________________________________________________________________
Sick sense of humor? Visit Yahoo! TV's 
Comedy with an Edge to see what's on, when. 
http://tv.yahoo.com/collections/222


      ____________________________________________________________________________________
Park yourself in front of a world of choices in alternative vehicles. Visit the Yahoo! Auto Green Center.
http://autos.yahoo.com/green_center/ 

