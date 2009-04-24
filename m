Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbZDXCqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbZDXCqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 22:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZDXCpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 22:45:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:50634 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbZDXCp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 22:45:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,238,1239001200"; 
   d="asc'?scan'208";a="450970464"
Subject: [PATCH 3/4] PCI: PCIE AER: PCIE AER software error injection
From: Huang Ying <ying.huang@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2PvCDczoiCe8FTgbHKor"
Date: Fri, 24 Apr 2009 10:45:27 +0800
Message-Id: <1240541127.6842.681.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2PvCDczoiCe8FTgbHKor
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Debugging PCIE AER code can be very difficult because it is hard to
trigger various real hardware errors. This patch provide a software
based error injection tool, which can fake various PCIE errors with a
user space helper tool named "aer-inject". Which can be gotten from:

  http://www.kernel.org/pub/linux/kernel/people/yhuang/

The patch fakes AER error by faking some PCIE AER related registers
and an AER interrupt for specified the PCIE device.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 drivers/pci/pcie/aer/Kconfig       |    2=20
 drivers/pci/pcie/aer/Kconfig.debug |   18 +
 drivers/pci/pcie/aer/Makefile      |    1=20
 drivers/pci/pcie/aer/aer_inject.c  |  472 ++++++++++++++++++++++++++++++++=
+++++
 4 files changed, 493 insertions(+)

--- /dev/null
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -0,0 +1,472 @@
+/*
+ * PCIE AER software error injection support.
+ *
+ * Debuging PCIE AER code is quite difficult because it is hard to
+ * trigger various real hardware errors. Software based error
+ * injection can fake almost all kinds of errors with the help of a
+ * user space helper tool aer-inject, which can be gotten from:
+ *   http://www.kernel.org/pub/utils/pcie/aer-inject
+ *
+ * Copyright 2009 Intel Corporation.
+ *     Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/miscdevice.h>
+#include <linux/pci.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include "aerdrv.h"
+
+struct aer_error_inj
+{
+	u8 bus;
+	u8 dev;
+	u8 fn;
+	u32 uncor_status;
+	u32 cor_status;
+	u32 header_log0;
+	u32 header_log1;
+	u32 header_log2;
+	u32 header_log3;
+};
+
+struct aer_error
+{
+	struct list_head list;
+	unsigned int bus;
+	unsigned int devfn;
+	int pos_cap_err;
+
+	u32 uncor_status;
+	u32 cor_status;
+	u32 header_log0;
+	u32 header_log1;
+	u32 header_log2;
+	u32 header_log3;
+	u32 root_status;
+	u32 source_id;
+};
+
+struct pci_bus_ops
+{
+	struct list_head list;
+	struct pci_bus *bus;
+	struct pci_ops *ops;
+};
+
+static LIST_HEAD(einjected);
+
+static LIST_HEAD(pci_bus_ops_list);
+
+/* Protect einjected and pci_bus_ops_list */
+static DEFINE_SPINLOCK(inject_lock);
+
+static void aer_error_init(struct aer_error *err, unsigned int bus,
+			   unsigned int devfn, int pos_cap_err)
+{
+	INIT_LIST_HEAD(&err->list);
+	err->bus =3D bus;
+	err->devfn =3D devfn;
+	err->pos_cap_err =3D pos_cap_err;
+}
+
+/* inject_lock must be held before calling */
+static struct aer_error *__find_aer_error(unsigned int bus, unsigned int d=
evfn)
+{
+	struct aer_error *err;
+
+	list_for_each_entry(err, &einjected, list) {
+		if (bus =3D=3D err->bus && devfn =3D=3D err->devfn)
+			return err;
+	}
+	return NULL;
+}
+
+/* inject_lock must be held before calling */
+static struct aer_error *__find_aer_error_by_dev(struct pci_dev *dev)
+{
+	return __find_aer_error(dev->bus->number, dev->devfn);
+}
+
+/* inject_lock must be held before calling */
+static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
+{
+	struct pci_bus_ops *bus_ops;
+
+	list_for_each_entry(bus_ops, &pci_bus_ops_list, list) {
+		if (bus_ops->bus =3D=3D bus)
+			return bus_ops->ops;
+	}
+	return NULL;
+}
+
+static struct pci_bus_ops *pci_bus_ops_pop(void)
+{
+	unsigned long flags;
+	struct pci_bus_ops *bus_ops =3D NULL;
+
+	spin_lock_irqsave(&inject_lock, flags);
+	if (list_empty(&pci_bus_ops_list))
+		bus_ops =3D NULL;
+	else {
+		struct list_head *lh =3D pci_bus_ops_list.next;
+		list_del(lh);
+		bus_ops =3D list_entry(lh, struct pci_bus_ops, list);
+	}
+	spin_unlock_irqrestore(&inject_lock, flags);
+	return bus_ops;
+}
+
+static u32 *find_pci_config_dword(struct aer_error *err, int where,
+				  int *prw1cs)
+{
+	int rw1cs =3D 0;
+	u32 *target =3D NULL;
+
+	if (err->pos_cap_err =3D=3D -1)
+		return NULL;
+
+	switch (where - err->pos_cap_err) {
+	case PCI_ERR_UNCOR_STATUS:
+		target =3D &err->uncor_status;
+		rw1cs =3D 1;
+		break;
+	case PCI_ERR_COR_STATUS:
+		target =3D &err->cor_status;
+		rw1cs =3D 1;
+		break;
+	case PCI_ERR_HEADER_LOG:
+		target =3D &err->header_log0;
+		break;
+	case PCI_ERR_HEADER_LOG+4:
+		target =3D &err->header_log1;
+		break;
+	case PCI_ERR_HEADER_LOG+8:
+	        target =3D &err->header_log2;
+		break;
+	case PCI_ERR_HEADER_LOG+12:
+		target =3D &err->header_log3;
+		break;
+	case PCI_ERR_ROOT_STATUS:
+		target =3D &err->root_status;
+		rw1cs =3D 1;
+		break;
+	case PCI_ERR_ROOT_COR_SRC:
+		target =3D &err->source_id;
+		break;
+	}
+	if (prw1cs)
+		*prw1cs =3D rw1cs;
+	return target;
+}
+
+static int pci_read_aer(struct pci_bus *bus, unsigned int devfn, int where=
,
+			int size, u32 *val)
+{
+	u32 *sim;
+	struct aer_error *err;
+	unsigned long flags;
+	struct pci_ops *ops;
+
+	spin_lock_irqsave(&inject_lock, flags);
+	if (size !=3D sizeof(u32))
+		goto out;
+	err =3D __find_aer_error(bus->number, devfn);
+	if (!err)
+		goto out;
+
+	sim =3D find_pci_config_dword(err, where, NULL);
+	if (sim) {
+		*val =3D *sim;
+		spin_unlock_irqrestore(&inject_lock, flags);
+		return 0;
+	}
+out:
+	ops =3D __find_pci_bus_ops(bus);
+	spin_unlock_irqrestore(&inject_lock, flags);
+	return ops->read(bus, devfn, where, size, val);
+}
+
+int pci_write_aer(struct pci_bus *bus, unsigned int devfn, int where, int =
size,
+		  u32 val)
+{
+	u32 *sim;
+	struct aer_error *err;
+	unsigned long flags;
+	int rw1cs;
+	struct pci_ops *ops;
+
+	spin_lock_irqsave(&inject_lock, flags);
+	if (size !=3D sizeof(u32))
+		goto out;
+	err =3D __find_aer_error(bus->number, devfn);
+	if (!err)
+		goto out;
+
+	sim =3D find_pci_config_dword(err, where, &rw1cs);
+	if (sim) {
+		if (rw1cs)
+			*sim ^=3D val;
+		else
+			*sim =3D val;
+		spin_unlock_irqrestore(&inject_lock, flags);
+		return 0;
+	}
+out:
+	ops =3D __find_pci_bus_ops(bus);
+	spin_unlock_irqrestore(&inject_lock, flags);
+	return ops->write(bus, devfn, where, size, val);
+}
+
+static struct pci_ops pci_ops_aer =3D {
+	.read =3D pci_read_aer,
+	.write =3D pci_write_aer,
+};
+
+static void pci_bus_ops_init(struct pci_bus_ops *bus_ops,
+			     struct pci_bus *bus,
+			     struct pci_ops *ops)
+{
+	INIT_LIST_HEAD(&bus_ops->list);
+	bus_ops->bus =3D bus;
+	bus_ops->ops =3D ops;
+}
+
+static int pci_bus_set_aer_ops(struct pci_bus *bus)
+{
+	struct pci_ops *ops;
+	struct pci_bus_ops *bus_ops;
+	unsigned long flags;
+
+	bus_ops =3D kmalloc(sizeof(*bus_ops), GFP_KERNEL);
+	if (!bus_ops)
+		return -ENOMEM;
+	ops =3D pci_bus_set_ops(bus, &pci_ops_aer);
+	spin_lock_irqsave(&inject_lock, flags);
+	if (ops =3D=3D &pci_ops_aer)
+		goto out;
+	pci_bus_ops_init(bus_ops, bus, ops);
+	list_add(&bus_ops->list, &pci_bus_ops_list);
+	bus_ops =3D NULL;
+out:
+	spin_unlock_irqrestore(&inject_lock, flags);
+	if (bus_ops)
+		kfree(bus_ops);
+	return 0;
+}
+
+static struct pci_dev *pcie_find_root_port(struct pci_dev *dev)
+{
+	while (1) {
+		if (!dev->is_pcie)
+			break;
+		if (dev->pcie_type =3D=3D PCI_EXP_TYPE_ROOT_PORT)
+			return dev;
+		if (!dev->bus->self)
+			break;
+		dev =3D dev->bus->self;
+	}
+	return NULL;
+}
+
+static int find_aer_device_iter(struct device *device, void *data)
+{
+	struct pcie_device **result =3D data;
+	struct pcie_device *pcie_dev;
+
+	if (device->bus =3D=3D &pcie_port_bus_type) {
+		pcie_dev =3D to_pcie_device(device);
+		if (pcie_dev->service & PCIE_PORT_SERVICE_AER) {
+			*result =3D pcie_dev;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int find_aer_device(struct pci_dev *dev, struct pcie_device **resul=
t)
+{
+	return device_for_each_child(&dev->dev, result, find_aer_device_iter);
+}
+
+static int aer_inject(struct aer_error_inj *einj)
+{
+	struct aer_error *err, *rperr;
+	struct aer_error *err_alloc =3D NULL, *rperr_alloc =3D NULL;
+	struct pci_dev *dev, *rpdev;
+	struct pcie_device *edev;
+	unsigned long flags;
+	unsigned int devfn =3D PCI_DEVFN(einj->dev, einj->fn);
+	int pos_cap_err, rp_pos_cap_err;
+	u32 sever;
+	int ret =3D 0;
+
+	dev =3D pci_get_bus_and_slot(einj->bus, devfn);
+	if (!dev)
+		return -EINVAL;
+	rpdev =3D pcie_find_root_port(dev);
+	if (!rpdev) {
+		ret =3D -EINVAL;
+		goto out_put;
+	}
+
+	pos_cap_err =3D pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (!pos_cap_err) {
+		ret =3D -EIO;
+		goto out_put;
+	}
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_SEVER, &sever);
+
+	rp_pos_cap_err =3D pci_find_ext_capability(rpdev, PCI_EXT_CAP_ID_ERR);
+	if (!rp_pos_cap_err) {
+		ret =3D -EIO;
+		goto out_put;
+	}
+
+	err_alloc =3D  kzalloc(sizeof(struct aer_error), GFP_KERNEL);
+	if (!err_alloc) {
+		ret =3D -ENOMEM;
+		goto out_put;
+	}
+	rperr_alloc =3D  kzalloc(sizeof(struct aer_error), GFP_KERNEL);
+	if (!rperr_alloc) {
+		ret =3D -ENOMEM;
+		goto out_put;
+	}
+
+	spin_lock_irqsave(&inject_lock, flags);
+
+	err =3D __find_aer_error_by_dev(dev);
+	if (!err) {
+		err =3D err_alloc;
+		err_alloc =3D NULL;
+		aer_error_init(err, einj->bus, devfn, pos_cap_err);
+		list_add(&err->list, &einjected);
+	}
+	err->uncor_status |=3D einj->uncor_status;
+	err->cor_status |=3D einj->cor_status;
+	err->header_log0 =3D einj->header_log0;
+	err->header_log1 =3D einj->header_log1;
+	err->header_log2 =3D einj->header_log2;
+	err->header_log3 =3D einj->header_log3;
+
+	rperr =3D __find_aer_error_by_dev(rpdev);
+	if (!rperr) {
+		rperr =3D rperr_alloc;
+		rperr_alloc =3D NULL;
+		aer_error_init(rperr, rpdev->bus->number, rpdev->devfn,
+			       rp_pos_cap_err);
+		list_add(&rperr->list, &einjected);
+	}
+	if (einj->cor_status) {
+		if (rperr->root_status & PCI_ERR_ROOT_COR_RCV)
+			rperr->root_status |=3D PCI_ERR_ROOT_MULTI_COR_RCV;
+		else
+			rperr->root_status |=3D PCI_ERR_ROOT_COR_RCV;
+		rperr->source_id &=3D 0xffff0000;
+		rperr->source_id |=3D (einj->bus << 8) | devfn;
+	}
+	if (einj->uncor_status) {
+		if (rperr->root_status & PCI_ERR_ROOT_UNCOR_RCV)
+			rperr->root_status |=3D PCI_ERR_ROOT_MULTI_UNCOR_RCV;
+		else {
+			if (sever & einj->uncor_status)
+				rperr->root_status |=3D PCI_ERR_ROOT_FIRST_FATAL;
+		}
+		if (!(sever & einj->uncor_status))
+			rperr->root_status |=3D PCI_ERR_ROOT_UNCOR_RCV;
+		rperr->source_id &=3D 0x0000ffff;
+		rperr->source_id |=3D ((einj->bus << 8) | devfn) << 16;
+	}
+	spin_unlock_irqrestore(&inject_lock, flags);
+
+	ret =3D pci_bus_set_aer_ops(dev->bus);
+	if (ret)
+		goto out_put;
+	ret =3D pci_bus_set_aer_ops(rpdev->bus);
+	if (ret)
+		goto out_put;
+
+	if (find_aer_device(rpdev, &edev))
+		aer_irq(-1, edev);
+	else
+		ret =3D -EINVAL;
+out_put:
+	if (err_alloc)
+		kfree(err_alloc);
+	if (rperr_alloc)
+		kfree(rperr_alloc);
+	pci_dev_put(dev);
+	return ret;
+}
+
+static ssize_t aer_inject_write(struct file *filp, const char __user *ubuf=
,
+				size_t usize, loff_t *off)
+{
+	struct aer_error_inj einj;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (usize !=3D sizeof(struct aer_error_inj))
+		return -EINVAL;
+
+	if (copy_from_user(&einj, ubuf, usize))
+		return -EFAULT;
+
+	ret =3D aer_inject(&einj);
+	return ret ? ret : usize;
+}
+
+static const struct file_operations aer_inject_fops =3D {
+	.write =3D aer_inject_write,
+	.owner =3D THIS_MODULE,
+};
+
+static struct miscdevice aer_inject_device =3D {
+	.minor =3D MISC_DYNAMIC_MINOR,
+	.name =3D "aer_inject",
+	.fops =3D &aer_inject_fops,
+};
+
+static int __init aer_inject_init(void)
+{
+	return misc_register(&aer_inject_device);
+}
+
+static void __exit aer_inject_exit(void)
+{
+	struct aer_error *err, *err_next;
+	unsigned long flags;
+	struct pci_bus_ops *bus_ops;
+
+	misc_deregister(&aer_inject_device);
+
+	while ((bus_ops =3D pci_bus_ops_pop())) {
+		pci_bus_set_ops(bus_ops->bus, bus_ops->ops);
+		kfree(bus_ops);
+	}
+
+	spin_lock_irqsave(&inject_lock, flags);
+	list_for_each_entry_safe(err, err_next,
+				 &pci_bus_ops_list, list) {
+		list_del(&err->list);
+		kfree(err);
+	}
+	spin_unlock_irqrestore(&inject_lock, flags);
+}
+
+module_init(aer_inject_init);
+module_exit(aer_inject_exit);
+
+MODULE_DESCRIPTION("PCIE AER software error injector");
+MODULE_LICENSE("GPL");
--- a/drivers/pci/pcie/aer/Kconfig
+++ b/drivers/pci/pcie/aer/Kconfig
@@ -10,3 +10,5 @@ config PCIEAER
 	  This enables PCI Express Root Port Advanced Error Reporting
 	  (AER) driver support. Error reporting messages sent to Root
 	  Port will be handled by PCI Express AER driver.
+
+source "drivers/pci/pcie/aer/Kconfig.debug"
--- a/drivers/pci/pcie/aer/Makefile
+++ b/drivers/pci/pcie/aer/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_PCIEAER) +=3D aerdriver.o
 aerdriver-objs :=3D aerdrv_errprint.o aerdrv_core.o aerdrv.o
 aerdriver-$(CONFIG_ACPI) +=3D aerdrv_acpi.o
=20
+obj-$(CONFIG_PCIEAER_INJECT) +=3D aer_inject.o
--- /dev/null
+++ b/drivers/pci/pcie/aer/Kconfig.debug
@@ -0,0 +1,18 @@
+#
+# PCI Express Root Port Device AER Debug Configuration
+#
+
+config PCIEAER_INJECT
+	tristate "PCIE AER error injector support"
+	depends on PCIEAER
+	default n
+	help
+	  This enables PCI Express Root Port Advanced Error Reporting
+	  (AER) software error injector.
+
+	  Debuging PCIE AER code is quite difficult because it is hard
+	  to trigger various real hardware errors. Software based
+	  error injection can fake almost all kinds of errors with the
+	  help of a user space helper tool aer-inject, which can be
+	  gotten from:
+	     http://www.kernel.org/pub/utils/pcie/aer-inject


--=-2PvCDczoiCe8FTgbHKor
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxJ8UACgkQKhFGF+eHlpipbwCeL5BZlzeU30PJnnLErMyodIk/
/oMAn1oaowYcxgub48TPhw+AXAnAtkLR
=rpbD
-----END PGP SIGNATURE-----

--=-2PvCDczoiCe8FTgbHKor--

