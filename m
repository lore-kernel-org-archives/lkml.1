Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYJUMmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYJUMmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbYJUMmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:42:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:41641 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbYJUMmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:42:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,457,1220252400"; 
   d="scan'208";a="350677934"
Date: Tue, 21 Oct 2008 19:47:35 +0800
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
Subject: [PATCH 4/15 v5] PCI: make pci_alloc_child_bus() be able to handle
	NULL bridge
Message-ID: <20081021114735.GE3185@yzhao12-linux.sh.intel.com>
References: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021114056.GA3185@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pci_alloc_child_bus() be able to handle buses without bridge
devices. Some devices such as SR-IOV devices use more than one bus
number while there is no explicit bridge devices since they have
internal routing mechanism.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/probe.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index db3e5a7..4b12b58 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -401,12 +401,10 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	if (!child)
 		return NULL;
 
-	child->self = bridge;
 	child->parent = parent;
 	child->ops = parent->ops;
 	child->sysdata = parent->sysdata;
 	child->bus_flags = parent->bus_flags;
-	child->bridge = get_device(&bridge->dev);
 
 	/* initialize some portions of the bus device, but don't register it
 	 * now as the parent is not properly set up yet.  This device will get
@@ -423,6 +421,11 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	child->primary = parent->secondary;
 	child->subordinate = 0xff;
 
+	if (!bridge)
+		return child;
+
+	child->self = bridge;
+	child->bridge = get_device(&bridge->dev);
 	/* Set up default resource pointers and names.. */
 	for (i = 0; i < PCI_BRIDGE_RES_NUM; i++) {
 		child->resource[i] = &bridge->resource[PCI_BRIDGE_RESOURCES+i];
-- 
1.5.6.4

