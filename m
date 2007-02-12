Return-Path: <linux-kernel-owner+w=401wt.eu-S964805AbXBLJJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbXBLJJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964791AbXBLJIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:54 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:42675 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:38:18 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 02/10] nfnetlink_log: stop reference leak
Message-ID: <20070212003818.GC8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop reference leaking in nfulnl_log_packet(). If we start a timer we
are already taking another reference.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.0	2007-02-11 20:20:27.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:51:57.000000000 +0100
@@ -705,15 +705,16 @@ nfulnl_log_packet(unsigned int pf,
 		inst->timer.expires = jiffies + (inst->flushtimeout*HZ/100);
 		add_timer(&inst->timer);
 	}
-	spin_unlock_bh(&inst->lock);
 
+unlock_and_release:
+	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 	return;
 
 alloc_failure:
-	spin_unlock_bh(&inst->lock);
-	instance_put(inst);
 	UDEBUG("error allocating skb\n");
 	/* FIXME: statistics */
+	goto unlock_and_release;
 }
 
 static int
