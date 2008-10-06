Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYJFBCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYJFBCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 21:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYJFBB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 21:01:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:34802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYJFBB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 21:01:57 -0400
Date: Sun, 5 Oct 2008 18:01:54 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Subject: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081005180154.7cc12486@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 5 Oct 2008 18:00:15 -0700
Subject: [PATCH] resource: don't allow /dev/mem access reserved resources

Device drivers that use pci_request_regions() (and similar APIs) have a
reasonable expectation that they are the only ones accessing their device.
As part of the e1000e hunt, we were afraid that some userland (X or some
bootsplash stuff) was mapping the MMIO region, that the driver thought it
had exclusively, via /dev/mem.

This patch adds, to the existing config option to restrict /dev/mem, the
reserved regions to the "banned from /dev/mem use" list, so now
both kernel memory and device-exclusive MMIO regions are banned.

The introduced iomem_is_reserved() function is also planned to be used
for other patches in 2.6.28 (pci_ioremap) so is exported here as part
of being introduced.

Signed-of-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/mm/init_32.c  |    2 ++
 arch/x86/mm/init_64.c  |    2 ++
 include/linux/ioport.h |    1 +
 kernel/resource.c      |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 63b71d3..c98f5e8 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -329,6 +329,8 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_reserved(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 747f6c9..0c7037c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -892,6 +892,8 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	if (pagenr <= 256)
 		return 1;
+	if (iomem_is_reserved(pagenr << PAGE_SHIFT))
+		return 0;
 	if (!page_is_ram(pagenr))
 		return 1;
 	return 0;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index e38b6aa..eee0f61 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -170,6 +170,7 @@ extern struct resource * __devm_request_region(struct device *dev,
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
 extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
+extern int iomem_is_reserved(u64 addr);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 7797dae..e217083 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -864,3 +864,35 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 
 	return err;
 }
+
+/*
+ * check if an address is reserved in the iomem resource tree
+ * returns 1 if reserved, 0 if not reserved.
+ */
+int iomem_is_reserved(u64 addr)
+{
+	struct resource *p = &iomem_resource;
+	int err = 0;
+	loff_t l;
+	int size= PAGE_SIZE;
+
+	read_lock(&resource_lock);
+	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+		/*
+		 * We can probably skip the resources without
+		 * IORESOURCE_IO attribute?
+		 */
+		if (p->start >= addr + size)
+			continue;
+		if (p->end < addr)
+			continue;
+		if (p->flags & IORESOURCE_BUSY) {
+			err = 1;
+			break;
+		}
+	}
+	read_unlock(&resource_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(iomem_is_reserved);
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
