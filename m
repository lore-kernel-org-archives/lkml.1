Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZFJVkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZFJVkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZFJVk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:40:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43637 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbZFJVk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:40:27 -0400
Date: Wed, 10 Jun 2009 23:40:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v2.6.31
Message-ID: <20090610214018.GA29510@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-microcode-for-linus

 Thanks,

	Ingo

------------------>
Dmitry Adamushko (1):
      x86: microcode: use smp_call_function_single instead of set_cpus_allowed, cleanup of synchronization logic

Figo.zhang (1):
      x86, microcode: Simplify vfree() use


 arch/x86/include/asm/microcode.h  |   25 ++-
 arch/x86/kernel/microcode_amd.c   |   70 +++-----
 arch/x86/kernel/microcode_core.c  |  329 +++++++++++++++++++++----------------
 arch/x86/kernel/microcode_intel.c |   90 ++++-------
 4 files changed, 266 insertions(+), 248 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c882664..ef51b50 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -9,20 +9,31 @@ struct cpu_signature {
 
 struct device;
 
+enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
+
 struct microcode_ops {
-	int  (*request_microcode_user) (int cpu, const void __user *buf, size_t size);
-	int  (*request_microcode_fw) (int cpu, struct device *device);
+	enum ucode_state (*request_microcode_user) (int cpu,
+				const void __user *buf, size_t size);
 
-	void (*apply_microcode) (int cpu);
+	enum ucode_state (*request_microcode_fw) (int cpu,
+				struct device *device);
 
-	int  (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
 	void (*microcode_fini_cpu) (int cpu);
+
+	/*
+	 * The generic 'microcode_core' part guarantees that
+	 * the callbacks below run on a target cpu when they
+	 * are being called.
+	 * See also the "Synchronization" section in microcode_core.c.
+	 */
+	int (*apply_microcode) (int cpu);
+	int (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
 };
 
 struct ucode_cpu_info {
-	struct cpu_signature cpu_sig;
-	int valid;
-	void *mc;
+	struct cpu_signature	cpu_sig;
+	int			valid;
+	void			*mc;
 };
 extern struct ucode_cpu_info ucode_cpu_info[];
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..366baa1 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -13,25 +13,13 @@
  *  Licensed under the terms of the GNU General Public
  *  License version 2. See file COPYING for details.
  */
-#include <linux/platform_device.h>
-#include <linux/capability.h>
-#include <linux/miscdevice.h>
 #include <linux/firmware.h>
-#include <linux/spinlock.h>
-#include <linux/cpumask.h>
 #include <linux/pci_ids.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/cpu.h>
 #include <linux/pci.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
@@ -79,9 +67,6 @@ struct microcode_amd {
 #define UCODE_CONTAINER_SECTION_HDR	8
 #define UCODE_CONTAINER_HEADER_SIZE	12
 
-/* serialize access to the physical write */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
 static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
@@ -144,9 +129,8 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	return 1;
 }
 
-static void apply_microcode_amd(int cpu)
+static int apply_microcode_amd(int cpu)
 {
-	unsigned long flags;
 	u32 rev, dummy;
 	int cpu_num = raw_smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
@@ -156,25 +140,25 @@ static void apply_microcode_amd(int cpu)
 	BUG_ON(cpu_num != cpu);
 
 	if (mc_amd == NULL)
-		return;
+		return 0;
 
-	spin_lock_irqsave(&microcode_update_lock, flags);
 	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
 	/* get patch id after patching */
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
 
 	/* check current patch id and patch's id for match */
 	if (rev != mc_amd->hdr.patch_id) {
 		printk(KERN_ERR "microcode: CPU%d: update failed "
 		       "(for patch_level=0x%x)\n", cpu, mc_amd->hdr.patch_id);
-		return;
+		return -1;
 	}
 
 	printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n",
 	       cpu, rev);
 
 	uci->cpu_sig.rev = rev;
+
+	return 0;
 }
 
 static int get_ucode_data(void *to, const u8 *from, size_t n)
@@ -257,13 +241,12 @@ static int install_equiv_cpu_table(const u8 *buf)
 
 static void free_equiv_cpu_table(void)
 {
-	if (equiv_cpu_table) {
-		vfree(equiv_cpu_table);
-		equiv_cpu_table = NULL;
-	}
+	vfree(equiv_cpu_table);
+	equiv_cpu_table = NULL;
 }
 
-static int generic_load_microcode(int cpu, const u8 *data, size_t size)
+static enum ucode_state
+generic_load_microcode(int cpu, const u8 *data, size_t size)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	const u8 *ucode_ptr = data;
@@ -272,12 +255,13 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 	int new_rev = uci->cpu_sig.rev;
 	unsigned int leftover;
 	unsigned long offset;
+	enum ucode_state state = UCODE_OK;
 
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
 		printk(KERN_ERR "microcode: failed to create "
 		       "equivalent cpu table\n");
-		return -EINVAL;
+		return UCODE_ERROR;
 	}
 
 	ucode_ptr += offset;
@@ -293,8 +277,7 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 		mc_header = (struct microcode_header_amd *)mc;
 		if (get_matching_microcode(cpu, mc, new_rev)) {
-			if (new_mc)
-				vfree(new_mc);
+			vfree(new_mc);
 			new_rev = mc_header->patch_id;
 			new_mc  = mc;
 		} else
@@ -306,34 +289,32 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	if (new_mc) {
 		if (!leftover) {
-			if (uci->mc)
-				vfree(uci->mc);
+			vfree(uci->mc);
 			uci->mc = new_mc;
 			pr_debug("microcode: CPU%d found a matching microcode "
 				 "update with version 0x%x (current=0x%x)\n",
 				 cpu, new_rev, uci->cpu_sig.rev);
-		} else
+		} else {
 			vfree(new_mc);
-	}
+			state = UCODE_ERROR;
+		}
+	} else
+		state = UCODE_NFOUND;
 
 	free_equiv_cpu_table();
 
-	return (int)leftover;
+	return state;
 }
 
-static int request_microcode_fw(int cpu, struct device *device)
+static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 {
 	const char *fw_name = "amd-ucode/microcode_amd.bin";
 	const struct firmware *firmware;
-	int ret;
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
+	enum ucode_state ret;
 
-	ret = request_firmware(&firmware, fw_name, device);
-	if (ret) {
+	if (request_firmware(&firmware, fw_name, device)) {
 		printk(KERN_ERR "microcode: failed to load file %s\n", fw_name);
-		return ret;
+		return UCODE_NFOUND;
 	}
 
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
@@ -343,11 +324,12 @@ static int request_microcode_fw(int cpu, struct device *device)
 	return ret;
 }
 
-static int request_microcode_user(int cpu, const void __user *buf, size_t size)
+static enum ucode_state
+request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
 	printk(KERN_INFO "microcode: AMD microcode update via "
 	       "/dev/cpu/microcode not supported\n");
-	return -1;
+	return UCODE_ERROR;
 }
 
 static void microcode_fini_cpu_amd(int cpu)
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 98c470c..9c44615 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -71,27 +71,18 @@
  *		Thanks to Stuart Swales for pointing out this bug.
  */
 #include <linux/platform_device.h>
-#include <linux/capability.h>
 #include <linux/miscdevice.h>
-#include <linux/firmware.h>
+#include <linux/capability.h>
 #include <linux/smp_lock.h>
-#include <linux/spinlock.h>
-#include <linux/cpumask.h>
-#include <linux/uaccess.h>
-#include <linux/vmalloc.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
-#include <asm/msr.h>
 
 MODULE_DESCRIPTION("Microcode Update Driver");
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
@@ -101,36 +92,110 @@ MODULE_LICENSE("GPL");
 
 static struct microcode_ops	*microcode_ops;
 
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
 
 struct ucode_cpu_info		ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
+/*
+ * Operations that are run on a target cpu:
+ */
+
+struct cpu_info_ctx {
+	struct cpu_signature	*cpu_sig;
+	int			err;
+};
+
+static void collect_cpu_info_local(void *arg)
+{
+	struct cpu_info_ctx *ctx = arg;
+
+	ctx->err = microcode_ops->collect_cpu_info(smp_processor_id(),
+						   ctx->cpu_sig);
+}
+
+static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
+{
+	struct cpu_info_ctx ctx = { .cpu_sig = cpu_sig, .err = 0 };
+	int ret;
+
+	ret = smp_call_function_single(cpu, collect_cpu_info_local, &ctx, 1);
+	if (!ret)
+		ret = ctx.err;
+
+	return ret;
+}
+
+static int collect_cpu_info(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	int ret;
+
+	memset(uci, 0, sizeof(*uci));
+
+	ret = collect_cpu_info_on_target(cpu, &uci->cpu_sig);
+	if (!ret)
+		uci->valid = 1;
+
+	return ret;
+}
+
+struct apply_microcode_ctx {
+	int err;
+};
+
+static void apply_microcode_local(void *arg)
+{
+	struct apply_microcode_ctx *ctx = arg;
+
+	ctx->err = microcode_ops->apply_microcode(smp_processor_id());
+}
+
+static int apply_microcode_on_target(int cpu)
+{
+	struct apply_microcode_ctx ctx = { .err = 0 };
+	int ret;
+
+	ret = smp_call_function_single(cpu, apply_microcode_local, &ctx, 1);
+	if (!ret)
+		ret = ctx.err;
+
+	return ret;
+}
+
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
 static int do_microcode_update(const void __user *buf, size_t size)
 {
-	cpumask_t old;
 	int error = 0;
 	int cpu;
 
-	old = current->cpus_allowed;
-
 	for_each_online_cpu(cpu) {
 		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+		enum ucode_state ustate;
 
 		if (!uci->valid)
 			continue;
 
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-		error = microcode_ops->request_microcode_user(cpu, buf, size);
-		if (error < 0)
-			goto out;
-		if (!error)
-			microcode_ops->apply_microcode(cpu);
+		ustate = microcode_ops->request_microcode_user(cpu, buf, size);
+		if (ustate == UCODE_ERROR) {
+			error = -1;
+			break;
+		} else if (ustate == UCODE_OK)
+			apply_microcode_on_target(cpu);
 	}
-out:
-	set_cpus_allowed_ptr(current, &old);
+
 	return error;
 }
 
@@ -143,19 +208,17 @@ static int microcode_open(struct inode *unused1, struct file *unused2)
 static ssize_t microcode_write(struct file *file, const char __user *buf,
 			       size_t len, loff_t *ppos)
 {
-	ssize_t ret;
+	ssize_t ret = -EINVAL;
 
 	if ((len >> PAGE_SHIFT) > num_physpages) {
-		printk(KERN_ERR "microcode: too much data (max %ld pages)\n",
-		       num_physpages);
-		return -EINVAL;
+		pr_err("microcode: too much data (max %ld pages)\n", num_physpages);
+		return ret;
 	}
 
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	ret = do_microcode_update(buf, len);
-	if (!ret)
+	if (do_microcode_update(buf, len) == 0)
 		ret = (ssize_t)len;
 
 	mutex_unlock(&microcode_mutex);
@@ -165,15 +228,15 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 }
 
 static const struct file_operations microcode_fops = {
-	.owner		= THIS_MODULE,
-	.write		= microcode_write,
-	.open		= microcode_open,
+	.owner			= THIS_MODULE,
+	.write			= microcode_write,
+	.open			= microcode_open,
 };
 
 static struct miscdevice microcode_dev = {
-	.minor		= MICROCODE_MINOR,
-	.name		= "microcode",
-	.fops		= &microcode_fops,
+	.minor			= MICROCODE_MINOR,
+	.name			= "microcode",
+	.fops			= &microcode_fops,
 };
 
 static int __init microcode_dev_init(void)
@@ -182,9 +245,7 @@ static int __init microcode_dev_init(void)
 
 	error = misc_register(&microcode_dev);
 	if (error) {
-		printk(KERN_ERR
-			"microcode: can't misc_register on minor=%d\n",
-			MICROCODE_MINOR);
+		pr_err("microcode: can't misc_register on minor=%d\n", MICROCODE_MINOR);
 		return error;
 	}
 
@@ -205,42 +266,51 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 /* fake device for request_firmware */
 static struct platform_device	*microcode_pdev;
 
-static long reload_for_cpu(void *unused)
+static int reload_for_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	int err = 0;
 
 	mutex_lock(&microcode_mutex);
 	if (uci->valid) {
-		err = microcode_ops->request_microcode_fw(smp_processor_id(),
-							  &microcode_pdev->dev);
-		if (!err)
-			microcode_ops->apply_microcode(smp_processor_id());
+		enum ucode_state ustate;
+
+		ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
+		if (ustate == UCODE_OK)
+			apply_microcode_on_target(cpu);
+		else
+			if (ustate == UCODE_ERROR)
+				err = -EINVAL;
 	}
 	mutex_unlock(&microcode_mutex);
+
 	return err;
 }
 
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
-			    const char *buf, size_t sz)
+			    const char *buf, size_t size)
 {
-	char *end;
-	unsigned long val = simple_strtoul(buf, &end, 0);
-	int err = 0;
+	unsigned long val;
 	int cpu = dev->id;
+	int ret = 0;
+	char *end;
 
+	val = simple_strtoul(buf, &end, 0);
 	if (end == buf)
 		return -EINVAL;
+
 	if (val == 1) {
 		get_online_cpus();
 		if (cpu_online(cpu))
-			err = work_on_cpu(cpu, reload_for_cpu, NULL);
+			ret = reload_for_cpu(cpu);
 		put_online_cpus();
 	}
-	if (err)
-		return err;
-	return sz;
+
+	if (!ret)
+		ret = size;
+
+	return ret;
 }
 
 static ssize_t version_show(struct sys_device *dev,
@@ -271,11 +341,11 @@ static struct attribute *mc_default_attrs[] = {
 };
 
 static struct attribute_group mc_attr_group = {
-	.attrs		= mc_default_attrs,
-	.name		= "microcode",
+	.attrs			= mc_default_attrs,
+	.name			= "microcode",
 };
 
-static void __microcode_fini_cpu(int cpu)
+static void microcode_fini_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
@@ -283,103 +353,68 @@ static void __microcode_fini_cpu(int cpu)
 	uci->valid = 0;
 }
 
-static void microcode_fini_cpu(int cpu)
-{
-	mutex_lock(&microcode_mutex);
-	__microcode_fini_cpu(cpu);
-	mutex_unlock(&microcode_mutex);
-}
-
-static void collect_cpu_info(int cpu)
+static enum ucode_state microcode_resume_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	memset(uci, 0, sizeof(*uci));
-	if (!microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig))
-		uci->valid = 1;
+	if (!uci->mc)
+		return UCODE_NFOUND;
+
+	pr_debug("microcode: CPU%d updated upon resume\n", cpu);
+	apply_microcode_on_target(cpu);
+
+	return UCODE_OK;
 }
 
-static int microcode_resume_cpu(int cpu)
+static enum ucode_state microcode_init_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	struct cpu_signature nsig;
+	enum ucode_state ustate;
 
-	pr_debug("microcode: CPU%d resumed\n", cpu);
+	if (collect_cpu_info(cpu))
+		return UCODE_ERROR;
 
-	if (!uci->mc)
-		return 1;
+	/* --dimm. Trigger a delayed update? */
+	if (system_state != SYSTEM_RUNNING)
+		return UCODE_NFOUND;
 
-	/*
-	 * Let's verify that the 'cached' ucode does belong
-	 * to this cpu (a bit of paranoia):
-	 */
-	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
-		__microcode_fini_cpu(cpu);
-		printk(KERN_ERR "failed to collect_cpu_info for resuming cpu #%d\n",
-				cpu);
-		return -1;
-	}
+	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
 
-	if ((nsig.sig != uci->cpu_sig.sig) || (nsig.pf != uci->cpu_sig.pf)) {
-		__microcode_fini_cpu(cpu);
-		printk(KERN_ERR "cached ucode doesn't match the resuming cpu #%d\n",
-				cpu);
-		/* Should we look for a new ucode here? */
-		return 1;
+	if (ustate == UCODE_OK) {
+		pr_debug("microcode: CPU%d updated upon init\n", cpu);
+		apply_microcode_on_target(cpu);
 	}
 
-	return 0;
+	return ustate;
 }
 
-static long microcode_update_cpu(void *unused)
+static enum ucode_state microcode_update_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
-	int err = 0;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	enum ucode_state ustate;
 
-	/*
-	 * Check if the system resume is in progress (uci->valid != NULL),
-	 * otherwise just request a firmware:
-	 */
-	if (uci->valid) {
-		err = microcode_resume_cpu(smp_processor_id());
-	} else {
-		collect_cpu_info(smp_processor_id());
-		if (uci->valid && system_state == SYSTEM_RUNNING)
-			err = microcode_ops->request_microcode_fw(
-					smp_processor_id(),
-					&microcode_pdev->dev);
-	}
-	if (!err)
-		microcode_ops->apply_microcode(smp_processor_id());
-	return err;
-}
+	if (uci->valid)
+		ustate = microcode_resume_cpu(cpu);
+	else
+		ustate = microcode_init_cpu(cpu);
 
-static int microcode_init_cpu(int cpu)
-{
-	int err;
-	mutex_lock(&microcode_mutex);
-	err = work_on_cpu(cpu, microcode_update_cpu, NULL);
-	mutex_unlock(&microcode_mutex);
-
-	return err;
+	return ustate;
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)
 {
 	int err, cpu = sys_dev->id;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	if (!cpu_online(cpu))
 		return 0;
 
 	pr_debug("microcode: CPU%d added\n", cpu);
-	memset(uci, 0, sizeof(*uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
-	err = microcode_init_cpu(cpu);
+	if (microcode_init_cpu(cpu) == UCODE_ERROR)
+		err = -EINVAL;
 
 	return err;
 }
@@ -400,19 +435,30 @@ static int mc_sysdev_remove(struct sys_device *sys_dev)
 static int mc_sysdev_resume(struct sys_device *dev)
 {
 	int cpu = dev->id;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	if (!cpu_online(cpu))
 		return 0;
 
-	/* only CPU 0 will apply ucode here */
-	microcode_update_cpu(NULL);
+	/*
+	 * All non-bootup cpus are still disabled,
+	 * so only CPU 0 will apply ucode here.
+	 *
+	 * Moreover, there can be no concurrent
+	 * updates from any other places at this point.
+	 */
+	WARN_ON(cpu != 0);
+
+	if (uci->valid && uci->mc)
+		microcode_ops->apply_microcode(cpu);
+
 	return 0;
 }
 
 static struct sysdev_driver mc_sysdev_driver = {
-	.add		= mc_sysdev_add,
-	.remove		= mc_sysdev_remove,
-	.resume		= mc_sysdev_resume,
+	.add			= mc_sysdev_add,
+	.remove			= mc_sysdev_remove,
+	.resume			= mc_sysdev_resume,
 };
 
 static __cpuinit int
@@ -425,15 +471,12 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		if (microcode_init_cpu(cpu))
-			printk(KERN_ERR "microcode: failed to init CPU%d\n",
-			       cpu);
+		microcode_update_cpu(cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("microcode: CPU%d added\n", cpu);
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
-			printk(KERN_ERR "microcode: Failed to create the sysfs "
-				"group for CPU%d\n", cpu);
+			pr_err("microcode: Failed to create group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -465,13 +508,10 @@ static int __init microcode_init(void)
 		microcode_ops = init_amd_microcode();
 
 	if (!microcode_ops) {
-		printk(KERN_ERR "microcode: no support for this CPU vendor\n");
+		pr_err("microcode: no support for this CPU vendor\n");
 		return -ENODEV;
 	}
 
-	error = microcode_dev_init();
-	if (error)
-		return error;
 	microcode_pdev = platform_device_register_simple("microcode", -1,
 							 NULL, 0);
 	if (IS_ERR(microcode_pdev)) {
@@ -480,23 +520,31 @@ static int __init microcode_init(void)
 	}
 
 	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
+
+	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
+
 	if (error) {
-		microcode_dev_exit();
 		platform_device_unregister(microcode_pdev);
 		return error;
 	}
 
+	error = microcode_dev_init();
+	if (error)
+		return error;
+
 	register_hotcpu_notifier(&mc_cpu_notifier);
 
-	printk(KERN_INFO
-	       "Microcode Update Driver: v" MICROCODE_VERSION
+	pr_info("Microcode Update Driver: v" MICROCODE_VERSION
 	       " <tigran@aivazian.fsnet.co.uk>,"
 	       " Peter Oruba\n");
 
 	return 0;
 }
+module_init(microcode_init);
 
 static void __exit microcode_exit(void)
 {
@@ -505,16 +553,17 @@ static void __exit microcode_exit(void)
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 
 	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
 	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+
+	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
 	platform_device_unregister(microcode_pdev);
 
 	microcode_ops = NULL;
 
-	printk(KERN_INFO
-	       "Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
+	pr_info("Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
 }
-
-module_init(microcode_init);
 module_exit(microcode_exit);
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..0d334dd 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -70,24 +70,11 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
-#include <linux/platform_device.h>
-#include <linux/capability.h>
-#include <linux/miscdevice.h>
 #include <linux/firmware.h>
-#include <linux/smp_lock.h>
-#include <linux/spinlock.h>
-#include <linux/cpumask.h>
 #include <linux/uaccess.h>
-#include <linux/vmalloc.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/cpu.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
+#include <linux/vmalloc.h>
 
 #include <asm/microcode.h>
 #include <asm/processor.h>
@@ -150,13 +137,9 @@ struct extended_sigtable {
 
 #define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
 
-/* serialize access to the physical write to MSR 0x79 */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-	unsigned long flags;
 	unsigned int val[2];
 
 	memset(csig, 0, sizeof(*csig));
@@ -176,18 +159,14 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		csig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 
-	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);
-
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 	/* see notes above for revision 1.07.  Apparent chip bug */
 	sync_core();
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
 
-	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
-			csig->sig, csig->pf, csig->rev);
+	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
+			cpu_num, csig->sig, csig->pf, csig->rev);
 
 	return 0;
 }
@@ -318,11 +297,10 @@ get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
 	return 0;
 }
 
-static void apply_microcode(int cpu)
+static int apply_microcode(int cpu)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
-	unsigned long flags;
 	unsigned int val[2];
 	int cpu_num;
 
@@ -334,10 +312,7 @@ static void apply_microcode(int cpu)
 	BUG_ON(cpu_num != cpu);
 
 	if (mc_intel == NULL)
-		return;
-
-	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);
+		return 0;
 
 	/* write microcode via MSR 0x79 */
 	wrmsr(MSR_IA32_UCODE_WRITE,
@@ -351,30 +326,32 @@ static void apply_microcode(int cpu)
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
 	if (val[1] != mc_intel->hdr.rev) {
-		printk(KERN_ERR "microcode: CPU%d update from revision "
-				"0x%x to 0x%x failed\n",
-			cpu_num, uci->cpu_sig.rev, val[1]);
-		return;
+		printk(KERN_ERR "microcode: CPU%d update "
+				"to revision 0x%x failed\n",
+			cpu_num, mc_intel->hdr.rev);
+		return -1;
 	}
-	printk(KERN_INFO "microcode: CPU%d updated from revision "
-			 "0x%x to 0x%x, date = %04x-%02x-%02x \n",
-		cpu_num, uci->cpu_sig.rev, val[1],
+	printk(KERN_INFO "microcode: CPU%d updated to revision "
+			 "0x%x, date = %04x-%02x-%02x \n",
+		cpu_num, val[1],
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
 		(mc_intel->hdr.date >> 16) & 0xff);
 
 	uci->cpu_sig.rev = val[1];
+
+	return 0;
 }
 
-static int generic_load_microcode(int cpu, void *data, size_t size,
-		int (*get_ucode_data)(void *, const void *, size_t))
+static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
+				int (*get_ucode_data)(void *, const void *, size_t))
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
 	int new_rev = uci->cpu_sig.rev;
 	unsigned int leftover = size;
+	enum ucode_state state = UCODE_OK;
 
 	while (leftover) {
 		struct microcode_header_intel mc_header;
@@ -412,11 +389,15 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 		leftover  -= mc_size;
 	}
 
-	if (!new_mc)
+	if (leftover) {
+		if (new_mc)
+			vfree(new_mc);
+		state = UCODE_ERROR;
 		goto out;
+	}
 
-	if (leftover) {
-		vfree(new_mc);
+	if (!new_mc) {
+		state = UCODE_NFOUND;
 		goto out;
 	}
 
@@ -427,9 +408,8 @@ static int generic_load_microcode(int cpu, void *data, size_t size,
 	pr_debug("microcode: CPU%d found a matching microcode update with"
 		 " version 0x%x (current=0x%x)\n",
 			cpu, new_rev, uci->cpu_sig.rev);
-
- out:
-	return (int)leftover;
+out:
+	return state;
 }
 
 static int get_ucode_fw(void *to, const void *from, size_t n)
@@ -438,21 +418,19 @@ static int get_ucode_fw(void *to, const void *from, size_t n)
 	return 0;
 }
 
-static int request_microcode_fw(int cpu, struct device *device)
+static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 {
 	char name[30];
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	const struct firmware *firmware;
-	int ret;
+	enum ucode_state ret;
 
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
 		c->x86, c->x86_model, c->x86_mask);
-	ret = request_firmware(&firmware, name, device);
-	if (ret) {
+
+	if (request_firmware(&firmware, name, device)) {
 		pr_debug("microcode: data file %s load failed\n", name);
-		return ret;
+		return UCODE_NFOUND;
 	}
 
 	ret = generic_load_microcode(cpu, (void *)firmware->data,
@@ -468,11 +446,9 @@ static int get_ucode_user(void *to, const void *from, size_t n)
 	return copy_from_user(to, from, n);
 }
 
-static int request_microcode_user(int cpu, const void __user *buf, size_t size)
+static enum ucode_state
+request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
 	return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
 }
 
