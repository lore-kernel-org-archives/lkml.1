Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZA1Usr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZA1Usr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZA1UcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:12 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47785 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbZA1UcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:10 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:06 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 03/12] OMAP2/3 clock: convert remaining MPU barriers into
	OCP barriers
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:06 -0700
Message-ID: <20090128193504.2396.57715.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several parts of the OMAP2/3 clock code use wmb() to try to ensure
that the hardware write completes before continuing.  This approach is
problematic: wmb() only ensures that the write leaves the ARM.  It
does not ensure that the write actually reaches the endpoint device.
The endpoint device in this case - either the PRM, CM, or SCM - is
three interconnects away from the ARM - and the final interconnect is
low-speed.  And the OCP interconnects will post the write, and who
knows how long that will take to complete.  So the wmb() is not what
we want.  Worse, the wmb() is indiscriminate; it causes the ARM to
flush any other unrelated buffered writes and wait for the local
interconnect to acknowledge them - potentially very expensive.

Fix this by converting the wmb()s into readbacks of the same PRM/CM/SCM
register.  Since the PRM/CM/SCM devices use a single OCP thread, this
will cause the MPU to block while waiting for posted writes to that device
to complete.

linux-omap source commit is 260f5487848681b4d8ea7430a709a601bbcb21d1.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 25efa93..bbc6e7d 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -444,7 +444,7 @@ static int _omap2_clk_enable(struct clk *clk)
 	else
 		v |= (1 << clk->enable_bit);
 	_omap2_clk_write_reg(v, clk->enable_reg, clk);
-	wmb();
+	v = _omap2_clk_read_reg(clk->enable_reg, clk); /* OCP barrier */
 
 	omap2_clk_wait_ready(clk);
 
@@ -772,8 +772,7 @@ int omap2_clksel_set_rate(struct clk *clk, unsigned long rate)
 	v &= ~clk->clksel_mask;
 	v |= field_val << __ffs(clk->clksel_mask);
 	_omap2_clk_write_reg(v, clk->clksel_reg, clk);
-
-	wmb();
+	v = _omap2_clk_read_reg(clk->clksel_reg, clk); /* OCP barrier */
 
 	clk->rate = clk->parent->rate / new_div;
 
@@ -849,7 +848,7 @@ int omap2_clk_set_parent(struct clk *clk, struct clk *new_parent)
 	v &= ~clk->clksel_mask;
 	v |= field_val << __ffs(clk->clksel_mask);
 	_omap2_clk_write_reg(v, clk->clksel_reg, clk);
-	wmb();
+	v = _omap2_clk_read_reg(clk->clksel_reg, clk);    /* OCP barrier */
 
 	_omap2xxx_clk_commit(clk);
 


