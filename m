Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXEMDtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXEMDtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 23:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbXEMDtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 23:49:08 -0400
Received: from ozlabs.org ([203.10.76.45]:55596 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbXEMDtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 23:49:06 -0400
Subject: Re: [PATCH 2/5] lguest guest feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070511065613.GB25182@infradead.org>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
	 <1178846490.23513.27.camel@localhost.localdomain>
	 <20070511065613.GB25182@infradead.org>
Content-Type: text/plain
Date: Sun, 13 May 2007 13:48:47 +1000
Message-Id: <1179028128.23513.110.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 07:56 +0100, Christoph Hellwig wrote:
> On Fri, May 11, 2007 at 11:21:30AM +1000, Rusty Russell wrote:
> > 1) send-dma and bind-dma hypercall wrappers for drivers to use,
> > 2) formalization of the convention that devices can use the irq
> >    corresponding to their index on the lguest_bus.
> > 3) ___force to shut up sparse: guests *can* use ioremap as virtual mem.
> 
> No, they can't.

OK, here's the updated patch (lguest_map/lguest_unmap).

==
Jeff Garzik argued forcefully that __pa() should not appear in
drivers, and that struct netdevice's irq field should not be used.
Christoph Hellwig suggested that I run sparse, and provide an
lguest-specific wrapper for mapping/unmapping virtual device memory.

Results:
1) send-dma and bind-dma hypercall wrappers for drivers to use,
2) formalization of the convention that devices can use the irq
   corresponding to their index on the lguest_bus.
3) Helper to map and unmap virtual device memory (not classic __iomem).
4) lguest.c should include "lguest_bus.h" for lguest_devices declaration.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c     |   33 +++++++++++++++++++++++++++++++++
 drivers/lguest/lguest_bus.c |    2 +-
 include/linux/lguest_bus.h  |   17 ++++++++++++++++-
 3 files changed, 50 insertions(+), 2 deletions(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
+#include <linux/lguest_bus.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -35,6 +36,7 @@
 #include <asm/setup.h>
 #include <asm/e820.h>
 #include <asm/mce.h>
+#include <asm/io.h>
 
 /* Declarations for definitions in lguest_guest.S */
 extern char lguest_noirq_start[], lguest_noirq_end[];
@@ -99,6 +101,37 @@ void async_hcall(unsigned long call,
 			next_call = 0;
 	}
 	local_irq_restore(flags);
+}
+
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma)
+{
+	dma->used_len = 0;
+	hcall(LHCALL_SEND_DMA, key, __pa(dma), 0);
+}
+
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq)
+{
+	if (!hcall(LHCALL_BIND_DMA, key, __pa(dmas), (num << 8) | irq))
+		return -ENOMEM;
+	return 0;
+}
+
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas)
+{
+	hcall(LHCALL_BIND_DMA, key, __pa(dmas), 0);
+}
+
+/* For guests, device memory can be used as normal memory, so we cast away the
+ * __iomem to quieten sparse. */
+void *lguest_map(unsigned long phys_addr, unsigned long pages)
+{
+	return (__force void *)ioremap(phys_addr, PAGE_SIZE*pages);
+}
+
+void lguest_unmap(void *addr)
+{
+	iounmap((__force void __iomem *)addr);
 }
 
 static unsigned long save_fl(void)
===================================================================
--- a/drivers/lguest/lguest_bus.c
+++ b/drivers/lguest/lguest_bus.c
@@ -136,7 +136,7 @@ static int __init lguest_bus_init(void)
 		return 0;
 
 	/* Devices are in page above top of "normal" mem. */
-	lguest_devices = ioremap(max_pfn << PAGE_SHIFT, PAGE_SIZE);
+	lguest_devices = lguest_map(max_pfn<<PAGE_SHIFT, 1);
 
 	if (bus_register(&lguest_bus.bus) != 0
 	    || device_register(&lguest_bus.dev) != 0)
===================================================================
--- a/include/linux/lguest_bus.h
+++ b/include/linux/lguest_bus.h
@@ -7,7 +7,6 @@
 
 struct lguest_device {
 	/* Unique busid, and index into lguest_page->devices[] */
-	/* By convention, each device can use irq index+1 if it wants to. */
 	unsigned int index;
 
 	struct device dev;
@@ -15,6 +14,22 @@ struct lguest_device {
 	/* Driver can hang data off here. */
 	void *private;
 };
+
+/* By convention, each device can use irq index+1 if it wants to. */
+static inline int lgdev_irq(const struct lguest_device *dev)
+{
+	return dev->index + 1;
+}
+
+/* dma args must not be vmalloced! */
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma);
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq);
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas);
+
+/* Map the virtual device space */
+void *lguest_map(unsigned long phys_addr, unsigned long pages);
+void lguest_unmap(void *);
 
 struct lguest_driver {
 	const char *name;


