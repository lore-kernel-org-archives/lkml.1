Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbXGVPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbXGVPsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbXGVPow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60825 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969AbXGVPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=lKPNxYM0/H3PUUmN/Enclodo8EFdbT2anb3FGlCKA+w5i4DO+MaFWg0m8xQrTxlROt4WprWE6Ql6Og8L2Xaqt6xW/gBVX0hc3fMBjypY7VDkED9e9Z+GLKSkGsR7qpX3pcOHQ5AP2WkWBocWjljLWp4um8nqrCg53Lsm7oX/n2c=
Message-Id: <20070722153416.233445834@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:20 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 8/9] mce: fix cpu hotplug error handling
Content-Disposition: inline; filename=mce-cpuhotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Clear kobject in percpu device_mce before calling sysdev_register() with

  Because mce_create_device() may fail and it leaves kobject filled with
  junk. It will be the problem when mce_create_device() will be called
  next time.

- Fix error handling in mce_create_device()

  Error handling should not do sysdev_remove_file() with not yet added
  attributes.

- Don't register hotcpu notifier when mce_create_device() returns error

- Do mce_create_device() in CPU_UP_PREPARE instead of CPU_ONLINE

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/x86_64/kernel/mce.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

Index: 2.6-git/arch/x86_64/kernel/mce.c
===================================================================
--- 2.6-git.orig/arch/x86_64/kernel/mce.c
+++ 2.6-git/arch/x86_64/kernel/mce.c
@@ -690,16 +690,29 @@ static __cpuinit int mce_create_device(u
 	if (!mce_available(&cpu_data[cpu]))
 		return -EIO;
 
+	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
 	per_cpu(device_mce,cpu).id = cpu;
 	per_cpu(device_mce,cpu).cls = &mce_sysclass;
 
 	err = sysdev_register(&per_cpu(device_mce,cpu));
+	if (err)
+		return err;
+
+	for (i = 0; mce_attributes[i]; i++) {
+		err = sysdev_create_file(&per_cpu(device_mce,cpu),
+					 mce_attributes[i]);
+		if (err)
+			goto error;
+	}
 
-	if (!err) {
-		for (i = 0; mce_attributes[i]; i++)
-			sysdev_create_file(&per_cpu(device_mce,cpu),
-				mce_attributes[i]);
+	return 0;
+error:
+	while (i--) {
+		sysdev_remove_file(&per_cpu(device_mce,cpu),
+				   mce_attributes[i]);
 	}
+	sysdev_unregister(&per_cpu(device_mce,cpu));
+
 	return err;
 }
 
@@ -711,7 +724,6 @@ static void mce_remove_device(unsigned i
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 			mce_attributes[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
-	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
@@ -719,18 +731,21 @@ static int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
 
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		mce_create_device(cpu);
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		err = mce_create_device(cpu);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block mce_cpu_notifier = {
@@ -745,9 +760,13 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 	err = sysdev_class_register(&mce_sysclass);
+	if (err)
+		return err;
 
 	for_each_online_cpu(i) {
-		mce_create_device(i);
+		err = mce_create_device(i);
+		if (err)
+			return err;
 	}
 
 	register_hotcpu_notifier(&mce_cpu_notifier);

-- 
