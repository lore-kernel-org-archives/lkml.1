Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZLNJtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZLNJtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZLNJtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:49:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:48340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbZLNJtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:49:05 -0500
Date: Mon, 14 Dec 2009 09:48:30 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, prasad@linux.vnet.ibm.com
In-Reply-To: <4B1DC578.9020909@cn.fujitsu.com>
References: <4B1DC578.9020909@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ksym_tracer: Fix bad cast
Message-ID: <tip-16620e0f1990fa6d896a639449c4b3d678458464@git.kernel.org>
Git-Commit-ID: 16620e0f1990fa6d896a639449c4b3d678458464
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16620e0f1990fa6d896a639449c4b3d678458464
Gitweb:     http://git.kernel.org/tip/16620e0f1990fa6d896a639449c4b3d678458464
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:18:16 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:46:54 +0100

ksym_tracer: Fix bad cast

Fix this warning:

kernel/trace/trace_ksym.c: In function 'ksym_trace_filter_read':
kernel/trace/trace_ksym.c:239: warning: cast to pointer from integer of different size

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
LKML-Reference: <4B1DC578.9020909@cn.fujitsu.com>
[remove the strstrip fix as tglx already fixed that]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_ksym.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 64e7a5b..48f1c6c 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -235,7 +235,8 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&ksym_tracer_mutex);
 
 	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
-		ret = trace_seq_printf(s, "%pS:", (void *)entry->attr.bp_addr);
+		ret = trace_seq_printf(s, "%pS:",
+				(void *)(unsigned long)entry->attr.bp_addr);
 		if (entry->attr.bp_type == HW_BREAKPOINT_R)
 			ret = trace_seq_puts(s, "r--\n");
 		else if (entry->attr.bp_type == HW_BREAKPOINT_W)
@@ -298,8 +299,8 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	 * 2: echo 0 > ksym_trace_filter
 	 * 3: echo "*:---" > ksym_trace_filter
 	 */
-	if (!input_string[0] || !strcmp(input_string, "0") ||
-	    !strcmp(input_string, "*:---")) {
+	if (!buf[0] || !strcmp(buf, "0") ||
+	    !strcmp(buf, "*:---")) {
 		__ksym_trace_reset();
 		ret = 0;
 		goto out;
