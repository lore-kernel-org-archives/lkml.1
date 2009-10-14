Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZJNGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZJNGDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZJNGD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:58654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZJNGD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:27 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/16] percpu: remove some sparse warnings
Date: Wed, 14 Oct 2009 15:01:52 +0900
Message-Id: <1255500125-3210-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following changes to remove some sparse warnings.

* Make DEFINE_PER_CPU_SECTION() declare __pcpu_unique_* before
  defining it.

* Annotate pcpu_extend_area_map() that it is entered with pcpu_lock
  held, releases it and then reacquires it.

* Make percpu related macros use unique nested variable names.

* While at it, add pcpu prefix to __size_call[_return]() macros as
  to-be-implemented sparse annotations will add percpu specific stuff
  to these macros.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 arch/x86/include/asm/percpu.h |   26 +++++++++++-----------
 include/linux/percpu-defs.h   |    1 +
 include/linux/percpu.h        |   48 ++++++++++++++++++++--------------------
 mm/percpu.c                   |    1 +
 4 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 8b5ec19..0c44196 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -74,31 +74,31 @@ extern void __bad_percpu_size(void);
 
 #define percpu_to_op(op, var, val)			\
 do {							\
-	typedef typeof(var) T__;			\
+	typedef typeof(var) pto_T__;			\
 	if (0) {					\
-		T__ tmp__;				\
-		tmp__ = (val);				\
+		pto_T__ pto_tmp__;			\
+		pto_tmp__ = (val);			\
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "qi" ((T__)(val)));		\
+		    : "qi" ((pto_T__)(val)));		\
 		break;					\
 	case 2:						\
 		asm(op "w %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)(val)));		\
+		    : "ri" ((pto_T__)(val)));		\
 		break;					\
 	case 4:						\
 		asm(op "l %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "ri" ((T__)(val)));		\
+		    : "ri" ((pto_T__)(val)));		\
 		break;					\
 	case 8:						\
 		asm(op "q %1,"__percpu_arg(0)		\
 		    : "+m" (var)			\
-		    : "re" ((T__)(val)));		\
+		    : "re" ((pto_T__)(val)));		\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
@@ -106,31 +106,31 @@ do {							\
 
 #define percpu_from_op(op, var, constraint)		\
 ({							\
-	typeof(var) ret__;				\
+	typeof(var) pfo_ret__;				\
 	switch (sizeof(var)) {				\
 	case 1:						\
 		asm(op "b "__percpu_arg(1)",%0"		\
-		    : "=q" (ret__)			\
+		    : "=q" (pfo_ret__)			\
 		    : constraint);			\
 		break;					\
 	case 2:						\
 		asm(op "w "__percpu_arg(1)",%0"		\
-		    : "=r" (ret__)			\
+		    : "=r" (pfo_ret__)			\
 		    : constraint);			\
 		break;					\
 	case 4:						\
 		asm(op "l "__percpu_arg(1)",%0"		\
-		    : "=r" (ret__)			\
+		    : "=r" (pfo_ret__)			\
 		    : constraint);			\
 		break;					\
 	case 8:						\
 		asm(op "q "__percpu_arg(1)",%0"		\
-		    : "=r" (ret__)			\
+		    : "=r" (pfo_ret__)			\
 		    : constraint);			\
 		break;					\
 	default: __bad_percpu_size();			\
 	}						\
-	ret__;						\
+	pfo_ret__;					\
 })
 
 /*
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 9bd0319..5a5d6ce 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -60,6 +60,7 @@
 
 #define DEFINE_PER_CPU_SECTION(type, name, sec)				\
 	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\
+	extern __PCPU_DUMMY_ATTRS char __pcpu_unique_##name;		\
 	__PCPU_DUMMY_ATTRS char __pcpu_unique_##name;			\
 	__PCPU_ATTRS(sec) PER_CPU_DEF_ATTRIBUTES __weak			\
 	__typeof__(type) per_cpu__##name
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 519d687..522f421 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -226,20 +226,20 @@ do {									\
 
 extern void __bad_size_call_parameter(void);
 
-#define __size_call_return(stem, variable)				\
-({	typeof(variable) ret__;						\
+#define __pcpu_size_call_return(stem, variable)				\
+({	typeof(variable) pscr_ret__;					\
 	switch(sizeof(variable)) {					\
-	case 1: ret__ = stem##1(variable);break;			\
-	case 2: ret__ = stem##2(variable);break;			\
-	case 4: ret__ = stem##4(variable);break;			\
-	case 8: ret__ = stem##8(variable);break;			\
+	case 1: pscr_ret__ = stem##1(variable);break;			\
+	case 2: pscr_ret__ = stem##2(variable);break;			\
+	case 4: pscr_ret__ = stem##4(variable);break;			\
+	case 8: pscr_ret__ = stem##8(variable);break;			\
 	default:							\
 		__bad_size_call_parameter();break;			\
 	}								\
-	ret__;								\
+	pscr_ret__;							\
 })
 
-#define __size_call(stem, variable, ...)				\
+#define __pcpu_size_call(stem, variable, ...)				\
 do {									\
 	switch(sizeof(variable)) {					\
 		case 1: stem##1(variable, __VA_ARGS__);break;		\
@@ -299,7 +299,7 @@ do {									\
 # ifndef this_cpu_read_8
 #  define this_cpu_read_8(pcp)	_this_cpu_generic_read(pcp)
 # endif
-# define this_cpu_read(pcp)	__size_call_return(this_cpu_read_, (pcp))
+# define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
 #endif
 
 #define _this_cpu_generic_to_op(pcp, val, op)				\
@@ -322,7 +322,7 @@ do {									\
 # ifndef this_cpu_write_8
 #  define this_cpu_write_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
 # endif
-# define this_cpu_write(pcp, val)	__size_call(this_cpu_write_, (pcp), (val))
+# define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, (pcp), (val))
 #endif
 
 #ifndef this_cpu_add
@@ -338,7 +338,7 @@ do {									\
 # ifndef this_cpu_add_8
 #  define this_cpu_add_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# define this_cpu_add(pcp, val)		__size_call(this_cpu_add_, (pcp), (val))
+# define this_cpu_add(pcp, val)		__pcpu_size_call(this_cpu_add_, (pcp), (val))
 #endif
 
 #ifndef this_cpu_sub
@@ -366,7 +366,7 @@ do {									\
 # ifndef this_cpu_and_8
 #  define this_cpu_and_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# define this_cpu_and(pcp, val)		__size_call(this_cpu_and_, (pcp), (val))
+# define this_cpu_and(pcp, val)		__pcpu_size_call(this_cpu_and_, (pcp), (val))
 #endif
 
 #ifndef this_cpu_or
@@ -382,7 +382,7 @@ do {									\
 # ifndef this_cpu_or_8
 #  define this_cpu_or_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# define this_cpu_or(pcp, val)		__size_call(this_cpu_or_, (pcp), (val))
+# define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
 #endif
 
 #ifndef this_cpu_xor
@@ -398,7 +398,7 @@ do {									\
 # ifndef this_cpu_xor_8
 #  define this_cpu_xor_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# define this_cpu_xor(pcp, val)		__size_call(this_cpu_or_, (pcp), (val))
+# define this_cpu_xor(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
 #endif
 
 /*
@@ -428,7 +428,7 @@ do {									\
 # ifndef __this_cpu_read_8
 #  define __this_cpu_read_8(pcp)	(*__this_cpu_ptr(&(pcp)))
 # endif
-# define __this_cpu_read(pcp)	__size_call_return(__this_cpu_read_, (pcp))
+# define __this_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
 #endif
 
 #define __this_cpu_generic_to_op(pcp, val, op)				\
@@ -449,7 +449,7 @@ do {									\
 # ifndef __this_cpu_write_8
 #  define __this_cpu_write_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
 # endif
-# define __this_cpu_write(pcp, val)	__size_call(__this_cpu_write_, (pcp), (val))
+# define __this_cpu_write(pcp, val)	__pcpu_size_call(__this_cpu_write_, (pcp), (val))
 #endif
 
 #ifndef __this_cpu_add
@@ -465,7 +465,7 @@ do {									\
 # ifndef __this_cpu_add_8
 #  define __this_cpu_add_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# define __this_cpu_add(pcp, val)	__size_call(__this_cpu_add_, (pcp), (val))
+# define __this_cpu_add(pcp, val)	__pcpu_size_call(__this_cpu_add_, (pcp), (val))
 #endif
 
 #ifndef __this_cpu_sub
@@ -493,7 +493,7 @@ do {									\
 # ifndef __this_cpu_and_8
 #  define __this_cpu_and_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# define __this_cpu_and(pcp, val)	__size_call(__this_cpu_and_, (pcp), (val))
+# define __this_cpu_and(pcp, val)	__pcpu_size_call(__this_cpu_and_, (pcp), (val))
 #endif
 
 #ifndef __this_cpu_or
@@ -509,7 +509,7 @@ do {									\
 # ifndef __this_cpu_or_8
 #  define __this_cpu_or_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# define __this_cpu_or(pcp, val)	__size_call(__this_cpu_or_, (pcp), (val))
+# define __this_cpu_or(pcp, val)	__pcpu_size_call(__this_cpu_or_, (pcp), (val))
 #endif
 
 #ifndef __this_cpu_xor
@@ -525,7 +525,7 @@ do {									\
 # ifndef __this_cpu_xor_8
 #  define __this_cpu_xor_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# define __this_cpu_xor(pcp, val)	__size_call(__this_cpu_xor_, (pcp), (val))
+# define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
 #endif
 
 /*
@@ -556,7 +556,7 @@ do {									\
 # ifndef irqsafe_cpu_add_8
 #  define irqsafe_cpu_add_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# define irqsafe_cpu_add(pcp, val) __size_call(irqsafe_cpu_add_, (pcp), (val))
+# define irqsafe_cpu_add(pcp, val) __pcpu_size_call(irqsafe_cpu_add_, (pcp), (val))
 #endif
 
 #ifndef irqsafe_cpu_sub
@@ -584,7 +584,7 @@ do {									\
 # ifndef irqsafe_cpu_and_8
 #  define irqsafe_cpu_and_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# define irqsafe_cpu_and(pcp, val) __size_call(irqsafe_cpu_and_, (val))
+# define irqsafe_cpu_and(pcp, val) __pcpu_size_call(irqsafe_cpu_and_, (val))
 #endif
 
 #ifndef irqsafe_cpu_or
@@ -600,7 +600,7 @@ do {									\
 # ifndef irqsafe_cpu_or_8
 #  define irqsafe_cpu_or_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# define irqsafe_cpu_or(pcp, val) __size_call(irqsafe_cpu_or_, (val))
+# define irqsafe_cpu_or(pcp, val) __pcpu_size_call(irqsafe_cpu_or_, (val))
 #endif
 
 #ifndef irqsafe_cpu_xor
@@ -616,7 +616,7 @@ do {									\
 # ifndef irqsafe_cpu_xor_8
 #  define irqsafe_cpu_xor_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# define irqsafe_cpu_xor(pcp, val) __size_call(irqsafe_cpu_xor_, (val))
+# define irqsafe_cpu_xor(pcp, val) __pcpu_size_call(irqsafe_cpu_xor_, (val))
 #endif
 
 #endif /* __LINUX_PERCPU_H */
diff --git a/mm/percpu.c b/mm/percpu.c
index ec158bb..e2e80fc 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -365,6 +365,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
  * 0 if noop, 1 if successfully extended, -errno on failure.
  */
 static int pcpu_extend_area_map(struct pcpu_chunk *chunk)
+	__releases(lock) __acquires(lock)
 {
 	int new_alloc;
 	int *new;
-- 
1.6.4.2

