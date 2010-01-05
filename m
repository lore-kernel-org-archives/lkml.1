Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080Ab0AEAsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0AEAsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066Ab0AEArh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:47:37 -0500
Received: from kroah.org ([198.145.64.141]:34341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0AEAfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/97] ath5k: fix SWI calibration interrupt storm
Date: Mon,  4 Jan 2010 16:32:58 -0800
Message-Id: <1262651630-7354-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Copeland <me@bobcopeland.com>

commit 242ab7ad689accafd5e87ffd22b85cf1bf7fbbef upstream.

The calibration period is now invoked by triggering a software
interrupt from within the ISR by ath5k_hw_calibration_poll()
instead of via a timer.

However, the calibration interval isn't initialized before
interrupts are enabled, so we can have a situation where an
interrupt occurs before the interval is assigned, so the
interval is actually negative.  As a result, the ISR will
arm a software interrupt to schedule the tasklet, and then
rearm it when the SWI is processed, and so on, leading to a
softlockup at modprobe time.

Move the initialization order around so the calibration interval
is set before interrupts are active.  Another possible fix
is to schedule the tasklet directly from the poll routine,
but I think there are additional plans for the SWI.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 95a8e23..8a82c75 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2349,6 +2349,9 @@ ath5k_init(struct ath5k_softc *sc)
 	 */
 	ath5k_stop_locked(sc);
 
+	/* Set PHY calibration interval */
+	ah->ah_cal_intval = ath5k_calinterval;
+
 	/*
 	 * The basic interface to setting the hardware in a good
 	 * state is ``reset''.  On return the hardware is known to
@@ -2376,10 +2379,6 @@ ath5k_init(struct ath5k_softc *sc)
 
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(ah, false);
-
-	/* Set PHY calibration inteval */
-	ah->ah_cal_intval = ath5k_calinterval;
-
 	ret = 0;
 done:
 	mmiowb();
-- 
1.6.6

