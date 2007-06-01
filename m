Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbXFAIiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbXFAIiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbXFAIhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:37:55 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41026 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXFAIhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:37:54 -0400
Date: Fri, 1 Jun 2007 17:36:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] smc91x: sh solution engine fixes.
Message-ID: <20070601083648.GA11035@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jeff@garzik.org>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current smc91x I/O routines ifdef the solution engine subtypes
individually, which is rather bogus, as they can simply use
CONFIG_SOLUTION_ENGINE instead. This fixes it for some of the other
solution engines that weren't included in the ifdef list (SH7206
specifically).

There are also inb/outb definitions which are totally bogus (missing
brackets in _both_ cases, SMC_CAN_USE_8BIT == 0, and even better, they
try to use a 16-bit access to fake 8-bit access). Kill that nonsense off
completely.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/net/smc91x.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 111f23d..506bffc 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -281,17 +281,14 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
 
 #elif   defined(CONFIG_SUPERH)
 
-#if defined(CONFIG_SH_7780_SOLUTION_ENGINE) || defined(CONFIG_SH_7722_SOLUTION_ENGINE)
+#ifdef CONFIG_SOLUTION_ENGINE
 #define SMC_CAN_USE_8BIT       0
 #define SMC_CAN_USE_16BIT      1
 #define SMC_CAN_USE_32BIT      0
 #define SMC_IO_SHIFT           0
 #define SMC_NOWAIT             1
 
-#define SMC_inb(a, r)          (inw((a) + ((r)&~1)) >> (8*(r%2)))&0xff
 #define SMC_inw(a, r)          inw((a) + (r))
-#define SMC_outb(v, a, r)      outw(((inw((a)+((r)&~1))*(0xff<<8*(r%2)))) | ((v)<<(8*(r&2)))), (a) + ((r)&~1))
-
 #define SMC_outw(v, a, r)      outw(v, (a) + (r))
 #define SMC_insw(a, r, p, l)   insw((a) + (r), p, l)
 #define SMC_outsw(a, r, p, l)  outsw((a) + (r), p, l)
