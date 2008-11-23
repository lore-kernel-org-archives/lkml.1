Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYKWKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYKWKj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbYKWKjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:39:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:25219 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYKWKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=xRGu9FgcHEw0OEXqQClRbsA/cJ41IJ2QhPxrdIxubgSGLfzWiLzSk5USGmbvUm7avE
         M9vxI0Ud4zmEwAer24G8ENbyk4GpaZhgyzYbATd4NUX8gD2c0TKGsaeoWg4ZUScGdKjO
         d2bOOJLd0XhZ526SCnzM2OmfTwp/fMKzWDvgQ=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 2/3] tracing/stack-tracer: fix locking
Date: Sun, 23 Nov 2008 12:39:07 +0200
Message-Id: <1227436748-17075-2-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081123085310.GF30453@elte.hu>
References: <20081123085310.GF30453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hold mmap_sem while looking up/accessing vma.
Hold the RCU lock while using the task we looked up.

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 kernel/trace/trace.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dedf35f..4c3bd82 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1462,11 +1462,15 @@ static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 	int ret = 1;
 
 	if (mm) {
-		const struct vm_area_struct *vma = find_vma(mm, ip);
+		const struct vm_area_struct *vma;
+
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, ip);
 		if (vma) {
 			file = vma->vm_file;
 			vmstart = vma->vm_start;
 		}
+		up_read(&mm->mmap_sem);
 	}
 	if (file) {
 		ret = trace_seq_path(s, &file->f_path);
@@ -1494,10 +1498,9 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		 */
 		rcu_read_lock();
 		task = find_task_by_vpid(entry->ent.tgid);
-		rcu_read_unlock();
-
 		if (task)
 			mm = get_task_mm(task);
+		rcu_read_unlock();
 	}
 
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-- 
1.5.6.5

