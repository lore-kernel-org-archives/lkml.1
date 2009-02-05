Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZBEISY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZBEISY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756359AbZBEISM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:18:12 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:53777 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbZBEISL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:18:11 -0500
Date: Thu, 5 Feb 2009 01:18:09 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: linux@arm.linux.org.uk
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, tero.kristo@nokia.com,
       khilman@deeprootsystems.com, tony@atomide.com
Subject: [PATCH] OMAP2/3 clock: fix CONFIG_OMAP_RESET_CLOCKS
Message-ID: <alpine.DEB.2.00.0902050103210.3715@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Russell,

Kevin Hilman kindly alerted me to a bugfix patch that I had omitted from 
the sets that I sent to you recently.  It's inserted below.  Perhaps you 
might consider merging it along with the other sets that you are working 
on?  Without it, chip power management won't work correctly.

The good news is that it is a small and self-contained patch that should 
be possible to apply at any point after patch D 08.


thanks,

- Paul


From: Paul Walmsley <paul@pwsan.com>
Date: Thu, 5 Feb 2009 00:58:23 -0700

OMAP2/3 clock: fix CONFIG_OMAP_RESET_CLOCKS

plat-omap/clock.c was skipping clocks with enable_reg == 0.  This no longer
works now that we use enable_reg as an offset from a PRCM module.

Problem found and traced by Tero Kristo <tero.kristo@nokia.com> -
thanks Tero.

linux-omap source commit is 4c1cb27545d19642d43874ebeacef83bf3566b86.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tero Kristo <tero.kristo@nokia.com>
---
 arch/arm/plat-omap/clock.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index c1fad02..bdf2cd4 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -547,8 +547,11 @@ static int __init clk_disable_unused(void)
 	unsigned long flags;
 
 	list_for_each_entry(ck, &clocks, node) {
-		if (ck->usecount > 0 || (ck->flags & ALWAYS_ENABLED) ||
-			ck->enable_reg == 0)
+		if (ck->usecount > 0 ||
+		    (ck->flags & (ALWAYS_ENABLED | PARENT_CONTROLS_CLOCK)))
+			continue;
+
+		if (cpu_class_is_omap1() && ck->enable_reg == 0)
 			continue;
 
 		spin_lock_irqsave(&clockfw_lock, flags);
-- 
1.6.0.2.GIT
