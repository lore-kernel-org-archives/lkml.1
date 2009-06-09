Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbZFIKQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbZFIKQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbZFIKPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:40 -0400
Received: from kroah.org ([198.145.64.141]:59702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759835AbZFIKPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:39 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:53 2009
Message-Id: <20090609094053.228151746@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:53 -0700
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
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 05/87] sch_teql: should not dereference skb after ndo_start_xmit()
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=sch_teql-should-not-dereference-skb-after-ndo_start_xmit.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <dada1@cosmosbay.com>

[ Upstream commit c0f84d0d4be3f7d818b4ffb04d27f9bae64397f0 ]

It is illegal to dereference a skb after a successful ndo_start_xmit()
call. We must store skb length in a local variable instead.

Bug was introduced in 2.6.27 by commit 0abf77e55a2459aa9905be4b226e4729d5b4f0cb
(net_sched: Add accessor function for packet length for qdiscs)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_teql.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -303,6 +303,8 @@ restart:
 		switch (teql_resolve(skb, skb_res, slave)) {
 		case 0:
 			if (__netif_tx_trylock(slave_txq)) {
+				unsigned int length = qdisc_pkt_len(skb);
+
 				if (!netif_tx_queue_stopped(slave_txq) &&
 				    !netif_tx_queue_frozen(slave_txq) &&
 				    slave_ops->ndo_start_xmit(skb, slave) == 0) {
@@ -310,8 +312,7 @@ restart:
 					master->slaves = NEXT_SLAVE(q);
 					netif_wake_queue(dev);
 					master->stats.tx_packets++;
-					master->stats.tx_bytes +=
-						qdisc_pkt_len(skb);
+					master->stats.tx_bytes += length;
 					return 0;
 				}
 				__netif_tx_unlock(slave_txq);


