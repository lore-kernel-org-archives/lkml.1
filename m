Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYJPSCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYJPSCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYJPSAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:00:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:46768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbYJPSAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:00:44 -0400
Date: Thu, 16 Oct 2008 10:56:35 -0700
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
       alan@lxorguk.ukuu.org.uk, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 07/14] rfkill: update LEDs for all state changes
Message-ID: <20081016175635.GH12850@suse.de>
References: <20081016174814.734527827@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rfkill-update-leds-for-all-state-changes.patch"
In-Reply-To: <20081016175525.GA12850@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 417bd25ac4c6f76c8aafe8a584f3620f4a936b72 upstream

The LED state was not being updated by rfkill_force_state(), which
will cause regressions in wireless drivers that had old-style rfkill
support and are updated to use rfkill_force_state().

The LED state was not being updated when a change was detected through
the rfkill->get_state() hook, either.

Move the LED trigger update calls into notify_rfkill_state_change(),
where it should have been in the first place.  This takes care of both
issues above.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rfkill/rfkill.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -117,6 +117,7 @@ static void rfkill_led_trigger_activate(
 
 static void notify_rfkill_state_change(struct rfkill *rfkill)
 {
+	rfkill_led_trigger(rfkill, rfkill->state);
 	blocking_notifier_call_chain(&rfkill_notifier_list,
 			RFKILL_STATE_CHANGED,
 			rfkill);
@@ -204,10 +205,8 @@ static int rfkill_toggle_radio(struct rf
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
