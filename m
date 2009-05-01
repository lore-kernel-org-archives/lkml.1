Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbZEAAMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbZEAAMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765149AbZEAABv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:01:51 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61651 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765115AbZEAABu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:01:50 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 08/11] x86: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 20:01:35 -0400
Message-Id: <1241136098-10376-9-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-8-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
 <1241136098-10376-5-git-send-email-tabbott@mit.edu>
 <1241136098-10376-6-git-send-email-tabbott@mit.edu>
 <1241136098-10376-7-git-send-email-tabbott@mit.edu>
 <1241136098-10376-8-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.  This has the consequence of moving
the init_task data inside _edata, which I think should be OK.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/init_task.c   |    3 +--
 arch/x86/kernel/vmlinux.lds.S |   13 ++++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index df3bf26..e0383af 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -21,8 +21,7 @@ struct mm_struct init_mm = INIT_MM(init_mm);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index c7d54bf..6b8a633 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -102,6 +102,7 @@ SECTIONS
 	/* Data */
 	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		INIT_TASK_DATA(THREAD_SIZE)
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
 #ifdef CONFIG_X86_32
@@ -205,15 +206,6 @@ SECTIONS
 
 #endif /* CONFIG_X86_64 */
 
-	/* init_task */
-	. = ALIGN(THREAD_SIZE);
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
-	}
-#ifdef CONFIG_X86_64
-	 :data.init
-#endif
-
 	/*
 	 * smp_locks might be freed after init
 	 * start/end must be page aligned
@@ -225,6 +217,9 @@ SECTIONS
 		__smp_locks_end = .;
 		. = ALIGN(PAGE_SIZE);
 	}
+#ifdef CONFIG_X86_64
+	 :data.init
+#endif
 
 	/* Init code and data - will be freed after init */
 	. = ALIGN(PAGE_SIZE);
-- 
1.6.2.1

