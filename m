Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZHTVvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZHTVvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932073AbZHTVvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:51:11 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:62222 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbZHTVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:51:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKFijUqrR7MV/2dsb2JhbAC+dogvkQcFhBg
X-IronPort-AV: E=Sophos;i="4.43,416,1246838400"; 
   d="scan'208";a="197502596"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Is adding requeue_delayed_work() a good idea
X-Message-Flag: Warning: May contain useful information
Date: Thu, 20 Aug 2009 14:51:10 -0700
Message-ID: <adazl9uw3w1.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Aug 2009 21:51:10.0608 (UTC) FILETIME=[5469A100:01CA21E0]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the following patch queued up for 2.6.32.  It fixes a
(theoretical, lockdep-reported) deadlock involving the del_timer_sync()
inside cancel_delayed_work(); the code in question really wants to
reschedule delayed work if the timeout it's keeping track of changes,
but the only way to do this now with delayed work is to cancel the work
and then queue it again.

My patch goes back to an open-coded version of delayed work that splits
the timer and the work struct.  However it occurs to me that an API like
requeue_delayed_work() that does a mod_timer() on the delayed work
struct might be useful -- OTOH making this fully general and keeping
track of the work's pending bit etc seems perhaps a bit dicy.

Thoughts?

 - Roland


IB/mad: Fix possible lock-lock-timer deadlock

Lockdep reported a possible deadlock with cm_id_priv->lock,
mad_agent_priv->lock and mad_agent_priv->timed_work.timer; this
happens because the mad module does

	cancel_delayed_work(&mad_agent_priv->timed_work);

while holding mad_agent_priv->lock.  cancel_delayed_work() internally
does del_timer_sync(&mad_agent_priv->timed_work.timer).

This can turn into a deadlock because mad_agent_priv->lock is taken
inside cm_id_priv->lock, so we can get the following set of contexts
that deadlock each other:

 A: holding cm_id_priv->lock, waiting for mad_agent_priv->lock
 B: holding mad_agent_priv->lock, waiting for del_timer_sync()
 C: interrupt during mad_agent_priv->timed_work.timer that takes
    cm_id_priv->lock

Fix this by splitting the delayed work struct into a normal work
struct and a timer, and using mod_timer() instead of
cancel_delayed_work() plus queue_delayed_work() (which internally
becomes del_timer_sync() plus add_timer()).

Addresses: http://bugzilla.kernel.org/show_bug.cgi?id=13757
Reported-by: Bart Van Assche <bart.vanassche@gmail.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/core/mad.c      |   51 +++++++++++++++++------------------
 drivers/infiniband/core/mad_priv.h |    3 +-
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index de922a0..e8c05b2 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -175,6 +175,15 @@ int ib_response_mad(struct ib_mad *mad)
 }
 EXPORT_SYMBOL(ib_response_mad);
 
+static void timeout_callback(unsigned long data)
+{
+	struct ib_mad_agent_private *mad_agent_priv =
+		(struct ib_mad_agent_private *) data;
+
+	queue_work(mad_agent_priv->qp_info->port_priv->wq,
+		   &mad_agent_priv->timeout_work);
+}
+
 /*
  * ib_register_mad_agent - Register to send/receive MADs
  */
@@ -306,7 +315,9 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	INIT_LIST_HEAD(&mad_agent_priv->wait_list);
 	INIT_LIST_HEAD(&mad_agent_priv->done_list);
 	INIT_LIST_HEAD(&mad_agent_priv->rmpp_list);
-	INIT_DELAYED_WORK(&mad_agent_priv->timed_work, timeout_sends);
+	INIT_WORK(&mad_agent_priv->timeout_work, timeout_sends);
+	setup_timer(&mad_agent_priv->timeout_timer, timeout_callback,
+		    (unsigned long) mad_agent_priv);
 	INIT_LIST_HEAD(&mad_agent_priv->local_list);
 	INIT_WORK(&mad_agent_priv->local_work, local_completions);
 	atomic_set(&mad_agent_priv->refcount, 1);
@@ -513,7 +524,8 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	 */
 	cancel_mads(mad_agent_priv);
 	port_priv = mad_agent_priv->qp_info->port_priv;
-	cancel_delayed_work(&mad_agent_priv->timed_work);
+	del_timer_sync(&mad_agent_priv->timeout_timer);
+	cancel_work_sync(&mad_agent_priv->timeout_work);
 
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
 	remove_mad_reg_req(mad_agent_priv);
@@ -1971,10 +1983,9 @@ out:
 static void adjust_timeout(struct ib_mad_agent_private *mad_agent_priv)
 {
 	struct ib_mad_send_wr_private *mad_send_wr;
-	unsigned long delay;
 
 	if (list_empty(&mad_agent_priv->wait_list)) {
-		cancel_delayed_work(&mad_agent_priv->timed_work);
+		del_timer(&mad_agent_priv->timeout_timer);
 	} else {
 		mad_send_wr = list_entry(mad_agent_priv->wait_list.next,
 					 struct ib_mad_send_wr_private,
@@ -1983,13 +1994,8 @@ static void adjust_timeout(struct ib_mad_agent_private *mad_agent_priv)
 		if (time_after(mad_agent_priv->timeout,
 			       mad_send_wr->timeout)) {
 			mad_agent_priv->timeout = mad_send_wr->timeout;
-			cancel_delayed_work(&mad_agent_priv->timed_work);
-			delay = mad_send_wr->timeout - jiffies;
-			if ((long)delay <= 0)
-				delay = 1;
-			queue_delayed_work(mad_agent_priv->qp_info->
-					   port_priv->wq,
-					   &mad_agent_priv->timed_work, delay);
+			mod_timer(&mad_agent_priv->timeout_timer,
+				  mad_send_wr->timeout);
 		}
 	}
 }
@@ -2016,17 +2022,14 @@ static void wait_for_response(struct ib_mad_send_wr_private *mad_send_wr)
 				       temp_mad_send_wr->timeout))
 				break;
 		}
-	}
-	else
+	} else
 		list_item = &mad_agent_priv->wait_list;
 	list_add(&mad_send_wr->agent_list, list_item);
 
 	/* Reschedule a work item if we have a shorter timeout */
-	if (mad_agent_priv->wait_list.next == &mad_send_wr->agent_list) {
-		cancel_delayed_work(&mad_agent_priv->timed_work);
-		queue_delayed_work(mad_agent_priv->qp_info->port_priv->wq,
-				   &mad_agent_priv->timed_work, delay);
-	}
+	if (mad_agent_priv->wait_list.next == &mad_send_wr->agent_list)
+		mod_timer(&mad_agent_priv->timeout_timer,
+			  mad_send_wr->timeout);
 }
 
 void ib_reset_mad_timeout(struct ib_mad_send_wr_private *mad_send_wr,
@@ -2470,10 +2473,10 @@ static void timeout_sends(struct work_struct *work)
 	struct ib_mad_agent_private *mad_agent_priv;
 	struct ib_mad_send_wr_private *mad_send_wr;
 	struct ib_mad_send_wc mad_send_wc;
-	unsigned long flags, delay;
+	unsigned long flags;
 
 	mad_agent_priv = container_of(work, struct ib_mad_agent_private,
-				      timed_work.work);
+				      timeout_work);
 	mad_send_wc.vendor_err = 0;
 
 	spin_lock_irqsave(&mad_agent_priv->lock, flags);
@@ -2483,12 +2486,8 @@ static void timeout_sends(struct work_struct *work)
 					 agent_list);
 
 		if (time_after(mad_send_wr->timeout, jiffies)) {
-			delay = mad_send_wr->timeout - jiffies;
-			if ((long)delay <= 0)
-				delay = 1;
-			queue_delayed_work(mad_agent_priv->qp_info->
-					   port_priv->wq,
-					   &mad_agent_priv->timed_work, delay);
+			mod_timer(&mad_agent_priv->timeout_timer,
+				  mad_send_wr->timeout);
 			break;
 		}
 
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 05ce331..1526fa2 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -99,7 +99,8 @@ struct ib_mad_agent_private {
 	struct list_head send_list;
 	struct list_head wait_list;
 	struct list_head done_list;
-	struct delayed_work timed_work;
+	struct work_struct timeout_work;
+	struct timer_list timeout_timer;
 	unsigned long timeout;
 	struct list_head local_list;
 	struct work_struct local_work;
-- 
1.6.4

