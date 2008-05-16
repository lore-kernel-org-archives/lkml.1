Return-Path: <linux-kernel-owner+w=401wt.eu-S1760531AbYEPWjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531AbYEPWjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYEPWjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:39:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:8799 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYEPWjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MufWfX7fQujVEJ62fMpPRcwjDlG+llA7gOZwWTsHqKNWDJnAW+JipF7rcmvLNhrUnJj9+MWYy76sEBjyWIWmsmS8qVoRVRQILmxvoHQKiape2MGPOakKAh4mnBA8pYyUPqFI+79xQ0HUQWwWurNokMcHlG8qfjD2lTKW8xe0srw=
Date: Sat, 17 May 2008 03:34:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, rmk@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arm: switch /proc/cpu/alignment to seq_files
Message-ID: <20080516233458.GA27794@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/mm/alignment.c |   55 +++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 
 #include <asm/uaccess.h>
@@ -80,36 +81,28 @@ static const char *usermode_action[] = {
 	"signal+warn"
 };
 
-static int
-proc_alignment_read(char *page, char **start, off_t off, int count, int *eof,
-		    void *data)
+static int alignment_proc_show(struct seq_file *m, void *v)
 {
-	char *p = page;
-	int len;
-
-	p += sprintf(p, "User:\t\t%lu\n", ai_user);
-	p += sprintf(p, "System:\t\t%lu\n", ai_sys);
-	p += sprintf(p, "Skipped:\t%lu\n", ai_skipped);
-	p += sprintf(p, "Half:\t\t%lu\n", ai_half);
-	p += sprintf(p, "Word:\t\t%lu\n", ai_word);
+	seq_printf(m, "User:\t\t%lu\n", ai_user);
+	seq_printf(m, "System:\t\t%lu\n", ai_sys);
+	seq_printf(m, "Skipped:\t%lu\n", ai_skipped);
+	seq_printf(m, "Half:\t\t%lu\n", ai_half);
+	seq_printf(m, "Word:\t\t%lu\n", ai_word);
 	if (cpu_architecture() >= CPU_ARCH_ARMv5TE)
-		p += sprintf(p, "DWord:\t\t%lu\n", ai_dword);
-	p += sprintf(p, "Multi:\t\t%lu\n", ai_multi);
-	p += sprintf(p, "User faults:\t%i (%s)\n", ai_usermode,
+		seq_printf(m, "DWord:\t\t%lu\n", ai_dword);
+	seq_printf(m, "Multi:\t\t%lu\n", ai_multi);
+	seq_printf(m, "User faults:\t%i (%s)\n", ai_usermode,
 			usermode_action[ai_usermode]);
+	return 0;
+}
 
-	len = (p - page) - off;
-	if (len < 0)
-		len = 0;
-
-	*eof = (len <= count) ? 1 : 0;
-	*start = page + off;
-
-	return len;
+static int alignment_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, alignment_proc_show, NULL);
 }
 
-static int proc_alignment_write(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+static ssize_t alignment_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char mode;
 
@@ -122,6 +115,14 @@ static int proc_alignment_write(struct file *file, const char __user *buffer,
 	return count;
 }
 
+static const struct file_operations alignment_proc_fops = {
+	.open		= alignment_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= alignment_proc_write,
+};
+
 #endif /* CONFIG_PROC_FS */
 
 union offset_union {
@@ -788,12 +789,10 @@ static int __init alignment_init(void)
 	if (!res)
 		return -ENOMEM;
 
-	res = create_proc_entry("alignment", S_IWUSR | S_IRUGO, res);
+	res = proc_create("alignment", S_IWUSR | S_IRUGO, res,
+			  &alignment_proc_fops);
 	if (!res)
 		return -ENOMEM;
-
-	res->read_proc = proc_alignment_read;
-	res->write_proc = proc_alignment_write;
 #endif
 
 	hook_fault_code(1, do_alignment, SIGILL, "alignment exception");

