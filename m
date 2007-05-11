Return-Path: <linux-kernel-owner+w=401wt.eu-S1761824AbXEKBVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824AbXEKBVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXEKBVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:21:47 -0400
Received: from ozlabs.org ([203.10.76.45]:50083 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbXEKBVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:21:46 -0400
Subject: [PATCH 2/5] lguest guest feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1178846354.23513.23.camel@localhost.localdomain>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 11 May 2007 11:21:30 +1000
Message-Id: <1178846490.23513.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) send-dma and bind-dma hypercall wrappers for drivers to use,
2) formalization of the convention that devices can use the irq
   corresponding to their index on the lguest_bus.
3) ___force to shut up sparse: guests *can* use ioremap as virtual mem.
4) lguest.c should include "lguest_bus.h" for lguest_devices declaration.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c     |   20 ++++++++++++++++++++
 drivers/lguest/lguest_bus.c |    2 +-
 include/linux/lguest_bus.h  |   13 ++++++++++++-
 3 files changed, 33 insertions(+), 2 deletions(-)

===================================================================
--- a/include/linux/lguest_bus.h
+++ b/include/linux/lguest_bus.h
@@ -7,7 +7,6 @@
 
 struct lguest_device {
 	/* Unique busid, and index into lguest_page->devices[] */
-	/* By convention, each device can use irq index+1 if it wants to. */
 	unsigned int index;
 
 	struct device dev;
@@ -15,6 +14,18 @@ struct lguest_device {
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
 
 struct lguest_driver {
 	const char *name;
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
@@ -99,6 +100,25 @@ void async_hcall(unsigned long call,
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
 }
 
 static unsigned long save_fl(void)
===================================================================
--- a/drivers/lguest/lguest_bus.c
+++ b/drivers/lguest/lguest_bus.c
@@ -136,7 +136,7 @@ static int __init lguest_bus_init(void)
 		return 0;
 
 	/* Devices are in page above top of "normal" mem. */
-	lguest_devices = ioremap(max_pfn << PAGE_SHIFT, PAGE_SIZE);
+	lguest_devices = (__force void*)ioremap(max_pfn<<PAGE_SHIFT,PAGE_SIZE);
 
 	if (bus_register(&lguest_bus.bus) != 0
 	    || device_register(&lguest_bus.dev) != 0)


