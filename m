Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZCZMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZCZMSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZCZMSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:18:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58510 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZCZMSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:18:11 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: broonie@sirena.org.uk
Cc: linux@arm.linux.org.uk, dbaryshkov@gmail.com, alsa-devel@alsa-project.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] pxa2xx-ac97: fix displaying GSR after reset timeout
Date: Thu, 26 Mar 2009 13:18:03 +0100
Message-Id: <1238069883-12445-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325103406.GA20936@sirena.org.uk>
References: <20090325103406.GA20936@sirena.org.uk>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable gsr_bit is set in isr. It is however set to 0 and interrupts are
disabled prior to reset. Hence it doesn't make a lot of sense to show the
content of gsr_bit in case of a reset timeout.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 sound/arm/pxa2xx-ac97-lib.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/arm/pxa2xx-ac97-lib.c b/sound/arm/pxa2xx-ac97-lib.c
index 35afd0c..bbb71ae 100644
--- a/sound/arm/pxa2xx-ac97-lib.c
+++ b/sound/arm/pxa2xx-ac97-lib.c
@@ -199,6 +199,8 @@ static inline void pxa_ac97_cold_pxa3xx(void)
 
 bool pxa2xx_ac97_try_warm_reset(struct snd_ac97 *ac97)
 {
+	unsigned long gsr;
+
 #ifdef CONFIG_PXA25x
 	if (cpu_is_pxa25x())
 		pxa_ac97_warm_pxa25x();
@@ -215,10 +217,10 @@ bool pxa2xx_ac97_try_warm_reset(struct snd_ac97 *ac97)
 	else
 #endif
 		BUG();
-
-	if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR))) {
+	gsr = GSR | gsr_bits;
+	if (!(gsr & (GSR_PCR | GSR_SCR))) {
 		printk(KERN_INFO "%s: warm reset timeout (GSR=%#lx)\n",
-				 __func__, gsr_bits);
+				 __func__, gsr);
 
 		return false;
 	}
@@ -229,6 +231,8 @@ EXPORT_SYMBOL_GPL(pxa2xx_ac97_try_warm_reset);
 
 bool pxa2xx_ac97_try_cold_reset(struct snd_ac97 *ac97)
 {
+	unsigned long gsr;
+
 #ifdef CONFIG_PXA25x
 	if (cpu_is_pxa25x())
 		pxa_ac97_cold_pxa25x();
@@ -246,9 +250,10 @@ bool pxa2xx_ac97_try_cold_reset(struct snd_ac97 *ac97)
 #endif
 		BUG();
 
-	if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR))) {
+	gsr = GSR | gsr_bits;
+	if (!(gsr & (GSR_PCR | GSR_SCR))) {
 		printk(KERN_INFO "%s: cold reset timeout (GSR=%#lx)\n",
-				 __func__, gsr_bits);
+				 __func__, gsr);
 
 		return false;
 	}
-- 
1.6.2

