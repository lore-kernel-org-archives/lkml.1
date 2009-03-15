Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZCOJi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZCOJi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZCOJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:38:19 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:50069 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbZCOJiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:38:18 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Yenya Kasprzak <kas@fi.muni.cz>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] Char: moxa, fix refcounting in moxa_poll_port
Date: Sun, 15 Mar 2009 10:37:24 +0100
Message-Id: <1237109844-3866-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <49BCCAE0.6010303@gmail.com>
References: <49BCCAE0.6010303@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repost, sorry, scripts don't understand Reported-by.

--

There is missing tty_kref_put on some paths in moxa_poll_port,
although the reference is always taken. Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Jan 'Yenya' Kasprzak <kas@fi.muni.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/moxa.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 8b0da97..4a4cab7 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1486,11 +1486,11 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 	}
 
 	if (!handle) /* nothing else to do */
-		return 0;
+		goto put;
 
 	intr = readw(ip); /* port irq status */
 	if (intr == 0)
-		return 0;
+		goto put;
 
 	writew(0, ip); /* ACK port */
 	ofsAddr = p->tableAddr;
@@ -1499,16 +1499,17 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 				ofsAddr + HostStat);
 
 	if (!inited)
-		return 0;
+		goto put;
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
 		tty_insert_flip_char(tty, 0, TTY_BREAK);
 		tty_schedule_flip(tty);
 	}
-	tty_kref_put(tty);
 
 	if (intr & IntrLine)
 		moxa_new_dcdstate(p, readb(ofsAddr + FlagStat) & DCD_state);
+put:
+	tty_kref_put(tty);
 
 	return 0;
 }
-- 
1.6.2

