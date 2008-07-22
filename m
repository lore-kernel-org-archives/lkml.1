Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYGVXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYGVXVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYGVXSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:18:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:52881 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbYGVXSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:18:11 -0400
Date: Tue, 22 Jul 2008 16:14:55 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, Leonid <leonidv11@gmail.com>
Subject: [patch 11/47] USB: ehci - fix timer regression
Message-ID: <20080722231455.GL8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ehci-fix-timer-regression.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Brownell <david-b@pacbell.net>

commit 056761e55c8687ddf3db14226213f2e8dc2689bc upstream

This patch fixes a regression in the EHCI driver's TIMER_IO_WATCHDOG
behavior.  The patch "USB: EHCI: add separate IAA watchdog timer" changed
how that timer is handled, so that short timeouts on the remaining
timer (unfortunately, overloaded) would never be used.

This takes a more direct approach, reorganizing the code slightly to
be explicit about only the I/O watchdog role now being overridable.
It also replaces a now-obsolete comment describing older timer behavior.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Leonid <leonidv11@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci.h |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -176,6 +176,15 @@ timer_action_done (struct ehci_hcd *ehci
 static inline void
 timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
 {
+	/* Don't override timeouts which shrink or (later) disable
+	 * the async ring; just the I/O watchdog.  Note that if a
+	 * SHRINK were pending, OFF would never be requested.
+	 */
+	if (timer_pending(&ehci->watchdog)
+			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
+				& ehci->actions))
+		return;
+
 	if (!test_and_set_bit (action, &ehci->actions)) {
 		unsigned long t;
 
@@ -191,15 +200,7 @@ timer_action (struct ehci_hcd *ehci, enu
 			t = EHCI_SHRINK_JIFFIES;
 			break;
 		}
-		t += jiffies;
-		// all timings except IAA watchdog can be overridden.
-		// async queue SHRINK often precedes IAA.  while it's ready
-		// to go OFF neither can matter, and afterwards the IO
-		// watchdog stops unless there's still periodic traffic.
-		if (time_before_eq(t, ehci->watchdog.expires)
-				&& timer_pending (&ehci->watchdog))
-			return;
-		mod_timer (&ehci->watchdog, t);
+		mod_timer(&ehci->watchdog, t + jiffies);
 	}
 }
 

-- 
