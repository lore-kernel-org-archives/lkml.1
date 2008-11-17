Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbYKQHWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbYKQHWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYKQHU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:20:58 -0500
Received: from kroah.org ([198.145.64.141]:38150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752125AbYKQHUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:20:54 -0500
Date: Sun, 16 Nov 2008 23:14:17 -0800
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
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Elias Oltmanns <eo@nebensachen.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 03/46] ath5k: fix suspend-related oops on rmmod
Message-ID: <20081117071417.GD29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="ath5k-fix-suspend-related-oops-on-rmmod.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Elias Oltmanns <eo@nebensachen.de>

Cumulative patch backporting the following two commits from upstream:

commit 8bdd5b9c6bd53add260756b6673a0545fbdbba21 upstream
Author: Bob Copeland <me@bobcopeland.com>

Based on a patch by Elias Oltmanns, we call ath5k_init in resume even
if we didn't previously open the device.  Besides starting up the
device unnecessarily, this also causes an oops on rmmod because
mac80211 will not invoke ath5k_stop and softirqs are left running after
the module has been unloaded.  Add a new state bit, ATH_STAT_STARTED,
to indicate that we have been started up.

commit bc1b32d6bdd2d6f3fbee9a7c01c9b099f11c579c upstream
Author: Elias Oltmanns <eo@nebensachen.de>

After a s2ram / resume cycle, resetting the key cache does not work
unless it is deferred until after the hardware has been reinitialised by
a call to ath5k_hw_reset(). This fixes a regression introduced by
"ath5k: fix suspend-related oops on rmmod".

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/ath5k/base.c |   67 +++++++++++++++++++-------------------
 drivers/net/wireless/ath5k/base.h |    3 +
 2 files changed, 36 insertions(+), 34 deletions(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -294,9 +294,9 @@ static inline u64 ath5k_extend_tsf(struc
 }
 
 /* Interrupt handling */
-static int 	ath5k_init(struct ath5k_softc *sc);
+static int 	ath5k_init(struct ath5k_softc *sc, bool is_resume);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
-static int 	ath5k_stop_hw(struct ath5k_softc *sc);
+static int 	ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
 
@@ -584,7 +584,7 @@ ath5k_pci_suspend(struct pci_dev *pdev, 
 
 	ath5k_led_off(sc);
 
-	ath5k_stop_hw(sc);
+	ath5k_stop_hw(sc, true);
 
 	free_irq(pdev->irq, sc);
 	pci_save_state(pdev);
@@ -599,8 +599,7 @@ ath5k_pci_resume(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
-	int i, err;
+	int err;
 
 	pci_restore_state(pdev);
 
@@ -621,21 +620,11 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
 
-	err = ath5k_init(sc);
+	err = ath5k_init(sc, true);
 	if (err)
 		goto err_irq;
 	ath5k_led_enable(sc);
 
-	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up or resume.
-	 *
-	 * FIXME: This may need to be revisited when mac80211 becomes
-	 *        aware of suspend/resume.
-	 */
-	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
-		ath5k_hw_reset_key(ah, i);
-
 	return 0;
 err_irq:
 	free_irq(pdev->irq, sc);
@@ -657,7 +646,6 @@ ath5k_attach(struct pci_dev *pdev, struc
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	u8 mac[ETH_ALEN];
-	unsigned int i;
 	int ret;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device);
@@ -676,13 +664,6 @@ ath5k_attach(struct pci_dev *pdev, struc
 		__set_bit(ATH_STAT_MRRETRY, sc->status);
 
 	/*
-	 * Reset the key cache since some parts do not
-	 * reset the contents on initial power up.
-	 */
-	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
-		ath5k_hw_reset_key(ah, i);
-
-	/*
 	 * Collect the channel list.  The 802.11 layer
 	 * is resposible for filtering this list based
 	 * on settings like the phy mode and regulatory
@@ -2197,12 +2178,18 @@ ath5k_beacon_config(struct ath5k_softc *
 \********************/
 
 static int
-ath5k_init(struct ath5k_softc *sc)
+ath5k_init(struct ath5k_softc *sc, bool is_resume)
 {
-	int ret;
+	struct ath5k_hw *ah = sc->ah;
+	int ret, i;
 
 	mutex_lock(&sc->lock);
 
+	if (is_resume && !test_bit(ATH_STAT_STARTED, sc->status))
+		goto out_ok;
+
+	__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
@@ -2220,7 +2207,7 @@ ath5k_init(struct ath5k_softc *sc)
 	 */
 	sc->curchan = sc->hw->conf.channel;
 	sc->curband = &sc->sbands[sc->curchan->band];
-	ret = ath5k_hw_reset(sc->ah, sc->opmode, sc->curchan, false);
+	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, false);
 	if (ret) {
 		ATH5K_ERR(sc, "unable to reset hardware: %d\n", ret);
 		goto done;
@@ -2229,7 +2216,14 @@ ath5k_init(struct ath5k_softc *sc)
 	 * This is needed only to setup initial state
 	 * but it's best done after a reset.
 	 */
-	ath5k_hw_set_txpower_limit(sc->ah, 0);
+	ath5k_hw_set_txpower_limit(ah, 0);
+
+	/*
+	 * Reset the key cache since some parts do not reset the
+	 * contents on initial power up or resume from suspend.
+	 */
+	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
+		ath5k_hw_reset_key(ah, i);
 
 	/*
 	 * Setup the hardware after reset: the key cache
@@ -2249,13 +2243,17 @@ ath5k_init(struct ath5k_softc *sc)
 		AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL |
 		AR5K_INT_MIB;
 
-	ath5k_hw_set_intr(sc->ah, sc->imask);
+	ath5k_hw_set_intr(ah, sc->imask);
+
+	__set_bit(ATH_STAT_STARTED, sc->status);
+
 	/* Set ack to be sent at low bit-rates */
-	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
+	ath5k_hw_set_ack_bitrate_high(ah, false);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
 
+out_ok:
 	ret = 0;
 done:
 	mmiowb();
@@ -2310,7 +2308,7 @@ ath5k_stop_locked(struct ath5k_softc *sc
  * stop is preempted).
  */
 static int
-ath5k_stop_hw(struct ath5k_softc *sc)
+ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend)
 {
 	int ret;
 
@@ -2341,6 +2339,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		}
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
+	if (!is_suspend)
+		__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	mmiowb();
 	mutex_unlock(&sc->lock);
 
@@ -2719,12 +2720,12 @@ err:
 
 static int ath5k_start(struct ieee80211_hw *hw)
 {
-	return ath5k_init(hw->priv);
+	return ath5k_init(hw->priv, false);
 }
 
 static void ath5k_stop(struct ieee80211_hw *hw)
 {
-	ath5k_stop_hw(hw->priv);
+	ath5k_stop_hw(hw->priv, false);
 }
 
 static int ath5k_add_interface(struct ieee80211_hw *hw,
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -132,11 +132,12 @@ struct ath5k_softc {
 	size_t			desc_len;	/* size of TX/RX descriptors */
 	u16			cachelsz;	/* cache line size */
 
-	DECLARE_BITMAP(status, 4);
+	DECLARE_BITMAP(status, 5);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
 #define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
 #define ATH_STAT_PROMISC	2
 #define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
+#define ATH_STAT_STARTED	4		/* opened & irqs enabled */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	unsigned int		curmode;	/* current phy mode */

-- 
