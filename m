Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955Ab0A2IUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0A2IUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873Ab0A2IUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:20:22 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:27149 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0A2IUU (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Fri, 29 Jan 2010 03:20:20 -0500
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 03:20:19 EST
Message-Id: <4B62A39D020000780002CA80@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 29 Jan 2010 08:00:13 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86: enlightenment for ticket spinlocks
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part49636D9D.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part49636D9D.3__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

With the pv-ops based spinlocks reportedly having measurable overhead
on native execution, and with them also not easily fit (at least) fully
virtualized Xen guests, this patch series introduces a replacement
mechanism based on alternative instruction patching, and then uses it
for fully virtualized Xen guests. While coded to be orthogonal to
pv-ops, it really isn't, and it shouldn't be difficult to make pv-ops =
guests
use this in place of pv-ops spin locks.

The only additional overhead this introduces for native execution is
the writing of the owning CPU in the lock acquire paths. If this is
considered a problem, even that code could be eliminated for native
execution (by further alternative instruction patching).

(1) base implementation
(2) Xen implementation
(3) [optional] eliminate on NOPs in unlock path (introduced in (1))

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>


--=__Part49636D9D.3__=
Content-Type: text/plain; name="linux-2.6.33-rc5-virt-spinlocks-xen.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-2.6.33-rc5-virt-spinlocks-xen.patch"

Use the (alternative instructions based) callout hooks to the ticket=0Aspin=
lock code to enlighten ticket locks when running fully virtualized=0Aon =
Xen. Ultimately, this code might also be a candidate to be used=0Awhen =
running para-virtualized.=0A=0ASigned-off-by: Jan Beulich <jbeulich@novell.=
com>=0ACc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>=0A=0A---=0A=
 arch/x86/include/asm/processor.h |    1 =0A arch/x86/include/asm/xen.h    =
   |    7 +=0A arch/x86/include/asm/xen/cpuid.h |   68 ++++++++++=0A =
arch/x86/kernel/cpu/Makefile     |    2 =0A arch/x86/kernel/cpu/hypervisor.=
c |   11 +=0A arch/x86/kernel/cpu/xen.c        |  259 +++++++++++++++++++++=
++++++++++++++++++=0A 6 files changed, 345 insertions(+), 3 deletions(-)=0A=
=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/processor.h=0A++=
+ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/processor.h=0A@@ -129,6 =
+129,7 @@ struct cpuinfo_x86 {=0A =0A #define X86_HYPER_VENDOR_NONE  0=0A =
#define X86_HYPER_VENDOR_VMWARE 1=0A+#define X86_HYPER_VENDOR_XEN   2=0A =
=0A /*=0A  * capabilities of CPUs=0A--- /dev/null=0A+++ 2.6.33-rc5-virt-spi=
nlocks/arch/x86/include/asm/xen.h=0A@@ -0,0 +1,7 @@=0A+#ifndef ASM_X86__XEN=
_H=0A+#define ASM_X86__XEN_H=0A+=0A+extern int xen_platform(void);=0A+exter=
n void xen_set_feature_bits(struct cpuinfo_x86 *c);=0A+=0A+#endif=0A--- =
/dev/null=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/xen/cpuid.h=
=0A@@ -0,0 +1,68 @@=0A+/***************************************************=
***************************=0A+ * arch-x86/cpuid.h=0A+ *=0A+ * CPUID =
interface to Xen.=0A+ *=0A+ * Permission is hereby granted, free of =
charge, to any person obtaining a copy=0A+ * of this software and =
associated documentation files (the "Software"), to=0A+ * deal in the =
Software without restriction, including without limitation the=0A+ * =
rights to use, copy, modify, merge, publish, distribute, sublicense, =
and/or=0A+ * sell copies of the Software, and to permit persons to whom =
the Software is=0A+ * furnished to do so, subject to the following =
conditions:=0A+ *=0A+ * The above copyright notice and this permission =
notice shall be included in=0A+ * all copies or substantial portions of =
the Software.=0A+ *=0A+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT =
WARRANTY OF ANY KIND, EXPRESS OR=0A+ * IMPLIED, INCLUDING BUT NOT LIMITED =
TO THE WARRANTIES OF MERCHANTABILITY,=0A+ * FITNESS FOR A PARTICULAR =
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE=0A+ * AUTHORS OR =
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER=0A+ * =
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING=0A+=
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER=0A+ =
* DEALINGS IN THE SOFTWARE.=0A+ *=0A+ * Copyright (c) 2007 Citrix Systems, =
Inc.=0A+ *=0A+ * Authors:=0A+ *    Keir Fraser <keir.fraser@citrix.com>=0A+=
 */=0A+=0A+#ifndef __XEN_PUBLIC_ARCH_X86_CPUID_H__=0A+#define __XEN_PUBLIC_=
ARCH_X86_CPUID_H__=0A+=0A+/* Xen identification leaves start at 0x40000000.=
 */=0A+#define XEN_CPUID_FIRST_LEAF 0x40000000=0A+#define XEN_CPUID_LEAF(i)=
    (XEN_CPUID_FIRST_LEAF + (i))=0A+=0A+/*=0A+ * Leaf 1 (0x40000000)=0A+ * =
EAX: Largest Xen-information leaf. All leaves up to an including @EAX=0A+ =
*      are supported by the Xen host.=0A+ * EBX-EDX: "XenVMMXenVMM" =
signature, allowing positive identification=0A+ *      of a Xen host.=0A+ =
*/=0A+#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */=0A+#define =
XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */=0A+#define XEN_CPUID_SIGNAT=
URE_EDX 0x4d4d566e /* "nVMM" */=0A+=0A+/*=0A+ * Leaf 2 (0x40000001)=0A+ * =
EAX[31:16]: Xen major version.=0A+ * EAX[15: 0]: Xen minor version.=0A+ * =
EBX-EDX: Reserved (currently all zeroes).=0A+ */=0A+=0A+/*=0A+ * Leaf 3 =
(0x40000002)=0A+ * EAX: Number of hypercall transfer pages. This register =
is always guaranteed=0A+ *      to specify one hypercall page.=0A+ * EBX: =
Base address of Xen-specific MSRs.=0A+ * ECX: Features 1. Unused bits are =
set to zero.=0A+ * EDX: Features 2. Unused bits are set to zero.=0A+ =
*/=0A+=0A+/* Does the host support MMU_PT_UPDATE_PRESERVE_AD for this =
guest? */=0A+#define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0=0A+#defin=
e XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)=0A+=0A+#endif /* =
__XEN_PUBLIC_ARCH_X86_CPUID_H__ */=0A--- 2.6.33-rc5-virt-spinlocks.orig/arc=
h/x86/kernel/cpu/Makefile=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/c=
pu/Makefile=0A@@ -14,7 +14,7 @@ CFLAGS_common.o		:=3D $(nostackp)=0A=
 =0A obj-y			:=3D intel_cacheinfo.o addon_cpuid_features=
.o=0A obj-y			+=3D proc.o capflags.o powerflags.o =
common.o=0A-obj-y			+=3D vmware.o hypervisor.o =
sched.o=0A+obj-y			+=3D vmware.o xen.o hypervisor.o =
sched.o=0A =0A obj-$(CONFIG_X86_32)	+=3D bugs.o cmpxchg.o=0A obj-$(CONF=
IG_X86_64)	+=3D bugs_64.o=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/x8=
6/kernel/cpu/hypervisor.c=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/c=
pu/hypervisor.c=0A@@ -23,6 +23,7 @@=0A =0A #include <asm/processor.h>=0A =
#include <asm/vmware.h>=0A+#include <asm/xen.h>=0A #include <asm/hypervisor=
.h>=0A =0A #ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A@@ -39,6 +40,8 @@ detect_hyp=
ervisor_vendor(struct cpuinfo_=0A {=0A 	if (vmware_platform())=0A 		=
c->x86_hyper_vendor =3D X86_HYPER_VENDOR_VMWARE;=0A+	else if (xen_platfo=
rm())=0A+		c->x86_hyper_vendor =3D X86_HYPER_VENDOR_XEN;=0A 	=
else=0A 		c->x86_hyper_vendor =3D X86_HYPER_VENDOR_NONE;=0A =
}=0A@@ -46,9 +49,13 @@ detect_hypervisor_vendor(struct cpuinfo_=0A static =
inline void __cpuinit=0A hypervisor_set_feature_bits(struct cpuinfo_x86 =
*c)=0A {=0A-	if (boot_cpu_data.x86_hyper_vendor =3D=3D X86_HYPER_VENDOR_=
VMWARE) {=0A+	switch (boot_cpu_data.x86_hyper_vendor) {=0A+	case =
X86_HYPER_VENDOR_VMWARE:=0A 		vmware_set_feature_bits(c);=0A-		=
return;=0A+		break;=0A+	case X86_HYPER_VENDOR_XEN:=0A+		=
xen_set_feature_bits(c);=0A+		break;=0A 	}=0A }=0A =0A--- =
/dev/null=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/cpu/xen.c=0A@@ =
-0,0 +1,259 @@=0A+#define __XEN_INTERFACE_VERSION__ 0x00030207=0A+#include =
<linux/bootmem.h>=0A+#include <linux/init.h>=0A+#include <linux/module.h>=
=0A+#include <linux/percpu.h>=0A+#include <linux/smp.h>=0A+#include =
<linux/spinlock.h>=0A+#include <linux/stringify.h>=0A+#include <asm/sync_bi=
tops.h>=0A+#include <asm/xen.h>=0A+#include <asm/xen/cpuid.h>=0A+#include =
<asm/xen/hypercall.h>=0A+#include <xen/interface/event_channel.h>=0A+#inclu=
de <xen/interface/memory.h>=0A+#include <xen/interface/vcpu.h>=0A+=0A+#ifde=
f CONFIG_ENLIGHTEN_SPINLOCKS=0A+struct spinning {=0A+	volatile struct =
arch_spinlock *lock;=0A+	unsigned int ticket;=0A+	struct =
spinning *prev;=0A+};=0A+=0A+static struct shared_info *__read_mostly =
xen_shared_info;=0A+EXPORT_SYMBOL_GPL(xen_shared_info);=0A+=0A+static =
DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);=0A+static DEFINE_PER_C=
PU(evtchn_port_t, poll_evtchn);=0A+static DEFINE_PER_CPU(struct spinning =
*, spinning);=0A+/*=0A+ * Protect removal of objects: Insertion can be =
done lockless, and even=0A+ * removal itself doesn't need protection - =
what needs to be prevented is=0A+ * removed objects going out of scope (as =
they're living on the stack).=0A+ */=0A+static DEFINE_PER_CPU(arch_rwlock_t=
, spinning_rm_lock) =3D __ARCH_RW_LOCK_UNLOCKED;=0A+=0A+static unsigned =
int __read_mostly spin_count =3D 1000;=0A+static int __init setup_spin_coun=
t(char *s)=0A+{=0A+	if (!s)=0A+		return -EINVAL;=0A+	=
spin_count =3D simple_strtoul(s, &s, 0);=0A+	return !*s ? 0 : =
-EINVAL;=0A+}=0A+early_param("spin_count", setup_spin_count);=0A+=0A+#ifnde=
f CONFIG_XEN=0A+__asm__(".pushsection .text, \"ax\", @progbits\n"=0A+	=
".p2align " __stringify(PAGE_SHIFT) "\n"=0A+	"hypercall_page:\n"=0A+	=
".skip 1 << " __stringify(PAGE_SHIFT) "\n"=0A+	".popsection");=0A+#endif=
=0A+=0A+static void xen_spin_lock(volatile struct arch_spinlock *lock,=0A+	=
		  unsigned int token)=0A+{=0A+	arch_rwlock_t *rm_lock;=0A+=
	unsigned long flags;=0A+	unsigned int count;=0A+	struct =
spinning spinning;=0A+=0A+	if (unlikely(percpu_read(runstate.state) =
!=3D RUNSTATE_running))=0A+		xen_set_feature_bits(&__get_cpu_var=
(cpu_info));=0A+=0A+	token >>=3D TICKET_SHIFT;=0A+	spinning.ticket =
=3D token;=0A+	spinning.lock =3D lock;=0A+	spinning.prev =3D =
percpu_read(spinning);=0A+	smp_wmb();=0A+	percpu_write(spinning, =
&spinning);=0A+=0A+	sync_clear_bit(percpu_read(poll_evtchn),=0A+		=
       xen_shared_info->evtchn_pending);=0A+=0A+	for (count =3D =
spin_count; lock->cur !=3D token; )=0A+		if (likely(cpu_online(raw_s=
mp_processor_id()))=0A+		    && (per_cpu(runstate.state, lock->owner=
) !=3D RUNSTATE_running=0A+			|| unlikely(!--count))) =
{=0A+			struct sched_poll sched_poll;=0A+=0A+			=
set_xen_guest_handle(sched_poll.ports,=0A+					=
     &__get_cpu_var(poll_evtchn));=0A+			sched_poll.nr_ports=
 =3D 1;=0A+			sched_poll.timeout =3D 0;=0A+			=
HYPERVISOR_sched_op(SCHEDOP_poll, &sched_poll);=0A+			=
count =3D spin_count;=0A+		} else=0A+			=
cpu_relax();=0A+=0A+	/*=0A+	 * If we interrupted another spinlock =
while it was blocking, make=0A+	 * sure it doesn't block (again) without =
re-checking the lock.=0A+	 */=0A+	if (spinning.prev)=0A+		=
sync_set_bit(percpu_read(poll_evtchn),=0A+			     =
xen_shared_info->evtchn_pending);=0A+=0A+	percpu_write(spinning, =
spinning.prev);=0A+	rm_lock =3D &__get_cpu_var(spinning_rm_lock);=0A+	=
raw_local_irq_save(flags);=0A+	arch_write_lock(rm_lock);=0A+	arch_write_=
unlock(rm_lock);=0A+	raw_local_irq_restore(flags);=0A+}=0A+=0A+static =
void xen_spin_unlock(volatile struct arch_spinlock *lock,=0A+			=
    unsigned int token)=0A+{=0A+	unsigned int cpu;=0A+=0A+	=
token &=3D (1U << TICKET_SHIFT) - 1;=0A+	for_each_online_cpu(cpu) =
{=0A+		arch_rwlock_t *rm_lock;=0A+		unsigned long =
flags;=0A+		struct spinning *spinning;=0A+=0A+		if =
(cpu =3D=3D raw_smp_processor_id())=0A+			continue;=0A+=0A+	=
	rm_lock =3D &per_cpu(spinning_rm_lock, cpu);=0A+		=
raw_local_irq_save(flags);=0A+		arch_read_lock(rm_lock);=0A+=0A+	=
	spinning =3D per_cpu(spinning, cpu);=0A+		smp_rmb();=
=0A+		if (spinning=0A+		    && (spinning->lock =
!=3D lock || spinning->ticket !=3D token))=0A+			spinning =
=3D NULL;=0A+=0A+		arch_read_unlock(rm_lock);=0A+		=
raw_local_irq_restore(flags);=0A+=0A+		if (unlikely(spinning)) =
{=0A+			struct evtchn_send send;=0A+=0A+			=
send.port =3D per_cpu(poll_evtchn, cpu);=0A+			HYPERVISOR_=
event_channel_op(EVTCHNOP_send, &send);=0A+			return;=0A+=
		}=0A+	}=0A+}=0A+=0A+static void __init _prepare_shared_in=
fo_page(void)=0A+{=0A+	struct xen_add_to_physmap xatp;=0A+=0A+	xen_shared_=
info =3D alloc_bootmem_pages(PAGE_SIZE);=0A+=0A+	xatp.domid =3D =
DOMID_SELF;=0A+	xatp.idx =3D 0;=0A+	xatp.space =3D XENMAPSPACE_shared_i=
nfo;=0A+	xatp.gpfn =3D __pa(xen_shared_info) >> PAGE_SHIFT;=0A+	if =
(HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))=0A+		=
BUG();=0A+}=0A+=0A+static void __ref prepare_shared_info_page(void)=0A+{=0A=
+	_prepare_shared_info_page();=0A+}=0A+#endif=0A+=0A+int __cpuinit =
xen_platform(void)=0A+{=0A+	unsigned int first =3D XEN_CPUID_FIRST_LEAF=
;=0A+=0A+#if 0 /* So far, Xen sets this only for PV guests. */=0A+	if =
(!cpu_has_hypervisor)=0A+		return 0;=0A+#endif=0A+=0A+	=
while (first < XEN_CPUID_LEAF(0x10000)) {=0A+		unsigned int eax, =
ebx, ecx, edx;=0A+=0A+		cpuid(first, &eax, &ebx, &ecx, &edx);=0A+	=
	if (ebx =3D=3D XEN_CPUID_SIGNATURE_EBX=0A+		    && ecx =
=3D=3D XEN_CPUID_SIGNATURE_ECX=0A+		    && edx =3D=3D =
XEN_CPUID_SIGNATURE_EDX) {=0A+			if (!smp_processor_id()) =
{=0A+				cpuid(first + 1, &eax, &ebx, &ecx, =
&edx);=0A+				printk(KERN_INFO "Running on Xen =
%u.%u\n",=0A+				       eax >> 16, eax & 0xffff);=0A=
+			}=0A+			return 1;=0A+		=
}=0A+		first +=3D 0x100;=0A+	}=0A+=0A+	return 0;=0A+}=0A+=
=0A+void xen_set_feature_bits(struct cpuinfo_x86 *c)=0A+{=0A+#ifdef =
CONFIG_ENLIGHTEN_SPINLOCKS=0A+	unsigned int msr, eax, ebx, ecx, edx;=0A+	=
unsigned int first =3D XEN_CPUID_FIRST_LEAF;=0A+	int ret;=0A+	=
struct vcpu_register_runstate_memory_area vrrma;=0A+=0A+	if =
(num_possible_cpus() <=3D 1=0A+	    || !spin_count=0A+	    || (c !=3D =
&boot_cpu_data=0A+		&& !boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD=
)))=0A+		return;=0A+=0A+	while (first < XEN_CPUID_LEAF(0x10000)) =
{=0A+		cpuid(first, &eax, &ebx, &ecx, &edx);=0A+		if =
(ebx =3D=3D XEN_CPUID_SIGNATURE_EBX=0A+		    && ecx =3D=3D =
XEN_CPUID_SIGNATURE_ECX=0A+		    && edx =3D=3D XEN_CPUID_SIGNATU=
RE_EDX)=0A+			break;=0A+		first +=3D =
0x100;=0A+	}=0A+	BUG_ON(first >=3D XEN_CPUID_LEAF(0x10000));=0A+=0A+=
	cpuid(first + 2, &eax, &msr, &ecx, &edx);=0A+	BUG_ON(!eax);=0A+	=
wrmsrl(msr, __pa_symbol(hypercall_page));=0A+=0A+	if (!xen_shared_inf=
o)=0A+		prepare_shared_info_page();=0A+=0A+	memset(&vrrma, 0, =
sizeof(vrrma));=0A+	set_xen_guest_handle(vrrma.addr.h, &__get_cpu_var(r=
unstate));=0A+	ret =3D HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_=
area,=0A+				 c->cpu_index, &vrrma);=0A+	if =
(ret) {=0A+		printk(KERN_WARNING=0A+		       "Could not =
register runstate area for CPU%u: %d\n",=0A+		       c->cpu_index=
, ret);=0A+		BUG_ON(boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD));=
=0A+		return;=0A+	}=0A+=0A+	if (c !=3D &boot_cpu_data =
|| !percpu_read(poll_evtchn)) {=0A+		struct evtchn_bind_ipi =
bind_ipi;=0A+=0A+		bind_ipi.vcpu =3D c->cpu_index;=0A+		=
ret =3D HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,=0A+			=
			  &bind_ipi);=0A+		if (ret) {=0A+		=
	printk(KERN_WARNING=0A+			       "Could not bind =
event channel for CPU%u: %d\n",=0A+			       c->cpu_index=
, ret);=0A+			BUG_ON(boot_cpu_has(X86_FEATURE_SPINLOCK_YI=
ELD));=0A+			return;=0A+		}=0A+		=
sync_set_bit(bind_ipi.port, xen_shared_info->evtchn_mask);=0A+		=
percpu_write(poll_evtchn, bind_ipi.port);=0A+		printk(KERN_INFO =
"CPU%u spinlock poll event channel: %u\n",=0A+		       c->cpu_index=
, bind_ipi.port);=0A+	}=0A+=0A+	virt_spin_lock =3D xen_spin_lock;=
=0A+	virt_spin_unlock =3D xen_spin_unlock;=0A+	set_cpu_cap(c, =
X86_FEATURE_SPINLOCK_YIELD);=0A+#endif=0A+}=0A
--=__Part49636D9D.3__=
Content-Type: text/plain; name="linux-2.6.33-rc5-virt-spinlocks-base.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-2.6.33-rc5-virt-spinlocks-base.patch"

Add optional (alternative instructions based) callout hooks to the=0Aconten=
ded ticket lock and the ticket unlock paths, to allow hypervisor=0Aspecific=
 code to be used for reducing/eliminating the bad effects=0Aticket locks =
have on performance when running virtualized.=0A=0AThe only additional =
overhead this introduces for native execution is=0Athe writing of the =
owning CPU in the lock acquire paths, and a nop in=0Athe release paths. If =
the former is considered a problem, even that=0Acode could be eliminated =
for native execution (by further alternative=0Ainstruction patching). For =
the latter, if considered undesirable, a=0Asubsequent (optional) patch =
will eliminate those nop-s again.=0A=0AFor the moment, this isn't intended =
to be used together with pv-ops,=0Abut this is just to simplify initial =
integration. The ultimate goal=0Afor this should still be to replace =
pv-ops spinlocks.=0A=0AThis requires adjustments to the alternative =
instruction patching,=0Asince locked instructions may now both get patched =
out and reside in=0Areplacement code.=0A=0ASigned-off-by: Jan Beulich =
<jbeulich@novell.com>=0ACc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix=
.com>=0A=0A---=0A arch/x86/Kconfig                      |    8 +=0A =
arch/x86/include/asm/alternative.h    |   17 +--=0A arch/x86/include/asm/cp=
ufeature.h     |    1 =0A arch/x86/include/asm/spinlock.h       |  188 =
++++++++++++++++++++++++++++++++--=0A arch/x86/include/asm/spinlock_types.h=
 |   22 +++=0A arch/x86/kernel/alternative.c         |   30 +++++=0A =
arch/x86/kernel/cpu/hypervisor.c      |    9 +=0A arch/x86/kernel/module.c =
             |    8 -=0A arch/x86/lib/thunk_32.S               |   31 =
+++++=0A arch/x86/lib/thunk_64.S               |   54 +++++++++=0A 10 =
files changed, 346 insertions(+), 22 deletions(-)=0A=0A--- 2.6.33-rc5-virt-=
spinlocks.orig/arch/x86/Kconfig=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/Kc=
onfig=0A@@ -568,6 +568,14 @@ config PARAVIRT_DEBUG=0A 	  Enable to debug =
paravirt_ops internals.  Specifically, BUG if=0A 	  a paravirt_op is =
missing when it is called.=0A =0A+config ENLIGHTEN_SPINLOCKS=0A+	=
bool "enlighten spinlocks"=0A+	depends on SMP && !PARAVIRT_GUEST=0A+	=
help=0A+	  Provide a mechanism for enlightening (para-virtualizing) =
spin locks=0A+	  in the absence of full pv-ops support (i.e. for "fully" =
virtualized=0A+	  guests).=0A+=0A config MEMTEST=0A 	bool "Memtest"=0A 	=
---help---=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/altern=
ative.h=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/alternative.h=
=0A@@ -29,11 +29,11 @@=0A =0A #ifdef CONFIG_SMP=0A #define LOCK_PREFIX =
\=0A-		".section .smp_locks,\"a\"\n"	\=0A+		".pushsecti=
on .smp_locks,\"a\"\n" \=0A 		_ASM_ALIGN "\n"			=
\=0A-		_ASM_PTR "661f\n" /* address */	\=0A-		".previous\=
n"			\=0A-		"661:\n\tlock; "=0A+		=
_ASM_PTR "669f\n" /* address */	\=0A+		".popsection\n"			=
\=0A+		"669:\n\tlock; "=0A =0A #else /* ! CONFIG_SMP */=0A =
#define LOCK_PREFIX ""=0A@@ -55,7 +55,12 @@ struct alt_instr {=0A };=0A =
=0A extern void alternative_instructions(void);=0A-extern void apply_altern=
atives(struct alt_instr *start, struct alt_instr *end);=0A+#ifndef =
CONFIG_SMP=0A+#define apply_alternatives(alt_start, alt_end, smp_start, =
smp_end) \=0A+	apply_alternatives(alt_start, alt_end)=0A+#endif=0A+extern =
void apply_alternatives(struct alt_instr *start, struct alt_instr =
*end,=0A+			       u8 **smp_start, u8 **smp_end);=0A =
=0A struct module;=0A =0A@@ -129,7 +134,7 @@ static inline void alternative=
s_smp_swit=0A  * use this macro(s) if you need more than one output =
parameter=0A  * in alternative_io=0A  */=0A-#define ASM_OUTPUT2(a, b) a, =
b=0A+#define ASM_OUTPUT2(a...) a=0A =0A struct paravirt_patch_site;=0A =
#ifdef CONFIG_PARAVIRT=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/includ=
e/asm/cpufeature.h=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/cpu=
feature.h=0A@@ -97,6 +97,7 @@=0A #define X86_FEATURE_EXTD_APICID	=
(3*32+26) /* has extended APICID (8 bits) */=0A #define X86_FEATURE_AMD_DCM=
     (3*32+27) /* multi-node processor */=0A #define X86_FEATURE_APERFMPERF=
	(3*32+28) /* APERFMPERF */=0A+#define X86_FEATURE_SPINLOCK_YIELD =
(3*32+31) /* hypervisor yield interface */=0A =0A /* Intel-defined CPU =
features, CPUID level 0x00000001 (ecx), word 4 */=0A #define X86_FEATURE_XM=
M3	(4*32+ 0) /* "pni" SSE-3 */=0A--- 2.6.33-rc5-virt-spinlocks.orig/ar=
ch/x86/include/asm/spinlock.h=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/incl=
ude/asm/spinlock.h=0A@@ -7,6 +7,20 @@=0A #include <asm/processor.h>=0A =
#include <linux/compiler.h>=0A #include <asm/paravirt.h>=0A+=0A+#ifdef =
CONFIG_ENLIGHTEN_SPINLOCKS=0A+#include <asm/alternative.h>=0A+#include =
<asm/nops.h>=0A+/* Including asm/smp.h here causes a cyclic include =
dependency. */=0A+#include <asm/percpu.h>=0A+DECLARE_PER_CPU(int, =
cpu_number);=0A+=0A+extern void (*virt_spin_lock)(volatile struct =
arch_spinlock *, unsigned int);=0A+extern void (*virt_spin_unlock)(volatile=
 struct arch_spinlock *, unsigned int);=0A+extern void virt_spin_lock_stub(=
void);=0A+extern void virt_spin_unlock_stub(void);=0A+#endif=0A+=0A /*=0A  =
* Your basic SMP spinlocks, allowing only a single CPU anywhere=0A  *=0A@@ =
-22,9 +36,11 @@=0A #ifdef CONFIG_X86_32=0A # define LOCK_PTR_REG "a"=0A # =
define REG_PTR_MODE "k"=0A+# define REG_PTR_PREFIX "e"=0A #else=0A # =
define LOCK_PTR_REG "D"=0A # define REG_PTR_MODE "q"=0A+# define REG_PTR_PR=
EFIX "r"=0A #endif=0A =0A #if defined(CONFIG_X86_32) && \=0A@@ -62,19 =
+78,54 @@ static __always_inline void __ticket_spi=0A {=0A 	short inc =
=3D 0x0100;=0A =0A+#ifndef CONFIG_ENLIGHTEN_SPINLOCKS=0A 	asm =
volatile (=0A+#else=0A+	alternative_io(=0A+		".L%=3Dorig:\n\t"=
=0A+#endif=0A 		LOCK_PREFIX "xaddw %w0, %1\n"=0A 		=
"1:\t"=0A 		"cmpb %h0, %b0\n\t"=0A-		"je 2f\n\t"=0A+		=
"je .L%=3Ddone\n\t"=0A 		"rep ; nop\n\t"=0A 		"movb %1, =
%b0\n\t"=0A 		/* don't need lfence here, because loads are =
in-order */=0A 		"jmp 1b\n"=0A-		"2:"=0A-		: =
"+Q" (inc), "+m" (lock->slock)=0A+		".L%=3Ddone:"=0A+#ifndef =
CONFIG_ENLIGHTEN_SPINLOCKS=0A 		:=0A+#else=0A+		, =
".L%=3Dalt:\n\t"=0A+		  /* Prevent using rip-relative addressing =
here. */=0A+		  LOCK_PREFIX "xaddw %w0, %P1\n\t"=0A+		  =
"cmpb %h0, %b0\n\t"=0A+		  /* jne .L%=3Dcallout */=0A+		  =
".byte 0x0f, 0x85\n\t"=0A+		  ".long (.L%=3Dcallout - =
.L%=3Dorig) - (. + 4 - .L%=3Dalt)\n"=0A+		  ".previous\n"=0A+=
		  ".subsection 1\n"=0A+		  ".L%=3Dcallout:\n\t"=0A+	=
	  "push $.L%=3Ddone\n\t"=0A+		  "push %%" REG_PTR_PREFIX =
"bp\n\t"=0A+		  "push %" REG_PTR_MODE "0\n\t"=0A+		  =
"lea %1, %%" REG_PTR_PREFIX "bp\n\t"=0A+		  "call %P[stub]\n\=
t"=0A+		  ".subsection 0\n\t"=0A+		  ".section =
.altinstr_replacement",=0A+		X86_FEATURE_SPINLOCK_YIELD,=0A+#end=
if=0A+		ASM_OUTPUT2("+Q" (inc), "+m" (lock->slock))=0A+#ifndef =
CONFIG_ENLIGHTEN_SPINLOCKS=0A+		:=0A+#else=0A+		, [stub] =
"i" (virt_spin_lock_stub)=0A+#endif=0A 		: "memory", "cc");=0A+=0A+#=
ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A+	lock->owner =3D percpu_read(cpu_num=
ber);=0A+#endif=0A }=0A =0A static __always_inline int __ticket_spin_tryloc=
k(arch_spinlock_t *lock)=0A@@ -93,14 +144,54 @@ static __always_inline int =
__ticket_spin=0A 		     :=0A 		     : "memory", =
"cc");=0A =0A+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A+	if (tmp)=0A+		=
lock->owner =3D percpu_read(cpu_number);=0A+#endif=0A+=0A 	return =
tmp;=0A }=0A =0A static __always_inline void __ticket_spin_unlock(arch_spin=
lock_t *lock)=0A {=0A-	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"=0A+#ifnde=
f CONFIG_ENLIGHTEN_SPINLOCKS=0A+	asm volatile(=0A+#else=0A+	=
unsigned int token;=0A+=0A+	alternative_io(=0A+		     =
".L%=3Dorig:\n\t"=0A+#endif=0A+		     UNLOCK_LOCK_PREFIX "incb =
%0"=0A+#ifndef CONFIG_ENLIGHTEN_SPINLOCKS=0A 		     : "+m" =
(lock->slock)=0A 		     :=0A+#else=0A+		     =
"\n\t"=0A+		     ASM_NOP3=0A+		     ".L%=3Ddone:",=
=0A+		     ".L%=3Dalt:\n\t"=0A+		     /* jmp =
.L%=3Dcallout */=0A+		     ".byte 0xe9\n\t"=0A+		   =
  ".long (.L%=3Dcallout - .L%=3Dorig) - (. + 4 - .L%=3Dalt)\n\t"=0A+		=
     ".previous\n\t"=0A+		     ".subsection 1\n"=0A+		=
     ".L%=3Dcallout:\n\t"=0A+		     UNLOCK_LOCK_PREFIX "incb =
%0\n\t"=0A+		     "movzwl %0, %1\n\t"=0A+		     "cmpb =
%h1, %b1\n\t"=0A+		     "je .L%=3Ddone\n\t"=0A+		   =
  "push $.L%=3Ddone\n\t"=0A+		     "push %%" REG_PTR_PREFIX =
"bp\n\t"=0A+		     "push %" REG_PTR_MODE "1\n\t"=0A+		   =
  "lea %0, %%" REG_PTR_PREFIX "bp\n\t"=0A+		     "call =
%P[stub]\n\t"=0A+		     ".subsection 0\n\t"=0A+		   =
  ".section .altinstr_replacement",=0A+		     X86_FEATURE_SPINLOCK_Y=
IELD,=0A+		     ASM_OUTPUT2("+m" (lock->slock), "=3D&Q" =
(token)),=0A+		     [stub] "i" (virt_spin_unlock_stub)=0A+#endif=
=0A 		     : "memory", "cc");=0A }=0A #else=0A@@ -111,20 +202,58 =
@@ static __always_inline void __ticket_spi=0A 	int inc =3D 0x00010000;=0A =
	int tmp;=0A =0A-	asm volatile(LOCK_PREFIX "xaddl %0, =
%1\n"=0A+#ifndef CONFIG_ENLIGHTEN_SPINLOCKS=0A+	asm volatile(=0A+#else=0A+	=
alternative_io(=0A+		     ".L%=3Dorig:\n\t"=0A+#endif=0A+		=
     LOCK_PREFIX "xaddl %0, %1\n"=0A 		     "movzwl %w0, =
%2\n\t"=0A 		     "shrl $16, %0\n\t"=0A 		     =
"1:\t"=0A 		     "cmpl %0, %2\n\t"=0A-		     "je =
2f\n\t"=0A+		     "je .L%=3Ddone\n\t"=0A 		     "rep =
; nop\n\t"=0A 		     "movzwl %1, %2\n\t"=0A 		     /* =
don't need lfence here, because loads are in-order */=0A 		   =
  "jmp 1b\n"=0A-		     "2:"=0A-		     : "+r" (inc), =
"+m" (lock->slock), "=3D&r" (tmp)=0A+		     ".L%=3Ddone:"=0A+#ifnd=
ef CONFIG_ENLIGHTEN_SPINLOCKS=0A 		     :=0A+#else=0A+		=
     , ".L%=3Dalt:\n\t"=0A+		       /* Prevent using rip-relativ=
e addressing here. */=0A+		       LOCK_PREFIX "xaddl %0, =
%P1\n\t"=0A+		       "movzwl %w0, %2\n\t"=0A+		       =
"shrl $16, %0\n\t"=0A+		       "cmpl %0, %2\n\t"=0A+		   =
    /* jne .L%=3Dcallout */=0A+		       ".byte 0x0f, 0x85\n\t"=0A+	=
	       ".long (.L%=3Dcallout - .L%=3Dorig) - (. + 4 - .L%=3Dalt)\n"=
=0A+		       ".previous\n"=0A+		       ".subsection=
 1\n"=0A+		       ".L%=3Dcallout:\n\t"=0A+		       =
"push $.L%=3Ddone\n\t"=0A+		       "push %%" REG_PTR_PREFIX =
"bp\n\t"=0A+		       "push %" REG_PTR_MODE "0\n\t"=0A+		=
       "lea %1, %%" REG_PTR_PREFIX "bp\n\t"=0A+		       "call =
%P[stub]\n\t"=0A+		       ".subsection 0\n\t"=0A+		   =
    ".section .altinstr_replacement",=0A+		     X86_FEATURE_SP=
INLOCK_YIELD,=0A+#endif=0A+		     ASM_OUTPUT2("+r" (inc), "+m" =
(lock->slock), "=3D&r" (tmp))=0A+#ifndef CONFIG_ENLIGHTEN_SPINLOCKS=0A+		=
     :=0A+#else=0A+		     , [stub] "i" (virt_spin_lock_stub)=0A+=
#endif=0A 		     : "memory", "cc");=0A+=0A+#ifdef CONFIG_ENLIGH=
TEN_SPINLOCKS=0A+	lock->owner =3D percpu_read(cpu_number);=0A+#endif=
=0A }=0A =0A static __always_inline int __ticket_spin_trylock(arch_spinlock=
_t *lock)=0A@@ -146,14 +275,55 @@ static __always_inline int __ticket_spin=
=0A 		     :=0A 		     : "memory", "cc");=0A =
=0A+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A+	if (tmp)=0A+		=
lock->owner =3D percpu_read(cpu_number);=0A+#endif=0A+=0A 	return =
tmp;=0A }=0A =0A static __always_inline void __ticket_spin_unlock(arch_spin=
lock_t *lock)=0A {=0A-	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"=0A+#ifnde=
f CONFIG_ENLIGHTEN_SPINLOCKS=0A+	asm volatile(=0A+#else=0A+	=
unsigned int token, tmp;=0A+=0A+	alternative_io(=0A+		   =
  ".L%=3Dorig:\n\t"=0A+#endif=0A+		     UNLOCK_LOCK_PREFIX =
"incw %0"=0A+#ifndef CONFIG_ENLIGHTEN_SPINLOCKS=0A 		     : =
"+m" (lock->slock)=0A 		     :=0A+#else=0A+		     =
"\n\t"=0A+		     ASM_NOP2=0A+		     ".L%=3Ddone:",=
=0A+		     ".L%=3Dalt:\n\t"=0A+		     /* jmp =
.L%=3Dcallout */=0A+		     ".byte 0xe9\n\t"=0A+		   =
  ".long (.L%=3Dcallout - .L%=3Dorig) - (. + 4 - .L%=3Dalt)\n\t"=0A+		=
     ".previous\n\t"=0A+		     ".subsection 1\n"=0A+		=
     ".L%=3Dcallout:\n\t"=0A+		     UNLOCK_LOCK_PREFIX "incw =
%0\n\t"=0A+		     "movl %0, %1\n\t"=0A+		     =
"shldl $16, %1, %2\n\t"=0A+		     "cmpw %w2, %w1\n\t"=0A+		=
     "je .L%=3Ddone\n\t"=0A+		     "push $.L%=3Ddone\n\t"=0A+		=
     "push %%" REG_PTR_PREFIX "bp\n\t"=0A+		     "push %" =
REG_PTR_MODE "1\n\t"=0A+		     "lea %0, %%" REG_PTR_PREFIX =
"bp\n\t"=0A+		     "call %P[stub]\n\t"=0A+		     =
".subsection 0\n\t"=0A+		     ".section .altinstr_replacement",=0A+	=
	     X86_FEATURE_SPINLOCK_YIELD,=0A+		     ASM_OUTPUT2("+=
m" (lock->slock), "=3D&r" (token), "=3D&r" (tmp)),=0A+		     =
[stub] "i" (virt_spin_unlock_stub)=0A+#endif=0A 		     : =
"memory", "cc");=0A }=0A #endif=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/x=
86/include/asm/spinlock_types.h=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/in=
clude/asm/spinlock_types.h=0A@@ -5,11 +5,29 @@=0A # error "please don't =
include this file directly"=0A #endif=0A =0A+#include <asm/types.h>=0A+=0A =
typedef struct arch_spinlock {=0A-	unsigned int slock;=0A+	union =
{=0A+		unsigned int slock;=0A+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A=
+		struct {=0A+# if CONFIG_NR_CPUS < 256=0A+			=
u8 cur, seq;=0A+# else=0A+			u16 cur, seq;=0A+# =
endif=0A+# if CONFIG_NR_CPUS <=3D 256=0A+			u8 =
owner;=0A+# else=0A+			u16 owner;=0A+# endif=0A+		=
};=0A+#endif=0A+	};=0A } arch_spinlock_t;=0A =0A-#define __ARCH_SPIN=
_LOCK_UNLOCKED	{ 0 }=0A+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } =
}=0A =0A typedef struct {=0A 	unsigned int lock;=0A--- 2.6.33-rc5-virt-sp=
inlocks.orig/arch/x86/kernel/alternative.c=0A+++ 2.6.33-rc5-virt-spinlocks/=
arch/x86/kernel/alternative.c=0A@@ -202,7 +202,8 @@ static void *text_poke_=
early(void *addr,=0A    Tough. Make sure you disable such features by =
hand. */=0A =0A void __init_or_module apply_alternatives(struct alt_instr =
*start,=0A-					 struct alt_instr =
*end)=0A+					 struct alt_instr =
*end,=0A+					 u8 **smp_start, u8 =
**smp_end)=0A {=0A 	struct alt_instr *a;=0A 	char insnbuf[MAX_PA=
TCH_LEN];=0A@@ -226,6 +227,30 @@ void __init_or_module apply_alternatives=
=0A 		add_nops(insnbuf + a->replacementlen,=0A 			=
 a->instrlen - a->replacementlen);=0A 		text_poke_early(instr, =
insnbuf, a->instrlen);=0A+=0A+#ifdef CONFIG_SMP=0A+		/*=0A+		=
 * Must fix up SMP locks pointers pointing into overwritten=0A+		 * =
code, and should fix up SMP locks pointers pointing into=0A+		 * =
replacement code (as those would otherwise not take effect).=0A+		=
 */=0A+		if (smp_start) {=0A+			u8 **ptr;=0A+=0A+	=
		for (ptr =3D smp_start; ptr < smp_end; ptr++) {=0A+		=
		if (*ptr >=3D instr && *ptr < instr + a->instrlen) {=0A+	=
				DPRINTK("invalidating smp lock @ %p\n", =
*ptr);=0A+					*ptr =3D NULL;=0A+		=
		}=0A+				if (*ptr >=3D a->replacemen=
t=0A+				    && *ptr < a->replacement + a->replaceme=
ntlen) {=0A+					DPRINTK("relocating smp =
lock %p -> %p\n",=0A+						*ptr, *ptr =
+ (instr - a->replacement));=0A+					=
*ptr +=3D instr - a->replacement;=0A+				}=0A+		=
	}=0A+		}=0A+#endif=0A 	}=0A }=0A =0A@@ -440,7 +465,8 @@ =
void __init alternative_instructions(voi=0A 	 * patching.=0A 	 =
*/=0A =0A-	apply_alternatives(__alt_instructions, __alt_instructions_e=
nd);=0A+	apply_alternatives(__alt_instructions, __alt_instructions_e=
nd,=0A+			   __smp_locks, __smp_locks_end);=0A =0A 	/* =
switch to patch-once-at-boottime-only mode and free the=0A 	 * tables =
in case we know the number of CPUs will never ever=0A--- 2.6.33-rc5-virt-sp=
inlocks.orig/arch/x86/kernel/cpu/hypervisor.c=0A+++ 2.6.33-rc5-virt-spinloc=
ks/arch/x86/kernel/cpu/hypervisor.c=0A@@ -25,6 +25,15 @@=0A #include =
<asm/vmware.h>=0A #include <asm/hypervisor.h>=0A =0A+#ifdef CONFIG_ENLIGHTE=
N_SPINLOCKS=0A+#include <linux/cache.h>=0A+#include <linux/module.h>=0A+#in=
clude <linux/spinlock.h>=0A+void (*__read_mostly virt_spin_lock)(volatile =
struct arch_spinlock *, unsigned int);=0A+void (*__read_mostly virt_spin_un=
lock)(volatile struct arch_spinlock *, unsigned int);=0A+EXPORT_SYMBOL(virt=
_spin_unlock_stub);=0A+#endif=0A+=0A static inline void __cpuinit=0A =
detect_hypervisor_vendor(struct cpuinfo_x86 *c)=0A {=0A--- 2.6.33-rc5-virt-=
spinlocks.orig/arch/x86/kernel/module.c=0A+++ 2.6.33-rc5-virt-spinlocks/arc=
h/x86/kernel/module.c=0A@@ -208,6 +208,7 @@ int module_finalize(const =
Elf_Ehdr *hdr,=0A 	const Elf_Shdr *s, *text =3D NULL, *alt =3D NULL, =
*locks =3D NULL,=0A 		*para =3D NULL;=0A 	char *secstrings =
=3D (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;=0A+	void =
*lseg;=0A =0A 	for (s =3D sechdrs; s < sechdrs + hdr->e_shnum; s++) {=0A 	=
	if (!strcmp(".text", secstrings + s->sh_name))=0A@@ -220,13 =
+221,14 @@ int module_finalize(const Elf_Ehdr *hdr,=0A 			=
para =3D s;=0A 	}=0A =0A+	lseg =3D locks && text ? (void *)locks->sh_=
addr : NULL;=0A 	if (alt) {=0A 		/* patch .altinstructions =
*/=0A 		void *aseg =3D (void *)alt->sh_addr;=0A-		=
apply_alternatives(aseg, aseg + alt->sh_size);=0A+		apply_alter=
natives(aseg, aseg + alt->sh_size,=0A+				   lseg, =
lseg ? lseg + locks->sh_size : NULL);=0A 	}=0A-	if (locks && text) =
{=0A-		void *lseg =3D (void *)locks->sh_addr;=0A+	if (lseg) =
{=0A 		void *tseg =3D (void *)text->sh_addr;=0A 		=
alternatives_smp_module_add(me, me->name,=0A 					=
    lseg, lseg + locks->sh_size,=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/=
x86/lib/thunk_32.S=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/lib/thunk_32.S=
=0A@@ -45,3 +45,34 @@=0A 	thunk_ra trace_hardirqs_on_thunk,trace_hard=
irqs_on_caller=0A 	thunk_ra trace_hardirqs_off_thunk,trace_hardirqs_of=
f_caller=0A #endif=0A+=0A+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A+#include =
<asm/dwarf2.h>=0A+	.macro virt_spin_stub what, _stub=3D_stub=0A+ENTRY(=
virt_spin_\what\_stub)=0A+	CFI_STARTPROC simple=0A+	CFI_DEF_CFA=
 esp, 16=0A+	CFI_OFFSET eip, -4=0A+	CFI_OFFSET ebp, -8=0A+	movl	=
%edx, (%esp)			# don't need this return address=0A+	=
movl	4(%esp), %edx			# token=0A+	movl	%eax, =
4(%esp)=0A+	movl	%ebp, %eax			# lock pointer=0A+	=
movl	8(%esp), %ebp=0A+	CFI_RESTORE ebp=0A+	movl	%ecx, =
8(%esp)=0A+	call	*virt_spin_\what=0A+	popl	%edx=0A+	=
CFI_ADJUST_CFA_OFFSET -4=0A+	popl	%eax=0A+	CFI_ADJUST_CFA_OFFS=
ET -4=0A+	popl	%ecx=0A+	CFI_ADJUST_CFA_OFFSET -4=0A+	=
ret=0A+	CFI_ENDPROC=0A+ENDPROC(virt_spin_\what\_stub)=0A+	.endm=0A+vi=
rt_spin_stub lock=0A+virt_spin_stub unlock=0A+	.purgem virt_spin_stub=0A+#=
endif=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/lib/thunk_64.S=0A+++ =
2.6.33-rc5-virt-spinlocks/arch/x86/lib/thunk_64.S=0A@@ -79,3 +79,57 @@ =
restore_norax:	=0A 	RESTORE_ARGS 1=0A 	ret=0A 	CFI_ENDPROC=0A+=0A+=
#ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A+	.text=0A+	.macro virt_spin_st=
ub what, _stub=3D_stub=0A+ENTRY(virt_spin_\what\_stub)=0A+	CFI_STARTPR=
OC simple=0A+	CFI_DEF_CFA rsp, 32=0A+	CFI_OFFSET rip, -8=0A+	CFI_OFFSET =
rbp, -16=0A+	movq	%rsi, (%rsp)			# don't need this =
return address=0A+	movl	8(%rsp), %esi			# =
token=0A+	movq	%rdi, 8(%rsp)=0A+	movq	%rbp, %rdi		=
	# lock pointer=0A+	movq	16(%rsp), %rbp=0A+	movq	=
%rax, 16(%rsp)=0A+	pushq	%rcx=0A+	CFI_ADJUST_CFA_OFFSET =
8=0A+	pushq	%rdx=0A+	CFI_ADJUST_CFA_OFFSET 8=0A+	pushq	=
%r8=0A+	CFI_ADJUST_CFA_OFFSET 8=0A+	pushq	%r9=0A+	CFI_ADJUST_CFA_OFFS=
ET 8=0A+	pushq	%r10=0A+	CFI_ADJUST_CFA_OFFSET 8=0A+	=
pushq	%r11=0A+	CFI_ADJUST_CFA_OFFSET 8=0A+	call	*virt_spin_=
\what(%rip)=0A+	popq	%r11=0A+	CFI_ADJUST_CFA_OFFSET -8=0A+	=
popq	%r10=0A+	CFI_ADJUST_CFA_OFFSET -8=0A+	popq	%r9=0A+	=
CFI_ADJUST_CFA_OFFSET -8=0A+	popq	%r8=0A+	CFI_ADJUST_CFA_OFFSET =
-8=0A+	popq	%rdx=0A+	CFI_ADJUST_CFA_OFFSET -8=0A+	popq	=
%rcx=0A+	CFI_ADJUST_CFA_OFFSET -8=0A+	popq	%rsi=0A+	=
CFI_ADJUST_CFA_OFFSET -8=0A+	popq	%rdi=0A+	CFI_ADJUST_CFA_OFFS=
ET -8=0A+	popq	%rax=0A+	CFI_ADJUST_CFA_OFFSET -8=0A+	=
ret=0A+	CFI_ENDPROC=0A+ENDPROC(virt_spin_\what\_stub)=0A+	.endm=0A+vi=
rt_spin_stub lock=0A+virt_spin_stub unlock=0A+	.purgem virt_spin_stub=0A+#=
endif=0A
--=__Part49636D9D.3__=
Content-Type: text/plain; name="linux-2.6.33-rc5-virt-spinlocks-no-nop.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-2.6.33-rc5-virt-spinlocks-no-nop.patch"

Under the assumption that the nop-s added by the base ticket spinlock=0Aenl=
ightenment patch might be considered undesirable (or worse), here=0Ais an =
optional patch to eliminate these nop-s again. This is done=0Athrough =
extending the memory operands of the inc instructions used for=0Aunlocking =
ticket locks to the necessary size, using assembler and=0Alinker =
features.=0A=0ASigned-off-by: Jan Beulich <jbeulich@novell.com>=0ACc: =
Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>=0A=0A---=0A arch/x86/M=
akefile                      |    3 +=0A arch/x86/include/asm/alternative-a=
sm.h |   59 +++++++++++++++++++++++++++++++++=0A arch/x86/include/asm/alter=
native.h     |    5 ++=0A arch/x86/include/asm/spinlock.h        |   27 =
++++-----------=0A arch/x86/kernel/symdefs.lds            |    1 =0A =
arch/x86/kernel/vmlinux.lds.S          |    2 +=0A 6 files changed, 78 =
insertions(+), 19 deletions(-)=0A=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch=
/x86/Makefile=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/Makefile=0A@@ -87,6 =
+87,9 @@ ifeq ($(CONFIG_KMEMCHECK),y)=0A 	KBUILD_CFLAGS +=3D $(call =
cc-option,-fno-builtin-memcpy)=0A endif=0A =0A+KBUILD_CFLAGS +=3D =
-Wa,-I$(srctree)/arch/x86/include=0A+LDFLAGS_MODULE +=3D -T $(srctree)/arch=
/x86/kernel/symdefs.lds=0A+=0A # Stackpointer is addressed different for =
32 bit and 64 bit x86=0A sp-$(CONFIG_X86_32) :=3D esp=0A sp-$(CONFIG_X86_64=
) :=3D rsp=0A--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/altern=
ative.h=0A+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/alternative.h=
=0A@@ -6,6 +6,11 @@=0A #include <linux/stringify.h>=0A #include <asm/asm.h>=
=0A =0A+#if !defined(__ASSEMBLY__) && !defined(__PIC__)=0A+#include =
<asm/alternative-asm.h> /* just for tracking the build dependency =
*/=0A+__asm__(".include \"asm/alternative-asm.h\"");=0A+#endif=0A+=0A =
/*=0A  * Alternative inline assembly for SMP.=0A  *=0A--- 2.6.33-rc5-virt-s=
pinlocks.orig/arch/x86/include/asm/alternative-asm.h=0A+++ 2.6.33-rc5-virt-=
spinlocks/arch/x86/include/asm/alternative-asm.h=0A@@ -1,3 +1,7 @@=0A+#if =
0 /* Hide this from compiler. */=0A+	.if 0 # Hide assembly source stuff =
when assembling compiler output.=0A+#endif=0A+=0A #ifdef __ASSEMBLY__=0A =
=0A #include <asm/asm.h>=0A@@ -16,3 +20,58 @@=0A #endif=0A =0A #endif  /*  =
__ASSEMBLY__  */=0A+=0A+#if 0 /* Hide this from compiler. */=0A+	=
.else # Code to be used in compiler output:=0A+=0A+	.weak _$.zero=0A+=
=0A+	.macro unary opc arg1 arg2 arg3=0A+	 .Lempty=3D2=0A+	 =
.irpc c,"\arg2"=0A+	  .Lempty=3D3=0A+	 .endr=0A+	 .irpc =
c,"\arg3"=0A+	  .Lempty=3D0=0A+	 .endr=0A+	 .Lsym=3D1=0A+	 =
.Lnum=3D0=0A+	 .irpc c,"\arg1"=0A+	  .irpc m,"(123456789-0"=0A+	   =
.ifeqs "\c","\m"=0A+	    .Lsym=3D0=0A+	    .exitm=0A+	   =
.endif=0A+	   .Lnum=3D1=0A+	  .endr=0A+	  .exitm=0A+	 =
.endr=0A+	 .if .Lempty =3D=3D 2=0A+	  .if .Lsym=0A+	   \opc =
\arg1=0A+	  .elseif .Lnum=0A+	   \opc _$.zero+\arg1=0A+	  =
.else=0A+	   \opc _$.zero\arg1=0A+	  .endif=0A+	 .elseif =
.Lempty =3D=3D 3=0A+	  .if .Lsym=0A+	   \opc \arg1,\arg2=0A+	  .elseif =
.Lnum=0A+	   \opc _$.zero+\arg1,\arg2=0A+	  .else=0A+	   \opc =
_$.zero\arg1,\arg2=0A+	  .endif=0A+	 .else=0A+	  .if .Lsym=0A+	   =
\opc \arg1,\arg2,\arg3=0A+	  .elseif .Lnum=0A+	   \opc _$.zero+\ar=
g1,\arg2,\arg3=0A+	  .else=0A+	   \opc _$.zero\arg1,\arg2,\arg3=0A=
+	  .endif=0A+	 .endif=0A+	.endm=0A+=0A+	.endif=0A+#endif=0A=
--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/spinlock.h=0A+++ =
2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/spinlock.h=0A@@ -10,7 +10,6 =
@@=0A =0A #ifdef CONFIG_ENLIGHTEN_SPINLOCKS=0A #include <asm/alternative.h>=
=0A-#include <asm/nops.h>=0A /* Including asm/smp.h here causes a cyclic =
include dependency. */=0A #include <asm/percpu.h>=0A DECLARE_PER_CPU(int, =
cpu_number);=0A@@ -155,20 +154,15 @@ static __always_inline int __ticket_sp=
in=0A static __always_inline void __ticket_spin_unlock(arch_spinlock_t =
*lock)=0A {=0A #ifndef CONFIG_ENLIGHTEN_SPINLOCKS=0A-	asm volatile(=0A+	=
asm volatile(UNLOCK_LOCK_PREFIX "incb %0"=0A+		     : "+m" =
(lock->slock)=0A+		     :=0A #else=0A 	unsigned int =
token;=0A =0A 	alternative_io(=0A 		     ".L%=3Dorig:\n\t"=0A-#=
endif=0A-		     UNLOCK_LOCK_PREFIX "incb %0"=0A-#ifndef =
CONFIG_ENLIGHTEN_SPINLOCKS=0A-		     : "+m" (lock->slock)=0A-		=
     :=0A-#else=0A-		     "\n\t"=0A-		     ASM_NOP3=0A+	=
	     UNLOCK_LOCK_PREFIX "unary incb %0\n\t"=0A 		     =
".L%=3Ddone:",=0A 		     ".L%=3Dalt:\n\t"=0A 		   =
  /* jmp .L%=3Dcallout */=0A@@ -286,20 +280,15 @@ static __always_inline =
int __ticket_spin=0A static __always_inline void __ticket_spin_unlock(arch_=
spinlock_t *lock)=0A {=0A #ifndef CONFIG_ENLIGHTEN_SPINLOCKS=0A-	=
asm volatile(=0A+	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"=0A+		=
     : "+m" (lock->slock)=0A+		     :=0A #else=0A 	unsigned =
int token, tmp;=0A =0A 	alternative_io(=0A 		     ".L%=3Dorig:\n=
\t"=0A-#endif=0A-		     UNLOCK_LOCK_PREFIX "incw %0"=0A-#ifnde=
f CONFIG_ENLIGHTEN_SPINLOCKS=0A-		     : "+m" (lock->slock)=
=0A-		     :=0A-#else=0A-		     "\n\t"=0A-		   =
  ASM_NOP2=0A+		     UNLOCK_LOCK_PREFIX "unary incw %0\n\t"=0A 		=
     ".L%=3Ddone:",=0A 		     ".L%=3Dalt:\n\t"=0A 		   =
  /* jmp .L%=3Dcallout */=0A--- /dev/null=0A+++ 2.6.33-rc5-virt-spinlocks/a=
rch/x86/kernel/symdefs.lds=0A@@ -0,0 +1 @@=0A+_$.zero =3D 0;=0A--- =
2.6.33-rc5-virt-spinlocks.orig/arch/x86/kernel/vmlinux.lds.S=0A+++ =
2.6.33-rc5-virt-spinlocks/arch/x86/kernel/vmlinux.lds.S=0A@@ -27,6 +27,8 =
@@=0A #include <asm/cache.h>=0A #include <asm/boot.h>=0A =0A+#include =
"symdefs.lds"=0A+=0A #undef i386     /* in case the preprocessor is a =
32bit one */=0A =0A OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMA=
T, CONFIG_OUTPUT_FORMAT)=0A
--=__Part49636D9D.3__=--
