Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZCJP7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZCJP7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZCJP7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:59:10 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:64785 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbZCJP7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:59:09 -0400
Date: Tue, 10 Mar 2009 10:57:02 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090310105702.43eb1402@thinkcentre.lan>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
References: <20090305163857.0C18F3FD@kernel>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: 62141C30-0D8C-11DE-A19B-CFA5EBB1AA3C-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider this and a following patch.

>From a0fb96aa41c4d360559013cfd7f32f07f449c1c4 Mon Sep 17 00:00:00 2001
From: Nathan Lynch <ntl@pobox.com>
Date: Mon, 9 Mar 2009 22:23:02 -0500
Subject: [PATCH] checkpoint: make files_deny_checkpointing print task name and pid

This lets the developer know *which* task performed an action that
prevents checkpoint.


Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 fs/file.c                  |    2 +-
 fs/open.c                  |    2 +-
 include/linux/checkpoint.h |   13 +++++++------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 0501af6..fcb2803 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -299,7 +299,7 @@ static void __scan_files_for_cr(struct files_struct *files)
 			continue;
 		if (cr_file_supported(f))
 			continue;
-		files_deny_checkpointing(files);
+		files_deny_checkpointing(current, files);
 	}
 }
 
diff --git a/fs/open.c b/fs/open.c
index 7f575b0..327ff5b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1018,7 +1018,7 @@ void fd_install(unsigned int fd, struct file *file)
 	struct fdtable *fdt;
 
 	if (!cr_file_supported(file))
-		files_deny_checkpointing(files);
+		files_deny_checkpointing(current, files);
 
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index e77393f..27366ac 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -13,6 +13,7 @@
 #include <linux/path.h>
 #include <linux/fs.h>
 #include <linux/fdtable.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_CHECKPOINT_RESTART
 
@@ -102,16 +103,16 @@ extern int cr_read_files(struct cr_ctx *ctx);
 
 #define pr_fmt(fmt) "[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__
 
-static inline void __files_deny_checkpointing(struct files_struct *files,
-		char *file, int line)
+static inline void __files_deny_checkpointing(const struct task_struct *tsk,
+		struct files_struct *files, char *file, int line)
 {
 	if (!test_and_clear_bit(0, &files->may_checkpoint))
 		return;
-	printk(KERN_INFO "process performed an action that can not be "
-			"checkpointed at: %s:%d\n", file, line);
+	printk(KERN_INFO "%s/%i performed an action that can not be "
+	       "checkpointed at: %s:%d\n", tsk->comm, tsk->pid, file, line);
 }
-#define files_deny_checkpointing(f)  \
-	__files_deny_checkpointing(f, __FILE__, __LINE__)
+#define files_deny_checkpointing(tsk,f)				\
+	__files_deny_checkpointing(tsk, f, __FILE__, __LINE__)
 
 int cr_explain_file(struct file *file, char *explain, int left);
 int cr_file_supported(struct file *file);
-- 
1.6.0.6

