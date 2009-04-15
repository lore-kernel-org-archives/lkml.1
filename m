Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZDOKMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZDOKMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZDOKMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:12:35 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42661 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZDOKMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=p3/mYqcz/PSzDnUbJRRbqe+jRDlQ/zSXuPIHFuQaAiTm7GdsDiJm7O5BsdF5szO/sT
         ejvRbMPxB4DWmPEc9DuXxFY28U1QsmOTGBxV8WvULZ03whUcGJMSjSULhVtjoFCw2O0y
         DOoA8kSTXyEBUJdtLVSgjPLxHNCYCIz1UEJrI=
MIME-Version: 1.0
In-Reply-To: <200904151414.09119.rusty@rustcorp.com.au>
References: <Pine.LNX.4.64.0904141919350.3124@blonde.anvils>
	 <200904151414.09119.rusty@rustcorp.com.au>
Date: Wed, 15 Apr 2009 12:12:30 +0200
Message-ID: <b647ffbd0904150312jdd898b7wf7485e0ffe8d5414@mail.gmail.com>
Subject: Re: [PATCH] x86 microcode: revert some work_on_cpu
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c40a46b7e9a0467952f05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c40a46b7e9a0467952f05
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

2009/4/15 Rusty Russell <rusty@rustcorp.com.au>:
> On Wed, 15 Apr 2009 03:55:42 am Hugh Dickins wrote:
>> Revert part of af5c820a3169e81af869c113e18ec7588836cd50
>> x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c
>>
>> That change is causing only one Intel CPU's microcode to be updated e.g.
>> microcode: CPU3 updated from revision 0x9 to 0x17, date = 2005-04-22
>> where before it announced that also for CPU0 and CPU1 and CPU2.
>>
>> We cannot use work_on_cpu() in the CONFIG_MICROCODE_OLD_INTERFACE code,
>> because Intel's request_microcode_user() involves a copy_from_user() from
>> /sbin/microcode_ctl, which therefore needs to be on that CPU at the time.
>
> Erk.  Ack the reversion, but this needs to be fixed properly.
>
> We can't just mug a process's affinity.  I'll look at this code again and
> see what I can do.

Rusty,


what's about something like below?

Disclaimer: it's not even compilation-tested, consider it merely as an
illustration of an approach. I'll be able to test it later.

- run collect_cpu_info() and apply_microcode() on a target  cpu, the
rest of callbacks are just fine to run on any cpu;

- some synchronization changes (based on
http://lkml.indiana.edu/hypermail/linux/kernel/0903.1/00525.html)
See the "Synchronization" note in microcode_core.c

- removed sysfs_remove_group() from mc_sysdev_add() to avoid warnings
being triggered in some cases (there were a few reports on lkml) --
perhaps, to be reworked.

- some things perhaps need to be changed, e.g. add a return code to
apply_microcode(), ...

(the non-white-space damaged version is enclosed)

diff -upr linux-2.6.git/arch/x86/include/asm/microcode.h
linux-2.6.git.my/arch/x86/include/asm/microcode.h
--- linux-2.6.git/arch/x86/include/asm/microcode.h      2009-04-14
22:51:48.000000000 +0200
+++ linux-2.6.git.my/arch/x86/include/asm/microcode.h   2009-04-15
11:49:47.000000000 +0200
@@ -13,10 +13,16 @@ struct microcode_ops {
        int  (*request_microcode_user) (int cpu, const void __user
*buf, size_t size);
        int  (*request_microcode_fw) (int cpu, struct device *device);

-       void (*apply_microcode) (int cpu);
+       void (*microcode_fini_cpu) (int cpu);

+       /*
+        * The generic 'microcode_core' part guarantees that
+        * the callbacks below run on a target cpu when they
+        * are being called.
+        * See also the "Synchronization" section in microcode_core.c.
+        */
+       void (*apply_microcode) (int cpu);
        int  (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
-       void (*microcode_fini_cpu) (int cpu);
 };

 struct ucode_cpu_info {
diff -upr linux-2.6.git/arch/x86/kernel/microcode_amd.c
linux-2.6.git.my/arch/x86/kernel/microcode_amd.c
--- linux-2.6.git/arch/x86/kernel/microcode_amd.c       2009-04-14
22:51:48.000000000 +0200
+++ linux-2.6.git.my/arch/x86/kernel/microcode_amd.c    2009-04-15
11:46:38.000000000 +0200
@@ -17,7 +17,6 @@
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
 #include <linux/firmware.h>
-#include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/pci_ids.h>
 #include <linux/uaccess.h>
@@ -79,9 +78,6 @@ struct microcode_amd {
 #define UCODE_CONTAINER_SECTION_HDR    8
 #define UCODE_CONTAINER_HEADER_SIZE    12

-/* serialize access to the physical write */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
 static struct equiv_cpu_entry *equiv_cpu_table;

 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
@@ -158,11 +154,9 @@ static void apply_microcode_amd(int cpu)
        if (mc_amd == NULL)
                return;

-       spin_lock_irqsave(&microcode_update_lock, flags);
        wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
        /* get patch id after patching */
        rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-       spin_unlock_irqrestore(&microcode_update_lock, flags);

        /* check current patch id and patch's id for match */
        if (rev != mc_amd->hdr.patch_id) {
@@ -327,9 +321,6 @@ static int request_microcode_fw(int cpu,
        const struct firmware *firmware;
        int ret;

-       /* We should bind the task to the CPU */
-       BUG_ON(cpu != raw_smp_processor_id());
-
        ret = request_firmware(&firmware, fw_name, device);
        if (ret) {
                printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
diff -upr linux-2.6.git/arch/x86/kernel/microcode_core.c
linux-2.6.git.my/arch/x86/kernel/microcode_core.c
--- linux-2.6.git/arch/x86/kernel/microcode_core.c      2009-04-14
22:51:48.000000000 +0200
+++ linux-2.6.git.my/arch/x86/kernel/microcode_core.c   2009-04-15
11:45:48.000000000 +0200
@@ -101,36 +101,89 @@ MODULE_LICENSE("GPL");

 static struct microcode_ops    *microcode_ops;

-/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
+/*
+ * Synchronization.
+ *
+ * All non cpu-hotplug-callback call sites use:
+ *
+ * - microcode_mutex to synchronize with each other;
+ * - get/put_online_cpus() to synchronize with
+ *   the cpu-hotplug-callback call sites.
+ *
+ * We guarantee that only a single cpu is being
+ * updated at any particular moment of time.
+ */
 static DEFINE_MUTEX(microcode_mutex);

 struct ucode_cpu_info          ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);

+/*
+ * Operations that are run on a target cpu:
+ */
+
+struct collect_for_cpu {
+       struct cpu_signature    cpu_sig;
+       int                     cpu;
+};
+
+static long collect_cpu_info_local(void *arg)
+{
+       struct collect_for_cpu *cfc = arg;
+
+       BUG_ON(cfc->cpu != smp_processor_id());
+
+       return microcode_ops->collect_cpu_info(cfc->cpu, &cfc->cpu_sig);
+}
+
+static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
+{
+       return work_on_cpu(cpu, collect_cpu_info_local, cpu_sig);
+}
+
+static void collect_cpu_info(int cpu)
+{
+       struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+       memset(uci, 0, sizeof(*uci));
+       if (!collect_cpu_info_on_target(cpu, &uci->cpu_sig))
+               uci->valid = 1;
+}
+
+static long apply_microcode_local(void *arg)
+{
+       int cpu = (int)arg;
+
+       BUG_ON(cpu != smp_processor_id());
+       microcode_ops->apply_microcode(cpu);
+
+       return 0;
+}
+
+static int apply_microcode_on_target(int cpu)
+{
+       return work_on_cpu(cpu, apply_microcode_local, (void *)cpu);
+}
+
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
 static int do_microcode_update(const void __user *buf, size_t size)
 {
-       cpumask_t old;
        int error = 0;
        int cpu;

-       old = current->cpus_allowed;
-
        for_each_online_cpu(cpu) {
                struct ucode_cpu_info *uci = ucode_cpu_info + cpu;

                if (!uci->valid)
                        continue;

-               set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
                error = microcode_ops->request_microcode_user(cpu, buf, size);
                if (error < 0)
-                       goto out;
+                       break;
                if (!error)
-                       microcode_ops->apply_microcode(cpu);
+                       apply_microcode_on_target(cpu);
        }
-out:
-       set_cpus_allowed_ptr(current, &old);
+
        return error;
 }

@@ -205,17 +258,16 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 /* fake device for request_firmware */
 static struct platform_device  *microcode_pdev;

-static long reload_for_cpu(void *unused)
+static int reload_for_cpu(int cpu)
 {
-       struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
+       struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
        int err = 0;

        mutex_lock(&microcode_mutex);
        if (uci->valid) {
-               err = microcode_ops->request_microcode_fw(smp_processor_id(),
-                                                         &microcode_pdev->dev);
+               err = microcode_ops->request_microcode_fw(cpu,
&microcode_pdev->dev);
                if (!err)
-                       microcode_ops->apply_microcode(smp_processor_id());
+                       apply_microcode_on_target(cpu);
        }
        mutex_unlock(&microcode_mutex);
        return err;
@@ -235,7 +287,7 @@ static ssize_t reload_store(struct sys_d
        if (val == 1) {
                get_online_cpus();
                if (cpu_online(cpu))
-                       err = work_on_cpu(cpu, reload_for_cpu, NULL);
+                       err = reload_for_cpu(cpu);
                put_online_cpus();
        }
        if (err)
@@ -275,7 +327,7 @@ static struct attribute_group mc_attr_gr
        .name           = "microcode",
 };

-static void __microcode_fini_cpu(int cpu)
+static void microcode_fini_cpu(int cpu)
 {
        struct ucode_cpu_info *uci = ucode_cpu_info + cpu;

@@ -283,22 +335,6 @@ static void __microcode_fini_cpu(int cpu
        uci->valid = 0;
 }

-static void microcode_fini_cpu(int cpu)
-{
-       mutex_lock(&microcode_mutex);
-       __microcode_fini_cpu(cpu);
-       mutex_unlock(&microcode_mutex);
-}
-
-static void collect_cpu_info(int cpu)
-{
-       struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-       memset(uci, 0, sizeof(*uci));
-       if (!microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig))
-               uci->valid = 1;
-}
-
 static int microcode_resume_cpu(int cpu)
 {
        struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -313,15 +349,15 @@ static int microcode_resume_cpu(int cpu)
         * Let's verify that the 'cached' ucode does belong
         * to this cpu (a bit of paranoia):
         */
-       if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
-               __microcode_fini_cpu(cpu);
+       if (collect_cpu_info_on_target(cpu, &nsig)) {
+               microcode_fini_cpu(cpu);
                printk(KERN_ERR "failed to collect_cpu_info for
resuming cpu #%d\n",
                                cpu);
                return -1;
        }

        if ((nsig.sig != uci->cpu_sig.sig) || (nsig.pf != uci->cpu_sig.pf)) {
-               __microcode_fini_cpu(cpu);
+               microcode_fini_cpu(cpu);
                printk(KERN_ERR "cached ucode doesn't match the
resuming cpu #%d\n",
                                cpu);
                /* Should we look for a new ucode here? */
@@ -331,9 +367,9 @@ static int microcode_resume_cpu(int cpu)
        return 0;
 }

-static long microcode_update_cpu(void *unused)
+static int microcode_init_cpu(int cpu)
 {
-       struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
+       struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
        int err = 0;

        /*
@@ -341,25 +377,16 @@ static long microcode_update_cpu(void *u
         * otherwise just request a firmware:
         */
        if (uci->valid) {
-               err = microcode_resume_cpu(smp_processor_id());
+               err = microcode_resume_cpu(cpu);
        } else {
-               collect_cpu_info(smp_processor_id());
+               collect_cpu_info(cpu);
                if (uci->valid && system_state == SYSTEM_RUNNING)
                        err = microcode_ops->request_microcode_fw(
-                                       smp_processor_id(),
+                                       cpu,
                                        &microcode_pdev->dev);
        }
        if (!err)
-               microcode_ops->apply_microcode(smp_processor_id());
-       return err;
-}
-
-static int microcode_init_cpu(int cpu)
-{
-       int err;
-       mutex_lock(&microcode_mutex);
-       err = work_on_cpu(cpu, microcode_update_cpu, NULL);
-       mutex_unlock(&microcode_mutex);
+               apply_microcode_on_target(cpu);

        return err;
 }
@@ -380,8 +407,6 @@ static int mc_sysdev_add(struct sys_devi
                return err;

        err = microcode_init_cpu(cpu);
-       if (err)
-               sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);

        return err;
 }
@@ -406,8 +431,17 @@ static int mc_sysdev_resume(struct sys_d
        if (!cpu_online(cpu))
                return 0;

-       /* only CPU 0 will apply ucode here */
-       microcode_update_cpu(NULL);
+       /*
+        * All non-bootup cpus are still disabled,
+        * so only CPU 0 will apply ucode here.
+        *
+        * Moreover, there can be no concurrent
+        * updates from any other places at this point.
+        */
+       WARN_ON(cpu != 0);
+
+       microcode_init_cpu(cpu);
+
        return 0;
 }

@@ -471,9 +505,6 @@ static int __init microcode_init(void)
                return -ENODEV;
        }

-       error = microcode_dev_init();
-       if (error)
-               return error;
        microcode_pdev = platform_device_register_simple("microcode", -1,
                                                         NULL, 0);
        if (IS_ERR(microcode_pdev)) {
@@ -482,14 +513,26 @@ static int __init microcode_init(void)
        }

        get_online_cpus();
+       /*
+        * --dimm. Hmm, we can avoid it if we perhaps first
+        * try to apply ucode in mc_sysdev_add() and only
+        * then create a sysfs group.
+        */
+       mutex_lock(&microcode_mutex);
        error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
+       mutex_unlock(&microcode_mutex);
+
        put_online_cpus();
+
        if (error) {
-               microcode_dev_exit();
                platform_device_unregister(microcode_pdev);
                return error;
        }

+       error = microcode_dev_init();
+       if (error)
+               return error;
+
        register_hotcpu_notifier(&mc_cpu_notifier);

        printk(KERN_INFO
@@ -507,7 +550,9 @@ static void __exit microcode_exit(void)
        unregister_hotcpu_notifier(&mc_cpu_notifier);

        get_online_cpus();
+       mutex_lock(&microcode_mutex);
        sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+       mutex_unlock(&microcode_mutex);
        put_online_cpus();

        platform_device_unregister(microcode_pdev);
diff -upr linux-2.6.git/arch/x86/kernel/microcode_intel.c
linux-2.6.git.my/arch/x86/kernel/microcode_intel.c
--- linux-2.6.git/arch/x86/kernel/microcode_intel.c     2009-04-14
22:51:48.000000000 +0200
+++ linux-2.6.git.my/arch/x86/kernel/microcode_intel.c  2009-04-15
11:47:21.000000000 +0200
@@ -75,7 +75,6 @@
 #include <linux/miscdevice.h>
 #include <linux/firmware.h>
 #include <linux/smp_lock.h>
-#include <linux/spinlock.h>
 #include <linux/cpumask.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
@@ -150,9 +149,6 @@ struct extended_sigtable {

 #define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)

-/* serialize access to the physical write to MSR 0x79 */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
        struct cpuinfo_x86 *c = &cpu_data(cpu_num);
@@ -176,15 +172,11 @@ static int collect_cpu_info(int cpu_num,
                csig->pf = 1 << ((val[1] >> 18) & 7);
        }

-       /* serialize access to the physical write to MSR 0x79 */
-       spin_lock_irqsave(&microcode_update_lock, flags);
-
        wrmsr(MSR_IA32_UCODE_REV, 0, 0);
        /* see notes above for revision 1.07.  Apparent chip bug */
        sync_core();
        /* get the current revision from MSR 0x8B */
        rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
-       spin_unlock_irqrestore(&microcode_update_lock, flags);

        pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
                        csig->sig, csig->pf, csig->rev);
@@ -336,9 +328,6 @@ static void apply_microcode(int cpu)
        if (mc_intel == NULL)
                return;

-       /* serialize access to the physical write to MSR 0x79 */
-       spin_lock_irqsave(&microcode_update_lock, flags);
-
        /* write microcode via MSR 0x79 */
        wrmsr(MSR_IA32_UCODE_WRITE,
              (unsigned long) mc_intel->bits,
@@ -351,7 +340,6 @@ static void apply_microcode(int cpu)
        /* get the current revision from MSR 0x8B */
        rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);

-       spin_unlock_irqrestore(&microcode_update_lock, flags);
        if (val[1] != mc_intel->hdr.rev) {
                printk(KERN_ERR "microcode: CPU%d update from revision "
                                "0x%x to 0x%x failed\n",
@@ -445,8 +433,6 @@ static int request_microcode_fw(int cpu,
        const struct firmware *firmware;
        int ret;

-       /* We should bind the task to the CPU */
-       BUG_ON(cpu != raw_smp_processor_id());
        sprintf(name, "intel-ucode/%02x-%02x-%02x",
                c->x86, c->x86_model, c->x86_mask);
        ret = request_firmware(&firmware, name, device);
@@ -470,9 +456,6 @@ static int get_ucode_user(void *to, cons

 static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-       /* We should bind the task to the CPU */
-       BUG_ON(cpu != raw_smp_processor_id());
-
        return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
 }



---





-- 
Best regards,
Dmitry Adamushko

--0015174c40a46b7e9a0467952f05
Content-Type: text/x-patch; charset=US-ASCII; name="microcode.patch"
Content-Disposition: attachment; filename="microcode.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftjus7zq0

ZGlmZiAtdXByIGxpbnV4LTIuNi5naXQvYXJjaC94ODYvaW5jbHVkZS9hc20vbWljcm9jb2RlLmgg
bGludXgtMi42LmdpdC5teS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9taWNyb2NvZGUuaAotLS0gbGlu
dXgtMi42LmdpdC9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9taWNyb2NvZGUuaAkyMDA5LTA0LTE0IDIy
OjUxOjQ4LjAwMDAwMDAwMCArMDIwMAorKysgbGludXgtMi42LmdpdC5teS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9taWNyb2NvZGUuaAkyMDA5LTA0LTE1IDExOjQ5OjQ3LjAwMDAwMDAwMCArMDIwMApA
QCAtMTMsMTAgKzEzLDE2IEBAIHN0cnVjdCBtaWNyb2NvZGVfb3BzIHsKIAlpbnQgICgqcmVxdWVz
dF9taWNyb2NvZGVfdXNlcikgKGludCBjcHUsIGNvbnN0IHZvaWQgX191c2VyICpidWYsIHNpemVf
dCBzaXplKTsKIAlpbnQgICgqcmVxdWVzdF9taWNyb2NvZGVfZncpIChpbnQgY3B1LCBzdHJ1Y3Qg
ZGV2aWNlICpkZXZpY2UpOwogCi0Jdm9pZCAoKmFwcGx5X21pY3JvY29kZSkgKGludCBjcHUpOwor
CXZvaWQgKCptaWNyb2NvZGVfZmluaV9jcHUpIChpbnQgY3B1KTsKIAorCS8qIAorCSAqIFRoZSBn
ZW5lcmljICdtaWNyb2NvZGVfY29yZScgcGFydCBndWFyYW50ZWVzIHRoYXQKKwkgKiB0aGUgY2Fs
bGJhY2tzIGJlbG93IHJ1biBvbiBhIHRhcmdldCBjcHUgd2hlbiB0aGV5CisJICogYXJlIGJlaW5n
IGNhbGxlZC4KKwkgKiBTZWUgYWxzbyB0aGUgIlN5bmNocm9uaXphdGlvbiIgc2VjdGlvbiBpbiBt
aWNyb2NvZGVfY29yZS5jLgorCSAqLworCXZvaWQgKCphcHBseV9taWNyb2NvZGUpIChpbnQgY3B1
KTsKIAlpbnQgICgqY29sbGVjdF9jcHVfaW5mbykgKGludCBjcHUsIHN0cnVjdCBjcHVfc2lnbmF0
dXJlICpjc2lnKTsKLQl2b2lkICgqbWljcm9jb2RlX2ZpbmlfY3B1KSAoaW50IGNwdSk7CiB9Owog
CiBzdHJ1Y3QgdWNvZGVfY3B1X2luZm8gewpkaWZmIC11cHIgbGludXgtMi42LmdpdC9hcmNoL3g4
Ni9rZXJuZWwvbWljcm9jb2RlX2FtZC5jIGxpbnV4LTIuNi5naXQubXkvYXJjaC94ODYva2VybmVs
L21pY3JvY29kZV9hbWQuYwotLS0gbGludXgtMi42LmdpdC9hcmNoL3g4Ni9rZXJuZWwvbWljcm9j
b2RlX2FtZC5jCTIwMDktMDQtMTQgMjI6NTE6NDguMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC0y
LjYuZ2l0Lm15L2FyY2gveDg2L2tlcm5lbC9taWNyb2NvZGVfYW1kLmMJMjAwOS0wNC0xNSAxMTo0
NjozOC4wMDAwMDAwMDAgKzAyMDAKQEAgLTE3LDcgKzE3LDYgQEAKICNpbmNsdWRlIDxsaW51eC9j
YXBhYmlsaXR5Lmg+CiAjaW5jbHVkZSA8bGludXgvbWlzY2RldmljZS5oPgogI2luY2x1ZGUgPGxp
bnV4L2Zpcm13YXJlLmg+Ci0jaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4KICNpbmNsdWRlIDxs
aW51eC9jcHVtYXNrLmg+CiAjaW5jbHVkZSA8bGludXgvcGNpX2lkcy5oPgogI2luY2x1ZGUgPGxp
bnV4L3VhY2Nlc3MuaD4KQEAgLTc5LDkgKzc4LDYgQEAgc3RydWN0IG1pY3JvY29kZV9hbWQgewog
I2RlZmluZSBVQ09ERV9DT05UQUlORVJfU0VDVElPTl9IRFIJOAogI2RlZmluZSBVQ09ERV9DT05U
QUlORVJfSEVBREVSX1NJWkUJMTIKIAotLyogc2VyaWFsaXplIGFjY2VzcyB0byB0aGUgcGh5c2lj
YWwgd3JpdGUgKi8KLXN0YXRpYyBERUZJTkVfU1BJTkxPQ0sobWljcm9jb2RlX3VwZGF0ZV9sb2Nr
KTsKLQogc3RhdGljIHN0cnVjdCBlcXVpdl9jcHVfZW50cnkgKmVxdWl2X2NwdV90YWJsZTsKIAog
c3RhdGljIGludCBjb2xsZWN0X2NwdV9pbmZvX2FtZChpbnQgY3B1LCBzdHJ1Y3QgY3B1X3NpZ25h
dHVyZSAqY3NpZykKQEAgLTE1OCwxMSArMTU0LDkgQEAgc3RhdGljIHZvaWQgYXBwbHlfbWljcm9j
b2RlX2FtZChpbnQgY3B1KQogCWlmIChtY19hbWQgPT0gTlVMTCkKIAkJcmV0dXJuOwogCi0Jc3Bp
bl9sb2NrX2lycXNhdmUoJm1pY3JvY29kZV91cGRhdGVfbG9jaywgZmxhZ3MpOwogCXdybXNybChN
U1JfQU1ENjRfUEFUQ0hfTE9BREVSLCAodTY0KShsb25nKSZtY19hbWQtPmhkci5kYXRhX2NvZGUp
OwogCS8qIGdldCBwYXRjaCBpZCBhZnRlciBwYXRjaGluZyAqLwogCXJkbXNyKE1TUl9BTUQ2NF9Q
QVRDSF9MRVZFTCwgcmV2LCBkdW1teSk7Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmbWljcm9j
b2RlX3VwZGF0ZV9sb2NrLCBmbGFncyk7CiAKIAkvKiBjaGVjayBjdXJyZW50IHBhdGNoIGlkIGFu
ZCBwYXRjaCdzIGlkIGZvciBtYXRjaCAqLwogCWlmIChyZXYgIT0gbWNfYW1kLT5oZHIucGF0Y2hf
aWQpIHsKQEAgLTMyNyw5ICszMjEsNiBAQCBzdGF0aWMgaW50IHJlcXVlc3RfbWljcm9jb2RlX2Z3
KGludCBjcHUsCiAJY29uc3Qgc3RydWN0IGZpcm13YXJlICpmaXJtd2FyZTsKIAlpbnQgcmV0Owog
Ci0JLyogV2Ugc2hvdWxkIGJpbmQgdGhlIHRhc2sgdG8gdGhlIENQVSAqLwotCUJVR19PTihjcHUg
IT0gcmF3X3NtcF9wcm9jZXNzb3JfaWQoKSk7Ci0KIAlyZXQgPSByZXF1ZXN0X2Zpcm13YXJlKCZm
aXJtd2FyZSwgZndfbmFtZSwgZGV2aWNlKTsKIAlpZiAocmV0KSB7CiAJCXByaW50ayhLRVJOX0VS
UiAibWljcm9jb2RlOiBmYWlsZWQgdG8gbG9hZCBmaWxlICVzXG4iLCBmd19uYW1lKTsKZGlmZiAt
dXByIGxpbnV4LTIuNi5naXQvYXJjaC94ODYva2VybmVsL21pY3JvY29kZV9jb3JlLmMgbGludXgt
Mi42LmdpdC5teS9hcmNoL3g4Ni9rZXJuZWwvbWljcm9jb2RlX2NvcmUuYwotLS0gbGludXgtMi42
LmdpdC9hcmNoL3g4Ni9rZXJuZWwvbWljcm9jb2RlX2NvcmUuYwkyMDA5LTA0LTE0IDIyOjUxOjQ4
LjAwMDAwMDAwMCArMDIwMAorKysgbGludXgtMi42LmdpdC5teS9hcmNoL3g4Ni9rZXJuZWwvbWlj
cm9jb2RlX2NvcmUuYwkyMDA5LTA0LTE1IDExOjQ1OjQ4LjAwMDAwMDAwMCArMDIwMApAQCAtMTAx
LDM2ICsxMDEsODkgQEAgTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwogCiBzdGF0aWMgc3RydWN0IG1p
Y3JvY29kZV9vcHMJKm1pY3JvY29kZV9vcHM7CiAKLS8qIG5vIGNvbmN1cnJlbnQgLT53cml0ZSgp
cyBhcmUgYWxsb3dlZCBvbiAvZGV2L2NwdS9taWNyb2NvZGUgKi8KKy8qCisgKiBTeW5jaHJvbml6
YXRpb24uCisgKgorICogQWxsIG5vbiBjcHUtaG90cGx1Zy1jYWxsYmFjayBjYWxsIHNpdGVzIHVz
ZToKKyAqCisgKiAtIG1pY3JvY29kZV9tdXRleCB0byBzeW5jaHJvbml6ZSB3aXRoIGVhY2ggb3Ro
ZXI7CisgKiAtIGdldC9wdXRfb25saW5lX2NwdXMoKSB0byBzeW5jaHJvbml6ZSB3aXRoCisgKiAg
IHRoZSBjcHUtaG90cGx1Zy1jYWxsYmFjayBjYWxsIHNpdGVzLgorICoKKyAqIFdlIGd1YXJhbnRl
ZSB0aGF0IG9ubHkgYSBzaW5nbGUgY3B1IGlzIGJlaW5nCisgKiB1cGRhdGVkIGF0IGFueSBwYXJ0
aWN1bGFyIG1vbWVudCBvZiB0aW1lLgorICovCiBzdGF0aWMgREVGSU5FX01VVEVYKG1pY3JvY29k
ZV9tdXRleCk7CiAKIHN0cnVjdCB1Y29kZV9jcHVfaW5mbwkJdWNvZGVfY3B1X2luZm9bTlJfQ1BV
U107CiBFWFBPUlRfU1lNQk9MX0dQTCh1Y29kZV9jcHVfaW5mbyk7CiAKKy8qCisgKiBPcGVyYXRp
b25zIHRoYXQgYXJlIHJ1biBvbiBhIHRhcmdldCBjcHU6IAorICovCisKK3N0cnVjdCBjb2xsZWN0
X2Zvcl9jcHUgeworCXN0cnVjdCBjcHVfc2lnbmF0dXJlCWNwdV9zaWc7CisJaW50CQkJY3B1Owor
fTsKKworc3RhdGljIGxvbmcgY29sbGVjdF9jcHVfaW5mb19sb2NhbCh2b2lkICphcmcpCit7CisJ
c3RydWN0IGNvbGxlY3RfZm9yX2NwdSAqY2ZjID0gYXJnOworCisJQlVHX09OKGNmYy0+Y3B1ICE9
IHNtcF9wcm9jZXNzb3JfaWQoKSk7CisKKwlyZXR1cm4gbWljcm9jb2RlX29wcy0+Y29sbGVjdF9j
cHVfaW5mbyhjZmMtPmNwdSwgJmNmYy0+Y3B1X3NpZyk7Cit9CisKK3N0YXRpYyBpbnQgY29sbGVj
dF9jcHVfaW5mb19vbl90YXJnZXQoaW50IGNwdSwgc3RydWN0IGNwdV9zaWduYXR1cmUgKmNwdV9z
aWcpCit7CisJcmV0dXJuIHdvcmtfb25fY3B1KGNwdSwgY29sbGVjdF9jcHVfaW5mb19sb2NhbCwg
Y3B1X3NpZyk7Cit9CisKK3N0YXRpYyB2b2lkIGNvbGxlY3RfY3B1X2luZm8oaW50IGNwdSkKK3sK
KwlzdHJ1Y3QgdWNvZGVfY3B1X2luZm8gKnVjaSA9IHVjb2RlX2NwdV9pbmZvICsgY3B1OworCisJ
bWVtc2V0KHVjaSwgMCwgc2l6ZW9mKCp1Y2kpKTsKKwlpZiAoIWNvbGxlY3RfY3B1X2luZm9fb25f
dGFyZ2V0KGNwdSwgJnVjaS0+Y3B1X3NpZykpCisJCXVjaS0+dmFsaWQgPSAxOworfQorCitzdGF0
aWMgbG9uZyBhcHBseV9taWNyb2NvZGVfbG9jYWwodm9pZCAqYXJnKQoreworCWludCBjcHUgPSAo
aW50KWFyZzsKKworCUJVR19PTihjcHUgIT0gc21wX3Byb2Nlc3Nvcl9pZCgpKTsKKwltaWNyb2Nv
ZGVfb3BzLT5hcHBseV9taWNyb2NvZGUoY3B1KTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMg
aW50IGFwcGx5X21pY3JvY29kZV9vbl90YXJnZXQoaW50IGNwdSkKK3sKKwlyZXR1cm4gd29ya19v
bl9jcHUoY3B1LCBhcHBseV9taWNyb2NvZGVfbG9jYWwsICh2b2lkICopY3B1KTsKK30KKwogI2lm
ZGVmIENPTkZJR19NSUNST0NPREVfT0xEX0lOVEVSRkFDRQogc3RhdGljIGludCBkb19taWNyb2Nv
ZGVfdXBkYXRlKGNvbnN0IHZvaWQgX191c2VyICpidWYsIHNpemVfdCBzaXplKQogewotCWNwdW1h
c2tfdCBvbGQ7CiAJaW50IGVycm9yID0gMDsKIAlpbnQgY3B1OwogCi0Jb2xkID0gY3VycmVudC0+
Y3B1c19hbGxvd2VkOwotCiAJZm9yX2VhY2hfb25saW5lX2NwdShjcHUpIHsKIAkJc3RydWN0IHVj
b2RlX2NwdV9pbmZvICp1Y2kgPSB1Y29kZV9jcHVfaW5mbyArIGNwdTsKIAogCQlpZiAoIXVjaS0+
dmFsaWQpCiAJCQljb250aW51ZTsKIAotCQlzZXRfY3B1c19hbGxvd2VkX3B0cihjdXJyZW50LCAm
Y3B1bWFza19vZl9jcHUoY3B1KSk7CiAJCWVycm9yID0gbWljcm9jb2RlX29wcy0+cmVxdWVzdF9t
aWNyb2NvZGVfdXNlcihjcHUsIGJ1Ziwgc2l6ZSk7CiAJCWlmIChlcnJvciA8IDApCi0JCQlnb3Rv
IG91dDsKKwkJCWJyZWFrOwogCQlpZiAoIWVycm9yKQotCQkJbWljcm9jb2RlX29wcy0+YXBwbHlf
bWljcm9jb2RlKGNwdSk7CisJCQlhcHBseV9taWNyb2NvZGVfb25fdGFyZ2V0KGNwdSk7CiAJfQot
b3V0OgotCXNldF9jcHVzX2FsbG93ZWRfcHRyKGN1cnJlbnQsICZvbGQpOworCiAJcmV0dXJuIGVy
cm9yOwogfQogCkBAIC0yMDUsMTcgKzI1OCwxNiBAQCBNT0RVTEVfQUxJQVNfTUlTQ0RFVihNSUNS
T0NPREVfTUlOT1IpOwogLyogZmFrZSBkZXZpY2UgZm9yIHJlcXVlc3RfZmlybXdhcmUgKi8KIHN0
YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlCSptaWNyb2NvZGVfcGRldjsKIAotc3RhdGljIGxv
bmcgcmVsb2FkX2Zvcl9jcHUodm9pZCAqdW51c2VkKQorc3RhdGljIGludCByZWxvYWRfZm9yX2Nw
dShpbnQgY3B1KQogewotCXN0cnVjdCB1Y29kZV9jcHVfaW5mbyAqdWNpID0gdWNvZGVfY3B1X2lu
Zm8gKyBzbXBfcHJvY2Vzc29yX2lkKCk7CisJc3RydWN0IHVjb2RlX2NwdV9pbmZvICp1Y2kgPSB1
Y29kZV9jcHVfaW5mbyArIGNwdTsKIAlpbnQgZXJyID0gMDsKIAogCW11dGV4X2xvY2soJm1pY3Jv
Y29kZV9tdXRleCk7CiAJaWYgKHVjaS0+dmFsaWQpIHsKLQkJZXJyID0gbWljcm9jb2RlX29wcy0+
cmVxdWVzdF9taWNyb2NvZGVfZncoc21wX3Byb2Nlc3Nvcl9pZCgpLAotCQkJCQkJCSAgJm1pY3Jv
Y29kZV9wZGV2LT5kZXYpOworCQllcnIgPSBtaWNyb2NvZGVfb3BzLT5yZXF1ZXN0X21pY3JvY29k
ZV9mdyhjcHUsICZtaWNyb2NvZGVfcGRldi0+ZGV2KTsKIAkJaWYgKCFlcnIpCi0JCQltaWNyb2Nv
ZGVfb3BzLT5hcHBseV9taWNyb2NvZGUoc21wX3Byb2Nlc3Nvcl9pZCgpKTsKKwkJCWFwcGx5X21p
Y3JvY29kZV9vbl90YXJnZXQoY3B1KTsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZtaWNyb2NvZGVfbXV0
ZXgpOwogCXJldHVybiBlcnI7CkBAIC0yMzUsNyArMjg3LDcgQEAgc3RhdGljIHNzaXplX3QgcmVs
b2FkX3N0b3JlKHN0cnVjdCBzeXNfZAogCWlmICh2YWwgPT0gMSkgewogCQlnZXRfb25saW5lX2Nw
dXMoKTsKIAkJaWYgKGNwdV9vbmxpbmUoY3B1KSkKLQkJCWVyciA9IHdvcmtfb25fY3B1KGNwdSwg
cmVsb2FkX2Zvcl9jcHUsIE5VTEwpOworCQkJZXJyID0gcmVsb2FkX2Zvcl9jcHUoY3B1KTsKIAkJ
cHV0X29ubGluZV9jcHVzKCk7CiAJfQogCWlmIChlcnIpCkBAIC0yNzUsNyArMzI3LDcgQEAgc3Rh
dGljIHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgbWNfYXR0cl9ncgogCS5uYW1lCQk9ICJtaWNyb2Nv
ZGUiLAogfTsKIAotc3RhdGljIHZvaWQgX19taWNyb2NvZGVfZmluaV9jcHUoaW50IGNwdSkKK3N0
YXRpYyB2b2lkIG1pY3JvY29kZV9maW5pX2NwdShpbnQgY3B1KQogewogCXN0cnVjdCB1Y29kZV9j
cHVfaW5mbyAqdWNpID0gdWNvZGVfY3B1X2luZm8gKyBjcHU7CiAKQEAgLTI4MywyMiArMzM1LDYg
QEAgc3RhdGljIHZvaWQgX19taWNyb2NvZGVfZmluaV9jcHUoaW50IGNwdQogCXVjaS0+dmFsaWQg
PSAwOwogfQogCi1zdGF0aWMgdm9pZCBtaWNyb2NvZGVfZmluaV9jcHUoaW50IGNwdSkKLXsKLQlt
dXRleF9sb2NrKCZtaWNyb2NvZGVfbXV0ZXgpOwotCV9fbWljcm9jb2RlX2ZpbmlfY3B1KGNwdSk7
Ci0JbXV0ZXhfdW5sb2NrKCZtaWNyb2NvZGVfbXV0ZXgpOwotfQotCi1zdGF0aWMgdm9pZCBjb2xs
ZWN0X2NwdV9pbmZvKGludCBjcHUpCi17Ci0Jc3RydWN0IHVjb2RlX2NwdV9pbmZvICp1Y2kgPSB1
Y29kZV9jcHVfaW5mbyArIGNwdTsKLQotCW1lbXNldCh1Y2ksIDAsIHNpemVvZigqdWNpKSk7Ci0J
aWYgKCFtaWNyb2NvZGVfb3BzLT5jb2xsZWN0X2NwdV9pbmZvKGNwdSwgJnVjaS0+Y3B1X3NpZykp
Ci0JCXVjaS0+dmFsaWQgPSAxOwotfQotCiBzdGF0aWMgaW50IG1pY3JvY29kZV9yZXN1bWVfY3B1
KGludCBjcHUpCiB7CiAJc3RydWN0IHVjb2RlX2NwdV9pbmZvICp1Y2kgPSB1Y29kZV9jcHVfaW5m
byArIGNwdTsKQEAgLTMxMywxNSArMzQ5LDE1IEBAIHN0YXRpYyBpbnQgbWljcm9jb2RlX3Jlc3Vt
ZV9jcHUoaW50IGNwdSkKIAkgKiBMZXQncyB2ZXJpZnkgdGhhdCB0aGUgJ2NhY2hlZCcgdWNvZGUg
ZG9lcyBiZWxvbmcKIAkgKiB0byB0aGlzIGNwdSAoYSBiaXQgb2YgcGFyYW5vaWEpOgogCSAqLwot
CWlmIChtaWNyb2NvZGVfb3BzLT5jb2xsZWN0X2NwdV9pbmZvKGNwdSwgJm5zaWcpKSB7Ci0JCV9f
bWljcm9jb2RlX2ZpbmlfY3B1KGNwdSk7CisJaWYgKGNvbGxlY3RfY3B1X2luZm9fb25fdGFyZ2V0
KGNwdSwgJm5zaWcpKSB7CisJCW1pY3JvY29kZV9maW5pX2NwdShjcHUpOwogCQlwcmludGsoS0VS
Tl9FUlIgImZhaWxlZCB0byBjb2xsZWN0X2NwdV9pbmZvIGZvciByZXN1bWluZyBjcHUgIyVkXG4i
LAogCQkJCWNwdSk7CiAJCXJldHVybiAtMTsKIAl9CiAKIAlpZiAoKG5zaWcuc2lnICE9IHVjaS0+
Y3B1X3NpZy5zaWcpIHx8IChuc2lnLnBmICE9IHVjaS0+Y3B1X3NpZy5wZikpIHsKLQkJX19taWNy
b2NvZGVfZmluaV9jcHUoY3B1KTsKKwkJbWljcm9jb2RlX2ZpbmlfY3B1KGNwdSk7CiAJCXByaW50
ayhLRVJOX0VSUiAiY2FjaGVkIHVjb2RlIGRvZXNuJ3QgbWF0Y2ggdGhlIHJlc3VtaW5nIGNwdSAj
JWRcbiIsCiAJCQkJY3B1KTsKIAkJLyogU2hvdWxkIHdlIGxvb2sgZm9yIGEgbmV3IHVjb2RlIGhl
cmU/ICovCkBAIC0zMzEsOSArMzY3LDkgQEAgc3RhdGljIGludCBtaWNyb2NvZGVfcmVzdW1lX2Nw
dShpbnQgY3B1KQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgbG9uZyBtaWNyb2NvZGVfdXBkYXRl
X2NwdSh2b2lkICp1bnVzZWQpCitzdGF0aWMgaW50IG1pY3JvY29kZV9pbml0X2NwdShpbnQgY3B1
KQogewotCXN0cnVjdCB1Y29kZV9jcHVfaW5mbyAqdWNpID0gdWNvZGVfY3B1X2luZm8gKyBzbXBf
cHJvY2Vzc29yX2lkKCk7CisJc3RydWN0IHVjb2RlX2NwdV9pbmZvICp1Y2kgPSB1Y29kZV9jcHVf
aW5mbyArIGNwdTsKIAlpbnQgZXJyID0gMDsKIAogCS8qCkBAIC0zNDEsMjUgKzM3NywxNiBAQCBz
dGF0aWMgbG9uZyBtaWNyb2NvZGVfdXBkYXRlX2NwdSh2b2lkICp1CiAJICogb3RoZXJ3aXNlIGp1
c3QgcmVxdWVzdCBhIGZpcm13YXJlOgogCSAqLwogCWlmICh1Y2ktPnZhbGlkKSB7Ci0JCWVyciA9
IG1pY3JvY29kZV9yZXN1bWVfY3B1KHNtcF9wcm9jZXNzb3JfaWQoKSk7CisJCWVyciA9IG1pY3Jv
Y29kZV9yZXN1bWVfY3B1KGNwdSk7CiAJfSBlbHNlIHsKLQkJY29sbGVjdF9jcHVfaW5mbyhzbXBf
cHJvY2Vzc29yX2lkKCkpOworCQljb2xsZWN0X2NwdV9pbmZvKGNwdSk7CiAJCWlmICh1Y2ktPnZh
bGlkICYmIHN5c3RlbV9zdGF0ZSA9PSBTWVNURU1fUlVOTklORykKIAkJCWVyciA9IG1pY3JvY29k
ZV9vcHMtPnJlcXVlc3RfbWljcm9jb2RlX2Z3KAotCQkJCQlzbXBfcHJvY2Vzc29yX2lkKCksCisJ
CQkJCWNwdSwKIAkJCQkJJm1pY3JvY29kZV9wZGV2LT5kZXYpOwogCX0KIAlpZiAoIWVycikKLQkJ
bWljcm9jb2RlX29wcy0+YXBwbHlfbWljcm9jb2RlKHNtcF9wcm9jZXNzb3JfaWQoKSk7Ci0JcmV0
dXJuIGVycjsKLX0KLQotc3RhdGljIGludCBtaWNyb2NvZGVfaW5pdF9jcHUoaW50IGNwdSkKLXsK
LQlpbnQgZXJyOwotCW11dGV4X2xvY2soJm1pY3JvY29kZV9tdXRleCk7Ci0JZXJyID0gd29ya19v
bl9jcHUoY3B1LCBtaWNyb2NvZGVfdXBkYXRlX2NwdSwgTlVMTCk7Ci0JbXV0ZXhfdW5sb2NrKCZt
aWNyb2NvZGVfbXV0ZXgpOworCQlhcHBseV9taWNyb2NvZGVfb25fdGFyZ2V0KGNwdSk7CiAKIAly
ZXR1cm4gZXJyOwogfQpAQCAtMzgwLDggKzQwNyw2IEBAIHN0YXRpYyBpbnQgbWNfc3lzZGV2X2Fk
ZChzdHJ1Y3Qgc3lzX2RldmkKIAkJcmV0dXJuIGVycjsKIAogCWVyciA9IG1pY3JvY29kZV9pbml0
X2NwdShjcHUpOwotCWlmIChlcnIpCi0JCXN5c2ZzX3JlbW92ZV9ncm91cCgmc3lzX2Rldi0+a29i
aiwgJm1jX2F0dHJfZ3JvdXApOwogCiAJcmV0dXJuIGVycjsKIH0KQEAgLTQwNiw4ICs0MzEsMTcg
QEAgc3RhdGljIGludCBtY19zeXNkZXZfcmVzdW1lKHN0cnVjdCBzeXNfZAogCWlmICghY3B1X29u
bGluZShjcHUpKQogCQlyZXR1cm4gMDsKIAotCS8qIG9ubHkgQ1BVIDAgd2lsbCBhcHBseSB1Y29k
ZSBoZXJlICovCi0JbWljcm9jb2RlX3VwZGF0ZV9jcHUoTlVMTCk7CisJLyoKKwkgKiBBbGwgbm9u
LWJvb3R1cCBjcHVzIGFyZSBzdGlsbCBkaXNhYmxlZCwKKwkgKiBzbyBvbmx5IENQVSAwIHdpbGwg
YXBwbHkgdWNvZGUgaGVyZS4KKwkgKgorCSAqIE1vcmVvdmVyLCB0aGVyZSBjYW4gYmUgbm8gY29u
Y3VycmVudAorCSAqIHVwZGF0ZXMgZnJvbSBhbnkgb3RoZXIgcGxhY2VzIGF0IHRoaXMgcG9pbnQu
CisJICovCisJV0FSTl9PTihjcHUgIT0gMCk7CisKKwltaWNyb2NvZGVfaW5pdF9jcHUoY3B1KTsK
KwogCXJldHVybiAwOwogfQogCkBAIC00NzEsOSArNTA1LDYgQEAgc3RhdGljIGludCBfX2luaXQg
bWljcm9jb2RlX2luaXQodm9pZCkKIAkJcmV0dXJuIC1FTk9ERVY7CiAJfQogCi0JZXJyb3IgPSBt
aWNyb2NvZGVfZGV2X2luaXQoKTsKLQlpZiAoZXJyb3IpCi0JCXJldHVybiBlcnJvcjsKIAltaWNy
b2NvZGVfcGRldiA9IHBsYXRmb3JtX2RldmljZV9yZWdpc3Rlcl9zaW1wbGUoIm1pY3JvY29kZSIs
IC0xLAogCQkJCQkJCSBOVUxMLCAwKTsKIAlpZiAoSVNfRVJSKG1pY3JvY29kZV9wZGV2KSkgewpA
QCAtNDgyLDE0ICs1MTMsMjYgQEAgc3RhdGljIGludCBfX2luaXQgbWljcm9jb2RlX2luaXQodm9p
ZCkKIAl9CiAKIAlnZXRfb25saW5lX2NwdXMoKTsKKwkvKgorCSAqIC0tZGltbS4gSG1tLCB3ZSBj
YW4gYXZvaWQgaXQgaWYgd2UgcGVyaGFwcyBmaXJzdAorCSAqIHRyeSB0byBhcHBseSB1Y29kZSBp
biBtY19zeXNkZXZfYWRkKCkgYW5kIG9ubHkgCisJICogdGhlbiBjcmVhdGUgYSBzeXNmcyBncm91
cC4KKwkgKi8KKwltdXRleF9sb2NrKCZtaWNyb2NvZGVfbXV0ZXgpOwogCWVycm9yID0gc3lzZGV2
X2RyaXZlcl9yZWdpc3RlcigmY3B1X3N5c2Rldl9jbGFzcywgJm1jX3N5c2Rldl9kcml2ZXIpOwor
CW11dGV4X3VubG9jaygmbWljcm9jb2RlX211dGV4KTsKKwogCXB1dF9vbmxpbmVfY3B1cygpOwor
CiAJaWYgKGVycm9yKSB7Ci0JCW1pY3JvY29kZV9kZXZfZXhpdCgpOwogCQlwbGF0Zm9ybV9kZXZp
Y2VfdW5yZWdpc3RlcihtaWNyb2NvZGVfcGRldik7CiAJCXJldHVybiBlcnJvcjsKIAl9CiAKKwll
cnJvciA9IG1pY3JvY29kZV9kZXZfaW5pdCgpOworCWlmIChlcnJvcikKKwkJcmV0dXJuIGVycm9y
OworCiAJcmVnaXN0ZXJfaG90Y3B1X25vdGlmaWVyKCZtY19jcHVfbm90aWZpZXIpOwogCiAJcHJp
bnRrKEtFUk5fSU5GTwpAQCAtNTA3LDcgKzU1MCw5IEBAIHN0YXRpYyB2b2lkIF9fZXhpdCBtaWNy
b2NvZGVfZXhpdCh2b2lkKQogCXVucmVnaXN0ZXJfaG90Y3B1X25vdGlmaWVyKCZtY19jcHVfbm90
aWZpZXIpOwogCiAJZ2V0X29ubGluZV9jcHVzKCk7CisJbXV0ZXhfbG9jaygmbWljcm9jb2RlX211
dGV4KTsKIAlzeXNkZXZfZHJpdmVyX3VucmVnaXN0ZXIoJmNwdV9zeXNkZXZfY2xhc3MsICZtY19z
eXNkZXZfZHJpdmVyKTsKKwltdXRleF91bmxvY2soJm1pY3JvY29kZV9tdXRleCk7CiAJcHV0X29u
bGluZV9jcHVzKCk7CiAKIAlwbGF0Zm9ybV9kZXZpY2VfdW5yZWdpc3RlcihtaWNyb2NvZGVfcGRl
dik7CmRpZmYgLXVwciBsaW51eC0yLjYuZ2l0L2FyY2gveDg2L2tlcm5lbC9taWNyb2NvZGVfaW50
ZWwuYyBsaW51eC0yLjYuZ2l0Lm15L2FyY2gveDg2L2tlcm5lbC9taWNyb2NvZGVfaW50ZWwuYwot
LS0gbGludXgtMi42LmdpdC9hcmNoL3g4Ni9rZXJuZWwvbWljcm9jb2RlX2ludGVsLmMJMjAwOS0w
NC0xNCAyMjo1MTo0OC4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi5naXQubXkvYXJjaC94
ODYva2VybmVsL21pY3JvY29kZV9pbnRlbC5jCTIwMDktMDQtMTUgMTE6NDc6MjEuMDAwMDAwMDAw
ICswMjAwCkBAIC03NSw3ICs3NSw2IEBACiAjaW5jbHVkZSA8bGludXgvbWlzY2RldmljZS5oPgog
I2luY2x1ZGUgPGxpbnV4L2Zpcm13YXJlLmg+CiAjaW5jbHVkZSA8bGludXgvc21wX2xvY2suaD4K
LSNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5oPgogI2luY2x1ZGUgPGxpbnV4L2NwdW1hc2suaD4K
ICNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+CiAjaW5jbHVkZSA8bGludXgvdm1hbGxvYy5oPgpA
QCAtMTUwLDkgKzE0OSw2IEBAIHN0cnVjdCBleHRlbmRlZF9zaWd0YWJsZSB7CiAKICNkZWZpbmUg
ZXh0dGFibGVfc2l6ZShldCkgKChldCktPmNvdW50ICogRVhUX1NJR05BVFVSRV9TSVpFICsgRVhU
X0hFQURFUl9TSVpFKQogCi0vKiBzZXJpYWxpemUgYWNjZXNzIHRvIHRoZSBwaHlzaWNhbCB3cml0
ZSB0byBNU1IgMHg3OSAqLwotc3RhdGljIERFRklORV9TUElOTE9DSyhtaWNyb2NvZGVfdXBkYXRl
X2xvY2spOwotCiBzdGF0aWMgaW50IGNvbGxlY3RfY3B1X2luZm8oaW50IGNwdV9udW0sIHN0cnVj
dCBjcHVfc2lnbmF0dXJlICpjc2lnKQogewogCXN0cnVjdCBjcHVpbmZvX3g4NiAqYyA9ICZjcHVf
ZGF0YShjcHVfbnVtKTsKQEAgLTE3NiwxNSArMTcyLDExIEBAIHN0YXRpYyBpbnQgY29sbGVjdF9j
cHVfaW5mbyhpbnQgY3B1X251bSwKIAkJY3NpZy0+cGYgPSAxIDw8ICgodmFsWzFdID4+IDE4KSAm
IDcpOwogCX0KIAotCS8qIHNlcmlhbGl6ZSBhY2Nlc3MgdG8gdGhlIHBoeXNpY2FsIHdyaXRlIHRv
IE1TUiAweDc5ICovCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJm1pY3JvY29kZV91cGRhdGVfbG9jaywg
ZmxhZ3MpOwotCiAJd3Jtc3IoTVNSX0lBMzJfVUNPREVfUkVWLCAwLCAwKTsKIAkvKiBzZWUgbm90
ZXMgYWJvdmUgZm9yIHJldmlzaW9uIDEuMDcuICBBcHBhcmVudCBjaGlwIGJ1ZyAqLwogCXN5bmNf
Y29yZSgpOwogCS8qIGdldCB0aGUgY3VycmVudCByZXZpc2lvbiBmcm9tIE1TUiAweDhCICovCiAJ
cmRtc3IoTVNSX0lBMzJfVUNPREVfUkVWLCB2YWxbMF0sIGNzaWctPnJldik7Ci0Jc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmbWljcm9jb2RlX3VwZGF0ZV9sb2NrLCBmbGFncyk7CiAKIAlwcl9kZWJ1
ZygibWljcm9jb2RlOiBjb2xsZWN0X2NwdV9pbmZvIDogc2lnPTB4JXgsIHBmPTB4JXgsIHJldj0w
eCV4XG4iLAogCQkJY3NpZy0+c2lnLCBjc2lnLT5wZiwgY3NpZy0+cmV2KTsKQEAgLTMzNiw5ICsz
MjgsNiBAQCBzdGF0aWMgdm9pZCBhcHBseV9taWNyb2NvZGUoaW50IGNwdSkKIAlpZiAobWNfaW50
ZWwgPT0gTlVMTCkKIAkJcmV0dXJuOwogCi0JLyogc2VyaWFsaXplIGFjY2VzcyB0byB0aGUgcGh5
c2ljYWwgd3JpdGUgdG8gTVNSIDB4NzkgKi8KLQlzcGluX2xvY2tfaXJxc2F2ZSgmbWljcm9jb2Rl
X3VwZGF0ZV9sb2NrLCBmbGFncyk7Ci0KIAkvKiB3cml0ZSBtaWNyb2NvZGUgdmlhIE1TUiAweDc5
ICovCiAJd3Jtc3IoTVNSX0lBMzJfVUNPREVfV1JJVEUsCiAJICAgICAgKHVuc2lnbmVkIGxvbmcp
IG1jX2ludGVsLT5iaXRzLApAQCAtMzUxLDcgKzM0MCw2IEBAIHN0YXRpYyB2b2lkIGFwcGx5X21p
Y3JvY29kZShpbnQgY3B1KQogCS8qIGdldCB0aGUgY3VycmVudCByZXZpc2lvbiBmcm9tIE1TUiAw
eDhCICovCiAJcmRtc3IoTVNSX0lBMzJfVUNPREVfUkVWLCB2YWxbMF0sIHZhbFsxXSk7CiAKLQlz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZtaWNyb2NvZGVfdXBkYXRlX2xvY2ssIGZsYWdzKTsKIAlp
ZiAodmFsWzFdICE9IG1jX2ludGVsLT5oZHIucmV2KSB7CiAJCXByaW50ayhLRVJOX0VSUiAibWlj
cm9jb2RlOiBDUFUlZCB1cGRhdGUgZnJvbSByZXZpc2lvbiAiCiAJCQkJIjB4JXggdG8gMHgleCBm
YWlsZWRcbiIsCkBAIC00NDUsOCArNDMzLDYgQEAgc3RhdGljIGludCByZXF1ZXN0X21pY3JvY29k
ZV9mdyhpbnQgY3B1LAogCWNvbnN0IHN0cnVjdCBmaXJtd2FyZSAqZmlybXdhcmU7CiAJaW50IHJl
dDsKIAotCS8qIFdlIHNob3VsZCBiaW5kIHRoZSB0YXNrIHRvIHRoZSBDUFUgKi8KLQlCVUdfT04o
Y3B1ICE9IHJhd19zbXBfcHJvY2Vzc29yX2lkKCkpOwogCXNwcmludGYobmFtZSwgImludGVsLXVj
b2RlLyUwMngtJTAyeC0lMDJ4IiwKIAkJYy0+eDg2LCBjLT54ODZfbW9kZWwsIGMtPng4Nl9tYXNr
KTsKIAlyZXQgPSByZXF1ZXN0X2Zpcm13YXJlKCZmaXJtd2FyZSwgbmFtZSwgZGV2aWNlKTsKQEAg
LTQ3MCw5ICs0NTYsNiBAQCBzdGF0aWMgaW50IGdldF91Y29kZV91c2VyKHZvaWQgKnRvLCBjb25z
CiAKIHN0YXRpYyBpbnQgcmVxdWVzdF9taWNyb2NvZGVfdXNlcihpbnQgY3B1LCBjb25zdCB2b2lk
IF9fdXNlciAqYnVmLCBzaXplX3Qgc2l6ZSkKIHsKLQkvKiBXZSBzaG91bGQgYmluZCB0aGUgdGFz
ayB0byB0aGUgQ1BVICovCi0JQlVHX09OKGNwdSAhPSByYXdfc21wX3Byb2Nlc3Nvcl9pZCgpKTsK
LQogCXJldHVybiBnZW5lcmljX2xvYWRfbWljcm9jb2RlKGNwdSwgKHZvaWQgKilidWYsIHNpemUs
ICZnZXRfdWNvZGVfdXNlcik7CiB9Cg==
--0015174c40a46b7e9a0467952f05--
