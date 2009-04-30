Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbZEAA3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbZEAA3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765678AbZEAAHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:07:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62551 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765107AbZEAAHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:07:07 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/6] s390: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:57:19 -0400
Message-Id: <1241135841-9619-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135841-9619-4-git-send-email-tabbott@mit.edu>
References: <1241135841-9619-1-git-send-email-tabbott@mit.edu>
 <1241135841-9619-2-git-send-email-tabbott@mit.edu>
 <1241135841-9619-3-git-send-email-tabbott@mit.edu>
 <1241135841-9619-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.init_task should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/kernel/init_task.c   |    3 +--
 arch/s390/kernel/vmlinux.lds.S |    6 +-----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kernel/init_task.c b/arch/s390/kernel/init_task.c
index 7db95c0..e5a68f6 100644
--- a/arch/s390/kernel/init_task.c
+++ b/arch/s390/kernel/init_task.c
@@ -29,8 +29,7 @@ EXPORT_SYMBOL(init_mm);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index c828398..b10a950 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -59,6 +59,7 @@ SECTIONS
 	} :data
 
 	.data : {		/* Data */
+		INIT_TASK_DATA(THREAD_SIZE)
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(0x100)
@@ -72,11 +73,6 @@ SECTIONS
 	}
 	_edata = .;		/* End of data section */
 
-	. = ALIGN(THREAD_SIZE);	/* init_task */
-	.data.init_task : {
-		*(.data.init_task)
-	}
-
 	/* will be freed after init */
 	. = ALIGN(PAGE_SIZE);	/* Init code and data */
 	__init_begin = .;
-- 
1.6.2.1

