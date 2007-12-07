Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbXLGTSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbXLGTSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXLGTSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:18:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47114 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbXLGTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:18:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, ak@suse.de, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
References: <200711280121.18376.lenb@kernel.org>
	<20071204163946.63ac73ce.akpm@linux-foundation.org>
	<20071205094837.GB17911@elte.hu> <200712062141.05195.lenb@kernel.org>
Date: Fri, 07 Dec 2007 12:16:22 -0700
In-Reply-To: <200712062141.05195.lenb@kernel.org> (Len Brown's message of
	"Thu, 6 Dec 2007 21:41:04 -0500")
Message-ID: <m1mysmqprt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> On Wednesday 05 December 2007 04:48, Ingo Molnar wrote:
>> 
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>> 
>> > On Tue, 4 Dec 2007 13:26:49 +0100
>> > Ingo Molnar <mingo@elte.hu> wrote:
>> > 
>> > > * Len Brown <lenb@kernel.org> wrote:
>> > > 
>> > > >     So while the irq compression code on i386 should really
>> > > >     be deleted -- even before merging the x86_64 irq-overhaul,
>> > > >     this patch simply disables it on all high volume systems
>> > > >     to avoid problems #1 and #2 on most all i386 systems.
>> > > >     
>> > > >     A large system with pin numbers >=64 will still have compression
>> > > >     to conserve limited IRQ numbers for sparse IOAPICS.  However,
>> > > >     the vast majority of the planet, those with only pin numbers < 64
>> > > >     will use an identity GSI -> IRQ mapping.
>> > > >     
>> > > >     Signed-off-by: Len Brown <len.brown@intel.com>
>> > > 
>> > > thanks for the patch and the extensive description. I've applied this to 
>> > > x86.git.
>> > 
>> > Len applied it to his tree too.
>> 
>> Len, i think this belongs into x86.git a bit more (especially with the 
>> unification activities going on all around the tree) - do you agree? 
>> Andrew, i'd suggest to apply a reverted patch to between git.acpi and 
>> git.x86 until this gets sorted out.
>
> Sure.
> I'm re-basing my test branch right now and can exclude this one
> since it is in x86.git. (and yes, I'm interested in unifying mpparse_*.c some
> day)
>
> yes, your understanding is correct -- this is not urgent 2.6.24 material,
> it is just a 'regular patch':-)
>
> Re: making the VIA part into dead-code
> I had avoided that originally because I was going to nominate
> this patch for the highest check-in-comment length/code-change ratio
> But once I went over 1 line I blew the budget;-)
>
> Eric,
> What do you suggest we do with NR_IRQS on i386 so that we
> can delete the compression code entirely?
>
> thanks,
> -Len

Attached below is my patch from last time I was looking at this
problem, it doesn't quite apply but it is gives a good idea of where
I think we should go.

For the current 64bit kernel we do have a point where if we run out
of vectors we just can't use the irqs.  Because that point is
about 192*nr_online_cpus() we never hit it in practice.

If we just rip out the vector irq compression logic (without
implementing the per cpu vector logic) we will theoretically
have systems that will not run out of vectors and so some of their
irqs (50?) won't work, but it is likely those systems will still boot.

Unless there are really nasty ioapic bugs on that don't show up on
the 64bit systems we should be able to move the  per cpu vector
logic onto the 32bit side as well now that we understand what needs
to happen.  I didn't want to do the port until we had stabalized
things on the 64bit side, which largely we seem to have managed.

So as long as we are going to move the per cpu vector logic eventually
to the 32bit kernels I don't think we will have a problem if we
increase NR_IRQs, then kill the compression, and then get around to
implementing the per cpu vector logic.


>From b91d576ba0f88e5416f8737c4f2dca3fb814f2fe Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Fri, 16 Feb 2007 02:18:28 -0700
Subject: [PATCH] i386 irq: Kill NR_IRQ_VECTORS and increase NR_IRQS

Due to hardware and software implementation limits the i386 kernel
can only use 224 or so different IRQs at one time.  However except
for actually having the irqs delivered there are no limits except
the arbitrary number NR_IRQS on how many irqs we can talk about
and deal with.

Frequently not all io_apics inputs are connected to interrupt traces
going to real devices, and since even when they are devices don't
 always use all of interrupt traces routed to them.  So it makes
sense to be able to talk about many more irq sources then we can
actually use.

So this patch consolidates NR_IRQS and NR_IRQ_VECTORS into just
NR_IRQS and raises NR_IRQS where appropriate above the number of
irqs we can use at one time.

Allowing the kernel to work on big machines without complicated
and error prone irq remapping logic.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/acpi/boot.c                       |    4 ++--
 arch/i386/kernel/io_apic.c                         |    6 +++---
 include/asm-i386/mach-default/irq_vectors_limits.h |    8 +++-----
 include/asm-i386/mach-generic/irq_vectors_limits.h |    3 +--
 include/asm-i386/mach-summit/irq_vectors_limits.h  |    3 +--
 include/asm-i386/mach-visws/irq_vectors.h          |    1 -
 include/asm-i386/mach-voyager/irq_vectors.h        |    1 -
 7 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/i386/kernel/acpi/boot.c b/arch/i386/kernel/acpi/boot.c
index 9ea5b8e..859fb03 100644
--- a/arch/i386/kernel/acpi/boot.c
+++ b/arch/i386/kernel/acpi/boot.c
@@ -811,7 +811,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
-				  NR_IRQ_VECTORS);
+				  NR_IRQS);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -831,7 +831,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  NR_IRQ_VECTORS);
+				  NR_IRQS);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 816a8aa..9578ca9 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -1223,14 +1223,14 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 
 /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
+static u8 irq_vector[NR_IRQS] __read_mostly = { FIRST_DEVICE_VECTOR , 0 };
 
 static int __assign_irq_vector(int irq)
 {
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	int vector, offset, i;
 
-	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
+	BUG_ON((unsigned)irq >= NR_IRQS);
 
 	if (irq_vector[irq] > 0)
 		return irq_vector[irq];
@@ -1247,7 +1247,7 @@ next:
 		return -ENOSPC;
 	if (vector == SYSCALL_VECTOR)
 		goto next;
-	for (i = 0; i < NR_IRQ_VECTORS; i++)
+	for (i = 0; i < NR_IRQS; i++)
 		if (irq_vector[i] == vector)
 			goto next;
 
diff --git a/include/asm-i386/mach-default/irq_vectors_limits.h b/include/asm-i386/mach-default/irq_vectors_limits.h
index 7f161e7..ad4e05c 100644
--- a/include/asm-i386/mach-default/irq_vectors_limits.h
+++ b/include/asm-i386/mach-default/irq_vectors_limits.h
@@ -2,15 +2,13 @@
 #define _ASM_IRQ_VECTORS_LIMITS_H
 
 #ifdef CONFIG_X86_IO_APIC
-#define NR_IRQS 224
-# if (224 >= 32 * NR_CPUS)
-# define NR_IRQ_VECTORS NR_IRQS
+# if (200 >= 32 * NR_CPUS)
+#  define NR_IRQS 200
 # else
-# define NR_IRQ_VECTORS (32 * NR_CPUS)
+#  define NR_IRQS (32 * NR_CPUS)
 # endif
 #else
 #define NR_IRQS 16
-#define NR_IRQ_VECTORS NR_IRQS
 #endif
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-i386/mach-generic/irq_vectors_limits.h b/include/asm-i386/mach-generic/irq_vectors_limits.h
index 890ce3f..f16f727 100644
--- a/include/asm-i386/mach-generic/irq_vectors_limits.h
+++ b/include/asm-i386/mach-generic/irq_vectors_limits.h
@@ -8,7 +8,6 @@
  * This value should be the same in both the generic and summit subarches.
  * Change one, change 'em both.
  */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
+#define NR_IRQS	1024
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-i386/mach-summit/irq_vectors_limits.h b/include/asm-i386/mach-summit/irq_vectors_limits.h
index 890ce3f..f16f727 100644
--- a/include/asm-i386/mach-summit/irq_vectors_limits.h
+++ b/include/asm-i386/mach-summit/irq_vectors_limits.h
@@ -8,7 +8,6 @@
  * This value should be the same in both the generic and summit subarches.
  * Change one, change 'em both.
  */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
+#define NR_IRQS	1024
 
 #endif /* _ASM_IRQ_VECTORS_LIMITS_H */
diff --git a/include/asm-i386/mach-visws/irq_vectors.h b/include/asm-i386/mach-visws/irq_vectors.h
index cb572d8..c32ebdf 100644
--- a/include/asm-i386/mach-visws/irq_vectors.h
+++ b/include/asm-i386/mach-visws/irq_vectors.h
@@ -51,7 +51,6 @@
  */
 #define NR_VECTORS 256
 #define NR_IRQS 224
-#define NR_IRQ_VECTORS NR_IRQS
 
 #define FPU_IRQ			13
 
diff --git a/include/asm-i386/mach-voyager/irq_vectors.h b/include/asm-i386/mach-voyager/irq_vectors.h
index 165421f..abaf5cf 100644
--- a/include/asm-i386/mach-voyager/irq_vectors.h
+++ b/include/asm-i386/mach-voyager/irq_vectors.h
@@ -57,7 +57,6 @@
 
 #define NR_VECTORS 256
 #define NR_IRQS 224
-#define NR_IRQ_VECTORS NR_IRQS
 
 #define FPU_IRQ				13
 
-- 
1.5.3.rc6.17.g1911

