Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYELEKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYELEKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYELEKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:10:11 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:11948 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYELEKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:10:09 -0400
X-IronPort-AV: E=Sophos;i="4.27,470,1204520400"; 
   d="scan'208";a="53384140"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] Blackfin SPORT UART Driver: rewrite assembly with better constraints (and proper clobber lists) so gcc can do a better job
Date: Mon, 12 May 2008 12:10:09 +0800
Message-Id: <1210565409-3655-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210565409-3655-1-git-send-email-cooloney@kernel.org>
References: <1210565409-3655-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_sport_uart.c |   54 ++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index c31ca6f..786451d 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -102,15 +102,16 @@ static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
 {
 	pr_debug("%s value:%x\n", __FUNCTION__, value);
 	/* Place a Start and Stop bit */
-	__asm__ volatile (
-		"R2 = b#01111111100;\n\t"
-		"R3 = b#10000000001;\n\t"
-		"%0 <<= 2;\n\t"
-		"%0 = %0 & R2;\n\t"
-		"%0 = %0 | R3;\n\t"
-		:"=r"(value)
-		:"0"(value)
-		:"R2", "R3");
+	__asm__ __volatile__ (
+		"R2 = b#01111111100;"
+		"R3 = b#10000000001;"
+		"%0 <<= 2;"
+		"%0 = %0 & R2;"
+		"%0 = %0 | R3;"
+		: "=d"(value)
+		:
+		: "ASTAT", "R2", "R3"
+	);
 	pr_debug("%s value:%x\n", __FUNCTION__, value);
 
 	SPORT_PUT_TX(up, value);
@@ -120,27 +121,30 @@ static inline unsigned char rx_one_byte(struct sport_uart_port *up)
 {
 	unsigned int value;
 	unsigned char extract;
+	u32 tmp_mask1, tmp_mask2, tmp_shift, tmp;
 
 	value = SPORT_GET_RX32(up);
 	pr_debug("%s value:%x\n", __FUNCTION__, value);
 
 	/* Extract 8 bits data */
-	__asm__ volatile (
-		"R5 = 0;\n\t"
-		"P0 = 8;\n\t"
-		"R1 = 0x1801(Z);\n\t"
-		"R3 = 0x0300(Z);\n\t"
-		"R4 = 0;\n\t"
-		"LSETUP(loop_s, loop_e) LC0 = P0;\nloop_s:\t"
-		"R2 = extract(%1, R1.L)(Z);\n\t"
-		"R2 <<= R4;\n\t"
-		"R5 = R5 | R2;\n\t"
-		"R1 = R1 - R3;\nloop_e:\t"
-		"R4 += 1;\n\t"
-		"%0 = R5;\n\t"
-		:"=r"(extract)
-		:"r"(value)
-		:"P0", "R1", "R2","R3","R4", "R5");
+	__asm__ __volatile__ (
+		"%0 = 0;"
+		"%[mask1] = 0x1801(Z);"
+		"%[mask2] = 0x0300(Z);"
+		"%[shift] = 0;"
+		"LSETUP(.Lloop_s, .Lloop_e) LC0 = %[lc];"
+		".Lloop_s:"
+		"%[tmp] = extract(%[val], %[mask1].L)(Z);"
+		"%[tmp] <<= %[shift];"
+		"%0 = %0 | %[tmp];"
+		"%[mask1] = %[mask1] - %[mask2];"
+		".Lloop_e:"
+		"%[shift] += 1;"
+		: "=d"(extract), [shift]"=d"(tmp_shift), [tmp]"=d"(tmp),
+		  [mask1]"=d"(tmp_mask1), [mask2]"=d"(tmp_mask2)
+		: [val]"d"(value), [lc]"a"(8)
+		: "ASTAT", "LB0", "LC0", "LT0"
+	);
 
 	pr_debug("	extract:%x\n", extract);
 	return extract;
-- 
1.5.5
