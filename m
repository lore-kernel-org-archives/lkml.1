Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbXL0DwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbXL0DwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 22:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXL0DwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 22:52:15 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33409 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXL0DwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 22:52:14 -0500
Message-ID: <477321C8.3070004@ak.jp.nec.com>
Date: Thu, 27 Dec 2007 12:53:44 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: akpm@osdl.org, morgan@kernel.org, serue@us.ibm.com
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Exporting capability code/name pairs
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables to export the code/name pairs of capabilities under
/capability of securityfs.

In the current libcap, it obtains the list of capabilities from header file
on the build environment statically. However, it is not enough portable
between different versions of kernels, because an already built libcap
cannot have knowledge about new added capabilities.

Dynamic collection of code/name pairs of capabilities will resolve this
matter.

But it is not perfect one. I have a bit concern about this patch now.

1. I want to generate cap_entries array from linux/capability.h
   automatically. Is there any good idea?
2. We have to mount securityfs explicitly, or using /etc/fstab.
   It can make a matter when we want to use this features
   in very early boot sequence.

Any comment please.

usage:
-----------------------------------------------
# mount -t securityfs none /sys/kernel/security
# cd /sys/kernel/security/capability
# ls
cap_audit_control    cap_kill              cap_setpcap     cap_sys_rawio
cap_audit_write      cap_lease             cap_setuid      cap_sys_resource
cap_chown            cap_linux_immutable   cap_sys_admin   cap_sys_time
cap_dac_override     cap_mknod             cap_sys_boot    cap_sys_tty_config
cap_dac_read_search  cap_net_admin         cap_sys_chroot  index
cap_fowner           cap_net_bind_service  cap_sys_module  version
cap_fsetid           cap_net_broadcast     cap_sys_nice
cap_ipc_lock         cap_setfcap           cap_sys_pacct
cap_ipc_owner        cap_setgid            cap_sys_ptrace
# cat cap_audit_write ; echo
29
# cat cap_sys_chroot ; echo
18
# cat version ; echo
0x19980330
# cat index; echo
31
#

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
---
 capability.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/kernel/capability.c b/kernel/capability.c
index efbd9cd..5d9bf53 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -245,3 +245,131 @@ int capable(int cap)
 	return __capable(current, cap);
 }
 EXPORT_SYMBOL(capable);
+
+/*
+ * Capability code/name pair exporting
+ */
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
+	{ _LINUX_CAPABILITY_VERSION,	"version" },
+	/* max number of capability */
+	{ CAP_LAST_CAP,			"index" },
+	/* list of capabilities */
+	{ CAP_CHOWN,			"cap_chown" },
+	{ CAP_DAC_OVERRIDE,		"cap_dac_override" },
+	{ CAP_DAC_READ_SEARCH,		"cap_dac_read_search" },
+	{ CAP_FOWNER,			"cap_fowner" },
+	{ CAP_FSETID,			"cap_fsetid" },
+	{ CAP_KILL,			"cap_kill" },
+	{ CAP_SETGID,			"cap_setgid" },
+	{ CAP_SETUID,			"cap_setuid" },
+	{ CAP_SETPCAP,			"cap_setpcap" },
+	{ CAP_LINUX_IMMUTABLE,		"cap_linux_immutable" },
+	{ CAP_NET_BIND_SERVICE,		"cap_net_bind_service" },
+	{ CAP_NET_BROADCAST,		"cap_net_broadcast" },
+	{ CAP_NET_ADMIN,		"cap_net_admin" },
+	{ CAP_NET_RAW,			"cap_net_admin" },
+	{ CAP_IPC_LOCK,			"cap_ipc_lock" },
+	{ CAP_IPC_OWNER,		"cap_ipc_owner" },
+	{ CAP_SYS_MODULE,		"cap_sys_module" },
+	{ CAP_SYS_RAWIO,		"cap_sys_rawio" },
+	{ CAP_SYS_CHROOT,		"cap_sys_chroot" },
+	{ CAP_SYS_PTRACE,		"cap_sys_ptrace" },
+	{ CAP_SYS_PACCT,		"cap_sys_pacct" },
+	{ CAP_SYS_ADMIN,		"cap_sys_admin" },
+	{ CAP_SYS_BOOT,			"cap_sys_boot" },
+	{ CAP_SYS_NICE,			"cap_sys_nice" },
+	{ CAP_SYS_RESOURCE,		"cap_sys_resource" },
+	{ CAP_SYS_TIME,			"cap_sys_time" },
+	{ CAP_SYS_TTY_CONFIG,		"cap_sys_tty_config" },
+	{ CAP_MKNOD,			"cap_mknod" },
+	{ CAP_LEASE,			"cap_lease" },
+	{ CAP_AUDIT_WRITE,		"cap_audit_write" },
+	{ CAP_AUDIT_CONTROL,		"cap_audit_control" },
+	{ CAP_SETFCAP,			"cap_setfcap" },
+	{ CAP_MAC_OVERRIDE,		"cap_mac_override" },
+	{ CAP_MAC_ADMIN,		"cap_mac_admin" },
+	{ -1,				NULL},
+};
+
+static ssize_t cap_entry_read(struct file *file, char __user *buffer,
+			      size_t count, loff_t *ppos)
+{
+	struct cap_entry_data *cap_entry;
+	size_t len, ofs = *ppos;
+	char tmp[32];
+	int rc;
+
+	cap_entry = file->f_dentry->d_inode->i_private;
+	if (!cap_entry)
+		return -EINVAL;
+
+	if (cap_entry == &cap_entries[0]) {
+		/* 'version' entry*/
+		snprintf(tmp, sizeof(tmp), "0x%08x", cap_entry->code);
+	} else {
+		snprintf(tmp, sizeof(tmp), "%u", cap_entry->code);
+	}
+	len = strlen(tmp);
+
+	if (ofs >= len)
+		return 0;
+
+	if (len - ofs < count)
+		count = len - ofs;
+
+	rc = copy_to_user(buffer, tmp + ofs, count);
+	if (rc)
+		return rc;
+
+	*ppos += count;
+	return count;
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
