Return-Path: <linux-kernel-owner+w=401wt.eu-S966793AbYD1X1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966793AbYD1X1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbYD1X1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:27:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26065 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764598AbYD1X1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=NaWRG8RjTNmNwqFX6Fn0WygNwCepsrgW385Ti1xraHKtUqK0t1vJwZGlad4lN323D5VHXmhaY4tHkNcYwY7ISMqRItCl1wO2KO7hUZxJlvgHz0nbYRSLF/3mkjxd1tS4SIkTNd98829OL/OgLzk8HPTQQ6MSDzT96EIzFQApE5I=
Reply-To: yhlu.kernel@gmail.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/pci: remove flag in pci_cfg_space_size_ext
Date: Mon, 28 Apr 2008 16:27:23 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>
References: <20080426185516.GA32364@elte.hu> <20080426215540.GA3545@elte.hu> <200804281334.16713.jbarnes@virtuousgeek.org>
In-Reply-To: <200804281334.16713.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281627.23566.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so let pci_cfg_space_size call it directly without flag.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index b60b2ab..ff3a6a3 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -502,7 +502,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
  */
 static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
 {
-	dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
+	dev->cfg_size = pci_cfg_space_size_ext(dev);
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, fam10h_pci_cfg_space_size);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4a55bf3..3706ce7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -842,13 +842,25 @@ static void set_pcie_port_type(struct pci_dev *pdev)
  * reading the dword at 0x100 which must either be 0 or a valid extended
  * capability header.
  */
-int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)
+int pci_cfg_space_size_ext(struct pci_dev *dev)
 {
-	int pos;
 	u32 status;
 
-	if (!check_exp_pcix)
-		goto skip;
+	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
+		goto fail;
+	if (status == 0xffffffff)
+		goto fail;
+
+	return PCI_CFG_SPACE_EXP_SIZE;
+
+ fail:
+	return PCI_CFG_SPACE_SIZE;
+}
+
+int pci_cfg_space_size(struct pci_dev *dev)
+{
+	int pos;
+	u32 status;
 
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
@@ -861,23 +873,12 @@ int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)
 			goto fail;
 	}
 
- skip:
-	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
-		goto fail;
-	if (status == 0xffffffff)
-		goto fail;
-
-	return PCI_CFG_SPACE_EXP_SIZE;
+	return pci_cfg_space_size_ext(dev);
 
  fail:
 	return PCI_CFG_SPACE_SIZE;
 }
 
-int pci_cfg_space_size(struct pci_dev *dev)
-{
-	return pci_cfg_space_size_ext(dev, 1);
-}
-
 static void pci_release_bus_bridge_dev(struct device *dev)
 {
 	kfree(dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8f53f4b..e9b4fcb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -667,7 +667,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 		  void *userdata);
-int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix);
+int pci_cfg_space_size_ext(struct pci_dev *dev);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus *bus);
 
