Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYJUMog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYJUMog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYJUMoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:44:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:5726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbYJUMoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="453860098"
Date: Tue, 21 Oct 2008 19:48:52 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 7/15 v5] PCI: cleanup pcibios_allocate_resources()
Message-ID: <20081021114852.GH3185@yzhao12-linux.sh.intel.com>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup makes pcibios_allocate_resources() easier to be read.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 arch/x86/pci/i386.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 844df0c..8729bde 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -147,7 +147,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 static void __init pcibios_allocate_resources(int pass)
 {
 	struct pci_dev *dev = NULL;
-	int idx, disabled;
+	int idx, enabled;
 	u16 command;
 	struct resource *r, *pr;
 
@@ -160,22 +160,22 @@ static void __init pcibios_allocate_resources(int pass)
 			if (!r->start)		/* Address not assigned at all */
 				continue;
 			if (r->flags & IORESOURCE_IO)
-				disabled = !(command & PCI_COMMAND_IO);
+				enabled = command & PCI_COMMAND_IO;
 			else
-				disabled = !(command & PCI_COMMAND_MEMORY);
-			if (pass == disabled) {
-				dev_dbg(&dev->dev, "resource %#08llx-%#08llx (f=%lx, d=%d, p=%d)\n",
+				enabled = command & PCI_COMMAND_MEMORY;
+			if (pass == enabled)
+				continue;
+			dev_dbg(&dev->dev, "resource %#08llx-%#08llx (f=%lx, d=%d, p=%d)\n",
 					(unsigned long long) r->start,
 					(unsigned long long) r->end,
-					r->flags, disabled, pass);
-				pr = pci_find_parent_resource(dev, r);
-				if (!pr || request_resource(pr, r) < 0) {
-					dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
-					/* We'll assign a new address later */
-					r->end -= r->start;
-					r->start = 0;
-				}
-			}
+					r->flags, enabled, pass);
+			pr = pci_find_parent_resource(dev, r);
+			if (pr && !request_resource(pr, r))
+				continue;
+			dev_err(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+			/* We'll assign a new address later */
+			r->end -= r->start;
+			r->start = 0;
 		}
 		if (!pass) {
 			r = &dev->resource[PCI_ROM_RESOURCE];
-- 
1.5.6.4

