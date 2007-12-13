Return-Path: <linux-kernel-owner+w=401wt.eu-S1762473AbXLMG5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473AbXLMG5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760901AbXLMGzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55018 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760839AbXLMGzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:42 -0500
Date: Wed, 12 Dec 2007 22:51:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 06/60] PKT_SCHED: Check subqueue status before calling
	hard_start_xmit
Message-ID: <20071213065119.GG6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pkt_sched-check-subqueue-status-before-calling-hard_start_xmit.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>

[PKT_SCHED]: Check subqueue status before calling hard_start_xmit

[ Upstream commit: 5f1a485d5905aa641f33009019b3699076666a4c ]

The only qdiscs that check subqueue state before dequeue'ing are PRIO
and RR.  The other qdiscs, including the default pfifo_fast qdisc,
will allow traffic bound for subqueue 0 through to hard_start_xmit.
The check for netif_queue_stopped() is done above in pkt_sched.h, so
it is unnecessary for qdisc_restart().  However, if the underlying
driver is multiqueue capable, and only sets queue states on subqueues,
this will allow packets to enter the driver when it's currently unable
to process packets, resulting in expensive requeues and driver
entries.  This patch re-adds the check for the subqueue status before
calling hard_start_xmit, so we can try and avoid the driver entry when
the queues are stopped.

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -135,7 +135,7 @@ static inline int qdisc_restart(struct n
 	struct Qdisc *q = dev->qdisc;
 	struct sk_buff *skb;
 	unsigned lockless;
-	int ret;
+	int ret = NETDEV_TX_BUSY;
 
 	/* Dequeue packet */
 	if (unlikely((skb = dev_dequeue_skb(dev, q)) == NULL))
@@ -158,7 +158,8 @@ static inline int qdisc_restart(struct n
 	/* And release queue */
 	spin_unlock(&dev->queue_lock);
 
-	ret = dev_hard_start_xmit(skb, dev);
+	if (!netif_subqueue_stopped(dev, skb->queue_mapping))
+		ret = dev_hard_start_xmit(skb, dev);
 
 	if (!lockless)
 		netif_tx_unlock(dev);

-- 
