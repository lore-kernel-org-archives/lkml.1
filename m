Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbXBLJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbXBLJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXBLJI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:56 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:43864 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:38:33 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 03/10] nfnetlink_log: kill duplicate code
Message-ID: <20070212003833.GD8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kill some duplicate code in nfulnl_log_packet().

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.1	2007-02-11 20:51:57.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:43:24.000000000 +0100
@@ -666,30 +666,23 @@ nfulnl_log_packet(unsigned int pf,
 		break;
 	
 	default:
-		spin_unlock_bh(&inst->lock);
-		instance_put(inst);
-		return;
+		goto unlock_and_release;
 	}
 
-	if (!inst->skb) {
-		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
-			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
-				inst->nlbufsiz, size);
-			goto alloc_failure;
-		}
-	} else if (inst->qlen >= qthreshold ||
-		   size > skb_tailroom(inst->skb)) {
+	if (inst->qlen >= qthreshold ||
+		   (inst->skb && size > skb_tailroom(inst->skb))) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
 
 		__nfulnl_send(inst);
+	}
 
-		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
-			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
-				inst->nlbufsiz, size);
+	if (!inst->skb) {
+		inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size);
+
+		if (!inst->skb)
 			goto alloc_failure;
-		}
 	}
 
 	UDEBUG("qlen %d, qthreshold %d\n", inst->qlen, qthreshold);
