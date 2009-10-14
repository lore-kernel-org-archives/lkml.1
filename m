Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZJNGDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZJNGDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZJNGDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:58693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZJNGDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:34 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/16] percpu: make access macros universal
Date: Wed, 14 Oct 2009 15:02:03 +0900
Message-Id: <1255500125-3210-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that per_cpu__ prefix is gone, there's no distinction between
static and dynamic percpu variables.  Make get_cpu_var() take dynamic
percpu variables and ensure that all macros have parentheses around
the parameter evaluation and evaluate the variable parameter only once
such that any expression which evaluates to percpu address can be used
safely.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e12410e..f965f83 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -27,10 +27,13 @@
  * we force a syntax error here if it isn't.
  */
 #define get_cpu_var(var) (*({				\
-	extern int simple_identifier_##var(void);	\
 	preempt_disable();				\
 	&__get_cpu_var(var); }))
-#define put_cpu_var(var) preempt_enable()
+
+#define put_cpu_var(var) do {				\
+	(void)(var);					\
+	preempt_enable();				\
+} while (0)
 
 #ifdef CONFIG_SMP
 
@@ -182,17 +185,19 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
 #ifndef percpu_read
 # define percpu_read(var)						\
   ({									\
-	typeof(var) __tmp_var__;					\
-	__tmp_var__ = get_cpu_var(var);					\
-	put_cpu_var(var);						\
-	__tmp_var__;							\
+	typeof(var) *pr_ptr__ = &(var);					\
+	typeof(var) pr_ret__;						\
+	pr_ret__ = get_cpu_var(*pr_ptr__);				\
+	put_cpu_var(*pr_ptr__);						\
+	pr_ret__;							\
   })
 #endif
 
 #define __percpu_generic_to_op(var, val, op)				\
 do {									\
-	get_cpu_var(var) op val;					\
-	put_cpu_var(var);						\
+	typeof(var) *pgto_ptr__ = &(var);				\
+	get_cpu_var(*pgto_ptr__) op val;				\
+	put_cpu_var(*pgto_ptr__);					\
 } while (0)
 
 #ifndef percpu_write
@@ -304,7 +309,7 @@ do {									\
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	preempt_disable();						\
-	*__this_cpu_ptr(&pcp) op val;					\
+	*__this_cpu_ptr(&(pcp)) op val;					\
 	preempt_enable();						\
 } while (0)
 
-- 
1.6.4.2

