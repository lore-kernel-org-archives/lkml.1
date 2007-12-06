Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbXLFKA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbXLFKA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXLFKAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:00:12 -0500
Received: from [222.73.24.84] ([222.73.24.84]:62434 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXLFKAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:00:10 -0500
Message-ID: <4757C773.5010604@cn.fujitsu.com>
Date: Thu, 06 Dec 2007 17:57:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: davem@davemloft.net
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org, hs4233@mail.mn-solutions.de
Subject: [PATCH 3/3] wireless/libertas: don't cast a pointer to pointer of
 list_head
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't cast struct foo * to struct list_head *, it's safe only when
the list member is the first member of struct foo.

Also don't cast struct list_head * to struct foo *.


BTW: I'm not so sure where this patch should go to.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/net/wireless/libertas/cmd.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index be5cfd8..0fce9bb 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -946,11 +946,10 @@ void libertas_queue_cmd(wlan_adapter * adapter, struct cmd_ctrl_node *cmdnode, u
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
 	if (addtail) {
-		list_add_tail((struct list_head *)cmdnode,
-			      &adapter->cmdpendingq);
+		list_add_tail(&cmdnode->list, &adapter->cmdpendingq);
 		adapter->nr_cmd_pending++;
 	} else
-		list_add((struct list_head *)cmdnode, &adapter->cmdpendingq);
+		list_add(&cmdnode->list, &adapter->cmdpendingq);
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
@@ -1068,7 +1067,7 @@ void __libertas_cleanup_and_insert_cmd(wlan_private * priv, struct cmd_ctrl_node
 		return;
 
 	cleanup_cmdnode(ptempcmd);
-	list_add_tail((struct list_head *)ptempcmd, &adapter->cmdfreeq);
+	list_add_tail(&ptempcmd->list, &adapter->cmdfreeq);
 }
 
 static void libertas_cleanup_and_insert_cmd(wlan_private * priv, struct cmd_ctrl_node *ptempcmd)
@@ -1558,8 +1557,9 @@ struct cmd_ctrl_node *libertas_get_free_cmd_ctrl_node(wlan_private * priv)
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
 	if (!list_empty(&adapter->cmdfreeq)) {
-		tempnode = (struct cmd_ctrl_node *)adapter->cmdfreeq.next;
-		list_del((struct list_head *)tempnode);
+		tempnode = list_first_entry(&adapter->cmdfreeq,
+					    struct cmd_ctrl_node, list);
+		list_del(&tempnode->list);
 	} else {
 		lbs_deb_host("GET_CMD_NODE: cmd_ctrl_node is not available\n");
 		tempnode = NULL;
@@ -1656,8 +1656,8 @@ int libertas_execute_next_command(wlan_private * priv)
 	}
 
 	if (!list_empty(&adapter->cmdpendingq)) {
-		cmdnode = (struct cmd_ctrl_node *)
-		    adapter->cmdpendingq.next;
+		cmdnode = list_first_entry(&adapter->cmdpendingq,
+					   struct cmd_ctrl_node, list);
 	}
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
@@ -1721,7 +1721,7 @@ int libertas_execute_next_command(wlan_private * priv)
 				    cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
-					list_del((struct list_head *)cmdnode);
+					list_del(&cmdnode->list);
 					libertas_cleanup_and_insert_cmd(priv, cmdnode);
 
 					ret = 0;
@@ -1732,7 +1732,7 @@ int libertas_execute_next_command(wlan_private * priv)
 				    (adapter->psstate == PS_STATE_PRE_SLEEP)) {
 					lbs_deb_host(
 					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
-					list_del((struct list_head *)cmdnode);
+					list_del(&cmdnode->list);
 					libertas_cleanup_and_insert_cmd(priv, cmdnode);
 					adapter->needtowakeup = 1;
 
@@ -1744,7 +1744,7 @@ int libertas_execute_next_command(wlan_private * priv)
 				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
 			}
 		}
-		list_del((struct list_head *)cmdnode);
+		list_del(&cmdnode->list);
 		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
 			    le16_to_cpu(cmdptr->command));
 		DownloadcommandToStation(priv, cmdnode);
-- 
1.5.3.rc7

