Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYIZBnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYIZBnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYIZBng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:43:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:14985 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYIZBng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="443792236"
Date: Thu, 25 Sep 2008 18:43:34 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [patch] ioremap sanity check to catch mapping requests exceeding the BAR sizes
Message-ID: <20080926014334.GF15609@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[patch] ioremap sanity check to catch mapping requests exceeding the BAR sizes

Go through the iomem resource tree to check if any of the ioremap() requests
span more than any slot in the iomem resource tree and do a WARN_ON() if we hit
this check.

This will raise a red-flag, if some driver is mapping more than what
is needed. And hopefully identify possible corruptions much earlier.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 7955a5a..c0d2c3e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -169,6 +169,12 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
 	/*
+	 * Check if the request spans more than any BAR in the iomem resource
+	 * tree.
+	 */
+	WARN_ON(iomem_map_sanity_check(phys_addr, size));
+
+	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
 	for (pfn = phys_addr >> PAGE_SHIFT;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ee9bcc6..e38b6aa 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -169,6 +169,7 @@ extern struct resource * __devm_request_region(struct device *dev,
 
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
+extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
 
 #endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index fc59dcc..d582db3 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -827,3 +827,36 @@ static int __init reserve_setup(char *str)
 }
 
 __setup("reserve=", reserve_setup);
+
+/*
+ * Check if the requested addr and size spans more than any slot in the
+ * iomem resource tree.
+ */
+int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
+{
+	struct resource *p = &iomem_resource;
+	int err = 0;
+	loff_t l;
+
+	read_lock(&resource_lock);
+	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
+		/*
+		 * We can probably skip the resources with out
+		 * IORESOURCE_IO attribute?
+		 */
+		if (p->start >= addr + size)
+			continue;
+		if (p->end < addr)
+			continue;
+		if (p->start <= addr && (p->end >= addr + size - 1))
+			continue;
+		printk(KERN_WARNING "resource map sanity check conflict "
+		       " 0x%llx 0x%llx 0x%llx 0x%llx %s\n",
+		       addr, addr + size - 1, p->start, p->end, p->name);
+		err = -1;
+		break;
+	}
+	read_unlock(&resource_lock);
+
+	return err;
+}
