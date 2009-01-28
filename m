Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZA1Uyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZA1Uyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZA1Ucn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:43 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47775 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbZA1UcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:09 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:04 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 02/12] OMAP2xxx clock: consolidate DELAYED_APP clock commits;
	fix barrier
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:03 -0700
Message-ID: <20090128193501.2396.70073.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the commit code for DELAYED_APP clocks into a subroutine,
_omap2xxx_clk_commit().  Also convert the MPU barrier wmb() into an
OCP barrier, since with an MPU barrier, we have no guarantee that the
write actually reached the endpoint device.

linux-omap source commit is 0f5bdb736515801b296125d16937a21ff7b3cfdc.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index a1ccdcb..25efa93 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -119,6 +119,28 @@ static void _omap2_clk_write_reg(u32 v, u16 reg_offset, struct clk *clk)
 		cm_write_mod_reg(v, clk->prcm_mod, reg_offset);
 }
 
+/**
+ * _omap2xxx_clk_commit - commit clock parent/rate changes in hardware
+ * @clk: struct clk *
+ *
+ * If @clk has the DELAYED_APP flag set, meaning that parent/rate changes
+ * don't take effect until the VALID_CONFIG bit is written, write the
+ * VALID_CONFIG bit and wait for the write to complete.  No return value.
+ */
+static void _omap2xxx_clk_commit(struct clk *clk)
+{
+	if (!cpu_is_omap24xx())
+		return;
+
+	if (!(clk->flags & DELAYED_APP))
+		return;
+
+	prm_write_mod_reg(OMAP24XX_VALID_CONFIG, OMAP24XX_GR_MOD,
+			  OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET);
+	/* OCP barrier */
+	prm_read_mod_reg(OMAP24XX_GR_MOD, OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET);
+}
+
 /*
  * _dpll_test_fint - test whether an Fint value is valid for the DPLL
  * @clk: DPLL struct clk to test
@@ -755,11 +777,7 @@ int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
 
 	clk->rate = clk->parent->rate / new_div;
 
-	if (clk->flags & DELAYED_APP && cpu_is_omap24xx()) {
-		prm_write_mod_reg(OMAP24XX_VALID_CONFIG,
-			OMAP24XX_GR_MOD, OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET);
-		wmb();
-	}
+	_omap2xxx_clk_commit(clk);
 
 	return 0;
 }
@@ -833,11 +851,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	_omap2_clk_write_reg(v, clk->clksel_reg, clk);
 	wmb();
 
-	if (clk->flags & DELAYED_APP && cpu_is_omap24xx()) {
-		prm_write_mod_reg(OMAP24XX_VALID_CONFIG,
-			OMAP24XX_GR_MOD, OMAP24XX_PRCM_CLKCFG_CTRL_OFFSET);
-		wmb();
-	}
+	_omap2xxx_clk_commit(clk);
 
 	if (clk->usecount > 0)
 		_omap2_clk_enable(clk);


