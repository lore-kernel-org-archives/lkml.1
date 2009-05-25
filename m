Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZEYXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZEYXYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZEYXYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:24:09 -0400
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:39894 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbZEYXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:24:07 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>, Jiri Slaby <jirislaby@gmail.com>,
       ath5k-devel@venema.h4ckr.net
Subject: [PATCH] ath5k: added initial RFKILL support
Date: Tue, 26 May 2009 01:24:02 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-rc7-wl; KDE/4.2.85; i686; ; )
Cc: mickflemm@gmail.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905202216.43996.tobias.doerffel@gmail.com> <20090520202124.M71221@bobcopeland.com>
In-Reply-To: <20090520202124.M71221@bobcopeland.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart31087822.TpRyDaT0ff";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905260124.03287.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 36fc706507f2bc6280ab4ec5292e3e65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart31087822.TpRyDaT0ff
Content-Type: multipart/mixed;
  boundary="Boundary-01=_TiyGKjN2fNIt5bT"
Content-Transfer-Encoding: 7bit


--Boundary-01=_TiyGKjN2fNIt5bT
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Am Mittwoch, 20. Mai 2009 22:29:42 schrieb Bob Copeland:
> I'm definitely interested in seeing rfkill gpio support getting in,
> it's overdue.  So I say repost it and we can fasttrack that.  Digging
> up your last patchset was already on my todo list.
Here we go. I attached a patch (against wireless-testing) which represents =
my=20
latest work on RFKILL support for ath5k. It still lacks testing with a real=
=20
physical rfkill switch (for I don't have one with my NC10) but everything e=
lse=20
(SW rfkill) works fine after testing various scenarios. Furthermore I think=
 I=20
addressed all remarks in the last review by Bob Copeland.

Regards,

Toby

--Boundary-01=_TiyGKjN2fNIt5bT
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-ath5k-added-initial-RFKILL-support.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-ath5k-added-initial-RFKILL-support.patch"

=46rom 0dfab8fbd3223747e2a7948296606e661899630b Mon Sep 17 00:00:00 2001
=46rom: Tobias Doerffel <tobias.doerffel@gmail.com>
Date: Tue, 26 May 2009 00:52:20 +0200
Subject: [PATCH] ath5k: added initial RFKILL support

This patch introduces initial RFKILL support for the ath5k driver.
All RFKILL related code is separated into newly created rfkill.c.

Changes to existing code are minimal:

=2D added a new data structure ath5k_rfkill to the ath5k_softc structure
=2D new function ath5k_eeprom_read_rfkill() for retrieving RFKILL related
  parameters from EEPROM
=2D inserted calls to init/deinit routines for both the SW and HW part of
  RFKILL support
=2D ath5k_intr() has been extended to handle AR5K_INT_GPIO interrupts
=2D--
 drivers/net/wireless/ath/ath5k/Kconfig  |    9 +
 drivers/net/wireless/ath/ath5k/Makefile |    1 +
 drivers/net/wireless/ath/ath5k/ath5k.h  |   22 +++
 drivers/net/wireless/ath/ath5k/base.c   |   20 ++-
 drivers/net/wireless/ath/ath5k/base.h   |   26 +++
 drivers/net/wireless/ath/ath5k/eeprom.c |   16 ++
 drivers/net/wireless/ath/ath5k/reset.c  |   17 --
 drivers/net/wireless/ath/ath5k/rfkill.c |  268 +++++++++++++++++++++++++++=
++++
 8 files changed, 358 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/rfkill.c

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/=
ath/ath5k/Kconfig
index 509b6f9..618a879 100644
=2D-- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -39,3 +39,12 @@ config ATH5K_DEBUG
=20
 	  modprobe ath5k debug=3D0x00000400
=20
+config ATH5K_RFKILL
+	bool "Atheros 5xxx rfkill support"
+	select RFKILL
+	depends on ATH5K
+	default y
+	---help---
+	  Include support for enabling/disabling WiFi via rfkill switch
+	  with Atheros 5xxx cards
+
diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless=
/ath/ath5k/Makefile
index 84a74c5..f1e281c 100644
=2D-- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -12,4 +12,5 @@ ath5k-y				+=3D attach.o
 ath5k-y				+=3D base.o
 ath5k-y				+=3D led.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+=3D debug.o
+ath5k-$(CONFIG_ATH5K_RFKILL)	+=3D rfkill.o
 obj-$(CONFIG_ATH5K)		+=3D ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/=
ath/ath5k/ath5k.h
index 8137182..0dadcbb 100644
=2D-- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1162,6 +1162,10 @@ extern void ath5k_led_enable(struct ath5k_softc *sc);
 extern void ath5k_led_off(struct ath5k_softc *sc);
 extern void ath5k_unregister_leds(struct ath5k_softc *sc);
=20
+/* Start/Stop Functions */
+extern int ath5k_init(struct ath5k_softc *sc);
+extern int ath5k_stop_hw(struct ath5k_softc *sc);
+
 /* Reset Functions */
 extern int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initia=
l);
 extern int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode=
, struct ieee80211_channel *channel, bool change_channel);
@@ -1190,6 +1194,7 @@ extern void ath5k_hw_update_mib_counters(struct ath5k=
_hw *ah, struct ieee80211_l
 extern int ath5k_eeprom_init(struct ath5k_hw *ah);
 extern void ath5k_eeprom_detach(struct ath5k_hw *ah);
 extern int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
+extern void ath5k_eeprom_read_rfkill(struct ath5k_hw *ah, u16 *gpio, u8 *p=
olarity);
 extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
=20
 /* Protocol Control Unit Functions */
@@ -1256,6 +1261,23 @@ extern u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u3=
2 gpio);
 extern int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
 extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,=
 u32 interrupt_level);
=20
+/* rfkill Functions */
+#ifdef CONFIG_ATH5K_RFKILL
+extern int ath5k_rfkill_init(struct ath5k_softc *sc);
+extern void ath5k_rfkill_deinit(struct ath5k_softc *sc);
+extern void ath5k_rfkill_hw_start(struct ath5k_hw *ah);
+extern void ath5k_rfkill_hw_stop(struct ath5k_hw *ah);
+#else
+static inline int ath5k_rfkill_init(struct ath5k_softc *sc)
+{
+	return 0;
+}
+
+static inline void ath5k_rfkill_deinit(struct ath5k_softc *sc) {}
+static inline void ath5k_rfkill_hw_start(struct ath5k_hw *ah) {}
+static inline void ath5k_rfkill_hw_stop(struct ath5k_hw *ah) {}
+#endif
+
 /* Misc functions */
 int ath5k_hw_set_capabilities(struct ath5k_hw *ah);
 extern int ath5k_hw_get_capability(struct ath5k_hw *ah, enum ath5k_capabil=
ity_type cap_type, u32 capability, u32 *result);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/a=
th/ath5k/base.c
index fb51937..aa9446e 100644
=2D-- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -363,9 +363,7 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah,=
 u32 rstamp)
 }
=20
 /* Interrupt handling */
=2Dstatic int 	ath5k_init(struct ath5k_softc *sc);
 static int 	ath5k_stop_locked(struct ath5k_softc *sc);
=2Dstatic int 	ath5k_stop_hw(struct ath5k_softc *sc);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
=20
@@ -822,6 +820,9 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw =
*hw)
=20
 	ath5k_init_leds(sc);
=20
+	/* Initialize rfkill subsystem */
+	ath5k_rfkill_init(sc);
+
 	return 0;
 err_queues:
 	ath5k_txq_release(sc);
@@ -856,6 +857,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw =
*hw)
 	ath5k_txq_release(sc);
 	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
 	ath5k_unregister_leds(sc);
+	ath5k_rfkill_deinit(sc);
=20
 	/*
 	 * NB: can't reclaim these until after ieee80211_ifdetach
@@ -2321,7 +2323,7 @@ static void ath5k_tasklet_beacon(unsigned long data)
 * Interrupt handling *
 \********************/
=20
=2Dstatic int
+int
 ath5k_init(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah =3D sc->ah;
@@ -2353,6 +2355,8 @@ ath5k_init(struct ath5k_softc *sc)
 	if (ret)
 		goto done;
=20
+	ath5k_rfkill_hw_start(ah);
+
 	/*
 	 * Reset the key cache since some parts do not reset the
 	 * contents on initial power up or resume from suspend.
@@ -2419,7 +2423,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
  * if another thread does a system call and the thread doing the
  * stop is preempted).
  */
=2Dstatic int
+int
 ath5k_stop_hw(struct ath5k_softc *sc)
 {
 	int ret;
@@ -2461,6 +2465,8 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	tasklet_kill(&sc->restq);
 	tasklet_kill(&sc->beacontq);
=20
+	ath5k_rfkill_hw_stop(sc->ah);
+
 	return ret;
 }
=20
@@ -2519,6 +2525,12 @@ ath5k_intr(int irq, void *dev_id)
 				 */
 				ath5k_hw_update_mib_counters(ah, &sc->ll_stats);
 			}
+#ifdef CONFIG_ATH5K_RFKILL
+			if (status & AR5K_INT_GPIO)
+			{
+				tasklet_schedule(&sc->rf_kill.toggleq);
+			}
+#endif
 		}
 	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
=20
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/a=
th/ath5k/base.h
index 852b2c1..88c6929 100644
=2D-- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -46,6 +46,7 @@
 #include <linux/wireless.h>
 #include <linux/if_ether.h>
 #include <linux/leds.h>
+#include <linux/rfkill.h>
=20
 #include "ath5k.h"
 #include "debug.h"
@@ -91,6 +92,27 @@ struct ath5k_led
 	struct led_classdev led_dev;		/* led classdev */
 };
=20
+/* Rfkill */
+#define ATH5K_RFKILL_FLAG_HW_STARTED	BIT(0)
+#define ATH5K_RFKILL_FLAG_SW_BLOCKED	BIT(1)
+#define ATH5K_RFKILL_FLAG_HW_BLOCKED	BIT(2)
+
+struct ath5k_rfkill {
+	/* GPIO PIN for rfkill */
+	u16 gpio;
+	/* polarity of rfkill GPIO PIN */
+	u8 polarity;
+	/* The RFKILL subsystem data structure */
+	struct rfkill *rfkill;
+	/* The unique name of this rfkill switch */
+	char rfkill_name[32];
+	/* Flags indicating SW RFKILL status */
+	u32 flags;
+	/* RFKILL toggle tasklet */
+	struct tasklet_struct toggleq;
+	/* mutex for RFKILL related operations */
+	struct mutex lock;
+};
=20
 #if CHAN_DEBUG
 #define ATH_CHAN_MAX	(26+26+26+200+200)
@@ -167,6 +189,10 @@ struct ath5k_softc {
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 	struct ath5k_led	tx_led;		/* tx led */
=20
+#ifdef CONFIG_ATH5K_RFKILL
+	struct ath5k_rfkill	rf_kill;
+#endif
+
 	spinlock_t		block;		/* protects beacon */
 	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
 	struct ath5k_buf	*bbuf;		/* beacon buffer */
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless=
/ath/ath5k/eeprom.c
index c56b494..ff00502 100644
=2D-- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1800,3 +1800,19 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *m=
ac)
=20
 	return 0;
 }
+
+
+/*
+ * Read RFKILL GPIO configuration from eeprom
+ */
+void ath5k_eeprom_read_rfkill(struct ath5k_hw *ah, u16 *gpio, u8 *polarity)
+{
+	u16 data;
+
+	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_RFKILL_GPIO_SEL, &data);
+	*gpio =3D AR5K_REG_MS(data, AR5K_EEPROM_RFKILL_GPIO_SEL);
+
+	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_RFKILL_POLARITY, &data);
+	*polarity =3D AR5K_REG_MS(data, AR5K_EEPROM_RFKILL_POLARITY);
+}
+
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/=
ath/ath5k/reset.c
index bd1940e..8077f0a 100644
=2D-- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1305,23 +1305,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211=
_iftype op_mode,
 	if (ah->ah_version !=3D AR5K_AR5210)
 		ath5k_hw_set_imr(ah, ah->ah_imr);
=20
=2D	/*
=2D	 * Setup RFKill interrupt if rfkill flag is set on eeprom.
=2D	 * TODO: Use gpio pin and polarity infos from eeprom
=2D	 * TODO: Handle this in ath5k_intr because it'll result
=2D	 * 	 a nasty interrupt storm.
=2D	 */
=2D#if 0
=2D	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
=2D		ath5k_hw_set_gpio_input(ah, 0);
=2D		ah->ah_gpio[0] =3D ath5k_hw_get_gpio(ah, 0);
=2D		if (ah->ah_gpio[0] =3D=3D 0)
=2D			ath5k_hw_set_gpio_intr(ah, 0, 1);
=2D		else
=2D			ath5k_hw_set_gpio_intr(ah, 0, 0);
=2D	}
=2D#endif
=2D
 	/* Enable 32KHz clock function for AR5212+ chips
 	 * Set clocks to 32KHz operation and use an
 	 * external 32KHz crystal when sleeping if one
diff --git a/drivers/net/wireless/ath/ath5k/rfkill.c b/drivers/net/wireless=
/ath/ath5k/rfkill.c
new file mode 100644
index 0000000..2ae6961
=2D-- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/rfkill.c
@@ -0,0 +1,268 @@
+/*
+ * RFKILL support for ath5k
+ *
+ * Copyright (c) 2009 Tobias Doerffel <tobias.doerffel@gmail.com>
+ *
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
+ *    redistribution must be conditioned upon including a substantially
+ *    similar Disclaimer requirement for further binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products deriv=
ed
+ *    from this software without specific prior written permission.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF NONINFRINGEMENT, MERCHANTIBILITY
+ * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY,
+ * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
+ * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWI=
SE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
+ * THE POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include "base.h"
+
+
+static inline void ath5k_rfkill_disable(struct ath5k_softc *sc)
+{
+	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "rfkill disable (gpio:%d polarity:%d)\n",
+		sc->rf_kill.gpio, sc->rf_kill.polarity);
+	ath5k_hw_set_gpio_output(sc->ah, sc->rf_kill.gpio);
+	ath5k_hw_set_gpio(sc->ah, sc->rf_kill.gpio, !sc->rf_kill.polarity);
+}
+
+
+static inline void ath5k_rfkill_enable(struct ath5k_softc *sc)
+{
+	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "rfkill enable (gpio:%d polarity:%d)\n",
+		sc->rf_kill.gpio, sc->rf_kill.polarity);
+	ath5k_hw_set_gpio_output(sc->ah, sc->rf_kill.gpio);
+	ath5k_hw_set_gpio(sc->ah, sc->rf_kill.gpio, sc->rf_kill.polarity);
+}
+
+static inline void ath5k_rfkill_set_intr(struct ath5k_softc *sc, bool enab=
le)
+{
+	struct ath5k_hw *ah =3D sc->ah;
+	ath5k_hw_set_gpio_input(ah, sc->rf_kill.gpio);
+	ah->ah_gpio[0] =3D ath5k_hw_get_gpio(ah, sc->rf_kill.gpio);
+	ath5k_hw_set_gpio_intr(ah, sc->rf_kill.gpio, enable ?
+					!!ah->ah_gpio[0] : !ah->ah_gpio[0]);
+}
+
+static void
+ath5k_radio_enable(struct ath5k_softc *sc)
+{
+	ath5k_init(sc);
+
+	ieee80211_wake_queues(sc->hw);
+}
+
+
+static void
+ath5k_radio_disable(struct ath5k_softc *sc)
+{
+	ieee80211_stop_queues(sc->hw);
+
+	/* shutdown hardware */
+	ath5k_stop_hw(sc);
+}
+
+
+static bool
+ath5k_is_rfkill_set(struct ath5k_softc *sc)
+{
+	/* configuring GPIO for input for some reason disables rfkill */
+	/*ath5k_hw_set_gpio_input(sc->ah, sc->rf_kill.gpio);*/
+	return ath5k_hw_get_gpio(sc->ah, sc->rf_kill.gpio) =3D=3D
+							sc->rf_kill.polarity;
+}
+
+
+static void
+ath5k_tasklet_rfkill_toggle(unsigned long data)
+{
+	struct ath5k_softc *sc =3D (void *)data;
+	bool radio_on;
+
+	mutex_lock(&sc->rf_kill.lock);
+
+	radio_on =3D !ath5k_is_rfkill_set(sc);
+
+	/*
+	 * enable/disable radio only when there is a
+	 * state change in RF switch
+	 */
+	if (radio_on =3D=3D !!(sc->rf_kill.flags & ATH5K_RFKILL_FLAG_HW_BLOCKED))=
 {
+		enum rfkill_state state;
+
+		if (sc->rf_kill.flags & ATH5K_RFKILL_FLAG_SW_BLOCKED) {
+			state =3D radio_on ? RFKILL_STATE_SOFT_BLOCKED
+				: RFKILL_STATE_HARD_BLOCKED;
+		} else if (radio_on) {
+			ath5k_radio_enable(sc);
+			state =3D RFKILL_STATE_UNBLOCKED;
+		} else {
+			ath5k_radio_disable(sc);
+			state =3D RFKILL_STATE_HARD_BLOCKED;
+		}
+
+		if (state =3D=3D RFKILL_STATE_HARD_BLOCKED)
+			sc->rf_kill.flags |=3D ATH5K_RFKILL_FLAG_HW_BLOCKED;
+		else
+			sc->rf_kill.flags &=3D ~ATH5K_RFKILL_FLAG_HW_BLOCKED;
+
+		rfkill_force_state(sc->rf_kill.rfkill, state);
+	}
+	mutex_unlock(&sc->rf_kill.lock);
+
+}
+
+
+/* s/w rfkill handler */
+static int
+ath5k_rfkill_soft_toggle(void *data, enum rfkill_state state)
+{
+	struct ath5k_softc *sc =3D data;
+	mutex_lock(&sc->rf_kill.lock);
+	/* RFKILL framework might call this toggle callback even if HW is
+	   not started (i.e. interface not up) - depending on the current
+	   SW RFKILL state this could cause calling ath5k_radio_disable()
+           leading to kernel panic due to un-initialized HW state */
+	if (!(sc->rf_kill.flags & ATH5K_RFKILL_FLAG_HW_STARTED)) {
+		mutex_unlock(&sc->rf_kill.lock);
+		return -EINVAL;
+	}
+
+	switch (state) {
+	case RFKILL_STATE_SOFT_BLOCKED:
+		if (!(sc->rf_kill.flags & (ATH5K_RFKILL_FLAG_HW_BLOCKED |
+						ATH5K_RFKILL_FLAG_SW_BLOCKED)))
+			ath5k_radio_disable(sc);
+		sc->rf_kill.flags |=3D ATH5K_RFKILL_FLAG_SW_BLOCKED;
+		mutex_unlock(&sc->rf_kill.lock);
+		return 0;
+	case RFKILL_STATE_UNBLOCKED:
+		if ((sc->rf_kill.flags & ATH5K_RFKILL_FLAG_SW_BLOCKED)) {
+			sc->rf_kill.flags &=3D ~ATH5K_RFKILL_FLAG_SW_BLOCKED;
+			if (sc->rf_kill.flags & ATH5K_RFKILL_FLAG_HW_BLOCKED) {
+				ATH5K_ERR(sc, "Can't turn on the"
+					"radio as it is disabled by h/w\n");
+				mutex_unlock(&sc->rf_kill.lock);
+				return -EBUSY;
+			}
+			ath5k_radio_enable(sc);
+		}
+		mutex_unlock(&sc->rf_kill.lock);
+		return 0;
+	default:
+		break;
+	}
+	mutex_unlock(&sc->rf_kill.lock);
+	return -EINVAL;
+}
+
+
+/* Init s/w rfkill */
+int
+ath5k_rfkill_init(struct ath5k_softc *sc)
+{
+	int err;
+
+	mutex_init(&sc->rf_kill.lock);
+
+	sc->rf_kill.rfkill =3D rfkill_allocate(wiphy_dev(sc->hw->wiphy),
+					     RFKILL_TYPE_WLAN);
+	if (!sc->rf_kill.rfkill) {
+		ATH5K_ERR(sc, "Failed to allocate rfkill\n");
+		return -ENOMEM;
+	}
+
+	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
+		"ath5k-%s:rfkill", wiphy_name(sc->hw->wiphy));
+	sc->rf_kill.rfkill->name =3D sc->rf_kill.rfkill_name;
+	sc->rf_kill.rfkill->data =3D sc;
+	sc->rf_kill.rfkill->toggle_radio =3D ath5k_rfkill_soft_toggle;
+	sc->rf_kill.rfkill->state =3D RFKILL_STATE_UNBLOCKED;
+
+	err =3D rfkill_register(sc->rf_kill.rfkill);
+	if (err) {
+		sc->rf_kill.rfkill =3D NULL;
+		return -1;
+	}
+
+	return 0;
+}
+
+
+/* Deinitialize s/w rfkill */
+void
+ath5k_rfkill_deinit(struct ath5k_softc *sc)
+{
+	if (sc->rf_kill.rfkill !=3D NULL) {
+		rfkill_unregister(sc->rf_kill.rfkill);
+		sc->rf_kill.rfkill =3D NULL;
+	}
+}
+
+
+void
+ath5k_rfkill_hw_start(struct ath5k_hw *ah)
+{
+	struct ath5k_softc *sc =3D ah->ah_sc;
+
+	if ((sc->rf_kill.flags & ATH5K_RFKILL_FLAG_HW_STARTED) ||
+		(sc->rf_kill.flags & ATH5K_RFKILL_FLAG_SW_BLOCKED))
+		return;
+
+	/* read rfkill GPIO configuration from EEPROM */
+	ath5k_eeprom_read_rfkill(ah, &sc->rf_kill.gpio, &sc->rf_kill.polarity);
+
+	tasklet_init(&sc->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle,
+		(unsigned long)sc);
+
+	if (!(sc->rf_kill.flags & ATH5K_RFKILL_FLAG_HW_BLOCKED))
+		ath5k_rfkill_disable(sc);
+
+	/* enable interrupt for rfkill switch */
+	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
+		ath5k_rfkill_set_intr(sc, true);
+	}
+
+	sc->rf_kill.flags |=3D ATH5K_RFKILL_FLAG_HW_STARTED;
+}
+
+
+void
+ath5k_rfkill_hw_stop(struct ath5k_hw *ah)
+{
+	struct ath5k_softc *sc =3D ah->ah_sc;
+
+	if (sc->rf_kill.flags & ATH5K_RFKILL_FLAG_HW_STARTED) {
+		/* disable interrupt for rfkill switch */
+		if (AR5K_EEPROM_HDR_RFKILL(
+				ah->ah_capabilities.cap_eeprom.ee_header)) {
+			ath5k_rfkill_set_intr(sc, false);
+		}
+
+		tasklet_kill(&sc->rf_kill.toggleq);
+
+		/* enable RFKILL when stopping HW so Wifi LED is turned off */
+		ath5k_rfkill_enable(sc);
+
+		sc->rf_kill.flags &=3D ~ATH5K_RFKILL_FLAG_HW_STARTED;
+	}
+}
+
=2D-=20
1.6.3.1


--Boundary-01=_TiyGKjN2fNIt5bT--

--nextPart31087822.TpRyDaT0ff
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkobKJMACgkQHsjdpw2OaackCQCeNhSLEsOGrABfNXIS6h6SLyTc
fb4An0QSL9MCX3Ov9fWTGk9NflMkD9cU
=qG+D
-----END PGP SIGNATURE-----

--nextPart31087822.TpRyDaT0ff--
