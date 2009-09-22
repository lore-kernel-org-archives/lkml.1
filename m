Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZIVLc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZIVLc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbZIVLcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:32:54 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:34028 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbZIVLcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:32:54 -0400
Date: Tue, 22 Sep 2009 17:02:53 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v6 PATCH 6/7]: POWER: add a default_idle idle loop for POWER.
Message-ID: <20090922113253.GG7788@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922112526.GA7788@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090922112526.GA7788@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 16:55:27]:

In arch/powerpc/kernel/idle.c create a default_idle() routine by moving
the failover condition of the cpu_idle() idle loop. This is needed by
cpuidle infrastructure to call default_idle when other idle routines
are not yet registered. Functionality remains the same, but the code is
slightly moved around.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig              |    3 +++
 arch/powerpc/include/asm/system.h |    1 +
 arch/powerpc/kernel/idle.c        |    6 ++++++
 3 files changed, 10 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig
+++ linux.trees.git/arch/powerpc/Kconfig
@@ -91,6 +91,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_HAS_CPU_IDLE_WAIT
 	def_bool y
 
+config ARCH_HAS_DEFAULT_IDLE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
Index: linux.trees.git/arch/powerpc/include/asm/system.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/system.h
+++ linux.trees.git/arch/powerpc/include/asm/system.h
@@ -218,6 +218,7 @@ extern unsigned long klimit;
 extern void *alloc_maybe_bootmem(size_t size, gfp_t mask);
 extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
 
+extern void default_idle(void);
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 
 /*
Index: linux.trees.git/arch/powerpc/kernel/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/idle.c
+++ linux.trees.git/arch/powerpc/kernel/idle.c
@@ -113,6 +113,12 @@ void cpu_idle_wait(void)
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
+void default_idle(void)
+{
+	HMT_low();
+	HMT_very_low();
+}
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
