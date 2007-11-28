Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbXK1Ogf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbXK1Ogf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbXK1Of1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:35:27 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62237 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757135AbXK1OfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:35:23 -0500
Message-Id: <20071128143438.096659000@pademelon.sonytel.be>
References: <20071128143142.580732000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 15:31:43 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 1/7] ps3: Make bus_id and dev_id u64
Content-Disposition: inline; filename=ps3-wip/make-dev_id-and-bus_id-u64.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3: Make bus_id and dev_id u64.

These IDs are 64-bit in the repository, and the special storage notification
device has a device ID of ULONG_MAX.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/device-init.c |    4 ++--
 arch/powerpc/platforms/ps3/mm.c          |    8 ++++----
 arch/powerpc/platforms/ps3/platform.h    |   12 ++++++------
 arch/powerpc/platforms/ps3/repository.c  |   21 ++++++++-------------
 arch/powerpc/platforms/ps3/system-bus.c  |   14 +++++++-------
 drivers/net/ps3_gelic_net.c              |    4 ++--
 include/asm-powerpc/ps3.h                |    4 ++--
 7 files changed, 31 insertions(+), 36 deletions(-)

--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -297,7 +297,7 @@ static int ps3_storage_wait_for_device(c
 		u64 dev_port;
 	} *notify_event;
 
-	pr_debug(" -> %s:%u: (%u:%u:%u)\n", __func__, __LINE__, repo->bus_id,
+	pr_debug(" -> %s:%u: (%lu:%lu:%u)\n", __func__, __LINE__, repo->bus_id,
 		 repo->dev_id, repo->dev_type);
 
 	buf = kzalloc(512, GFP_KERNEL);
@@ -384,7 +384,7 @@ static int ps3_storage_wait_for_device(c
 
 		if (notify_event->dev_id == repo->dev_id &&
 		    notify_event->dev_type == PS3_DEV_TYPE_NOACCESS) {
-			pr_debug("%s:%u: no access: dev_id %u\n", __func__,
+			pr_debug("%s:%u: no access: dev_id %lu\n", __func__,
 				 __LINE__, repo->dev_id);
 			break;
 		}
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -359,7 +359,7 @@ static unsigned long dma_sb_lpar_to_bus(
 static void  __maybe_unused _dma_dump_region(const struct ps3_dma_region *r,
 	const char *func, int line)
 {
-	DBG("%s:%d: dev        %u:%u\n", func, line, r->dev->bus_id,
+	DBG("%s:%d: dev        %lu:%lu\n", func, line, r->dev->bus_id,
 		r->dev->dev_id);
 	DBG("%s:%d: page_size  %u\n", func, line, r->page_size);
 	DBG("%s:%d: bus_addr   %lxh\n", func, line, r->bus_addr);
@@ -394,7 +394,7 @@ struct dma_chunk {
 static void _dma_dump_chunk (const struct dma_chunk* c, const char* func,
 	int line)
 {
-	DBG("%s:%d: r.dev        %u:%u\n", func, line,
+	DBG("%s:%d: r.dev        %lu:%lu\n", func, line,
 		c->region->dev->bus_id, c->region->dev->dev_id);
 	DBG("%s:%d: r.bus_addr   %lxh\n", func, line, c->region->bus_addr);
 	DBG("%s:%d: r.page_size  %u\n", func, line, c->region->page_size);
@@ -658,7 +658,7 @@ static int dma_sb_region_create(struct p
 	BUG_ON(!r);
 
 	if (!r->dev->bus_id) {
-		pr_info("%s:%d: %u:%u no dma\n", __func__, __LINE__,
+		pr_info("%s:%d: %lu:%lu no dma\n", __func__, __LINE__,
 			r->dev->bus_id, r->dev->dev_id);
 		return 0;
 	}
@@ -724,7 +724,7 @@ static int dma_sb_region_free(struct ps3
 	BUG_ON(!r);
 
 	if (!r->dev->bus_id) {
-		pr_info("%s:%d: %u:%u no dma\n", __func__, __LINE__,
+		pr_info("%s:%d: %lu:%lu no dma\n", __func__, __LINE__,
 			r->dev->bus_id, r->dev->dev_id);
 		return 0;
 	}
--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -95,7 +95,7 @@ enum ps3_dev_type {
 
 int ps3_repository_read_bus_str(unsigned int bus_index, const char *bus_str,
 	u64 *value);
-int ps3_repository_read_bus_id(unsigned int bus_index, unsigned int *bus_id);
+int ps3_repository_read_bus_id(unsigned int bus_index, u64 *bus_id);
 int ps3_repository_read_bus_type(unsigned int bus_index,
 	enum ps3_bus_type *bus_type);
 int ps3_repository_read_bus_num_dev(unsigned int bus_index,
@@ -119,7 +119,7 @@ enum ps3_reg_type {
 int ps3_repository_read_dev_str(unsigned int bus_index,
 	unsigned int dev_index, const char *dev_str, u64 *value);
 int ps3_repository_read_dev_id(unsigned int bus_index, unsigned int dev_index,
-	unsigned int *dev_id);
+	u64 *dev_id);
 int ps3_repository_read_dev_type(unsigned int bus_index,
 	unsigned int dev_index, enum ps3_dev_type *dev_type);
 int ps3_repository_read_dev_intr(unsigned int bus_index,
@@ -138,12 +138,12 @@ int ps3_repository_read_dev_reg(unsigned
 /* repository bus enumerators */
 
 struct ps3_repository_device {
-	enum ps3_bus_type bus_type;
 	unsigned int bus_index;
-	unsigned int bus_id;
-	enum ps3_dev_type dev_type;
 	unsigned int dev_index;
-	unsigned int dev_id;
+	enum ps3_bus_type bus_type;
+	enum ps3_dev_type dev_type;
+	u64 bus_id;
+	u64 dev_id;
 };
 
 static inline struct ps3_repository_device *ps3_repository_bump_device(
--- a/arch/powerpc/platforms/ps3/repository.c
+++ b/arch/powerpc/platforms/ps3/repository.c
@@ -168,18 +168,15 @@ int ps3_repository_read_bus_str(unsigned
 		value, 0);
 }
 
-int ps3_repository_read_bus_id(unsigned int bus_index, unsigned int *bus_id)
+int ps3_repository_read_bus_id(unsigned int bus_index, u64 *bus_id)
 {
 	int result;
-	u64 v1;
-	u64 v2; /* unused */
 
 	result = read_node(PS3_LPAR_ID_PME,
 		make_first_field("bus", bus_index),
 		make_field("id", 0),
 		0, 0,
-		&v1, &v2);
-	*bus_id = v1;
+		bus_id, NULL);
 	return result;
 }
 
@@ -225,18 +222,16 @@ int ps3_repository_read_dev_str(unsigned
 }
 
 int ps3_repository_read_dev_id(unsigned int bus_index, unsigned int dev_index,
-	unsigned int *dev_id)
+	u64 *dev_id)
 {
 	int result;
-	u64 v1;
 
 	result = read_node(PS3_LPAR_ID_PME,
 		make_first_field("bus", bus_index),
 		make_field("dev", dev_index),
 		make_field("id", 0),
 		0,
-		&v1, 0);
-	*dev_id = v1;
+		dev_id, 0);
 	return result;
 }
 
@@ -332,7 +327,7 @@ int ps3_repository_find_device(struct ps
 		return result;
 	}
 
-	pr_debug("%s:%d: bus_type %u, bus_index %u, bus_id %u, num_dev %u\n",
+	pr_debug("%s:%d: bus_type %u, bus_index %u, bus_id %lu, num_dev %u\n",
 		__func__, __LINE__, tmp.bus_type, tmp.bus_index, tmp.bus_id,
 		num_dev);
 
@@ -387,7 +382,7 @@ int ps3_repository_find_device(struct ps
 		return result;
 	}
 
-	pr_debug("%s:%d: found: dev_type %u, dev_index %u, dev_id %u\n",
+	pr_debug("%s:%d: found: dev_type %u, dev_index %u, dev_id %lu\n",
 		__func__, __LINE__, tmp.dev_type, tmp.dev_index, tmp.dev_id);
 
 	*repo = tmp;
@@ -1034,7 +1029,7 @@ static int dump_device_info(struct ps3_r
 			continue;
 		}
 
-		pr_debug("%s:%d  (%u:%u): dev_type %u, dev_id %u\n", __func__,
+		pr_debug("%s:%d  (%u:%u): dev_type %u, dev_id %lu\n", __func__,
 			__LINE__, repo->bus_index, repo->dev_index,
 			repo->dev_type, repo->dev_id);
 
@@ -1091,7 +1086,7 @@ int ps3_repository_dump_bus_info(void)
 			continue;
 		}
 
-		pr_debug("%s:%d bus_%u: bus_type %u, bus_id %u, num_dev %u\n",
+		pr_debug("%s:%d bus_%u: bus_type %u, bus_id %lu, num_dev %u\n",
 			__func__, __LINE__, repo.bus_index, repo.bus_type,
 			repo.bus_id, num_dev);
 
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -42,8 +42,8 @@ struct {
 	int gpu;
 } static usage_hack;
 
-static int ps3_is_device(struct ps3_system_bus_device *dev,
-			 unsigned int bus_id, unsigned int dev_id)
+static int ps3_is_device(struct ps3_system_bus_device *dev, u64 bus_id,
+			 u64 dev_id)
 {
 	return dev->bus_id == bus_id && dev->dev_id == dev_id;
 }
@@ -182,8 +182,8 @@ int ps3_open_hv_device(struct ps3_system
 	case PS3_MATCH_ID_SYSTEM_MANAGER:
 		pr_debug("%s:%d: unsupported match_id: %u\n", __func__,
 			__LINE__, dev->match_id);
-		pr_debug("%s:%d: bus_id: %u\n", __func__,
-			__LINE__, dev->bus_id);
+		pr_debug("%s:%d: bus_id: %lu\n", __func__, __LINE__,
+			dev->bus_id);
 		BUG();
 		return -EINVAL;
 
@@ -220,8 +220,8 @@ int ps3_close_hv_device(struct ps3_syste
 	case PS3_MATCH_ID_SYSTEM_MANAGER:
 		pr_debug("%s:%d: unsupported match_id: %u\n", __func__,
 			__LINE__, dev->match_id);
-		pr_debug("%s:%d: bus_id: %u\n", __func__,
-			__LINE__, dev->bus_id);
+		pr_debug("%s:%d: bus_id: %lu\n", __func__, __LINE__,
+			dev->bus_id);
 		BUG();
 		return -EINVAL;
 
@@ -240,7 +240,7 @@ EXPORT_SYMBOL_GPL(ps3_close_hv_device);
 static void _dump_mmio_region(const struct ps3_mmio_region* r,
 	const char* func, int line)
 {
-	pr_debug("%s:%d: dev       %u:%u\n", func, line, r->dev->bus_id,
+	pr_debug("%s:%d: dev       %lu:%lu\n", func, line, r->dev->bus_id,
 		r->dev->dev_id);
 	pr_debug("%s:%d: bus_addr  %lxh\n", func, line, r->bus_addr);
 	pr_debug("%s:%d: len       %lxh\n", func, line, r->len);
--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -58,11 +58,11 @@ static inline struct device *ctodev(stru
 {
 	return &card->dev->core;
 }
-static inline unsigned int bus_id(struct gelic_net_card *card)
+static inline u64 bus_id(struct gelic_net_card *card)
 {
 	return card->dev->bus_id;
 }
-static inline unsigned int dev_id(struct gelic_net_card *card)
+static inline u64 dev_id(struct gelic_net_card *card)
 {
 	return card->dev->dev_id;
 }
--- a/include/asm-powerpc/ps3.h
+++ b/include/asm-powerpc/ps3.h
@@ -344,8 +344,8 @@ struct ps3_system_bus_device {
 	enum ps3_match_id match_id;
 	enum ps3_system_bus_device_type dev_type;
 
-	unsigned int bus_id;              /* SB */
-	unsigned int dev_id;              /* SB */
+	u64 bus_id;                       /* SB */
+	u64 dev_id;                       /* SB */
 	unsigned int interrupt_id;        /* SB */
 	struct ps3_dma_region *d_region;  /* SB, IOC0 */
 	struct ps3_mmio_region *m_region; /* SB, IOC0*/

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

