Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZISVji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZISVji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZISVjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:39:35 -0400
Received: from kroah.org ([198.145.64.141]:50955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZISVjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:39:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/79] cyclades: remove more duplicated code
Date: Sat, 19 Sep 2009 14:36:25 -0700
Message-Id: <1253396244-7885-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Remove duplicated code from cy_set_line_char. There were 2 if
branches with same contents except flags.

Branch only for the flags computation and use them in the only copy
of the code.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |   45 ++++++++++++++-------------------------------
 1 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index cf2874a..f518e0b 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2057,6 +2057,8 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 	channel = info->line - card->first_line;
 
 	if (!cy_is_Z(card)) {
+		u32 cflags;
+
 		/* baud rate */
 		baud = tty_get_baud_rate(tty);
 		if (baud == 38400 && (info->port.flags & ASYNC_SPD_MASK) ==
@@ -2198,37 +2200,18 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
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
1.6.4.2

