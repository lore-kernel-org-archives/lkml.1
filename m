Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbZD3XqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbZD3XqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759726AbZD3Xpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:45:41 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59117 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759556AbZD3Xpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:45:40 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/3] frv: use new macros for .data.init_task
Date: Thu, 30 Apr 2009 19:45:34 -0400
Message-Id: <1241135135-8084-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135135-8084-2-git-send-email-tabbott@mit.edu>
References: <1241135135-8084-1-git-send-email-tabbott@mit.edu>
 <1241135135-8084-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/init_task.c   |    3 +--
 arch/frv/kernel/vmlinux.lds.S |    8 +-------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/frv/kernel/init_task.c b/arch/frv/kernel/init_task.c
index 29429a8..9f182b3 100644
--- a/arch/frv/kernel/init_task.c
+++ b/arch/frv/kernel/init_task.c
@@ -23,8 +23,7 @@ EXPORT_SYMBOL(init_mm);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index dc61f3e..d19d3c0 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -69,13 +69,6 @@ SECTIONS
   . = ALIGN(THREAD_SIZE);
   __init_end = .;
 
-  /* put sections together that have massive alignment issues */
-  . = ALIGN(THREAD_SIZE);
-  .data.init_task : {
-	  /* init task record & stack */
-	  *(.data.init_task)
-  }
-
   .trap : {
 	/* trap table management - read entry-table.S before modifying */
 	. = ALIGN(8192);
@@ -128,6 +121,7 @@ SECTIONS
 
   _sdata = .;
   .data : {			/* Data */
+	INIT_TASK_DATA(THREAD_SIZE)
 	CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 	DATA_DATA
 	*(.data.*)
-- 
1.6.2.1

