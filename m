Return-Path: <linux-kernel-owner+w=401wt.eu-S1765520AbYDQBMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765520AbYDQBMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbYDQBHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:24 -0400
Received: from sous-sol.org ([216.99.217.87]:58831 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbYDQBHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:21 -0400
Message-Id: <20080417010343.953795252@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Chapman <jchapman@katalix.com>,
       David S Miller <davem@davemloft.net>
Subject: PPPOL2TP: Fix SMP issues in skb reorder queue handling
Content-Disposition: inline; filename=pppol2tp-fix-smp-issues-in-skb-reorder-queue-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: James Chapman <jchapman@katalix.com>

Upstream commit: e653181dd6b3ad38ce14904351b03a5388f4b0f7

When walking a session's packet reorder queue, use
skb_queue_walk_safe() since the list could be modified inside the
loop.

Rearrange the unlinking skbs from the reorder queue such that it is
done while the queue lock is held in pppol2tp_recv_dequeue() when
walking the skb list.

A version of this patch was suggested by Jarek Poplawski.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/pppol2tp.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -342,10 +342,11 @@ static struct pppol2tp_tunnel *pppol2tp_
 static void pppol2tp_recv_queue_skb(struct pppol2tp_session *session, struct sk_buff *skb)
 {
 	struct sk_buff *skbp;
+	struct sk_buff *tmp;
 	u16 ns = PPPOL2TP_SKB_CB(skb)->ns;
 
 	spin_lock_bh(&session->reorder_q.lock);
-	skb_queue_walk(&session->reorder_q, skbp) {
+	skb_queue_walk_safe(&session->reorder_q, skbp, tmp) {
 		if (PPPOL2TP_SKB_CB(skbp)->ns > ns) {
 			__skb_insert(skb, skbp->prev, skbp, &session->reorder_q);
 			PRINTK(session->debug, PPPOL2TP_MSG_SEQ, KERN_DEBUG,
@@ -371,10 +372,9 @@ static void pppol2tp_recv_dequeue_skb(st
 	int length = PPPOL2TP_SKB_CB(skb)->length;
 	struct sock *session_sock = NULL;
 
-	/* We're about to requeue the skb, so unlink it and return resources
+	/* We're about to requeue the skb, so return resources
 	 * to its current owner (a socket receive buffer).
 	 */
-	skb_unlink(skb, &session->reorder_q);
 	skb_orphan(skb);
 
 	tunnel->stats.rx_packets++;
@@ -469,6 +469,11 @@ static void pppol2tp_recv_dequeue(struct
 				goto out;
 			}
 		}
+		__skb_unlink(skb, &session->reorder_q);
+
+		/* Process the skb. We release the queue lock while we
+		 * do so to let other contexts process the queue.
+		 */
 		spin_unlock_bh(&session->reorder_q.lock);
 		pppol2tp_recv_dequeue_skb(session, skb);
 		spin_lock_bh(&session->reorder_q.lock);

-- 
