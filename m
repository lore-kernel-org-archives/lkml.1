Return-Path: <linux-kernel-owner+w=401wt.eu-S1763862AbXGYVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763862AbXGYVnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXGYVnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:43:06 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:51360 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753763AbXGYVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:43:05 -0400
Message-id: <31400312111566521886@wsc.cz>
Subject: [PATCH 1/1] Char: moxa, fix and optimise empty timer
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jul 2007 23:43:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

moxa, fix and optimise empty timer

don't wait and delete empty timer in empty timer function. Also fire next
empty timer at rounded jiffies to save power.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit da52793b6347e8b6b048526ce2422e29b20bb335
tree ad0bee78e45beef89dc740f81e0606d782296542
parent 3a69b463dcad1ff142f46e8fb74e7dc5a092eb60
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 23:42:49 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 23:42:49 +0200

 drivers/char/moxa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index ed76f0a..5000b3b 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1040,14 +1040,14 @@ static void check_xmit_empty(unsigned long data)
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
