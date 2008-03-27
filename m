Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYC0Tw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYC0Tw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757633AbYC0Twu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:52:50 -0400
Received: from mail.bencastricum.nl ([213.84.203.196]:48057 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbYC0Twt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:52:49 -0400
Date: Thu, 27 Mar 2008 20:52:35 +0100 (CET)
From: Ben Castricum <lk08@bencastricum.nl>
X-X-Sender: benc@gateway.bencastricum.nl
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org
Subject: [TRIVIAL PATCH] Microcode: show results on success too
Message-ID: <alpine.LNX.1.10.0803272041450.11972@gateway.bencastricum.nl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Report when microcode was successfully updated. It used to be there but 
now with DEBUG unset it becomes very silent. Also some cosmetic fixes.

Signed-off-by: Ben Castricum <lk08@bencastricum.nl>

---

This is take 2 of the patch. Thanks for the feedback on the first one. It 
is now sent with a decent mailer. It is also a bit larger since I made the 
debug message more consistent.

Does anyone know if there are still plans on using the firmware loader for 
this? Last thing I could dig up on this subject is that we are waiting for 
some program to split up the large microcode.dat file into the ucode 
files.


diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index f2702d0..25cf6de 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -290,7 +290,7 @@ static int get_maching_microcode(void *m
 	}
 	return 0;
 find:
-	pr_debug("microcode: CPU %d found a matching microcode update with"
+	pr_debug("microcode: CPU%d found a matching microcode update with"
 		" version 0x%x (current=0x%x)\n", cpu, mc_header->rev,uci->rev);
 	new_mc = vmalloc(total_size);
 	if (!new_mc) {
@@ -336,11 +336,11 @@ static void apply_microcode(int cpu)
 
 	spin_unlock_irqrestore(&microcode_update_lock, flags);
 	if (val[1] != uci->mc->hdr.rev) {
-		printk(KERN_ERR "microcode: CPU%d updated from revision "
+		printk(KERN_ERR "microcode: CPU%d update from revision "
 			"0x%x to 0x%x failed\n", cpu_num, uci->rev, val[1]);
 		return;
 	}
-	pr_debug("microcode: CPU%d updated from revision "
+	printk(KERN_INFO "microcode: CPU%d updated from revision "
 	       "0x%x to 0x%x, date = %08x \n", 
 	       cpu_num, uci->rev, val[1], uci->mc->hdr.date);
 	uci->rev = val[1];
@@ -534,7 +534,7 @@ static int cpu_request_microcode(int cpu
 		c->x86, c->x86_model, c->x86_mask);
 	error = request_firmware(&firmware, name, &microcode_pdev->dev);
 	if (error) {
-		pr_debug("ucode data file %s load failed\n", name);
+		pr_debug("microcode: ucode data file %s load failed\n", name);
 		return error;
 	}
 	buf = firmware->data;
@@ -709,7 +709,7 @@ static int __mc_sysdev_add(struct sys_de
 	if (!cpu_online(cpu))
 		return 0;
 
-	pr_debug("Microcode:CPU %d added\n", cpu);
+	pr_debug("microcode: CPU%d added\n", cpu);
 	memset(uci, 0, sizeof(*uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
@@ -733,7 +733,7 @@ static int mc_sysdev_remove(struct sys_d
 	if (!cpu_online(cpu))
 		return 0;
 
-	pr_debug("Microcode:CPU %d removed\n", cpu);
+	pr_debug("microcode: CPU%d removed\n", cpu);
 	microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
@@ -745,7 +745,7 @@ static int mc_sysdev_resume(struct sys_d
 
 	if (!cpu_online(cpu))
 		return 0;
-	pr_debug("Microcode:CPU %d resumed\n", cpu);
+	pr_debug("microcode: CPU%d resumed\n", cpu);
 	/* only CPU 0 will apply ucode here */
 	apply_microcode(0);
 	return 0;
@@ -783,7 +783,7 @@ mc_cpu_callback(struct notifier_block *n
 		}
 	case CPU_DOWN_FAILED_FROZEN:
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
-			printk(KERN_ERR "Microcode: Failed to create the sysfs "
+			printk(KERN_ERR "microcode: Failed to create the sysfs "
 				"group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
