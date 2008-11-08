Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYKHJYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYKHJYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYKHJYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:24:24 -0500
Received: from ozlabs.org ([203.10.76.45]:43208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYKHJYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:24:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Date: Sat, 8 Nov 2008 20:24:19 +1100
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <20081107093911.GD7787@elte.hu> <20081107122400.GA20777@elte.hu>
In-Reply-To: <20081107122400.GA20777@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811082024.20157.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2008 23:24:00 Ingo Molnar wrote:
> Find below the delta patch between the two versions, and an
> analysis/review of the changes. I've started testing it as well, and
> it's looking good so far.

Ok, I sent through the latest delta on top of this before, but see below.

> - the cpumask_of() is added to the SMP section of cpumask.h but not to
>   the UP section.

Not quite: it's in the general section.  Don't scare me like that :)

> - the free_bootmem_cpumask_var() addition looks good but is a tiny bit
>   incomplete: the free_bootmem_cpumask_var() function should be marked
>   __init, like all bootmem methods are.

Looks like you took that draft I mailed around?  Mike asked for free_... as a
response to that.  But I'll fix the __init.

I've restored the patch into that version you have, plus separate updates.  I
hope that fixes the workflow issues.

Updates below for reference.

Thanks,
Rusty.
===
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -894,6 +894,12 @@ static inline void cpumask_copy(struct c
 #define cpumask_any_and(mask1, mask2) cpumask_first_and((mask1), (mask2))
 
 /**
+ * cpumask_of - the cpumask containing just a given cpu
+ * @cpu: the cpu (<= nr_cpu_ids)
+ */
+#define cpumask_of(cpu) (get_cpu_mask(cpu))
+
+/**
  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
  * @bitmap: the bitmap
  *
@@ -946,6 +952,7 @@ bool alloc_cpumask_var(cpumask_var_t *ma
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 void alloc_bootmem_cpumask_var(cpumask_var_t *mask);
 void free_cpumask_var(cpumask_var_t mask);
+void free_bootmem_cpumask_var(cpumask_var_t mask);
 
 #else
 typedef struct cpumask cpumask_var_t[1];
@@ -960,6 +967,10 @@ static inline void alloc_bootmem_cpumask
 }
 
 static inline void free_cpumask_var(cpumask_var_t mask)
+{
+}
+
+static inline void free_bootmem_cpumask_var(cpumask_var_t mask)
 {
 }
 #endif /* CONFIG_CPUMASK_OFFSTACK */
diff --git a/lib/cpumask.c b/lib/cpumask.c
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -107,4 +107,9 @@ void free_cpumask_var(cpumask_var_t mask
 	kfree(mask);
 }
 EXPORT_SYMBOL(free_cpumask_var);
+
+void free_bootmem_cpumask_var(cpumask_var_t mask)
+{
+	free_bootmem((unsigned long)mask, cpumask_size());
+}
 #endif
===
1) Andrew pointed out inlines are superior to macros.  Also, UP versions
   weren't correct in all cases (doesn't matter at the moment, but
   nasty surprise one day).

2) Documentation was missing for for_each_cpu and for_each_cpu_and.

3) As we state when fixing the UP version, the "cpu" arg to
   "cpumask_any_but()" must be a valid CPU number, so add debug check.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 09f8198c811d include/linux/cpumask.h
--- a/include/linux/cpumask.h	Sat Nov 08 20:05:51 2008 +1100
+++ b/include/linux/cpumask.h	Sat Nov 08 20:10:07 2008 +1100
@@ -564,12 +564,36 @@ static inline unsigned int cpumask_check
 }
 
 #if NR_CPUS == 1
-/* Uniprocesor. */
-#define cpumask_first(src)		({ (void)(src); 0; })
-#define cpumask_next(n, src)		({ (void)(src); 1; })
-#define cpumask_next_zero(n, src)	({ (void)(src); 1; })
-#define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
-#define cpumask_any_but(mask, cpu)	({ (void)(mask); (void)(cpu); 0; })
+/* Uniprocessor.  Assume all masks are "1". */
+static inline unsigned int cpumask_first(const struct cpumask *srcp)
+{
+	return 0;
+}
+
+/* Valid inputs for n are -1 and 0. */
+static inline unsigned int cpumask_next(int n, const struct cpumask *srcp)
+{
+	return n+1;
+}
+
+static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
+{
+	return n+1;
+}
+
+static inline unsigned int cpumask_next_and(int n,
+					    const struct cpumask *srcp,
+					    const struct cpumask *andp)
+{
+	return n+1;
+}
+
+/* cpu must be a valid cpu, ie 0, so there's no other choice. */
+static inline unsigned int cpumask_any_but(const struct cpumask *mask,
+					   unsigned int cpu)
+{
+	return 1;
+}
 
 #define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
@@ -620,10 +644,32 @@ int cpumask_next_and(int n, const struct
 int cpumask_next_and(int n, const struct cpumask *, const struct cpumask *);
 int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
 
+/**
+ * for_each_cpu - iterate over every cpu in a mask
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask: the cpumask pointer
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
 #define for_each_cpu(cpu, mask)				\
 	for ((cpu) = -1;				\
 		(cpu) = cpumask_next((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
+
+/**
+ * for_each_cpu_and - iterate over every cpu in both masks
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask: the first cpumask pointer
+ * @and: the second cpumask pointer
+ *
+ * This saves a temporary CPU mask in many places.  It is equivalent to:
+ *	struct cpumask tmp;
+ *	cpumask_and(&tmp, &mask, &and);
+ *	for_each_cpu(cpu, &tmp)
+ *		...
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
 #define for_each_cpu_and(cpu, mask, and)				\
 	for ((cpu) = -1;						\
 		(cpu) = cpumask_next_and((cpu), (mask), (and)),		\
diff -r 09f8198c811d lib/cpumask.c
--- a/lib/cpumask.c	Sat Nov 08 20:05:51 2008 +1100
+++ b/lib/cpumask.c	Sat Nov 08 20:10:07 2008 +1100
@@ -67,6 +67,7 @@ int cpumask_any_but(const struct cpumask
 {
 	unsigned int i;
 
+	cpumask_check(cpu);
 	for_each_cpu(i, mask)
 		if (i != cpu)
 			break;
===
Ingo points out that free_bootmem_cpumask_var() should be __init.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r dfda8a1507d5 lib/cpumask.c
--- a/lib/cpumask.c	Sat Nov 08 20:10:15 2008 +1100
+++ b/lib/cpumask.c	Sat Nov 08 20:19:14 2008 +1100
@@ -109,7 +109,7 @@ void free_cpumask_var(cpumask_var_t mask
 }
 EXPORT_SYMBOL(free_cpumask_var);
 
-void free_bootmem_cpumask_var(cpumask_var_t mask)
+void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
 	free_bootmem((unsigned long)mask, cpumask_size());
 }









