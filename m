Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXKSSYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXKSSYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbXKSSVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:21:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbXKSSVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:21:49 -0500
Date: Mon, 19 Nov 2007 10:18:48 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/26] Fix TEQL oops.
Message-ID: <20071119181848.GI15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-teql-oops.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

[PKT_SCHED]: Fix OOPS when removing devices from a teql queuing discipline

[ Upstream commit: 4f9f8311a08c0d95c70261264a2b47f2ae99683a ]

tecl_reset() is called from deactivate and qdisc is set to noop already,
but subsequent teql_xmit does not know about it and dereference private
data as teql qdisc and thus oopses.
not catch it first :)

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_teql.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -263,6 +263,9 @@ __teql_resolve(struct sk_buff *skb, stru
 static __inline__ int
 teql_resolve(struct sk_buff *skb, struct sk_buff *skb_res, struct net_device *dev)
 {
+	if (dev->qdisc == &noop_qdisc)
+		return -ENODEV;
+
 	if (dev->hard_header == NULL ||
 	    skb->dst == NULL ||
 	    skb->dst->neighbour == NULL)

-- 
