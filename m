Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476AbZCFQQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbZCFQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZCFQQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:16:16 -0500
Received: from usea-naimss2.unisys.com ([192.61.61.104]:4287 "EHLO
	usea-naimss2.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZCFQQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:16:15 -0500
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2009 11:16:15 EST
Subject: [PATCH] MSI: check for BIOS assigned addresses
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Content-Type: text/plain
Date: Fri, 06 Mar 2009 10:11:49 -0500
Message-Id: <1236352309.31604.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 (2.25.92-1.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2009 15:41:56.0626 (UTC) FILETIME=[149FFF20:01C99E72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating MSI addresses the kernel makes them up and writes them to
the hardware without first checking for what the system BIOS may have
assigned.  The patch below checks for already assigned values, and
leaves them alone if they exist. 


Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>

---
diff -Naurp linux-2.6.29-rc5/arch/x86/kernel/io_apic.c linux-2.6.29-rc5-dpy/arch/x86/kernel/io_apic.c
--- linux-2.6.29-rc5/arch/x86/kernel/io_apic.c	2009-02-13 18:31:30.000000000 -0500
+++ linux-2.6.29-rc5-dpy/arch/x86/kernel/io_apic.c	2009-03-04 08:25:30.000000000 -0500
@@ -3258,6 +3258,7 @@ static int msi_compose_msg(struct pci_de
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
@@ -3265,6 +3266,8 @@ static int msi_compose_msg(struct pci_de
 		return err;
 
 	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
+	
+	read_msi_msg_desc(desc, msg);
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3295,17 +3298,18 @@ static int msi_compose_msg(struct pci_de
 	} else
 #endif
 	{
-		msg->address_hi = MSI_ADDR_BASE_HI;
-		msg->address_lo =
-			MSI_ADDR_BASE_LO |
-			((INT_DEST_MODE == 0) ?
-				MSI_ADDR_DEST_MODE_PHYSICAL:
-				MSI_ADDR_DEST_MODE_LOGICAL) |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
-				MSI_ADDR_REDIRECTION_CPU:
-				MSI_ADDR_REDIRECTION_LOWPRI) |
-			MSI_ADDR_DEST_ID(dest);
-
+		if (!msg->address_hi && !msg->address_lo) {
+			msg->address_hi = MSI_ADDR_BASE_HI;
+			msg->address_lo = 
+				MSI_ADDR_BASE_LO |
+				((INT_DEST_MODE == 0) ?
+					MSI_ADDR_DEST_MODE_PHYSICAL:
+					MSI_ADDR_DEST_MODE_LOGICAL) |
+				((INT_DELIVERY_MODE != dest_LowestPrio) ?
+					MSI_ADDR_REDIRECTION_CPU:
+					MSI_ADDR_REDIRECTION_LOWPRI) |
+				MSI_ADDR_DEST_ID(dest); 
+		}
 		msg->data =
 			MSI_DATA_TRIGGER_EDGE |
 			MSI_DATA_LEVEL_ASSERT |
@@ -3440,11 +3444,13 @@ static int setup_msi_irq(struct pci_dev 
 	int ret;
 	struct msi_msg msg;
 
+	set_irq_msi(irq, msidesc);
 	ret = msi_compose_msg(dev, irq, &msg);
-	if (ret < 0)
+	if (ret < 0) {
+		set_irq_msi(irq, NULL);
 		return ret;
+	}
 
-	set_irq_msi(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
 #ifdef CONFIG_INTR_REMAP


