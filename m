Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYADC1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYADC1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYADC1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:27:43 -0500
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:64901 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752545AbYADC1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:27:42 -0500
Message-ID: <477D99B4.8010805@ak.jp.nec.com>
Date: Fri, 04 Jan 2008 11:28:04 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: KaiGai Kohei <kaigai@kaigai.gr.jp>, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@osdl.org, morgan@kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com> <Xine.LNX.4.64.0712281957520.23510@us.intercode.com.au> <477B457E.6000802@kaigai.gr.jp> <Xine.LNX.4.64.0801022100550.30212@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0801022100550.30212@us.intercode.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Wed, 2 Jan 2008, KaiGai Kohei wrote:
> 
>>> Another issue is that securityfs depends on CONFIG_SECURITY, which might be
>>> undesirable, given that capabilities are a standard feature.
>> We can implement this feature on another pseudo filesystems.
>> Do you think what filesystem is the best candidate?
>> I prefer procfs or sysfs instead.
> 
> Sysfs makes more sense, as this information is system-wide and does not 
> relate to specific processes.

The following patch enables to export any capabilities which are supported
on the working kernel, under the /sys/kernel/capability.
You can obtain the code/name pairs of capabilities with scanning this directory.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
--
 kernel/Makefile       |    9 +++++++++
 kernel/capability.c   |   36 ++++++++++++++++++++++++++++++++++++
 scripts/mkcapnames.sh |   45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 0 deletions(-)

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
index e69de29..c1c8b1f 100644
--- a/scripts/mkcapnames.sh
+++ b/scripts/mkcapnames.sh
@@ -0,0 +1,45 @@
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
+echo '#ifndef SYSFS_CAPABILITY_ENTRY'
+echo '#error cap_names.h should be included from kernel/capability.c'
+echo '#else'
+
+echo 'SYSFS_CAPABILITY_ENTRY(version, "0x%08x\n", _LINUX_CAPABILITY_VERSION);'
+
+cat ${BASEDIR}/../include/linux/capability.h	\
+    | egrep '^#define CAP_[A-Z_]+[ ]+[0-9]+$'	\
+    | awk 'BEGIN {
+            max_code = -1;
+        }
+        {
+            if ($3 > max_code)
+                max_code = $3;
+            printf("\tSYSFS_CAPABILITY_ENTRY(%s, \"%%u\\n\", %s);\n", tolower($2), $2);
+        }
+        END {
+            printf("\tSYSFS_CAPABILITY_ENTRY(index, \"%%u\\n\", %u);\n", max_code);
+        }'
+
+echo
+echo 'static struct attribute *capability_attrs[] = {'
+echo '        &version_attr.attr,'
+echo '        &index_attr.attr,'
+
+cat ${BASEDIR}/../include/linux/capability.h    \
+    | egrep '^#define CAP_[A-Z_]+[ ]+[0-9]+$'   \
+    | awk '{ printf ("        &%s_attr.attr,\n", tolower($2)); }'
+
+echo '        NULL,'
+echo '};'
+
+echo '#endif	/* SYSFS_CAPABILITY_ENTRY */'
+echo '#endif	/* CAP_NAMES_H */'
