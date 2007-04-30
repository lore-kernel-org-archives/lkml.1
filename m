Return-Path: <linux-kernel-owner+w=401wt.eu-S1423473AbXD3Pyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423473AbXD3Pyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423476AbXD3PxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:53:12 -0400
Received: from mx1.suse.de ([195.135.220.2]:45038 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423474AbXD3Pt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:58 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [24/34] x86_64: Auto compute __NR_syscall_max at compile time
Message-Id: <20070430154957.41395151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


No need to maintain it anymore

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/asm-offsets.c |   10 ++++++++++
 arch/x86_64/kernel/syscall.c     |    1 +
 include/asm-x86_64/unistd.h      |    2 --
 3 files changed, 11 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/asm-offsets.c
===================================================================
--- linux.orig/arch/x86_64/kernel/asm-offsets.c
+++ linux/arch/x86_64/kernel/asm-offsets.c
@@ -21,6 +21,14 @@
 
 #define BLANK() asm volatile("\n->" : : )
 
+#define __NO_STUBS 1
+#undef __SYSCALL
+#undef _ASM_X86_64_UNISTD_H_
+#define __SYSCALL(nr, sym) [nr] = 1,
+static char syscalls[] = {
+#include <asm/unistd.h>
+};
+
 int main(void)
 {
 #define ENTRY(entry) DEFINE(tsk_ ## entry, offsetof(struct task_struct, entry))
@@ -71,5 +79,7 @@ int main(void)
 	DEFINE(TSS_ist, offsetof(struct tss_struct, ist));
 	BLANK();
 	DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
+	BLANK();
+	DEFINE(__NR_syscall_max, sizeof(syscalls) - 1);
 	return 0;
 }
Index: linux/arch/x86_64/kernel/syscall.c
===================================================================
--- linux.orig/arch/x86_64/kernel/syscall.c
+++ linux/arch/x86_64/kernel/syscall.c
@@ -3,6 +3,7 @@
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <linux/cache.h>
+#include <asm/asm-offsets.h>
 
 #define __NO_STUBS
 
Index: linux/include/asm-x86_64/unistd.h
===================================================================
--- linux.orig/include/asm-x86_64/unistd.h
+++ linux/include/asm-x86_64/unistd.h
@@ -620,8 +620,6 @@ __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
 
-#define __NR_syscall_max __NR_move_pages
-
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
