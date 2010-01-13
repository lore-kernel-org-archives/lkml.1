Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538Ab0AMK2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0AMK2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496Ab0AMK2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:28:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:58761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab0AMK2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:28:39 -0500
Date: Wed, 13 Jan 2010 10:27:58 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626498423064-git-send-email->
References: <12626498423064-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add debug check for too many rcu_read_unlock()
Message-ID: <tip-cba8244a0f1c277b6b1e48ed6504fa434119e24d@git.kernel.org>
Git-Commit-ID: cba8244a0f1c277b6b1e48ed6504fa434119e24d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:27:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cba8244a0f1c277b6b1e48ed6504fa434119e24d
Gitweb:     http://git.kernel.org/tip/cba8244a0f1c277b6b1e48ed6504fa434119e24d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 16:04:01 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:06 +0100

rcu: Add debug check for too many rcu_read_unlock()

TREE_PREEMPT_RCU maintains an rcu_read_lock_nesting counter in
the task structure, which happens to be a signed int.  So this
patch adds a check for this counter being negative at the end of
__rcu_read_unlock(). This check is under CONFIG_PROVE_LOCKING,
so can be thought of as being part of lockdep.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12626498423064-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
