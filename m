Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYCNFU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYCNFU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbYCNFUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:20:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbYCNFUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iY87Mbh3yr0UcAQNDl9mI+QaSBpiEvxKTdSaI9hEEP1ow670CQYzlPqyeUT1mb1OsGHfnKpOI0kzK/+h1TFjfwpvTdVwDbp9hQD0LLRQdsIuNJyg5dSCyljnfacLGzrtVii8MUC3jUkePxHyvTiPwr0kFXCtS3NZ5KoV33UJI8I=
Subject: [PATCH 04/10] b43: replace limit_value macro with clamp_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:20:35 -0700
Message-Id: <1205472035.19712.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel-provided clamp_val is identical, delete the private
limit_value helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/b43.h  |   16 ----------------
 drivers/net/wireless/b43/lo.c   |    4 ++--
 drivers/net/wireless/b43/main.c |    8 ++++----
 drivers/net/wireless/b43/phy.c  |   24 ++++++++++++------------
 4 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index f13346b..2ae3094 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -843,22 +843,6 @@ static inline bool __b43_warn_on_dummy(bool x) { return x; }
 # define B43_WARN_ON(x)	__b43_warn_on_dummy(unlikely(!!(x)))
 #endif
 
-/** Limit a value between two limits */
-#ifdef limit_value
-# undef limit_value
-#endif
-#define limit_value(value, min, max)  \
-	({						\
-		typeof(value) __value = (value);	\
-		typeof(value) __min = (min);		\
-		typeof(value) __max = (max);		\
-		if (__value < __min)			\
-			__value = __min;		\
-		else if (__value > __max)		\
-			__value = __max;		\
-		__value;				\
-	})
-
 /* Convert an integer to a Q5.2 value */
 #define INT_TO_Q52(i)	((i) << 2)
 /* Convert a Q5.2 value to an integer (precision loss!) */
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index d890f36..ee8d1b1 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -366,7 +366,7 @@ static void lo_measure_txctl_values(struct b43_wldev *dev)
 		if (lb_gain > 10) {
 			radio_pctl_reg = 0;
 			pga = abs(10 - lb_gain) / 6;
-			pga = limit_value(pga, 0, 15);
+			pga = clamp_val(pga, 0, 15);
 		} else {
 			int cmp_val;
 			int tmp;
@@ -510,7 +510,7 @@ static void lo_measure_gain_values(struct b43_wldev *dev,
 			phy->lna_lod_gain = 1;
 			trsw_rx_gain -= 8;
 		}
-		trsw_rx_gain = limit_value(trsw_rx_gain, 0, 0x2D);
+		trsw_rx_gain = clamp_val(trsw_rx_gain, 0, 0x2D);
 		phy->pga_gain = trsw_rx_gain / 3;
 		if (phy->pga_gain >= 5) {
 			phy->pga_gain -= 5;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 51dfce1..a8d3f86 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1052,10 +1052,10 @@ static void handle_irq_noise(struct b43_wldev *dev)
 	/* Get the noise samples. */
 	B43_WARN_ON(dev->noisecalc.nr_samples >= 8);
 	i = dev->noisecalc.nr_samples;
-	noise[0] = limit_value(noise[0], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
-	noise[1] = limit_value(noise[1], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
-	noise[2] = limit_value(noise[2], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
-	noise[3] = limit_value(noise[3], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[0] = clamp_val(noise[0], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[1] = clamp_val(noise[1], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[2] = clamp_val(noise[2], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[3] = clamp_val(noise[3], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
 	dev->noisecalc.samples[i][0] = phy->nrssi_lt[noise[0]];
 	dev->noisecalc.samples[i][1] = phy->nrssi_lt[noise[1]];
 	dev->noisecalc.samples[i][2] = phy->nrssi_lt[noise[2]];
diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 71507b2..bd8413f 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -1572,7 +1572,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
 		 * Essentially, what we do here is resetting all NRSSI LT
-		 * entries to -32 (see the limit_value() in nrssi_hw_update())
+		 * entries to -32 (see the clamp_val() in nrssi_hw_update())
 		 */
 		b43_nrssi_hw_update(dev, 0xFFFF);	//FIXME?
 		b43_calc_nrssi_threshold(dev);
@@ -1634,13 +1634,13 @@ static s8 b43_phy_estimate_power_out(struct b43_wldev *dev, s8 tssi)
 	switch (phy->type) {
 	case B43_PHYTYPE_A:
 		tmp += 0x80;
-		tmp = limit_value(tmp, 0x00, 0xFF);
+		tmp = clamp_val(tmp, 0x00, 0xFF);
 		dbm = phy->tssi2dbm[tmp];
 		//TODO: There's a FIXME on the specs
 		break;
 	case B43_PHYTYPE_B:
 	case B43_PHYTYPE_G:
-		tmp = limit_value(tmp, 0x00, 0x3F);
+		tmp = clamp_val(tmp, 0x00, 0x3F);
 		dbm = phy->tssi2dbm[tmp];
 		break;
 	default:
@@ -1699,8 +1699,8 @@ void b43_put_attenuation_into_ranges(struct b43_wldev *dev,
 		break;
 	}
 
-	*_rfatt = limit_value(rfatt, rf_min, rf_max);
-	*_bbatt = limit_value(bbatt, bb_min, bb_max);
+	*_rfatt = clamp_val(rfatt, rf_min, rf_max);
+	*_bbatt = clamp_val(bbatt, bb_min, bb_max);
 }
 
 /* http://bcm-specs.sipsolutions.net/RecalculateTransmissionPower */
@@ -1795,7 +1795,7 @@ void b43_phy_xmitpower(struct b43_wldev *dev)
 			/* Get desired power (in Q5.2) */
 			desired_pwr = INT_TO_Q52(phy->power_level);
 			/* And limit it. max_pwr already is Q5.2 */
-			desired_pwr = limit_value(desired_pwr, 0, max_pwr);
+			desired_pwr = clamp_val(desired_pwr, 0, max_pwr);
 			if (b43_debug(dev, B43_DBG_XMITPOWER)) {
 				b43dbg(dev->wl,
 				       "Current TX power output: " Q52_FMT
@@ -1908,7 +1908,7 @@ static inline
 		f = q;
 		i++;
 	} while (delta >= 2);
-	entry[index] = limit_value(b43_tssi2dbm_ad(m1 * f, 8192), -127, 128);
+	entry[index] = clamp_val(b43_tssi2dbm_ad(m1 * f, 8192), -127, 128);
 	return 0;
 }
 
@@ -2452,7 +2452,7 @@ void b43_nrssi_hw_update(struct b43_wldev *dev, u16 val)
 	for (i = 0; i < 64; i++) {
 		tmp = b43_nrssi_hw_read(dev, i);
 		tmp -= val;
-		tmp = limit_value(tmp, -32, 31);
+		tmp = clamp_val(tmp, -32, 31);
 		b43_nrssi_hw_write(dev, i, tmp);
 	}
 }
@@ -2469,7 +2469,7 @@ void b43_nrssi_mem_update(struct b43_wldev *dev)
 		tmp = (i - delta) * phy->nrssislope;
 		tmp /= 0x10000;
 		tmp += 0x3A;
-		tmp = limit_value(tmp, 0, 0x3F);
+		tmp = clamp_val(tmp, 0, 0x3F);
 		phy->nrssi_lt[i] = tmp;
 	}
 }
@@ -2906,7 +2906,7 @@ void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 			} else
 				threshold = phy->nrssi[1] - 5;
 
-			threshold = limit_value(threshold, 0, 0x3E);
+			threshold = clamp_val(threshold, 0, 0x3E);
 			b43_phy_read(dev, 0x0020);	/* dummy read */
 			b43_phy_write(dev, 0x0020,
 				      (((u16) threshold) << 8) | 0x001C);
@@ -2957,7 +2957,7 @@ void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 			else
 				a += 32;
 			a = a >> 6;
-			a = limit_value(a, -31, 31);
+			a = clamp_val(a, -31, 31);
 
 			b = b * (phy->nrssi[1] - phy->nrssi[0]);
 			b += (phy->nrssi[0] << 6);
@@ -2966,7 +2966,7 @@ void b43_calc_nrssi_threshold(struct b43_wldev *dev)
 			else
 				b += 32;
 			b = b >> 6;
-			b = limit_value(b, -31, 31);
+			b = clamp_val(b, -31, 31);
 
 			tmp_u16 = b43_phy_read(dev, 0x048A) & 0xF000;
 			tmp_u16 |= ((u32) b & 0x0000003F);
-- 
1.5.4.4.653.g7cf1e


