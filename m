Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbXFRGTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbXFRGTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXFRGTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:19:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38423 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbXFRGTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:19:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
Subject: [patch] use __asm__ and __volatile__ in asm-ia64/gcc_intrin.h
Date: Mon, 18 Jun 2007 02:19:10 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706180219.11164.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since asm-ia64/gcc_intrin.h gets exported to userspace, we need to make sure
to use __asm__() rather than asm() since the latter is not available when
compiling with gcc with GNU extensions turned off (like -std=c99).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-ia64/gcc_intrin.h b/include/asm-ia64/gcc_intrin.h
index 4fb4e43..0bb24df 100644
--- a/include/asm-ia64/gcc_intrin.h
+++ b/include/asm-ia64/gcc_intrin.h
@@ -13,41 +13,41 @@
 
 /* Optimization barrier */
 /* The "volatile" is due to gcc bugs */
-#define ia64_barrier()	asm volatile ("":::"memory")
+#define ia64_barrier()	__asm__ __volatile__ ("":::"memory")
 
-#define ia64_stop()	asm volatile (";;"::)
+#define ia64_stop()	__asm__ __volatile__ (";;"::)
 
-#define ia64_invala_gr(regnum)	asm volatile ("invala.e r%0" :: "i"(regnum))
+#define ia64_invala_gr(regnum)	__asm__ __volatile__ ("invala.e r%0" :: "i"(regnum))
 
-#define ia64_invala_fr(regnum)	asm volatile ("invala.e f%0" :: "i"(regnum))
+#define ia64_invala_fr(regnum)	__asm__ __volatile__ ("invala.e f%0" :: "i"(regnum))
 
 extern void ia64_bad_param_for_setreg (void);
 extern void ia64_bad_param_for_getreg (void);
 
-register unsigned long ia64_r13 asm ("r13") __attribute_used__;
+register unsigned long ia64_r13 __asm__ ("r13") __attribute_used__;
 
 #define ia64_setreg(regnum, val)						\
 ({										\
 	switch (regnum) {							\
 	    case _IA64_REG_PSR_L:						\
-		    asm volatile ("mov psr.l=%0" :: "r"(val) : "memory");	\
+		    __asm__ __volatile__ ("mov psr.l=%0" :: "r"(val) : "memory");	\
 		    break;							\
 	    case _IA64_REG_AR_KR0 ... _IA64_REG_AR_EC:				\
-		    asm volatile ("mov ar%0=%1" ::				\
+		    __asm__ __volatile__ ("mov ar%0=%1" ::				\
 		    			  "i" (regnum - _IA64_REG_AR_KR0),	\
 					  "r"(val): "memory");			\
 		    break;							\
 	    case _IA64_REG_CR_DCR ... _IA64_REG_CR_LRR1:			\
-		    asm volatile ("mov cr%0=%1" ::				\
+		    __asm__ __volatile__ ("mov cr%0=%1" ::				\
 				          "i" (regnum - _IA64_REG_CR_DCR),	\
 					  "r"(val): "memory" );			\
 		    break;							\
 	    case _IA64_REG_SP:							\
-		    asm volatile ("mov r12=%0" ::				\
+		    __asm__ __volatile__ ("mov r12=%0" ::				\
 			    		  "r"(val): "memory");			\
 		    break;							\
 	    case _IA64_REG_GP:							\
-		    asm volatile ("mov gp=%0" :: "r"(val) : "memory");		\
+		    __asm__ __volatile__ ("mov gp=%0" :: "r"(val) : "memory");		\
 		break;								\
 	    default:								\
 		    ia64_bad_param_for_setreg();				\
@@ -61,27 +61,27 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 										\
 	switch (regnum) {							\
 	case _IA64_REG_GP:							\
-		asm volatile ("mov %0=gp" : "=r"(ia64_intri_res));		\
+		__asm__ __volatile__ ("mov %0=gp" : "=r"(ia64_intri_res));		\
 		break;								\
 	case _IA64_REG_IP:							\
-		asm volatile ("mov %0=ip" : "=r"(ia64_intri_res));		\
+		__asm__ __volatile__ ("mov %0=ip" : "=r"(ia64_intri_res));		\
 		break;								\
 	case _IA64_REG_PSR:							\
-		asm volatile ("mov %0=psr" : "=r"(ia64_intri_res));		\
+		__asm__ __volatile__ ("mov %0=psr" : "=r"(ia64_intri_res));		\
 		break;								\
 	case _IA64_REG_TP:	/* for current() */				\
 		ia64_intri_res = ia64_r13;					\
 		break;								\
 	case _IA64_REG_AR_KR0 ... _IA64_REG_AR_EC:				\
-		asm volatile ("mov %0=ar%1" : "=r" (ia64_intri_res)		\
+		__asm__ __volatile__ ("mov %0=ar%1" : "=r" (ia64_intri_res)		\
 				      : "i"(regnum - _IA64_REG_AR_KR0));	\
 		break;								\
 	case _IA64_REG_CR_DCR ... _IA64_REG_CR_LRR1:				\
-		asm volatile ("mov %0=cr%1" : "=r" (ia64_intri_res)		\
+		__asm__ __volatile__ ("mov %0=cr%1" : "=r" (ia64_intri_res)		\
 				      : "i" (regnum - _IA64_REG_CR_DCR));	\
 		break;								\
 	case _IA64_REG_SP:							\
-		asm volatile ("mov %0=sp" : "=r" (ia64_intri_res));		\
+		__asm__ __volatile__ ("mov %0=sp" : "=r" (ia64_intri_res));		\
 		break;								\
 	default:								\
 		ia64_bad_param_for_getreg();					\
@@ -96,7 +96,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 ({								\
 	switch (mode) {						\
 	case ia64_hint_pause:					\
-		asm volatile ("hint @pause" ::: "memory");	\
+		__asm__ __volatile__ ("hint @pause" ::: "memory");	\
 		break;						\
 	}							\
 })
@@ -115,19 +115,19 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 										\
 	switch (mode) {								\
 	case ia64_mux1_brcst:							\
-		asm ("mux1 %0=%1,@brcst" : "=r" (ia64_intri_res) : "r" (x));	\
+		__asm__ ("mux1 %0=%1,@brcst" : "=r" (ia64_intri_res) : "r" (x));	\
 		break;								\
 	case ia64_mux1_mix:							\
-		asm ("mux1 %0=%1,@mix" : "=r" (ia64_intri_res) : "r" (x));	\
+		__asm__ ("mux1 %0=%1,@mix" : "=r" (ia64_intri_res) : "r" (x));	\
 		break;								\
 	case ia64_mux1_shuf:							\
-		asm ("mux1 %0=%1,@shuf" : "=r" (ia64_intri_res) : "r" (x));	\
+		__asm__ ("mux1 %0=%1,@shuf" : "=r" (ia64_intri_res) : "r" (x));	\
 		break;								\
 	case ia64_mux1_alt:							\
-		asm ("mux1 %0=%1,@alt" : "=r" (ia64_intri_res) : "r" (x));	\
+		__asm__ ("mux1 %0=%1,@alt" : "=r" (ia64_intri_res) : "r" (x));	\
 		break;								\
 	case ia64_mux1_rev:							\
-		asm ("mux1 %0=%1,@rev" : "=r" (ia64_intri_res) : "r" (x));	\
+		__asm__ ("mux1 %0=%1,@rev" : "=r" (ia64_intri_res) : "r" (x));	\
 		break;								\
 	}									\
 	ia64_intri_res;								\
@@ -139,7 +139,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 # define ia64_popcnt(x)						\
   ({								\
 	__u64 ia64_intri_res;					\
-	asm ("popcnt %0=%1" : "=r" (ia64_intri_res) : "r" (x));	\
+	__asm__ ("popcnt %0=%1" : "=r" (ia64_intri_res) : "r" (x));	\
 								\
 	ia64_intri_res;						\
   })
@@ -149,7 +149,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 ({								\
 	long ia64_intri_res;					\
 								\
-	asm ("getf.exp %0=%1" : "=r"(ia64_intri_res) : "f"(x));	\
+	__asm__ ("getf.exp %0=%1" : "=r"(ia64_intri_res) : "f"(x));	\
 								\
 	ia64_intri_res;						\
 })
@@ -157,75 +157,75 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_shrp(a, b, count)								\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm ("shrp %0=%1,%2,%3" : "=r"(ia64_intri_res) : "r"(a), "r"(b), "i"(count));	\
+	__asm__ ("shrp %0=%1,%2,%3" : "=r"(ia64_intri_res) : "r"(a), "r"(b), "i"(count));	\
 	ia64_intri_res;									\
 })
 
 #define ia64_ldfs(regnum, x)					\
 ({								\
-	register double __f__ asm ("f"#regnum);			\
-	asm volatile ("ldfs %0=[%1]" :"=f"(__f__): "r"(x));	\
+	register double __f__ __asm__ ("f"#regnum);			\
+	__asm__ __volatile__ ("ldfs %0=[%1]" :"=f"(__f__): "r"(x));	\
 })
 
 #define ia64_ldfd(regnum, x)					\
 ({								\
-	register double __f__ asm ("f"#regnum);			\
-	asm volatile ("ldfd %0=[%1]" :"=f"(__f__): "r"(x));	\
+	register double __f__ __asm__ ("f"#regnum);			\
+	__asm__ __volatile__ ("ldfd %0=[%1]" :"=f"(__f__): "r"(x));	\
 })
 
 #define ia64_ldfe(regnum, x)					\
 ({								\
-	register double __f__ asm ("f"#regnum);			\
-	asm volatile ("ldfe %0=[%1]" :"=f"(__f__): "r"(x));	\
+	register double __f__ __asm__ ("f"#regnum);			\
+	__asm__ __volatile__ ("ldfe %0=[%1]" :"=f"(__f__): "r"(x));	\
 })
 
 #define ia64_ldf8(regnum, x)					\
 ({								\
-	register double __f__ asm ("f"#regnum);			\
-	asm volatile ("ldf8 %0=[%1]" :"=f"(__f__): "r"(x));	\
+	register double __f__ __asm__ ("f"#regnum);			\
+	__asm__ __volatile__ ("ldf8 %0=[%1]" :"=f"(__f__): "r"(x));	\
 })
 
 #define ia64_ldf_fill(regnum, x)				\
 ({								\
-	register double __f__ asm ("f"#regnum);			\
-	asm volatile ("ldf.fill %0=[%1]" :"=f"(__f__): "r"(x));	\
+	register double __f__ __asm__ ("f"#regnum);			\
+	__asm__ __volatile__ ("ldf.fill %0=[%1]" :"=f"(__f__): "r"(x));	\
 })
 
 #define ia64_stfs(x, regnum)						\
 ({									\
-	register double __f__ asm ("f"#regnum);				\
-	asm volatile ("stfs [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
+	register double __f__ __asm__ ("f"#regnum);				\
+	__asm__ __volatile__ ("stfs [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
 })
 
 #define ia64_stfd(x, regnum)						\
 ({									\
-	register double __f__ asm ("f"#regnum);				\
-	asm volatile ("stfd [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
+	register double __f__ __asm__ ("f"#regnum);				\
+	__asm__ __volatile__ ("stfd [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
 })
 
 #define ia64_stfe(x, regnum)						\
 ({									\
-	register double __f__ asm ("f"#regnum);				\
-	asm volatile ("stfe [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
+	register double __f__ __asm__ ("f"#regnum);				\
+	__asm__ __volatile__ ("stfe [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
 })
 
 #define ia64_stf8(x, regnum)						\
 ({									\
-	register double __f__ asm ("f"#regnum);				\
-	asm volatile ("stf8 [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
+	register double __f__ __asm__ ("f"#regnum);				\
+	__asm__ __volatile__ ("stf8 [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
 })
 
 #define ia64_stf_spill(x, regnum)						\
 ({										\
-	register double __f__ asm ("f"#regnum);					\
-	asm volatile ("stf.spill [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
+	register double __f__ __asm__ ("f"#regnum);					\
+	__asm__ __volatile__ ("stf.spill [%0]=%1" :: "r"(x), "f"(__f__) : "memory");	\
 })
 
 #define ia64_fetchadd4_acq(p, inc)						\
 ({										\
 										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("fetchadd4.acq %0=[%1],%2"				\
+	__asm__ __volatile__ ("fetchadd4.acq %0=[%1],%2"				\
 				: "=r"(ia64_intri_res) : "r"(p), "i" (inc)	\
 				: "memory");					\
 										\
@@ -235,7 +235,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_fetchadd4_rel(p, inc)						\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("fetchadd4.rel %0=[%1],%2"				\
+	__asm__ __volatile__ ("fetchadd4.rel %0=[%1],%2"				\
 				: "=r"(ia64_intri_res) : "r"(p), "i" (inc)	\
 				: "memory");					\
 										\
@@ -246,7 +246,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 ({										\
 										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("fetchadd8.acq %0=[%1],%2"				\
+	__asm__ __volatile__ ("fetchadd8.acq %0=[%1],%2"				\
 				: "=r"(ia64_intri_res) : "r"(p), "i" (inc)	\
 				: "memory");					\
 										\
@@ -256,7 +256,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_fetchadd8_rel(p, inc)						\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("fetchadd8.rel %0=[%1],%2"				\
+	__asm__ __volatile__ ("fetchadd8.rel %0=[%1],%2"				\
 				: "=r"(ia64_intri_res) : "r"(p), "i" (inc)	\
 				: "memory");					\
 										\
@@ -266,7 +266,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_xchg1(ptr,x)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("xchg1 %0=[%1],%2"					\
+	__asm__ __volatile__ ("xchg1 %0=[%1],%2"					\
 		      : "=r" (ia64_intri_res) : "r" (ptr), "r" (x) : "memory");	\
 	ia64_intri_res;								\
 })
@@ -274,7 +274,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_xchg2(ptr,x)						\
 ({									\
 	__u64 ia64_intri_res;						\
-	asm volatile ("xchg2 %0=[%1],%2" : "=r" (ia64_intri_res)	\
+	__asm__ __volatile__ ("xchg2 %0=[%1],%2" : "=r" (ia64_intri_res)	\
 		      : "r" (ptr), "r" (x) : "memory");			\
 	ia64_intri_res;							\
 })
@@ -282,7 +282,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_xchg4(ptr,x)						\
 ({									\
 	__u64 ia64_intri_res;						\
-	asm volatile ("xchg4 %0=[%1],%2" : "=r" (ia64_intri_res)	\
+	__asm__ __volatile__ ("xchg4 %0=[%1],%2" : "=r" (ia64_intri_res)	\
 		      : "r" (ptr), "r" (x) : "memory");			\
 	ia64_intri_res;							\
 })
@@ -290,7 +290,7 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_xchg8(ptr,x)						\
 ({									\
 	__u64 ia64_intri_res;						\
-	asm volatile ("xchg8 %0=[%1],%2" : "=r" (ia64_intri_res)	\
+	__asm__ __volatile__ ("xchg8 %0=[%1],%2" : "=r" (ia64_intri_res)	\
 		      : "r" (ptr), "r" (x) : "memory");			\
 	ia64_intri_res;							\
 })
@@ -298,8 +298,8 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg1_acq(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
-	asm volatile ("cmpxchg1.acq %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("cmpxchg1.acq %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
@@ -307,8 +307,8 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg1_rel(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
-	asm volatile ("cmpxchg1.rel %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("cmpxchg1.rel %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
@@ -316,8 +316,8 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg2_acq(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
-	asm volatile ("cmpxchg2.acq %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("cmpxchg2.acq %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
@@ -325,9 +325,9 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg2_rel(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
 											\
-	asm volatile ("cmpxchg2.rel %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("cmpxchg2.rel %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
@@ -335,8 +335,8 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg4_acq(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
-	asm volatile ("cmpxchg4.acq %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("cmpxchg4.acq %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
@@ -344,8 +344,8 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg4_rel(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
-	asm volatile ("cmpxchg4.rel %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("cmpxchg4.rel %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
@@ -353,8 +353,8 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg8_acq(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
-	asm volatile ("cmpxchg8.acq %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("cmpxchg8.acq %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
@@ -362,106 +362,106 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_cmpxchg8_rel(ptr, new, old)						\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov ar.ccv=%0;;" :: "rO"(old));					\
+	__asm__ __volatile__ ("mov ar.ccv=%0;;" :: "rO"(old));					\
 											\
-	asm volatile ("cmpxchg8.rel %0=[%1],%2,ar.ccv":					\
+	__asm__ __volatile__ ("cmpxchg8.rel %0=[%1],%2,ar.ccv":					\
 			      "=r"(ia64_intri_res) : "r"(ptr), "r"(new) : "memory");	\
 	ia64_intri_res;									\
 })
 
-#define ia64_mf()	asm volatile ("mf" ::: "memory")
-#define ia64_mfa()	asm volatile ("mf.a" ::: "memory")
+#define ia64_mf()	__asm__ __volatile__ ("mf" ::: "memory")
+#define ia64_mfa()	__asm__ __volatile__ ("mf.a" ::: "memory")
 
-#define ia64_invala() asm volatile ("invala" ::: "memory")
+#define ia64_invala() __asm__ __volatile__ ("invala" ::: "memory")
 
 #define ia64_thash(addr)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("thash %0=%1" : "=r"(ia64_intri_res) : "r" (addr));	\
+	__asm__ __volatile__ ("thash %0=%1" : "=r"(ia64_intri_res) : "r" (addr));	\
 	ia64_intri_res;								\
 })
 
-#define ia64_srlz_i()	asm volatile (";; srlz.i ;;" ::: "memory")
-#define ia64_srlz_d()	asm volatile (";; srlz.d" ::: "memory");
+#define ia64_srlz_i()	__asm__ __volatile__ (";; srlz.i ;;" ::: "memory")
+#define ia64_srlz_d()	__asm__ __volatile__ (";; srlz.d" ::: "memory");
 
 #ifdef HAVE_SERIALIZE_DIRECTIVE
-# define ia64_dv_serialize_data()		asm volatile (".serialize.data");
-# define ia64_dv_serialize_instruction()	asm volatile (".serialize.instruction");
+# define ia64_dv_serialize_data()		__asm__ __volatile__ (".serialize.data");
+# define ia64_dv_serialize_instruction()	__asm__ __volatile__ (".serialize.instruction");
 #else
 # define ia64_dv_serialize_data()
 # define ia64_dv_serialize_instruction()
 #endif
 
-#define ia64_nop(x)	asm volatile ("nop %0"::"i"(x));
+#define ia64_nop(x)	__asm__ __volatile__ ("nop %0"::"i"(x));
 
-#define ia64_itci(addr)	asm volatile ("itc.i %0;;" :: "r"(addr) : "memory")
+#define ia64_itci(addr)	__asm__ __volatile__ ("itc.i %0;;" :: "r"(addr) : "memory")
 
-#define ia64_itcd(addr)	asm volatile ("itc.d %0;;" :: "r"(addr) : "memory")
+#define ia64_itcd(addr)	__asm__ __volatile__ ("itc.d %0;;" :: "r"(addr) : "memory")
 
 
-#define ia64_itri(trnum, addr) asm volatile ("itr.i itr[%0]=%1"				\
+#define ia64_itri(trnum, addr) __asm__ __volatile__ ("itr.i itr[%0]=%1"				\
 					     :: "r"(trnum), "r"(addr) : "memory")
 
-#define ia64_itrd(trnum, addr) asm volatile ("itr.d dtr[%0]=%1"				\
+#define ia64_itrd(trnum, addr) __asm__ __volatile__ ("itr.d dtr[%0]=%1"				\
 					     :: "r"(trnum), "r"(addr) : "memory")
 
 #define ia64_tpa(addr)								\
 ({										\
 	__u64 ia64_pa;								\
-	asm volatile ("tpa %0 = %1" : "=r"(ia64_pa) : "r"(addr) : "memory");	\
+	__asm__ __volatile__ ("tpa %0 = %1" : "=r"(ia64_pa) : "r"(addr) : "memory");	\
 	ia64_pa;								\
 })
 
 #define __ia64_set_dbr(index, val)						\
-	asm volatile ("mov dbr[%0]=%1" :: "r"(index), "r"(val) : "memory")
+	__asm__ __volatile__ ("mov dbr[%0]=%1" :: "r"(index), "r"(val) : "memory")
 
 #define ia64_set_ibr(index, val)						\
-	asm volatile ("mov ibr[%0]=%1" :: "r"(index), "r"(val) : "memory")
+	__asm__ __volatile__ ("mov ibr[%0]=%1" :: "r"(index), "r"(val) : "memory")
 
 #define ia64_set_pkr(index, val)						\
-	asm volatile ("mov pkr[%0]=%1" :: "r"(index), "r"(val) : "memory")
+	__asm__ __volatile__ ("mov pkr[%0]=%1" :: "r"(index), "r"(val) : "memory")
 
 #define ia64_set_pmc(index, val)						\
-	asm volatile ("mov pmc[%0]=%1" :: "r"(index), "r"(val) : "memory")
+	__asm__ __volatile__ ("mov pmc[%0]=%1" :: "r"(index), "r"(val) : "memory")
 
 #define ia64_set_pmd(index, val)						\
-	asm volatile ("mov pmd[%0]=%1" :: "r"(index), "r"(val) : "memory")
+	__asm__ __volatile__ ("mov pmd[%0]=%1" :: "r"(index), "r"(val) : "memory")
 
 #define ia64_set_rr(index, val)							\
-	asm volatile ("mov rr[%0]=%1" :: "r"(index), "r"(val) : "memory");
+	__asm__ __volatile__ ("mov rr[%0]=%1" :: "r"(index), "r"(val) : "memory");
 
 #define ia64_get_cpuid(index)								\
 ({											\
 	__u64 ia64_intri_res;								\
-	asm volatile ("mov %0=cpuid[%r1]" : "=r"(ia64_intri_res) : "rO"(index));	\
+	__asm__ __volatile__ ("mov %0=cpuid[%r1]" : "=r"(ia64_intri_res) : "rO"(index));	\
 	ia64_intri_res;									\
 })
 
 #define __ia64_get_dbr(index)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("mov %0=dbr[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
+	__asm__ __volatile__ ("mov %0=dbr[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
 	ia64_intri_res;								\
 })
 
 #define ia64_get_ibr(index)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("mov %0=ibr[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
+	__asm__ __volatile__ ("mov %0=ibr[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
 	ia64_intri_res;								\
 })
 
 #define ia64_get_pkr(index)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("mov %0=pkr[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
+	__asm__ __volatile__ ("mov %0=pkr[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
 	ia64_intri_res;								\
 })
 
 #define ia64_get_pmc(index)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("mov %0=pmc[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
+	__asm__ __volatile__ ("mov %0=pmc[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
 	ia64_intri_res;								\
 })
 
@@ -469,46 +469,46 @@ register unsigned long ia64_r13 asm ("r13") __attribute_used__;
 #define ia64_get_pmd(index)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("mov %0=pmd[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
+	__asm__ __volatile__ ("mov %0=pmd[%1]" : "=r"(ia64_intri_res) : "r"(index));	\
 	ia64_intri_res;								\
 })
 
 #define ia64_get_rr(index)							\
 ({										\
 	__u64 ia64_intri_res;							\
-	asm volatile ("mov %0=rr[%1]" : "=r"(ia64_intri_res) : "r" (index));	\
+	__asm__ __volatile__ ("mov %0=rr[%1]" : "=r"(ia64_intri_res) : "r" (index));	\
 	ia64_intri_res;								\
 })
 
-#define ia64_fc(addr)	asm volatile ("fc %0" :: "r"(addr) : "memory")
+#define ia64_fc(addr)	__asm__ __volatile__ ("fc %0" :: "r"(addr) : "memory")
 
 
-#define ia64_sync_i()	asm volatile (";; sync.i" ::: "memory")
+#define ia64_sync_i()	__asm__ __volatile__ (";; sync.i" ::: "memory")
 
-#define ia64_ssm(mask)	asm volatile ("ssm %0":: "i"((mask)) : "memory")
-#define ia64_rsm(mask)	asm volatile ("rsm %0":: "i"((mask)) : "memory")
-#define ia64_sum(mask)	asm volatile ("sum %0":: "i"((mask)) : "memory")
-#define ia64_rum(mask)	asm volatile ("rum %0":: "i"((mask)) : "memory")
+#define ia64_ssm(mask)	__asm__ __volatile__ ("ssm %0":: "i"((mask)) : "memory")
+#define ia64_rsm(mask)	__asm__ __volatile__ ("rsm %0":: "i"((mask)) : "memory")
+#define ia64_sum(mask)	__asm__ __volatile__ ("sum %0":: "i"((mask)) : "memory")
+#define ia64_rum(mask)	__asm__ __volatile__ ("rum %0":: "i"((mask)) : "memory")
 
-#define ia64_ptce(addr)	asm volatile ("ptc.e %0" :: "r"(addr))
+#define ia64_ptce(addr)	__asm__ __volatile__ ("ptc.e %0" :: "r"(addr))
 
 #define ia64_ptcga(addr, size)							\
 do {										\
-	asm volatile ("ptc.ga %0,%1" :: "r"(addr), "r"(size) : "memory");	\
+	__asm__ __volatile__ ("ptc.ga %0,%1" :: "r"(addr), "r"(size) : "memory");	\
 	ia64_dv_serialize_data();						\
 } while (0)
 
 #define ia64_ptcl(addr, size)							\
 do {										\
-	asm volatile ("ptc.l %0,%1" :: "r"(addr), "r"(size) : "memory");	\
+	__asm__ __volatile__ ("ptc.l %0,%1" :: "r"(addr), "r"(size) : "memory");	\
 	ia64_dv_serialize_data();						\
 } while (0)
 
 #define ia64_ptri(addr, size)						\
-	asm volatile ("ptr.i %0,%1" :: "r"(addr), "r"(size) : "memory")
+	__asm__ __volatile__ ("ptr.i %0,%1" :: "r"(addr), "r"(size) : "memory")
 
 #define ia64_ptrd(addr, size)						\
-	asm volatile ("ptr.d %0,%1" :: "r"(addr), "r"(size) : "memory")
+	__asm__ __volatile__ ("ptr.d %0,%1" :: "r"(addr), "r"(size) : "memory")
 
 /* Values for lfhint in ia64_lfetch and ia64_lfetch_fault */
 
@@ -521,16 +521,16 @@ do {										\
 ({								\
         switch (lfhint) {					\
         case ia64_lfhint_none:					\
-                asm volatile ("lfetch [%0]" : : "r"(y));	\
+                __asm__ __volatile__ ("lfetch [%0]" : : "r"(y));	\
                 break;						\
         case ia64_lfhint_nt1:					\
-                asm volatile ("lfetch.nt1 [%0]" : : "r"(y));	\
+                __asm__ __volatile__ ("lfetch.nt1 [%0]" : : "r"(y));	\
                 break;						\
         case ia64_lfhint_nt2:					\
-                asm volatile ("lfetch.nt2 [%0]" : : "r"(y));	\
+                __asm__ __volatile__ ("lfetch.nt2 [%0]" : : "r"(y));	\
                 break;						\
         case ia64_lfhint_nta:					\
-                asm volatile ("lfetch.nta [%0]" : : "r"(y));	\
+                __asm__ __volatile__ ("lfetch.nta [%0]" : : "r"(y));	\
                 break;						\
         }							\
 })
@@ -539,16 +539,16 @@ do {										\
 ({									\
         switch (lfhint) {						\
         case ia64_lfhint_none:						\
-                asm volatile ("lfetch.excl [%0]" :: "r"(y));		\
+                __asm__ __volatile__ ("lfetch.excl [%0]" :: "r"(y));		\
                 break;							\
         case ia64_lfhint_nt1:						\
-                asm volatile ("lfetch.excl.nt1 [%0]" :: "r"(y));	\
+                __asm__ __volatile__ ("lfetch.excl.nt1 [%0]" :: "r"(y));	\
                 break;							\
         case ia64_lfhint_nt2:						\
-                asm volatile ("lfetch.excl.nt2 [%0]" :: "r"(y));	\
+                __asm__ __volatile__ ("lfetch.excl.nt2 [%0]" :: "r"(y));	\
                 break;							\
         case ia64_lfhint_nta:						\
-                asm volatile ("lfetch.excl.nta [%0]" :: "r"(y));	\
+                __asm__ __volatile__ ("lfetch.excl.nta [%0]" :: "r"(y));	\
                 break;							\
         }								\
 })
@@ -557,16 +557,16 @@ do {										\
 ({									\
         switch (lfhint) {						\
         case ia64_lfhint_none:						\
-                asm volatile ("lfetch.fault [%0]" : : "r"(y));		\
+                __asm__ __volatile__ ("lfetch.fault [%0]" : : "r"(y));		\
                 break;							\
         case ia64_lfhint_nt1:						\
-                asm volatile ("lfetch.fault.nt1 [%0]" : : "r"(y));	\
+                __asm__ __volatile__ ("lfetch.fault.nt1 [%0]" : : "r"(y));	\
                 break;							\
         case ia64_lfhint_nt2:						\
-                asm volatile ("lfetch.fault.nt2 [%0]" : : "r"(y));	\
+                __asm__ __volatile__ ("lfetch.fault.nt2 [%0]" : : "r"(y));	\
                 break;							\
         case ia64_lfhint_nta:						\
-                asm volatile ("lfetch.fault.nta [%0]" : : "r"(y));	\
+                __asm__ __volatile__ ("lfetch.fault.nta [%0]" : : "r"(y));	\
                 break;							\
         }								\
 })
@@ -575,23 +575,23 @@ do {										\
 ({									\
         switch (lfhint) {						\
         case ia64_lfhint_none:						\
-                asm volatile ("lfetch.fault.excl [%0]" :: "r"(y));	\
+                __asm__ __volatile__ ("lfetch.fault.excl [%0]" :: "r"(y));	\
                 break;							\
         case ia64_lfhint_nt1:						\
-                asm volatile ("lfetch.fault.excl.nt1 [%0]" :: "r"(y));	\
+                __asm__ __volatile__ ("lfetch.fault.excl.nt1 [%0]" :: "r"(y));	\
                 break;							\
         case ia64_lfhint_nt2:						\
-                asm volatile ("lfetch.fault.excl.nt2 [%0]" :: "r"(y));	\
+                __asm__ __volatile__ ("lfetch.fault.excl.nt2 [%0]" :: "r"(y));	\
                 break;							\
         case ia64_lfhint_nta:						\
-                asm volatile ("lfetch.fault.excl.nta [%0]" :: "r"(y));	\
+                __asm__ __volatile__ ("lfetch.fault.excl.nta [%0]" :: "r"(y));	\
                 break;							\
         }								\
 })
 
 #define ia64_intrin_local_irq_restore(x)			\
 do {								\
-	asm volatile (";;   cmp.ne p6,p7=%0,r0;;"		\
+	__asm__ __volatile__ (";;   cmp.ne p6,p7=%0,r0;;"		\
 		      "(p6) ssm psr.i;"				\
 		      "(p7) rsm psr.i;;"			\
 		      "(p6) srlz.d"				\
