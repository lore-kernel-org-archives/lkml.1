Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYIQUIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYIQUIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYIQUIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:08:07 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52108 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbYIQUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:08:06 -0400
X-Sasl-enc: KiF5F38No163Dn69LPVXBTyIFmf+W4wKqzQvYIdTa/p5 1221682083
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, Michael Buesch <mb@bu3sch.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rfkill: update LEDs for all state changes
Date: Wed, 17 Sep 2008 17:07:56 -0300
Message-Id: <1221682077-21170-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080917023334.GA1187@khazad-dum.debian.net>
References: <20080917023334.GA1187@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LED state was not being updated by rfkill_force_state(), which will
cause regressions in wireless drivers that had old-style rfkill support and
are updated to use rfkill_force_state().

The LED state was not being updated when a change was detected through the
rfkill->get_state() hook, either.

Move the LED trigger update calls into notify_rfkill_state_change(), where
it should have been in the first place.  This takes care of both issues.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

 John, this one is quite likely something that should be sent for
 merge in mainline BEFORE 2.6.27 is released.

 I am NOT sure it fixes regressions, that depends on whether the drivers
 using rfkill that are in 2.6.27 had working LED support before rfkill
 support was added to them.  Unfortunately, it cannot fix the b43
 regression by itself.

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index ea0dc04..f949a48 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -125,6 +125,7 @@ static void rfkill_led_trigger_activate(struct led_classdev *led)
 
 static void notify_rfkill_state_change(struct rfkill *rfkill)
 {
+	rfkill_led_trigger(rfkill, rfkill->state);
 	blocking_notifier_call_chain(&rfkill_notifier_list,
 			RFKILL_STATE_CHANGED,
 			rfkill);
@@ -217,10 +218,8 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
 			rfkill->state = state;
 	}
 
-	if (force || rfkill->state != oldstate) {
-		rfkill_led_trigger(rfkill, rfkill->state);
+	if (force || rfkill->state != oldstate)
 		notify_rfkill_state_change(rfkill);
-	}
 
 	return retval;
 }
-- 
1.5.6.5

