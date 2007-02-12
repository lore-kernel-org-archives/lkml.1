Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXBLUXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXBLUXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965370AbXBLUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:23:14 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:58910 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965369AbXBLUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:23:13 -0500
Date: Mon, 12 Feb 2007 21:22:55 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 13/14] nfnetlink_log: fix reference counting
Message-ID: <20070212202255.GD28704@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070212202052.GA28704@rere.qmqm.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix reference counting (memory leak) problem in __nfulnl_send() and callers
related to packet queueing.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.11	2007-02-12 17:35:50.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:58:01.000000000 +0100
@@ -223,6 +223,11 @@ _instance_destroy2(struct nfulnl_instanc
 
 	spin_lock_bh(&inst->lock);
 	if (inst->skb) {
+		/* timer "holds" one reference (we have one more) */
+		if (timer_pending(&inst->timer)) {
+			del_timer(&inst->timer);
+			instance_put(inst);
+		}
 		if (inst->qlen)
 			__nfulnl_send(inst);
 		if (inst->skb) {
@@ -370,9 +375,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
 
-	if (timer_pending(&inst->timer))
-		del_timer(&inst->timer);
-
 	if (!inst->skb)
 		return 0;
 
@@ -399,6 +401,8 @@ static void nfulnl_timer(unsigned long d
 	UDEBUG("timer function called, flushing buffer\n");
 
 	spin_lock_bh(&inst->lock);
+	if (timer_pending(&inst->timer))	/* is it always true or false here? */
+		del_timer(&inst->timer);
 	__nfulnl_send(inst);
 	spin_unlock_bh(&inst->lock);
 	instance_put(inst);
@@ -683,6 +687,11 @@ nfulnl_log_packet(unsigned int pf,
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
 
+		/* timer "holds" one reference (we have another one) */
+		if (timer_pending(&inst->timer)) {
+			del_timer(&inst->timer);
+			instance_put(inst);
+		}
 		__nfulnl_send(inst);
 	}
 
