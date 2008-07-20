Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYGTQA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYGTQA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbYGTQAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:00:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:58791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130AbYGTQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:00:50 -0400
Date: Sun, 20 Jul 2008 09:00:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       Rene Herman <rene.herman@keyaccess.nl>,
       Simon Arlott <simon@fire.lp0.eu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Daniel Walker <dwalker@mvista.com>
Subject: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
Message-ID: <20080720090041.5924f5ff@infradead.org>
In-Reply-To: <20080720085924.122feb2b@infradead.org>
References: <20080720085924.122feb2b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] fastboot: sync the async execution before late_initcall and move level 6s (sync) first

Rene Herman points out several cases where it's basically needed to have all
level 6/6a/6s calls done before the level 7 (late_initcall) code runs. This patch
adds a sync point in the transition from the 6's to the 7's.

Second, this patch makes sure that level 6s (sync) happens before the async code starts,
and puts a user in driver/pci in this category that needs to happen before device init.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/pci/pci.c                 |    2 +-
 include/asm-generic/vmlinux.lds.h |    3 ++-
 init/main.c                       |    8 +++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 44a46c9..d75295d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1889,7 +1889,7 @@ static int __devinit pci_setup(char *str)
 }
 early_param("pci", pci_setup);
 
-device_initcall(pci_init);
+device_initcall_sync(pci_init);
 
 EXPORT_SYMBOL(pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_io);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 39c1afc..514dbdf 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -372,11 +372,12 @@
   	*(.initcall5.init)						\
   	*(.initcall5s.init)						\
 	*(.initcallrootfs.init)						\
+  	*(.initcall6s.init)						\
 	__async_initcall_start = .;					\
 	*(.initcall6a.init)						\
 	__async_initcall_end = .;					\
   	*(.initcall6.init)						\
-  	*(.initcall6s.init)						\
+	__device_initcall_end = .;					\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
diff --git a/init/main.c b/init/main.c
index dcb2c32..5c9e90e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -741,6 +741,7 @@ int do_one_initcall(initcall_t fn)
 
 extern initcall_t __initcall_start[], __initcall_end[];
 extern initcall_t __async_initcall_start[], __async_initcall_end[];
+extern initcall_t __device_initcall_end[];
 
 static void __init do_async_initcalls(struct work_struct *dummy)
 {
@@ -764,7 +765,7 @@ static void __init do_initcalls(void)
 {
 	initcall_t *call;
 	static DECLARE_WORK(async_work, do_async_initcalls);
-	int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after level 6a */
+	int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after level 6a, 3 = after level 6 */
 
 	async_init_wq = create_singlethread_workqueue("kasyncinit");
 
@@ -775,6 +776,11 @@ static void __init do_initcalls(void)
 		}
 		if (phase == 1 && call >= __async_initcall_end)
 			phase = 2;
+		if (phase == 2 && call >= __device_initcall_end) {
+			phase = 3;
+			/* make sure all async work is done before level 7 */
+			flush_workqueue(async_init_wq);
+		}
 		if (phase != 1)
 			do_one_initcall(*call);
 	}
-- 
1.5.5.1

