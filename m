Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZJGEfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZJGEfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZJGEfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:35:21 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:32778 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752088AbZJGEfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:35:19 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091006233731.419967057@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:37:04 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 10/19] Use this_cpu ops for VM statistics.
Content-Disposition: inline; filename=this_cpu_vmstats
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using per cpu atomics for the vm statistics reduces their overhead.
And in the case of x86 we are guaranteed that they will never race even
in the lax form used for vm statistics.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/vmstat.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2009-08-14 10:07:18.000000000 -0500
+++ linux-2.6/include/linux/vmstat.h	2009-09-01 14:59:22.000000000 -0500
@@ -76,24 +76,22 @@ DECLARE_PER_CPU(struct vm_event_state, v
 
 static inline void __count_vm_event(enum vm_event_item item)
 {
-	__get_cpu_var(vm_event_states).event[item]++;
+	__this_cpu_inc(per_cpu_var(vm_event_states).event[item]);
 }
 
 static inline void count_vm_event(enum vm_event_item item)
 {
-	get_cpu_var(vm_event_states).event[item]++;
-	put_cpu();
+	this_cpu_inc(per_cpu_var(vm_event_states).event[item]);
 }
 
 static inline void __count_vm_events(enum vm_event_item item, long delta)
 {
-	__get_cpu_var(vm_event_states).event[item] += delta;
+	__this_cpu_add(per_cpu_var(vm_event_states).event[item], delta);
 }
 
 static inline void count_vm_events(enum vm_event_item item, long delta)
 {
-	get_cpu_var(vm_event_states).event[item] += delta;
-	put_cpu();
+	this_cpu_add(per_cpu_var(vm_event_states).event[item], delta);
 }
 
 extern void all_vm_events(unsigned long *);

-- 
