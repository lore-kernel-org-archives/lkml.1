Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545Ab0AELs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0AELs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450Ab0AELsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36323 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab0AELsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:03 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [3/12] SYSDEV: Convert cpu driver sysdev class attributes 
Message-Id: <20100105114800.7CE01B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using the new attribute argument convert the cpu driver class attributes
to carry the node state. Then use a shared function to do what 
a lot of individual functions did before.

This eliminates an ugly macro.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/base/cpu.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

Index: linux-2.6.33-rc2-ak/drivers/base/cpu.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/cpu.c
+++ linux-2.6.33-rc2-ak/drivers/base/cpu.c
@@ -141,27 +141,32 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
 /*
  * Print cpu online, possible, present, and system maps
  */
-static ssize_t print_cpus_map(char *buf, const struct cpumask *map)
+
+struct cpu_attr {
+	struct sysdev_class_attribute attr;
+	const struct cpumask *const * const map;
+};
+
+static ssize_t show_cpus_attr(struct sysdev_class *class,
+			      struct sysdev_class_attribute *attr,
+			      char *buf)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, map);
+	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
+	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, *(ca->map));
 
 	buf[n++] = '\n';
 	buf[n] = '\0';
 	return n;
 }
 
-#define	print_cpus_func(type) \
-static ssize_t print_cpus_##type(struct sysdev_class *class, 		\
-	 		struct sysdev_class_attribute *attr, char *buf)	\
-{									\
-	return print_cpus_map(buf, cpu_##type##_mask);			\
-}									\
-static struct sysdev_class_attribute attr_##type##_map = 		\
-	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
-
-print_cpus_func(online);
-print_cpus_func(possible);
-print_cpus_func(present);
+#define _CPU_ATTR(name, map)						\
+	{ _SYSDEV_CLASS_ATTR(name, 0444, show_cpus_attr, NULL), map }
+
+static struct cpu_attr cpu_attrs[] = {
+	_CPU_ATTR(online, &cpu_online_mask),
+	_CPU_ATTR(possible, &cpu_possible_mask),
+	_CPU_ATTR(present, &cpu_present_mask),
+};
 
 /*
  * Print values for NR_CPUS and offlined cpus
@@ -208,9 +213,9 @@ static ssize_t print_cpus_offline(struct
 static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
 
 static struct sysdev_class_attribute *cpu_state_attr[] = {
-	&attr_online_map,
-	&attr_possible_map,
-	&attr_present_map,
+	&cpu_attrs[0].attr,
+	&cpu_attrs[1].attr,
+	&cpu_attrs[2].attr,
 	&attr_kernel_max,
 	&attr_offline,
 };
