Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZKNKUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZKNKUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 05:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZKNKT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 05:19:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:37672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbZKNKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 05:19:54 -0500
Date: Sat, 14 Nov 2009 10:19:27 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, davej@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, davej@redhat.com, mingo@elte.hu
In-Reply-To: <20091113203000.GA19160@redhat.com>
References: <20091113203000.GA19160@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Fix cpu_devs[] initialization in early_cpu_init()
Message-ID: <tip-31c997cac76e62918858a432fff6e43fd48425f9@git.kernel.org>
Git-Commit-ID: 31c997cac76e62918858a432fff6e43fd48425f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31c997cac76e62918858a432fff6e43fd48425f9
Gitweb:     http://git.kernel.org/tip/31c997cac76e62918858a432fff6e43fd48425f9
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 14 Nov 2009 10:34:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 10:36:50 +0100

x86: Fix cpu_devs[] initialization in early_cpu_init()

Yinghai Lu noticed that this commit:

  0388423: x86: Minimise printk spew from per-vendor init code

mistakenly left out the initialization of cpu_devs[] in the
!PROCESSOR_SELECT case. Fix it.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Jones <davej@redhat.com>
LKML-Reference: <20091113203000.GA19160@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/common.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9db1e24..61242a5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -651,28 +651,34 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 void __init early_cpu_init(void)
 {
-#ifdef PROCESSOR_SELECT
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
+#ifdef PROCESSOR_SELECT
 	printk(KERN_INFO "KERNEL supported cpus:\n");
+#endif
+
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
 		const struct cpu_dev *cpudev = *cdev;
-		unsigned int j;
 
 		if (count >= X86_VENDOR_NUM)
 			break;
 		cpu_devs[count] = cpudev;
 		count++;
 
-		for (j = 0; j < 2; j++) {
-			if (!cpudev->c_ident[j])
-				continue;
-			printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
-				cpudev->c_ident[j]);
+#ifdef PROCESSOR_SELECT
+		{
+			unsigned int j;
+
+			for (j = 0; j < 2; j++) {
+				if (!cpudev->c_ident[j])
+					continue;
+				printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
+					cpudev->c_ident[j]);
+			}
 		}
-	}
 #endif
+	}
 	early_identify_cpu(&boot_cpu_data);
 }
 
