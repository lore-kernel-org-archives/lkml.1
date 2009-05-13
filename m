Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbZEMALG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbZEMALG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbZEMAH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:56 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56421 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbZEMAHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:44 -0400
MBOX-Line: From nobody Tue May 12 18:05:19 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 05/10] OMAP3 SDRC: initialize SDRC_POWER at boot
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 12 May 2009 18:05:19 -0600
Message-ID: <20090513000518.10349.64171.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize SDRC_POWER to a known-good setting when the kernel boots.
Necessary since some bootloaders don't initialize SDRC_POWER properly.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/sdrc.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/sdrc.c b/arch/arm/mach-omap2/sdrc.c
index 2a30060..d62e4e1 100644
--- a/arch/arm/mach-omap2/sdrc.c
+++ b/arch/arm/mach-omap2/sdrc.c
@@ -37,6 +37,10 @@ static struct omap_sdrc_params *sdrc_init_params;
 void __iomem *omap2_sdrc_base;
 void __iomem *omap2_sms_base;
 
+/* SDRC_POWER register bits */
+#define SDRC_POWER_EXTCLKDIS_SHIFT		3
+#define SDRC_POWER_PWDENA_SHIFT			2
+#define SDRC_POWER_PAGEPOLICY_SHIFT		0
 
 /**
  * omap2_sdrc_get_params - return SDRC register values for a given clock rate
@@ -74,7 +78,14 @@ void __init omap2_set_globals_sdrc(struct omap_globals *omap2_globals)
 	omap2_sms_base = omap2_globals->sms;
 }
 
-/* turn on smart idle modes for SDRAM scheduler and controller */
+/**
+ * omap2_sdrc_init - initialize SMS, SDRC devices on boot
+ * @sp: pointer to a null-terminated list of struct omap_sdrc_params
+ *
+ * Turn on smart idle modes for SDRAM scheduler and controller.
+ * Program a known-good configuration for the SDRC to deal with buggy
+ * bootloaders.
+ */
 void __init omap2_sdrc_init(struct omap_sdrc_params *sp)
 {
 	u32 l;
@@ -90,4 +101,10 @@ void __init omap2_sdrc_init(struct omap_sdrc_params *sp)
 	sdrc_write_reg(l, SDRC_SYSCONFIG);
 
 	sdrc_init_params = sp;
+
+	/* XXX Enable SRFRONIDLEREQ here also? */
+	l = (1 << SDRC_POWER_EXTCLKDIS_SHIFT) |
+		(1 << SDRC_POWER_PWDENA_SHIFT) |
+		(1 << SDRC_POWER_PAGEPOLICY_SHIFT);
+	sdrc_write_reg(l, SDRC_POWER);
 }


