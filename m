Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbXGPN1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbXGPN1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765385AbXGPN11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:27:27 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:27745 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765353AbXGPN1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:27:25 -0400
Date: Mon, 16 Jul 2007 17:26:33 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 1/2] Use list_head in binfmt handling
Message-ID: <20070716132633.GA11126@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch single-linked binfmt formats list to usual list_head's.
This leads to one-liners in register_binfmt() and unregister_binfmt().
The downside is one pointer more in struct linux_binfmt. This is not a
problem, since the set of registered binfmts on typical box is very small
(ELF + something distro enabled for you).

Test-booted, played with executable .txt files, modprobe/rmmod binfmt_misc.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/exec.c               |   34 ++++++----------------------------
 include/linux/binfmts.h |    3 +--
 2 files changed, 7 insertions(+), 30 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -66,27 +66,15 @@ int suid_dumpable = 0;
 EXPORT_SYMBOL(suid_dumpable);
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
-static struct linux_binfmt *formats;
+static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
 int register_binfmt(struct linux_binfmt * fmt)
 {
-	struct linux_binfmt ** tmp = &formats;
-
 	if (!fmt)
 		return -EINVAL;
-	if (fmt->next)
-		return -EBUSY;
 	write_lock(&binfmt_lock);
-	while (*tmp) {
-		if (fmt == *tmp) {
-			write_unlock(&binfmt_lock);
-			return -EBUSY;
-		}
-		tmp = &(*tmp)->next;
-	}
-	fmt->next = formats;
-	formats = fmt;
+	list_add(&fmt->lh, &formats);
 	write_unlock(&binfmt_lock);
 	return 0;	
 }
@@ -95,20 +83,10 @@ EXPORT_SYMBOL(register_binfmt);
 
 int unregister_binfmt(struct linux_binfmt * fmt)
 {
-	struct linux_binfmt ** tmp = &formats;
-
 	write_lock(&binfmt_lock);
-	while (*tmp) {
-		if (fmt == *tmp) {
-			*tmp = fmt->next;
-			fmt->next = NULL;
-			write_unlock(&binfmt_lock);
-			return 0;
-		}
-		tmp = &(*tmp)->next;
-	}
+	list_del(&fmt->lh);
 	write_unlock(&binfmt_lock);
-	return -EINVAL;
+	return 0;
 }
 
 EXPORT_SYMBOL(unregister_binfmt);
@@ -155,7 +133,7 @@ asmlinkage long sys_uselib(const char __user * library)
 		struct linux_binfmt * fmt;
 
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			if (!fmt->load_shlib)
 				continue;
 			if (!try_module_get(fmt->module))
@@ -1097,7 +1075,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
 			if (!fn)
 				continue;
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -55,7 +55,7 @@ struct linux_binprm{
  * linux accepts.
  */
 struct linux_binfmt {
-	struct linux_binfmt * next;
+	struct list_head lh;
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);

