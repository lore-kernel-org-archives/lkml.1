Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZESA2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZESA2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 20:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZESA2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 20:28:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36963 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZESA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 20:28:32 -0400
Date: Mon, 18 May 2009 20:28:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
       me@bobcopeland.com, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ath5k: prevent infinite loop
Message-ID: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After updating my laptop with the latest kernel (had 2.6.26 before that),
my laptop load went to 100%. The daemon phy0 was at 99.9% of the CPU.
Luckily I compiled with a preempt kernel otherwise this would have
been a lock up.

Using ftrace to dig into the problem I found that that the ath5k driver
was in an infinite loop. The code in ath5k_get_linear_pcdac_min has:

	pwr_i = pwrR[0];
	do {
		pwr_i--;
		tmp = (s8) ath5k_get_interpolated_value(pwr_i,
						pwrR[0], pwrR[1],
						stepR[0], stepR[1]);
	} while (tmp > 1);


But ath5k_get_interpolated returns stepR[0] if pwrR[0] == pwrR[1] or 
stepR[0] == stepR[1]. The pwr_i is ignored and we enter an infinite loop
because tmp never changes between iterations. Using ftrace, I was able to 
determine that is exactly what happened in the case of my laptop.

This patch tries to keep the same result that would happen when this case 
occurs. That is, the pwr_i becomes a minimal number. I used the minimum 
number that a signed short may be to initialize the min pwrL and pwrR.
Then if the case that the code would cause an infinite loop, we bypass it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 9e2faae..2c916fc 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1473,6 +1473,8 @@ ath5k_get_interpolated_value(s16 target, s16 x_left, s16 x_right,
 	return result;
 }
 
+#define MIN_PWR (-32768)
+
 /*
  * Find vertical boundary (min pwr) for the linear PCDAC curve.
  *
@@ -1486,29 +1488,32 @@ ath5k_get_linear_pcdac_min(const u8 *stepL, const u8 *stepR,
 				const s16 *pwrL, const s16 *pwrR)
 {
 	s8 tmp;
-	s16 min_pwrL, min_pwrR;
+	s16 min_pwrL = MIN_PWR, min_pwrR = MIN_PWR;
 	s16 pwr_i = pwrL[0];
 
-	do {
-		pwr_i--;
-		tmp = (s8) ath5k_get_interpolated_value(pwr_i,
-						pwrL[0], pwrL[1],
-						stepL[0], stepL[1]);
-
-	} while (tmp > 1);
-
-	min_pwrL = pwr_i;
+	/* Avoid infinite loop */
+	if (pwrL[0] != pwrL[1] && stepL[0] != stepL[1]) {
+		do {
+			pwr_i--;
+			tmp = (s8) ath5k_get_interpolated_value(pwr_i,
+							pwrL[0], pwrL[1],
+							stepL[0], stepL[1]);
+		} while (tmp > 1);
+		min_pwrL = pwr_i;
+	}
 
 	pwr_i = pwrR[0];
-	do {
-		pwr_i--;
-		tmp = (s8) ath5k_get_interpolated_value(pwr_i,
-						pwrR[0], pwrR[1],
-						stepR[0], stepR[1]);
-
-	} while (tmp > 1);
 
-	min_pwrR = pwr_i;
+	/* Avoid infinite loop */
+	if (pwrR[0] != pwrR[1] && stepR[0] != stepR[1]) {
+		do {
+			pwr_i--;
+			tmp = (s8) ath5k_get_interpolated_value(pwr_i,
+							pwrR[0], pwrR[1],
+							stepR[0], stepR[1]);
+		} while (tmp > 1);
+		min_pwrR = pwr_i;
+	}
 
 	/* Keep the right boundary so that it works for both curves */
 	return max(min_pwrL, min_pwrR);
