Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbZKYW4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbZKYW4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbZKYW4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:56:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53167 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466AbZKYW4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:56:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=azLP2r1HfN1IMGDJGw36SInt7TpL3rV9h2fY8DnETpXj/y6OM5O7XGm7Aa3amgrUOS
         sJORGbSs6VJIJ+MRheXS9WyWINvERosKa8xfDuIuAud4IhmGbwwV5twlx369t40bXqbp
         CxMfNBCfm7hXsQqDgYILHmGAXj2hxnViJS9yc=
Subject: [PATCH - 2/2] tip, x86-microcode: refactor microcode output
 messages
From: dimm <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 23:56:12 +0100
Message-Id: <1259189772.7940.48.camel@dimm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: x86-microcode: refactor microcode output messages


Provide a compound message for cpus with equal microcode version as follows:

[  425.432384] microcode: original microcode versions
[  425.432400] microcode: CPU0-1: sig=0x6f2, pf=0x20, revision=0x56
...
[  425.468367] microcode: updated microcode versions
[  425.468382] microcode: CPU0-1: sig=0x6f2, pf=0x20, revision=0x57


The new mechanism is used in microcode_init()
[ i.e. when loading a module ] and microcode_write(), i.e. when all the cpus are being updated at once.

reload_for_cpu() and update-all-cpus-upon-resuming() use the old
approach - a new microcode version is being reported upon applying it.


Andreas, would you please try these changes with your setups?
My laptop's CPUs are of the most recent microcode revision so I can't test them thoroughly. Thanks in advance.


 arch/x86/include/asm/microcode.h  |    5 ++-
 arch/x86/kernel/microcode_amd.c   |   11 +++-
 arch/x86/kernel/microcode_core.c  |  108 ++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/microcode_intel.c |   23 +++++---
 4 files changed, 122 insertions(+), 25 deletions(-)


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andreas Mohr <andi@lisas.de>

---

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 0be7c00..6fae822 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -14,6 +14,7 @@ enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
 struct microcode_ops {
 	void (*init)(struct device *device);
 	void (*fini)(void);
+
 	enum ucode_state (*request_microcode_user) (int cpu,
 				const void __user *buf, size_t size);
 
@@ -28,8 +29,10 @@ struct microcode_ops {
 	 * are being called.
 	 * See also the "Synchronization" section in microcode_core.c.
 	 */
-	int (*apply_microcode) (int cpu);
+	int (*apply_microcode) (int cpu, int verbose);
 	int (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
+
+	int (*version_snprintf) (char *buf, int len, struct cpu_signature *csig);
 };
 
 struct ucode_cpu_info {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7d006e4..8c081cf 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -85,6 +85,11 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	return 0;
 }
 
+static int version_snprintf(char *buf, int len, struct cpu_signature *csig)
+{
+	return snprintf(buf, len, "patch_level=0x%x", csig->rev);
+}
+
 static int get_matching_microcode(int cpu, void *mc, int rev)
 {
 	struct microcode_header_amd *mc_header = mc;
@@ -122,7 +127,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 	return 1;
 }
 
-static int apply_microcode_amd(int cpu)
+static int apply_microcode_amd(int cpu, int verbose)
 {
 	u32 rev, dummy;
 	int cpu_num = raw_smp_processor_id();
@@ -146,7 +151,8 @@ static int apply_microcode_amd(int cpu)
 		return -1;
 	}
 
-	pr_info("microcode: CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
+	if (verbose)
+		printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n", cpu, rev);
 
 	return 0;
 }
@@ -359,6 +365,7 @@ static struct microcode_ops microcode_amd_ops = {
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info_amd,
 	.apply_microcode                  = apply_microcode_amd,
+	.version_snprintf                 = version_snprintf,
 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
 };
 
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 30558fe..b0fe584 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -137,20 +137,33 @@ static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
 	return ret;
 }
 
+struct cpu_info_array_ctx {
+	struct cpu_signature    cpu_sig;
+	int                     err;
+};
+
+static void collect_cpu_info_array(void *arg)
+{
+	int cpu = smp_processor_id();
+	struct cpu_info_array_ctx *ctx = arg;
+
+	ctx[cpu].err = microcode_ops->collect_cpu_info(cpu, &ctx[cpu].cpu_sig);
+}
+
 struct apply_microcode_ctx {
-	int err;
+	int err, verbose;
 };
 
 static void apply_microcode_local(void *arg)
 {
 	struct apply_microcode_ctx *ctx = arg;
 
-	ctx->err = microcode_ops->apply_microcode(smp_processor_id());
+	ctx->err = microcode_ops->apply_microcode(smp_processor_id(), ctx->verbose);
 }
 
-static int apply_microcode_on_target(int cpu)
+static int apply_microcode_on_target(int cpu, int verbose)
 {
-	struct apply_microcode_ctx ctx = { .err = 0 };
+	struct apply_microcode_ctx ctx = { .err = 0, .verbose = verbose };
 	int ret;
 
 	ret = smp_call_function_single(cpu, apply_microcode_local, &ctx, 1);
@@ -160,6 +173,67 @@ static int apply_microcode_on_target(int cpu)
 	return ret;
 }
 
+static int summarize_cpu_range(struct cpumask *range, struct cpu_signature *csig)
+{
+	char *cpu_str, *ver_str;
+	int ret = -1;
+
+	cpu_str = kmalloc(128, GFP_KERNEL);
+	ver_str = kmalloc(128, GFP_KERNEL);
+	if (!cpu_str || !ver_str)
+		goto out;
+
+	cpulist_scnprintf(cpu_str, 128, range);
+	microcode_ops->version_snprintf(ver_str, 128, csig);
+
+        printk(KERN_INFO "microcode: CPU%s: %s\n", cpu_str, ver_str);
+	ret = 0;
+out:
+	if (cpu_str)
+		kfree(cpu_str);
+	if (ver_str)
+		kfree(ver_str);
+
+	return ret;
+}
+
+static void summarize_cpu_info(void)
+{
+	struct cpu_info_array_ctx *ctx_array;
+	cpumask_var_t cpulist;
+	int base, cpu, ret;
+
+	if (!zalloc_cpumask_var(&cpulist, GFP_KERNEL))
+		return;
+
+	ctx_array = kmalloc(nr_cpu_ids * sizeof(*ctx_array), GFP_KERNEL);
+	if (!ctx_array)
+		goto out;
+
+	ret = on_each_cpu(collect_cpu_info_array, ctx_array, 1);
+	if (ret)
+		goto out;
+
+	base = cpumask_first(cpu_online_mask);
+	cpu  = base;
+	cpumask_set_cpu(cpu, cpulist);
+
+	while ((cpu = cpumask_next(cpu, cpu_online_mask)) < nr_cpu_ids) {
+		if (memcmp(&ctx_array[base].cpu_sig, &ctx_array[cpu].cpu_sig,
+				sizeof(ctx_array[base].cpu_sig)) != 0) {
+			summarize_cpu_range(cpulist, &ctx_array[base].cpu_sig);
+			cpumask_clear(cpulist);
+			base = cpu;
+		}
+		cpumask_set_cpu(cpu, cpulist);
+	}
+	summarize_cpu_range(cpulist, &ctx_array[base].cpu_sig);
+out:
+	free_cpumask_var(cpulist);
+	if (ctx_array)
+		kfree(ctx_array);
+}
+
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
 static int do_microcode_update(const void __user *buf, size_t size)
 {
@@ -174,7 +248,7 @@ static int do_microcode_update(const void __user *buf, size_t size)
 			error = -1;
 			break;
 		} else if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
+			apply_microcode_on_target(cpu, 0);
 	}
 
 	return error;
@@ -198,8 +272,10 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	if (do_microcode_update(buf, len) == 0)
+	if (do_microcode_update(buf, len) == 0) {
 		ret = (ssize_t)len;
+		summarize_cpu_info();
+	}
 
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
@@ -254,7 +330,7 @@ static int reload_for_cpu(int cpu)
 	mutex_lock(&microcode_mutex);
 	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
 	if (ustate == UCODE_OK)
-		apply_microcode_on_target(cpu);
+		apply_microcode_on_target(cpu, 1);
 	mutex_unlock(&microcode_mutex);
 
 	return (ustate == UCODE_ERROR)? -EINVAL : 0;
@@ -337,12 +413,12 @@ static enum ucode_state microcode_resume_cpu(int cpu)
 		return UCODE_NFOUND;
 
 	pr_debug("microcode: CPU%d updated upon resume\n", cpu);
-	apply_microcode_on_target(cpu);
+	apply_microcode_on_target(cpu, 1);
 
 	return UCODE_OK;
 }
 
-static enum ucode_state microcode_init_cpu(int cpu)
+static enum ucode_state microcode_init_cpu(int cpu, int verbose)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
@@ -357,7 +433,7 @@ static enum ucode_state microcode_init_cpu(int cpu)
 
 	if (ustate == UCODE_OK) {
 		pr_debug("microcode: CPU%d updated upon init\n", cpu);
-		apply_microcode_on_target(cpu);
+		apply_microcode_on_target(cpu, verbose);
 	}
 
 	return ustate;
@@ -371,7 +447,7 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	if (uci->mc)
 		ustate = microcode_resume_cpu(cpu);
 	else
-		ustate = microcode_init_cpu(cpu);
+		ustate = microcode_init_cpu(cpu, 1);
 
 	return ustate;
 }
@@ -389,7 +465,7 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR)
+	if (microcode_init_cpu(cpu, 0) == UCODE_ERROR)
 		err = -EINVAL;
 
 	return err;
@@ -426,7 +502,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
 	WARN_ON(cpu != 0);
 
 	if (uci->mc)
-		microcode_ops->apply_microcode(cpu);
+		microcode_ops->apply_microcode(cpu, 1);
 
 	return 0;
 }
@@ -501,8 +577,14 @@ static int __init microcode_init(void)
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
+	printk(KERN_INFO "microcode: original microcode versions\n");
+	summarize_cpu_info();
+
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
 
+	printk(KERN_INFO "microcode: updated microcode versions\n");
+	summarize_cpu_info();
+
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 6589765..571f289 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -165,12 +165,14 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
 
-	printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
-			cpu_num, csig->sig, csig->pf, csig->rev);
-
 	return 0;
 }
 
+static int version_snprintf(char *buf, int len, struct cpu_signature *csig)
+{
+	return snprintf(buf, len, "sig=0x%x, pf=0x%x, revision=0x%x", csig->sig, csig->pf, csig->rev);
+}
+
 static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 {
 	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
@@ -297,7 +299,7 @@ get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
 	return 0;
 }
 
-static int apply_microcode(int cpu)
+static int apply_microcode(int cpu, int verbose)
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
@@ -332,12 +334,14 @@ static int apply_microcode(int cpu)
 			cpu_num, mc_intel->hdr.rev);
 		return -1;
 	}
-	printk(KERN_INFO "microcode: CPU%d updated to revision "
+
+	if (verbose)
+		printk(KERN_INFO "microcode: CPU%d updated to revision "
 			 "0x%x, date = %04x-%02x-%02x \n",
-		cpu_num, val[1],
-		mc_intel->hdr.date & 0xffff,
-		mc_intel->hdr.date >> 24,
-		(mc_intel->hdr.date >> 16) & 0xff);
+			cpu_num, val[1],
+			mc_intel->hdr.date & 0xffff,
+			mc_intel->hdr.date >> 24,
+			(mc_intel->hdr.date >> 16) & 0xff);
 
 	return 0;
 }
@@ -468,6 +472,7 @@ static struct microcode_ops microcode_intel_ops = {
 	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
 	.apply_microcode                  = apply_microcode,
+	.version_snprintf                 = version_snprintf,
 	.microcode_fini_cpu               = microcode_fini_cpu,
 };
 

