Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbZEAASB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbZEAASB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765346AbZEAADX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:23 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61952 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765151AbZEAADW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:22 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Chris Zankel <chris@zankel.net>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/3] xtensa: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 20:00:27 -0400
Message-Id: <1241136027-10244-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136027-10244-3-git-send-email-tabbott@mit.edu>
References: <1241136027-10244-1-git-send-email-tabbott@mit.edu>
 <1241136027-10244-2-git-send-email-tabbott@mit.edu>
 <1241136027-10244-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.  Also replace aligment of 8192 with
THREAD_SIZE (=8192).

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/kernel/init_task.c   |    3 +--
 arch/xtensa/kernel/vmlinux.lds.S |    5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/init_task.c b/arch/xtensa/kernel/init_task.c
index e07f5c9..dfda282 100644
--- a/arch/xtensa/kernel/init_task.c
+++ b/arch/xtensa/kernel/init_task.c
@@ -27,8 +27,7 @@ struct mm_struct init_mm = INIT_MM(init_mm);
 
 EXPORT_SYMBOL(init_mm);
 
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 { INIT_THREAD_INFO(init_task) };
 
 struct task_struct init_task = INIT_TASK(init_task);
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 165a980..3eacf74 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -121,6 +121,7 @@ SECTIONS
   _fdata = .;
   .data :
   {
+    INIT_TASK_DATA(THREAD_SIZE)
     DATA_DATA
     CONSTRUCTORS
     CACHELINE_ALIGNED_DATA(XCHAL_ICACHE_LINESIZE)
@@ -128,10 +129,6 @@ SECTIONS
 
   _edata = .;
 
-  /* The initial task */
-  . = ALIGN(8192);
-  .data.init_task : { *(.data.init_task) }
-
   /* Initialization code and data: */
 
   . = ALIGN(1 << 12);
-- 
1.6.2.1

