Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0AEAET (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 19:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903Ab0AEAEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:04:14 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39687 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab0AEAEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:04:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: add debug check for too many rcu_read_unlock()
Date: Mon,  4 Jan 2010 16:04:01 -0800
Message-Id: <12626498423064-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100105000337.GA23307@linux.vnet.ibm.com>
References: <20100105000337.GA23307@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

TREE_PREEMPT_RCU maintains an rcu_read_lock_nesting counter in the
task structure, which happens to be a signed int.  So this patch adds a
check for this counter being negative at the end of __rcu_read_unlock().
This check is under CONFIG_PROVE_LOCKING, so can be thought of as being
part of lockdep.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f11ebd4..e77cdf3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -304,6 +304,9 @@ void __rcu_read_unlock(void)
 	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 		rcu_read_unlock_special(t);
+#ifdef CONFIG_PROVE_LOCKING
+	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-- 
1.5.2.5

