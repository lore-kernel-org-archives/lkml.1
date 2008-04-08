Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYDHOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYDHOz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYDHOzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:55:14 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:17126 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYDHOzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:55:13 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 04/12] proc: switch /proc/apm to seq_file interface
Date: Tue, 8 Apr 2008 18:54:35 +0400
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081854.36523.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 careful, my cross-compile farm is currently defunct

 drivers/char/apm-emulation.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -14,6 +14,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/miscdevice.h>
 #include <linux/apm_bios.h>
 #include <linux/capability.h>
@@ -493,11 +494,10 @@ static struct miscdevice apm_device = {
  *	-1: Unknown
  *   8) min = minutes; sec = seconds
  */
-static int apm_get_info(char *buf, char **start, off_t fpos, int length)
+static int proc_apm_show(struct seq_file *m, void *v)
 {
 	struct apm_power_info info;
 	char *units;
-	int ret;
 
 	info.ac_line_status = 0xff;
 	info.battery_status = 0xff;
@@ -515,14 +515,27 @@ static int apm_get_info(char *buf, char **start, off_t fpos, int length)
 	case 1: 	units = "sec";	break;
 	}
 
-	ret = sprintf(buf, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
+	seq_printf(m, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
 		     driver_version, APM_32_BIT_SUPPORT,
 		     info.ac_line_status, info.battery_status,
 		     info.battery_flag, info.battery_life,
 		     info.time, units);
 
-	return ret;
+	return 0;
 }
+
+static int proc_apm_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_apm_show, NULL);
+}
+
+static const struct file_operations apm_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_apm_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 static int kapmd(void *arg)
@@ -593,7 +606,7 @@ static int __init apm_init(void)
 	wake_up_process(kapmd_tsk);
 
 #ifdef CONFIG_PROC_FS
-	create_proc_info_entry("apm", 0, NULL, apm_get_info);
+	proc_create("apm", 0, NULL, &apm_proc_fops);
 #endif
 
 	ret = misc_register(&apm_device);
-- 
1.5.4.3

