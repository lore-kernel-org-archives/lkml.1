Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZCZNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZCZNNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZCZNNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:13:05 -0400
Received: from mx1.emlix.com ([193.175.82.87]:43120 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbZCZNND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:13:03 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Piet Delaney <piet@tensilica.com>, linux-kernel@vger.kernel.org,
       linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 2/2] xtensa: support dma_alloc_coherent on s6000
Date: Thu, 26 Mar 2009 14:14:06 +0100
Message-Id: <1238073246-23753-2-git-send-email-dg@emlix.com>
In-Reply-To: <1238073246-23753-1-git-send-email-dg@emlix.com>
References: <1238073246-23753-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s6000 core is a nommu variant but there is additional hardware that
mirrors the first 512MB of RAM at another address, which is made uncached
by the boot loader.

This patch uses that RAM mirror to provide support for dma_alloc_coherent.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/variants/s6000/Makefile           |    2 +-
 arch/xtensa/variants/s6000/uncached-mapping.c |   46 +++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 1 deletions(-)
 create mode 100644 arch/xtensa/variants/s6000/uncached-mapping.c

diff --git a/arch/xtensa/variants/s6000/Makefile b/arch/xtensa/variants/s6000/Makefile
index 5f1429d..408c4fe 100644
--- a/arch/xtensa/variants/s6000/Makefile
+++ b/arch/xtensa/variants/s6000/Makefile
@@ -1,3 +1,3 @@
 # s6000 Makefile
 
-obj-y		+= irq.o gpio.o dmac.o isef.o
+obj-y		+= irq.o gpio.o dmac.o isef.o uncached-mapping.o
diff --git a/arch/xtensa/variants/s6000/uncached-mapping.c b/arch/xtensa/variants/s6000/uncached-mapping.c
new file mode 100644
index 0000000..10dfdf1
--- /dev/null
+++ b/arch/xtensa/variants/s6000/uncached-mapping.c
@@ -0,0 +1,46 @@
+/*
+ * arch/xtensa/variant/s6000/uncached-mapping.c
+ *
+ * address translation between cached and uncached regions
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * Copyright (C) 2009 emlix GmbH
+ *
+ * Daniel Gloeckner <dg@emlix.com>
+ */
+
+#include <asm/page.h>
+#include <asm/uncached-mapping.h>
+
+#define AREA_START_C	0x40000000
+#define AREA_START_UC	0x00000000
+#define AREA_SIZE	0x20000000
+
+unsigned long variant_uncacheable_pages(unsigned long page)
+{
+	const unsigned long start_page = AREA_START_C >> PAGE_SHIFT;
+	const unsigned long end_page = (AREA_START_C + AREA_SIZE) >> PAGE_SHIFT;
+	if (page < start_page || page > end_page)
+		return 0;
+	return end_page - page;
+}
+
+void *variant_map_uncached(void *addr, unsigned long size)
+{
+	if ((unsigned long)addr < AREA_START_C ||
+	    (unsigned long)addr > AREA_START_C + AREA_SIZE)
+		return 0;
+	return addr - AREA_START_C + AREA_START_UC;
+}
+
+void *variant_unmap_uncached(void *addr, unsigned long size)
+{
+	if ((unsigned long)addr < AREA_START_UC ||
+	    (unsigned long)addr > AREA_START_UC + AREA_SIZE)
+		return 0;
+	return addr - AREA_START_UC + AREA_START_C;
+}
-- 
1.6.2.107.ge47ee

