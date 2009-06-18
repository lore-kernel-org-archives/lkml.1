Return-Path: <linux-kernel-owner+w=401wt.eu-S1759762AbZFRHml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762AbZFRHml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZFRHmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:09 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47390 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbZFRHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 04/13] Char: cyclades, switch to tty_port_hangup
Date: Thu, 18 Jun 2009 09:41:39 +0200
Message-Id: <1245310908-27691-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not duplicate common tty_port_hangup code. Use it instead.

Also do not unset ASYNC_NORMAL_ACTIVE and wake up from the
tty_hangup() caller. It makes no sense since we don't check that
flag in sleepers. tty_port_hangup() performed later will do the
right job.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 691a765..44bd42d 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1289,11 +1289,10 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
 	}
 
 	if ((mdm_change & CyDCD) && (info->port.flags & ASYNC_CHECK_CD)) {
-		if (!(mdm_status & CyDCD)) {
+		if (mdm_status & CyDCD)
+			wake_up_interruptible(&info->port.open_wait);
+		else
 			tty_hangup(tty);
-			info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-		}
-		wake_up_interruptible(&info->port.open_wait);
 	}
 	if ((mdm_change & CyCTS) && (info->port.flags & ASYNC_CTS_FLOW)) {
 		if (tty->hw_stopped) {
@@ -1654,13 +1653,10 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 			if (info->port.flags & ASYNC_CHECK_CD) {
 				u32 dcd = fw_ver > 241 ? param :
 					readl(&info->u.cyz.ch_ctrl->rs_status);
-				if (dcd & C_RS_DCD) {
+				if (dcd & C_RS_DCD)
 					wake_up_interruptible(&info->port.open_wait);
-				} else {
+				else
 					tty_hangup(tty);
-					wake_up_interruptible(&info->port.open_wait);
-					info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-				}
 			}
 			break;
 		case C_CM_MCTS:
@@ -4008,14 +4004,7 @@ static void cy_hangup(struct tty_struct *tty)
 
 	cy_flush_buffer(tty);
 	cy_shutdown(info, tty);
-	info->port.count = 0;
-#ifdef CY_DEBUG_COUNT
-	printk(KERN_DEBUG "cyc:cy_hangup (%d): setting count to 0\n",
-		current->pid);
-#endif
-	tty_port_tty_set(&info->port, NULL);
-	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	wake_up_interruptible(&info->port.open_wait);
+	tty_port_hangup(&info->port);
 }				/* cy_hangup */
 
 static int cyy_carrier_raised(struct tty_port *port)
-- 
1.6.3.2

