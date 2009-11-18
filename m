Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZKRXiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZKRXiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbZKRXiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:38:12 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:48271 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394AbZKRXiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:38:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAK8TBEtGGN1W/2dsb2JhbACBTdgRhDsEgW8
Date: Wed, 18 Nov 2009 18:38:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] notifier atomic call chain notrace
Message-ID: <20091118233815.GA28962@Krystal>
References: <cover.1258580048.git.jbaron@redhat.com> <14acd28665b633909f7e9873861075fd657e9a52.1258580048.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <14acd28665b633909f7e9873861075fd657e9a52.1258580048.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:33:07 up 92 days, 10:22,  4 users,  load average: 0.26, 0.22,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> Note that this is conditional on gcc >= 4.5. Also there is a !lockdep
> condition. This is b/c the die_notifier takes an rcu_read_lock() on the
> int3 trap, which then causes another one etc. Since, we aren't going to be
> installing removing the handler, the rcu_read_lock() could be avoided for this
> case with some code restructuring.
> 
[snip]

Would the following patch help ? I use it in the LTTng tree to alleviate
this problem.


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
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/kernel/notifier.c
===================================================================
--- linux-2.6-lttng.orig/kernel/notifier.c	2009-11-12 17:58:56.000000000 -0500
+++ linux-2.6-lttng/kernel/notifier.c	2009-11-12 18:03:28.000000000 -0500
@@ -148,7 +148,7 @@ int atomic_notifier_chain_unregister(str
 	spin_lock_irqsave(&nh->lock, flags);
 	ret = notifier_chain_unregister(&nh->head, n);
 	spin_unlock_irqrestore(&nh->lock, flags);
-	synchronize_rcu();
+	synchronize_sched();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
@@ -178,9 +178,9 @@ int __kprobes __atomic_notifier_call_cha
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
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
