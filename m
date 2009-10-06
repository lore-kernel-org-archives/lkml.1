Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZJFAvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZJFAvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZJFAvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:51:37 -0400
Received: from claw.goop.org ([74.207.240.146]:35259 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbZJFAve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:51:34 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Xen-devel <xen-devel@lists.xensource.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/5] xen/time: add pvclock_clocksource_vread support
Date: Mon,  5 Oct 2009 17:50:11 -0700
Message-Id: <1254790211-15416-6-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to register pvclock_vcpu_time_info structures in the userspace
mapped page and set the xen clocksource .vread method if that works.
The common pvclock code does everything else.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Kconfig         |    6 +++++
 arch/x86/xen/mmu.c           |    3 +-
 arch/x86/xen/smp.c           |    2 +
 arch/x86/xen/time.c          |   52 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h       |    8 ++++++
 include/xen/interface/vcpu.h |   41 +++++++++++++++++++++++++++++++++
 6 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index b83e119..a002004 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -13,6 +13,11 @@ config XEN
 	  kernel to boot in a paravirtualized environment under the
 	  Xen hypervisor.
 
+config XEN_TIME_VSYSCALL
+       def_bool y
+       depends on PREEMPT_NOTIFIERS
+       select PARAVIRT_CLOCK_VSYSCALL
+
 config XEN_MAX_DOMAIN_MEMORY
        int "Maximum allowed size of a domain in gigabytes"
        default 8 if X86_32
@@ -36,3 +41,4 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
+
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4ceb285..99b8aa5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1814,6 +1814,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # endif
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+	case FIX_PVCLOCK_TIME_INFO:
 #endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	case FIX_APIC_BASE:	/* maps dummy local APIC */
@@ -1834,7 +1835,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+	if (user_fixmap(idx)) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 429834e..a2ee882 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -313,6 +313,8 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	if (rc)
 		return rc;
 
+	xen_setup_vcpu_vsyscall_time_info(cpu);
+
 	rc = HYPERVISOR_vcpu_op(VCPUOP_up, cpu, NULL);
 	BUG_ON(rc);
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0a5aa44..ab3119e 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -474,6 +474,55 @@ void xen_timer_resume(void)
 	}
 }
 
+#ifdef CONFIG_PARAVIRT_CLOCK_VSYSCALL
+void xen_setup_vcpu_vsyscall_time_info(int cpu)
+{
+	int ret;
+	struct pvclock_vcpu_time_info *pvti;
+	struct vcpu_register_time_memory_area t;
+
+	pvti = pvclock_get_vsyscall_time_info(cpu);
+	if (!pvti)
+		return;
+
+	t.addr.pv = pvti;
+
+	ret = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_time_memory_area,
+				 cpu, &t);
+	/*
+	 * If the call succeeds, it will update the vcpu_time_info and
+	 * set the version to something valid.  If it fails, we set
+	 * the version to invalid so that usermode doesn't try to use
+	 * it.
+	 */
+	if (ret != 0)
+		pvti->version = ~0;
+}
+
+static int __init xen_setup_vsyscall_timeinfo(int cpu)
+{
+	int ret;
+
+	ret = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_time_memory_area,
+				 cpu, NULL);
+	if (ret == -ENOSYS) {
+		printk(KERN_INFO "xen: vcpu_time_info placement not supported\n");
+		return ret;
+	}
+
+	ret = pvclock_init_vsyscall();
+	if (ret != 0) {
+		printk(KERN_INFO "xen: Failed to initialize pvclock vsyscall: %d\n",
+		       ret);
+		return ret;
+	}
+
+	xen_setup_vcpu_vsyscall_time_info(cpu);
+
+	return 0;
+}
+#endif	/* CONFIG_PARAVIRT_CLOCK_VSYSCALL */
+
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
@@ -496,4 +545,7 @@ __init void xen_time_init(void)
 
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
+
+	if (xen_setup_vsyscall_timeinfo(cpu) == 0)
+		xen_clocksource.vread = pvclock_clocksource_vread;
 }
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 22494fd..d92ddc8 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -58,6 +58,14 @@ bool xen_vcpu_stolen(int vcpu);
 
 void xen_setup_vcpu_info_placement(void);
 
+#ifdef CONFIG_XEN_TIME_VSYSCALL
+void xen_setup_vcpu_vsyscall_time_info(int cpu);
+#else
+static inline void xen_setup_vcpu_vsyscall_time_info(int cpu)
+{
+}
+#endif
+
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
diff --git a/include/xen/interface/vcpu.h b/include/xen/interface/vcpu.h
index 87e6f8a..0a8edfd 100644
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -170,4 +170,45 @@ struct vcpu_register_vcpu_info {
 };
 DEFINE_GUEST_HANDLE_STRUCT(vcpu_register_vcpu_info);
 
+
+/*
+ * Register a memory location to get a secondary copy of the vcpu time
+ * parameters.  The master copy still exists as part of the vcpu
+ * shared memory area, and this secondary copy is updated whenever the
+ * master copy is updated.
+ *
+ * The intent is that this copy may be mapped (RO) into userspace so
+ * that usermode can compute system time using the time info and the
+ * tsc.  Usermode will see an array of vcpu_time_info structures, one
+ * for each vcpu, and choose the right one by an existing mechanism
+ * which allows it to get the current vcpu number (such as via a
+ * segment limit).  It can then apply the normal algorithm to compute
+ * system time from the tsc.
+ *
+ * However, because usermode threads are subject to two levels of
+ * scheduling (kernel scheduling of threads to vcpus, and Xen
+ * scheduling of vcpus to pcpus), we must make sure that the thread
+ * knows it has had a race with either (or both) of these two events.
+ * To allow this, the guest kernel updates the time_info version
+ * number when the vcpu does a context switch, so that usermode will
+ * always see a version number change when the parameters need to be
+ * revalidated.  Xen makes sure that it always updates the guest's
+ * version rather than overwriting it.  (It assumes that a vcpu will
+ * always update its own version number, so there are no cross-cpu
+ * synchronization issues; the only concern is that if the guest
+ * kernel gets preempted by Xen it doesn't revert the version number
+ * to an older value.)
+ *
+ * @extra_arg == pointer to vcpu_register_time_info_memory_area structure.
+ */
+#define VCPUOP_register_vcpu_time_memory_area   13
+
+struct vcpu_register_time_memory_area {
+	union {
+		struct vcpu_time_info *v;
+		struct pvclock_vcpu_time_info *pv;
+		uint64_t p;
+	} addr;
+};
+
 #endif /* __XEN_PUBLIC_VCPU_H__ */
-- 
1.6.2.5

