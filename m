Return-Path: <linux-kernel-owner+w=401wt.eu-S1764417AbZD3XyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764417AbZD3XyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZD3XvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:51:06 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59956 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763299AbZD3XvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:51:02 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/2] m68k: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:49:23 -0400
Message-Id: <1241135363-8506-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135363-8506-2-git-send-email-tabbott@mit.edu>
References: <1241135363-8506-1-git-send-email-tabbott@mit.edu>
 <1241135363-8506-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.

I changed the aligment in both linker scripts to be THREAD_SIZE from
8192 and PAGE_SIZE, respectively.  I'd like an ack from one of the
m68k maintainers that this is right.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/kernel/process.c        |    4 ++--
 arch/m68k/kernel/vmlinux-std.lds  |    3 +--
 arch/m68k/kernel/vmlinux-sun3.lds |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index ec37fb5..6bf2cac 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -46,8 +46,8 @@ struct mm_struct init_mm = INIT_MM(init_mm);
 
 EXPORT_SYMBOL(init_mm);
 
-union thread_union init_thread_union
-__attribute__((section(".data.init_task"), aligned(THREAD_SIZE)))
+union thread_union init_thread_union __init_task_data
+__attribute__((aligned(THREAD_SIZE)))
        = { INIT_THREAD_INFO(init_task) };
 
 /* initial task structure */
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index ac800bc..9e3cd1d 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -30,6 +30,7 @@ SECTIONS
   RODATA
 
   .data : {			/* Data */
+	INIT_TASK_DATA(THREAD_SIZE)
 	CACHELINE_ALIGNED_DATA(16)
 	DATA_DATA
 	CONSTRUCTORS
@@ -76,8 +77,6 @@ SECTIONS
   . = ALIGN(8192);
   __init_end = .;
 
-  .data.init_task : { *(.data.init_task) }	/* The initial task and kernel stack */
-
   _end = . ;
 
   /* Sections to be discarded */
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index c192f77..8a988db 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -24,6 +24,7 @@ SECTIONS
   _etext = .;			/* End of text section */
 
   .data : {			/* Data */
+	INIT_TASK_DATA(THREAD_SIZE)
 	DATA_DATA
 	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
@@ -70,7 +71,6 @@ __init_begin = .;
 #endif
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-	.data.init.task : { *(.data.init_task) }
 
 
   .bss : { *(.bss) }		/* BSS */
-- 
1.6.2.1

