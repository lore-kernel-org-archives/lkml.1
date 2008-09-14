Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYINJO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYINJO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYINJOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:14:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:17047 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYINJOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=akwIkzGb2HCZ9YFokLZ0k7kHlO2BPnr11Swukq/3FeqwjmOb879kYDEbM4iycipD4w
         CCFbHKw0J+BF26Z/udf33fU6moEczgQNwtg76QQLBcuxuOrIs2xHazEi9qf1auZsAmXU
         QpbhjKdxufvNrOGA92rbj/ef1T6K606KWcEeQ=
Subject: [x86-tip, patch] rework of the microcode splitup
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Oruba <peter.oruba@amd.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 14 Sep 2008 11:14:08 +0200
Message-Id: <1221383648.6184.28.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, Peter,


this version is slightly different from the current one in -tip (added missing vfree()).

I have tested it only with "microcode_ctl" (update via /dev/cpu/microcode).

Since my CPUs already have the revision equal to the recent microcode revision
from Intel, I temporarily altered the logic of checks in order to verify that
the correct microcode file is found and applied. That proved to work well.

Peter: please take a look at the "microcode_amd" part, esp. 2 "FIXME" notes.


todo (not dependent on this patch):
- perhaps, move arch-specific structures from microcode.h to arch-specific *.c files;
- remove union in struct ucode_cpu_info;
- see how we could apply microcode as early as possible;
- don't use set_cpus_allowed()

anyway, I think this new interface is cleaner and better maintainability-wise.

4 files changed, 304 insertions(+), 362 deletions(-)

---

From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: x86-microcode, rework of the microcode splitup

x86, microcode rework, v2
    
this is a rework of the microcode splitup in tip/x86/microcode
    
This new interface is supposed to be cleaner and better maintainability-wise;

4 files changed, 304 insertions(+), 362 deletions(-)


--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -70,8 +70,9 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
-
-/* #define DEBUG pr_debug */
+#if 0
+#define DEBUG /* pr_debug */
+#endif
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -110,50 +111,28 @@ struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
-void __user *user_buffer;		/* user area microcode data buffer */
-EXPORT_SYMBOL_GPL(user_buffer);
-unsigned int user_buffer_size;		/* it's size */
-EXPORT_SYMBOL_GPL(user_buffer_size);
-
-static int do_microcode_update(void)
+static int do_microcode_update(const void __user *buf, size_t size)
 {
-	long cursor = 0;
+	cpumask_t old;
 	int error = 0;
-	void *new_mc = NULL;
 	int cpu;
-	cpumask_t old;
 
 	old = current->cpus_allowed;
 
-	while ((cursor = microcode_ops->get_next_ucode(&new_mc, cursor)) > 0) {
-		if (microcode_ops->microcode_sanity_check != NULL)
-			error = microcode_ops->microcode_sanity_check(new_mc);
-		if (error)
+	for_each_online_cpu(cpu) {
+		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+		if (!uci->valid)
+			continue;
+
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		error = microcode_ops->request_microcode_user(cpu, buf, size);
+		if (error < 0)
 			goto out;
-		/*
-		 * It's possible the data file has multiple matching ucode,
-		 * lets keep searching till the latest version
-		 */
-		for_each_online_cpu(cpu) {
-			struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-			if (!uci->valid)
-				continue;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-			error = microcode_ops->get_matching_microcode(new_mc,
-								      cpu);
-			if (error < 0)
-				goto out;
-			if (error == 1)
-				microcode_ops->apply_microcode(cpu);
-		}
-		vfree(new_mc);
+		if (!error)
+			microcode_ops->apply_microcode(cpu);
 	}
 out:
-	if (cursor > 0)
-		vfree(new_mc);
-	if (cursor < 0)
-		error = cursor;
 	set_cpus_allowed_ptr(current, &old);
 	return error;
 }
@@ -178,10 +157,7 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-	user_buffer = (void __user *) buf;
-	user_buffer_size = (int) len;
-
-	ret = do_microcode_update();
+	ret = do_microcode_update(buf, len);
 	if (!ret)
 		ret = (ssize_t)len;
 
@@ -231,7 +207,6 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 
 /* fake device for request_firmware */
 struct platform_device *microcode_pdev;
-EXPORT_SYMBOL_GPL(microcode_pdev);
 
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
@@ -252,8 +227,12 @@ static ssize_t reload_store(struct sys_device *dev,
 		if (cpu_online(cpu)) {
 			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 			mutex_lock(&microcode_mutex);
-			if (uci->valid)
-				err = microcode_ops->cpu_request_microcode(cpu);
+			if (uci->valid) {
+				err = microcode_ops->request_microcode_fw(cpu,
+						&microcode_pdev->dev);
+				if (!err)
+					microcode_ops->apply_microcode(cpu);
+			}
 			mutex_unlock(&microcode_mutex);
 			set_cpus_allowed_ptr(current, &old);
 		}
@@ -315,7 +294,7 @@ static void collect_cpu_info(int cpu)
 		uci->valid = 1;
 }
 
-static void microcode_resume_cpu(int cpu)
+static int microcode_resume_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct cpu_signature nsig;
@@ -323,7 +302,7 @@ static void microcode_resume_cpu(int cpu)
 	pr_debug("microcode: CPU%d resumed\n", cpu);
 
 	if (!uci->mc.valid_mc)
-		return;
+		return 1;
 
 	/*
 	 * Let's verify that the 'cached' ucode does belong
@@ -331,21 +310,22 @@ static void microcode_resume_cpu(int cpu)
 	 */
 	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
 		microcode_fini_cpu(cpu);
-		return;
+		return -1;
 	}
 
 	if (memcmp(&nsig, &uci->cpu_sig, sizeof(nsig))) {
 		microcode_fini_cpu(cpu);
 		/* Should we look for a new ucode here? */
-		return;
+		return 1;
 	}
 
-	microcode_ops->apply_microcode(cpu);
+	return 0;
 }
 
 void microcode_update_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	int err = 0;
 
 	/* We should bind the task to the CPU */
 	BUG_ON(raw_smp_processor_id() != cpu);
@@ -356,12 +336,17 @@ void microcode_update_cpu(int cpu)
 	 * otherwise just request a firmware:
 	 */
 	if (uci->valid) {
-		microcode_resume_cpu(cpu);
+		err = microcode_resume_cpu(cpu);
 	} else {	
 		collect_cpu_info(cpu);
 		if (uci->valid && system_state == SYSTEM_RUNNING)
-			microcode_ops->cpu_request_microcode(cpu);
+			err = microcode_ops->request_microcode_fw(cpu,
+					&microcode_pdev->dev);
 	}
+
+	if (!err)
+		microcode_ops->apply_microcode(cpu);
+
 	mutex_unlock(&microcode_mutex);
 }
 
@@ -412,9 +397,9 @@ static int mc_sysdev_resume(struct sys_device *dev)
 
 	if (!cpu_online(cpu))
 		return 0;
-	pr_debug("microcode: CPU%d resumed\n", cpu);
+
 	/* only CPU 0 will apply ucode here */
-	microcode_ops->apply_microcode(0);
+	microcode_update_cpu(0);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index d606a05..48aec9f 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -59,7 +59,7 @@ MODULE_LICENSE("GPL v2");
 /* serialize access to the physical write */
 static DEFINE_SPINLOCK(microcode_update_lock);
 
-struct equiv_cpu_entry *equiv_cpu_table;
+static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
@@ -83,36 +83,37 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 	return 0;
 }
 
-static int get_matching_microcode_amd(void *mc, int cpu)
+static int get_matching_microcode(int cpu, void *mc, int rev)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct microcode_header_amd *mc_header = mc;
-	unsigned long total_size = get_totalsize(mc_header);
-	void *new_mc;
 	struct pci_dev *nb_pci_dev, *sb_pci_dev;
 	unsigned int current_cpu_id;
 	unsigned int equiv_cpu_id = 0x00;
 	unsigned int i = 0;
 
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
-	/* This is a tricky part. We might be called from a write operation */
-	/* to the device file instead of the usual process of firmware */
-	/* loading. This routine needs to be able to distinguish both */
-/* cases. This is done by checking if there alread is a equivalent */
-	/* CPU table installed. If not, we're written through */
-	/* /dev/cpu/microcode. */
-/* Since we ignore all checks. The error case in which going through */
-/* firmware loading and that table is not loaded has already been */
-	/* checked earlier. */
+	/*
+	 * FIXME! dimm: do we need this? Why an update via /dev/... is different
+	 * from the one via firmware?
+	 *
+	 * This is a tricky part. We might be called from a write operation
+	 * to the device file instead of the usual process of firmware
+	 * loading. This routine needs to be able to distinguish both
+	 * cases. This is done by checking if there alread is a equivalent
+	 * CPU table installed. If not, we're written through
+	 * /dev/cpu/microcode.
+	 * Since we ignore all checks. The error case in which going through
+	 * firmware loading and that table is not loaded has already been
+	 * checked earlier.
+	 */
+	BUG_ON(equiv_cpu_table == NULL);
+#if 0
 	if (equiv_cpu_table == NULL) {
 		printk(KERN_INFO "microcode: CPU%d microcode update with "
 		       "version 0x%x (current=0x%x)\n",
 		       cpu, mc_header->patch_id, uci->cpu_sig.rev);
 		goto out;
 	}
-
+#endif
 	current_cpu_id = cpuid_eax(0x00000001);
 
 	while (equiv_cpu_table[i].installed_cpu != 0) {
@@ -175,27 +176,9 @@ static int get_matching_microcode_amd(void *mc, int cpu)
 		pci_dev_put(sb_pci_dev);
 	}
 
-	if (mc_header->patch_id <= uci->cpu_sig.rev)
+	if (mc_header->patch_id <= rev)
 		return 0;
 
-	printk(KERN_INFO "microcode: CPU%d found a matching microcode "
-	       "update with version 0x%x (current=0x%x)\n",
-	       cpu, mc_header->patch_id, uci->cpu_sig.rev);
-
-out:
-	new_mc = vmalloc(UCODE_MAX_SIZE);
-	if (!new_mc) {
-		printk(KERN_ERR "microcode: error, can't allocate memory\n");
-		return -ENOMEM;
-	}
-	memset(new_mc, 0, UCODE_MAX_SIZE);
-
-	/* free previous update file */
-	vfree(uci->mc.mc_amd);
-
-	memcpy(new_mc, mc, total_size);
-
-	uci->mc.mc_amd = new_mc;
 	return 1;
 }
 
@@ -245,104 +228,65 @@ static void apply_microcode_amd(int cpu)
 	uci->cpu_sig.rev = rev;
 }
 
-#ifdef CONFIG_MICROCODE_OLD_INTERFACE
-extern void __user *user_buffer;        /* user area microcode data buffer */
-extern unsigned int user_buffer_size;   /* it's size */
-
-static long get_next_ucode_amd(void **mc, long offset)
-{
-	struct microcode_header_amd mc_header;
-	unsigned long total_size;
-
-	/* No more data */
-	if (offset >= user_buffer_size)
-		return 0;
-	if (copy_from_user(&mc_header, user_buffer + offset, MC_HEADER_SIZE)) {
-		printk(KERN_ERR "microcode: error! Can not read user data\n");
-		return -EFAULT;
-	}
-	total_size = get_totalsize(&mc_header);
-	if (offset + total_size > user_buffer_size) {
-		printk(KERN_ERR "microcode: error! Bad total size in microcode "
-		       "data file\n");
-		return -EINVAL;
-	}
-	*mc = vmalloc(UCODE_MAX_SIZE);
-	if (!*mc)
-		return -ENOMEM;
-	memset(*mc, 0, UCODE_MAX_SIZE);
-
-	if (copy_from_user(*mc, user_buffer + offset, total_size)) {
-		printk(KERN_ERR "microcode: error! Can not read user data\n");
-		vfree(*mc);
-		return -EFAULT;
-	}
-	return offset + total_size;
-}
-#else
-#define get_next_ucode_amd() NULL
-#endif
-
-static long get_next_ucode_from_buffer_amd(void **mc, void *buf,
-				       unsigned long size, long offset)
+static void * get_next_ucode(u8 *buf, unsigned int size,
+			int (*get_ucode_data)(void *, const void *, size_t),
+			unsigned int *mc_size)
 {
-	struct microcode_header_amd *mc_header;
-	unsigned long total_size;
-	unsigned char *buf_pos = buf;
+	unsigned int total_size;
+#define UCODE_UNKNOWN_HDR	8
+	u8 hdr[UCODE_UNKNOWN_HDR];
+	void *mc;
 
-	/* No more data */
-	if (offset >= size)
-		return 0;
+	if (get_ucode_data(hdr, buf, UCODE_UNKNOWN_HDR))
+		return NULL;
 
-	if (buf_pos[offset] != UCODE_UCODE_TYPE) {
+	if (hdr[0] != UCODE_UCODE_TYPE) {
 		printk(KERN_ERR "microcode: error! "
 		       "Wrong microcode payload type field\n");
-		return -EINVAL;
+		return NULL;
 	}
 
-	mc_header = (struct microcode_header_amd *)(&buf_pos[offset+8]);
+	/* FIXME! dimm: Why not by means of get_totalsize(hdr)? */
+	total_size = (unsigned long) (hdr[4] + (hdr[5] << 8));
 
-	total_size = (unsigned long) (buf_pos[offset+4] +
-				      (buf_pos[offset+5] << 8));
+	printk(KERN_INFO "microcode: size %u, total_size %u\n",
+		size, total_size);
 
-	printk(KERN_INFO "microcode: size %lu, total_size %lu, offset %ld\n",
-		size, total_size, offset);
-
-	if (offset + total_size > size) {
+	if (total_size > size || total_size > UCODE_MAX_SIZE) {
 		printk(KERN_ERR "microcode: error! Bad data in microcode data file\n");
-		return -EINVAL;
+		return NULL;
 	}
 
-	*mc = vmalloc(UCODE_MAX_SIZE);
-	if (!*mc) {
-		printk(KERN_ERR "microcode: error! "
-		       "Can not allocate memory for microcode patch\n");
-		return -ENOMEM;
+	mc = vmalloc(UCODE_MAX_SIZE);
+	if (mc) {
+		memset(mc, 0, UCODE_MAX_SIZE);
+		if (get_ucode_data(mc, buf + UCODE_UNKNOWN_HDR, total_size)) {
+			vfree(mc);
+			mc = NULL;
+		} else
+			*mc_size = total_size + UCODE_UNKNOWN_HDR;
 	}
-
-	memset(*mc, 0, UCODE_MAX_SIZE);
-	memcpy(*mc, buf + offset + 8, total_size);
-
-	return offset + total_size + 8;
+#undef UCODE_UNKNOWN_HDR
+	return mc;
 }
 
-static long install_equiv_cpu_table(void *buf, unsigned long size, long offset)
+
+static int install_equiv_cpu_table(u8 *buf,
+		int (*get_ucode_data)(void *, const void *, size_t))
 {
-	unsigned int *buf_pos = buf;
+#define UCODE_HEADER_SIZE	12
+	u8 *hdr[UCODE_HEADER_SIZE];
+	unsigned int *buf_pos = (unsigned int *)hdr;
+	unsigned long size;
 
-	/* No more data */
-	if (offset >= size)
+	if (get_ucode_data(&hdr, buf, UCODE_HEADER_SIZE))
 		return 0;
 
-	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE) {
-		printk(KERN_ERR "microcode: error! "
-		       "Wrong microcode equivalnet cpu table type field\n");
-		return 0;
-	}
+	size = buf_pos[2];
 
-	if (size == 0) {
+	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
 		printk(KERN_ERR "microcode: error! "
-		       "Wrong microcode equivalnet cpu table length\n");
+		       "Wrong microcode equivalnet cpu table\n");
 		return 0;
 	}
 
@@ -352,79 +296,120 @@ static long install_equiv_cpu_table(void *buf, unsigned long size, long offset)
 		return 0;
 	}
 
-	memset(equiv_cpu_table, 0, size);
-	memcpy(equiv_cpu_table, &buf_pos[3], size);
+	buf += UCODE_HEADER_SIZE;
+	if (get_ucode_data(equiv_cpu_table, buf, size)) {
+		vfree(equiv_cpu_table);
+		return 0;
+	}
 
-	return size + 12; /* add header length */
+	return size + UCODE_HEADER_SIZE; /* add header length */
+#undef UCODE_HEADER_SIZE
 }
 
-/* fake device for request_firmware */
-extern struct platform_device *microcode_pdev;
-
-static int cpu_request_microcode_amd(int cpu)
+static void free_equiv_cpu_table(void)
 {
-	char name[30];
-	const struct firmware *firmware;
-	void *buf;
-	unsigned int *buf_pos;
-	unsigned long size;
-	long offset = 0;
-	int error;
-	void *mc;
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-
-	sprintf(name, "amd-ucode/microcode_amd.bin");
-	error = request_firmware(&firmware, "amd-ucode/microcode_amd.bin",
-				 &microcode_pdev->dev);
-	if (error) {
-		printk(KERN_ERR "microcode: ucode data file %s load failed\n",
-		       name);
-		return error;
-	}
-
-	buf_pos = (unsigned int *)firmware->data;
-	buf = (void *)firmware->data;
-	size = firmware->size;
-
-	if (buf_pos[0] != UCODE_MAGIC) {
-		printk(KERN_ERR "microcode: error! Wrong microcode patch file magic\n");
-		return -EINVAL;
+	if (equiv_cpu_table) {
+		vfree(equiv_cpu_table);
+		equiv_cpu_table = NULL;
 	}
+}
 
-	offset = install_equiv_cpu_table(buf, buf_pos[2], offset);
+static int generic_load_microcode(int cpu, void *data, size_t size,
+		int (*get_ucode_data)(void *, const void *, size_t))
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
+	int new_rev = uci->cpu_sig.rev;
+	unsigned int leftover;
+	unsigned long offset;
 
+	offset = install_equiv_cpu_table(ucode_ptr, get_ucode_data);
 	if (!offset) {
 		printk(KERN_ERR "microcode: installing equivalent cpu table failed\n");
 		return -EINVAL;
 	}
 
-	while ((offset =
-		get_next_ucode_from_buffer_amd(&mc, buf, size, offset)) > 0) {
-		error = get_matching_microcode_amd(mc, cpu);
-		if (error < 0)
+	ucode_ptr += offset;
+	leftover = size - offset;
+
+	while (leftover) {
+		unsigned int mc_size;
+		struct microcode_header_amd *mc_header;
+
+		mc = get_next_ucode(ucode_ptr, leftover, get_ucode_data, &mc_size);
+		if (!mc)
 			break;
-		/*
-		 * It's possible the data file has multiple matching ucode,
-		 * lets keep searching till the latest version
-		 */
-		if (error == 1) {
-			apply_microcode_amd(cpu);
-			error = 0;
-		}
-		vfree(mc);
+
+		mc_header = (struct microcode_header_amd *)mc;
+		if (get_matching_microcode(cpu, mc, new_rev)) {
+			if (new_mc)
+				vfree(new_mc);
+			new_rev = mc_header->patch_id;
+			new_mc  = mc;
+		} else 
+			vfree(mc);
+
+		ucode_ptr += mc_size;
+		leftover  -= mc_size;
 	}
-	if (offset > 0) {
-		vfree(mc);
-		vfree(equiv_cpu_table);
-		equiv_cpu_table = NULL;
+
+	if (new_mc) {
+		if (!leftover) {
+			if (uci->mc.mc_amd)
+				vfree(uci->mc.mc_amd);
+			uci->mc.mc_amd = (struct microcode_amd *)new_mc;
+			pr_debug("microcode: CPU%d found a matching microcode update with"
+				" version 0x%x (current=0x%x)\n",
+				cpu, uci->mc.mc_amd->hdr.patch_id, uci->cpu_sig.rev);
+		} else
+			vfree(new_mc);
+	}
+
+	free_equiv_cpu_table();
+
+	return (int)leftover;
+}
+
+static int get_ucode_fw(void *to, const void *from, size_t n)
+{
+	memcpy(to, from, n);
+	return 0;
+}
+
+static int request_microcode_fw(int cpu, struct device *device)
+{
+	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	const struct firmware *firmware;
+	int ret;
+
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu != raw_smp_processor_id());
+
+	ret = request_firmware(&firmware, fw_name, device);
+	if (ret) {
+		printk(KERN_ERR "microcode: ucode data file %s load failed\n", fw_name);
+		return ret;
 	}
-	if (offset < 0)
-		error = offset;
+
+	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
+			&get_ucode_fw);
+
 	release_firmware(firmware);
 
-	return error;
+	return ret;
+}
+
+static int get_ucode_user(void *to, const void *from, size_t n)
+{
+	return copy_from_user(to, from, n);
+}
+
+static int request_microcode_user(int cpu, const void __user *buf, size_t size)
+{
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu != raw_smp_processor_id());
+
+	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
 }
 
 static void microcode_fini_cpu_amd(int cpu)
@@ -436,10 +421,8 @@ static void microcode_fini_cpu_amd(int cpu)
 }
 
 static struct microcode_ops microcode_amd_ops = {
-	.get_next_ucode                   = get_next_ucode_amd,
-	.get_matching_microcode           = get_matching_microcode_amd,
-	.microcode_sanity_check           = NULL,
-	.cpu_request_microcode            = cpu_request_microcode_amd,
+	.request_microcode_user           = request_microcode_user,
+	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info_amd,
 	.apply_microcode                  = apply_microcode_amd,
 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index c9b5320..f05a37e 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -70,8 +70,9 @@
  *		Fix sigmatch() macro to handle old CPUs with pf == 0.
  *		Thanks to Stuart Swales for pointing out this bug.
  */
-
-/* #define DEBUG */ /* pr_debug */
+#if 0
+#define DEBUG /* pr_debug */
+#endif
 #include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -155,15 +156,15 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 	return 0;
 }
 
-static inline int microcode_update_match(int cpu_num,
-	struct microcode_header_intel *mc_header, int sig, int pf)
+static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
+}
 
-	if (!sigmatch(sig, uci->cpu_sig.sig, pf, uci->cpu_sig.pf)
-		|| mc_header->rev <= uci->cpu_sig.rev)
-		return 0;
-	return 1;
+static inline int 
+update_match_revision(struct microcode_header_intel *mc_header,	int rev)
+{
+	return (mc_header->rev <= rev) ? 0 : 1;
 }
 
 static int microcode_sanity_check(void *mc)
@@ -248,51 +249,36 @@ static int microcode_sanity_check(void *mc)
 /*
  * return 0 - no update found
  * return 1 - found update
- * return < 0 - error
  */
-static int get_matching_microcode(void *mc, int cpu)
+static int
+get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header;
 	unsigned long total_size = get_totalsize(mc_header);
 	int ext_sigcount, i;
 	struct extended_signature *ext_sig;
-	void *new_mc;
 
-	if (microcode_update_match(cpu, mc_header,
-			mc_header->sig, mc_header->pf))
-		goto find;
+	if (!update_match_revision(mc_header, rev))
+		return 0;
+
+	if (update_match_cpu(cpu_sig, mc_header->sig, mc_header->pf))
+		return 1;
 
+	/* Look for ext. headers: */
 	if (total_size <= get_datasize(mc_header) + MC_HEADER_SIZE)
 		return 0;
 
 	ext_header = mc + get_datasize(mc_header) + MC_HEADER_SIZE;
 	ext_sigcount = ext_header->count;
 	ext_sig = (void *)ext_header + EXT_HEADER_SIZE;
+
 	for (i = 0; i < ext_sigcount; i++) {
-		if (microcode_update_match(cpu, mc_header,
-				ext_sig->sig, ext_sig->pf))
-			goto find;
+		if (update_match_cpu(cpu_sig, ext_sig->sig, ext_sig->pf))
+			return 1;
 		ext_sig++;
 	}
 	return 0;
-find:
-	pr_debug("microcode: CPU%d found a matching microcode update with"
-		 " version 0x%x (current=0x%x)\n",
-		 cpu, mc_header->rev, uci->cpu_sig.rev);
-	new_mc = vmalloc(total_size);
-	if (!new_mc) {
-		printk(KERN_ERR "microcode: error! Can not allocate memory\n");
-		return -ENOMEM;
-	}
-
-	/* free previous update file */
-	vfree(uci->mc.mc_intel);
-
-	memcpy(new_mc, mc, total_size);
-	uci->mc.mc_intel = new_mc;
-	return 1;
 }
 
 static void apply_microcode(int cpu)
@@ -300,7 +286,7 @@ static void apply_microcode(int cpu)
 	unsigned long flags;
 	unsigned int val[2];
 	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -338,116 +324,107 @@ static void apply_microcode(int cpu)
 	uci->cpu_sig.rev = val[1];
 }
 
-#ifdef CONFIG_MICROCODE_OLD_INTERFACE
-extern void __user *user_buffer;        /* user area microcode data buffer */
-extern unsigned int user_buffer_size;   /* it's size */
-
-static long get_next_ucode(void **mc, long offset)
+static int generic_load_microcode(int cpu, void *data, size_t size,
+		int (*get_ucode_data)(void *, const void *, size_t))
 {
-	struct microcode_header_intel mc_header;
-	unsigned long total_size;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
+	int new_rev = uci->cpu_sig.rev;
+	unsigned int leftover = size;
 
-	/* No more data */
-	if (offset >= user_buffer_size)
-		return 0;
-	if (copy_from_user(&mc_header, user_buffer + offset, MC_HEADER_SIZE)) {
-		printk(KERN_ERR "microcode: error! Can not read user data\n");
-		return -EFAULT;
-	}
-	total_size = get_totalsize(&mc_header);
-	if (offset + total_size > user_buffer_size) {
-		printk(KERN_ERR "microcode: error! Bad total size in microcode "
-				"data file\n");
-		return -EINVAL;
-	}
-	*mc = vmalloc(total_size);
-	if (!*mc)
-		return -ENOMEM;
-	if (copy_from_user(*mc, user_buffer + offset, total_size)) {
-		printk(KERN_ERR "microcode: error! Can not read user data\n");
-		vfree(*mc);
-		return -EFAULT;
-	}
-	return offset + total_size;
-}
-#endif
+	while (leftover) {
+		struct microcode_header_intel mc_header;
+		unsigned int mc_size;
 
-static long get_next_ucode_from_buffer(void **mc, const u8 *buf,
-	unsigned long size, long offset)
-{
-	struct microcode_header_intel *mc_header;
-	unsigned long total_size;
+		if (get_ucode_data(&mc_header, ucode_ptr, sizeof(mc_header)))
+			break;
 
-	/* No more data */
-	if (offset >= size)
-		return 0;
-	mc_header = (struct microcode_header_intel *)(buf + offset);
-	total_size = get_totalsize(mc_header);
+		mc_size = get_totalsize(&mc_header);
+		if (!mc_size || mc_size > leftover) {
+			printk(KERN_ERR "microcode: error!"
+					"Bad data in microcode data file\n");
+			break;
+		}
 
-	if (offset + total_size > size) {
-		printk(KERN_ERR "microcode: error! Bad data in microcode data file\n");
-		return -EINVAL;
+		mc = vmalloc(mc_size);
+		if (!mc)
+			break;
+
+		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
+		    microcode_sanity_check(mc) < 0) {
+			vfree(mc);
+			break;
+		}
+
+		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
+			if (new_mc)
+				vfree(new_mc);
+			new_rev = mc_header.rev;
+			new_mc  = mc;
+		} else
+			vfree(mc);
+
+		ucode_ptr += mc_size;
+		leftover  -= mc_size;
 	}
 
-	*mc = vmalloc(total_size);
-	if (!*mc) {
-		printk(KERN_ERR "microcode: error! Can not allocate memory\n");
-		return -ENOMEM;
+	if (new_mc) {
+		if (!leftover) {
+			if (uci->mc.mc_intel)
+				vfree(uci->mc.mc_intel);
+			uci->mc.mc_intel = (struct microcode_intel *)new_mc;
+			pr_debug("microcode: CPU%d found a matching microcode update with"
+				 " version 0x%x (current=0x%x)\n",
+				cpu, uci->mc.mc_intel->hdr.rev, uci->cpu_sig.rev);
+		} else
+			vfree(new_mc);
 	}
-	memcpy(*mc, buf + offset, total_size);
-	return offset + total_size;
+
+	return (int)leftover;
 }
 
-/* fake device for request_firmware */
-extern struct platform_device *microcode_pdev;
+static int get_ucode_fw(void *to, const void *from, size_t n)
+{
+	memcpy(to, from, n);
+	return 0;
+}
 
-static int cpu_request_microcode(int cpu)
+static int request_microcode_fw(int cpu, struct device *device)
 {
 	char name[30];
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	const struct firmware *firmware;
-	const u8 *buf;
-	unsigned long size;
-	long offset = 0;
-	int error;
-	void *mc;
+	int ret;
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu != raw_smp_processor_id());
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
 		c->x86, c->x86_model, c->x86_mask);
-	error = request_firmware(&firmware, name, &microcode_pdev->dev);
-	if (error) {
+	ret = request_firmware(&firmware, name, device);
+	if (ret) {
 		pr_debug("microcode: data file %s load failed\n", name);
-		return error;
+		return ret;
 	}
-	buf = firmware->data;
-	size = firmware->size;
-	while ((offset = get_next_ucode_from_buffer(&mc, buf, size, offset))
-			> 0) {
-		error = microcode_sanity_check(mc);
-		if (error)
-			break;
-		error = get_matching_microcode(mc, cpu);
-		if (error < 0)
-			break;
-		/*
-		 * It's possible the data file has multiple matching ucode,
-		 * lets keep searching till the latest version
-		 */
-		if (error == 1) {
-			apply_microcode(cpu);
-			error = 0;
-		}
-		vfree(mc);
-	}
-	if (offset > 0)
-		vfree(mc);
-	if (offset < 0)
-		error = offset;
+
+	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
+			&get_ucode_fw);
+
 	release_firmware(firmware);
 
-	return error;
+	return ret;
+}
+
+static int get_ucode_user(void *to, const void *from, size_t n)
+{
+	return copy_from_user(to, from, n);
+}
+
+static int request_microcode_user(int cpu, const void __user *buf, size_t size)
+{
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu != raw_smp_processor_id());
+
+	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
 }
 
 static void microcode_fini_cpu(int cpu)
@@ -459,10 +436,8 @@ static void microcode_fini_cpu(int cpu)
 }
 
 static struct microcode_ops microcode_intel_ops = {
-	.get_next_ucode                   = get_next_ucode,
-	.get_matching_microcode           = get_matching_microcode,
-	.microcode_sanity_check           = microcode_sanity_check,
-	.cpu_request_microcode            = cpu_request_microcode,
+	.request_microcode_user		  = request_microcode_user,
+	.request_microcode_fw             = request_microcode_fw,
 	.collect_cpu_info                 = collect_cpu_info,
 	.apply_microcode                  = apply_microcode,
 	.microcode_fini_cpu               = microcode_fini_cpu,
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 7ceff48..e2887fa 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -5,17 +5,16 @@ extern int microcode_init(void *opaque, struct module *module);
 extern void microcode_exit(void);
 
 struct cpu_signature;
+struct device;
 
 struct microcode_ops {
-	long (*get_next_ucode)(void **mc, long offset);
-	long (*microcode_get_next_ucode)(void **mc, long offset);
-	int (*get_matching_microcode)(void *mc, int cpu);
-	int (*microcode_sanity_check)(void *mc);
-	int (*cpu_request_microcode)(int cpu);
-	int (*collect_cpu_info)(int cpu_num, struct cpu_signature *csig);
-	void (*apply_microcode)(int cpu);
-	void (*microcode_fini_cpu)(int cpu);
-	void (*clear_patch)(void *data);
+	int  (*request_microcode_user) (int cpu, const void __user *buf, size_t size);
+	int  (*request_microcode_fw) (int cpu, struct device *device);
+
+	void (*apply_microcode) (int cpu);
+
+	int  (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
+	void (*microcode_fini_cpu) (int cpu);
 };
 
 struct microcode_header_intel {


