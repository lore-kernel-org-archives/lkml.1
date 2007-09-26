Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXIZRJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXIZRJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759734AbXIZRIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:08:31 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38597
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759236AbXIZRIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:08:30 -0400
X-IronPort-AV: E=Sophos;i="4.21,198,1188770400"; 
   d="scan'208";a="3292249"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 3/8] taskstats: split the extended accounting fields
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, Balbir Singh <balbir@in.ibm.com>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Wed, 26 Sep 2007 19:08:29 +0200
Message-ID: <20070926170829.31221.20894.stgit@cheypa.inria.fr>
In-Reply-To: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Split the extended accounting taskstats fields into the threadgroup specific
ones and the thread specific ones. This should have no effect on the execution.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 kernel/tsacct.c |   48 ++++++++++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 20 deletions(-)


diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index d32378f..e8c25d2 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -101,33 +101,41 @@ static void bacct_fill_threadgroup(struct taskstats *stats,
 /*
  * fill in extended accounting fields
  */
-void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
+
+static void xacct_fill_threadgroup(struct taskstats *stats,
+				   struct task_struct *tsk);
+
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+{
+	/* convert pages-jiffies to Mbyte-usec */
+	stats->coremem += jiffies_to_usecs(tsk->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem += jiffies_to_usecs(tsk->acct_vm_mem1)  * PAGE_SIZE / MB;
+
+	stats->read_char	+= tsk->rchar;
+	stats->write_char	+= tsk->wchar;
+	stats->read_syscalls	+= tsk->syscr;
+	stats->write_syscalls	+= tsk->syscw;
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	stats->read_bytes	+= tsk->ioac.read_bytes;
+	stats->write_bytes	+= tsk->ioac.write_bytes;
+	stats->cancelled_write_bytes += tsk->ioac.cancelled_write_bytes;
+#endif
+
+	xacct_fill_threadgroup(stats, tsk);
+}
+
+static void xacct_fill_threadgroup(struct taskstats *stats,
+				   struct task_struct *tsk)
 {
 	struct mm_struct *mm;
 
-	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
-	mm = get_task_mm(p);
+	mm = get_task_mm(tsk);
 	if (mm) {
 		/* adjust to KB unit */
-		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
-		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
+		stats->hiwater_rss = mm->hiwater_rss * PAGE_SIZE / KB;
+		stats->hiwater_vm  = mm->hiwater_vm  * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
-#ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
-#else
-	stats->read_bytes	= 0;
-	stats->write_bytes	= 0;
-	stats->cancelled_write_bytes = 0;
-#endif
 }
 #undef KB
 #undef MB
