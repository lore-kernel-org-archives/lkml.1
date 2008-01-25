Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYAYFTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYAYFTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYAYFTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:19:36 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57482 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYAYFTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:19:33 -0500
Message-ID: <47997122.3070504@ak.jp.nec.com>
Date: Fri, 25 Jan 2008 14:18:26 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: akpm@osdl.org
CC: morgan@kernel.org, serue@us.ibm.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 1/3] exporting capability code/name pairs (try 2nd)
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can apply this patch to kernel-2.6.24.
It enables to export code/name pairs of capabilities
at /sys/kernel/capability/, as follows:

--------
[root@saba ~]# ls /sys/kernel/capability/
cap_audit_control    cap_kill              cap_setgid      cap_sys_ptrace
cap_audit_write      cap_lease             cap_setpcap     cap_sys_rawio
cap_chown            cap_linux_immutable   cap_setuid      cap_sys_resource
cap_dac_override     cap_mknod             cap_sys_admin   cap_sys_time
cap_dac_read_search  cap_net_admin         cap_sys_boot    cap_sys_tty_config
cap_fowner           cap_net_bind_service  cap_sys_chroot  index
cap_fsetid           cap_net_broadcast     cap_sys_module  version
cap_ipc_lock         cap_net_raw           cap_sys_nice
cap_ipc_owner        cap_setfcap           cap_sys_pacct
[root@saba ~]# cat /sys/kernel/capability/cap_setfcap
31
[root@saba ~]# cat /sys/kernel/capability/version
0x19980330
[root@saba ~]#
--------

In the previous version of kernel, we have no way to obtain
what capabilities are supported in this running kernel.

The libcap is a library to provide fundamental facilities
to handle capabilities. It has to be rebuilt when new
capabilities are added, because it statically holds the
list of all capabilities generated from kernel header
automatically on its build environment.

This patch enables libcap to obtain these infomation dynamically,
and improves userspace portability.

Please consider to apply these patches.
Thanks,
----
Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>

 kernel/Makefile       |    9 ++++++++
 kernel/capability.c   |   36 +++++++++++++++++++++++++++++++++++
 scripts/mkcapnames.sh |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index dfa9695..29cd3ac 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -80,3 +80,12 @@ quiet_cmd_ikconfiggz = IKCFG   $@
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call if_changed,ikconfiggz)
+
+# cap_names.h contains the code/name pair of capabilities.
+# It is generated using include/linux/capability.h automatically.
+$(obj)/capability.o: $(obj)/cap_names.h
+quiet_cmd_cap_names  = CAPS    $@
+      cmd_cap_names  = /bin/sh $(src)/../scripts/mkcapnames.sh > $@
+targets += cap_names.h
+$(obj)/cap_names.h: $(src)/../scripts/mkcapnames.sh $(src)/../include/linux/capability.h FORCE
+	$(call if_changed,cap_names)
diff --git a/kernel/capability.c b/kernel/capability.c
index efbd9cd..14b4f4b 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -245,3 +245,39 @@ int capable(int cap)
 	return __capable(current, cap);
 }
 EXPORT_SYMBOL(capable);
+
+/*
+ * Export the list of capabilities on /sys/kernel/capability
+ */
+#define SYSFS_CAPABILITY_ENTRY(_name, _fmt, ...)			\
+	static ssize_t _name##_show(struct kset *kset, char *buffer)	\
+	{								\
+		return scnprintf(buffer, PAGE_SIZE, _fmt, __VA_ARGS__);	\
+	}								\
+	static struct subsys_attribute _name##_attr = __ATTR_RO(_name)
+
+/*
+ * capability_attrs[] is generated automatically by scripts/mkcapnames.sh
+ * This script parses include/linux/capability.h
+ */
+#include "cap_names.h"
+
+static struct attribute_group capability_attr_group = {
+	.name = "capability",
+	.attrs = capability_attrs,
+};
+
+static int __init capability_export_names(void)
+{
+	int rc;
+
+	rc = sysfs_create_group(&kernel_subsys.kobj,
+				&capability_attr_group);
+	if (rc) {
+		printk(KERN_ERR "Unable to export capabilities\n");
+		return rc;
+	}
+
+	return 0;
+}
+__initcall(capability_export_names);
diff --git a/scripts/mkcapnames.sh b/scripts/mkcapnames.sh
index e69de29..262478e 100644
--- a/scripts/mkcapnames.sh
+++ b/scripts/mkcapnames.sh
@@ -0,0 +1,50 @@
+#!/bin/sh
+
+#
+# generate a cap_names.h file from include/linux/capability.h
+#
+
+BASEDIR=`dirname $0`
+
+echo '#ifndef CAP_NAMES_H'
+echo '#define CAP_NAMES_H'
+echo
+echo '/*'
+echo ' * Do NOT edit this file directly.'
+echo ' * This file is generated from include/linux/capability.h automatically'
+echo ' */'
+echo
+echo '#ifndef SYSFS_CAPABILITY_ENTRY'
+echo '#error cap_names.h should be included from kernel/capability.c'
+echo '#else'
+
+echo 'SYSFS_CAPABILITY_ENTRY(version, "0x%08x\n", _LINUX_CAPABILITY_VERSION);'
+
+cat ${BASEDIR}/../include/linux/capability.h	\
+    | egrep '^#define CAP_[A-Z_]+[ 	]+[0-9]+$'	\
+    | awk 'BEGIN {
+            max_code = -1;
+        }
+        {
+            if ($3 > max_code)
+                max_code = $3;
+            printf("SYSFS_CAPABILITY_ENTRY(%s, \"%%u\\n\", %s);\n", tolower($2), $2);
+        }
+        END {
+            printf("SYSFS_CAPABILITY_ENTRY(index, \"%%u\\n\", %u);\n", max_code);
+        }'
+
+echo
+echo 'static struct attribute *capability_attrs[] = {'
+echo '        &version_attr.attr,'
+echo '        &index_attr.attr,'
+
+cat ${BASEDIR}/../include/linux/capability.h    \
+    | egrep '^#define CAP_[A-Z_]+[ 	]+[0-9]+$'   \
+    | awk '{ printf ("        &%s_attr.attr,\n", tolower($2)); }'
+
+echo '        NULL,'
+echo '};'
+
+echo '#endif	/* SYSFS_CAPABILITY_ENTRY */'
+echo '#endif	/* CAP_NAMES_H */'


-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
