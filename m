Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbYDEB0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbYDEB0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYDEBYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:24:52 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48044 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751372AbYDEBYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:24:49 -0400
Message-Id: <20080405012448.086228000@polaris-admin.engr.sgi.com>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:24:51 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cpumask: add show cpu map functions
Content-Disposition: inline; filename=add-cpu-show-map-funcs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add cpu_sysdev_class functions to display the

	cpu_online_map
	cpu_present_map
	cpu_possible_map
	cpu_system_map

  * Small change to include/linux/sysdev.h to allow the attribute
    name and label to be different (to avoid collision with the
    "attr_online" entry for bringing cpus on- and off-line.)

Depends on:
	[x86/latest]: x86: add cpus_scnprintf function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

# x86
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/base/cpu.c     |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysdev.h |   10 ++++++---
 2 files changed, 57 insertions(+), 3 deletions(-)

--- linux-2.6.x86.orig/drivers/base/cpu.c
+++ linux-2.6.x86/drivers/base/cpu.c
@@ -103,6 +103,53 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
 #endif
 
 /*
+ * Print cpu online, possible, present, and system maps
+ */
+static ssize_t print_cpus_map(char *buf, cpumask_t *map)
+{
+	int n = cpus_scnprintf(buf, PAGE_SIZE-2, *map);
+
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+
+#define	print_cpus_func(type) \
+static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
+{									\
+	return print_cpus_map(buf, &cpu_##type##_map);			\
+}									\
+struct sysdev_class_attribute attr_##type##_map = 			\
+	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
+
+print_cpus_func(online);
+print_cpus_func(possible);
+print_cpus_func(present);
+print_cpus_func(system);
+
+struct sysdev_class_attribute *cpu_state_attr[] = {
+	&attr_online_map,
+	&attr_possible_map,
+	&attr_present_map,
+	&attr_system_map,
+};
+
+static int cpu_states_init(void)
+{
+	int i;
+	int err = 0;
+
+	for (i = 0;  i < ARRAY_SIZE(cpu_state_attr); i++) {
+		int ret;
+		ret = sysdev_class_create_file(&cpu_sysdev_class,
+						cpu_state_attr[i]);
+		if (!err)
+			err = ret;
+	}
+	return err;
+}
+
+/*
  * register_cpu - Setup a sysfs device for a CPU.
  * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
  *	  sysfs for this CPU.
@@ -147,6 +194,9 @@ int __init cpu_dev_init(void)
 	int err;
 
 	err = sysdev_class_register(&cpu_sysdev_class);
+	if (!err)
+		err = cpu_states_init();
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	if (!err)
 		err = sched_create_sysfs_power_savings_entries(&cpu_sysdev_class);
--- linux-2.6.x86.orig/include/linux/sysdev.h
+++ linux-2.6.x86/include/linux/sysdev.h
@@ -45,12 +45,16 @@ struct sysdev_class_attribute {
 	ssize_t (*store)(struct sysdev_class *, const char *, size_t);
 };
 
-#define SYSDEV_CLASS_ATTR(_name,_mode,_show,_store) 		\
-struct sysdev_class_attribute attr_##_name = { 			\
+#define _SYSDEV_CLASS_ATTR(_name,_mode,_show,_store) 		\
+{					 			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
-};
+}
+
+#define SYSDEV_CLASS_ATTR(_name,_mode,_show,_store) 		\
+	struct sysdev_class_attribute attr_##_name = 		\
+		_SYSDEV_CLASS_ATTR(_name,_mode,_show,_store)
 
 
 extern int sysdev_class_register(struct sysdev_class *);

-- 
