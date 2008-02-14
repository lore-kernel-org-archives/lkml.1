Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbYBNPQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbYBNPQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYBNPQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:16:18 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:57965 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbYBNPQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:16:14 -0500
Date: Thu, 14 Feb 2008 16:16:09 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/6] drivers/atm: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.58.0802141615470.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In each case below, I have followed the original semantics, but in
drivers/atm/eni.c and drivers/atm/horizon.c, I have some doubts as to
whether the original semantics is correct.  In drivers/atm/eni.c, is the
division intended to be by div or by div-1?  In drivers/atm/horizon.c, it
seems strange that "case round_down" is implemented by DIV_ROUND_UP, twice.
The round_down and default (ie round_up) cases seem to be inversed.

---

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/atm/eni.c b/drivers/atm/eni.c
--- a/drivers/atm/eni.c 2007-07-20 15:28:28.000000000 +0200
+++ b/drivers/atm/eni.c 2008-02-13 20:50:10.000000000 +0100
@@ -1270,7 +1270,7 @@ static int comp_tx(struct eni_dev *eni_d
 			if (*pre < 3) (*pre)++; /* else fail later */
 			div = pre_div[*pre]*-*pcr;
 			DPRINTK("max div %d\n",div);
-			*res = (TS_CLOCK+div-1)/div-1;
+			*res = DIV_ROUND_UP(TS_CLOCK, div)-1;
 		}
 		if (*res < 0) *res = 0;
 		if (*res > MID_SEG_MAX_RATE) *res = MID_SEG_MAX_RATE;
diff -u -p a/drivers/atm/horizon.c b/drivers/atm/horizon.c
--- a/drivers/atm/horizon.c 2007-11-08 18:33:26.000000000 +0100
+++ b/drivers/atm/horizon.c 2008-02-13 20:50:13.000000000 +0100
@@ -635,7 +635,7 @@ static int make_rate (const hrz_dev * de
 		// take care of rounding
 		switch (r) {
 			case round_down:
-				pre = (br+(c<<div)-1)/(c<<div);
+				pre = DIV_ROUND_UP(br, c<<div);
 				// but p must be non-zero
 				if (!pre)
 					pre = 1;
@@ -668,7 +668,7 @@ static int make_rate (const hrz_dev * de
 			// take care of rounding
 			switch (r) {
 				case round_down:
-					pre = (br+(c<<div)-1)/(c<<div);
+					pre = DIV_ROUND_UP(br, c<<div);
 					break;
 				case round_nearest:
 					pre = (br+(c<<div)/2)/(c<<div);
@@ -698,7 +698,7 @@ got_it:
 		if (bits)
 			*bits = (div<<CLOCK_SELECT_SHIFT) | (pre-1);
 		if (actual) {
-			*actual = (br + (pre<<div) - 1) / (pre<<div);
+			*actual = DIV_ROUND_UP(br, pre<<div);
 			PRINTD (DBG_QOS, "actual rate: %u", *actual);
 		}
 		return 0;
@@ -1967,7 +1967,7 @@ static int __devinit hrz_init (hrz_dev *
   // Set the max AAL5 cell count to be just enough to contain the
   // largest AAL5 frame that the user wants to receive
   wr_regw (dev, MAX_AAL5_CELL_COUNT_OFF,
-	   (max_rx_size + ATM_AAL5_TRAILER + ATM_CELL_PAYLOAD - 1) / ATM_CELL_PAYLOAD);
+	   DIV_ROUND_UP(max_rx_size + ATM_AAL5_TRAILER, ATM_CELL_PAYLOAD));

   // Enable receive
   wr_regw (dev, RX_CONFIG_OFF, rd_regw (dev, RX_CONFIG_OFF) | RX_ENABLE);
diff -u -p a/drivers/atm/zatm.c b/drivers/atm/zatm.c
--- a/drivers/atm/zatm.c	2007-07-20 15:28:28.000000000 +0200
+++ b/drivers/atm/zatm.c	2008-02-14 07:26:36.000000000 +0100
@@ -496,8 +496,8 @@ static int open_rx_first(struct atm_vcc
 			vcc->qos.rxtp.max_sdu = 65464;
 			/* fix this - we may want to receive 64kB SDUs
 			   later */
-		cells = (vcc->qos.rxtp.max_sdu+ATM_AAL5_TRAILER+
-		    ATM_CELL_PAYLOAD-1)/ATM_CELL_PAYLOAD;
+		cells = DIV_ROUND_UP(vcc->qos.rxtp.max_sdu+ATM_AAL5_TRAILER,
+				     ATM_CELL_PAYLOAD);
 		zatm_vcc->pool = pool_index(cells*ATM_CELL_PAYLOAD);
 	}
 	else {
@@ -820,7 +820,7 @@ static int alloc_shaper(struct atm_dev *
 			}
 			else {
 				i = 255;
-				m = (ATM_OC3_PCR*255+max-1)/max;
+				m = DIV_ROUND_UP(ATM_OC3_PCR*255, max);
 			}
 		}
 		if (i > m) {
