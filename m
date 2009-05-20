Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZETDip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZETDip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 23:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZETDig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 23:38:36 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3622 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZETDif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 23:38:35 -0400
Date: Tue, 19 May 2009 23:37:31 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Steven Rostedt <rostedt@goodmis.org>, linville@tuxdriver.com
Cc: Nick Kossifidis <mickflemm@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com, lrodriguez@atheros.com,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ath5k: avoid and warn on potential infinite loop
Message-ID: <20090520033731.GA16640@hash.localnet>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com> <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com> <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com> <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com> <20090519114240.GA13934@hash.localnet> <alpine.DEB.2.00.0905190751200.1767@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905190751200.1767@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we are trying to interpolate a curve with slope == 0, the return
value will always be the y-coordinate.  In this code we are looping
until we reach a minimum y-coordinate on a line, which in the 0-slope
case can never happen, thus the loop never terminates.

The PCDAC steps come from the EEPROM and should never be equal, but
we should gracefully handle that case, so warn and bail out.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

This ok?  (based on top of the wireless-testing tree -- the patch
that's already there can go for 2.6.30.  This is in addition to that
patch, this handles the other, unlikely, corner case.)

Having looked at the code, I don't see why we need to loop at all,
couldn't we just invert the slope and solve directly for y=0?
Certainly recomputing the slope in a loop could be optimized.
Anyway, that's another patch for another day.

 drivers/net/wireless/ath/ath5k/phy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index d0d1c35..a876ca8 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1897,6 +1897,9 @@ ath5k_get_linear_pcdac_min(const u8 *stepL, const u8 *stepR,
 	s16 min_pwrL, min_pwrR;
 	s16 pwr_i;
 
+	if (WARN_ON(stepL[0] == stepL[1] || stepR[0] == stepR[1]))
+		return 0;
+
 	if (pwrL[0] == pwrL[1])
 		min_pwrL = pwrL[0];
 	else {
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

