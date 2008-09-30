Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbYI3FvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbYI3FvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYI3FvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:51:15 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:58546 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbYI3FvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:51:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgEAENZ4UhMQWq+/2dsb2JhbACBZLoHgWc
Date: Tue, 30 Sep 2008 01:51:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Tracepoints fix reentrancy
Message-ID: <20080930055112.GC16961@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:49:41 up 117 days, 10:30,  8 users,  load average: 0.24, 0.26,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracepoints had the same problem markers did have wrt reentrancy. Apply a
similar fix using a rcu_barrier after each tracepoint mutex lock.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/tracepoint.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-lttng/kernel/tracepoint.c
===================================================================
--- linux-2.6-lttng.orig/kernel/tracepoint.c	2008-09-30 01:38:39.000000000 -0400
+++ linux-2.6-lttng/kernel/tracepoint.c	2008-09-30 01:39:56.000000000 -0400
@@ -361,6 +361,8 @@ int tracepoint_probe_register(const char
 	mutex_lock(&tracepoints_mutex);
 	entry = get_tracepoint(name);
 	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	tracepoint_entry_free_old(entry, old);
 end:
 	mutex_unlock(&tracepoints_mutex);
@@ -397,6 +399,8 @@ int tracepoint_probe_unregister(const ch
 	entry = get_tracepoint(name);
 	if (!entry)
 		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	tracepoint_entry_free_old(entry, old);
 	remove_tracepoint(name);	/* Ignore busy error message */
 	ret = 0;
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
