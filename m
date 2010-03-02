Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0CBX3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:17 -0500
Received: from kroah.org ([198.145.64.141]:38501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab0CBX3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/62] sysdev: Convert cpu driver sysdev class attributes
Date: Tue,  2 Mar 2010 15:28:06 -0800
Message-Id: <1267572541-410-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Using the new attribute argument convert the cpu driver class attributes
to carry the node state. Then use a shared function to do what a lot of
individual functions did before.

This eliminates an ugly macro.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/cpu.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index fd1b2f9..b04ecfc 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -141,27 +141,32 @@ static SYSDEV_ATTR(crash_notes, 0400, show_crash_notes, NULL);
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
+#define _CPU_ATTR(name, map)						\
+	{ _SYSDEV_CLASS_ATTR(name, 0444, show_cpus_attr, NULL), map }
 
-print_cpus_func(online);
-print_cpus_func(possible);
-print_cpus_func(present);
+static struct cpu_attr cpu_attrs[] = {
+	_CPU_ATTR(online, &cpu_online_mask),
+	_CPU_ATTR(possible, &cpu_possible_mask),
+	_CPU_ATTR(present, &cpu_present_mask),
+};
 
 /*
  * Print values for NR_CPUS and offlined cpus
@@ -208,9 +213,9 @@ static ssize_t print_cpus_offline(struct sysdev_class *class,
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
-- 
1.7.0.1

