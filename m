Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYJJLQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYJJLQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYJJLQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:16:26 -0400
Received: from perso1.free.fr ([212.27.63.203]:50300 "EHLO perso1.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbYJJLQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:16:25 -0400
XPARM: thesermon.free.fr
XPARAM2: 193.50.29.42
Subject: [PATCH 2/6] tracepoint: Check if the probe has been registered
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 10 Oct 2008 13:16:31
To: Ingo Molnar <mingo@elte.hu>
Message-Id: <20081010111631.78545D1BDA2@perso1.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we try to remove a probe that has not been already registered,
the tracepoint_entry_remove_probe() function will dereference a NULL
pointer.
Check the probe before removing it to avoid crashes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/tracepoint.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index f2b7c28..af8c856 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -131,6 +131,9 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry, void *probe)
 
 	old = entry->funcs;
 
+	if (!old)
+		return NULL;
+
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
 	for (nr_probes = 0; old[nr_probes]; nr_probes++) {
@@ -388,6 +391,11 @@ int tracepoint_probe_unregister(const char *name, void *probe)
 	if (entry->rcu_pending)
 		rcu_barrier_sched();
 	old = tracepoint_entry_remove_probe(entry, probe);
+	if (!old) {
+		printk(KERN_WARNING "Warning: Trying to unregister a probe"
+				    "that doesn't exist\n");
+		goto end;
+	}
 	mutex_unlock(&tracepoints_mutex);
 	tracepoint_update_probes();		/* may update entry */
 	mutex_lock(&tracepoints_mutex);

