Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbZJPJtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbZJPJtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758183AbZJPJtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:49:19 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33066 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbZJPJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:49:18 -0400
Date: Fri, 16 Oct 2009 15:18:33 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v9 PATCH 9/9]: POWER: Enable default_idle when power_save=off.
Message-ID: <20091016094833.GK27350@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091016093850.GB27350@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091016093850.GB27350@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-16 15:08:50]:

This patch enables default_idle when power_save=off kernel boot
option is specified.

Earlier, this was done by setting ppc_md.power_save = NULL and hence
HMT_low() and HMT_very_low() was called. Now this is defined under
default_idle() and hence by setting boot_option_idle_override = 1,
the cpuidle registration stuff does not happen and hence default_idle
is chosen in cpuidle_idle_call.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/processor.h            |    2 ++
 arch/powerpc/kernel/idle.c                      |    4 +++-
 arch/powerpc/platforms/pseries/processor_idle.c |    5 +++++
 3 files changed, 10 insertions(+), 1 deletion(-)

Index: linux.trees.git/arch/powerpc/include/asm/processor.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/processor.h
+++ linux.trees.git/arch/powerpc/include/asm/processor.h
@@ -332,6 +332,8 @@ static inline unsigned long get_clean_sp
 }
 #endif
 
+extern int boot_option_idle_override;
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_PROCESSOR_H */
Index: linux.trees.git/arch/powerpc/kernel/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/idle.c
+++ linux.trees.git/arch/powerpc/kernel/idle.c
@@ -40,9 +40,11 @@
 #define cpu_should_die()	0
 #endif
 
+int boot_option_idle_override = 0;
+
 static int __init powersave_off(char *arg)
 {
-	ppc_md.power_save = NULL;
+	boot_option_idle_override = 1;
 	return 0;
 }
 __setup("powersave=off", powersave_off);
Index: linux.trees.git/arch/powerpc/platforms/pseries/processor_idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pseries/processor_idle.c
+++ linux.trees.git/arch/powerpc/platforms/pseries/processor_idle.c
@@ -185,6 +185,11 @@ static int __init pseries_processor_idle
 	int cpu;
 	int result;
 
+	if (boot_option_idle_override) {
+		printk(KERN_DEBUG "Using default idle\n");
+		return 0;
+	}
+
 	result = cpuidle_register_driver(&pseries_idle_driver);
 
 	if (result < 0)
