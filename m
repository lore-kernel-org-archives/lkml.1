Return-Path: <linux-kernel-owner+w=401wt.eu-S1767043AbXDEPQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767043AbXDEPQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767044AbXDEPQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:16:46 -0400
Received: from nlpi043.sbcis.sbc.com ([207.115.36.72]:25781 "EHLO
	nlpi043.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767043AbXDEPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:16:44 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 11:15:57 -0400
From: Tony Lindgren <tony@atomide.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 53/90] ARM: OMAP: Fix warning in timer32k.c
Message-ID: <20070405151555.GJ24297@atomide.com>
References: <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <20070404121421.eb90a58d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CXFpZVxO6m2Ol4tQ"
Content-Disposition: inline
In-Reply-To: <20070404121421.eb90a58d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Randy Dunlap <randy.dunlap@oracle.com> [070404 15:14]:
> On Wed,  4 Apr 2007 14:05:32 -0400 Tony Lindgren wrote:
> 
> > From: Dirk Behme <dirk.behme_at_gmail.com>
> 
> NAK the obfuscated email address.
> And in the S-O-B line as well.

Updated patch following. I'll also fix it in other patches
from Dirk:

55/90 ARM: OMAP: H3 workqueue fixes
56/90 ARM: OMAP: Make board palmz71 compile again
64/90 ARM: OMAP: Fix warning in pm.c

Tony

--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0053-ARM-OMAP-Fix-warning-in-timer32k.c.txt"

>From b78b9979fcdfd68604570f51ece0c43f17cd37ae Mon Sep 17 00:00:00 2001
From: Dirk Behme <dirk.behme@gmail.com>
Date: Thu, 25 Jan 2007 16:26:19 -0800
Subject: [PATCH 53/90] ARM: OMAP: Fix warning in timer32k.c

ARM: OMAP: Fix warning in timer32k.c if CONFIG_NO_IDLE_HZ
isn't set:

arch/arm/plat-omap/timer32k.c:221: warning:
'omap_32k_timer_handler' defined but not used

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/timer32k.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/plat-omap/timer32k.c b/arch/arm/plat-omap/timer32k.c
index c37d7b4..a98de90 100644
--- a/arch/arm/plat-omap/timer32k.c
+++ b/arch/arm/plat-omap/timer32k.c
@@ -217,6 +217,18 @@ static inline irqreturn_t _omap_32k_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+	_omap_32k_timer_interrupt(irq, dev_id);
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_NO_IDLE_HZ
 static irqreturn_t omap_32k_timer_handler(int irq, void *dev_id)
 {
 	unsigned long now;
@@ -233,18 +245,6 @@ static irqreturn_t omap_32k_timer_handler(int irq, void *dev_id)
 	return _omap_32k_timer_interrupt(irq, dev_id);
 }
 
-static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
-{
-	unsigned long flags;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
-	_omap_32k_timer_interrupt(irq, dev_id);
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
-	return IRQ_HANDLED;
-}
-
-#ifdef CONFIG_NO_IDLE_HZ
 /*
  * Programs the next timer interrupt needed. Called when dynamic tick is
  * enabled, and to reprogram the ticks to skip from pm_idle. Note that
-- 
1.4.4.2


--CXFpZVxO6m2Ol4tQ--
