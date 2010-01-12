Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469Ab0ALQ1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0ALQ1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458Ab0ALQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:27:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0ALQ07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:26:59 -0500
Date: Tue, 12 Jan 2010 11:26:34 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <5d1c072742086ff48961b0e546c55c4505432daa.1263247114.git.jbaron@redhat.com>
In-Reply-To: <cover.1263247113.git.jbaron@redhat.com>
References: <cover.1263247113.git.jbaron@redhat.com>
Subject: [RFC PATCH 4/8] jump label v4 - notifier atomic call chain notrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

notifier atomic call chain notrace

In LTTng, being able to use the atomic notifier from cpu idle entry to
ensure the tracer flush the last events in the current subbuffer
requires the rcu read-side to be marked "notrace", otherwise it can end
up calling back into lockdep and the tracer.

Also apply to the the die notifier.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Jason Baron <jbaron@redhat.com>
CC: mingo@elte.hu
---
 kernel/notifier.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index acd24e7..5bde20a 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -148,7 +148,7 @@ int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 	spin_lock_irqsave(&nh->lock, flags);
 	ret = notifier_chain_unregister(&nh->head, n);
 	spin_unlock_irqrestore(&nh->lock, flags);
-	synchronize_rcu();
+	synchronize_sched();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
@@ -178,9 +178,9 @@ int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
 {
 	int ret;
 
-	rcu_read_lock();
+	rcu_read_lock_sched_notrace();
 	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
-	rcu_read_unlock();
+	rcu_read_unlock_sched_notrace();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
-- 
1.6.5.1

