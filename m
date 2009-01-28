Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbZA1Uh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbZA1Uh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbZA1U3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:42 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32940 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbZA1U3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:32 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:59 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 11/14] OMAP clock: track child clocks
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:59 -0700
Message-ID: <20090128192756.29333.41541.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Track child clocks for each struct clk.  This optimizes traversals of the
clock tree from parent to child, which happens during rate propagation, and
in the future, clock notifiers.

Previously, parent-to-child traversals sequentially scanned the entire
clock list at each step to determine the children of a particular
clock node.  Now each struct clk maintains a clock list of its
children.  For a DPLL3_M2_CK rate change, this converts what were
about O(6*180*2) operations into O(6*6*2) operations.  The savings
will be even more significant after the future notifier patches:
something like O(6*180*6) to O(6*6*6).

The price paid is additional runtime memory consumption - 8 bytes per
clock and 16 bytes per child clock - roughly 4.5KiB on OMAP3.  The
memory comes mostly from bootmem, since initial clock registration
takes place before slab is ready.  Several other operations will take
slightly more time due the extra bookkeeping: clk_register(),
clk_unregister(), clk_set_parent(), and omap2_init_clksel_parent().

linux-omap source commit is c4cd1332c2a78112624f4a418116e95fa6e9e57c.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c             |    4 +
 arch/arm/plat-omap/clock.c              |  221 ++++++++++++++++++++++++-------
 arch/arm/plat-omap/include/mach/clock.h |   22 +++
 3 files changed, 199 insertions(+), 48 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 0c00706..6ca67cb 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -223,7 +223,11 @@ void omap2_init_clksel_parent(struct clk *clk)
 						 clk->name, clks->parent->name,
 						 ((clk->parent) ?
 						  clk->parent->name : "NULL"));
+					if (clk->parent)
+						omap_clk_del_child(clk->parent,
+								   clk);
 					clk->parent = clks->parent;
+					omap_clk_add_child(clk->parent, clk);
 				};
 				found = 1;
 			}
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 7a7547d..8417d11 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -23,6 +23,8 @@
 #include <linux/cpufreq.h>
 #include <linux/debugfs.h>
 #include <linux/io.h>
+#include <linux/bootmem.h>
+#include <linux/slab.h>
 
 #include <mach/clock.h>
 
@@ -32,6 +34,142 @@ static DEFINE_SPINLOCK(clockfw_lock);
 
 static struct clk_functions *arch_clock;
 
+/**
+ * omap_clk_for_each_child - call callback on each child clock of clk
+ * @clk: struct clk * to use as the "parent"
+ * @parent_rate: rate of the parent of @clk to pass along
+ * @rate_storage: flag indicating whether current or temporary rates are used
+ * @cb: pointer to a callback function
+ *
+ * For each child clock of @clk, call the callback function @cb, passing
+ * along the contents of @parent_rate and @rate_storage.  If the callback
+ * function returns non-zero, terminate the function and pass along the
+ * return value.
+ */
+static int omap_clk_for_each_child(struct clk *clk, unsigned long parent_rate,
+				   u8 rate_storage,
+				   int (*cb)(struct clk *clk,
+					     unsigned long parent_rate,
+					     u8 rate_storage))
+{
+	struct clk_child *child;
+	int ret;
+
+	list_for_each_entry(child, &clk->children, node) {
+		ret = (*cb)(child->clk, parent_rate, rate_storage);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/**
+ * omap_clk_has_children - does clk @clk have any child clocks?
+ * @clk: struct clk * to test for child clocks
+ *
+ * If clock @clk has any child clocks, return 1; otherwise, return 0.
+ */
+static int omap_clk_has_children(struct clk *clk)
+{
+	return (list_empty(&clk->children)) ? 0 : 1;
+}
+
+/**
+ * _do_propagate_rate - callback function for rate propagation
+ * @clk: struct clk * to recalc and propagate from
+ * @parent_rate: rate of the parent of @clk, to use in recalculation
+ * @rate_storage: flag indicating whether current or temporary rates are used
+ *
+ * If @clk has a recalc function, call it.  If @clk has any children,
+ * propagate @clk's rate.  Returns 0.
+ */
+static int _do_propagate_rate(struct clk *clk, unsigned long parent_rate,
+			      u8 rate_storage)
+{
+	if (clk->recalc)
+		clk->recalc(clk, parent_rate, rate_storage);
+	if (omap_clk_has_children(clk))
+		propagate_rate(clk, rate_storage);
+	return 0;
+}
+
+/**
+ * omap_clk_add_child - add a child clock @clk2 to @clk
+ * @clk: parent struct clk *
+ * @clk2: new child struct clk *
+ *
+ * Add a child clock @clk2 to the list of children of parent clock
+ * @clk.  Will potentially allocate memory from bootmem or, if
+ * available, from slab.  Must only be called with the clock framework
+ * spinlock held.  No return value.
+ */
+void omap_clk_add_child(struct clk *clk, struct clk *clk2)
+{
+	struct clk_child *child;
+	int reuse = 0;
+
+	if (!clk->children.next)
+		INIT_LIST_HEAD(&clk->children);
+
+	list_for_each_entry(child, &clk->children, node) {
+		if (child->flags & CLK_CHILD_DELETED) {
+			reuse = 1;
+			child->flags &= ~CLK_CHILD_DELETED;
+			break;
+		}
+	}
+
+	if (!reuse) {
+		if (slab_is_available())
+			child = kmalloc(sizeof(struct clk_child), GFP_ATOMIC);
+		else
+			child = alloc_bootmem(sizeof(struct clk_child));
+
+		if (!child) {
+			WARN_ON(1);
+			return;
+		}
+
+		memset(child, 0, sizeof(struct clk_child));
+
+		if (slab_is_available())
+			child->flags |= CLK_CHILD_SLAB_ALLOC;
+	}
+
+	child->clk = clk2;
+
+	list_add_tail(&child->node, &clk->children);
+}
+
+/**
+ * omap_clk_del_child - add a child clock @clk2 to @clk
+ * @clk: parent struct clk *
+ * @clk2: former child struct clk *
+ *
+ * Remove a child clock @clk2 from the list of children of parent
+ * clock @clk.  Must only be called with the clock framework spinlock
+ * held.  No return value.
+ */
+void omap_clk_del_child(struct clk *clk, struct clk *clk2)
+{
+	struct clk_child *child, *tmp;
+
+	/* Loop over all existing clk_childs, when found, deallocate */
+	list_for_each_entry_safe(child, tmp, &clk->children, node) {
+		if (child->clk == clk2) {
+			list_del(&child->node);
+			if (child->flags & CLK_CHILD_SLAB_ALLOC) {
+				kfree(child);
+			} else {
+				child->clk = NULL;
+				child->flags |= CLK_CHILD_DELETED;
+			}
+			break;
+		}
+	}
+}
+
 /*-------------------------------------------------------------------------
  * Standard clock functions defined in include/linux/clk.h
  *-------------------------------------------------------------------------*/
@@ -85,13 +223,9 @@ int clk_enable(struct clk *clk)
 	spin_lock_irqsave(&clockfw_lock, flags);
 	if (arch_clock->clk_enable) {
 		ret = arch_clock->clk_enable(clk);
-		if (ret == 0 && clk->flags & RECALC_ON_ENABLE) {
-			if (clk->recalc)
-				(*clk->recalc)(clk, clk->parent->rate,
-					       CURRENT_RATE);
-			if (clk->flags & RATE_PROPAGATES)
-				propagate_rate(clk, CURRENT_RATE);
-		}
+		if (ret == 0 && clk->flags & RECALC_ON_ENABLE)
+			_do_propagate_rate(clk, clk->parent->rate,
+					   CURRENT_RATE);
 	}
 
 	spin_unlock_irqrestore(&clockfw_lock, flags);
@@ -117,13 +251,9 @@ void clk_disable(struct clk *clk)
 
 	if (arch_clock->clk_disable) {
 		arch_clock->clk_disable(clk);
-		if (clk->flags & RECALC_ON_ENABLE) {
-			if (clk->recalc)
-				(*clk->recalc)(clk, clk->parent->rate,
-					       CURRENT_RATE);
-			if (clk->flags & RATE_PROPAGATES)
-				propagate_rate(clk, CURRENT_RATE);
-		}
+		if (clk->flags & RECALC_ON_ENABLE)
+			_do_propagate_rate(clk, clk->parent->rate,
+					   CURRENT_RATE);
 	}
 
 out:
@@ -203,13 +333,9 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 
 	if (arch_clock->clk_set_rate) {
 		ret = arch_clock->clk_set_rate(clk, rate);
-		if (ret == 0) {
-			if (clk->recalc)
-				(*clk->recalc)(clk, clk->parent->rate,
-					       CURRENT_RATE);
-			if (clk->flags & RATE_PROPAGATES)
-				propagate_rate(clk, CURRENT_RATE);
-		}
+		if (ret == 0)
+			_do_propagate_rate(clk, clk->parent->rate,
+					   CURRENT_RATE);
 	}
 
 	spin_unlock_irqrestore(&clockfw_lock, flags);
@@ -221,6 +347,7 @@ EXPORT_SYMBOL(clk_set_rate);
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	unsigned long flags;
+	struct clk *prev_parent;
 	int ret = -EINVAL;
 
 	if (clk == NULL || IS_ERR(clk) || parent == NULL || IS_ERR(parent))
@@ -229,13 +356,13 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	spin_lock_irqsave(&clockfw_lock, flags);
 
 	if (arch_clock->clk_set_parent) {
+		prev_parent = clk->parent;
 		ret = arch_clock->clk_set_parent(clk, parent);
 		if (ret == 0) {
-			if (clk->recalc)
-				(*clk->recalc)(clk, clk->parent->rate,
-					       CURRENT_RATE);
-			if (clk->flags & RATE_PROPAGATES)
-				propagate_rate(clk, CURRENT_RATE);
+			omap_clk_del_child(prev_parent, clk);
+			omap_clk_add_child(parent, clk);
+			_do_propagate_rate(clk, clk->parent->rate,
+					   CURRENT_RATE);
 		}
 	}
 
@@ -299,26 +426,18 @@ void followparent_recalc(struct clk *clk, unsigned long new_parent_rate,
 /* Propagate rate to children */
 void propagate_rate(struct clk *tclk, u8 rate_storage)
 {
-	struct clk *clkp;
 	unsigned long parent_rate = 0;
 
 	if (tclk == NULL || IS_ERR(tclk))
 		return;
 
-	list_for_each_entry(clkp, &clocks, node) {
-		if (likely(clkp->parent != tclk))
-			continue;
-
-		if (rate_storage == CURRENT_RATE)
-			parent_rate = tclk->rate;
-		else if (rate_storage == TEMP_RATE)
-			parent_rate = tclk->temp_rate;
+	if (rate_storage == CURRENT_RATE)
+		parent_rate = tclk->rate;
+	else if (rate_storage == TEMP_RATE)
+		parent_rate = tclk->temp_rate;
 
-		if (clkp->recalc)
-			clkp->recalc(clkp, parent_rate, rate_storage);
-		if (clkp->flags & RATE_PROPAGATES)
-			propagate_rate(clkp, rate_storage);
-	}
+	omap_clk_for_each_child(tclk, parent_rate, rate_storage,
+				_do_propagate_rate);
 }
 
 /**
@@ -332,14 +451,9 @@ void recalculate_root_clocks(void)
 {
 	struct clk *clkp;
 
-	list_for_each_entry(clkp, &clocks, node) {
-		if (unlikely(!clkp->parent)) {
-			if (clkp->recalc)
-				clkp->recalc(clkp, 0, CURRENT_RATE);
-			if (clkp->flags & RATE_PROPAGATES)
-				propagate_rate(clkp, CURRENT_RATE);
-		}
-	}
+	list_for_each_entry(clkp, &clocks, node)
+		if (unlikely(!clkp->parent))
+			_do_propagate_rate(clkp, 0, CURRENT_RATE);
 }
 
 int clk_register(struct clk *clk)
@@ -349,6 +463,10 @@ int clk_register(struct clk *clk)
 
 	mutex_lock(&clocks_mutex);
 	list_add(&clk->node, &clocks);
+	if (!clk->children.next)
+		INIT_LIST_HEAD(&clk->children);
+	if (clk->parent)
+		omap_clk_add_child(clk->parent, clk);
 	if (clk->init)
 		clk->init(clk);
 	mutex_unlock(&clocks_mutex);
@@ -359,11 +477,18 @@ EXPORT_SYMBOL(clk_register);
 
 void clk_unregister(struct clk *clk)
 {
+	struct clk_child *child, *tmp;
+
 	if (clk == NULL || IS_ERR(clk))
 		return;
 
 	mutex_lock(&clocks_mutex);
 	list_del(&clk->node);
+	if (clk->parent)
+		omap_clk_del_child(clk->parent, clk);
+	list_for_each_entry_safe(child, tmp, &clk->children, node)
+		if (child->flags & CLK_CHILD_SLAB_ALLOC)
+			kfree(child);
 	mutex_unlock(&clocks_mutex);
 }
 EXPORT_SYMBOL(clk_unregister);
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 9b1d1f8..358bf9e 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -60,6 +60,21 @@ struct dpll_data {
 
 #endif
 
+/**
+ * struct clk_child - used to track the children of a clock
+ * @clk: child struct clk *
+ * @node: list_head
+ * @flags: is this entry allocated in bootmem or slab?  is it deleted?
+ *
+ * One struct clk_child is allocated for each child clock @clk of a
+ * parent clock.  @flags values are listed below and start with CLK_CHILD_*.
+ */
+struct clk_child {
+	struct clk		*clk;
+	struct list_head	node;
+	u8			flags;
+};
+
 struct clk {
 	struct list_head	node;
 	struct module		*owner;
@@ -68,6 +83,7 @@ struct clk {
 	struct clk		*parent;
 	unsigned long		rate;
 	unsigned long		temp_rate;
+	struct list_head	children;
 	__u32			flags;
 	u32			enable_reg;
 	__u8			enable_bit;
@@ -132,6 +148,8 @@ extern void clk_enable_init_clocks(void);
 #ifdef CONFIG_CPU_FREQ
 extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #endif
+void omap_clk_add_child(struct clk *clk, struct clk *clk2);
+void omap_clk_del_child(struct clk *clk, struct clk *clk2);
 
 /* Clock flags */
 #define RATE_CKCTL		(1 << 0)	/* Main fixed ratio clocks */
@@ -174,6 +192,10 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #define CURRENT_RATE		0
 #define TEMP_RATE		1
 
+/* clk_child flags */
+#define CLK_CHILD_SLAB_ALLOC	(1 << 0)	/* if !set, bootmem was used */
+#define CLK_CHILD_DELETED	(1 << 1)	/* can be reused */
+
 /*
  * clk.prcm_mod flags (possible since only the top byte in clk.prcm_mod
  * is significant)


