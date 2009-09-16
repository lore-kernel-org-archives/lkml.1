Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbZIPQly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbZIPQly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759854AbZIPQlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:41:49 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39317 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759777AbZIPQlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:41:47 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: linux-kernel@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Tim Abbott <tabbott@mit.edu>
Subject: [PATCH v2 1/3] alpha: use .data.init_task instead of .data.init_thread.
Date: Wed, 16 Sep 2009 12:38:37 -0400
Message-Id: <1253119119-18956-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253119119-18956-1-git-send-email-tabbott@ksplice.com>
References: <1253119119-18956-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alpha is the only architecture that uses the section name
.data.init_thread instead of .data.init_task.  So convert alpha to use
.data.init_task like everything else.

.data.init_task does not need a separate output section; this change
also moves it into the .data output section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/init_task.c   |    5 ++---
 arch/alpha/kernel/vmlinux.lds.S |    7 ++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/init_task.c b/arch/alpha/kernel/init_task.c
index 19b8632..6f80ca4 100644
--- a/arch/alpha/kernel/init_task.c
+++ b/arch/alpha/kernel/init_task.c
@@ -13,6 +13,5 @@ static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct task_struct init_task = INIT_TASK(init_task);
 EXPORT_SYMBOL(init_task);
 
-union thread_union init_thread_union
-	__attribute__((section(".data.init_thread")))
-	= { INIT_THREAD_INFO(init_task) };
+union thread_union init_thread_union __init_task_data =
+	{ INIT_THREAD_INFO(init_task) };
diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 6dc03c3..82803df 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -1,5 +1,6 @@
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 OUTPUT_FORMAT("elf64-alpha")
 OUTPUT_ARCH(alpha)
@@ -92,11 +93,6 @@ SECTIONS
 	__init_end = .;
 	/* Freed after init ends here */
 
-	/* Note 2 page alignment above.  */
-	.data.init_thread : {
-		*(.data.init_thread)
-	}
-
 	. = ALIGN(PAGE_SIZE);
 	.data.page_aligned : {
 		*(.data.page_aligned)
@@ -110,6 +106,7 @@ SECTIONS
 	_data = .;
 	/* Data */
 	.data : {
+		INIT_TASK_DATA(THREAD_SIZE)
 		DATA_DATA
 		CONSTRUCTORS
 	}
-- 
1.6.3.3

