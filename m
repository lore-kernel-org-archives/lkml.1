Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZKAWXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZKAWXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZKAWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:23:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:46555 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbZKAWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:23:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cfrfY2rMR01mdq4uPwg6FR/HrqLsukRYmkAbNDvPe+J2wLigpfSAYA/HILCOrwrjUo
         9ZH4gYd+4atEZ3UgIMcCWaqfpdyoqBZS4gzX73XLkfBU/9cGMLTkz2DRV4aEpYvRuu/2
         QX4ERG9wPveILnuuNmCNdSPN0CNUn3V/dvwqg=
Subject: [ RFC, PATCH - 1/2 ] x86-microcode: refactor microcode output
 messages
From: dimm <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 01 Nov 2009 23:22:59 +0100
Message-Id: <1257114179.6833.47.camel@dimm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


this is in response to Mike's patch "Limit the number of microcode
messages".

What's about the following (yet preliminary and not thoroughly tested)
approach?

patch-1:

simplify 'struct ucode_cpu_info' and related operational logic.


patch-2: 

reduce a number of similar 'microcode version' messages by printing a
single message for all cpus with equal microcode version, like:

(1)
[   96.589437] microcode: original microcode versions...
[   96.589451] microcode: CPU0-1: sig=0x6f2, pf=0x20, revision=0x57

(2)
[   96.603176] microcode: microcode versions after update...
[   96.603193] microcode: CPU0-1: sig=0x6f2, pf=0x20, revision=0x57


The new approach is used in microcode_init() [ i.e. when loading a
module ] and microcode_write(), that's when we update all the cpus at
once.

reload_for_cpu() and update-all-cpus-upon-resuming() use the old
approach - a new microcode version is being reported upon applying it.

The latter might employ the similar 'report-for-all' approach as above
but that would somewhat complicate the logic. Anyways, there are plenty
of per-cpu messages upon system resuming so having some more
update-microcode related ones won't harm that muc, I guess :-)


(Not-yet-)signed-off-by: Dmitry Adaushko <dmitry.adamushko@gmail.com>

Patch-1:

diff --git a/arch/x86/include/asm/microcode.h
b/arch/x86/include/asm/microcode.h
index ef51b50..68fd54c 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -31,8 +31,6 @@ struct microcode_ops {
 };
 
 struct ucode_cpu_info {
-	struct cpu_signature	cpu_sig;
-	int			valid;
 	void			*mc;
 };
 extern struct ucode_cpu_info ucode_cpu_info[];
diff --git a/arch/x86/kernel/microcode_amd.c
b/arch/x86/kernel/microcode_amd.c
index 366baa1..c205d37 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -156,8 +156,6 @@ static int apply_microcode_amd(int cpu)
 	printk(KERN_INFO "microcode: CPU%d: updated (new patch_level=0x%x)\n",
 	       cpu, rev);
 
-	uci->cpu_sig.rev = rev;
-
 	return 0;
 }
 
@@ -249,14 +247,18 @@ static enum ucode_state
 generic_load_microcode(int cpu, const u8 *data, size_t size)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct cpu_signature cpu_sig;
 	const u8 *ucode_ptr = data;
-	void *new_mc = NULL;
-	void *mc;
-	int new_rev = uci->cpu_sig.rev;
-	unsigned int leftover;
+	void *new_mc = NULL, *mc;
+	unsigned int leftover, new_rev;
 	unsigned long offset;
 	enum ucode_state state = UCODE_OK;
 
+	if (collect_cpu_info_amd(cpu, &cpu_sig))
+		return UCODE_ERROR;
+
+	new_rev = cpu_sig.rev;
+
 	offset = install_equiv_cpu_table(ucode_ptr);
 	if (!offset) {
 		printk(KERN_ERR "microcode: failed to create "
@@ -293,7 +295,7 @@ generic_load_microcode(int cpu, const u8 *data,
size_t size)
 			uci->mc = new_mc;
 			pr_debug("microcode: CPU%d found a matching microcode "
 				 "update with version 0x%x (current=0x%x)\n",
-				 cpu, new_rev, uci->cpu_sig.rev);
+				 cpu, new_rev, cpu_sig.rev);
 		} else {
 			vfree(new_mc);
 			state = UCODE_ERROR;
diff --git a/arch/x86/kernel/microcode_core.c
b/arch/x86/kernel/microcode_core.c
index 378e9a8..b7ead3a 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -138,20 +138,6 @@ static int collect_cpu_info_on_target(int cpu,
struct cpu_signature *cpu_sig)
 	return ret;
 }
 
-static int collect_cpu_info(int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	int ret;
-
-	memset(uci, 0, sizeof(*uci));
-
-	ret = collect_cpu_info_on_target(cpu, &uci->cpu_sig);
-	if (!ret)
-		uci->valid = 1;
-
-	return ret;
-}
-
 struct apply_microcode_ctx {
 	int err;
 };
@@ -182,12 +168,8 @@ static int do_microcode_update(const void __user
*buf, size_t size)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 		enum ucode_state ustate;
 
-		if (!uci->valid)
-			continue;
-
 		ustate = microcode_ops->request_microcode_user(cpu, buf, size);
 		if (ustate == UCODE_ERROR) {
 			error = -1;
@@ -269,23 +251,16 @@ static struct platform_device	*microcode_pdev;
 
 static int reload_for_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	int err = 0;
+	enum ucode_state ustate;
 
 	mutex_lock(&microcode_mutex);
-	if (uci->valid) {
-		enum ucode_state ustate;
 
-		ustate = microcode_ops->request_microcode_fw(cpu,
&microcode_pdev->dev);
-		if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
-		else
-			if (ustate == UCODE_ERROR)
-				err = -EINVAL;
-	}
+	ustate = microcode_ops->request_microcode_fw(cpu,
&microcode_pdev->dev);
+	if (ustate == UCODE_OK)
+		apply_microcode_on_target(cpu);
 	mutex_unlock(&microcode_mutex);
 
-	return err;
+	return (ustate == UCODE_ERROR)? -EINVAL : 0;
 }
 
 static ssize_t reload_store(struct sys_device *dev,
@@ -317,17 +292,23 @@ static ssize_t reload_store(struct sys_device
*dev,
 static ssize_t version_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct cpu_signature cpu_sig;
 
-	return sprintf(buf, "0x%x\n", uci->cpu_sig.rev);
+	if (collect_cpu_info_on_target(dev->id, &cpu_sig))
+		return 0;
+
+	return sprintf(buf, "0x%x\n", cpu_sig.rev);
 }
 
 static ssize_t pf_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct cpu_signature cpu_sig;
+
+	if (collect_cpu_info_on_target(dev->id, &cpu_sig))
+		return 0;
 
-	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
+	return sprintf(buf, "0x%x\n", cpu_sig.pf);
 }
 
 static SYSDEV_ATTR(reload, 0200, NULL, reload_store);
@@ -348,10 +329,7 @@ static struct attribute_group mc_attr_group = {
 
 static void microcode_fini_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
 	microcode_ops->microcode_fini_cpu(cpu);
-	uci->valid = 0;
 }
 
 static enum ucode_state microcode_resume_cpu(int cpu)
@@ -369,10 +347,10 @@ static enum ucode_state microcode_resume_cpu(int
cpu)
 
 static enum ucode_state microcode_init_cpu(int cpu)
 {
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
-	if (collect_cpu_info(cpu))
-		return UCODE_ERROR;
+	memset(uci, 0, sizeof(*uci));
 
 	/* --dimm. Trigger a delayed update? */
 	if (system_state != SYSTEM_RUNNING)
@@ -388,19 +366,6 @@ static enum ucode_state microcode_init_cpu(int cpu)
 	return ustate;
 }
 
-static enum ucode_state microcode_update_cpu(int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	enum ucode_state ustate;
-
-	if (uci->valid)
-		ustate = microcode_resume_cpu(cpu);
-	else
-		ustate = microcode_init_cpu(cpu);
-
-	return ustate;
-}
-
 static int mc_sysdev_add(struct sys_device *sys_dev)
 {
 	int err, cpu = sys_dev->id;
@@ -450,7 +415,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
 	 */
 	WARN_ON(cpu != 0);
 
-	if (uci->valid && uci->mc)
+	if (uci->mc)
 		microcode_ops->apply_microcode(cpu);
 
 	return 0;
@@ -472,7 +437,10 @@ mc_cpu_callback(struct notifier_block *nb, unsigned
long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		microcode_update_cpu(cpu);
+		if (action == CPU_ONLINE_FROZEN)
+			microcode_resume_cpu(cpu);
+		else
+			microcode_init_cpu(cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("microcode: CPU%d added\n", cpu);
diff --git a/arch/x86/kernel/microcode_intel.c
b/arch/x86/kernel/microcode_intel.c
index 0d334dd..6589765 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -339,8 +339,6 @@ static int apply_microcode(int cpu)
 		mc_intel->hdr.date >> 24,
 		(mc_intel->hdr.date >> 16) & 0xff);
 
-	uci->cpu_sig.rev = val[1];
-
 	return 0;
 }
 
@@ -348,11 +346,16 @@ static enum ucode_state generic_load_microcode(int
cpu, void *data, size_t size,
 				int (*get_ucode_data)(void *, const void *, size_t))
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct cpu_signature cpu_sig;
 	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
-	int new_rev = uci->cpu_sig.rev;
-	unsigned int leftover = size;
+	unsigned int leftover = size, new_rev;
 	enum ucode_state state = UCODE_OK;
 
+	if (collect_cpu_info(cpu, &cpu_sig))
+		return UCODE_ERROR;
+
+	new_rev = cpu_sig.rev;
+
 	while (leftover) {
 		struct microcode_header_intel mc_header;
 		unsigned int mc_size;
@@ -377,7 +380,7 @@ static enum ucode_state generic_load_microcode(int
cpu, void *data, size_t size,
 			break;
 		}
 
-		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
+		if (get_matching_microcode(&cpu_sig, mc, new_rev)) {
 			if (new_mc)
 				vfree(new_mc);
 			new_rev = mc_header.rev;
@@ -407,7 +410,7 @@ static enum ucode_state generic_load_microcode(int
cpu, void *data, size_t size,
 
 	pr_debug("microcode: CPU%d found a matching microcode update with"
 		 " version 0x%x (current=0x%x)\n",
-			cpu, new_rev, uci->cpu_sig.rev);
+			cpu, new_rev, cpu_sig.rev);
 out:
 	return state;
 }



