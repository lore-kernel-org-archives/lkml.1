Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYICRk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYICRk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbYICRkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:40:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316AbYICRkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:40:16 -0400
Date: Wed, 3 Sep 2008 10:26:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 23/42] pkt_sched: Fix return value corruption in HTB and
	TBF.
Message-ID: <20080903172605.GX7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0004-pkt_sched-Fix-return-value-corruption-in-HTB-and-TB.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 69747650c814a8a79fef412c7416adf823293a3e ]

Based upon a bug report by Josip Rodin.

Packet schedulers should only return NET_XMIT_DROP iff
the packet really was dropped.  If the packet does reach
the device after we return NET_XMIT_DROP then TCP can
crash because it depends upon the enqueue path return
values being accurate.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_htb.c |   20 ++++++++++++--------
 net/sched/sch_tbf.c |   11 ++---------
 2 files changed, 14 insertions(+), 17 deletions(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -595,11 +595,13 @@ static int htb_enqueue(struct sk_buff *s
 		kfree_skb(skb);
 		return ret;
 #endif
-	} else if (cl->un.leaf.q->enqueue(skb, cl->un.leaf.q) !=
+	} else if ((ret = cl->un.leaf.q->enqueue(skb, cl->un.leaf.q)) !=
 		   NET_XMIT_SUCCESS) {
-		sch->qstats.drops++;
-		cl->qstats.drops++;
-		return NET_XMIT_DROP;
+		if (ret == NET_XMIT_DROP) {
+			sch->qstats.drops++;
+			cl->qstats.drops++;
+		}
+		return ret;
 	} else {
 		cl->bstats.packets +=
 			skb_is_gso(skb)?skb_shinfo(skb)->gso_segs:1;
@@ -639,11 +641,13 @@ static int htb_requeue(struct sk_buff *s
 		kfree_skb(skb);
 		return ret;
 #endif
-	} else if (cl->un.leaf.q->ops->requeue(skb, cl->un.leaf.q) !=
+	} else if ((ret = cl->un.leaf.q->ops->requeue(skb, cl->un.leaf.q)) !=
 		   NET_XMIT_SUCCESS) {
-		sch->qstats.drops++;
-		cl->qstats.drops++;
-		return NET_XMIT_DROP;
+		if (ret == NET_XMIT_DROP) {
+			sch->qstats.drops++;
+			cl->qstats.drops++;
+		}
+		return ret;
 	} else
 		htb_activate(q, cl);
 
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -123,15 +123,8 @@ static int tbf_enqueue(struct sk_buff *s
 	struct tbf_sched_data *q = qdisc_priv(sch);
 	int ret;
 
-	if (skb->len > q->max_size) {
-		sch->qstats.drops++;
-#ifdef CONFIG_NET_CLS_ACT
-		if (sch->reshape_fail == NULL || sch->reshape_fail(skb, sch))
-#endif
-			kfree_skb(skb);
-
-		return NET_XMIT_DROP;
-	}
+	if (skb->len > q->max_size)
+		return qdisc_reshape_fail(skb, sch);
 
 	if ((ret = q->qdisc->enqueue(skb, q->qdisc)) != 0) {
 		sch->qstats.drops++;

-- 
