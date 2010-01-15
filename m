Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0AOBEv (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129Ab0AOBDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:03:04 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50335 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0AOBDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:03:03 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 8/9] idr: apply lockdep-based diagnostics to rcu_dereference() uses
Date: Thu, 14 Jan 2010 17:02:45 -0800
Message-Id: <12635173672978-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100115010157.GA28221@linux.vnet.ibm.com>
References: <20100115010157.GA28221@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Because idr can be used with any of a number of locks or with any
flavor of RCU, just disable the lockdep-based diagnostics.  If idr
needs diagnostics, the check expression will need to be passed into
the relevant idr primitives as an additional argument.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/idr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 1cac726..4877fce 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -502,7 +502,7 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 	n = (p->layer+1) * IDR_BITS;
@@ -517,7 +517,7 @@ void *idr_find(struct idr *idp, int id)
 	while (n > 0 && p) {
 		n -= IDR_BITS;
 		BUG_ON(n != p->layer*IDR_BITS);
-		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+		p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
 }
@@ -550,7 +550,7 @@ int idr_for_each(struct idr *idp,
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	max = 1 << n;
 
 	id = 0;
@@ -558,7 +558,7 @@ int idr_for_each(struct idr *idp,
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
-			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 		}
 
 		if (p) {
-- 
1.5.2.5

