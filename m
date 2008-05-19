Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYESEtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYESEtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 00:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYESEs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 00:48:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55626 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYESEsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 00:48:54 -0400
Message-ID: <48310691.9050706@jp.fujitsu.com>
Date: Mon, 19 May 2008 13:48:17 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH] msi: skip calling pci_find_capability from msi_set_mask_bits
References: <20080515160426.GD14846@ghostprotocols.net> <20080515170407.GM9921@parisc-linux.org> <20080515171003.GF14846@ghostprotocols.net> <200805161044.34938.jbarnes@virtuousgeek.org>
In-Reply-To: <200805161044.34938.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Since we know MSI is a problem, let's just go with fixing that for now.  If we 
> find that other caps are also causing problems we can revisit caching all of 
> them; the patch is simple enough.

Humm...
I suppose it can be more simple. How about this patch?


> everytime handle_edge_irq is called it needs to mask and unmask MSI, and
> that leads to a series of very expensive calls to pci_find_capability

The position of MSI capability is already cached in the msi_desc when
we enter the msi_set_mask_bits().  Use it instead.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/msi.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 8c61304..ccb1974 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -70,12 +70,10 @@ arch_teardown_msi_irqs(struct pci_dev *dev)
 	}
 }
 
-static void msi_set_enable(struct pci_dev *dev, int enable)
+static void __msi_set_enable(struct pci_dev *dev, int pos, int enable)
 {
-	int pos;
 	u16 control;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
 	if (pos) {
 		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 		control &= ~PCI_MSI_FLAGS_ENABLE;
@@ -85,6 +83,11 @@ static void msi_set_enable(struct pci_dev *dev, int enable)
 	}
 }
 
+static void msi_set_enable(struct pci_dev *dev, int enable)
+{
+	__msi_set_enable(dev, pci_find_capability(dev, PCI_CAP_ID_MSI), enable);
+}
+
 static void msix_set_enable(struct pci_dev *dev, int enable)
 {
 	int pos;
@@ -141,7 +144,8 @@ static void msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
 			mask_bits |= flag & mask;
 			pci_write_config_dword(entry->dev, pos, mask_bits);
 		} else {
-			msi_set_enable(entry->dev, !flag);
+			__msi_set_enable(entry->dev, entry->msi_attrib.pos,
+					 !flag);
 		}
 		break;
 	case PCI_CAP_ID_MSIX:
-- 
1.5.4.3

