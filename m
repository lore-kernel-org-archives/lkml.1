Return-Path: <linux-kernel-owner+w=401wt.eu-S1765834AbXKOG1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765834AbXKOG1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764609AbXKOGWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45944 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764150AbXKOGWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:06 -0500
Date: Wed, 14 Nov 2007 22:20:35 -0800
From: Greg KH <gregkh@suse.de>
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
Subject: [patch 10/23] Fix TEQL oops.
Message-ID: <20071115062035.GK8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-teql-oops.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

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
@@ -249,6 +249,9 @@ __teql_resolve(struct sk_buff *skb, stru
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
