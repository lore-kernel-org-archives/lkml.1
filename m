Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXGYK5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXGYK5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbXGYK4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:56:55 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:38604 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbXGYK4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:56:54 -0400
Date: Wed, 25 Jul 2007 14:56:46 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] Use list_head in binfmt handling
Message-ID: <20070725105646.GA11047@localhost.sw.ru>
References: <200707250521.l6P5LIOp018521@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707250521.l6P5LIOp018521@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 10:16:44PM -0700, akpm@linux-foundation.org wrote:
> arch/sparc64/kernel/binfmt_aout32.c:41: warning: missing braces around initializer
> arch/sparc64/kernel/binfmt_aout32.c:41: warning: (near initialization for `aout32_format.lh')
> arch/sparc64/kernel/binfmt_aout32.c:41: warning: initialization from incompatible pointer type
> arch/sparc64/kernel/binfmt_aout32.c:41: warning: initialization from incompatible pointer type
> arch/sparc64/kernel/binfmt_aout32.c:41: warning: initialization from incompatible pointer type
> arch/sparc64/kernel/binfmt_aout32.c:41: warning: initialization from incompatible pointer type
> arch/sparc64/kernel/binfmt_aout32.c:43: warning: initialization makes pointer from integer without a cast

> --- a/arch/sparc64/kernel/binfmt_aout32.c~use-list_head-in-binfmt-handling-fix
> +++ a/arch/sparc64/kernel/binfmt_aout32.c
> @@ -38,8 +38,12 @@ static int load_aout32_library(struct fi
>  static int aout32_core_dump(long signr, struct pt_regs * regs, struct file *file);
>  
>  static struct linux_binfmt aout32_format = {
> -	NULL, THIS_MODULE, load_aout32_binary, load_aout32_library, aout32_core_dump,
> -	PAGE_SIZE
> +	.lh	=	LIST_HEAD_INIT(aout32_format.lh),
> +	.module =	THIS_MODULE,
> +	.load_binary =	load_aout32_binary,
> +	.load_shlib =	load_aout32_library,
> +	.core_dump =	aout32_core_dump,
> +	.min_coredump =	PAGE_SIZE,
>  };

Doh! Thanks, Andrew.

list_head initialization is unneeded, because register_binfmt() will
reinitialize it anyway.

Here is final version which was test-compiled on sparc64 and on mips
(after irixelf.c BROKEN removal):



[PATCH 1/2] Use list_head in binfmt handling

Switch single-linked binfmt formats list to usual list_head's.
This leads to one-liners in register_binfmt() and unregister_binfmt().
The downside is one pointer more in struct linux_binfmt. This is not a
problem, since the set of registered binfmts on typical box is very small --
(ELF + something distro enabled for you).

Test-booted, played with executable .txt files, modprobe/rmmod binfmt_misc.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/mips/kernel/irixelf.c          |    7 +++++--
 arch/sparc64/kernel/binfmt_aout32.c |    7 +++++--
 fs/exec.c                           |   34 ++++++----------------------------
 include/linux/binfmts.h             |    2 +-
 4 files changed, 17 insertions(+), 33 deletions(-)

--- a/arch/mips/kernel/irixelf.c
+++ b/arch/mips/kernel/irixelf.c
@@ -47,8 +47,11 @@ static int irix_core_dump(long signr, struct pt_regs * regs,
                           struct file *file);
 
 static struct linux_binfmt irix_format = {
-	NULL, THIS_MODULE, load_irix_binary, load_irix_library,
-	irix_core_dump, PAGE_SIZE
+	.module		= THIS_MODULE,
+	.load_binary	= load_irix_binary,
+	.load_shlib	= load_irix_library,
+	.core_dump	= irix_core_dump,
+	.min_coredump	= PAGE_SIZE,
 };
 
 /* Debugging routines. */
--- a/arch/sparc64/kernel/binfmt_aout32.c
+++ b/arch/sparc64/kernel/binfmt_aout32.c
@@ -38,8 +38,11 @@ static int load_aout32_library(struct file*);
 static int aout32_core_dump(long signr, struct pt_regs * regs, struct file *file);
 
 static struct linux_binfmt aout32_format = {
-	NULL, THIS_MODULE, load_aout32_binary, load_aout32_library, aout32_core_dump,
-	PAGE_SIZE
+	.module		= THIS_MODULE,
+	.load_binary	= load_aout32_binary,
+	.load_shlib	= load_aout32_library,
+	.core_dump	= aout32_core_dump,
+	.min_coredump	= PAGE_SIZE,
 };
 
 static void set_brk(unsigned long start, unsigned long end)
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -67,27 +67,15 @@ int suid_dumpable = 0;
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
@@ -96,20 +84,10 @@ EXPORT_SYMBOL(register_binfmt);
 
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
@@ -156,7 +134,7 @@ asmlinkage long sys_uselib(const char __user * library)
 		struct linux_binfmt * fmt;
 
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			if (!fmt->load_shlib)
 				continue;
 			if (!try_module_get(fmt->module))
@@ -1290,7 +1268,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
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
@@ -63,7 +63,7 @@ struct linux_binprm{
  * linux accepts.
  */
 struct linux_binfmt {
-	struct linux_binfmt * next;
+	struct list_head lh;
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);

