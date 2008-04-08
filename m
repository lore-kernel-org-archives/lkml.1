Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYDHPCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYDHPCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYDHPBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:01:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16531 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYDHPBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:01:53 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 09/12] proc: convert /proc/bus/nubus to seq_file interface
Date: Tue, 8 Apr 2008 19:00:50 +0400
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081900.51024.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/nubus/proc.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/drivers/nubus/proc.c
+++ b/drivers/nubus/proc.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/nubus.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/module.h>
 
@@ -28,38 +29,36 @@
 #include <asm/byteorder.h>
 
 static int
-get_nubus_dev_info(char *buf, char **start, off_t pos, int count)
+nubus_devices_proc_show(struct seq_file *m, void *v)
 {
 	struct nubus_dev *dev = nubus_devices;
-	off_t at = 0;
-	int len, cnt;
 
-	cnt = 0;
-	while (dev && count > cnt) {
-		len = sprintf(buf, "%x\t%04x %04x %04x %04x",
+	while (dev) {
+		seq_printf(m, "%x\t%04x %04x %04x %04x",
 			      dev->board->slot,
 			      dev->category,
 			      dev->type,
 			      dev->dr_sw,
 			      dev->dr_hw);
-		len += sprintf(buf+len,
-			       "\t%08lx",
-			       dev->board->slot_addr);
-		buf[len++] = '\n';
-		at += len;
-		if (at >= pos) {
-			if (!*start) {
-				*start = buf + (pos - (at - len));
-				cnt = at - pos;
-			} else
-				cnt += len;
-			buf += len;
-		}
+		seq_printf(m, "\t%08lx\n", dev->board->slot_addr);
 		dev = dev->next;
 	}
-	return (count > cnt) ? cnt : count;
+	return 0;
+}
+
+static int nubus_devices_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nubus_devices_proc_show, NULL);
 }
 
+static const struct file_operations nubus_devices_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nubus_devices_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static struct proc_dir_entry *proc_bus_nubus_dir;
 
 static void nubus_proc_subdir(struct nubus_dev* dev,
@@ -172,7 +171,6 @@ void __init nubus_proc_init(void)
 	if (!MACH_IS_MAC)
 		return;
 	proc_bus_nubus_dir = proc_mkdir("bus/nubus", NULL);
-	create_proc_info_entry("devices", 0, proc_bus_nubus_dir,
-				get_nubus_dev_info);
+	proc_create("devices", 0, proc_bus_nubus_dir, &nubus_devices_proc_fops);
 	proc_bus_nubus_add_devices();
 }
-- 
1.5.4.3

