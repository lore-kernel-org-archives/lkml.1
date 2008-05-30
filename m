Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbYE3EJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbYE3EJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYE3EA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45461 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753056AbYE3EAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:23 -0400
Message-Id: <20080530040021.460464557@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:51 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 31/41] VM statistics: Use CPU ops
Content-Disposition: inline; filename=cpu_alloc_ops_vmstat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of CPU ops here avoids the offset calculations that we used to have
to do with per cpu operations. The result of this patch is that event counters
are coded with a single instruction the following way:

	incq   %gs:offset(%rip)

Without these patches this was:

	mov    %gs:0x8,%rdx
	mov    %eax,0x38(%rsp)
	mov    xxx(%rip),%eax
	mov    %eax,0x48(%rsp)
	mov    varoffset,%rax
	incq   0x110(%rax,%rdx,1)

Signed-off-by: Christoph Lameter <clameter@sgi.com

---
 include/linux/vmstat.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2008-05-20 19:43:43.000000000 -0700
+++ linux-2.6/include/linux/vmstat.h	2008-05-20 21:40:32.000000000 -0700
@@ -63,24 +63,22 @@
 
 static inline void __count_vm_event(enum vm_event_item item)
 {
-	__get_cpu_var(vm_event_states).event[item]++;
+	__CPU_INC(per_cpu_var(vm_event_states).event[item]);
 }
 
 static inline void count_vm_event(enum vm_event_item item)
 {
-	get_cpu_var(vm_event_states).event[item]++;
-	put_cpu();
+	_CPU_INC(per_cpu_var(vm_event_states).event[item]);
 }
 
 static inline void __count_vm_events(enum vm_event_item item, long delta)
 {
-	__get_cpu_var(vm_event_states).event[item] += delta;
+	__CPU_ADD(per_cpu_var(vm_event_states).event[item], delta);
 }
 
 static inline void count_vm_events(enum vm_event_item item, long delta)
 {
-	get_cpu_var(vm_event_states).event[item] += delta;
-	put_cpu();
+	_CPU_ADD(per_cpu_var(vm_event_states).event[item], delta);
 }
 
 extern void all_vm_events(unsigned long *);

-- 
