Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbXF0Tnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbXF0Tnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXF0Tnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:43:33 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:33611 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbXF0Tnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:43:33 -0400
Message-Id: <20070627194327.938450052@goodmis.org>
References: <20070627193633.025544061@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jun 2007 15:36:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       Jonathan Corbet <corbet@lwn.net>,
       Arjan van de Ven <arjan@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH 5/8] Convert net wireless tasklet to workqueue
Content-Disposition: inline; filename=convert-net-wireless-tasklet-workqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we want to remove DECLARE_TASKLET API, there wasn't a simple way
to do that elegantly with net/core/wireless.c, so this patch just
replaces that tasklet with a work queue directly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-2.6-test/net/core/wireless.c
===================================================================
--- linux-2.6-test.orig/net/core/wireless.c
+++ linux-2.6-test/net/core/wireless.c
@@ -1916,7 +1916,7 @@ static int __init wireless_nlevent_init(
 
 subsys_initcall(wireless_nlevent_init);
 
-static void wireless_nlevent_process(unsigned long data)
+static void wireless_nlevent_process(struct work_struct *work)
 {
 	struct sk_buff *skb;
 
@@ -1924,7 +1924,7 @@ static void wireless_nlevent_process(uns
 		rtnl_notify(skb, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
 }
 
-static DECLARE_TASKLET(wireless_nlevent_tasklet, wireless_nlevent_process, 0);
+static DECLARE_WORK(wireless_nlevent_wq, wireless_nlevent_process);
 
 /* ---------------------------------------------------------------- */
 /*
@@ -1989,7 +1989,7 @@ static inline void rtmsg_iwinfo(struct n
 	}
 	NETLINK_CB(skb).dst_group = RTNLGRP_LINK;
 	skb_queue_tail(&wireless_nlevent_queue, skb);
-	tasklet_schedule(&wireless_nlevent_tasklet);
+	schedule_work(&wireless_nlevent_wq);
 }
 
 #endif	/* WE_EVENT_RTNETLINK */

-- 
