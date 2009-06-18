Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbZFRHo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbZFRHo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760091AbZFRHml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:41 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47402 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762AbZFRHmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:40 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 13/13] Char: cyclades, remove more duplicated code
Date: Thu, 18 Jun 2009 09:41:48 +0200
Message-Id: <1245310908-27691-13-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated code from cy_set_line_char. There were 2 if
branches with same contents except flags.

Branch only for the flags computation and use them in the only copy
of the code.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |   45 ++++++++++++++-------------------------------
 1 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 76248aa..5cec450 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2056,6 +2056,8 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 	channel = info->line - card->first_line;
 
 	if (!cy_is_Z(card)) {
+		u32 cflags;
+
 		/* baud rate */
 		baud = tty_get_baud_rate(tty);
 		if (baud == 38400 && (info->port.flags & ASYNC_SPD_MASK) ==
@@ -2197,37 +2199,18 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 			(info->default_timeout ? info->default_timeout : 0x02));
 		/* 10ms rx timeout */
 
-		if (C_CLOCAL(tty)) {
-			/* without modem intr */
-			cyy_writeb(info, CySRER,
-					cyy_readb(info, CySRER) | CyMdmCh);
-			/* act on 1->0 modem transitions */
-			if ((cflag & CRTSCTS) && info->rflow) {
-				cyy_writeb(info, CyMCOR1,
-					  (CyCTS | rflow_thr[i]));
-			} else {
-				cyy_writeb(info, CyMCOR1,
-					  CyCTS);
-			}
-			/* act on 0->1 modem transitions */
-			cyy_writeb(info, CyMCOR2, CyCTS);
-		} else {
-			/* without modem intr */
-			cyy_writeb(info, CySRER,
-					cyy_readb(info, CySRER) | CyMdmCh);
-			/* act on 1->0 modem transitions */
-			if ((cflag & CRTSCTS) && info->rflow) {
-				cyy_writeb(info, CyMCOR1,
-					  (CyDSR | CyCTS | CyRI | CyDCD |
-					   rflow_thr[i]));
-			} else {
-				cyy_writeb(info, CyMCOR1,
-						CyDSR | CyCTS | CyRI | CyDCD);
-			}
-			/* act on 0->1 modem transitions */
-			cyy_writeb(info, CyMCOR2,
-					CyDSR | CyCTS | CyRI | CyDCD);
-		}
+		cflags = CyCTS;
+		if (!C_CLOCAL(tty))
+			cflags |= CyDSR | CyRI | CyDCD;
+		/* without modem intr */
+		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) | CyMdmCh);
+		/* act on 1->0 modem transitions */
+		if ((cflag & CRTSCTS) && info->rflow)
+			cyy_writeb(info, CyMCOR1, cflags | rflow_thr[i]);
+		else
+			cyy_writeb(info, CyMCOR1, cflags);
+		/* act on 0->1 modem transitions */
+		cyy_writeb(info, CyMCOR2, cflags);
 
 		if (i == 0)	/* baud rate is zero, turn off line */
 			cyy_change_rts_dtr(info, 0, TIOCM_DTR);
-- 
1.6.3.2

