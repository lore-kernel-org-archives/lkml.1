Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZFRBEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZFRBEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZFRBD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:03:57 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:9837 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZFRBD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:03:56 -0400
Date: Wed, 17 Jun 2009 19:03:57 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Matthew Wilcox <matthew@wil.cx>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       a.beregalov@gmail.com, lenb@kernel.org
Subject: Re: linux-next: Tree for June 17 (pci/slot)
Message-ID: <20090618010357.GC29472@ldl.fc.hp.com>
References: <20090617155354.075c60ae.sfr@canb.auug.org.au> <4A39194B.2060200@oracle.com> <20090617163604.GT19977@parisc-linux.org> <20090617102901.6e39aac2@jbarnes-g45> <4A392B48.7060206@oracle.com> <20090617161001.734321be@jbarnes-g45> <20090618003808.GA29472@ldl.fc.hp.com> <20090618004612.GB29472@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618004612.GB29472@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index ba6af16..0be4efd 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -2,10 +2,11 @@
>  # Makefile for the PCI bus specific drivers.
>  #
>  
> -obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
> -			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
> +obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
> +			pci-driver.o search.o rom.o setup-res.o \
>  			irq.o
>  obj-$(CONFIG_PROC_FS) += proc.o
> +obj-$(CONFIG_SYSFS) += slot.o pci-sysfs.o

Sigh, this won't work because the PCI core blithely assumes we have
sysfs:

drivers/built-in.o: In function `pci_bus_add_device':
/kio/work/achiang/kernels/linux-2.6/drivers/pci/bus.c:89: undefined reference to `pci_create_sysfs_dev_files'
drivers/built-in.o: In function `pci_stop_dev':
/kio/work/achiang/kernels/linux-2.6/drivers/pci/remove.c:24: undefined reference to `pci_remove_sysfs_dev_files'

So, here is v3 that actually does build with !CONFIG_SYSFS. It
touches a bit more now, but I believe it is still appropriate
because neither pci_slot.ko nor any of the drivers in
drivers/pci/hotplug/ are useful without sysfs.

From: Alex Chiang <achiang@hp.com>

PCI: drivers/pci/slot.c should depend on CONFIG_SYSFS

There is no way to interact with a physical PCI slot without
sysfs, so encode the dependency and prevent this build error:

	drivers/pci/slot.c: In function 'pci_hp_create_module_link':
	drivers/pci/slot.c:327: error: 'module_kset' undeclared

This patch _should_ make pci-sysfs.o depend on CONFIG_SYSFS too,
but we cannot (yet) because the PCI core merrily assumes the
existence of sysfs:

	drivers/built-in.o: In function `pci_bus_add_device':
	drivers/pci/bus.c:89: undefined reference to `pci_create_sysfs_dev_files'
	drivers/built-in.o: In function `pci_stop_dev':
	drivers/pci/remove.c:24: undefined reference to `pci_remove_sysfs_dev_files'

So do the minimal bit for now and figure out how to untangle it
later.

Cc: Len Brown <lenb@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fix-suggested-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 431f8b4..7ec7d88 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -266,6 +266,7 @@ config ACPI_DEBUG_FUNC_TRACE
 
 config ACPI_PCI_SLOT
 	tristate "PCI slot detection driver"
+	depends on SYSFS
 	default n
 	help
 	  This driver creates entries in /sys/bus/pci/slots/ for all PCI
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index ba6af16..ed32f67 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -2,10 +2,11 @@
 # Makefile for the PCI bus specific drivers.
 #
 
-obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
+obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
 			irq.o
 obj-$(CONFIG_PROC_FS) += proc.o
+obj-$(CONFIG_SYSFS) += slot.o
 
 # Build PCI Express stuff if needed
 obj-$(CONFIG_PCIEPORTBUS) += pcie/
diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index 9aa4fe1..522c360 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig HOTPLUG_PCI
 	tristate "Support for PCI Hotplug"
-	depends on PCI && HOTPLUG
+	depends on PCI && HOTPLUG && SYSFS
 	---help---
 	  Say Y here if you have a motherboard with a PCI Hotplug controller.
 	  This allows you to add and remove PCI cards while the machine is
