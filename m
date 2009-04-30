Return-Path: <linux-kernel-owner+w=401wt.eu-S1764683AbZD3XEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764683AbZD3XEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764442AbZD3XEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:04:01 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52474 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764552AbZD3XEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:04:00 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/4] alpha: use .data.init_task instead of .data.init_thread
Date: Thu, 30 Apr 2009 19:00:16 -0400
Message-Id: <1241132416-7055-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241132416-7055-4-git-send-email-tabbott@mit.edu>
References: <1241132416-7055-1-git-send-email-tabbott@mit.edu>
 <1241132416-7055-2-git-send-email-tabbott@mit.edu>
 <1241132416-7055-3-git-send-email-tabbott@mit.edu>
 <1241132416-7055-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alpha is the only architecture that uses the section name
.data.init_thread instead of .data.init_task.  So convert alpha to use
.data.init_task like everything else.

.data.init_task should not need a separate output section; this change
also moves it into the .data output section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/init_task.c   |    5 ++---
 arch/alpha/kernel/vmlinux.lds.S |    7 ++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/init_task.c b/arch/alpha/kernel/init_task.c
index c2938e5..475d46a 100644
--- a/arch/alpha/kernel/init_task.c
+++ b/arch/alpha/kernel/init_task.c
@@ -16,6 +16,5 @@ struct task_struct init_task = INIT_TASK(init_task);
 EXPORT_SYMBOL(init_mm);
 EXPORT_SYMBOL(init_task);
 
-union thread_union init_thread_union
-	__attribute__((section(".data.init_thread")))
-	= { INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 7acd1eb..caca724 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -1,5 +1,6 @@
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf64-alpha")
 OUTPUT_ARCH(alpha)
@@ -92,14 +93,10 @@ SECTIONS
 	__init_end = .;
 	/* Freed after init ends here */
 
-	/* Note 2 page alignment above.  */
-	.data.init_thread : {
-		*(.data.init_thread)
-	}
-
 	_data = .;
 	/* Data */
 	.data : {
+		INIT_TASK_DATA(THREAD_SIZE)
 		PAGE_ALIGNED_DATA
 		CACHELINE_ALIGNED_DATA(64)
 		DATA_DATA
-- 
1.6.2.1

