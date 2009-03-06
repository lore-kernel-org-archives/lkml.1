Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZCFUAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZCFUAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZCFT7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:59:53 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37240 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZCFT7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:59:52 -0500
Date: Fri, 6 Mar 2009 13:59:37 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Cedric Le Goater <clg@fr.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 2/3] cr: add file checkpointability to /proc/pid/status
Message-ID: <20090306195937.GA9632@us.ibm.com>
References: <20090306195911.GA9512@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306195911.GA9512@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add file checkpointability info at the end of /proc/pid/status
output.  This will next be augmented by vm checkpointability
info.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 checkpoint/checkpoint.c    |   14 ++++++++++++++
 fs/proc/array.c            |    2 ++
 include/linux/checkpoint.h |    4 ++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
index e0af8a2..5debe70 100644
--- a/checkpoint/checkpoint.c
+++ b/checkpoint/checkpoint.c
@@ -21,12 +21,26 @@
 #include <linux/magic.h>
 #include <linux/checkpoint.h>
 #include <linux/checkpoint_hdr.h>
+#include <linux/seq_file.h>
 
 #include "checkpoint_arch.h"
 
 /* unique checkpoint identifier (FIXME: should be per-container ?) */
 static atomic_t cr_ctx_count = ATOMIC_INIT(0);
 
+void task_checkpoint_status(struct seq_file *m, struct task_struct *p)
+{
+	if (!p->files) {
+		seq_printf(m, "task has no files_struct\n");
+		return;
+	}
+
+	if (test_bit(0, &p->files->may_checkpoint))
+		seq_printf(m, "files are checkpointable\n");
+	else
+		seq_printf(m, "files are not checkpointable\n");
+}
+
 /**
  * cr_write_obj - write a record described by a cr_hdr
  * @ctx: checkpoint context
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7e4877d..f350e45 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -81,6 +81,7 @@
 #include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
 #include <linux/tracehook.h>
+#include <linux/checkpoint.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -339,6 +340,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
+	task_checkpoint_status(m, task);
 	return 0;
 }
 
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index 6c31c1b..0e90b67 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -123,6 +123,8 @@ static inline int cr_enabled(void)
 	return 1;
 }
 
+extern void task_checkpoint_status(struct seq_file *m, struct task_struct *p);
+
 #else /* !CONFIG_CHECKPOINT_RESTART */
 
 static inline void files_deny_checkpointing(struct files_struct *files) {}
@@ -143,5 +145,7 @@ static inline int cr_enabled(void)
 	return 0;
 }
 
+static inline void task_checkpoint_status(struct seq_file *m,
+			struct task_struct *p) {}
 #endif /* CONFIG_CHECKPOINT_RESTART */
 #endif /* _CHECKPOINT_CKPT_H_ */
-- 
1.5.4.3

