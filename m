Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZH0Lzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZH0Lzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZH0Lzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:55:41 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:39814 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZH0Lzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:55:40 -0400
Date: Thu, 27 Aug 2009 17:25:36 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/4]: ACPI/ARM: Register for cpuidle_pm_idle in
	drivers/acpi/processor_idle.c and arch/arm/mach-kirkwood/cpuidle.c
Message-ID: <20090827115536.GD24986@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090827114908.GA24986@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090827114908.GA24986@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-08-27 17:19:08]:

Set the idle routine to cpuidle_pm_idle after registering cpuidle
devices. Earlier pm_idle was assumed as the defualt idle loop by
cpuidle infrastructure. This is changed to an architecture independent
cpuidle_pm_idle.

There are 2 instances which are using cpuidle infrastructure currently.
This patch makes the change in both the places.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/arm/mach-kirkwood/cpuidle.c |    6 ++++++
 drivers/acpi/processor_idle.c    |    5 +++++
 2 files changed, 11 insertions(+)

Index: linux.trees.git/arch/arm/mach-kirkwood/cpuidle.c
===================================================================
--- linux.trees.git.orig/arch/arm/mach-kirkwood/cpuidle.c
+++ linux.trees.git/arch/arm/mach-kirkwood/cpuidle.c
@@ -90,6 +90,12 @@ static int kirkwood_init_cpuidle(void)
 		printk(KERN_ERR "kirkwood_init_cpuidle: Failed registering\n");
 		return -EIO;
 	}
+
+	if (pm_idle != cpuidle_pm_idle) {
+		printk(KERN_INFO "using cpuidle idle loop\n");
+		pm_idle = cpuidle_pm_idle;
+	}
+
 	return 0;
 }
 
Index: linux.trees.git/drivers/acpi/processor_idle.c
===================================================================
--- linux.trees.git.orig/drivers/acpi/processor_idle.c
+++ linux.trees.git/drivers/acpi/processor_idle.c
@@ -1216,6 +1216,11 @@ int __cpuinit acpi_processor_power_init(
 				printk(" C%d[C%d]", i,
 				       pr->power.states[i].type);
 		printk(")\n");
+
+		if (pm_idle != cpuidle_pm_idle) {
+			printk(KERN_INFO "using cpuidle idle loop\n");
+			pm_idle = cpuidle_pm_idle;
+		}
 	}
 
 	/* 'power' [R] */
