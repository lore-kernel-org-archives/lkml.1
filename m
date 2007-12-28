Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbXL1GRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbXL1GRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 01:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbXL1GR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 01:17:27 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39385 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbXL1GR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 01:17:26 -0500
Message-ID: <477494C3.2040301@ak.jp.nec.com>
Date: Fri, 28 Dec 2007 15:16:35 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>, jmorris@namei.org
CC: KaiGai Kohei <kaigai@ak.jp.nec.com>, akpm@osdl.org, morgan@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com>
In-Reply-To: <477455A0.7060603@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch enables to export capability code/name pairs
under /capability of securityfs (revision 2).

Inprovements from the first revison:
- simple_read_from_buffer() is used for read method.
- cap_entries[] array is generated from include/linux/capability.h
  automatically.

Remaining issues:
- We have to mount securityfs explicitly, or use /etc/fstab.
  It can cause a matter when we want to use this feature on
  very early phase on boot. (like /sbin/init)

It was also concerned at the past.
  http://marc.info/?l=linux-kernel&m=112063963623190&w=2

How do you think an idea that the root of securityfs is mounted on
kernel/security of sysfs when it is initialized?
If securityfs got being available when kernel initializing process,
we can always use this feature and the matter will be resolved.

>>> +static struct cap_entry_data cap_entries[] = {
>>> +    /* max number of supported format */
>>> +    { _LINUX_CAPABILITY_VERSION,    "version" },
>>> +    /* max number of capability */
>>> +    { CAP_LAST_CAP,            "index" },
>>> +    /* list of capabilities */
>>> +    { CAP_CHOWN,            "cap_chown" },
>>> +    { CAP_DAC_OVERRIDE,        "cap_dac_override" },
>   - snip -
>>> +    { CAP_MAC_OVERRIDE,        "cap_mac_override" },
>>> +    { CAP_MAC_ADMIN,        "cap_mac_admin" },
>>> +    { -1,                NULL},
>>> +};
>>
>> I don't like this duplication with the list in 
>> include/linux/capability.h.
>> Now when a new cap is added, it needs to be
>>
>>     1. added to capability.h
>>     2. swapped as the new CAP_LAST_CAP in capability.h
>>     3. added to this list...
>>
>> Could you integrate the two lists (not sure how offhand), or at least
>> put them in the same place?

kernel/cap_names.sh generates the body of cap_entries[] array,
and it is invoked when we make the kernel.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
---
 Makefile     |    9 +++++++
 cap_names.sh |   21 ++++++++++++++++
 capability.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index dfa9695..45d6034 100644
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
+      cmd_cap_names  = /bin/sh $(src)/cap_names.sh > $@
+targets += cap_names.h
+$(obj)/cap_names.h: $(src)/cap_names.sh $(src)/../include/linux/capability.h FORCE
+	$(call if_changed,cap_names)
diff --git a/kernel/cap_names.sh b/kernel/cap_names.sh
index e69de29..7b2fcfe 100644
--- a/kernel/cap_names.sh
+++ b/kernel/cap_names.sh
@@ -0,0 +1,21 @@
+#!/bin/sh
+
+#
+# generate a cap_names.h file from include/linux/capability.h
+#
+
+BASEDIR=`dirname $0`
+
+cat ${BASEDIR}/../include/linux/capability.h		\
+    | egrep '^#define CAP_[A-Z_]+[ 	]+[0-9]+$'	\
+    | awk 'BEGIN {
+               max_code = -1;
+          }
+          {
+               if ($3 > max_code)
+                   max_code = $3;
+               printf("\t{ %s, \"%s\" },\n", $2, tolower($2));
+          }
+          END {
+               printf("\t{ %u, \"index\" },\n", max_code);
+          }'
diff --git a/kernel/capability.c b/kernel/capability.c
index efbd9cd..03a9b62 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -245,3 +245,78 @@ int capable(int cap)
 	return __capable(current, cap);
 }
 EXPORT_SYMBOL(capable);
+
+/*
+ * capability code/name pairs are exported under /sys/security/capability/
+ */
+struct cap_entry_data {
+	unsigned int code;
+	const char *name;
+};
+
+static struct cap_entry_data cap_entries[] = {
+	/* max number of supported format */
+	{ _LINUX_CAPABILITY_VERSION, "version" },
+	/* list of capabilities */
+#include "cap_names.h"
+	{ -1, NULL},
+};
+
+static ssize_t cap_entry_read(struct file *file, char __user *buffer,
+			      size_t count, loff_t *ppos)
+{
+	struct cap_entry_data *cap_entry;
+	char tmp[32];
+	int len;
+
+	cap_entry = file->f_dentry->d_inode->i_private;
+	BUG_ON(!cap_entry);
+
+	snprintf(tmp, sizeof(tmp),
+		 cap_entry == &cap_entries[0] ? "0x%08x" :  "%u",
+		 cap_entry->code);
+	len = strlen(tmp);
+
+	return simple_read_from_buffer(buffer, count, ppos, tmp, len);
+}
+
+const struct file_operations cap_entry_fops = {
+	.read = cap_entry_read,
+};
+
+int __init cap_names_export(void)
+{
+	struct dentry *d_caps, *f_caps[ARRAY_SIZE(cap_entries)];
+	int i;
+
+	/* init max number of capability*/
+	cap_entries[1].code = ARRAY_SIZE(cap_entries) - 3;
+
+	d_caps = securityfs_create_dir("capability", NULL);
+	if (!d_caps)
+		goto error0;
+
+	memset(f_caps, 0, sizeof(f_caps));
+	for (i = 0; cap_entries[i].name; i++) {
+		f_caps[i] = securityfs_create_file(cap_entries[i].name, 0444,
+						   d_caps, &cap_entries[i],
+						   &cap_entry_fops);
+		if (!f_caps[i])
+			goto error1;
+	}
+	printk(KERN_NOTICE "capability code/name pairs are exported\n");
+	return 0;
+
+error1:
+	while (i > 0) {
+		i--;
+		securityfs_remove(f_caps[i]);
+	}
+	securityfs_remove(d_caps);
+error0:
+	printk(KERN_ERR "Unable to export capability code/name pairs\n");
+
+	return 0;
+}
+
+__initcall(cap_names_export);


-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
