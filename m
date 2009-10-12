Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbZJLTOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbZJLTOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbZJLTOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:14:47 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:46178 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbZJLTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:14:44 -0400
Subject: [PATCH v2 2/4] PCI: add support for PCI domains to aer_inject
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, linux-pci@vger.kernel.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Date: Mon, 12 Oct 2009 13:14:05 -0600
Message-ID: <20091012191405.14959.18482.stgit@bob.kio>
In-Reply-To: <20091012191354.14959.47024.stgit@bob.kio>
References: <20091012191354.14959.47024.stgit@bob.kio>
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
index 62d15f6..ac0b5e7 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -23,6 +23,7 @@
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/stddef.h>
 #include "aerdrv.h"
 
 struct aer_error_inj {
@@ -35,10 +36,12 @@ struct aer_error_inj {
 	u32 header_log1;
 	u32 header_log2;
 	u32 header_log3;
+	u16 domain;
 };
 
 struct aer_error {
 	struct list_head list;
+	u16 domain;
 	unsigned int bus;
 	unsigned int devfn;
 	int pos_cap_err;
@@ -66,22 +69,27 @@ static LIST_HEAD(pci_bus_ops_list);
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
@@ -90,7 +98,10 @@ static struct aer_error *__find_aer_error(unsigned int bus, unsigned int devfn)
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
@@ -172,11 +183,15 @@ static int pci_read_aer(struct pci_bus *bus, unsigned int devfn, int where,
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
 
@@ -200,11 +215,15 @@ int pci_write_aer(struct pci_bus *bus, unsigned int devfn, int where, int size,
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
 
@@ -305,7 +324,7 @@ static int aer_inject(struct aer_error_inj *einj)
 	u32 sever;
 	int ret = 0;
 
-	dev = pci_get_bus_and_slot(einj->bus, devfn);
+	dev = pci_get_domain_bus_and_slot((int)einj->domain, einj->bus, devfn);
 	if (!dev)
 		return -EINVAL;
 	rpdev = pcie_find_root_port(dev);
@@ -344,7 +363,8 @@ static int aer_inject(struct aer_error_inj *einj)
 	if (!err) {
 		err = err_alloc;
 		err_alloc = NULL;
-		aer_error_init(err, einj->bus, devfn, pos_cap_err);
+		aer_error_init(err, einj->domain, einj->bus, devfn,
+			       pos_cap_err);
 		list_add(&err->list, &einjected);
 	}
 	err->uncor_status |= einj->uncor_status;
@@ -358,7 +378,8 @@ static int aer_inject(struct aer_error_inj *einj)
 	if (!rperr) {
 		rperr = rperr_alloc;
 		rperr_alloc = NULL;
-		aer_error_init(rperr, rpdev->bus->number, rpdev->devfn,
+		aer_error_init(rperr, pci_domain_nr(rpdev->bus),
+			       rpdev->bus->number, rpdev->devfn,
 			       rp_pos_cap_err);
 		list_add(&rperr->list, &einjected);
 	}
@@ -411,10 +432,11 @@ static ssize_t aer_inject_write(struct file *filp, const char __user *ubuf,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	if (usize != sizeof(struct aer_error_inj))
+	if (usize < offsetof(struct aer_error_inj, domain) ||
+	    usize > sizeof(einj))
 		return -EINVAL;
 
+	memset(&einj, 0, sizeof(einj));
 	if (copy_from_user(&einj, ubuf, usize))
 		return -EFAULT;
 

