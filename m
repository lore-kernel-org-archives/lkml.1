Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZDFPj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZDFPj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZDFPfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:35:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56994 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756639AbZDFPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:35:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 17/27] tty: moxa, fix refcounting in moxa_poll_port
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:34:04 +0100
Message-ID: <20090406163401.12934.35147.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

There is missing tty_kref_put on some paths in moxa_poll_port,
although the reference is always taken. Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Jan 'Yenya' Kasprzak <kas@fi.muni.cz>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

