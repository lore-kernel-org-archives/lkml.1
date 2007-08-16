Return-Path: <linux-kernel-owner+w=401wt.eu-S1763943AbXHPH0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763943AbXHPH0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXHPH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:26:17 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:40609 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbXHPH0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:26:15 -0400
X-IronPort-AV: i="4.19,270,1183348800"; 
   d="scan'208"; a="48464455:sNHT29803081"
Subject: [PATCH 1/2] Add a new field `name' to struct linux_binfmt
From: Jie Zhang <jie.zhang@analog.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 16 Aug 2007 15:20:23 +0800
Message-Id: <1187248823.11475.24.camel@mercury.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 16 Aug 2007 07:26:12.0984 (UTC) FILETIME=[B9666780:01C7DFD6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Blackfin arch supports two binfmts: `flat' and `FDPIC ELF'. Sometimes we
need deal with them differently. For example, when application crashes,
something like below will be dumped:

        Undefined instruction
         - May be used to emulate instructions that are not defined for
         a particular processor implementation.
        
        CURRENT PROCESS:
        
        COMM=testmain PID=63
        TEXT = 0x01180000-0x011dd258  DATA = 0x01300258-0x013ac4a0
        BSS = 0x013ac4a0-0x010a0000   USER-STACK = 0x010bfec0

For `flat' binfmt, there is a sperate BSS. But for `FDPIC ELF', .bss is
usually put into the same segment as .data. So DATA has include .bss
section. The BSS for `FDPIC ELF' is meaningless and confusing, like the
one shown above. So I want to omit BSS for `FDPIC ELF' in dumping.

When mapping address to symbol in application, we also need deal with
`flat' and `FDPIC ELF' binfmts differently, since `flat' has a header
before the code.

This patch addes a new `name' field to struct linux_binfmt and
initialize it in each binfmt type.

A second blackfin arch patch will use this field to distinguish `flat'
binfmt with `FDPIC ELF'.

Is it OK? Any comments?

Thanks,
Jie


Signed-off-by: Jie Zhang <jie.zhang@analog.com>
---
 fs/binfmt_aout.c        |    3 ++-
 fs/binfmt_elf.c         |    3 ++-
 fs/binfmt_elf_fdpic.c   |    1 +
 fs/binfmt_em86.c        |    1 +
 fs/binfmt_flat.c        |    3 ++-
 fs/binfmt_misc.c        |    1 +
 fs/binfmt_script.c      |    1 +
 fs/binfmt_som.c         |    3 ++-
 include/linux/binfmts.h |    1 +
 9 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 813a887..a54a25e 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -38,7 +38,8 @@ static struct linux_binfmt aout_format = {
 	.load_binary	= load_aout_binary,
 	.load_shlib	= load_aout_library,
 	.core_dump	= aout_core_dump,
-	.min_coredump	= PAGE_SIZE
+	.min_coredump	= PAGE_SIZE,
+	.name		= "aout"
 };
 
 #define BAD_ADDR(x)	((unsigned long)(x) >= TASK_SIZE)
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4482a06..5d1e039 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -77,7 +77,8 @@ static struct linux_binfmt elf_format = {
 		.load_shlib	= load_elf_library,
 		.core_dump	= elf_core_dump,
 		.min_coredump	= ELF_EXEC_PAGESIZE,
-		.hasvdso	= 1
+		.hasvdso	= 1,
+		.name		= "ELF"
 };
 
 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 2f5d8db..3eaa2ec 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -85,6 +85,7 @@ static struct linux_binfmt elf_fdpic_format = {
 	.core_dump	= elf_fdpic_core_dump,
 #endif
 	.min_coredump	= ELF_EXEC_PAGESIZE,
+	.name		= "ELF FDPIC"
 };
 
 static int __init init_elf_fdpic_binfmt(void)
diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index 576dd7d..60036f9 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -97,6 +97,7 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 static struct linux_binfmt em86_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_em86,
+	.name		= "em86"
 };
 
 static int __init init_em86_binfmt(void)
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 861141b..b21deee 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -81,7 +81,8 @@ static struct linux_binfmt flat_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_flat_binary,
 	.core_dump	= flat_core_dump,
-	.min_coredump	= PAGE_SIZE
+	.min_coredump	= PAGE_SIZE,
+	.name		= "flat"
 };
 
 /****************************************************************************/
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 42e94b3..6df9da0 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -737,6 +737,7 @@ static int bm_get_sb(struct file_system_type *fs_type,
 static struct linux_binfmt misc_format = {
 	.module = THIS_MODULE,
 	.load_binary = load_misc_binary,
+	.name = "misc"
 };
 
 static struct file_system_type bm_fs_type = {
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 4d0e0f6..cdec898 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -100,6 +100,7 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 static struct linux_binfmt script_format = {
 	.module		= THIS_MODULE,
 	.load_binary	= load_script,
+	.name		= "script"
 };
 
 static int __init init_script_binfmt(void)
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index 5bcdaaf..4041d84 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -58,7 +58,8 @@ static struct linux_binfmt som_format = {
 	.load_binary	= load_som_binary,
 	.load_shlib	= load_som_library,
 	.core_dump	= som_core_dump,
-	.min_coredump	= SOM_PAGESIZE
+	.min_coredump	= SOM_PAGESIZE,
+	.name		= "SOM"
 };
 
 /*
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 91c8c07..b784784 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -70,6 +70,7 @@ struct linux_binfmt {
 	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
+	const char *name;
 };
 
 extern int register_binfmt(struct linux_binfmt *);
-- 
1.5.2.4
