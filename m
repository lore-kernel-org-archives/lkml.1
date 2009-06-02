Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZFBHMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZFBHMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZFBHLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46608 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbZFBHLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:45 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 03/11] Blackfin SPORT UART: rewrite inline assembly
Date: Tue,  2 Jun 2009 03:11:32 -0400
Message-Id: <1243926700-30485-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefuly the new version is easier to read, but in the process it declares
proper clobber lists and better constraints so that GCC can do a better
job at allocating free registers.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_sport_uart.c |   54 ++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 6687ccd..34b4ae0 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -101,15 +101,16 @@ static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
 {
 	pr_debug("%s value:%x\n", __func__, value);
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
+		: "d"(value)
+		: "ASTAT", "R2", "R3"
+	);
 	pr_debug("%s value:%x\n", __func__, value);
 
 	SPORT_PUT_TX(up, value);
@@ -118,27 +119,30 @@ static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
 static inline unsigned int rx_one_byte(struct sport_uart_port *up)
 {
 	unsigned int value, extract;
+	u32 tmp_mask1, tmp_mask2, tmp_shift, tmp;
 
 	value = SPORT_GET_RX32(up);
 	pr_debug("%s value:%x\n", __func__, value);
 
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
+		"%[extr] = 0;"
+		"%[mask1] = 0x1801(Z);"
+		"%[mask2] = 0x0300(Z);"
+		"%[shift] = 0;"
+		"LSETUP(.Lloop_s, .Lloop_e) LC0 = %[lc];"
+		".Lloop_s:"
+		"%[tmp] = extract(%[val], %[mask1].L)(Z);"
+		"%[tmp] <<= %[shift];"
+		"%[extr] = %[extr] | %[tmp];"
+		"%[mask1] = %[mask1] - %[mask2];"
+		".Lloop_e:"
+		"%[shift] += 1;"
+		: [val]"=d"(value), [extr]"=d"(extract), [shift]"=d"(tmp_shift), [tmp]"=d"(tmp),
+		  [mask1]"=d"(tmp_mask1), [mask2]"=d"(tmp_mask2)
+		: "d"(value), [lc]"a"(8)
+		: "ASTAT", "LB0", "LC0", "LT0"
+	);
 
 	pr_debug("	extract:%x\n", extract);
 	return extract;
-- 
1.6.3.1

