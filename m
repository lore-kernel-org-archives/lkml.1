Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZDOGf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZDOGf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZDOGfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:35:11 -0400
Received: from ozlabs.org ([203.10.76.45]:42694 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZDOGfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:35:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch for 2.6.30 2/2] arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts
Date: Wed, 15 Apr 2009 16:05:05 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Dave Jones <davej@redhat.com>, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, efault@gmx.de, len.brown@intel.com,
       mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com,
       yakui.zhao@intel.com, yanmin_zhang@linux.intel.com
References: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org> <200904141821.37413.rusty@rustcorp.com.au> <20090414101817.0c935261.akpm@linux-foundation.org>
In-Reply-To: <20090414101817.0c935261.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200904151605.05989.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 02:48:17 am Andrew Morton wrote:
> On Tue, 14 Apr 2009 18:21:36 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Subject: cpumask: cpumask_closest()
..
> Should it be exported?

Ah yes.

> It looks all racy against hotplug.  What are the caller's
> responsibilities here?

Kind of independent.  There's no implied internal reference to online_mask.

> any_online_cpu() could use cpumask_closest(), against (*mask & cpu_online_map).

Note that I've been killing any_online_cpu().  It passes a cpumask on stack, 
and cpumask_any(cpu_online_mask) / cpumask_any_and(mask, cpu_online_mask) work
just as well.

> I think all cpumask_any() call sites can be migrated to
> cpumask_closest() with, at worst, no benefit.

OK, here's the updated patch.

Rusty.

Subject: cpumask: cpumask_closest() and cpumask_closest_and()

Impact: new functions

Andrew points out that acpi-cpufreq uses cpumask_any, when it really
would prefer to use the same CPU if possible (to avoid an IPI).  In
general, this seems a good idea to offer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/cpumask.h |    4 +++
 lib/cpumask.c           |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -931,6 +931,10 @@ static inline void cpumask_copy(struct c
  */
 #define cpumask_of(cpu) (get_cpu_mask(cpu))
 
+unsigned int cpumask_closest(const struct cpumask *mask);
+unsigned int cpumask_closest_and(const struct cpumask *mask1,
+				 const struct cpumask *mask2);
+
 /**
  * cpumask_scnprintf - print a cpumask into a string as comma-separated hex
  * @buf: the buffer to sprintf into
diff --git a/lib/cpumask.c b/lib/cpumask.c
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -170,3 +170,57 @@ void __init free_bootmem_cpumask_var(cpu
 	free_bootmem((unsigned long)mask, cpumask_size());
 }
 #endif
+
+/**
+ * cpumask_closest - return the closest cpu in mask.
+ * @mask: the cpus to choose from.
+ *
+ * Returns >= nr_cpu_ids if no bits are set in @mask.
+ */
+unsigned int cpumask_closest(const struct cpumask *mask)
+{
+	unsigned int cpu = raw_smp_processor_id();
+
+	/* Try for same CPU. */
+	if (cpumask_test_cpu(cpu, mask))
+		return cpu;
+
+	/* Try for same node. */
+	cpu = cpumask_any_and(cpumask_of_node(cpu), mask);
+	if (cpu <= nr_cpu_ids)
+		return cpu;
+
+	/* Anything will do. */
+	return cpumask_any(mask);
+}
+EXPORT_SYMBOL(cpumask_closest);
+
+/**
+ * cpumask_closest_and - return the closest cpu in both masks.
+ * @mask1: one set of cpus to choose from.
+ * @mask2: the other set of cpus to choose from.
+ *
+ * The same as cpumask_closest(@mask1 & @mask2).
+ * Returns >= nr_cpu_ids if no bits are set in both..
+ */
+unsigned int cpumask_closest_and(const struct cpumask *mask1,
+				 const struct cpumask *mask2)
+{
+	unsigned int cpu = raw_smp_processor_id();
+	const struct cpumask *nodemask;
+
+	/* Try for same CPU. */
+	if (cpumask_test_cpu(cpu, mask1) && cpumask_test_cpu(cpu, mask2))
+		return cpu;
+
+	/* Try for same node. */
+	nodemask = cpumask_of_node(cpu);
+	for_each_cpu_and(cpu, nodemask, mask1) {
+		if (cpumask_test_cpu(cpu, mask2))
+			return cpu;
+	}
+
+	/* Anything will do. */
+	return cpumask_any_and(mask1, mask2);
+}
+EXPORT_SYMBOL(cpumask_closest_and);

