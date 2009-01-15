Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbZAOU4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbZAOU4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932364AbZAOUDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:03:20 -0500
Received: from kroah.org ([198.145.64.141]:49866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932107AbZAOUDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:03:10 -0500
Date: Thu, 15 Jan 2009 12:00:48 -0800
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
       alan@lxorguk.ukuu.org.uk, Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: [patch 93/94] ath5k: ignore the return value of
	ath5k_hw_noise_floor_calibration
Message-ID: <20090115200048.GO14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath5k-ignore-the-return-value-of-ath5k_hw_noise_floor_calibration.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 8b0162a3dc5c30e862b7a73da29e32de3170f5e4 upstream.

Noise floor calibration occasionally fails on Atheros hardware.
This is not fatal and can happen if there's simply too much
noise on the air. Ignoring the calibration error is the right
thing to do here, because when the error is ignored, the hardware
will still work, whereas if the error causes the driver to bail out
of a bigger configuration function and does not configure the tx
queues or the IMR (as is the case in reset.c), the hw no longer
works properly until the next reset.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/phy.c   |    4 +---
 drivers/net/wireless/ath5k/reset.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -2195,9 +2195,7 @@ static int ath5k_hw_rf5110_calibrate(str
 		return ret;
 	}
 
-	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
-	if (ret)
-		return ret;
+	ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
 
 	/*
 	 * Re-enable RX/TX and beacons
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -842,9 +842,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, 
 	 *
 	 * XXX: Find an interval that's OK for all cards...
 	 */
-	ret = ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
-	if (ret)
-		return ret;
+	ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
 
 	/*
 	 * Reset queues and start beacon timers at the end of the reset routine

