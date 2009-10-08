Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZJHJ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZJHJ4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZJHJ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:56:51 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48194 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbZJHJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:56:49 -0400
Date: Thu, 8 Oct 2009 15:26:05 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v8 PATCH 8/8]: POWER: Enable default_idle when power_save=off.
Message-ID: <20091008095605.GI20595@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091008094828.GA20595@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-08 15:18:28]:

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
