Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYGHUbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYGHUbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYGHUa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:30:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYGHUa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:30:58 -0400
Message-ID: <4873CE05.2030001@redhat.com>
Date: Tue, 08 Jul 2008 16:28:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Hideo AOKI <haoki@redhat.com>,
       Takahiro Yasui <tyasui@redhat.com>
Subject: [PATCH -mm] markers: avoid call_rcu_sched if old is NULL
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce marker_entry_free_old() and check old pointer is NULL before
setting call_rcu_sched(), because marker_entry_remove/add_probe() can
return NULL.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/marker.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

Mathieu, I think this might be a bug. Tracepoint also has
same bug...

Index: 2.6.26-rc8-mm1/kernel/marker.c
===================================================================
--- 2.6.26-rc8-mm1.orig/kernel/marker.c	2008-07-07 11:42:04.000000000 -0400
+++ 2.6.26-rc8-mm1/kernel/marker.c	2008-07-07 11:42:04.000000000 -0400
@@ -201,6 +201,17 @@ static void free_old_closure(struct rcu_
 	entry->rcu_pending = 0;
 }

+static void marker_entry_free_old(struct marker_entry *entry, void *old)
+{
+	if (!old)
+		return;
+	entry->oldptr = old;
+	entry->rcu_pending = 1;
+	/* write rcu_pending before calling the RCU callback */
+	smp_wmb();
+	call_rcu_sched(&entry->rcu, free_old_closure);
+}
+
 static void debug_print_probes(struct marker_entry *entry)
 {
 	int i;
@@ -666,11 +677,7 @@ int marker_probe_register(const char *na
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	WARN_ON(!entry);
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
+	marker_entry_free_old(entry, old);
 end:
 	mutex_unlock(&markers_mutex);
 	return ret;
@@ -709,11 +716,7 @@ int marker_probe_unregister(const char *
 	entry = get_marker(name);
 	if (!entry)
 		goto end;
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
+	marker_entry_free_old(entry, old);
 	remove_marker(name);	/* Ignore busy error message */
 	ret = 0;
 end:
@@ -787,11 +790,7 @@ int marker_probe_unregister_private_data
 	mutex_lock(&markers_mutex);
 	entry = get_marker_from_private_data(probe, probe_private);
 	WARN_ON(!entry);
-	entry->oldptr = old;
-	entry->rcu_pending = 1;
-	/* write rcu_pending before calling the RCU callback */
-	smp_wmb();
-	call_rcu_sched(&entry->rcu, free_old_closure);
+	marker_entry_free_old(entry, old);
 	remove_marker(entry->name);	/* Ignore busy error message */
 end:
 	mutex_unlock(&markers_mutex);
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

