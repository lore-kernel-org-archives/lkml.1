Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZIALjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZIALjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZIALjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:39:45 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56332 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbZIALjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:39:44 -0400
Date: Tue, 1 Sep 2009 17:09:41 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v4 PATCH 2/5]: cpuidle: Implement routines to register and
	unregister idle function.
Message-ID: <20090901113941.GI7599@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090901113704.GG7599@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090901113704.GG7599@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-01 17:07:04]:

Implement a LIFO based approach for registering arch dependent
idle routines.

This is a prototype for pseries, needs to be extended
for other platforms.

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/idle.c |    5 +++++
 drivers/cpuidle/cpuidle.c  |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h         |   10 ++++++++++
 3 files changed, 52 insertions(+)

Index: linux.trees.git/arch/powerpc/kernel/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/idle.c
+++ linux.trees.git/arch/powerpc/kernel/idle.c
@@ -46,6 +46,11 @@ static int __init powersave_off(char *ar
 }
 __setup("powersave=off", powersave_off);
 
+void set_arch_idle(void (*idle)(void))
+{
+	ppc_md.power_save = idle;
+}
+
 /*
  * The body of the idle task.
  */
Index: linux.trees.git/include/linux/pm.h
===================================================================
--- linux.trees.git.orig/include/linux/pm.h
+++ linux.trees.git/include/linux/pm.h
@@ -30,6 +30,16 @@ extern void (*pm_idle)(void);
 extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
 
+struct idle_function_desc {
+	char			*name;
+	void			(*idle_func)(void);
+	struct list_head	idle_list;
+};
+
+extern void set_arch_idle(void (*idle)(void));
+extern void register_idle_function(struct idle_function_desc *desc);
+extern void unregister_idle_function(struct idle_function_desc *desc);
+
 /*
  * Device power management
  */
Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -44,6 +44,43 @@ static void cpuidle_kick_cpus(void)
 static void cpuidle_kick_cpus(void) {}
 #endif
 
+LIST_HEAD(idle_function_list);
+static DEFINE_MUTEX(idle_list_mutex);
+
+void register_idle_function(struct idle_function_desc *desc)
+{
+	mutex_lock(&idle_list_mutex);
+
+	list_add(&desc->idle_list, &idle_function_list);
+	set_arch_idle(desc->idle_func);
+	cpuidle_kick_cpus();
+
+	mutex_unlock(&idle_list_mutex);
+}
+
+void unregister_idle_function(struct idle_function_desc *desc)
+{
+	struct list_head *pos;
+	struct idle_function_desc *temp_desc;
+
+	mutex_lock(&idle_list_mutex);
+	WARN_ON_ONCE(list_empty(&desc->idle_list) || desc != NULL);
+
+	list_for_each(pos, &idle_function_list) {
+		temp_desc = container_of(pos, struct idle_function_desc,
+					idle_list);
+		if (temp_desc == desc) {
+			list_del(&temp_desc->idle_list);
+			/* Re-using temp_desc here */
+			temp_desc = list_first_entry(&idle_function_list,
+					struct idle_function_desc, idle_list);
+			set_arch_idle(temp_desc->idle_func);
+			cpuidle_kick_cpus();
+		}
+	}
+	mutex_unlock(&idle_list_mutex);
+}
+
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
 /**
