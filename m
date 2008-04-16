Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbYDPUBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbYDPUBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYDPUB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:01:26 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:1153 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYDPUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=laTNlR6r9uZ1lUEuqnX0MTBdodwxvJEL965Ki+GMS5PyOcMd6aJ96iqhW3iRRNRIHDnO/NeV/Laaizq8en0502/SoJDHzaKw1KjZs2If7BGmBlF1Rdr65MK0JW4vpGa5xWs3YaWYzn72bjsL3OcxTmP0SqvzNw/QI9Nlak8O714=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: don't call pxm_to_node again
Date: Wed, 16 Apr 2008 13:01:05 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804161301.06090.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also make bus_numa work even ACPI_NUMA is not defined.

don't call pxm_to_node again, and use node directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 9a1cad0..3e1fd80 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -171,11 +171,11 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 	if (node != -1)
 		set_mp_bus_to_node(busnum, node);
 	else
+#endif
 		node = get_mp_bus_to_node(busnum);
 
 	if (node != -1 && !node_online(node))
 		node = -1;
-#endif
 
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
@@ -207,14 +207,16 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 	if (!bus)
 		kfree(sd);
 
+	if (bus && node != -1) {
 #ifdef CONFIG_ACPI_NUMA
-	if (bus) {
-		if (pxm >= 0) {
+		if (pxm >= 0)
 			printk(KERN_DEBUG "bus %02x -> pxm %d -> node %d\n",
-				busnum, pxm, pxm_to_node(pxm));
-		}
-	}
+				busnum, pxm, node);
+#else
+		printk(KERN_DEBUG "bus %02x -> node %d\n",
+			busnum, node);
 #endif
+	}
 
 	if (bus && (pci_probe & PCI_USE__CRS))
 		get_current_resources(device, busnum, bus);
