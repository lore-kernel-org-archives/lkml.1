Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZBJTQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZBJTQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZBJTEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:07 -0500
Received: from kroah.org ([198.145.64.141]:54029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755875AbZBJTEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:04 -0500
Date: Tue, 10 Feb 2009 11:00:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Timothy S. Nelson" <wayland@wayland.id.au>,
       Alex Villacis-Lasso <a_villacis@palosanto.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 36/53] PCI: return error on failure to read PCI ROMs
Message-ID: <20090210190059.GK14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-return-error-on-failure-to-read-pci-roms.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Timothy S. Nelson <wayland@wayland.id.au>

commit 97c44836cdec1ea713a15d84098a1a908157e68f upstream.

This patch makes the ROM reading code return an error to user space if
the size of the ROM read is equal to 0.

The patch also emits a warnings if the contents of the ROM are invalid,
and documents the effects of the "enable" file on ROM reading.

Signed-off-by: Timothy S. Nelson <wayland@wayland.id.au>
Acked-by: Alex Villacis-Lasso <a_villacis@palosanto.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/filesystems/sysfs-pci.txt |   13 ++++++++++++-
 arch/ia64/sn/kernel/io_acpi_init.c      |    2 +-
 arch/ia64/sn/kernel/io_init.c           |    2 +-
 drivers/pci/pci-sysfs.c                 |    4 ++--
 drivers/pci/rom.c                       |    8 +++++---
 include/linux/pci.h                     |    2 +-
 6 files changed, 22 insertions(+), 9 deletions(-)

--- a/arch/ia64/sn/kernel/io_acpi_init.c
+++ b/arch/ia64/sn/kernel/io_acpi_init.c
@@ -434,7 +434,7 @@ sn_acpi_slot_fixup(struct pci_dev *dev)
 		size = pci_resource_len(dev, PCI_ROM_RESOURCE);
 		addr = ioremap(pcidev_info->pdi_pio_mapped_addr[PCI_ROM_RESOURCE],
 			       size);
-		image_size = pci_get_rom_size(addr, size);
+		image_size = pci_get_rom_size(dev, addr, size);
 		dev->resource[PCI_ROM_RESOURCE].start = (unsigned long) addr;
 		dev->resource[PCI_ROM_RESOURCE].end =
 					(unsigned long) addr + image_size - 1;
--- a/arch/ia64/sn/kernel/io_init.c
+++ b/arch/ia64/sn/kernel/io_init.c
@@ -269,7 +269,7 @@ sn_io_slot_fixup(struct pci_dev *dev)
 
 			rom = ioremap(pci_resource_start(dev, PCI_ROM_RESOURCE),
 				      size + 1);
-			image_size = pci_get_rom_size(rom, size + 1);
+			image_size = pci_get_rom_size(dev, rom, size + 1);
 			dev->resource[PCI_ROM_RESOURCE].end =
 				dev->resource[PCI_ROM_RESOURCE].start +
 				image_size - 1;
--- a/Documentation/filesystems/sysfs-pci.txt
+++ b/Documentation/filesystems/sysfs-pci.txt
@@ -9,6 +9,7 @@ that support it.  For example, a given b
      |   |-- class
      |   |-- config
      |   |-- device
+     |   |-- enable
      |   |-- irq
      |   |-- local_cpus
      |   |-- resource
@@ -32,6 +33,7 @@ files, each with their own function.
        class		   PCI class (ascii, ro)
        config		   PCI config space (binary, rw)
        device		   PCI device (ascii, ro)
+       enable	           Whether the device is enabled (ascii, rw)
        irq		   IRQ number (ascii, ro)
        local_cpus	   nearby CPU mask (cpumask, ro)
        resource		   PCI resource host addresses (ascii, ro)
@@ -57,10 +59,19 @@ used to do actual device programming fro
 don't support mmapping of certain resources, so be sure to check the return
 value from any attempted mmap.
 
+The 'enable' file provides a counter that indicates how many times the device
+has been enabled.  If the 'enable' file currently returns '4', and a '1' is
+echoed into it, it will then return '5'.  Echoing a '0' into it will decrease
+the count.  Even when it returns to 0, though, some of the initialisation
+may not be reversed.
+
 The 'rom' file is special in that it provides read-only access to the device's
 ROM file, if available.  It's disabled by default, however, so applications
 should write the string "1" to the file to enable it before attempting a read
-call, and disable it following the access by writing "0" to the file.
+call, and disable it following the access by writing "0" to the file.  Note
+that the device must be enabled for a rom read to return data succesfully.
+In the event a driver is not bound to the device, it can be enabled using the
+'enable' file, documented above.
 
 Accessing legacy resources through sysfs
 ----------------------------------------
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -777,8 +777,8 @@ pci_read_rom(struct kobject *kobj, struc
 		return -EINVAL;
 	
 	rom = pci_map_rom(pdev, &size);	/* size starts out as PCI window size */
-	if (!rom)
-		return 0;
+	if (!rom || !size)
+		return -EIO;
 		
 	if (off >= size)
 		count = 0;
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -63,7 +63,7 @@ void pci_disable_rom(struct pci_dev *pde
  * The PCI window size could be much larger than the
  * actual image size.
  */
-size_t pci_get_rom_size(void __iomem *rom, size_t size)
+size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
 {
 	void __iomem *image;
 	int last_image;
@@ -72,8 +72,10 @@ size_t pci_get_rom_size(void __iomem *ro
 	do {
 		void __iomem *pds;
 		/* Standard PCI ROMs start out with these bytes 55 AA */
-		if (readb(image) != 0x55)
+		if (readb(image) != 0x55) {
+			dev_err(&pdev->dev, "Invalid ROM contents\n");
 			break;
+		}
 		if (readb(image + 1) != 0xAA)
 			break;
 		/* get the PCI data structure and check its signature */
@@ -159,7 +161,7 @@ void __iomem *pci_map_rom(struct pci_dev
 	 * size is much larger than the actual size of the ROM.
 	 * True size is important if the ROM is going to be copied.
 	 */
-	*size = pci_get_rom_size(rom, *size);
+	*size = pci_get_rom_size(pdev, rom, *size);
 	return rom;
 }
 
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -651,7 +651,7 @@ int pci_enable_rom(struct pci_dev *pdev)
 void pci_disable_rom(struct pci_dev *pdev);
 void __iomem __must_check *pci_map_rom(struct pci_dev *pdev, size_t *size);
 void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom);
-size_t pci_get_rom_size(void __iomem *rom, size_t size);
+size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size);
 
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);

