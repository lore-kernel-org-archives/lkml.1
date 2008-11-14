Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbYKNXDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbYKNXDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYKNXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:24 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52196 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYKNXAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:20 -0500
Message-Id: <20081114224947.492375959@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 02/16] Marker fix unregister
Content-Disposition: inline; filename=markers-fix-unregister-private-data.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_marker() can return a NULL entry because the mutex is released in the middle
of those functions. Make sure we check to see if it has been concurrently
removed.

Impact: Bugfix.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/marker.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux.trees.git/kernel/marker.c
===================================================================
--- linux.trees.git.orig/kernel/marker.c	2008-11-14 17:38:39.000000000 -0500
+++ linux.trees.git/kernel/marker.c	2008-11-14 17:38:43.000000000 -0500
@@ -653,10 +653,11 @@ int marker_probe_register(const char *na
 		goto end;
 	}
 	mutex_unlock(&markers_mutex);
-	marker_update_probes();		/* may update entry */
+	marker_update_probes();
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
-	WARN_ON(!entry);
+	if (!entry)
+		goto end;
 	if (entry->rcu_pending)
 		rcu_barrier_sched();
 	entry->oldptr = old;
@@ -697,7 +698,7 @@ int marker_probe_unregister(const char *
 		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, probe, probe_private);
 	mutex_unlock(&markers_mutex);
-	marker_update_probes();		/* may update entry */
+	marker_update_probes();
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	if (!entry)
@@ -778,10 +779,11 @@ int marker_probe_unregister_private_data
 		rcu_barrier_sched();
 	old = marker_entry_remove_probe(entry, NULL, probe_private);
 	mutex_unlock(&markers_mutex);
-	marker_update_probes();		/* may update entry */
+	marker_update_probes();
 	mutex_lock(&markers_mutex);
 	entry = get_marker_from_private_data(probe, probe_private);
-	WARN_ON(!entry);
+	if (!entry)
+		goto end;
 	if (entry->rcu_pending)
 		rcu_barrier_sched();
 	entry->oldptr = old;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
