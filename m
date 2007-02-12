Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXBLHoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXBLHoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXBLHn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:43:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:38414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099AbXBLHiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:16 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [27/39] i386: APM on i386
Message-Id: <20070212073815.2591A13DD5@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexey Dobriyan <adobriyan@gmail.com>
Byte-to-byte identical /proc/apm here.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/apm.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/apm.c
===================================================================
--- linux.orig/arch/i386/kernel/apm.c
+++ linux/arch/i386/kernel/apm.c
@@ -211,6 +211,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/miscdevice.h>
 #include <linux/apm_bios.h>
 #include <linux/init.h>
@@ -1636,9 +1637,8 @@ static int do_open(struct inode * inode,
 	return 0;
 }
 
-static int apm_get_info(char *buf, char **start, off_t fpos, int length)
+static int proc_apm_show(struct seq_file *m, void *v)
 {
-	char *		p;
 	unsigned short	bx;
 	unsigned short	cx;
 	unsigned short	dx;
@@ -1650,8 +1650,6 @@ static int apm_get_info(char *buf, char 
 	int             time_units     = -1;
 	char            *units         = "?";
 
-	p = buf;
-
 	if ((num_online_cpus() == 1) &&
 	    !(error = apm_get_power_status(&bx, &cx, &dx))) {
 		ac_line_status = (bx >> 8) & 0xff;
@@ -1705,7 +1703,7 @@ static int apm_get_info(char *buf, char 
 	      -1: Unknown
 	   8) min = minutes; sec = seconds */
 
-	p += sprintf(p, "%s %d.%d 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
+	seq_printf(m, "%s %d.%d 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
 		     driver_version,
 		     (apm_info.bios.version >> 8) & 0xff,
 		     apm_info.bios.version & 0xff,
@@ -1716,10 +1714,22 @@ static int apm_get_info(char *buf, char 
 		     percentage,
 		     time_units,
 		     units);
+	return 0;
+}
 
-	return p - buf;
+static int proc_apm_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_apm_show, NULL);
 }
 
+static const struct file_operations apm_file_ops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_apm_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int apm(void *unused)
 {
 	unsigned short	bx;
@@ -2341,9 +2351,9 @@ static int __init apm_init(void)
 	set_base(gdt[APM_DS >> 3],
 		 __va((unsigned long)apm_info.bios.dseg << 4));
 
-	apm_proc = create_proc_info_entry("apm", 0, NULL, apm_get_info);
+	apm_proc = create_proc_entry("apm", 0, NULL);
 	if (apm_proc)
-		apm_proc->owner = THIS_MODULE;
+		apm_proc->proc_fops = &apm_file_ops;
 
 	kapmd_task = kthread_create(apm, NULL, "kapmd");
 	if (IS_ERR(kapmd_task)) {
