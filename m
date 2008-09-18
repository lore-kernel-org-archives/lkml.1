Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYIRIG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYIRIG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 04:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYIRIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 04:06:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:45237 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYIRIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 04:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NuJaoNzKpSbkYqt/6GHCAAxSPDQ46JPLnAM+4mnhDlSrQn0I9Y0KY2eb//qrMK8Qgg
         K7JNGeirkgP3Rh9vh7V1GKIAg9VMhL8sMxOG8Z/tY71QS5yeQ3ALUenz3OtUMe29341b
         5KGbesHyWAQ9pn6zD+93uPGH4DWzcX8VGXNO0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] add sysctl from printk_tag
Date: Thu, 18 Sep 2008 01:05:37 -0700
Message-Id: <1221725137-21947-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

under /proc/sys/kernel/printk_tag/ will have acpi, apic, dev, pci

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 init/main.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -63,6 +63,8 @@
 #include <linux/idr.h>
 #include <linux/kmemcheck.h>
 #include <linux/ftrace.h>
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -395,6 +397,60 @@ static int __init quiet_kernel(char *str
 early_param("debug", debug_kernel);
 early_param("quiet", quiet_kernel);
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table printk_tag_ctl_dir[] = {
+        {
+                .procname       = "printk_tag",
+                .mode           = 0555,
+        },
+        {0, },
+};
+
+static struct ctl_table printk_tag_ctl_root[] = {
+        {
+                .ctl_name       = CTL_KERN,
+                .procname       = "kernel",
+                .mode           = 0555,
+                .child          = printk_tag_ctl_dir,
+        },
+        {0, },
+};
+
+static int __init proc_printk_tag_init(void)
+{
+        int i;
+        struct ctl_table *entry;
+        char buf[32];
+
+        entry = kcalloc(tag_level_nr + 1, sizeof(struct ctl_table), GFP_KERNEL);
+        if (entry == NULL)
+                return -1;
+
+        WARN_ON(printk_tag_ctl_dir[0].child);
+        printk_tag_ctl_dir[0].child = entry;
+
+
+	for (i = 0; i < tag_level_nr; i++) {
+		int len;
+
+		len = strlen(tag_level[i].name);
+		memset(buf, 0, sizeof(buf));
+		strncpy(buf, tag_level[i].name, len - 1);
+                entry->procname = kstrdup(buf, GFP_KERNEL);
+		entry->data = &tag_level[i].level;
+		entry->maxlen = sizeof(tag_level[i].level);
+                entry->mode = 0644;
+		entry->proc_handler = proc_dointvec;
+                entry++;
+        }
+
+	register_sysctl_table(printk_tag_ctl_root);
+
+	return 0;
+}
+fs_initcall(proc_printk_tag_init);
+#endif
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * failed parameters
