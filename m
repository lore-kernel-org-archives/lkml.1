Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbYEMURk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbYEMURk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762060AbYEMUO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:14:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:38197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762054AbYEMUO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:28 -0400
Date: Tue, 13 May 2008 13:12:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/37] sch_htb: remove from event queue in
	htb_parent_to_leaf()
Message-ID: <20080513201201.GN31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sch_htb-remove-from-event-queue-in-htb_parent_to_leaf.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit: 3ba08b00e0d8413d79be9cab8ec085ceb6ae6fd6 ]

There is lack of removing a class from the event queue while changing
from parent to leaf which can cause corruption of this rb tree. This
patch fixes a bug introduced by my patch: "sch_htb: turn intermediate
classes into leaves" commit: 160d5e10f87b1dc88fd9b84b31b1718e0fd76398.

Many thanks to Jan 'yanek' Bortl for finding a way to reproduce this
rare bug and narrowing the test case, which made possible proper
diagnosing.

This patch is recommended for all kernels starting from 2.6.20.

Reported-and-tested-by: Jan 'yanek' Bortl <yanek@ya.bofh.cz>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_htb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1197,12 +1197,16 @@ static inline int htb_parent_last_child(
 	return 1;
 }
 
-static void htb_parent_to_leaf(struct htb_class *cl, struct Qdisc *new_q)
+static void htb_parent_to_leaf(struct htb_sched *q, struct htb_class *cl,
+			       struct Qdisc *new_q)
 {
 	struct htb_class *parent = cl->parent;
 
 	BUG_TRAP(!cl->level && cl->un.leaf.q && !cl->prio_activity);
 
+	if (parent->cmode != HTB_CAN_SEND)
+		htb_safe_rb_erase(&parent->pq_node, q->wait_pq + parent->level);
+
 	parent->level = 0;
 	memset(&parent->un.inner, 0, sizeof(parent->un.inner));
 	INIT_LIST_HEAD(&parent->un.leaf.drop_list);
@@ -1300,7 +1304,7 @@ static int htb_delete(struct Qdisc *sch,
 		htb_deactivate(q, cl);
 
 	if (last_child)
-		htb_parent_to_leaf(cl, new_q);
+		htb_parent_to_leaf(q, cl, new_q);
 
 	if (--cl->refcnt == 0)
 		htb_destroy_class(sch, cl);

-- 
