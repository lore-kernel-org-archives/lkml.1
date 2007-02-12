Return-Path: <linux-kernel-owner+w=401wt.eu-S965425AbXBLWBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbXBLWBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965429AbXBLWBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:01:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbXBLWBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:01:01 -0500
Date: Mon, 12 Feb 2007 14:00:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, adobriyan@openvz.org
Subject: Re: - rdmsr_on_cpu-wrmsr_on_cpu.patch removed from -mm tree
Message-Id: <20070212140043.6586665c.akpm@linux-foundation.org>
In-Reply-To: <200702111138.23253.ak@suse.de>
References: <200702082132.l18LWhl4027000@shell0.pdx.osdl.net>
	<20070211001143.GB13178@redhat.com>
	<200702111138.23253.ak@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 11 Feb 2007 11:38:23 +0100 Andi Kleen <ak@suse.de> wrote:
> On Sunday 11 February 2007 01:11, Dave Jones wrote:
> > On Thu, Feb 08, 2007 at 01:32:43PM -0800, akpm@linux-foundation.org wrote:
> >  > 
> >  > The patch titled
> >  >      rdmsr_on_cpu, wrmsr_on_cpu
> >  > has been removed from the -mm tree.  Its filename was
> >  >      rdmsr_on_cpu-wrmsr_on_cpu.patch
> >  > 
> >  > This patch was dropped because I've lost the plot on this thing
> > 
> > Alexey, send me the latest fixed up version of this, and I'll
> > queue this up to save Andrew trying to sort it out.
> 
> I fixed it up to at least support x86-64 too
> 

No you didn't ;) I still get a build error with i386 allmodconfig using
your version.

I backed out x86_64-mm-msr-on-cpu.patch (again) and went with Alexey's
second version (again).  It works fine.



From: Alexey Dobriyan <adobriyan@openvz.org>

There was OpenVZ specific bug rendering some cpufreq drivers unusable on SMP. 
In short, when cpufreq code thinks it confined itself to needed cpu by means
of set_cpus_allowed() to execute rdmsr, some "virtual cpu" feature can migrate
process to anywhere.  This triggers bugons and does wrong things in general.

This got fixed by introducing rdmsr_on_cpu and wrmsr_on_cpu executing rdmsr
and wrmsr on given physical cpu by means of smp_call_function_single().

Dave Jones mentioned cpufreq might be not only user of rdmsr_on_cpu() and
wrmsr_on_cpu(), so I'm putting them into arch/{i386,x86_64}/lib/ .

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Acked-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/Makefile       |    2 
 arch/i386/lib/msr-on-cpu.c   |   70 +++++++++++++++++++++++++++++++++
 arch/x86_64/lib/Makefile     |    2 
 arch/x86_64/lib/msr-on-cpu.c |    1 
 include/asm-i386/msr.h       |    3 +
 include/asm-x86_64/msr.h     |    2 
 6 files changed, 79 insertions(+), 1 deletion(-)

diff -puN arch/i386/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu arch/i386/lib/Makefile
--- a/arch/i386/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/arch/i386/lib/Makefile
@@ -7,3 +7,5 @@ lib-y = checksum.o delay.o usercopy.o ge
 	bitops.o semaphore.o
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
+
+obj-y = msr-on-cpu.o
diff -puN /dev/null arch/i386/lib/msr-on-cpu.c
--- /dev/null
+++ a/arch/i386/lib/msr-on-cpu.c
@@ -0,0 +1,70 @@
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <asm/msr.h>
+
+#ifdef CONFIG_SMP
+struct msr_info {
+	u32 msr_no;
+	u32 l, h;
+};
+
+static void __rdmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rdmsr(rv->msr_no, rv->l, rv->h);
+}
+
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	preempt_disable();
+	if (smp_processor_id() == cpu)
+		rdmsr(msr_no, *l, *h);
+	else {
+		struct msr_info rv;
+
+		rv.msr_no = msr_no;
+		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		*l = rv.l;
+		*h = rv.h;
+	}
+	preempt_enable();
+}
+
+static void __wrmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	wrmsr(rv->msr_no, rv->l, rv->h);
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	preempt_disable();
+	if (smp_processor_id() == cpu)
+		wrmsr(msr_no, l, h);
+	else {
+		struct msr_info rv;
+
+		rv.msr_no = msr_no;
+		rv.l = l;
+		rv.h = h;
+		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+	}
+	preempt_enable();
+}
+#else
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	rdmsr(msr_no, *l, *h);
+}
+
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	wrmsr(msr_no, l, h);
+}
+#endif
+
+EXPORT_SYMBOL(rdmsr_on_cpu);
+EXPORT_SYMBOL(wrmsr_on_cpu);
diff -puN arch/x86_64/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu arch/x86_64/lib/Makefile
--- a/arch/x86_64/lib/Makefile~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/arch/x86_64/lib/Makefile
@@ -4,7 +4,7 @@
 
 CFLAGS_csum-partial.o := -funroll-loops
 
-obj-y := io.o iomap_copy.o
+obj-y := io.o iomap_copy.o msr-on-cpu.o
 
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
diff -puN /dev/null arch/x86_64/lib/msr-on-cpu.c
--- /dev/null
+++ a/arch/x86_64/lib/msr-on-cpu.c
@@ -0,0 +1 @@
+#include "../../i386/lib/msr-on-cpu.c"
diff -puN include/asm-i386/msr.h~rdmsr_on_cpu-wrmsr_on_cpu include/asm-i386/msr.h
--- a/include/asm-i386/msr.h~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/include/asm-i386/msr.h
@@ -83,6 +83,9 @@ static inline void wrmsrl (unsigned long
 			  : "c" (counter))
 #endif	/* !CONFIG_PARAVIRT */
 
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+
 /* symbolic names for some interesting MSRs */
 /* Intel defined MSRs. */
 #define MSR_IA32_P5_MC_ADDR		0
diff -puN include/asm-x86_64/msr.h~rdmsr_on_cpu-wrmsr_on_cpu include/asm-x86_64/msr.h
--- a/include/asm-x86_64/msr.h~rdmsr_on_cpu-wrmsr_on_cpu
+++ a/include/asm-x86_64/msr.h
@@ -160,6 +160,8 @@ static inline unsigned int cpuid_edx(uns
 #define MSR_IA32_UCODE_WRITE		0x79
 #define MSR_IA32_UCODE_REV		0x8b
 
+void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
+void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
 
 #endif
 
_

