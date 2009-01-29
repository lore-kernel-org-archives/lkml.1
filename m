Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZA2WGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZA2WGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZA2WGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:06:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42033 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761AbZA2WGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:06:19 -0500
Date: Thu, 29 Jan 2009 22:06:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH E 11/14] OMAP clock: track child clocks
Message-ID: <20090129220608.GJ18233@n2100.arm.linux.org.uk>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192756.29333.41541.stgit@localhost.localdomain> <20090129151401.GC18233@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129151401.GC18233@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 03:14:01PM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 28, 2009 at 12:27:59PM -0700, Paul Walmsley wrote:
> > The price paid is additional runtime memory consumption - 8 bytes per
> > clock and 16 bytes per child clock - roughly 4.5KiB on OMAP3.
> 
> For OMAP3, that's 222 struct clks of which 182 are children, and indeed
> 222 * 8 + 182 * 16 gives about 4.5K.  On OMAP2, it's 140 and 136,
> giving 140 * 8 + 136 * 16 = 3.3K.
> 
> Moving struct clk_child into struct clk means that its clk and flags
> members can be deleted, making it 8 bytes in size - effectively just
> the list_head.  We need a list_head for the 'children' as you have it.
> So, that works out as 16 bytes per clock.  That gives 3.5K on OMAP3
> and 2.2K on OMAP2.
> 
> So, by taking that alternative approach, not only do you end up using
> less memory, but you also don't have to have the overhead of your
> custom memory bookkeeping.
> 
> The other change I'd suggest is that you have one function which deals
> with setting the parent of a clock:
> 
> void clk_reparent(struct clk *child, struct clk *parent)
> {
> 	list_del_init(&child->sibling);
> 	if (parent)
> 		list_add(&child->sibling, &parent->children);
> 	child->parent = parent;
> 
> 	/* now do the debugfs renaming to reattach the child
> 	   to the proper parent */
> }
> 
> which is a lot simpler than your omap_clk_add_child() and omap_clk_del_child().
> 
> These should be in the _core_ OMAP clock code, not just in the OMAP2
> clock code.  OMAP1 has child clocks as well as OMAP2.

And here is my version of this patch:

 arch/arm/mach-omap2/clock.c             |    4 +-
 arch/arm/plat-omap/clock.c              |   49 +++++++++++++++++++------------
 arch/arm/plat-omap/include/mach/clock.h |    3 ++
 3 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 56d9ea4..14bf566 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -175,7 +175,7 @@ void omap2_init_clksel_parent(struct clk *clk)
 						 clk->name, clks->parent->name,
 						 ((clk->parent) ?
 						  clk->parent->name : "NULL"));
-					clk->parent = clks->parent;
+					clk_reparent(clk, clks->parent);
 				};
 				found = 1;
 			}
@@ -780,7 +780,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	if (clk->usecount > 0)
 		_omap2_clk_enable(clk);
 
-	clk->parent = new_parent;
+	clk_reparent(clk, new_parent);
 
 	/* CLKSEL clocks follow their parents' rates, divided by a divisor */
 	clk->rate = new_parent->rate;
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 3688400..58e42b1 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -127,8 +127,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (ret == 0) {
 		if (clk->recalc)
 			clk->recalc(clk);
-		if (clk->flags & RATE_PROPAGATES)
-			propagate_rate(clk);
+		propagate_rate(clk);
 	}
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
@@ -150,8 +149,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (ret == 0) {
 		if (clk->recalc)
 			clk->recalc(clk);
-		if (clk->flags & RATE_PROPAGATES)
-			propagate_rate(clk);
+		propagate_rate(clk);
 	}
 	spin_unlock_irqrestore(&clockfw_lock, flags);
 
@@ -192,27 +190,34 @@ void followparent_recalc(struct clk *clk)
 	clk->rate = clk->parent->rate;
 }
 
+void clk_reparent(struct clk *child, struct clk *parent)
+{
+	list_del_init(&child->sibling);
+	if (parent)
+		list_add(&child->sibling, &parent->children);
+	child->parent = parent;
+
+	/* now do the debugfs renaming to reattach the child
+	   to the proper parent */
+}
+
 /* Propagate rate to children */
 void propagate_rate(struct clk * tclk)
 {
 	struct clk *clkp;
 
-	if (tclk == NULL || IS_ERR(tclk))
-		return;
-
-	list_for_each_entry(clkp, &clocks, node) {
-		if (likely(clkp->parent != tclk))
-			continue;
+	list_for_each_entry(clkp, &tclk->children, sibling) {
 		if (clkp->recalc) {
 			unsigned long old_rate = clkp->rate;
 			clkp->recalc(clkp);
-			if (clkp->rate != old_rate &&
-			    (clkp->flags & RATE_PROPAGATES))
+			if (clkp->rate != old_rate)
 				propagate_rate(clkp);
 		}
 	}
 }
 
+static LIST_HEAD(root_clks);
+
 /**
  * recalculate_root_clocks - recalculate and propagate all root clocks
  *
@@ -224,13 +229,10 @@ void recalculate_root_clocks(void)
 {
 	struct clk *clkp;
 
-	list_for_each_entry(clkp, &clocks, node) {
-		if (!clkp->parent) {
-			if (clkp->recalc)
-				clkp->recalc(clkp);
-			if (clkp->flags & RATE_PROPAGATES)
-				propagate_rate(clkp);
-		}
+	list_for_each_entry(clkp, &root_clks, sibling) {
+		if (clkp->recalc)
+			clkp->recalc(clkp);
+		propagate_rate(clkp);
 	}
 }
 
@@ -246,6 +248,15 @@ int clk_register(struct clk *clk)
 		return 0;
 
 	mutex_lock(&clocks_mutex);
+	if (!clk->children.next)
+		INIT_LIST_HEAD(&clk->children);
+	if (clk->parent && !clk->parent->children.next)
+		INIT_LIST_HEAD(&clk->parent->children);
+	if (clk->parent)
+		list_add(&clk->sibling, &clk->parent->children);
+	else
+		list_add(&clk->sibling, &root_clks);
+
 	list_add(&clk->node, &clocks);
 	if (clk->init)
 		clk->init(clk);
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index ad0345f..3504c2b 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -70,6 +70,8 @@ struct clk {
 	const char		*name;
 	int			id;
 	struct clk		*parent;
+	struct list_head	children;
+	struct list_head	sibling;	/* node for children */
 	unsigned long		rate;
 	__u32			flags;
 	void __iomem		*enable_reg;
@@ -116,6 +118,7 @@ extern unsigned int mpurate;
 
 extern int clk_init(struct clk_functions *custom_clocks);
 extern int clk_register(struct clk *clk);
+extern void clk_reparent(struct clk *child, struct clk *parent);
 extern void clk_unregister(struct clk *clk);
 extern void propagate_rate(struct clk *clk);
 extern void recalculate_root_clocks(void);
