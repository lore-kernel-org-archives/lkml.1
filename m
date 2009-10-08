Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbZJHWyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbZJHWyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 18:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbZJHWyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 18:54:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779AbZJHWyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 18:54:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PCI <linux-pci@vger.kernel.org>
Subject: [RFC][PATCH 2/4] PCI PM: PCIe PME root port service driver (rev. 3)
Date: Fri, 9 Oct 2009 00:53:23 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <200910090051.50932.rjw@sisk.pl>
In-Reply-To: <200910090051.50932.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910090053.23879.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

PCIe native PME detection mechanism is based on interrupts generated
by root ports or event collectors every time a PCIe device sends a
PME message upstream.

Once a PME message has been sent by an endpoint device and received
by its root port (or event collector in the case of root complex
integrated endpoints), the Requester ID from the message header is
registered in the root port's Root Status register.  At the same
time, the PME Status bit of the Root Status register is set to
indicate that there's a PME to handle.  If PCIe PME interrupt is
enabled for the root port, it generates an interrupt once the PME
Status has been set.  After receiving the interrupt, the kernel can
identify the PCIe device that generated the PME using the Requester
ID from the root port's Root Status register. [For details, see PCI
Express Base Specification, Rev. 2.0.]

Implement a driver for the PCIe PME root port service working in
accordance with the above description.

Based on a patch from Shaohua Li <shaohua.li@intel.com>.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c               |    4 
 drivers/pci/pcie/Kconfig             |    4 
 drivers/pci/pcie/Makefile            |    2 
 drivers/pci/pcie/pme/Makefile        |    8 
 drivers/pci/pcie/pme/pcie_pme.c      |  491 +++++++++++++++++++++++++++++++++++
 drivers/pci/pcie/pme/pcie_pme.h      |   28 +
 drivers/pci/pcie/pme/pcie_pme_acpi.c |   54 +++
 include/linux/pci.h                  |    6 
 8 files changed, 595 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/pcie/Kconfig
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/Kconfig
+++ linux-2.6/drivers/pci/pcie/Kconfig
@@ -46,3 +46,7 @@ config PCIEASPM_DEBUG
 	help
 	  This enables PCI Express ASPM debug support. It will add per-device
 	  interface to control ASPM.
+
+config PCIE_PME
+	def_bool y
+	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL
Index: linux-2.6/drivers/pci/pcie/Makefile
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/Makefile
+++ linux-2.6/drivers/pci/pcie/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_PCIEPORTBUS)	+= pcieportdrv
 
 # Build PCI Express AER if needed
 obj-$(CONFIG_PCIEAER)		+= aer/
+
+obj-$(CONFIG_PCIE_PME) += pme/
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/pci/pcie/pme/pcie_pme.c
@@ -0,0 +1,491 @@
+/*
+ * PCIe Native PME support
+ *
+ * Copyright (C) 2007 - 2009 Intel Corp
+ * Copyright (C) 2007 - 2009 Shaohua Li <shaohua.li@intel.com>
+ * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License V2.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/pcieport_if.h>
+#include <linux/acpi.h>
+#include <linux/pci-acpi.h>
+#include <linux/pm_runtime.h>
+
+#include "../../pci.h"
+#include "pcie_pme.h"
+
+#define PCI_EXP_RTSTA_PME	0x10000 /* PME status */
+#define PCI_EXP_RTSTA_PENDING	0x20000 /* PME pending */
+
+/*
+ * If set, this switch will prevent the PCIe root port PME service driver from
+ * being registered.  Consequently, the interrupt-based PCIe PME signaling will
+ * not be used by any PCIe root ports in that case.
+ */
+static bool pcie_pme_disabled;
+
+/*
+ * The PCI Express Base Specification 2.0, Section 6.1.8, states the following:
+ * "In order to maintain compatibility with non-PCI Express-aware system
+ * software, system power management logic must be configured by firmware to use
+ * the legacy mechanism of signaling PME by default.  PCI Express-aware system
+ * software must notify the firmware prior to enabling native, interrupt-based
+ * PME signaling."  However, if the platform doesn't provide us with a suitable
+ * notification mechanism or the notification fails, it is not clear whether or
+ * not we are supposed to use the interrupt-based PCIe PME signaling.  The
+ * switch below can be used to indicate the desired behaviour.  When set, it
+ * will make the kernel use the interrupt-based PCIe PME signaling regardless of
+ * the platform notification status, although the kernel will attempt to notify
+ * the platform anyway.  When unset, it will prevent the kernel from using the
+ * the interrupt-based PCIe PME signaling if the platform notification fails,
+ * which is the default.
+ */
+static bool pcie_pme_force_enable;
+
+/*
+ * This flag is set once the kernel has successfully received control of the
+ * PCIe PME registers from the platform firmware.
+ */
+static bool pcie_pme_control_received;
+
+static int __init pcie_pme_setup(char *str)
+{
+	if (!strcmp(str, "off"))
+		pcie_pme_disabled = true;
+	else if (!strcmp(str, "force"))
+		pcie_pme_force_enable = true;
+	return 1;
+}
+__setup("pcie_pme=", pcie_pme_setup);
+
+/**
+ * pcie_pme_platform_setup - Ensure that the kernel controls the PCIe PME.
+ * @srv: PCIe PME root port service to use for carrying out the check.
+ *
+ * Check if the kernel has already received control of the native PCIe PME
+ * feature from the platform firmware and if this is not the case, notify
+ * the platform that the native PCIe PME is going to be used.
+ */
+static int pcie_pme_platform_setup(struct pcie_device *srv)
+{
+	int ret;
+
+	if (pcie_pme_control_received)
+		return 0;
+
+	ret = pcie_pme_platform_notify(srv);
+	if (!ret)
+		pcie_pme_control_received = true;
+	else if (pcie_pme_force_enable)
+		ret = 0;
+
+	return ret;
+}
+
+/**
+ * pcie_pme_enabled - Check if given device can use the native PCIe PME feature.
+ * @dev: PCI device to check.
+ */
+bool pcie_pme_enabled(struct pci_dev *dev)
+{
+	return dev->is_pcie && !pcie_pme_disabled
+		&& (pcie_pme_control_received || pcie_pme_force_enable);
+}
+
+struct pcie_pme_service_data {
+	spinlock_t lock;
+	struct pcie_device *srv;
+	struct work_struct work;
+	bool noirq; /* Don't enable the PME interrupt used by this service. */
+};
+
+/**
+ * pcie_pme_interrupt_enable - Enable/disable PCIe PME interrupt generation.
+ * @dev: PCIe root port or event collector.
+ * @enable: Enable or disable the interrupt.
+ */
+static void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
+{
+	int rtctl_pos;
+	u16 rtctl;
+
+	rtctl_pos = pci_find_capability(dev, PCI_CAP_ID_EXP) + PCI_EXP_RTCTL;
+
+	pci_read_config_word(dev, rtctl_pos, &rtctl);
+	if (enable)
+		rtctl |= PCI_EXP_RTCTL_PMEIE;
+	else
+		rtctl &= ~PCI_EXP_RTCTL_PMEIE;
+	pci_write_config_word(dev, rtctl_pos, rtctl);
+}
+
+/**
+ * pcie_pme_clear_status - Clear root port PME interrupt status.
+ * @dev: PCIe root port or event collector.
+ */
+static void pcie_pme_clear_status(struct pci_dev *dev)
+{
+	int rtsta_pos;
+	u32 rtsta;
+
+	rtsta_pos = pci_find_capability(dev, PCI_CAP_ID_EXP) + PCI_EXP_RTSTA;
+
+	pci_read_config_dword(dev, rtsta_pos, &rtsta);
+	rtsta |= PCI_EXP_RTSTA_PME;
+	pci_write_config_dword(dev, rtsta_pos, rtsta);
+}
+
+/**
+ * pcie_pme_walk_bus - Scan a PCI bus for devices asserting PME#.
+ * @bus: PCI bus to scan.
+ *
+ * Scan given PCI bus and all buses under it for devices asserting PME#.
+ */
+static bool pcie_pme_walk_bus(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+	bool ret = false;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		/* Skip PCIe devices in case we started from a root port. */
+		if (!dev->is_pcie && pci_check_pme_status(dev)) {
+			pm_request_resume(&dev->dev);
+			ret = true;
+		}
+
+		if (dev->subordinate && pcie_pme_walk_bus(dev->subordinate))
+			ret = true;
+	}
+
+	return ret;
+}
+
+/**
+ * pcie_pme_from_pci_bridge - Check if PCIe-PCI bridge generated a PME.
+ * @bus: Secondary bus of the bridge.
+ * @devfn: Device/function number to check.
+ *
+ * PME from PCI devices under a PCIe-PCI bridge may be converted to an in-band
+ * PCIe PME message.  In such that case the bridge should use the Requester ID
+ * of device/function number 0 on its secondary bus.
+ */
+static bool pcie_pme_from_pci_bridge(struct pci_bus *bus, u8 devfn)
+{
+	struct pci_dev *dev;
+	bool found = false;
+
+	if (devfn)
+		return false;
+
+	dev = pci_dev_get(bus->self);
+	if (!dev)
+		return false;
+
+	if (dev->is_pcie && dev->pcie_type == PCI_EXP_TYPE_PCI_BRIDGE) {
+		down_read(&pci_bus_sem);
+		if (pcie_pme_walk_bus(bus))
+			found = true;
+		up_read(&pci_bus_sem);
+	}
+
+	pci_dev_put(dev);
+	return found;
+}
+
+/**
+ * pcie_pme_handle_request - Find device that generated PME and handle it.
+ * @port: Root port or event collector that generated the PME interrupt.
+ * @req_id: PCIe Requester ID of the device that generated the PME.
+ */
+static void pcie_pme_handle_request(struct pci_dev *port, u16 req_id)
+{
+	u8 busnr = req_id >> 8, devfn = req_id & 0xff;
+	struct pci_bus *bus;
+	struct pci_dev *dev;
+	bool found = false;
+
+	/* First, check if the PME is from the root port itself. */
+	if (port->devfn == devfn && port->bus->number == busnr) {
+		if (pci_check_pme_status(port)) {
+			pm_request_resume(&port->dev);
+			found = true;
+		} else {
+			/*
+			 * Apparently, the root port generated the PME on behalf
+			 * of a non-PCIe device downstream.  If this is done by
+			 * a root port, the Requester ID field in its status
+			 * register may contain either the root port's, or the
+			 * source device's information (PCI Express Base
+			 * Specification, Rev. 2.0, Section 6.1.9).
+			 */
+			down_read(&pci_bus_sem);
+			found = pcie_pme_walk_bus(port->subordinate);
+			up_read(&pci_bus_sem);
+		}
+		goto out;
+	}
+
+	/* Second, find the bus the source device is on. */
+	bus = pci_find_bus(pci_domain_nr(port->bus), busnr);
+	if (!bus)
+		goto out;
+
+	/* Next, check if the PME is from a PCIe-PCI bridge. */
+	found = pcie_pme_from_pci_bridge(bus, devfn);
+	if (found)
+		goto out;
+
+	/* Finally, try to find the PME source on the bus. */
+	down_read(&pci_bus_sem);
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		pci_dev_get(dev);
+		if (dev->devfn == devfn) {
+			found = true;
+			break;
+		}
+		pci_dev_put(dev);
+	}
+	up_read(&pci_bus_sem);
+
+	if (found) {
+		/* The device is there, but we have to check its PME status. */
+		found = pci_check_pme_status(dev);
+		if (found)
+			pm_request_resume(&dev->dev);
+		pci_dev_put(dev);
+	} else if (devfn) {
+		/*
+		 * The device is not there, but we can still try to recover by
+		 * assuming that the PME was reported by a PCIe-PCI bridge that
+		 * used devfn different from zero.
+		 */
+		dev_dbg(&port->dev, "PME interrupt generated for "
+			"non-existent device %02x:%02x.%d\n",
+			busnr, PCI_SLOT(devfn), PCI_FUNC(devfn));
+		found = pcie_pme_from_pci_bridge(bus, 0);
+	}
+
+ out:
+	if (!found)
+		dev_dbg(&port->dev, "Spurious native PME interrupt!\n");
+}
+
+/**
+ * pcie_pme_work_fn - Work handler for PCIe PME interrupt.
+ * @work: Work structure giving access to service data.
+ */
+static void pcie_pme_work_fn(struct work_struct *work)
+{
+	struct pcie_pme_service_data *data =
+			container_of(work, struct pcie_pme_service_data, work);
+	struct pci_dev *port = data->srv->port;
+	int rtsta_pos;
+	u32 rtsta;
+
+	rtsta_pos = pci_find_capability(port, PCI_CAP_ID_EXP) + PCI_EXP_RTSTA;
+
+	spin_lock_irq(&data->lock);
+
+	for (;;) {
+		if (data->noirq)
+			break;
+
+		pci_read_config_dword(port, rtsta_pos, &rtsta);
+		if (rtsta & PCI_EXP_RTSTA_PME) {
+			/*
+			 * Clear PME status of the port.  If there are other
+			 * pending PMEs, the status will be set again.
+			 */
+			pcie_pme_clear_status(port);
+
+			spin_unlock_irq(&data->lock);
+			pcie_pme_handle_request(port, rtsta & 0xffff);
+			spin_lock_irq(&data->lock);
+
+			continue;
+		}
+
+		/* No need to loop if there are no more PMEs pending. */
+		if (!(rtsta & PCI_EXP_RTSTA_PENDING))
+			break;
+
+		spin_unlock_irq(&data->lock);
+		cpu_relax();
+		spin_lock_irq(&data->lock);
+	}
+
+	if (!data->noirq)
+		pcie_pme_interrupt_enable(port, true);
+
+	spin_unlock_irq(&data->lock);
+}
+
+/**
+ * pcie_pme_irq - Interrupt handler for PCIe root port PME interrupt.
+ * @irq: Interrupt vector.
+ * @context: Interrupt context pointer.
+ */
+static irqreturn_t pcie_pme_irq(int irq, void *context)
+{
+	struct pci_dev *port;
+	struct pcie_pme_service_data *data;
+	int rtsta_pos;
+	u32 rtsta;
+	unsigned long flags;
+
+	port = ((struct pcie_device *)context)->port;
+	data = get_service_data((struct pcie_device *)context);
+
+	rtsta_pos = pci_find_capability(port, PCI_CAP_ID_EXP) + PCI_EXP_RTSTA;
+
+	spin_lock_irqsave(&data->lock, flags);
+	pci_read_config_dword(port, rtsta_pos, &rtsta);
+
+	if (!(rtsta & PCI_EXP_RTSTA_PME)) {
+		spin_unlock_irqrestore(&data->lock, flags);
+		return IRQ_NONE;
+	}
+
+	pcie_pme_interrupt_enable(port, false);
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	queue_work(pm_wq, &data->work);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * pcie_pme_probe - Initialize PCIe PME service for given root port.
+ * @srv - PCIe service to initialize.
+ */
+static int pcie_pme_probe(struct pcie_device *srv)
+{
+	struct pci_dev *port;
+	struct pcie_pme_service_data *data;
+	int ret;
+
+	ret = pcie_pme_platform_setup(srv);
+	if (ret)
+		return ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	spin_lock_init(&data->lock);
+	INIT_WORK(&data->work, pcie_pme_work_fn);
+	data->srv = srv;
+	set_service_data(srv, data);
+
+	port = srv->port;
+	pcie_pme_interrupt_enable(port, false);
+	pcie_pme_clear_status(port);
+
+	ret = request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED, "PCIe PME", srv);
+	if (ret)
+		kfree(data);
+	else
+		pcie_pme_interrupt_enable(port, true);
+
+	return ret;
+}
+
+/**
+ * pcie_pme_remove - Prepare PCIe PME service device for removal.
+ * @srv - PCIe service device to be removed.
+ */
+static void pcie_pme_remove(struct pcie_device *srv)
+{
+	struct pcie_pme_service_data *data = get_service_data(srv);
+	struct pci_dev *port = srv->port;
+
+	spin_lock_irq(&data->lock);
+	pcie_pme_interrupt_enable(port, false);
+	pcie_pme_clear_status(port);
+	data->noirq = true;
+	spin_unlock_irq(&data->lock);
+
+	flush_work(&data->work);
+	free_irq(srv->irq, srv);
+
+	set_service_data(srv, NULL);
+	kfree(data);
+}
+
+/**
+ * pcie_pme_suspend - Suspend PCIe PME service device.
+ * @srv - PCIe service device to suspend.
+ */
+static int pcie_pme_suspend(struct pcie_device *srv)
+{
+	struct pcie_pme_service_data *data = get_service_data(srv);
+	struct pci_dev *port = srv->port;
+
+	spin_lock_irq(&data->lock);
+	pcie_pme_interrupt_enable(port, false);
+	pcie_pme_clear_status(port);
+	data->noirq = true;
+	spin_unlock_irq(&data->lock);
+
+	return 0;
+}
+
+/**
+ * pcie_pme_resume - Resume PCIe PME service device.
+ * @srv - PCIe service device to resume.
+ */
+static int pcie_pme_resume(struct pcie_device *srv)
+{
+	struct pcie_pme_service_data *data = get_service_data(srv);
+	struct pci_dev *port = srv->port;
+
+	spin_lock_irq(&data->lock);
+	data->noirq = false;
+	pcie_pme_clear_status(port);
+	pcie_pme_interrupt_enable(port, true);
+	spin_unlock_irq(&data->lock);
+
+	return 0;
+}
+
+static struct pcie_port_service_driver pcie_pme_driver = {
+	.name		= "pcie_pme",
+	.port_type 	= PCIE_RC_PORT,
+	.service 	= PCIE_PORT_SERVICE_PME,
+
+	.probe		= pcie_pme_probe,
+	.remove		= pcie_pme_remove,
+	.suspend	= pcie_pme_suspend,
+	.resume		= pcie_pme_resume,
+};
+
+/**
+ * pcie_pme_service_init - Register the PCIe PME service driver.
+ */
+static int __init pcie_pme_service_init(void)
+{
+	return pcie_pme_disabled ?
+		-ENODEV : pcie_port_service_register(&pcie_pme_driver);
+}
+
+/**
+ * pcie_pme_service_exit - Unregister the PCIe PME service driver.
+ */
+static void __exit pcie_pme_service_exit(void)
+{
+	pcie_port_service_unregister(&pcie_pme_driver);
+}
+
+module_init(pcie_pme_service_init);
+module_exit(pcie_pme_service_exit);
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme_acpi.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/pci/pcie/pme/pcie_pme_acpi.c
@@ -0,0 +1,54 @@
+/*
+ * PCIe Native PME support, ACPI-related part
+ *
+ * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License V2.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/pci-acpi.h>
+#include <linux/pcieport_if.h>
+
+/**
+ * pcie_pme_acpi_setup - Request the ACPI BIOS to release control over PCIe PME.
+ * @srv - PCIe PME service for a root port or event collector.
+ *
+ * Invoked when the PCIe bus type loads PCIe PME service driver.  To avoid
+ * conflict with the BIOS PCIe support requires the BIOS to yield PCIe PME
+ * control to the kernel.
+ */
+int pcie_pme_acpi_setup(struct pcie_device *srv)
+{
+	acpi_status status = AE_NOT_FOUND;
+	struct pci_dev *port = srv->port;
+	acpi_handle handle;
+	int error = 0;
+
+	if (acpi_pci_disabled)
+		return -ENOSYS;
+
+	dev_info(&port->dev, "Requesting control of PCIe PME from ACPI BIOS\n");
+
+	handle = acpi_find_root_bridge_handle(port);
+	if (!handle)
+		return -EINVAL;
+
+	status = acpi_pci_osc_control_set(handle,
+			OSC_PCI_EXPRESS_PME_CONTROL |
+			OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+	if (ACPI_FAILURE(status)) {
+		dev_info(&port->dev,
+			"Failed to receive control of PCIe PME service: %s\n",
+			(status == AE_SUPPORT || status == AE_NOT_FOUND) ?
+			"no _OSC support" : "ACPI _OSC failed");
+		error = -ENODEV;
+	}
+
+	return error;
+}
Index: linux-2.6/drivers/pci/pcie/pme/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/drivers/pci/pcie/pme/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for PCI-Express Root Port PME signaling driver
+#
+
+obj-$(CONFIG_PCIE_PME) += pmedriver.o
+
+pmedriver-objs := pcie_pme.o
+pmedriver-$(CONFIG_ACPI) += pcie_pme_acpi.o
Index: linux-2.6/drivers/pci/pcie/pme/pcie_pme.h
===================================================================
--- /dev/null
+++ linux-2.6/drivers/pci/pcie/pme/pcie_pme.h
@@ -0,0 +1,28 @@
+/*
+ * drivers/pci/pcie/pme/pcie_pme.h
+ *
+ * PCI Express Root Port PME signaling support
+ *
+ * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ */
+
+#ifndef _PCIE_PME_H_
+#define _PCIE_PME_H_
+
+struct pcie_device;
+
+#ifdef CONFIG_ACPI
+extern int pcie_pme_acpi_setup(struct pcie_device *srv);
+
+static inline int pcie_pme_platform_notify(struct pcie_device *srv)
+{
+	return pcie_pme_acpi_setup(srv);
+}
+#else /* !CONFIG_ACPI */
+static inline int pcie_pme_platform_notify(struct pcie_device *srv)
+{
+	return 0;
+}
+#endif /* !CONFIG_ACPI */
+
+#endif
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -911,6 +911,12 @@ extern void pcie_set_ecrc_checking(struc
 extern void pcie_ecrc_get_policy(char *str);
 #endif
 
+#ifndef CONFIG_PCIE_PME
+static inline bool pcie_pme_enabled(struct pci_dev *dev) { return false; }
+#else
+extern bool pcie_pme_enabled(struct pci_dev *dev);
+#endif
+
 #define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
 
 #ifdef CONFIG_HT_IRQ
Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -116,7 +116,7 @@ static void acpi_pci_propagate_wakeup_en
 		int ret;
 
 		ret = acpi_pm_device_sleep_wake(&bridge->dev, enable);
-		if (!ret || bridge->is_pcie)
+		if (!ret || pcie_pme_enabled(bridge))
 			return;
 		bus = bus->parent;
 	}
@@ -131,7 +131,7 @@ static int acpi_pci_sleep_wake(struct pc
 	if (acpi_pci_can_wakeup(dev))
 		return acpi_pm_device_sleep_wake(&dev->dev, enable);
 
-	if (!dev->is_pcie)
+	if (!pcie_pme_enabled(dev))
 		acpi_pci_propagate_wakeup_enable(dev->bus, enable);
 
 	return 0;
