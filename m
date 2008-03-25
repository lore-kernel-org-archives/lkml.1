Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbYCYWIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbYCYWIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbYCYWG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:06:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57647 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755855AbYCYWGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:06:52 -0400
Message-Id: <20080325220651.822567000@polaris-admin.engr.sgi.com>
References: <20080325220650.835342000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Mar 2008 15:06:57 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] cpu: change cpu_sys_devices from array to per_cpu variable
Content-Disposition: inline; filename=nr_cpus-in-cpu_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change cpu_sys_devices from array to per_cpu variable in
drivers/base/cpu.c.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

(MAINTAINER unknown)
Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/base/cpu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux.trees.git.orig/drivers/base/cpu.c
+++ linux.trees.git/drivers/base/cpu.c
@@ -18,7 +18,7 @@ struct sysdev_class cpu_sysdev_class = {
 };
 EXPORT_SYMBOL(cpu_sysdev_class);
 
-static struct sys_device *cpu_sys_devices[NR_CPUS];
+static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
 static ssize_t show_online(struct sys_device *dev, char *buf)
@@ -68,7 +68,7 @@ void unregister_cpu(struct cpu *cpu)
 	sysdev_remove_file(&cpu->sysdev, &attr_online);
 
 	sysdev_unregister(&cpu->sysdev);
-	cpu_sys_devices[logical_cpu] = NULL;
+	per_cpu(cpu_sys_devices, logical_cpu) = NULL;
 	return;
 }
 #else /* ... !CONFIG_HOTPLUG_CPU */
@@ -122,7 +122,7 @@ int __cpuinit register_cpu(struct cpu *c
 	if (!error && cpu->hotpluggable)
 		register_cpu_control(cpu);
 	if (!error)
-		cpu_sys_devices[num] = &cpu->sysdev;
+		per_cpu(cpu_sys_devices, num) = &cpu->sysdev;
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
@@ -135,8 +135,8 @@ int __cpuinit register_cpu(struct cpu *c
 
 struct sys_device *get_cpu_sysdev(unsigned cpu)
 {
-	if (cpu < NR_CPUS)
-		return cpu_sys_devices[cpu];
+	if (cpu < nr_cpu_ids && cpu_possible(cpu))
+		return per_cpu(cpu_sys_devices, cpu);
 	else
 		return NULL;
 }

-- 
