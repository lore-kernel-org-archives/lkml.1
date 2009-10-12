Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZJLHDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZJLHDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZJLHDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:03:38 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:18496 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbZJLHDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:03:36 -0400
Subject: [PATCH 2/5] PCI: add support for PCI domains to aer_inject
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, pci-linux@vger.kernel.org
Date: Mon, 12 Oct 2009 01:02:59 -0600
Message-ID: <20091012070259.27029.15151.stgit@bob.kio>
In-Reply-To: <20091012070248.27029.78378.stgit@bob.kio>
References: <20091012070248.27029.78378.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: add support for PCI domains to aer_inject

Add support for PCI domains (segments) to aer_inject.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 62d15f6..5fc5b3e 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -26,6 +26,7 @@
 #include "aerdrv.h"
 
 struct aer_error_inj {
+	u16 domain;
 	u8 bus;
 	u8 dev;
 	u8 fn;
@@ -39,6 +40,7 @@ struct aer_error_inj {
 
 struct aer_error {
 	struct list_head list;
+	u16 domain;
 	unsigned int bus;
 	unsigned int devfn;
 	int pos_cap_err;
@@ -66,22 +68,27 @@ static LIST_HEAD(pci_bus_ops_list);
 /* Protect einjected and pci_bus_ops_list */
 static DEFINE_SPINLOCK(inject_lock);
 
-static void aer_error_init(struct aer_error *err, unsigned int bus,
-			   unsigned int devfn, int pos_cap_err)
+static void aer_error_init(struct aer_error *err, u16 domain,
+			   unsigned int bus, unsigned int devfn,
+			   int pos_cap_err)
 {
 	INIT_LIST_HEAD(&err->list);
+	err->domain = domain;
 	err->bus = bus;
 	err->devfn = devfn;
 	err->pos_cap_err = pos_cap_err;
 }
 
 /* inject_lock must be held before calling */
-static struct aer_error *__find_aer_error(unsigned int bus, unsigned int devfn)
+static struct aer_error *__find_aer_error(u16 domain, unsigned int bus,
+					  unsigned int devfn)
 {
 	struct aer_error *err;
 
 	list_for_each_entry(err, &einjected, list) {
-		if (bus == err->bus && devfn == err->devfn)
+		if (domain == err->domain &&
+		    bus == err->bus &&
+		    devfn == err->devfn)
 			return err;
 	}
 	return NULL;
@@ -90,7 +97,10 @@ static struct aer_error *__find_aer_error(unsigned int bus, unsigned int devfn)
 /* inject_lock must be held before calling */
 static struct aer_error *__find_aer_error_by_dev(struct pci_dev *dev)
 {
-	return __find_aer_error(dev->bus->number, dev->devfn);
+	int domain = pci_domain_nr(dev->bus);
+	if (domain < 0)
+		return NULL;
+	return __find_aer_error((u16)domain, dev->bus->number, dev->devfn);
 }
 
 /* inject_lock must be held before calling */
@@ -172,11 +182,15 @@ static int pci_read_aer(struct pci_bus *bus, unsigned int devfn, int where,
 	struct aer_error *err;
 	unsigned long flags;
 	struct pci_ops *ops;
+	int domain;
 
 	spin_lock_irqsave(&inject_lock, flags);
 	if (size != sizeof(u32))
 		goto out;
-	err = __find_aer_error(bus->number, devfn);
+	domain = pci_domain_nr(bus);
+	if (domain < 0)
+		goto out;
+	err = __find_aer_error((u16)domain, bus->number, devfn);
 	if (!err)
 		goto out;
 
@@ -200,11 +214,15 @@ int pci_write_aer(struct pci_bus *bus, unsigned int devfn, int where, int size,
 	unsigned long flags;
 	int rw1cs;
 	struct pci_ops *ops;
+	int domain;
 
 	spin_lock_irqsave(&inject_lock, flags);
 	if (size != sizeof(u32))
 		goto out;
-	err = __find_aer_error(bus->number, devfn);
+	domain = pci_domain_nr(bus);
+	if (domain < 0)
+		goto out;
+	err = __find_aer_error((u16)domain, bus->number, devfn);
 	if (!err)
 		goto out;
 
@@ -305,7 +323,7 @@ static int aer_inject(struct aer_error_inj *einj)
 	u32 sever;
 	int ret = 0;
 
-	dev = pci_get_bus_and_slot(einj->bus, devfn);
+	dev = pci_get_domain_bus_and_slot((int)einj->domain, einj->bus, devfn);
 	if (!dev)
 		return -EINVAL;
 	rpdev = pcie_find_root_port(dev);
@@ -344,7 +362,8 @@ static int aer_inject(struct aer_error_inj *einj)
 	if (!err) {
 		err = err_alloc;
 		err_alloc = NULL;
-		aer_error_init(err, einj->bus, devfn, pos_cap_err);
+		aer_error_init(err, einj->domain, einj->bus, devfn,
+			       pos_cap_err);
 		list_add(&err->list, &einjected);
 	}
 	err->uncor_status |= einj->uncor_status;
@@ -358,7 +377,8 @@ static int aer_inject(struct aer_error_inj *einj)
 	if (!rperr) {
 		rperr = rperr_alloc;
 		rperr_alloc = NULL;
-		aer_error_init(rperr, rpdev->bus->number, rpdev->devfn,
+		aer_error_init(rperr, pci_domain_nr(rpdev->bus),
+			       rpdev->bus->number, rpdev->devfn,
 			       rp_pos_cap_err);
 		list_add(&rperr->list, &einjected);
 	}

