Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYIPTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYIPTES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYIPTEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:04:06 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:55662 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYIPTEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=YMjYHDizyhtJozcNLIS9dr5aMytr4aF1blzCEotu57M7l1rIYAZh/gFno3kA/nn4g3
         HmXa4TexI6Uqvm4aRIsfPlhrCQEAlIeT0FGNSqgbso4jXumv8mkINjPeOvNYru99Rs83
         hUS/GEb79Xug6MdMmVQvC8BbMgxLsQBKvgHG4=
Date: Tue, 16 Sep 2008 22:03:56 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       Pavel Roskin <proski@gnu.org>
Subject: [PATCH 6/7] mmiotrace: remove left-over marker cruft.
Message-ID: <20080916220356.2dd140b7@daedalus.pq.iki.fi>
In-Reply-To: <20080916215416.16aee2dd@daedalus.pq.iki.fi>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
	<20080915224707.76b2cca0@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
	<20080916215416.16aee2dd@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From abd3cadc69143804cf4b0cf1d6fcadda5daad903 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 14 Sep 2008 20:50:55 +0300
Subject: [PATCH] mmiotrace: remove left-over marker cruft.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/mmio-mod.c    |   64 ---------------------------------------------
 include/linux/mmiotrace.h |    3 +-
 2 files changed, 1 insertions(+), 66 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 5e2e2e7..2c4baa8 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -56,13 +56,6 @@ struct remap_trace {
 static DEFINE_PER_CPU(struct trap_reason, pf_reason);
 static DEFINE_PER_CPU(struct mmiotrace_rw, cpu_trace);
 
-#if 0 /* XXX: no way gather this info anymore */
-/* Access to this is not per-cpu. */
-static DEFINE_PER_CPU(atomic_t, dropped);
-#endif
-
-static struct dentry *marker_file;
-
 static DEFINE_MUTEX(mmiotrace_mutex);
 static DEFINE_SPINLOCK(trace_lock);
 static atomic_t mmiotrace_enabled;
@@ -97,44 +90,6 @@ static bool is_enabled(void)
 	return atomic_read(&mmiotrace_enabled);
 }
 
-#if 0 /* XXX: needs rewrite */
-/*
- * Write callback for the debugfs entry:
- * Read a marker and write it to the mmio trace log
- */
-static ssize_t write_marker(struct file *file, const char __user *buffer,
-						size_t count, loff_t *ppos)
-{
-	char *event = NULL;
-	struct mm_io_header *headp;
-	ssize_t len = (count > 65535) ? 65535 : count;
-
-	event = kzalloc(sizeof(*headp) + len, GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
-
-	headp = (struct mm_io_header *)event;
-	headp->type = MMIO_MAGIC | (MMIO_MARKER << MMIO_OPCODE_SHIFT);
-	headp->data_len = len;
-
-	if (copy_from_user(event + sizeof(*headp), buffer, len)) {
-		kfree(event);
-		return -EFAULT;
-	}
-
-	spin_lock_irq(&trace_lock);
-#if 0 /* XXX: convert this to use tracing */
-	if (is_enabled())
-		relay_write(chan, event, sizeof(*headp) + len);
-	else
-#endif
-		len = -EINVAL;
-	spin_unlock_irq(&trace_lock);
-	kfree(event);
-	return len;
-}
-#endif
-
 static void print_pte(unsigned long address)
 {
 	unsigned int level;
@@ -481,26 +436,12 @@ static void leave_uniprocessor(void)
 }
 #endif
 
-#if 0 /* XXX: out of order */
-static struct file_operations fops_marker = {
-	.owner =	THIS_MODULE,
-	.write =	write_marker
-};
-#endif
-
 void enable_mmiotrace(void)
 {
 	mutex_lock(&mmiotrace_mutex);
 	if (is_enabled())
 		goto out;
 
-#if 0 /* XXX: tracing does not support text entries */
-	marker_file = debugfs_create_file("marker", 0660, dir, NULL,
-								&fops_marker);
-	if (!marker_file)
-		pr_err(NAME "marker file creation failed.\n");
-#endif
-
 	if (nommiotrace)
 		pr_info(NAME "MMIO tracing disabled.\n");
 	enter_uniprocessor();
@@ -525,11 +466,6 @@ void disable_mmiotrace(void)
 
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
 	leave_uniprocessor();
-	if (marker_file) {
-		debugfs_remove(marker_file);
-		marker_file = NULL;
-	}
-
 	pr_info(NAME "disabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index 60cc3bf..139d7c8 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -67,8 +67,7 @@ enum mm_io_opcode {
 	MMIO_WRITE = 0x2,    /* struct mmiotrace_rw */
 	MMIO_PROBE = 0x3,    /* struct mmiotrace_map */
 	MMIO_UNPROBE = 0x4,  /* struct mmiotrace_map */
-	MMIO_MARKER = 0x5,   /* raw char data */
-	MMIO_UNKNOWN_OP = 0x6, /* struct mmiotrace_rw */
+	MMIO_UNKNOWN_OP = 0x5, /* struct mmiotrace_rw */
 };
 
 struct mmiotrace_rw {
-- 
1.5.6.4

