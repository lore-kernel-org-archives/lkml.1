Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbZHBIuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbZHBIuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZHBIuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:50:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54137 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZHBIuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:50:11 -0400
Date: Sun, 2 Aug 2009 10:48:27 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/15] arch/powerpc: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021048090.15557@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/kernel/time.c          |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index eae4511..edb1edb 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -479,7 +479,8 @@ static int __init iSeries_tb_recal(void)
 		unsigned long tb_ticks = tb - iSeries_recal_tb;
 		unsigned long titan_usec = (titan - iSeries_recal_titan) >> 12;
 		unsigned long new_tb_ticks_per_sec   = (tb_ticks * USEC_PER_SEC)/titan_usec;
-		unsigned long new_tb_ticks_per_jiffy = (new_tb_ticks_per_sec+(HZ/2))/HZ;
+		unsigned long new_tb_ticks_per_jiffy =
+			DIV_ROUND_CLOSEST(new_tb_ticks_per_sec, HZ);
 		long tick_diff = new_tb_ticks_per_jiffy - tb_ticks_per_jiffy;
 		char sign = '+';		
 		/* make sure tb_ticks_per_sec and tb_ticks_per_jiffy are consistent */
