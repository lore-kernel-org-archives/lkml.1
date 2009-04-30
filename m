Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbZEAAbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbZEAAbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765885AbZEAAIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:08:45 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62761 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbZEAAIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:08:43 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 6/8] powerpc: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:56:15 -0400
Message-Id: <1241135777-9462-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135777-9462-6-git-send-email-tabbott@mit.edu>
References: <1241135777-9462-1-git-send-email-tabbott@mit.edu>
 <1241135777-9462-2-git-send-email-tabbott@mit.edu>
 <1241135777-9462-3-git-send-email-tabbott@mit.edu>
 <1241135777-9462-4-git-send-email-tabbott@mit.edu>
 <1241135777-9462-5-git-send-email-tabbott@mit.edu>
 <1241135777-9462-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.

This patch uses THREAD_SIZE rather than 8192/16384 for the alignment.
This should have the effect of increasing the alignment to 32768 if
CONFIG_PPC_256K_PAGES is defined, but it seems that it should be that
way.  One of the powerpc maintainers should confirm that this is
correct, otherwise we can go back to the #ifdef.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/init_task.c        |    3 +--
 arch/powerpc/kernel/machine_kexec_64.c |    4 ++--
 arch/powerpc/kernel/vmlinux.lds.S      |   13 +++----------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/init_task.c b/arch/powerpc/kernel/init_task.c
index 688b329..a4eb25d 100644
--- a/arch/powerpc/kernel/init_task.c
+++ b/arch/powerpc/kernel/init_task.c
@@ -20,8 +20,7 @@ EXPORT_SYMBOL(init_mm);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 49e705f..3761f76 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -10,6 +10,7 @@
  */
 
 
+#include <linux/init_task.h>
 #include <linux/kexec.h>
 #include <linux/smp.h>
 #include <linux/thread_info.h>
@@ -249,8 +250,7 @@ static void kexec_prepare_cpus(void)
  * We could use a smaller stack if we don't care about anything using
  * current, but that audit has not been performed.
  */
-static union thread_union kexec_stack
-	__attribute__((__section__(".data.init_task"))) = { };
+static union thread_union kexec_stack __init_task_data = { };
 
 /* Our assembly helper, in kexec_stub.S */
 extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index e769717..f91d7c1 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -6,6 +6,7 @@
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
+#include <asm/thread_info.h>
 
 ENTRY(_stext)
 
@@ -221,6 +222,8 @@ SECTIONS
 	_sdata = .;
 
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		/* The initial task and kernel stack */
+		INIT_TASK_DATA(THREAD_SIZE)
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
@@ -251,16 +254,6 @@ SECTIONS
 	_edata  =  .;
 	PROVIDE32 (edata = .);
 
-	/* The initial task and kernel stack */
-#ifdef CONFIG_PPC32
-	. = ALIGN(8192);
-#else
-	. = ALIGN(16384);
-#endif
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
-	}
-
 	. = ALIGN(L1_CACHE_BYTES);
 	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
 		*(.data.read_mostly)
-- 
1.6.2.1

