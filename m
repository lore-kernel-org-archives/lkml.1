Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193Ab0AAQlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0AAQlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 11:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232Ab0AAQlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 11:41:42 -0500
Received: from isilmar.linta.de ([213.133.102.198]:54572 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031Ab0AAQlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 11:41:18 -0500
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-arch@vger.kernel.org>, <torvalds@linux-foundation.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] resource: align functions now return start of resource
Date: Fri,  1 Jan 2010 17:40:49 +0100
Message-Id: <1262364050-8540-1-git-send-email-linux@dominikbrodowski.net>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100101163811.GA8124@comet.dominikbrodowski.net>
References: <20100101163811.GA8124@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Linus, align functions should return the start
of a resource, not void. An update of "res->start" is no longer
necessary.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 arch/alpha/kernel/pci.c                 |    4 ++--
 arch/arm/kernel/bios32.c                |    8 +++++---
 arch/cris/arch-v32/drivers/pci/bios.c   |   14 ++++++--------
 arch/frv/mb93090-mb00/pci-frv.c         |   14 ++++++--------
 arch/ia64/pci/pci.c                     |    3 ++-
 arch/mips/pci/pci.c                     |    4 ++--
 arch/mips/pmc-sierra/yosemite/ht.c      |   10 +++++-----
 arch/mn10300/unit-asb2305/pci-asb2305.c |   16 +++++++---------
 arch/parisc/kernel/pci.c                |   10 +++++-----
 arch/powerpc/kernel/pci-common.c        |   13 ++++++-------
 arch/sh/drivers/pci/pci.c               |    6 +++---
 arch/sparc/kernel/pci.c                 |    5 +++--
 arch/sparc/kernel/pcic.c                |    5 +++--
 arch/x86/pci/i386.c                     |   12 +++++-------
 arch/xtensa/kernel/pci.c                |   11 +++++------
 drivers/pci/bus.c                       |    6 ++++--
 drivers/pcmcia/rsrc_mgr.c               |   12 ++++++------
 drivers/pcmcia/rsrc_nonstatic.c         |   16 +++++++++-------
 include/linux/ioport.h                  |    6 ++++--
 include/linux/pci.h                     |    8 +++++---
 kernel/resource.c                       |   14 +++++++++-----
 21 files changed, 102 insertions(+), 95 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index a91ba28..5cf111e 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -126,7 +126,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pcibios_fixup_final);
 #define MB			(1024*KB)
 #define GB			(1024*MB)
 
-void
+resource_size_t
 pcibios_align_resource(void *data, struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
@@ -184,7 +184,7 @@ pcibios_align_resource(void *data, struct resource *res,
 		}
 	}
 
-	res->start = start;
+	return start;
 }
 #undef KB
 #undef MB
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 8096819..a7c85f8 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -616,15 +616,17 @@ char * __init pcibios_setup(char *str)
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might be mirrored at 0x0100-0x03ff..
  */
-void pcibios_align_resource(void *data, struct resource *res,
-			    resource_size_t size, resource_size_t align)
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
+				resource_size_t size, resource_size_t align)
 {
 	resource_size_t start = res->start;
 
 	if (res->flags & IORESOURCE_IO && start & 0x300)
 		start = (start + 0x3ff) & ~0x3ff;
 
-	res->start = (start + align - 1) & ~(align - 1);
+	start = (start + align - 1) & ~(align - 1);
+
+	return start;
 }
 
 /**
diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index 77ee319..5811e2f 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -41,18 +41,16 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 	return 0;
 }
 
-void
+resource_size_t
 pcibios_align_resource(void *data, struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
-	if (res->flags & IORESOURCE_IO) {
-		resource_size_t start = res->start;
+	resource_size_t start = res->start;
 
-		if (start & 0x300) {
-			start = (start + 0x3ff) & ~0x3ff;
-			res->start = start;
-		}
-	}
+	if ((res->flags & IORESOURCE_IO) && (start & 0x300))
+		start = (start + 0x3ff) & ~0x3ff;
+
+	return start
 }
 
 int pcibios_enable_resources(struct pci_dev *dev, int mask)
diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index 566bdeb..c947aa4 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -32,18 +32,16 @@
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-void
+resource_size_t
 pcibios_align_resource(void *data, struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
-	if (res->flags & IORESOURCE_IO) {
-		resource_size_t start = res->start;
+	resource_size_t start = res->start;
 
-		if (start & 0x300) {
-			start = (start + 0x3ff) & ~0x3ff;
-			res->start = start;
-		}
-	}
+	if ((res->flags & IORESOURCE_IO) && (start & 0x300))
+		start = (start + 0x3ff) & ~0x3ff;
+
+	return start
 }
 
 
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index df639db..ef574cd 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -547,10 +547,11 @@ pcibios_disable_device (struct pci_dev *dev)
 		acpi_pci_irq_disable(dev);
 }
 
-void
+resource_size_t
 pcibios_align_resource (void *data, struct resource *res,
 		        resource_size_t size, resource_size_t align)
 {
+	return res->start;
 }
 
 /*
diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 9a11c22..9085988 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -49,7 +49,7 @@ static int pci_initialized;
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-void
+resource_size_t
 pcibios_align_resource(void *data, struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
@@ -73,7 +73,7 @@ pcibios_align_resource(void *data, struct resource *res,
 			start = PCIBIOS_MIN_MEM + hose->mem_resource->start;
 	}
 
-	res->start = start;
+	return start;
 }
 
 static void __devinit pcibios_scanbus(struct pci_controller *hose)
diff --git a/arch/mips/pmc-sierra/yosemite/ht.c b/arch/mips/pmc-sierra/yosemite/ht.c
index 678388f..5e41008 100644
--- a/arch/mips/pmc-sierra/yosemite/ht.c
+++ b/arch/mips/pmc-sierra/yosemite/ht.c
@@ -345,14 +345,13 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
         return pcibios_enable_resources(dev);
 }
 
-void pcibios_align_resource(void *data, struct resource *res,
-                            resource_size_t size, resource_size_t align)
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
+				resource_size_t size, resource_size_t align)
 {
         struct pci_dev *dev = data;
+	resource_size_t start = res->start;
 
         if (res->flags & IORESOURCE_IO) {
-                resource_size_t start = res->start;
-
                 /* We need to avoid collisions with `mirrored' VGA ports
                    and other strange ISA hardware, so we always want the
                    addresses kilobyte aligned.  */
@@ -363,8 +362,9 @@ void pcibios_align_resource(void *data, struct resource *res,
                 }
 
                 start = (start + 1024 - 1) & ~(1024 - 1);
-                res->start = start;
         }
+
+	return start;
 }
 
 struct pci_ops titan_pci_ops = {
diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index d100ca7..60f24a7 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -31,9 +31,11 @@
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-void pcibios_align_resource(void *data, struct resource *res,
-			    resource_size_t size, resource_size_t align)
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
+				resource_size_t size, resource_size_t align)
 {
+	resource_size_t start = res->start;
+
 #if 0
 	struct pci_dev *dev = data;
 
@@ -47,14 +49,10 @@ void pcibios_align_resource(void *data, struct resource *res,
 	       );
 #endif
 
-	if (res->flags & IORESOURCE_IO) {
-		unsigned long start = res->start;
+	if ((res->flags & IORESOURCE_IO) && (start & 0x300))
+		start = (start + 0x3ff) & ~0x3ff;
 
-		if (start & 0x300) {
-			start = (start + 0x3ff) & ~0x3ff;
-			res->start = start;
-		}
-	}
+	return start;
 }
 
 
diff --git a/arch/parisc/kernel/pci.c b/arch/parisc/kernel/pci.c
index f7064ab..4463a31 100644
--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -254,10 +254,10 @@ EXPORT_SYMBOL(pcibios_bus_to_resource);
  * Since we are just checking candidates, don't use any fields other
  * than res->start.
  */
-void pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
 				resource_size_t size, resource_size_t alignment)
 {
-	resource_size_t mask, align;
+	resource_size_t mask, align, start = res->start;
 
 	DBG_RES("pcibios_align_resource(%s, (%p) [%lx,%lx]/%x, 0x%lx, 0x%lx)\n",
 		pci_name(((struct pci_dev *) data)),
@@ -269,10 +269,10 @@ void pcibios_align_resource(void *data, struct resource *res,
 
 	/* Align to largest of MIN or input size */
 	mask = max(alignment, align) - 1;
-	res->start += mask;
-	res->start &= ~mask;
+	start += mask;
+	start &= ~mask;
 
-	/* The caller updates the end field, we don't.  */
+	return start;
 }
 
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index e8dfdbd..3e343b8 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1168,21 +1168,20 @@ static int skip_isa_ioresource_align(struct pci_dev *dev)
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-void pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
+	resource_size_t start = res->start;
 
 	if (res->flags & IORESOURCE_IO) {
-		resource_size_t start = res->start;
-
 		if (skip_isa_ioresource_align(dev))
-			return;
-		if (start & 0x300) {
+			return start;
+		if (start & 0x300)
 			start = (start + 0x3ff) & ~0x3ff;
-			res->start = start;
-		}
 	}
+
+	return start;
 }
 EXPORT_SYMBOL(pcibios_align_resource);
 
diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index c481df6..b36ca82 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -148,8 +148,8 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
  * addresses to be allocated in the 0x000-0x0ff region
  * modulo 0x400.
  */
-void pcibios_align_resource(void *data, struct resource *res,
-			    resource_size_t size, resource_size_t align)
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
+				resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
 	struct pci_channel *chan = dev->sysdata;
@@ -171,7 +171,7 @@ void pcibios_align_resource(void *data, struct resource *res,
 			start = PCIBIOS_MIN_MEM + chan->mem_resource->start;
 	}
 
-	res->start = start;
+	return start;
 }
 
 void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 539e83f..6381ceb 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -715,9 +715,10 @@ void pcibios_update_irq(struct pci_dev *pdev, int irq)
 {
 }
 
-void pcibios_align_resource(void *data, struct resource *res,
-			    resource_size_t size, resource_size_t align)
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
+				resource_size_t size, resource_size_t align)
 {
+	return res->start;
 }
 
 int pcibios_enable_device(struct pci_dev *dev, int mask)
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 85e7037..96fe494 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -839,9 +839,10 @@ char * __devinit pcibios_setup(char *str)
 	return str;
 }
 
-void pcibios_align_resource(void *data, struct resource *res,
-			    resource_size_t size, resource_size_t align)
+resource_size_t pcibios_align_resource(void *data, struct resource *res,
+				resource_size_t size, resource_size_t align)
 {
+	return res->start;
 }
 
 int pcibios_enable_device(struct pci_dev *pdev, int mask)
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5dc9e8c..924e40c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -60,22 +60,20 @@ skip_isa_ioresource_align(struct pci_dev *dev) {
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-void
+resource_size_t
 pcibios_align_resource(void *data, struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
+	resource_size_t start = res->start;
 
 	if (res->flags & IORESOURCE_IO) {
-		resource_size_t start = res->start;
-
 		if (skip_isa_ioresource_align(dev))
-			return;
-		if (start & 0x300) {
+			return start;
+		if (start & 0x300)
 			start = (start + 0x3ff) & ~0x3ff;
-			res->start = start;
-		}
 	}
+	return start;
 }
 EXPORT_SYMBOL(pcibios_align_resource);
 
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index b7c0734..d7efab0 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -69,26 +69,25 @@ static int pci_bus_count;
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-void
+resource_size_t
 pcibios_align_resource(void *data, struct resource *res, resource_size_t size,
     		       resource_size_t align)
 {
 	struct pci_dev *dev = data;
+	resource_size_t start = res->start;
 
 	if (res->flags & IORESOURCE_IO) {
-		resource_size_t start = res->start;
-
 		if (size > 0x100) {
 			printk(KERN_ERR "PCI: I/O Region %s/%d too large"
 			       " (%ld bytes)\n", pci_name(dev),
 			       dev->resource - res, size);
 		}
 
-		if (start & 0x300) {
+		if (start & 0x300)
 			start = (start + 0x3ff) & ~0x3ff;
-			res->start = start;
-		}
 	}
+
+	return start;
 }
 
 int
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index cef28a7..d29d69a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -36,8 +36,10 @@ int
 pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		resource_size_t size, resource_size_t align,
 		resource_size_t min, unsigned int type_mask,
-		void (*alignf)(void *, struct resource *, resource_size_t,
-				resource_size_t),
+		resource_size_t (*alignf)(void *,
+					  struct resource *,
+					  resource_size_t,
+					  resource_size_t),
 		void *alignf_data)
 {
 	int i, ret = -ENOMEM;
diff --git a/drivers/pcmcia/rsrc_mgr.c b/drivers/pcmcia/rsrc_mgr.c
index 52db172..f92a2da 100644
--- a/drivers/pcmcia/rsrc_mgr.c
+++ b/drivers/pcmcia/rsrc_mgr.c
@@ -114,22 +114,20 @@ struct pcmcia_align_data {
 	unsigned long	offset;
 };
 
-static void pcmcia_align(void *align_data, struct resource *res,
-			unsigned long size, unsigned long align)
+static resource_size_t pcmcia_align(void *align_data, struct resource *res,
+				resource_size_t size, resource_size_t align)
 {
 	struct pcmcia_align_data *data = align_data;
-	unsigned long start;
+	resource_size_t start;
 
 	start = (res->start & ~data->mask) + data->offset;
 	if (start < res->start)
 		start += data->mask + 1;
-	res->start = start;
 
 #ifdef CONFIG_X86
 	if (res->flags & IORESOURCE_IO) {
 		if (start & 0x300) {
 			start = (start + 0x3ff) & ~0x3ff;
-			res->start = start;
 		}
 	}
 #endif
@@ -137,9 +135,11 @@ static void pcmcia_align(void *align_data, struct resource *res,
 #ifdef CONFIG_M68K
 	if (res->flags & IORESOURCE_IO) {
 		if ((res->start + size - 1) >= 1024)
-			res->start = res->end;
+			start = res->end;
 	}
 #endif
+
+	return start;
 }
 
 
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 9b0dc43..b659028 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -533,7 +533,7 @@ struct pcmcia_align_data {
 	struct resource_map	*map;
 };
 
-static void
+static resource_size_t
 pcmcia_common_align(void *align_data, struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
@@ -545,17 +545,18 @@ pcmcia_common_align(void *align_data, struct resource *res,
 	start = (res->start & ~data->mask) + data->offset;
 	if (start < res->start)
 		start += data->mask + 1;
-	res->start = start;
+	return start;
 }
 
-static void
+static resource_size_t
 pcmcia_align(void *align_data, struct resource *res, resource_size_t size,
 		resource_size_t align)
 {
 	struct pcmcia_align_data *data = align_data;
 	struct resource_map *m;
+	resource_size_t start;
 
-	pcmcia_common_align(data, res, size, align);
+	start = pcmcia_common_align(data, res, size, align);
 
 	for (m = data->map->next; m != data->map; m = m->next) {
 		unsigned long start = m->base;
@@ -567,8 +568,7 @@ pcmcia_align(void *align_data, struct resource *res, resource_size_t size,
 		 * fit here.
 		 */
 		if (res->start < start) {
-			res->start = start;
-			pcmcia_common_align(data, res, size, align);
+			start = pcmcia_common_align(data, res, size, align);
 		}
 
 		/*
@@ -586,7 +586,9 @@ pcmcia_align(void *align_data, struct resource *res, resource_size_t size,
 	 * If we failed to find something suitable, ensure we fail.
 	 */
 	if (m == data->map)
-		res->start = res->end;
+		start = res->end;
+
+	return start;
 }
 
 /*
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 7129504..f4195de 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -120,8 +120,10 @@ extern void insert_resource_expand_to_fit(struct resource *root, struct resource
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
 			     resource_size_t max, resource_size_t align,
-			     void (*alignf)(void *, struct resource *,
-					    resource_size_t, resource_size_t),
+			     resource_size_t (*alignf)(void *,
+						       struct resource *,
+						       resource_size_t,
+						       resource_size_t),
 			     void *alignf_data);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index bf1e670..30a6e9b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -562,7 +562,8 @@ int __must_check pcibios_enable_device(struct pci_dev *, int mask);
 char *pcibios_setup(char *str);
 
 /* Used only when drivers/pci/setup.c is used */
-void pcibios_align_resource(void *, struct resource *, resource_size_t,
+resource_size_t pcibios_align_resource(void *, struct resource *,
+				resource_size_t,
 				resource_size_t);
 void pcibios_update_irq(struct pci_dev *, int irq);
 
@@ -789,8 +790,9 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 			struct resource *res, resource_size_t size,
 			resource_size_t align, resource_size_t min,
 			unsigned int type_mask,
-			void (*alignf)(void *, struct resource *,
-				resource_size_t, resource_size_t),
+			resource_size_t (*alignf)(void *, struct resource *,
+						  resource_size_t,
+						  resource_size_t),
 			void *alignf_data);
 void pci_enable_bridges(struct pci_bus *bus);
 
diff --git a/kernel/resource.c b/kernel/resource.c
index af96c1e..e697f20 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -303,8 +303,10 @@ int walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 static int find_resource(struct resource *root, struct resource *new,
 			 resource_size_t size, resource_size_t min,
 			 resource_size_t max, resource_size_t align,
-			 void (*alignf)(void *, struct resource *,
-					resource_size_t, resource_size_t),
+			 resource_size_t (*alignf)(void *,
+						   struct resource *,
+						   resource_size_t,
+						   resource_size_t),
 			 void *alignf_data)
 {
 	struct resource *this = root->child;
@@ -330,7 +332,7 @@ static int find_resource(struct resource *root, struct resource *new,
 			tmp.end = max;
 		tmp.start = ALIGN(tmp.start, align);
 		if (alignf)
-			alignf(alignf_data, &tmp, size, align);
+			tmp.start = alignf(alignf_data, &tmp, size, align);
 		if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
 			new->start = tmp.start;
 			new->end = tmp.start + size - 1;
@@ -358,8 +360,10 @@ static int find_resource(struct resource *root, struct resource *new,
 int allocate_resource(struct resource *root, struct resource *new,
 		      resource_size_t size, resource_size_t min,
 		      resource_size_t max, resource_size_t align,
-		      void (*alignf)(void *, struct resource *,
-				     resource_size_t, resource_size_t),
+		      resource_size_t (*alignf)(void *,
+						struct resource *,
+						resource_size_t,
+						resource_size_t),
 		      void *alignf_data)
 {
 	int err;
-- 
1.6.3.3

