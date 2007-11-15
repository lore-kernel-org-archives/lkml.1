Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbXKOHH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbXKOHH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765690AbXKOGsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43701 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbXKOGsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:10 -0500
Date: Wed, 14 Nov 2007 22:45:45 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 34/40] Char: moxa, fix and optimise empty timer
Message-ID: <20071115064545.GI19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="char-moxa-fix-and-optimise-empty-timer.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Slaby <jirislaby@gmail.com>

patch c43422053bea7a5ce09f18d0c50a606fe1a549f4 in mainline.

moxa, fix and optimise empty timer

don't wait and delete empty timer in empty timer function. Also fire next
empty timer at rounded jiffies to save power.

This fixes a lockup, because we wait for ourselves to finish forever.
(i.e.  sync called from the timer itself).


Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/moxa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1040,14 +1040,14 @@ static void check_xmit_empty(unsigned lo
 	struct moxa_port *ch;
 
 	ch = (struct moxa_port *) data;
-	del_timer_sync(&moxa_ports[ch->port].emptyTimer);
 	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
 		if (MoxaPortTxQueue(ch->port) == 0) {
 			ch->statusflags &= ~EMPTYWAIT;
 			tty_wakeup(ch->tty);
 			return;
 		}
-		mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
+		mod_timer(&moxa_ports[ch->port].emptyTimer,
+				round_jiffies(jiffies + HZ));
 	} else
 		ch->statusflags &= ~EMPTYWAIT;
 }

-- 
