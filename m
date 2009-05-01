Return-Path: <linux-kernel-owner+w=401wt.eu-S933657AbZEAA34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbZEAA34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760794AbZEAAHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:07:12 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62553 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765679AbZEAAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:07:09 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/5] ia64: use new macros for .data.init_task
Date: Thu, 30 Apr 2009 20:04:05 -0400
Message-Id: <1241136247-10623-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136247-10623-3-git-send-email-tabbott@mit.edu>
References: <1241136247-10623-1-git-send-email-tabbott@mit.edu>
 <1241136247-10623-2-git-send-email-tabbott@mit.edu>
 <1241136247-10623-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/init_task.c   |    2 +-
 arch/ia64/kernel/vmlinux.lds.S |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/init_task.c b/arch/ia64/kernel/init_task.c
index 5b0e830..8b7bbed 100644
--- a/arch/ia64/kernel/init_task.c
+++ b/arch/ia64/kernel/init_task.c
@@ -37,7 +37,7 @@ union {
 		struct thread_info thread_info;
 	} s;
 	unsigned long stack[KERNEL_STACK_SIZE/sizeof (unsigned long)];
-} init_task_mem asm ("init_task") __attribute__((section(".data.init_task"))) = {{
+} init_task_mem asm ("init_task") __init_task_data = {{
 	.task =		INIT_TASK(init_task_mem.s.task),
 	.thread_info =	INIT_THREAD_INFO(init_task_mem.s.task)
 }};
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index cdcd655..9c4cc29 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -214,10 +214,6 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
-  /* The initial task and kernel stack */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET)
-	{ *(.data.init_task) }
-
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET)
         { *(__special_page_section)
 	  __start_gate_section = .;
@@ -253,6 +249,7 @@ SECTIONS
 		__cpu0_per_cpu = .;
   . = . + PERCPU_PAGE_SIZE;	/* cpu0 per-cpu space */
 #endif
+		INIT_TASK_DATA(PAGE_SIZE)
 		CACHELINE_ALIGNED_DATA(SMP_CACHE_BYTES)
 		DATA_DATA
 		*(.data1)
-- 
1.6.2.1

