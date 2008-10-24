Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbYJXEsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbYJXEsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYJXEjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:42 -0400
Received: from kroah.org ([198.145.64.141]:51997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751821AbYJXEjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:37 -0400
Date: Thu, 23 Oct 2008 21:35:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Elias Oltmanns <eo@nebensachen.de>,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 27/27] ath5k: fix suspend-related oops on rmmod
Message-ID: <20081024043530.GB30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="ath5k-fix-suspend-related-oops-on-rmmod.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Bob Copeland <me@bobcopeland.com>

commit 8bdd5b9c6bd53add260756b6673a0545fbdbba21 upstream

Based on a patch by Elias Oltmanns, we call ath5k_init in resume even
if we didn't previously open the device.  Besides starting up the
device unnecessarily, this also causes an oops on rmmod because
mac80211 will not invoke ath5k_stop and softirqs are left running after
the module has been unloaded.  Add a new state bit, ATH_STAT_STARTED,
to indicate that we have been started up.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/base.c |   28 ++++++++++++++++++++--------
 drivers/net/wireless/ath5k/base.h |    3 ++-
 2 files changed, 22 insertions(+), 9 deletions(-)

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
@@ -621,7 +621,7 @@ ath5k_pci_resume(struct pci_dev *pdev)
 		goto err_no_irq;
 	}
 
-	err = ath5k_init(sc);
+	err = ath5k_init(sc, true);
 	if (err)
 		goto err_irq;
 	ath5k_led_enable(sc);
@@ -2197,12 +2197,17 @@ ath5k_beacon_config(struct ath5k_softc *
 \********************/
 
 static int
-ath5k_init(struct ath5k_softc *sc)
+ath5k_init(struct ath5k_softc *sc, bool is_resume)
 {
 	int ret;
 
 	mutex_lock(&sc->lock);
 
+	if (is_resume && !test_bit(ATH_STAT_STARTED, sc->status))
+		goto out_ok;
+
+	__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
 
 	/*
@@ -2250,12 +2255,16 @@ ath5k_init(struct ath5k_softc *sc)
 		AR5K_INT_MIB;
 
 	ath5k_hw_set_intr(sc->ah, sc->imask);
+
+	__set_bit(ATH_STAT_STARTED, sc->status);
+
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
 			msecs_to_jiffies(ath5k_calinterval * 1000)));
 
+out_ok:
 	ret = 0;
 done:
 	mmiowb();
@@ -2310,7 +2319,7 @@ ath5k_stop_locked(struct ath5k_softc *sc
  * stop is preempted).
  */
 static int
-ath5k_stop_hw(struct ath5k_softc *sc)
+ath5k_stop_hw(struct ath5k_softc *sc, bool is_suspend)
 {
 	int ret;
 
@@ -2341,6 +2350,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		}
 	}
 	ath5k_txbuf_free(sc, sc->bbuf);
+	if (!is_suspend)
+		__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	mmiowb();
 	mutex_unlock(&sc->lock);
 
@@ -2719,12 +2731,12 @@ err:
 
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
