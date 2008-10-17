Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYJQMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYJQMlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYJQMlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:41:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:65202 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYJQMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VDL7Tyg5OQ0NCmI6q2u85jvFJ0Fn+OyXn2BdebizQL3DWCkvZUaRsTm2h8gEmqVdGM
         1MC+VXd72cbb3rmAwM+nmzSsgvViFOXXUstVSh7izw0g34nktIotxOWV+zfPvq/dRXFs
         UzD08T4U8H84BvU03xA9vwofco14hpdomFQgE=
Date: Fri, 17 Oct 2008 16:44:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/31] proc: move /proc/execdomains to kernel/exec_domain.c
Message-ID: <20081017124401.GJ22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 25da5017a8f837806bafada95be3cf5a79bb7344 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 4 Oct 2008 14:28:09 +0400
Subject: [PATCH 09/31] proc: move /proc/execdomains to kernel/exec_domain.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c  |    9 ---------
 kernel/exec_domain.c |   33 +++++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 60c35a0..2cc8288 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -62,7 +62,6 @@
  * have a way to deal with that gracefully. Right now I used straightforward
  * wrappers, but this needs further analysis wrt potential overflows.
  */
-extern int get_exec_domain_list(char *);
 
 static int proc_calc_metrics(char *page, char **start, off_t off,
 				 int count, int *eof, int len)
@@ -488,13 +487,6 @@ static const struct file_operations proc_locks_operations = {
 };
 #endif /* CONFIG_FILE_LOCKING */
 
-static int execdomains_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len = get_exec_domain_list(page);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -634,7 +626,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-		{"execdomains",	execdomains_read_proc},
 		{NULL,}
 	};
 	for (p = simple_ones; p->name; p++)
diff --git a/kernel/exec_domain.c b/kernel/exec_domain.c
index 0d407e8..0511716 100644
--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -12,7 +12,9 @@
 #include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/personality.h>
+#include <linux/proc_fs.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 #include <linux/types.h>
@@ -173,20 +175,39 @@ __set_personality(u_long personality)
 	return 0;
 }
 
-int
-get_exec_domain_list(char *page)
+#ifdef CONFIG_PROC_FS
+static int execdomains_proc_show(struct seq_file *m, void *v)
 {
 	struct exec_domain	*ep;
-	int			len = 0;
 
 	read_lock(&exec_domains_lock);
-	for (ep = exec_domains; ep && len < PAGE_SIZE - 80; ep = ep->next)
-		len += sprintf(page + len, "%d-%d\t%-16s\t[%s]\n",
+	for (ep = exec_domains; ep; ep = ep->next)
+		seq_printf(m, "%d-%d\t%-16s\t[%s]\n",
 			       ep->pers_low, ep->pers_high, ep->name,
 			       module_name(ep->module));
 	read_unlock(&exec_domains_lock);
-	return (len);
+	return 0;
+}
+
+static int execdomains_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, execdomains_proc_show, NULL);
+}
+
+static const struct file_operations execdomains_proc_fops = {
+	.open		= execdomains_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_execdomains_init(void)
+{
+	proc_create("execdomains", 0, NULL, &execdomains_proc_fops);
+	return 0;
 }
+module_init(proc_execdomains_init);
+#endif
 
 asmlinkage long
 sys_personality(u_long personality)
-- 
1.5.6.5

