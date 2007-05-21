Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbXEUKLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbXEUKLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761445AbXEUKJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:19 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1813 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbXEUKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:12 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505443:sNHT25751047"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 18/32] Blackfin arch: issue reset via SWRST so we dont clobber the watchdog state
Date: Mon, 21 May 2007 18:09:26 +0800
Message-Id: <11797421862498-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf533/head.S |   68 +++++++++-----------------------------
 arch/blackfin/mach-bf537/head.S |   70 +++++++++------------------------------
 arch/blackfin/mach-bf561/head.S |   70 +++++++++------------------------------
 3 files changed, 48 insertions(+), 160 deletions(-)

diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 7cb8258..1a54ff5 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -481,66 +481,30 @@ ENTRY(_bfin_reset)
 	[p0] = r0;
 	SSYNC;
 
-	/* Disable the WDOG TIMER */
-	p0.h = hi(WDOG_CTL);
-	p0.l = lo(WDOG_CTL);
-	r0.l = 0xAD6;
-	w[p0] = r0.l;
-	SSYNC;
-
-	/* Clear the sticky bit incase it is already set */
-	p0.h = hi(WDOG_CTL);
-	p0.l = lo(WDOG_CTL);
-	r0.l = 0x8AD6;
-	w[p0] = r0.l;
+	/* make sure SYSCR is set to use BMODE */
+	P0.h = hi(SYSCR);
+	P0.l = lo(SYSCR);
+	R0.l = 0x0;
+	W[P0] = R0.l;
 	SSYNC;
 
-	/* Program the count value */
-	R0.l = 0x100;
-	R0.h = 0x0;
-	P0.h = hi(WDOG_CNT);
-	P0.l = lo(WDOG_CNT);
-	[P0] = R0;
+	/* issue a system soft reset */
+	P1.h = hi(SWRST);
+	P1.l = lo(SWRST);
+	R1.l = 0x0007;
+	W[P1] = R1;
 	SSYNC;
 
-	/* Program WDOG_STAT if necessary */
-	P0.h = hi(WDOG_CTL);
-	P0.l = lo(WDOG_CTL);
-	R0 = W[P0](Z);
-	CC = BITTST(R0,1);
-	if !CC JUMP .LWRITESTAT;
-	CC = BITTST(R0,2);
-	if !CC JUMP .LWRITESTAT;
-	JUMP .LSKIP_WRITE;
-
-.LWRITESTAT:
-	/* When watch dog timer is enabled, a write to STAT will load the contents of CNT to STAT */
-	R0 = 0x0000(z);
-	P0.h = hi(WDOG_STAT);
-	P0.l = lo(WDOG_STAT)
-	[P0] = R0;
-	SSYNC;
-
-.LSKIP_WRITE:
-	/* Enable the reset event */
-	P0.h = hi(WDOG_CTL);
-	P0.l = lo(WDOG_CTL);
-	R0 = W[P0](Z);
-	BITCLR(R0,1);
-	BITCLR(R0,2);
-	W[P0] = R0.L;
-	SSYNC;
-	NOP;
-
-	/* Enable the wdog counter */
-	R0 = W[P0](Z);
-	BITCLR(R0,4);
-	W[P0] = R0.L;
+	/* clear system soft reset */
+	R0.l = 0x0000;
+	W[P0] = R0;
 	SSYNC;
 
-	IDLE;
+	/* issue core reset */
+	raise 1;
 
 	RTS;
+ENDPROC(_bfin_reset)
 
 #if CONFIG_DEBUG_KERNEL_START
 debug_kernel_start_trap:
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index de78e42..aafc686 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -517,68 +517,30 @@ _delay_lab1_end:
 	[p0] = r0;
 	SSYNC;
 
-	/* Disable the WDOG TIMER */
-	p0.h = hi(WDOG_CTL);
-	p0.l = lo(WDOG_CTL);
-	r0.l = 0xAD6;
-	w[p0] = r0.l;
+	/* make sure SYSCR is set to use BMODE */
+	P0.h = hi(SYSCR);
+	P0.l = lo(SYSCR);
+	R0.l = 0x0;
+	W[P0] = R0.l;
 	SSYNC;
 
-	/* Clear the sticky bit incase it is already set */
-	p0.h = hi(WDOG_CTL);
-	p0.l = lo(WDOG_CTL);
-	r0.l = 0x8AD6;
-	w[p0] = r0.l;
+	/* issue a system soft reset */
+	P1.h = hi(SWRST);
+	P1.l = lo(SWRST);
+	R1.l = 0x0007;
+	W[P1] = R1;
 	SSYNC;
 
-	/* Program the count value */
-	R0.l = 0x100;
-	R0.h = 0x0;
-	P0.h = hi(WDOG_CNT);
-	P0.l = lo(WDOG_CNT);
-	[P0] = R0;
-	SSYNC;
-
-	/* Program WDOG_STAT if necessary */
-	P0.h = hi(WDOG_CTL);
-	P0.l = lo(WDOG_CTL);
-	R0 = W[P0](Z);
-	CC = BITTST(R0,1);
-	if !CC JUMP .LWRITESTAT;
-	CC = BITTST(R0,2);
-	if !CC JUMP .LWRITESTAT;
-	JUMP .LSKIP_WRITE;
-
-.LWRITESTAT:
-	/* When watch dog timer is enabled,
-	 * a write to STAT will load the contents of CNT to STAT
-	 */
-	R0 = 0x0000(z);
-	P0.h = hi(WDOG_STAT);
-	P0.l = lo(WDOG_STAT)
-	[P0] = R0;
-	SSYNC;
-
-.LSKIP_WRITE:
-	/* Enable the reset event */
-	P0.h = hi(WDOG_CTL);
-	P0.l = lo(WDOG_CTL);
-	R0 = W[P0](Z);
-	BITCLR(R0,1);
-	BITCLR(R0,2);
-	W[P0] = R0.L;
-	SSYNC;
-	NOP;
-
-	/* Enable the wdog counter */
-	R0 = W[P0](Z);
-	BITCLR(R0,4);
-	W[P0] = R0.L;
+	/* clear system soft reset */
+	R0.l = 0x0000;
+	W[P0] = R0;
 	SSYNC;
 
-	IDLE;
+	/* issue core reset */
+	raise 1;
 
 	RTS;
+ENDPROC(_bfin_reset)
 
 .data
 
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 462c39e..04f3ac3 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -427,68 +427,30 @@ ENTRY(_bfin_reset)
 	[p0] = r0;
 	SSYNC;
 
-	/* Disable the WDOG TIMER */
-	p0.h = hi(WDOGA_CTL);
-	p0.l = lo(WDOGA_CTL);
-	r0.l = 0xAD6;
-	w[p0] = r0.l;
+	/* make sure SYSCR is set to use BMODE */
+	P0.h = hi(SICA_SYSCR);
+	P0.l = lo(SICA_SYSCR);
+	R0.l = 0x0;
+	W[P0] = R0.l;
 	SSYNC;
 
-	/* Clear the sticky bit incase it is already set */
-	p0.h = hi(WDOGA_CTL);
-	p0.l = lo(WDOGA_CTL);
-	r0.l = 0x8AD6;
-	w[p0] = r0.l;
-	SSYNC;
-
-	/* Program the count value */
-	R0.l = 0x100;
-	R0.h = 0x0;
-	P0.h = hi(WDOGA_CNT);
-	P0.l = lo(WDOGA_CNT);
-	[P0] = R0;
+	/* issue a system soft reset */
+	P1.h = hi(SICA_SWRST);
+	P1.l = lo(SICA_SWRST);
+	R1.l = 0x0007;
+	W[P1] = R1;
 	SSYNC;
 
-	/* Program WDOG_STAT if necessary */
-	P0.h = hi(WDOGA_CTL);
-	P0.l = lo(WDOGA_CTL);
-	R0 = W[P0](Z);
-	CC = BITTST(R0,1);
-	if !CC JUMP .LWRITESTAT;
-	CC = BITTST(R0,2);
-	if !CC JUMP .LWRITESTAT;
-	JUMP .LSKIP_WRITE;
-
-.LWRITESTAT:
-	/* When watch dog timer is enabled,
-	 * a write to STAT will load the contents of CNT to STAT
-	 */
-	R0 = 0x0000(z);
-	P0.h = hi(WDOGA_STAT);
-	P0.l = lo(WDOGA_STAT)
-	[P0] = R0;
-	SSYNC;
-
-.LSKIP_WRITE:
-	/* Enable the reset event */
-	P0.h = hi(WDOGA_CTL);
-	P0.l = lo(WDOGA_CTL);
-	R0 = W[P0](Z);
-	BITCLR(R0,1);
-	BITCLR(R0,2);
-	W[P0] = R0.L;
-	SSYNC;
-	NOP;
-
-	/* Enable the wdog counter */
-	R0 = W[P0](Z);
-	BITCLR(R0,4);
-	W[P0] = R0.L;
+	/* clear system soft reset */
+	R0.l = 0x0000;
+	W[P0] = R0;
 	SSYNC;
 
-	IDLE;
+	/* issue core reset */
+	raise 1;
 
 	RTS;
+ENDPROC(_bfin_reset)
 
 .data
 
-- 
1.5.1.2
