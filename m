Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZDXOrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZDXOrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZDXOrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:47:42 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:34593 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZDXOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:47:41 -0400
Date: Fri, 24 Apr 2009 18:47:38 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Richard Henderson <rth@twiddle.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: binfmt_aout fix
Message-ID: <20090424144738.GD32087@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the problem introduced by commit 3bfacef412 (get rid of
special-casing the /sbin/loader on alpha): osf/1 ecoff binary
segfaults when binfmt_aout built as module. That happens because
aout binary handler gets on the top of the binfmt list due to late
registration, and kernel attempts to execute the binary without
preparatory work that must be done by binfmt_loader.

Fixed by changing the registration order of the default
binfmt handlers using list_add_tail() and introducing insert_binfmt()
function which places new handler on the top of the binfmt list.
This might be generally useful for installing arch-specific frontends
for default handlers or just for overriding them.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/Makefile        |    6 +++++-
 arch/alpha/kernel/binfmt_loader.c |    2 +-
 fs/exec.c                         |    7 ++++---
 include/linux/binfmts.h           |   14 +++++++++++++-
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index a427538..7739a62 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -8,7 +8,7 @@ EXTRA_CFLAGS	:= -Werror -Wno-sign-compare
 
 obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
-	    alpha_ksyms.o systbls.o err_common.o io.o binfmt_loader.o
+	    alpha_ksyms.o systbls.o err_common.o io.o
 
 obj-$(CONFIG_VGA_HOSE)	+= console.o
 obj-$(CONFIG_SMP)	+= smp.o
@@ -43,6 +43,10 @@ else
 # Misc support
 obj-$(CONFIG_ALPHA_SRM)		+= srmcons.o
 
+ifdef CONFIG_BINFMT_AOUT
+obj-y	+= binfmt_loader.o
+endif
+
 # Core logic support
 obj-$(CONFIG_ALPHA_APECS)	+= core_apecs.o
 obj-$(CONFIG_ALPHA_CIA)		+= core_cia.o
diff --git a/arch/alpha/kernel/binfmt_loader.c b/arch/alpha/kernel/binfmt_loader.c
index 4a0af90..3fcfad4 100644
--- a/arch/alpha/kernel/binfmt_loader.c
+++ b/arch/alpha/kernel/binfmt_loader.c
@@ -46,6 +46,6 @@ static struct linux_binfmt loader_format = {
 
 static int __init init_loader_binfmt(void)
 {
-	return register_binfmt(&loader_format);
+	return insert_binfmt(&loader_format);
 }
 arch_initcall(init_loader_binfmt);
diff --git a/fs/exec.c b/fs/exec.c
index 052a961..974098d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -69,17 +69,18 @@ int suid_dumpable = 0;
 static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
-int register_binfmt(struct linux_binfmt * fmt)
+int __register_binfmt(struct linux_binfmt * fmt, int insert)
 {
 	if (!fmt)
 		return -EINVAL;
 	write_lock(&binfmt_lock);
-	list_add(&fmt->lh, &formats);
+	insert ? list_add(&fmt->lh, &formats) :
+		 list_add_tail(&fmt->lh, &formats);
 	write_unlock(&binfmt_lock);
 	return 0;	
 }
 
-EXPORT_SYMBOL(register_binfmt);
+EXPORT_SYMBOL(__register_binfmt);
 
 void unregister_binfmt(struct linux_binfmt * fmt)
 {
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 6638b81..61ee18c 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -82,7 +82,19 @@ struct linux_binfmt {
 	int hasvdso;
 };
 
-extern int register_binfmt(struct linux_binfmt *);
+extern int __register_binfmt(struct linux_binfmt *fmt, int insert);
+
+/* Registration of default binfmt handlers */
+static inline int register_binfmt(struct linux_binfmt *fmt)
+{
+	return __register_binfmt(fmt, 0);
+}
+/* Same as above, but adds a new binfmt at the top of the list */
+static inline int insert_binfmt(struct linux_binfmt *fmt)
+{
+	return __register_binfmt(fmt, 1);
+}
+
 extern void unregister_binfmt(struct linux_binfmt *);
 
 extern int prepare_binprm(struct linux_binprm *);
