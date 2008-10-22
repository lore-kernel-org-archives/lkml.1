Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYJVJjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYJVJjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYJVJiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:38:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:51483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbYJVJiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,463,1220252400"; 
   d="scan'208";a="454255354"
Date: Wed, 22 Oct 2008 16:42:41 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [PATCH 7/16 v6] PCI: cleanup pcibios_allocate_resources()
Message-ID: <20081022084241.GG3773@yzhao12-linux.sh.intel.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup makes pcibios_allocate_resources() easier to read.

Cc: Alex Chiang <achiang@hp.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>
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

