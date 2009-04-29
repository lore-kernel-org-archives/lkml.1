Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbZD2Wjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbZD2Wjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760342AbZD2WVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:52 -0400
Received: from kroah.org ([198.145.64.141]:40697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZD2WVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:30 2009
Message-Id: <20090429220929.995031553@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: [patch 47/58] ath9k: implement IO serialization
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-implement-io-serialization.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

This is a port of:
commit SHA1 6158425be398936af1fd04451f78ffad01529cb0
for 2.6.27

All 802.11n PCI devices (Cardbus, PCI, mini-PCI) require
serialization of IO when on non-uniprocessor systems. PCI
express devices not not require this.

This should fix our only last standing open ath9k kernel.org
bugzilla bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=12110

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath9k/ath9k.h |    4 ++--
 drivers/net/wireless/ath9k/core.c  |    1 +
 drivers/net/wireless/ath9k/core.h  |   33 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.c    |   19 +++++++++++++++++++
 4 files changed, 55 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -591,8 +591,8 @@ struct ath9k_country_entry {
 	u8 iso[3];
 };
 
-#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
-#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
+#define REG_WRITE(_ah, _reg, _val) ath9k_iowrite32((_ah), (_reg), (_val))
+#define REG_READ(_ah, _reg) ath9k_ioread32((_ah), (_reg))
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1120,6 +1120,7 @@ int ath_init(u16 devid, struct ath_softc
 	sc->sc_cachelsz = csz << 2;	/* convert to bytes */
 
 	spin_lock_init(&sc->sc_resetlock);
+	spin_lock_init(&sc->sc_serial_rw);
 
 	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
 	if (ah == NULL) {
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1022,6 +1022,7 @@ struct ath_softc {
 	spinlock_t sc_rxbuflock;
 	spinlock_t sc_txbuflock;
 	spinlock_t sc_resetlock;
+	spinlock_t sc_serial_rw;
 	spinlock_t node_lock;
 };
 
@@ -1069,4 +1070,36 @@ void ath_skb_unmap_single(struct ath_sof
 void ath_mcast_merge(struct ath_softc *sc, u32 mfilt[2]);
 enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc);
 
+/*
+ * Read and write, they both share the same lock. We do this to serialize
+ * reads and writes on Atheros 802.11n PCI devices only. This is required
+ * as the FIFO on these devices can only accept sanely 2 requests. After
+ * that the device goes bananas. Serializing the reads/writes prevents this
+ * from happening.
+ */
+
+static inline void ath9k_iowrite32(struct ath_hal *ah, u32 reg_offset, u32 val)
+{
+	if (ah->ah_config.serialize_regmode == SER_REG_MODE_ON) {
+		unsigned long flags;
+		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+	} else
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+}
+
+static inline unsigned int ath9k_ioread32(struct ath_hal *ah, u32 reg_offset)
+{
+	u32 val;
+	if (ah->ah_config.serialize_regmode == SER_REG_MODE_ON) {
+		unsigned long flags;
+		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
+		val = ioread32(ah->ah_sc->mem + reg_offset);
+		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+	} else
+		val = ioread32(ah->ah_sc->mem + reg_offset);
+	return val;
+}
+
 #endif /* CORE_H */
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -369,6 +369,25 @@ static void ath9k_hw_set_defaults(struct
 	}
 
 	ah->ah_config.intr_mitigation = 0;
+
+	/*
+	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
+	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
+	 * This means we use it for all AR5416 devices, and the few
+	 * minor PCI AR9280 devices out there.
+	 *
+	 * Serialization is required because these devices do not handle
+	 * well the case of two concurrent reads/writes due to the latency
+	 * involved. During one read/write another read/write can be issued
+	 * on another CPU while the previous read/write may still be working
+	 * on our hardware, if we hit this case the hardware poops in a loop.
+	 * We prevent this by serializing reads and writes.
+	 *
+	 * This issue is not present on PCI-Express devices or pre-AR5416
+	 * devices (legacy, 802.11abg).
+	 */
+       if (num_possible_cpus() > 1)
+               ah->ah_config.serialize_regmode = SER_REG_MODE_AUTO;
 }
 
 static inline void ath9k_hw_override_ini(struct ath_hal *ah,


