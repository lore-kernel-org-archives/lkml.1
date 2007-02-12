Return-Path: <linux-kernel-owner+w=401wt.eu-S964799AbXBLJJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799AbXBLJJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964804AbXBLJJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:09:31 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:35034 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:39:28 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 05/10] nfnetlink_log: micro-optimization for inst==NULL in nfulnl_recv_config()
Message-ID: <20070212003928.GF8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple micro-optimization: don't call instance_put() on known NULL pointers.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.3	2007-02-11 20:46:33.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:46:26.000000000 +0100
@@ -814,13 +814,13 @@ nfulnl_recv_config(struct sock *ctnl, st
 					       NETLINK_CB(skb).pid);
 			if (!inst) {
 				ret = -EINVAL;
-				goto out_put;
+				goto out_null;
 			}
 			break;
 		case NFULNL_CFG_CMD_UNBIND:
 			if (!inst) {
 				ret = -ENODEV;
-				goto out_put;
+				goto out_null;
 			}
 
 			if (inst->peer_pid != NETLINK_CB(skb).pid) {
@@ -850,7 +850,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 				"group=%u pid=%u =>ENOENT\n",
 				group_num, NETLINK_CB(skb).pid);
 			ret = -ENOENT;
-			goto out_put;
+			goto out_null;
 		}
 
 		if (inst->peer_pid != NETLINK_CB(skb).pid) {
@@ -897,6 +897,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 
 out_put:
 	instance_put(inst);
+out_null:
 	return ret;
 }
 
