Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXKTB06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXKTB06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbXKTBOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:18 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49886 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756281AbXKTBNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:42 -0500
Message-Id: <20071120011341.496602776@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:13 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 41/45] VM statistics: Use CPU ops
Content-Disposition: inline; filename=vmstat
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The use of CPU ops here avoids the offset calculations that we used to have
to do with per cpu ops. The result of this patch is that event counters are
coded with a single instruction the following way:

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
--- linux-2.6.orig/include/linux/vmstat.h	2007-11-18 09:29:53.177783417 -0800
+++ linux-2.6/include/linux/vmstat.h	2007-11-18 09:29:54.741283496 -0800
@@ -59,24 +59,22 @@ DECLARE_PER_CPU(struct vm_event_state, v
 
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
