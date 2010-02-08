Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0BHWon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:44:43 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26424 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0BHWoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:44:39 -0500
Subject: [PATCH v2 4/7] PCI: read bridge windows before filling in subtractive
	decode resources
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 08 Feb 2010 15:44:38 -0700
Message-ID: <20100208224438.27954.6224.stgit@bob.kio>
In-Reply-To: <20100208224236.27954.4358.stgit@bob.kio>
References: <20100208224236.27954.4358.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; this fills in the bus subtractive decode resources
after reading the bridge window information rather than before.  Also,
print out the subtractive decode resources as we already do for the
positive decode windows.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/probe.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8c94650..838a2c4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -403,14 +403,19 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		 child->secondary, child->subordinate,
 		 dev->transparent ? " (subtractive decode)": "");
 
-	if (dev->transparent) {
-		for(i = 3; i < PCI_BUS_NUM_RESOURCES; i++)
-			child->resource[i] = child->parent->resource[i - 3];
-	}
-
 	pci_read_bridge_io(child);
 	pci_read_bridge_mmio(child);
 	pci_read_bridge_mmio_pref(child);
+
+	if (dev->transparent) {
+		for (i = 3; i < PCI_BUS_NUM_RESOURCES; i++) {
+			child->resource[i] = child->parent->resource[i - 3];
+			if (child->resource[i])
+				dev_printk(KERN_DEBUG, &dev->dev,
+					   "  bridge window %pR (subtractive decode)\n",
+					   child->resource[i]);
+		}
+	}
 }
 
 static struct pci_bus * pci_alloc_bus(void)

