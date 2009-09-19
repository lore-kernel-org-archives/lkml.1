Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZISVik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZISVik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZISVii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:38:38 -0400
Received: from kroah.org ([198.145.64.141]:50918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZISVih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:38:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/79] cyclades: switch to tty_port_hangup
Date: Sat, 19 Sep 2009 14:36:16 -0700
Message-Id: <1253396244-7885-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Do not duplicate common tty_port_hangup code. Use it instead.

Also do not unset ASYNC_NORMAL_ACTIVE and wake up from the
tty_hangup() caller. It makes no sense since we don't check that
flag in sleepers. tty_port_hangup() performed later will do the
right job.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 7a7092a..226175d 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1290,11 +1290,10 @@ static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
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
@@ -1655,13 +1654,10 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
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
@@ -4009,14 +4005,7 @@ static void cy_hangup(struct tty_struct *tty)
 
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
1.6.4.2

