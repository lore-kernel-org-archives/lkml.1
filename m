Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZEZIgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZEZIgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZEZIgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:36:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbZEZIgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:36:16 -0400
Date: Tue, 26 May 2009 04:35:31 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, jdike@addtoit.com,
       mingo@elte.hu, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090526083743.5050.29667.sendpatchset@localhost.localdomain>
In-Reply-To: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
Subject: [Patch 3/4] uml module: fix uml build process due to this merge
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Due to the previous merge, uml needs to be fixed.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
Index: linux-2.6/arch/um/sys-i386/Makefile
===================================================================
--- linux-2.6.orig/arch/um/sys-i386/Makefile
+++ linux-2.6/arch/um/sys-i386/Makefile
@@ -8,7 +8,7 @@ obj-y = bug.o bugs.o checksum.o delay.o 
 
 subarch-obj-y = lib/semaphore_32.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
-subarch-obj-$(CONFIG_MODULES) += kernel/module_32.o
+subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 USER_OBJS := bugs.o ptrace_user.o fault.o
 
Index: linux-2.6/arch/um/sys-x86_64/Makefile
===================================================================
--- linux-2.6.orig/arch/um/sys-x86_64/Makefile
+++ linux-2.6/arch/um/sys-x86_64/Makefile
@@ -8,10 +8,8 @@ obj-y = bug.o bugs.o delay.o fault.o ldt
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
-obj-$(CONFIG_MODULES) += um_module.o
-
 subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
-subarch-obj-$(CONFIG_MODULES) += kernel/module_64.o
+subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 ldt-y = ../sys-i386/ldt.o
 
Index: linux-2.6/arch/um/sys-x86_64/um_module.c
===================================================================
--- linux-2.6.orig/arch/um/sys-x86_64/um_module.c
+++ /dev/null
@@ -1,21 +0,0 @@
-#include <linux/vmalloc.h>
-#include <linux/moduleloader.h>
-
-/* Copied from i386 arch/i386/kernel/module.c */
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc_exec(size);
-}
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-	/*
-	 * FIXME: If module_region == mod->init_region, trim exception
-	 * table entries.
-	 */
-}
-
