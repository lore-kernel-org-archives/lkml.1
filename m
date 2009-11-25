Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZKYCQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZKYCQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbZKYCQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:16:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:36953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbZKYCQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:16:43 -0500
Message-ID: <4B0C90D8.2000407@kernel.org>
Date: Tue, 24 Nov 2009 18:05:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] x86/pci: claim SR-IOV bar in pcibios_allocate_resource -v2
References: <4AFFB1E6.9040300@kernel.org>	<20091124131912.2aabb852@jbarnes-piketon>	<4B0C4E69.4090402@kernel.org> <20091124134008.0050a339@jbarnes-piketon>
In-Reply-To: <20091124134008.0050a339@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so use correct allocation from BIOS, instead of later assign another one.

-v2: use idx_range, so make it more clear

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/i386.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -146,16 +146,29 @@ static void __init pcibios_allocate_bus_
 	}
 }
 
+struct pci_check_idx_range {
+	int start;
+	int end;
+};
+
 static void __init pcibios_allocate_resources(int pass)
 {
 	struct pci_dev *dev = NULL;
-	int idx, disabled;
+	int idx, disabled, i;
 	u16 command;
 	struct resource *r;
 
+	struct pci_check_idx_range idx_range[] = {
+		{ PCI_STD_RESOURCES, PCI_STD_RESOURCE_END },
+#ifdef CONFIG_PCI_IOV
+		{ PCI_IOV_RESOURCES, PCI_IOV_RESOURCE_END },
+#endif
+	};
+
 	for_each_pci_dev(dev) {
 		pci_read_config_word(dev, PCI_COMMAND, &command);
-		for (idx = 0; idx < PCI_ROM_RESOURCE; idx++) {
+		for (i = 0; i < ARRAY_SIZE(idx_range); i++)
+		for (idx = idx_range[i].start; idx <= idx_range[i].end; idx++) {
 			r = &dev->resource[idx];
 			if (r->parent)		/* Already allocated */
 				continue;
