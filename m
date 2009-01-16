Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbZAPJHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbZAPJHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759901AbZAPJGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:06:14 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56255 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756895AbZAPJGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:06:06 -0500
Message-ID: <49704DF6.8040205@sgi.com>
Date: Fri, 16 Jan 2009 01:05:58 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL}: latest tip/cpus4096 changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

Please pull the following 'fairly lightweight' changes for tip/cpus4096.
(Well, except for "cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write"
which has been tested to be more reliable now.)

Thanks!
Mike
--- 
The following changes since commit c99dbbe9f8f6b3e9383e64710217e873431d1c31:
  Mike Travis (1):
        sched: fix warning on ia64

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo master

Mike Travis (6):
      cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
      x86: cleanup remaining cpumask_t code in microcode_core.c
      xen: reduce static memory usage
      x86: reduce static memory usage in microcode_core.c
      kgdb: reduce static memory usage in kgdb.c
      acpi: reduce memory required for apic_version

Rusty Russell (2):
      cpumask: don't try to get_online_cpus() in work_on_cpu.
      work_on_cpu: Use our own workqueue.

 arch/x86/include/asm/microcode.h           |    2 +-
 arch/x86/include/asm/mpspec.h              |   22 +++++++
 arch/x86/kernel/acpi/boot.c                |    8 +-
 arch/x86/kernel/apic.c                     |   70 ++++++++++++++++++++++-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   22 +++----
 arch/x86/kernel/io_apic.c                  |    2 +-
 arch/x86/kernel/microcode_core.c           |   85 ++++++++++++++++++----------
 arch/x86/kernel/setup_percpu.c             |    3 +
 arch/x86/kernel/smpboot.c                  |    6 +-
 arch/x86/kernel/visws_quirks.c             |    2 +-
 drivers/xen/events.c                       |   10 ++-
 kernel/kgdb.c                              |   10 +++-
 kernel/workqueue.c                         |   20 +++---
 13 files changed, 193 insertions(+), 69 deletions(-)

commit 4eadffe68fb5f1d4c18ee2bbcb91f5c79f434db5
Author: Mike Travis <travis@sgi.com>
Date:   Fri Jan 16 00:22:34 2009 -0800

    acpi: reduce memory required for apic_version
    
    Impact: reduce memory usage
    
    By moving the initial static apic_version array into __initdata
    memory, and allocating a correctly sized one once the number of
    apic's is known, reduces the memory required when the MAX_APICS
    is >= 256.  This deals with this memory bump when NR_CPUS bumped
    from 128 to 4096:
    
       1020   131072  +130052 +12750%  apic_version(.bss)
    
    Since apic_version is lightly used, a simple lookup is used to
    convert apicid -> version.
    
    If MAX_APICS < 256, then the current apic_version[MAX_APIC] array
    is left in place.
    
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 62d14ce..ec01fab 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -5,7 +5,29 @@
 
 #include <asm/mpspec_def.h>
 
+#if MAX_APICS < 256
 extern int apic_version[MAX_APICS];
+static inline int add_apic_version(unsigned int apicid, int version)
+{
+	apic_version[apicid] = version;
+	return 0;
+}
+
+static inline int get_apic_version(unsigned int apicid)
+{
+	return apic_version[apicid];
+}
+
+static inline void cleanup_apic_version(void)
+{
+}
+
+#else	/* MAX_APICS >= 256 */
+int __cpuinit add_apic_version(unsigned int apicid, int version);
+int get_apic_version(unsigned int apicid);
+void __init cleanup_apic_version(void);
+#endif
+
 extern int pic_mode;
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d37593c..0ea7036 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -254,7 +254,7 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 	}
 
 	if (boot_cpu_physical_apicid != -1U)
-		ver = apic_version[boot_cpu_physical_apicid];
+		ver = get_apic_version(boot_cpu_physical_apicid);
 
 	generic_processor_info(id, ver);
 }
@@ -789,8 +789,8 @@ static void __init acpi_register_lapic_address(unsigned long address)
 	set_fixmap_nocache(FIX_APIC_BASE, address);
 	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = read_apic_id();
-		apic_version[boot_cpu_physical_apicid] =
-			 GET_APIC_VERSION(apic_read(APIC_LVR));
+		add_apic_version(boot_cpu_physical_apicid,
+			 GET_APIC_VERSION(apic_read(APIC_LVR)));
 	}
 }
 
@@ -903,7 +903,7 @@ static u8 __init uniq_ioapic_id(u8 id)
 {
 #ifdef CONFIG_X86_32
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
-	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+	    !APIC_XAPIC(get_apic_version(boot_cpu_physical_apicid)))
 		return io_apic_get_unique_id(nr_ioapics, id);
 	else
 		return id;
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 0f830e4..2182094 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1562,8 +1562,69 @@ void __init init_apic_mappings(void)
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
+
+#if MAX_APICS < 256
 int apic_version[MAX_APICS];
 
+#else
+struct apic_version_info {
+	unsigned int apicid;
+	int version;
+};
+
+struct apic_version_info _apic_version_info[CONFIG_NR_CPUS] __initdata;
+struct apic_version_info *apic_version_info __refdata = _apic_version_info;
+int nr_apic_version_info;
+
+/* can be called either during init or cpu hotplug add */
+int __cpuinit add_apic_version(unsigned int apicid, int version)
+{
+	int i;
+
+	for (i = 0; i < nr_apic_version_info; i++)
+		if (apicid == apic_version_info[i].apicid) {
+			apic_version_info[i].version = version;
+			return 0;
+		}
+
+	if (likely(nr_apic_version_info < nr_cpu_ids)) {
+		i = nr_apic_version_info++;
+		apic_version_info[i].apicid = apicid;
+		apic_version_info[i].version = version;
+		return 0;
+	}
+	return -ENOMEM;
+}
+
+/* lookup version for apic, usually first one (boot cpu) */
+int get_apic_version(unsigned int apicid)
+{
+	int i;
+
+	for (i = 0; i < nr_apic_version_info; i++)
+		if (apicid == apic_version_info[i].apicid)
+			return apic_version_info[i].version;
+
+	return 0;
+}
+
+/* allocate permanent apic_version structure */
+void __init cleanup_apic_version(void)
+{
+	size_t size;
+	int i;
+
+	/* allows disabled_cpus to be brought online */
+	size = nr_cpu_ids * sizeof(*apic_version_info);
+	apic_version_info = alloc_bootmem(size);
+
+	/* copy version info from initial array to permanent array */
+	for (i = 0; i < nr_apic_version_info; i++)
+		apic_version_info[i] = _apic_version_info[i];
+}
+
+#endif /* MAX_APICS >= 256 */
+
 int __init APIC_init_uniprocessor(void)
 {
 #ifdef CONFIG_X86_64
@@ -1584,7 +1645,7 @@ int __init APIC_init_uniprocessor(void)
 	 * Complain if the BIOS pretends there is one.
 	 */
 	if (!cpu_has_apic &&
-	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+	    APIC_INTEGRATED(get_apic_version(boot_cpu_physical_apicid))) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
 			boot_cpu_physical_apicid);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
@@ -1816,7 +1877,12 @@ void __cpuinit generic_processor_info(int apicid, int version)
 				version);
 		version = 0x10;
 	}
-	apic_version[apicid] = version;
+	if (unlikely(add_apic_version(apicid, version)) < 0) {
+		pr_warning(
+			"ACPI: cannot add apicid 0x%x version: out of memory\n",
+			apicid);
+		return;
+	}
 
 	if (num_processors >= nr_cpu_ids) {
 		int max = nr_cpu_ids;
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 1579869..e575c3c 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2103,7 +2103,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 	 * no meaning without the serial APIC bus.
 	 */
 	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		|| APIC_XAPIC(get_apic_version(boot_cpu_physical_apicid)))
 		return;
 	/*
 	 * This is broken; anything with a real cpu count has to
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 55c4607..fb7a461 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -209,6 +209,9 @@ void __init setup_per_cpu_areas(void)
 
 	/* Setup cpu initialized, callin, callout masks */
 	setup_cpu_local_masks();
+
+	/* Cleanup apic_version array */
+	cleanup_apic_version();
 }
 
 #endif
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bb1a3b1..ae2c845 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -592,7 +592,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	 * Give the other CPU some time to accept the IPI.
 	 */
 	udelay(200);
-	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+	if (APIC_INTEGRATED(get_apic_version(boot_cpu_physical_apicid))) {
 		maxlvt = lapic_get_maxlvt();
 		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
@@ -625,7 +625,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	/*
 	 * Be paranoid about clearing APIC errors.
 	 */
-	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+	if (APIC_INTEGRATED(get_apic_version(phys_apicid))) {
 		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
@@ -665,7 +665,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	 * Determine this based on the APIC version.
 	 * If we don't have an integrated APIC, don't send the STARTUP IPIs.
 	 */
-	if (APIC_INTEGRATED(apic_version[phys_apicid]))
+	if (APIC_INTEGRATED(get_apic_version(phys_apicid)))
 		num_starts = 2;
 	else
 		num_starts = 0;
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index d801d06..7fe2b25 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -211,7 +211,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 			m->apicid);
 		ver = 0x10;
 	}
-	apic_version[m->apicid] = ver;
+	add_apic_version(m->apicid, ver);
 }
 
 static int __init visws_find_smp_config(unsigned int reserve)

commit 0389b4e73561c3ccf36d6c8290e9496b959f06a6
Author: Mike Travis <travis@sgi.com>
Date:   Fri Jan 16 00:22:33 2009 -0800

    kgdb: reduce static memory usage in kgdb.c
    
    Impact: reduce static memory usage.
    
    By allocating kgdb_info based on nr_cpu_ids instead of NR_CPUS,
    it will be sized big enough for the number of cpus on the running
    system.  This deals with this memory bump when NR_CPUS bumped
    from 128 to 4096:
    
       2048    65536   +63488 +3100%  kgdb_info(.bss)
    
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index e4dcfb2..21fde60 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -72,7 +72,7 @@ struct kgdb_state {
 static struct debuggerinfo_struct {
 	void			*debuggerinfo;
 	struct task_struct	*task;
-} kgdb_info[NR_CPUS];
+} *kgdb_info;
 
 /**
  * kgdb_connected - Is a host GDB connected to us?
@@ -1651,6 +1651,13 @@ int kgdb_register_io_module(struct kgdb_io *new_kgdb_io_ops)
 		return -EBUSY;
 	}
 
+	kgdb_info = kmalloc(nr_cpu_ids * sizeof(*kgdb_info), GFP_KERNEL);
+	if (unlikely(!kgdb_info)) {
+		spin_unlock(&kgdb_registration_lock);
+		printk(KERN_ERR "kgdb: No memory for kgdb_info\n");
+		return -ENOMEM;
+	}
+
 	if (new_kgdb_io_ops->init) {
 		err = new_kgdb_io_ops->init();
 		if (err) {
@@ -1696,6 +1703,7 @@ void kgdb_unregister_io_module(struct kgdb_io *old_kgdb_io_ops)
 
 	WARN_ON_ONCE(kgdb_io_ops != old_kgdb_io_ops);
 	kgdb_io_ops = NULL;
+	kfee(kgdb_info);
 
 	spin_unlock(&kgdb_registration_lock);
 

commit 16c4ae6a8845d6ccda26326678e0e7ec2e4b0509
Author: Mike Travis <travis@sgi.com>
Date:   Fri Jan 16 00:22:33 2009 -0800

    x86: reduce static memory usage in microcode_core.c
    
    Impact: reduce static memory usage.
    
    By allocating ucode_cpu_info based on nr_cpu_ids instead of
    NR_CPUS, it will be sized big enough for the number of cpus
    on the running system.  This deals with this memory bump
    when NR_CPUS bumped from 128 to 4096:
    
       3072    98304   +95232 +3100%  ucode_cpu_info(.bss)
    
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c882664..ca973f6 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -24,7 +24,7 @@ struct ucode_cpu_info {
 	int valid;
 	void *mc;
 };
-extern struct ucode_cpu_info ucode_cpu_info[];
+extern struct ucode_cpu_info *ucode_cpu_info;
 
 #ifdef CONFIG_MICROCODE_INTEL
 extern struct microcode_ops * __init init_intel_microcode(void);
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 50f9e18..5a1aafc 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -104,7 +104,7 @@ static struct microcode_ops *microcode_ops;
 /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
 static DEFINE_MUTEX(microcode_mutex);
 
-struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+struct ucode_cpu_info *ucode_cpu_info;
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
@@ -471,6 +471,13 @@ static int __init microcode_init(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
+	size_t size = sizeof(*ucode_cpu_info) * nr_cpu_ids;
+
+	ucode_cpu_info = kmalloc(size, GFP_KERNEL);
+	if (!ucode_cpu_info) {
+		WARN(1, "CPU: cannot allocate microcode info structure\n");
+		return -ENOMEM;
+	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();
@@ -525,6 +532,8 @@ static void __exit microcode_exit(void)
 
 	microcode_ops = NULL;
 
+	kfree(ucode_cpu_info);
+
 	printk(KERN_INFO
 	       "Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
 }

commit beec9183a43f8a42f5b790326a3b120a3b513590
Author: Mike Travis <travis@sgi.com>
Date:   Fri Jan 16 00:22:33 2009 -0800

    xen: reduce static memory usage
    
    Impact: reduce memory usage
    
    By allocating the irq_info and irq_bindcount based
    on nr_irqs instead of NR_IRQS, it will contain only
    enough entries as needed by the running system.
    
    This addresses this memory bump when NR_CPUS bumped
    from 128 to 4096:
    
      17408   132096  +114688  +658%  irq_info(.bss)
      17408   132096  +114688  +658%  irq_bindcount(.bss)
    
    This is only effective when CONFIG_SPARSE_IRQS=y.
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Tested-by: Christophe Saout <christophe@saout.de>

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 3141e14..c8894d7 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bootmem.h>
+#include <linux/irqnr.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
@@ -59,7 +60,7 @@ struct packed_irq
 	unsigned char type;
 };
 
-static struct packed_irq irq_info[NR_IRQS];
+static struct packed_irq *irq_info;
 
 /* Binding types. */
 enum {
@@ -87,7 +88,7 @@ static inline unsigned long *cpu_evtchn_mask(int cpu)
 static u8 cpu_evtchn[NR_EVENT_CHANNELS];
 
 /* Reference counts for bindings to IRQs. */
-static int irq_bindcount[NR_IRQS];
+static int *irq_bindcount;
 
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
@@ -833,7 +834,10 @@ void __init xen_init_IRQ(void)
 	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
 
 	cpu_evtchn_mask_p = alloc_bootmem(size);
-	BUG_ON(cpu_evtchn_mask_p == NULL);
+
+	irq_info = alloc_bootmem(nr_irqs * sizeof(struct packed_irq));
+
+	irq_bindcount = alloc_bootmem(nr_irqs * sizeof(int));
 
 	init_evtchn_cpu_bindings();
 

commit 47c28f0a59121a7bbdfb46d0362ca319f35538dc
Author: Mike Travis <travis@sgi.com>
Date:   Thu Jan 15 17:16:55 2009 -0800

    x86: cleanup remaining cpumask_t code in microcode_core.c
    
    Impact: Reduce problem with changing current->cpus_allowed mask directly.
    
    Use "work_on_cpu" to replace instances where set_cpus_allowed_ptr was being used.
    
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index c9b721b..50f9e18 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -108,29 +108,43 @@ struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
+struct do_microcode_update_args {
+	const void __user *buf;
+	size_t size;
+};
+
+static long do_microcode_update_sub(void *_args)
+{
+	struct do_microcode_update_args *args = _args;
+	long error;
+	int cpu = smp_processor_id();
+
+	error = microcode_ops->request_microcode_user(cpu, args->buf,
+						      args->size);
+	if (!error)
+		microcode_ops->apply_microcode(cpu);
+
+	return error;
+}
+
 static int do_microcode_update(const void __user *buf, size_t size)
 {
-	cpumask_t old;
+	struct do_microcode_update_args args;
 	int error = 0;
 	int cpu;
 
-	old = current->cpus_allowed;
-
+	args.buf = buf;
+	args.size = size;
 	for_each_online_cpu(cpu) {
 		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 		if (!uci->valid)
 			continue;
 
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-		error = microcode_ops->request_microcode_user(cpu, buf, size);
+		error = work_on_cpu(cpu, do_microcode_update_sub, &args);
 		if (error < 0)
-			goto out;
-		if (!error)
-			microcode_ops->apply_microcode(cpu);
+			break;
 	}
-out:
-	set_cpus_allowed_ptr(current, &old);
 	return error;
 }
 
@@ -205,6 +219,18 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 /* fake device for request_firmware */
 static struct platform_device *microcode_pdev;
 
+static long reload_store_sub(void *unused)
+{
+	int cpu = smp_processor_id();
+	long err;
+
+	err = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+	if (!err)
+		microcode_ops->apply_microcode(cpu);
+
+	return err;
+}
+
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
 			    const char *buf, size_t sz)
@@ -218,20 +244,12 @@ static ssize_t reload_store(struct sys_device *dev,
 	if (end == buf)
 		return -EINVAL;
 	if (val == 1) {
-		cpumask_t old = current->cpus_allowed;
-
 		get_online_cpus();
 		if (cpu_online(cpu)) {
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 			mutex_lock(&microcode_mutex);
-			if (uci->valid) {
-				err = microcode_ops->request_microcode_fw(cpu,
-						&microcode_pdev->dev);
-				if (!err)
-					microcode_ops->apply_microcode(cpu);
-			}
+			if (uci->valid)
+				work_on_cpu(cpu, reload_store_sub, NULL);
 			mutex_unlock(&microcode_mutex);
-			set_cpus_allowed_ptr(current, &old);
 		}
 		put_online_cpus();
 	}
@@ -349,19 +367,17 @@ static void microcode_update_cpu(int cpu)
 		microcode_ops->apply_microcode(cpu);
 }
 
-static void microcode_init_cpu(int cpu)
+static long microcode_update_cpu_sub(void *unused)
 {
-	cpumask_t old = current->cpus_allowed;
-
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	/* We should bind the task to the CPU */
-	BUG_ON(raw_smp_processor_id() != cpu);
+	microcode_update_cpu(smp_processor_id());
+	return 0;
+}
 
+static void microcode_init_cpu(int cpu)
+{
 	mutex_lock(&microcode_mutex);
-	microcode_update_cpu(cpu);
+	work_on_cpu(cpu, microcode_update_cpu_sub, NULL);
 	mutex_unlock(&microcode_mutex);
-
-	set_cpus_allowed_ptr(current, &old);
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)

commit f766ec2751f6f7ebed571e87f5f0f20f25a116be
Author: Mike Travis <travis@sgi.com>
Date:   Thu Jan 15 16:29:16 2009 -0800

    cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
    
    Impact: use new work_on_cpu function to reduce stack usage
    
    Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr() with
    a work_on_cpu function for drv_read() and drv_write().
    
    Basically converts do_drv_{read,write} into "work_on_cpu" functions that
    are now called by drv_read and drv_write.
    
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Rusty Russell <rusty@rustcorp.com.au>
    Tested-by: Dieter Ries <clip2@gmx.de>
    Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 0192767..4b1c319 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -150,8 +150,9 @@ struct drv_cmd {
 	u32 val;
 };
 
-static void do_drv_read(struct drv_cmd *cmd)
+static long do_drv_read(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 h;
 
 	switch (cmd->type) {
@@ -166,10 +167,12 @@ static void do_drv_read(struct drv_cmd *cmd)
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void do_drv_write(struct drv_cmd *cmd)
+static long do_drv_write(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
 
 	switch (cmd->type) {
@@ -186,30 +189,23 @@ static void do_drv_write(struct drv_cmd *cmd)
 	default:
 		break;
 	}
+	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed_ptr(current, cmd->mask);
-	do_drv_read(cmd);
-	set_cpus_allowed_ptr(current, &saved_mask);
+	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
 	for_each_cpu(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, cpumask_of(i));
-		do_drv_write(cmd);
+		work_on_cpu(i, do_drv_write, cmd);
 	}
-
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return;
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -367,7 +363,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	return freq;
 }
 
-static unsigned int check_freqs(const cpumask_t *mask, unsigned int freq,
+static unsigned int check_freqs(const struct cpumask *mask, unsigned int freq,
 				struct acpi_cpufreq_data *data)
 {
 	unsigned int cur_freq;

commit b758cdbee5da0b8fb7e34a68651e6ccc5310b48a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 15 16:29:16 2009 -0800

    work_on_cpu: Use our own workqueue.
    
    Impact: remove potential circular lock dependency with generic kevent workqueue
    
    Annoyingly, some places we want to use work_on_cpu are already in
    workqueues.  As per Ingo's suggestion, we create a different workqueue
    for work_on_cpu.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a35afdb..1f0c509 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -971,6 +971,8 @@ undo:
 }
 
 #ifdef CONFIG_SMP
+static struct workqueue_struct *work_on_cpu_wq __read_mostly;
+
 struct work_for_cpu {
 	struct work_struct work;
 	long (*fn)(void *);
@@ -1001,7 +1003,7 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	schedule_work_on(cpu, &wfc.work);
+	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
 	flush_work(&wfc.work);
 
 	return wfc.ret;
@@ -1019,4 +1021,8 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
+#ifdef CONFIG_SMP
+	work_on_cpu_wq = create_workqueue("work_on_cpu");
+	BUG_ON(!work_on_cpu_wq);
+#endif
 }

commit 660130abaa2d26672b7670f88741e29e88552dc6
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Jan 15 16:29:16 2009 -0800

    cpumask: don't try to get_online_cpus() in work_on_cpu.
    
    Impact: remove potential circular lock dependency with cpu hotplug lock
    
    This has caused more problems than it solved, with a pile of cpu
    hotplug locking issues.
    
    Followup patches will get_online_cpus() in callers that need it, but
    if they don't do it they're no worse than before when they were using
    set_cpus_allowed without locking.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2f44583..a35afdb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -991,8 +991,8 @@ static void do_work_for_cpu(struct work_struct *w)
  * @fn: the function to run
  * @arg: the function arg
  *
- * This will return -EINVAL in the cpu is not online, or the return value
- * of @fn otherwise.
+ * This will return the value @fn returns.
+ * It is up to the caller to ensure that the cpu doesn't go offline.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
@@ -1001,14 +1001,8 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	get_online_cpus();
-	if (unlikely(!cpu_online(cpu)))
-		wfc.ret = -EINVAL;
-	else {
-		schedule_work_on(cpu, &wfc.work);
-		flush_work(&wfc.work);
-	}
-	put_online_cpus();
+	schedule_work_on(cpu, &wfc.work);
+	flush_work(&wfc.work);
 
 	return wfc.ret;
 }

