Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbZE0SOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbZE0SOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762994AbZE0SN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:13:56 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:57605 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759619AbZE0SNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:13:55 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "Cc"
Message-Id: <20090527180714.834691580@gentwo.org>
References: <20090527180635.008102701@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 13:46:59 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>
Cc: davem@davemloft.net
Subject: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
Content-Disposition: inline; filename=my_cpu_ptr_intro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


my_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).


The problem with per_cpu_ptr(x, smp_processor_id) is that it requires
an array lookup to find the offset for the cpu. Processors typically
have the offset for the current cpu area in some kind of (arch dependent)
efficiently accessible register or memory location.

We can use that instead of doing the array lookup to speed up the
determination of the addressof the percpu variable. This is particularly
significant because these lookups occur in performance critical paths
of the core kernel.

This optimization is a prerequiste to the introduction of per processor
atomic operations for the core code. Atomic per processor operations
implicitly do the offset calculation to the current per cpu area in a
single instruction. All the locations touched by this patchset are potential
candidates for atomic per cpu operations.

my_cpu_ptr comes in two flavors. The preemption context matters since we
are referring the the currently executing processor. In many cases we must
insure that the processor does not change while a code segment is executed.

__my_cpu_ptr 	-> Do not check for preemption context
my_cpu_ptr	-> Check preemption context


Cc: David Howells <dhowells@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/percpu.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2009-05-27 11:32:36.000000000 -0500
+++ linux-2.6/include/linux/percpu.h	2009-05-27 11:33:32.000000000 -0500
@@ -78,6 +78,9 @@ extern ssize_t __init pcpu_embed_first_c
  */
 #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
 
+#define my_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
+#define __my_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
+
 extern void *__alloc_reserved_percpu(size_t size, size_t align);
 
 #else /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
@@ -94,6 +97,12 @@ struct percpu_data {
         (__typeof__(ptr))__p->ptrs[(cpu)];				\
 })
 
+#define my_cpu_ptr(ptr) \
+		per_cpu_ptr(ptr, smp_processor_id())
+
+#define __my_cpu_ptr(ptr) \
+		per_cpu_ptr(ptr, raw_smp_processor_id())
+
 #endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
 
 extern void *__alloc_percpu(size_t size, size_t align);
@@ -102,6 +111,8 @@ extern void free_percpu(void *__pdata);
 #else /* CONFIG_SMP */
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
+#define my_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
+#define __my_cpu_ptr(ptr) my_cpu_ptr(ptr)
 
 static inline void *__alloc_percpu(size_t size, size_t align)
 {

-- 
