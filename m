Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZCDADa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZCDADa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZCDADW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:03:22 -0500
Received: from ozlabs.org ([203.10.76.45]:53492 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbZCDADV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:03:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu 
 =?iso-8859-1?q?chunk=09allocation?=
Date: Wed, 4 Mar 2009 10:33:08 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224141217.GA17287@elte.hu> <49A40624.4000100@kernel.org>
In-Reply-To: <49A40624.4000100@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200903041033.09502.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 01:07:24 Tejun Heo wrote:
> it always
> saves a 2MB TLB entry for all the non-NUMA machines out there.

Note that everyone keeps talking about "a" TLB entry; I wanted to make
sure (esp. for those of us reading from the sidelines), it's not: it's
up to num_possible_cpus() TLB entries.  Of course, many paths won't access
other CPU's data, but it'd be interesting (and pretty easy) to actually
instrument how rare this is...

Hmm, fairly rare, but not incredibly:

percpu: measure use

With the idea of using virtual mappings for percpu regions, we wonder
how often we access other CPU's per-cpu variables.

32-bit 4-way SMP (under kvm), kernel make -j4:
get_cpu_var()         52,358,618
raw_get_cpu_var()        287,191
per_cpu():            17,371,648
per_cpu(same):        16,020,390

Total same-cpu calls: 68,666,199
Cross-per-cpu calls:   1,351,258

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/Makefile_32.cpu     |    2 +-
 include/asm-generic/percpu.h |   10 +++++++---
 kernel/module.c              |   11 +++++++++++
 kernel/smp.c                 |   21 +++++++++++++++++++++
 4 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -47,5 +47,5 @@ cflags-$(CONFIG_X86_GENERIC) 	+= $(call 
 # Bug fix for binutils: this option is required in order to keep
 # binutils from generating NOPL instructions against our will.
 ifneq ($(CONFIG_X86_P6_NOP),y)
-cflags-y			+= $(call cc-option,-Wa$(comma)-mtune=generic32,)
+#cflags-y			+= $(call cc-option,-Wa$(comma)-mtune=generic32,)
 endif
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -53,12 +53,16 @@ extern unsigned long __per_cpu_offset[NR
  * established ways to produce a usable pointer from the percpu variable
  * offset.
  */
+void count_per_cpu(unsigned int cpu);
+void count_get_cpu_var(void);
+void count_raw_get_cpu_var(void);
+
 #define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+	(*(count_per_cpu(cpu), SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu))))
 #define __get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
+	(*(count_get_cpu_var(), SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset)))
 #define __raw_get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
+	(*(count_raw_get_cpu_var(), SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset)))
 
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2705,6 +2705,17 @@ static const struct seq_operations modul
 
 static int modules_open(struct inode *inode, struct file *file)
 {
+	extern atomic_t get_cpu_var_count, raw_get_cpu_var_count, per_cpu_count[], unnecessary_count[];
+	unsigned int i;
+
+	printk("get_cpu_var_count: %i\n", atomic_xchg(&get_cpu_var_count, 0));
+	printk("raw_get_cpu_var_count: %i\n",
+	       atomic_xchg(&raw_get_cpu_var_count, 0));
+	for_each_online_cpu(i)
+		printk("per_cpu %i: %u (%u self)\n",
+		       i, atomic_xchg(&per_cpu_count[i], 0),
+		       atomic_xchg(&unnecessary_count[i], 0));
+
 	return seq_open(file, &modules_op);
 }
 
diff --git a/kernel/smp.c b/kernel/smp.c
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -10,6 +10,27 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/smp.h>
+
+atomic_t get_cpu_var_count, raw_get_cpu_var_count, per_cpu_count[CONFIG_NR_CPUS], unnecessary_count[CONFIG_NR_CPUS];
+void count_per_cpu(unsigned int cpu)
+{
+	if (cpu == raw_smp_processor_id())
+		atomic_inc(&unnecessary_count[cpu]);
+	atomic_inc(&per_cpu_count[cpu]);
+}
+EXPORT_SYMBOL(count_per_cpu);
+
+void count_get_cpu_var(void)
+{
+	atomic_inc(&get_cpu_var_count);
+}
+EXPORT_SYMBOL(count_get_cpu_var);
+
+void count_raw_get_cpu_var(void)
+{
+	atomic_inc(&raw_get_cpu_var_count);
+}
+EXPORT_SYMBOL(count_raw_get_cpu_var);
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 static LIST_HEAD(call_function_queue);
