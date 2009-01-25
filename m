Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZAYNOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZAYNOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZAYNNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:13:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35931 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbZAYNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:13:49 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, Tony Lindgren <tony@atomide.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] ARM: OMAP: Fix gpio.c compile on 15xx with CONFIG_DEBUGFS
Date: Sun, 25 Jan 2009 14:13:45 +0100
Message-Id: <1232889227-20887-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232889227-20887-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090125123023.GA12248@pengutronix.de>
 <1232889227-20887-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

There are no wakeup registers on 15xx, and suspend_wakeup
does not exist in the struct gpio_bank.

Without this fix we'll get "arch/arm/plat-omap/gpio.c:1792:
error: 'struct gpio_bank' has no member named 'suspend_wakeup'"
as noted by Russell King.

Note that the ifdefs will be cleaned up once the omap gpio
code gets split into omap1 and omap2 specific parts.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

(cherry picked from commit 3a26e3318bc2ceec340f242c6ee7074becdc7219)
---
 arch/arm/plat-omap/gpio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 9908710..4131e06 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -1816,6 +1816,8 @@ static int dbg_gpio_show(struct seq_file *s, void *unused)
 /* FIXME for at least omap2, show pullup/pulldown state */
 
 			irqstat = irq_desc[irq].status;
+#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP24XX) ||	\
+		defined(CONFIG_ARCH_OMAP34XX)
 			if (is_in && ((bank->suspend_wakeup & mask)
 					|| irqstat & IRQ_TYPE_SENSE_MASK)) {
 				char	*trigger = NULL;
@@ -1845,6 +1847,7 @@ static int dbg_gpio_show(struct seq_file *s, void *unused)
 						(bank->suspend_wakeup & mask)
 							? " wakeup" : "");
 			}
+#endif
 			seq_printf(s, "\n");
 		}
 
-- 
1.5.6.5

