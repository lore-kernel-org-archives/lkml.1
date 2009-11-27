Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZK0Nwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZK0Nwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZK0Nwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:52:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34734 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZK0Nwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:52:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nji3PaZYPukgW9XzEQRatYp7ycMkpoIbvLqEEizF4qermFGoBt7fbw0Xr6Ur6HRYKh
         x7RJquuFmU7WFojR4JCIN3p7hCCPy7xP2V2Vt9UYrWMfzB8KP10IPn2O/Dor+oxaLRwV
         dQFyBZNZLXHrWTHRIKDsSAcLyyfcalThp4qrU=
Date: Fri, 27 Nov 2009 16:52:41 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH v2] arm: convert /proc/cpu/alignment to seq_file 
Message-ID: <20091127135240.GA19410@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Fix compilation on some arm defconfigs due to THIS_MODULE
 by removing line.

 arch/arm/mm/alignment.c |   53 +++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
@@ -91,36 +92,29 @@ static const char *usermode_action[] = {
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
 
-	len = (p - page) - off;
-	if (len < 0)
-		len = 0;
-
-	*eof = (len <= count) ? 1 : 0;
-	*start = page + off;
+	return 0;
+}
 
-	return len;
+static int alignment_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, alignment_proc_show, NULL);
 }
 
-static int proc_alignment_write(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+static ssize_t alignment_proc_write(struct file *file, const char __user *buffer,
+				    size_t count, loff_t *pos)
 {
 	char mode;
 
@@ -133,6 +127,13 @@ static int proc_alignment_write(struct file *file, const char __user *buffer,
 	return count;
 }
 
+static const struct file_operations alignment_proc_fops = {
+	.open		= alignment_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= alignment_proc_write,
+};
 #endif /* CONFIG_PROC_FS */
 
 union offset_union {
@@ -902,12 +903,10 @@ static int __init alignment_init(void)
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
 
 	/*
