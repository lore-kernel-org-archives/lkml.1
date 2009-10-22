Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbZJVWMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbZJVWMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbZJVWMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:12:49 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56342 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbZJVWMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:12:47 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/YFkJoT8HYELthQMS2mUPO
Subject: [PATCH 08/10] omap3: PM: enable UART3 module wakeups
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2009 15:12:51 -0700
Message-ID: <20091022221250.27408.35730.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@deeprootsystems.com>

UART3 is in the PER powerdomain.  If PER goes idle/inactive
independently of CORE, for UART3 to wakeup it must have its wakeup
enable bits setup in PM_WKEN_PER.  This patch enables these bits.

The reason it works when PER and CORE work together is because when
CORE goes inactive/retention, the IOPAD wakeups are enabled and
trigger UART3 wakeup.

Without this patch, when the UART inactivity timer fires for UART3,
its clocks are disabled and it's unable to wakeup so will be unusable
until PER is awoken by another source.

Another way of testing is by keeping CORE on during suspend but
allowing PER to hit retention

  # echo 3 > /debug/pm_debug/core_pwrdm/suspend

then enter suspend

  # echo mem > /sys/power/state

Without this patch, UART3 will be unable to wakeup the system.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/pm34xx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 378c2f6..8946319 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -639,14 +639,15 @@ static void __init prcm_setup_regs(void)
 	prm_write_mod_reg(OMAP3430_IO_EN | OMAP3430_WKUP_EN,
 			  OCP_MOD, OMAP3_PRM_IRQENABLE_MPU_OFFSET);
 
-	/* Enable GPIO wakeups in PER */
+	/* Enable wakeups in PER */
 	prm_write_mod_reg(OMAP3430_EN_GPIO2 | OMAP3430_EN_GPIO3 |
 			  OMAP3430_EN_GPIO4 | OMAP3430_EN_GPIO5 |
-			  OMAP3430_EN_GPIO6, OMAP3430_PER_MOD, PM_WKEN);
+			  OMAP3430_EN_GPIO6 | OMAP3430_EN_UART3,
+			  OMAP3430_PER_MOD, PM_WKEN);
 	/* and allow them to wake up MPU */
 	prm_write_mod_reg(OMAP3430_GRPSEL_GPIO2 | OMAP3430_EN_GPIO3 |
 			  OMAP3430_GRPSEL_GPIO4 | OMAP3430_EN_GPIO5 |
-			  OMAP3430_GRPSEL_GPIO6,
+			  OMAP3430_GRPSEL_GPIO6 | OMAP3430_EN_UART3,
 			  OMAP3430_PER_MOD, OMAP3430_PM_MPUGRPSEL);
 
 	/* Don't attach IVA interrupts */

