Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbYHCQGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbYHCQGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 12:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbYHCQGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 12:06:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:49762 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbYHCQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 12:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IY2IRqO3lCaq9mWGPVVDfiIk4gBJhaCtGDVaduApuM0x+BZZ+gR4fZS1ZqhXggOabP
         /StbWYU9lPo4ooiLkLmn2ucvw8yhB7/ST9WEZA3gm08kQW8O1jXV6ItEhWHt7/a0hGS+
         17r1f2sKSbCpgLqp87idBAGtPz7VhdPz/dwxc=
Subject: [rfc-patch, bugfix 2/2] x86-microcode: run ucode-updates via
	workqueue
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Oruba <peter.oruba@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Max Krasnyansky <maxk@qualcomm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 18:06:02 +0200
Message-Id: <1217779562.4912.63.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Run ucode-updates via workqueue (keventd) instead of using set_cpus_allowed_ptr()
in cpu-hotplug handlers.

The target 'cpu' is not yet 'active' when set_cpu_allowed_ptr() gets called from
mc_cpu_callback() (i.e. tasks can't be migrated onto it).
This caused a bug#11197: http://www.ussg.iu.edu/hypermail/linux/kernel/0807.3/3791.html)


(Almost)-Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

commit 242f1830266d714f0b8a2796eb9b239e0eeca2e7
Author: dimm <dimm@earth.(none)>
Date:   Sun Aug 3 16:58:30 2008 +0200

    microcode: workqueue support

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index f9447ba..dab52ff 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -89,6 +89,7 @@
 #include <linux/cpu.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <linux/workqueue.h>
 
 #include <asm/msr.h>
 #include <asm/uaccess.h>
@@ -124,14 +125,24 @@ static DEFINE_SPINLOCK(microcode_update_lock);
 /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
 static DEFINE_MUTEX(microcode_mutex);
 
-static struct ucode_cpu_info {
+struct ucode_cpu_info {
 	int valid;
-	int resume;
 	unsigned int sig;
 	unsigned int pf;
 	unsigned int rev;
 	microcode_t *mc;
-} ucode_cpu_info[NR_CPUS];
+};
+
+static struct ucode_work_info {
+	struct ucode_cpu_info uci;
+	int resume;
+	struct work_struct work;
+} ucode_work_info[NR_CPUS];
+
+static inline struct ucode_cpu_info *get_ucode_cpu_info(int cpu)
+{
+	return &ucode_work_info[cpu].uci;
+}
 
 static void collect_cpu_info(int cpu_num, struct ucode_cpu_info *uci)
 {
@@ -172,7 +183,7 @@ static void collect_cpu_info(int cpu_num, struct ucode_cpu_info *uci)
 static inline int microcode_update_match(int cpu_num,
 	microcode_header_t *mc_header, int sig, int pf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu_num);
 
 	if (!sigmatch(sig, uci->sig, pf, uci->pf)
 		|| mc_header->rev <= uci->rev)
@@ -266,7 +277,7 @@ static int microcode_sanity_check(void *mc)
  */
 static int get_maching_microcode(void *mc, int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
 	microcode_header_t *mc_header = mc;
 	struct extended_sigtable *ext_header;
 	unsigned long total_size = get_totalsize(mc_header);
@@ -313,7 +324,7 @@ static void apply_microcode(int cpu)
 	unsigned long flags;
 	unsigned int val[2];
 	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu_num);
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -400,7 +411,7 @@ static int do_microcode_update (void)
 		 * lets keep searching till the latest version
 		 */
 		for_each_online_cpu(cpu) {
-			struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+			struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
 
 			if (!uci->valid)
 				continue;
@@ -571,34 +582,39 @@ static int cpu_request_microcode(int cpu)
 
 static void microcode_fini_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
 
 	mutex_lock(&microcode_mutex);
-	uci->valid = 0;
-	uci->resume = 0;
-	vfree(uci->mc);
-	uci->mc = NULL;
+	wi->uci.valid = 0;
+	vfree(wi->uci.mc);
+	wi->uci.mc = NULL;
+	wi->resume = 0;
 	mutex_unlock(&microcode_mutex);
 }
 
 static void microcode_set_cpu_frozen(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
+
+	pr_debug("microcode: CPU%d frozen\n", cpu);
 
 	mutex_lock(&microcode_mutex);
-	if (uci->valid)
-		uci->resume = 1;
+	if (wi->uci.valid)
+		wi->resume = 1;
 	mutex_unlock(&microcode_mutex);
 }
 
 static int microcode_resume_cpu(int cpu, struct ucode_cpu_info *new_uci)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
+	struct ucode_cpu_info *uci = &wi->uci;
 
-	if (!uci->resume)
+	if (!wi->resume)
 		return 0;
 
-	uci->resume = 0;
+	pr_debug("microcode: CPU%d resumed (ucode: %p)\n", cpu, uci->mc);
+
+	wi->resume = 0;
 
 	/* Check if the 'cached' microcode is ok: */
 	if (!uci->mc)
@@ -616,10 +632,13 @@ static int microcode_resume_cpu(int cpu, struct ucode_cpu_info *new_uci)
 	return 1;
 }
 
-void microcode_update_cpu(int cpu)
+static void microcode_update_cpu(struct work_struct *w)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu, 
-			      new_uci;
+	struct ucode_work_info *wi = container_of(w, struct ucode_work_info, work);
+	int cpu = raw_smp_processor_id(); /* keventd is per-cpu */
+ 	struct ucode_cpu_info new_uci;
+
+	pr_debug("microcode: CPU%d workqueue\n", cpu);
 
 	memset(&new_uci, 0, sizeof(new_uci));
 
@@ -632,7 +651,7 @@ void microcode_update_cpu(int cpu)
 		 * otherwise just request a firmware:
 		 */
 		if (!microcode_resume_cpu(cpu, &new_uci)) {
-			*uci = new_uci;
+			wi->uci = new_uci;
 
 			if (system_state == SYSTEM_RUNNING)
 				cpu_request_microcode(cpu);
@@ -641,20 +660,11 @@ void microcode_update_cpu(int cpu)
 	mutex_unlock(&microcode_mutex);
 }
 
-static void microcode_init_cpu(int cpu)
-{
-	cpumask_t old = current->cpus_allowed;
-
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	microcode_update_cpu(cpu);
-	set_cpus_allowed_ptr(current, &old);
-}
-
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
 			    const char *buf, size_t sz)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(dev->id);
 	char *end;
 	unsigned long val = simple_strtoul(buf, &end, 0);
 	int err = 0;
@@ -684,7 +694,7 @@ static ssize_t reload_store(struct sys_device *dev,
 static ssize_t version_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(dev->id);
 
 	return sprintf(buf, "0x%x\n", uci->rev);
 }
@@ -692,7 +702,7 @@ static ssize_t version_show(struct sys_device *dev,
 static ssize_t pf_show(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(dev->id);
 
 	return sprintf(buf, "0x%x\n", uci->pf);
 }
@@ -716,19 +726,19 @@ static struct attribute_group mc_attr_group = {
 static int mc_sysdev_add(struct sys_device *sys_dev)
 {
 	int err, cpu = sys_dev->id;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_work_info *wi = ucode_work_info + cpu;
 
 	if (!cpu_online(cpu))
 		return 0;
 
 	pr_debug("microcode: CPU%d added\n", cpu);
-	memset(uci, 0, sizeof(*uci));
+	memset(&wi->uci, 0, sizeof(wi->uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu);
+	schedule_work_on(cpu, &wi->work);
 
 	return 0;
 }
@@ -774,6 +784,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		schedule_work_on(cpu, &ucode_work_info[cpu].work);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
@@ -784,6 +795,7 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		cancel_work_sync(&ucode_work_info[cpu].work);
 		break;
 	case CPU_DEAD:
 	case CPU_UP_CANCELED_FROZEN:
@@ -803,7 +815,7 @@ static struct notifier_block __refdata mc_cpu_notifier = {
 
 static int __init microcode_init (void)
 {
-	int error;
+	int error, i;
 
 	printk(KERN_INFO
 		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
@@ -818,6 +830,9 @@ static int __init microcode_init (void)
 		return PTR_ERR(microcode_pdev);
 	}
 
+	for (i = 0; i < NR_CPUS; i++)
+		INIT_WORK(&ucode_work_info[i].work, microcode_update_cpu);
+
 	get_online_cpus();
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
 	put_online_cpus();


