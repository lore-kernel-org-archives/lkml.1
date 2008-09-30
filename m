Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbYI3FmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbYI3FmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYI3Fly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:41:54 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:59937 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbYI3Flx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:41:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgEAKBX4UhMQWq+/2dsb2JhbACBZLl/gWc
Date: Tue, 30 Sep 2008 01:41:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] Markers : fix reentrancy
Message-ID: <20080930054151.GA16961@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:33:34 up 117 days, 10:13,  8 users,  load average: 0.40, 0.46,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan <laijs@cn.fujitsu.com> wrote :
> marker_synchronize_unregister must be called _also_ between unregistration
> and destruction the data that unregistration-ed probes need to make sure
> there is no caller executing a probe when it's data is destroyed.
> 

Ah, you're right. I looked again through your patch description and I
think using a :


if (entry->rcu_pending)
                rcu_barrier_sched();

After each time the markers_mutex is taken would keep the fast
batch registration/unregistration and fix the reentrancy problem.
The following patch should address the problem.

Thanks,

Mathieu


Lai Jiangshan discovered a reentrancy issue with markers. This patch implements
a version of the fix which won't slow down marker batch
registration/unregistration.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "Frank Ch. Eigler" <fche@redhat.com>
---
 kernel/marker.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-09-30 01:29:18.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-09-30 01:31:28.000000000 -0400
@@ -674,6 +674,8 @@ int marker_probe_register(const char *na
 	mutex_lock(&markers_mutex);
 	entry = get_marker(name);
 	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
@@ -717,6 +719,8 @@ int marker_probe_unregister(const char *
 	entry = get_marker(name);
 	if (!entry)
 		goto end;
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */
@@ -795,6 +799,8 @@ int marker_probe_unregister_private_data
 	mutex_lock(&markers_mutex);
 	entry = get_marker_from_private_data(probe, probe_private);
 	WARN_ON(!entry);
+	if (entry->rcu_pending)
+		rcu_barrier_sched();
 	entry->oldptr = old;
 	entry->rcu_pending = 1;
 	/* write rcu_pending before calling the RCU callback */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
