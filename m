Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbYJJFo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbYJJFo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYJJFor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:44:47 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:61277 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756364AbYJJFoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:44:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAEOI7khMQWq+/2dsb2JhbACBcrwbgWo
Date: Fri, 10 Oct 2008 01:44:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Markers : fix check format with rcu callback race
Message-ID: <20081010054444.GB19481@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:43:11 up 127 days, 10:23, 10 users,  load average: 0.77, 0.57,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix "markers: fix unchecked format" introduced an RCU callback race. This
patch takes care of calling any pending RCU callback before set_format is
called.


* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> bit-field is not thread-safe nor smp-safe.
> 
> struct marker_entry.rcu_pending is not protected by any lock
> in rcu-callback free_old_closure().
> so we must turn it into a safe type.
> 

All struct marker_entry.rcu_pending accesses are done with the
markers_mutex held, except the one done in free_old_closure(). Normally,
there should be a
        if (entry->rcu_pending)
           rcu_barrier_sched();

At the beginning of each markers_mutex section (just after get_marker())
to make sure any pending callback is executed at that point before any
of rcu_pending or ptype are touched. 

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/marker.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-10-10 01:35:32.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-10-10 01:35:32.000000000 -0400
@@ -657,21 +657,23 @@ int marker_probe_register(const char *na
 		entry = add_marker(name, format);
 		if (IS_ERR(entry))
 			ret = PTR_ERR(entry);
-	} else if (format) {
-		if (!entry->format)
-			ret = marker_set_format(&entry, format);
-		else if (strcmp(entry->format, format))
-			ret = -EPERM;
+	} else {
+		/*
+		 * If we detect that a call_rcu is pending for this marker,
+		 * make sure it's executed now.
+		 */
+		if (entry->rcu_pending)
+			rcu_barrier_sched();
+		if (format) {
+			if (!entry->format)
+				ret = marker_set_format(&entry, format);
+			else if (strcmp(entry->format, format))
+				ret = -EPERM;
+		}
 	}
 	if (ret)
 		goto end;
 
-	/*
-	 * If we detect that a call_rcu is pending for this marker,
-	 * make sure it's executed now.
-	 */
-	if (entry->rcu_pending)
-		rcu_barrier_sched();
 	old = marker_entry_add_probe(entry, probe, probe_private);
 	if (IS_ERR(old)) {
 		ret = PTR_ERR(old);
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
