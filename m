Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYCNFVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYCNFVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbYCNFVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:21:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbYCNFU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oWJODSzgXIgHM1XDKAcPtAyGt9dNTTuc3HeNAo/3oii8ablDbQzx/lSvov3GR7yykbEIgUNhtL73zA/zcdLQIwX4QYoRav/ZdWmq8z21Lag9RDvi6xiAIS51aWpeaqxJERvoQngfylXfr23354gcjux8HaG9i+zJtK7qgGhPH+E=
Subject: [PATCH 06/10] bcm43xx: replace limit_value macro with clamp_val
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:20:58 -0700
Message-Id: <1205472058.19712.22.camel@brick>
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
 drivers/net/wireless/bcm43xx/bcm43xx.h       |   16 ----------------
 drivers/net/wireless/bcm43xx/bcm43xx_main.c  |   12 ++++++------
 drivers/net/wireless/bcm43xx/bcm43xx_phy.c   |   16 ++++++++--------
 drivers/net/wireless/bcm43xx/bcm43xx_radio.c |   12 ++++++------
 drivers/net/wireless/bcm43xx/bcm43xx_wx.c    |    2 +-
 5 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx.h b/drivers/net/wireless/bcm43xx/bcm43xx.h
index 2ebd2ed..dc956b4 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -978,20 +978,4 @@ int bcm43xx_pci_write_config32(struct bcm43xx_private *bcm, int offset, u32 valu
 	return pci_write_config_dword(bcm->pci_dev, offset, value);
 }
 
-/** Limit a value between two limits */
-#ifdef limit_value
-# undef limit_value
-#endif
-#define limit_value(value, min, max)  \
-	({						\
-		typeof(value) __value = (value);	\
-	 	typeof(value) __min = (min);		\
-	 	typeof(value) __max = (max);		\
-	 	if (__value < __min)			\
-	 		__value = __min;		\
-	 	else if (__value > __max)		\
-	 		__value = __max;		\
-	 	__value;				\
-	})
-
 #endif /* BCM43xx_H_ */
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index b96a325..67d8765 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1494,10 +1494,10 @@ static void handle_irq_noise(struct bcm43xx_private *bcm)
 	/* Get the noise samples. */
 	assert(bcm->noisecalc.nr_samples < 8);
 	i = bcm->noisecalc.nr_samples;
-	noise[0] = limit_value(noise[0], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
-	noise[1] = limit_value(noise[1], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
-	noise[2] = limit_value(noise[2], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
-	noise[3] = limit_value(noise[3], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
+	noise[0] = clamp_val(noise[0], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
+	noise[1] = clamp_val(noise[1], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
+	noise[2] = clamp_val(noise[2], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
+	noise[3] = clamp_val(noise[3], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
 	bcm->noisecalc.samples[i][0] = radio->nrssi_lt[noise[0]];
 	bcm->noisecalc.samples[i][1] = radio->nrssi_lt[noise[1]];
 	bcm->noisecalc.samples[i][2] = radio->nrssi_lt[noise[2]];
@@ -2854,9 +2854,9 @@ static int bcm43xx_wireless_core_init(struct bcm43xx_private *bcm,
 	 * The retry-limit is a 4-bit counter. Enforce this to avoid overflowing
 	 * the chip-internal counter.
 	 */
-	limit = limit_value(modparam_short_retry, 0, 0xF);
+	limit = clamp_val(modparam_short_retry, 0, 0xF);
 	bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0006, limit);
-	limit = limit_value(modparam_long_retry, 0, 0xF);
+	limit = clamp_val(modparam_long_retry, 0, 0xF);
 	bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0007, limit);
 
 	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0044, 3);
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
index af3de33..1d909ed 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -1265,7 +1265,7 @@ static void bcm43xx_phy_initg(struct bcm43xx_private *bcm)
 		 * the value 0x7FFFFFFF here. I think that is some weird
 		 * compiler optimization in the original driver.
 		 * Essentially, what we do here is resetting all NRSSI LT
-		 * entries to -32 (see the limit_value() in nrssi_hw_update())
+		 * entries to -32 (see the clamp_val() in nrssi_hw_update())
 		 */
 		bcm43xx_nrssi_hw_update(bcm, 0xFFFF);
 		bcm43xx_calc_nrssi_threshold(bcm);
@@ -1908,13 +1908,13 @@ static s8 bcm43xx_phy_estimate_power_out(struct bcm43xx_private *bcm, s8 tssi)
 	switch (phy->type) {
 		case BCM43xx_PHYTYPE_A:
 			tmp += 0x80;
-			tmp = limit_value(tmp, 0x00, 0xFF);
+			tmp = clamp_val(tmp, 0x00, 0xFF);
 			dbm = phy->tssi2dbm[tmp];
 			TODO(); //TODO: There's a FIXME on the specs
 			break;
 		case BCM43xx_PHYTYPE_B:
 		case BCM43xx_PHYTYPE_G:
-			tmp = limit_value(tmp, 0x00, 0x3F);
+			tmp = clamp_val(tmp, 0x00, 0x3F);
 			dbm = phy->tssi2dbm[tmp];
 			break;
 		default:
@@ -1998,7 +1998,7 @@ void bcm43xx_phy_xmitpower(struct bcm43xx_private *bcm)
 			where REG is the max power as per the regulatory domain
 		*/
 
-		desired_pwr = limit_value(radio->txpower_desired, 0, max_pwr);
+		desired_pwr = clamp_val(radio->txpower_desired, 0, max_pwr);
 		/* Check if we need to adjust the current power. */
 		pwr_adjust = desired_pwr - estimated_pwr;
 		radio_att_delta = -(pwr_adjust + 7) >> 3;
@@ -2034,7 +2034,7 @@ void bcm43xx_phy_xmitpower(struct bcm43xx_private *bcm)
 				radio_attenuation++;
 			}
 		}
-		baseband_attenuation = limit_value(baseband_attenuation, 0, 11);
+		baseband_attenuation = clamp_val(baseband_attenuation, 0, 11);
 
 		txpower = radio->txctl1;
 		if ((radio->version == 0x2050) && (radio->revision == 2)) {
@@ -2059,8 +2059,8 @@ void bcm43xx_phy_xmitpower(struct bcm43xx_private *bcm)
 			}
 		}
 		radio->txctl1 = txpower;
-		baseband_attenuation = limit_value(baseband_attenuation, 0, 11);
-		radio_attenuation = limit_value(radio_attenuation, 0, 9);
+		baseband_attenuation = clamp_val(baseband_attenuation, 0, 11);
+		radio_attenuation = clamp_val(radio_attenuation, 0, 9);
 
 		bcm43xx_phy_lock(bcm, phylock_flags);
 		bcm43xx_radio_lock(bcm);
@@ -2102,7 +2102,7 @@ s8 bcm43xx_tssi2dbm_entry(s8 entry [], u8 index, s16 pab0, s16 pab1, s16 pab2)
 		f = q;
 		i++;
 	} while (delta >= 2);
-	entry[index] = limit_value(bcm43xx_tssi2dbm_ad(m1 * f, 8192), -127, 128);
+	entry[index] = clamp_val(bcm43xx_tssi2dbm_ad(m1 * f, 8192), -127, 128);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
index c605099..2a05b67 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -343,7 +343,7 @@ void bcm43xx_nrssi_hw_update(struct bcm43xx_private *bcm, u16 val)
 	for (i = 0; i < 64; i++) {
 		tmp = bcm43xx_nrssi_hw_read(bcm, i);
 		tmp -= val;
-		tmp = limit_value(tmp, -32, 31);
+		tmp = clamp_val(tmp, -32, 31);
 		bcm43xx_nrssi_hw_write(bcm, i, tmp);
 	}
 }
@@ -360,7 +360,7 @@ void bcm43xx_nrssi_mem_update(struct bcm43xx_private *bcm)
 		tmp = (i - delta) * radio->nrssislope;
 		tmp /= 0x10000;
 		tmp += 0x3A;
-		tmp = limit_value(tmp, 0, 0x3F);
+		tmp = clamp_val(tmp, 0, 0x3F);
 		radio->nrssi_lt[i] = tmp;
 	}
 }
@@ -801,7 +801,7 @@ void bcm43xx_calc_nrssi_threshold(struct bcm43xx_private *bcm)
 		} else
 			threshold = radio->nrssi[1] - 5;
 
-		threshold = limit_value(threshold, 0, 0x3E);
+		threshold = clamp_val(threshold, 0, 0x3E);
 		bcm43xx_phy_read(bcm, 0x0020); /* dummy read */
 		bcm43xx_phy_write(bcm, 0x0020, (((u16)threshold) << 8) | 0x001C);
 
@@ -851,7 +851,7 @@ void bcm43xx_calc_nrssi_threshold(struct bcm43xx_private *bcm)
 			else
 				a += 32;
 			a = a >> 6;
-			a = limit_value(a, -31, 31);
+			a = clamp_val(a, -31, 31);
 
 			b = b * (radio->nrssi[1] - radio->nrssi[0]);
 			b += (radio->nrssi[0] << 6);
@@ -860,7 +860,7 @@ void bcm43xx_calc_nrssi_threshold(struct bcm43xx_private *bcm)
 			else
 				b += 32;
 			b = b >> 6;
-			b = limit_value(b, -31, 31);
+			b = clamp_val(b, -31, 31);
 
 			tmp_u16 = bcm43xx_phy_read(bcm, 0x048A) & 0xF000;
 			tmp_u16 |= ((u32)b & 0x0000003F);
@@ -1919,7 +1919,7 @@ void bcm43xx_radio_set_txpower_a(struct bcm43xx_private *bcm, u16 txpower)
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
 	u16 pamp, base, dac, ilt;
 
-	txpower = limit_value(txpower, 0, 63);
+	txpower = clamp_val(txpower, 0, 63);
 
 	pamp = bcm43xx_get_txgain_freq_power_amp(txpower);
 	pamp <<= 5;
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
index 6acfdc4..c5d9aca 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -466,7 +466,7 @@ static int bcm43xx_wx_set_xmitpower(struct net_device *net_dev,
 			maxpower = bcm->sprom.maxpower_aphy;
 		else
 			maxpower = bcm->sprom.maxpower_bgphy;
-		radio->txpower_desired = limit_value(data->txpower.value << 2,
+		radio->txpower_desired = clamp_val(data->txpower.value << 2,
 						     0, maxpower);
 		bcm43xx_phy_xmitpower(bcm);
 	}
-- 
1.5.4.4.653.g7cf1e


