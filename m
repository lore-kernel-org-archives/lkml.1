Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYCNFVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYCNFVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbYCNFUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:20:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:39675 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbYCNFUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YEM9m9ovLl5KffaCrLI61IOrNT7Wyl+tMkBlShipvzU5ip7Fib9xNxzo6mJ2gc7N2HcbYDlihApNOFRYFC+AB8VNOhzRis2wQSxUzvWZycwlz1W2NYFAXQRb7UzkGYBGBHvcj9h7fP9d1uesJq9aOXqAmgQ+KHYLonlzj7doNaM=
Subject: [PATCH 05/10] b43legacy: replace limit_value macro with clamp_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:20:47 -0700
Message-Id: <1205472047.19712.20.camel@brick>
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
 drivers/net/wireless/b43legacy/b43legacy.h |   17 -----------------
 drivers/net/wireless/b43legacy/main.c      |    8 ++++----
 drivers/net/wireless/b43legacy/phy.c       |   14 +++++++-------
 drivers/net/wireless/b43legacy/radio.c     |   12 ++++++------
 4 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/b43legacy.h b/drivers/net/wireless/b43legacy/b43legacy.h
index 93d45b7..378b9ff 100644
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -814,23 +814,6 @@ void b43legacydbg(struct b43legacy_wl *wl, const char *fmt, ...)
 # define b43legacydbg(wl, fmt...) do { /* nothing */ } while (0)
 #endif /* DEBUG */
 
-
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
 /* Macros for printing a value in Q5.2 format */
 #define Q52_FMT		"%u.%u"
 #define Q52_ARG(q52)	((q52) / 4), (((q52) & 3) * 100 / 4)
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 5f3f34e..d55c101 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -839,10 +839,10 @@ static void handle_irq_noise(struct b43legacy_wldev *dev)
 	/* Get the noise samples. */
 	B43legacy_WARN_ON(dev->noisecalc.nr_samples >= 8);
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
diff --git a/drivers/net/wireless/b43legacy/phy.c b/drivers/net/wireless/b43legacy/phy.c
index 8e5c09b..768cccb 100644
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -1088,7 +1088,7 @@ static void b43legacy_phy_initg(struct b43legacy_wldev *dev)
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
 		 * Essentially, what we do here is resetting all NRSSI LT
-		 * entries to -32 (see the limit_value() in nrssi_hw_update())
+		 * entries to -32 (see the clamp_val() in nrssi_hw_update())
 		 */
 		b43legacy_nrssi_hw_update(dev, 0xFFFF);
 		b43legacy_calc_nrssi_threshold(dev);
@@ -1756,7 +1756,7 @@ static s8 b43legacy_phy_estimate_power_out(struct b43legacy_wldev *dev, s8 tssi)
 	switch (phy->type) {
 	case B43legacy_PHYTYPE_B:
 	case B43legacy_PHYTYPE_G:
-		tmp = limit_value(tmp, 0x00, 0x3F);
+		tmp = clamp_val(tmp, 0x00, 0x3F);
 		dbm = phy->tssi2dbm[tmp];
 		break;
 	default:
@@ -1859,7 +1859,7 @@ void b43legacy_phy_xmitpower(struct b43legacy_wldev *dev)
 
 	/* find the desired power in Q5.2 - power_level is in dBm
 	 * and limit it - max_pwr is already in Q5.2 */
-	desired_pwr = limit_value(phy->power_level << 2, 0, max_pwr);
+	desired_pwr = clamp_val(phy->power_level << 2, 0, max_pwr);
 	if (b43legacy_debug(dev, B43legacy_DBG_XMITPOWER))
 		b43legacydbg(dev->wl, "Current TX power output: " Q52_FMT
 		       " dBm, Desired TX power output: " Q52_FMT
@@ -1905,7 +1905,7 @@ void b43legacy_phy_xmitpower(struct b43legacy_wldev *dev)
 			radio_attenuation++;
 		}
 	}
-	baseband_attenuation = limit_value(baseband_attenuation, 0, 11);
+	baseband_attenuation = clamp_val(baseband_attenuation, 0, 11);
 
 	txpower = phy->txctl1;
 	if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 2)) {
@@ -1933,8 +1933,8 @@ void b43legacy_phy_xmitpower(struct b43legacy_wldev *dev)
 	}
 	/* Save the control values */
 	phy->txctl1 = txpower;
-	baseband_attenuation = limit_value(baseband_attenuation, 0, 11);
-	radio_attenuation = limit_value(radio_attenuation, 0, 9);
+	baseband_attenuation = clamp_val(baseband_attenuation, 0, 11);
+	radio_attenuation = clamp_val(radio_attenuation, 0, 9);
 	phy->rfatt = radio_attenuation;
 	phy->bbatt = baseband_attenuation;
 
@@ -1979,7 +1979,7 @@ s8 b43legacy_tssi2dbm_entry(s8 entry [], u8 index, s16 pab0, s16 pab1, s16 pab2)
 		f = q;
 		i++;
 	} while (delta >= 2);
-	entry[index] = limit_value(b43legacy_tssi2dbm_ad(m1 * f, 8192),
+	entry[index] = clamp_val(b43legacy_tssi2dbm_ad(m1 * f, 8192),
 				   -127, 128);
 	return 0;
 }
diff --git a/drivers/net/wireless/b43legacy/radio.c b/drivers/net/wireless/b43legacy/radio.c
index 955832e..2df545c 100644
--- a/drivers/net/wireless/b43legacy/radio.c
+++ b/drivers/net/wireless/b43legacy/radio.c
@@ -357,7 +357,7 @@ void b43legacy_nrssi_hw_update(struct b43legacy_wldev *dev, u16 val)
 	for (i = 0; i < 64; i++) {
 		tmp = b43legacy_nrssi_hw_read(dev, i);
 		tmp -= val;
-		tmp = limit_value(tmp, -32, 31);
+		tmp = clamp_val(tmp, -32, 31);
 		b43legacy_nrssi_hw_write(dev, i, tmp);
 	}
 }
@@ -375,7 +375,7 @@ void b43legacy_nrssi_mem_update(struct b43legacy_wldev *dev)
 		tmp = (i - delta) * phy->nrssislope;
 		tmp /= 0x10000;
 		tmp += 0x3A;
-		tmp = limit_value(tmp, 0, 0x3F);
+		tmp = clamp_val(tmp, 0, 0x3F);
 		phy->nrssi_lt[i] = tmp;
 	}
 }
@@ -839,7 +839,7 @@ void b43legacy_calc_nrssi_threshold(struct b43legacy_wldev *dev)
 		} else
 			threshold = phy->nrssi[1] - 5;
 
-		threshold = limit_value(threshold, 0, 0x3E);
+		threshold = clamp_val(threshold, 0, 0x3E);
 		b43legacy_phy_read(dev, 0x0020); /* dummy read */
 		b43legacy_phy_write(dev, 0x0020, (((u16)threshold) << 8)
 				    | 0x001C);
@@ -892,7 +892,7 @@ void b43legacy_calc_nrssi_threshold(struct b43legacy_wldev *dev)
 			else
 				a += 32;
 			a = a >> 6;
-			a = limit_value(a, -31, 31);
+			a = clamp_val(a, -31, 31);
 
 			b = b * (phy->nrssi[1] - phy->nrssi[0]);
 			b += (phy->nrssi[0] << 6);
@@ -901,7 +901,7 @@ void b43legacy_calc_nrssi_threshold(struct b43legacy_wldev *dev)
 			else
 				b += 32;
 			b = b >> 6;
-			b = limit_value(b, -31, 31);
+			b = clamp_val(b, -31, 31);
 
 			tmp_u16 = b43legacy_phy_read(dev, 0x048A) & 0xF000;
 			tmp_u16 |= ((u32)b & 0x0000003F);
@@ -1905,7 +1905,7 @@ void b43legacy_radio_set_txpower_a(struct b43legacy_wldev *dev, u16 txpower)
 	u16 dac;
 	u16 ilt;
 
-	txpower = limit_value(txpower, 0, 63);
+	txpower = clamp_val(txpower, 0, 63);
 
 	pamp = b43legacy_get_txgain_freq_power_amp(txpower);
 	pamp <<= 5;
-- 
1.5.4.4.653.g7cf1e


