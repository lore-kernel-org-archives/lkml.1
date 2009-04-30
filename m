Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbZD3X5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbZD3X5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764346AbZD3XyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:15 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60506 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764214AbZD3XyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:13 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Michal Simek <monstr@monstr.eu>,
       microblaze-uclinux@itee.uq.edu.au, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/2] microblaze: use new macros for .data.init_task
Date: Thu, 30 Apr 2009 19:51:04 -0400
Message-Id: <1241135464-8778-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135464-8778-2-git-send-email-tabbott@mit.edu>
References: <1241135464-8778-1-git-send-email-tabbott@mit.edu>
 <1241135464-8778-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
---
 arch/microblaze/kernel/init_task.c   |    3 +--
 arch/microblaze/kernel/vmlinux.lds.S |    5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
index 48eb9fb..d765fc1 100644
--- a/arch/microblaze/kernel/init_task.c
+++ b/arch/microblaze/kernel/init_task.c
@@ -21,8 +21,7 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
 EXPORT_SYMBOL(init_mm);
 
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 { INIT_THREAD_INFO(init_task) };
 
 struct task_struct init_task = INIT_TASK(init_task);
diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
index de25a68..dcb2bc1 100644
--- a/arch/microblaze/kernel/vmlinux.lds.S
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -63,6 +63,7 @@ SECTIONS {
 
 	_sdata = . ;
 	.data ALIGN (4096) : { /* page aligned when MMU used - origin 0x4 */
+		INIT_TASK_DATA(THREAD_SIZE)
 		*(.data)
 		CACHELINE_ALIGNED_DATA(32)
 	}
@@ -73,10 +74,6 @@ SECTIONS {
 	r0_ram = . ;
 	. = . +  4096;	/* a page should be enough */
 
-	/* The initial task */
-	. = ALIGN(8192);
-	.data.init_task : { *(.data.init_task) }
-
 	/* Under the microblaze ABI, .sdata and .sbss must be contiguous */
 	. = ALIGN(8);
 	.sdata : {
-- 
1.6.2.1

