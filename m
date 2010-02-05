Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0BEUuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:50:46 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36799 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755787Ab0BEUun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:50:43 -0500
Date: Fri, 5 Feb 2010 23:50:41 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 1/3] of platforms: Move common static initialization to
 of_node_init()
Message-ID: <20100205205041.GA4178@oksana.dev.rtsoft.ru>
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far of_node_init() just initializes a kref, later we'll have to
initialize other fields (for example node->data_lock).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/microblaze/kernel/prom.c             |    4 ++--
 arch/powerpc/kernel/prom.c                |    4 ++--
 arch/powerpc/platforms/iseries/vio.c      |    5 +++--
 arch/powerpc/platforms/pseries/dlpar.c    |    7 ++++---
 arch/powerpc/platforms/pseries/reconfig.c |    7 ++++---
 arch/powerpc/sysdev/msi_bitmap.c          |    4 ++--
 arch/sparc/kernel/prom_common.c           |    6 +++---
 drivers/of/base.c                         |   10 ++++++++++
 include/linux/of.h                        |    2 ++
 9 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index b817df1..0003453 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/lmb.h>
+#include <linux/of.h>
 
 #include <asm/prom.h>
 #include <asm/page.h>
@@ -255,7 +256,7 @@ static unsigned long __init unflatten_dt_node(unsigned long mem,
 	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
 				__alignof__(struct device_node));
 	if (allnextpp) {
-		memset(np, 0, sizeof(*np));
+		of_node_init(np);
 		np->full_name = ((char *)np) + sizeof(struct device_node);
 		if (new_format) {
 			char *p2 = np->full_name;
@@ -287,7 +288,6 @@ static unsigned long __init unflatten_dt_node(unsigned long mem,
 				dad->next->sibling = np;
 			dad->next = np;
 		}
-		kref_init(&np->kref);
 	}
 	while (1) {
 		u32 sz, noff;
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 4ec3008..d8c2528 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/lmb.h>
+#include <linux/of.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -290,7 +291,7 @@ static unsigned long __init unflatten_dt_node(unsigned long mem,
 	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
 				__alignof__(struct device_node));
 	if (allnextpp) {
-		memset(np, 0, sizeof(*np));
+		of_node_init(np);
 		np->full_name = ((char*)np) + sizeof(struct device_node);
 		if (new_format) {
 			char *p = np->full_name;
@@ -321,7 +322,6 @@ static unsigned long __init unflatten_dt_node(unsigned long mem,
 				dad->next->sibling = np;
 			dad->next = np;
 		}
-		kref_init(&np->kref);
 	}
 	while(1) {
 		u32 sz, noff;
diff --git a/arch/powerpc/platforms/iseries/vio.c b/arch/powerpc/platforms/iseries/vio.c
index 2aa8b56..5f91a96 100644
--- a/arch/powerpc/platforms/iseries/vio.c
+++ b/arch/powerpc/platforms/iseries/vio.c
@@ -83,10 +83,12 @@ static void free_property(struct property *np)
 static struct device_node *new_node(const char *path,
 		struct device_node *parent)
 {
-	struct device_node *np = kzalloc(sizeof(*np), GFP_KERNEL);
+	struct device_node *np = kmalloc(sizeof(*np), GFP_KERNEL);
 
 	if (!np)
 		return NULL;
+
+	of_node_init(np);
 	np->full_name = kmalloc(strlen(path) + 1, GFP_KERNEL);
 	if (!np->full_name) {
 		kfree(np);
@@ -94,7 +96,6 @@ static struct device_node *new_node(const char *path,
 	}
 	strcpy(np->full_name, path);
 	of_node_set_flag(np, OF_DYNAMIC);
-	kref_init(&np->kref);
 	np->parent = of_node_get(parent);
 	return np;
 }
diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 37bce52..72043ad 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -11,11 +11,11 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kref.h>
 #include <linux/notifier.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
+#include <linux/of.h>
 #include "offline_states.h"
 
 #include <asm/prom.h>
@@ -69,10 +69,12 @@ static struct device_node *dlpar_parse_cc_node(struct cc_workarea *ccwa)
 	struct device_node *dn;
 	char *name;
 
-	dn = kzalloc(sizeof(*dn), GFP_KERNEL);
+	dn = kmalloc(sizeof(*dn), GFP_KERNEL);
 	if (!dn)
 		return NULL;
 
+	of_node_init(dn);
+
 	/* The configure connector reported name does not contain a
 	 * preceeding '/', so we allocate a buffer large enough to
 	 * prepend this to the full_name.
@@ -242,7 +244,6 @@ int dlpar_attach_node(struct device_node *dn)
 	int rc;
 
 	of_node_set_flag(dn, OF_DYNAMIC);
-	kref_init(&dn->kref);
 	dn->parent = derive_parent(dn->full_name);
 	if (!dn->parent)
 		return -ENOMEM;
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index a2305d2..a0b65b7 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -12,9 +12,9 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kref.h>
 #include <linux/notifier.h>
 #include <linux/proc_fs.h>
+#include <linux/of.h>
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -113,10 +113,12 @@ static int pSeries_reconfig_add_node(const char *path, struct property *proplist
 	struct device_node *np;
 	int err = -ENOMEM;
 
-	np = kzalloc(sizeof(*np), GFP_KERNEL);
+	np = kmalloc(sizeof(*np), GFP_KERNEL);
 	if (!np)
 		goto out_err;
 
+	of_node_init(np);
+
 	np->full_name = kmalloc(strlen(path) + 1, GFP_KERNEL);
 	if (!np->full_name)
 		goto out_err;
@@ -125,7 +127,6 @@ static int pSeries_reconfig_add_node(const char *path, struct property *proplist
 
 	np->properties = proplist;
 	of_node_set_flag(np, OF_DYNAMIC);
-	kref_init(&np->kref);
 
 	np->parent = derive_parent(path);
 	if (IS_ERR(np->parent)) {
diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
index 5a32cbe..0f259ff 100644
--- a/arch/powerpc/sysdev/msi_bitmap.c
+++ b/arch/powerpc/sysdev/msi_bitmap.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/bitmap.h>
+#include <linux/of.h>
 #include <asm/msi_bitmap.h>
 
 int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
@@ -199,8 +200,7 @@ void __init test_of_node(void)
 	DECLARE_BITMAP(expected, size);
 
 	/* There should really be a struct device_node allocator */
-	memset(&of_node, 0, sizeof(of_node));
-	kref_init(&of_node.kref);
+	of_node_init(&of_node);
 	of_node.full_name = node_name;
 
 	check(0 == msi_bitmap_alloc(&bmp, size, &of_node));
diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index d80a65d..dbfad05 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -229,11 +229,11 @@ static struct device_node * __init prom_create_node(phandle node,
 		return NULL;
 
 	dp = prom_early_alloc(sizeof(*dp));
-	dp->unique_id = prom_unique_id++;
-	dp->parent = parent;
 
-	kref_init(&dp->kref);
+	of_node_init(dp);
 
+	dp->unique_id = prom_unique_id++;
+	dp->parent = parent;
 	dp->name = get_one_property(node, "name");
 	dp->type = get_one_property(node, "device_type");
 	dp->node = node;
diff --git a/drivers/of/base.c b/drivers/of/base.c
index e6627b2..716d439 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -28,6 +28,16 @@ struct device_node *allnodes;
  */
 DEFINE_RWLOCK(devtree_lock);
 
+/**
+ * of_node_init - Initialize a device node
+ * @n:	Node to initialize
+ */
+void of_node_init(struct device_node *np)
+{
+	memset(np, 0, sizeof(*np));
+	kref_init(&np->kref);
+}
+
 int of_n_addr_cells(struct device_node *np)
 {
 	const int *ip;
diff --git a/include/linux/of.h b/include/linux/of.h
index e7facd8..717d690 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -63,6 +63,8 @@ struct device_node {
 #endif
 };
 
+extern void of_node_init(struct device_node *np);
+
 static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
 {
 	return test_bit(flag, &n->_flags);
-- 
1.6.5.7

