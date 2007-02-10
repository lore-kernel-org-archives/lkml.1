Return-Path: <linux-kernel-owner+w=401wt.eu-S1946815AbXBJBCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946815AbXBJBCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946821AbXBJBCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:02:30 -0500
Received: from smtp-out.google.com ([216.239.45.13]:54537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946815AbXBJBCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:02:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=JN0B1T1x2KJBBUPkconictq13qYVC1vxQeE/G2iWhUi+kOF/Pv1tVlEWJmOGuRtk+
	33gX8AzJrcgDZnbDFV9Ug==
Date: Fri, 9 Feb 2007 17:01:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + smaps-add-clear_refs-file-to-clear-reference.patch added to
 -mm tree
In-Reply-To: <20070210003958.GA3047@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0702091659230.14797@chino.kir.corp.google.com>
References: <20070210003958.GA3047@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do not clear references when the task_struct's mm is NULL by using 
/proc/pid/clear_refs.

Also, use mmap_sem since the mm_struct's VMA's are being iterated in 
fs/proc/task_mmu.c.

Reported by Oleg Nesterov <oleg@tv-sign.ru>.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/proc/base.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -719,6 +719,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
+	struct mm_struct *mm;
 	char buffer[PROC_NUMBUF], *end;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -733,7 +734,13 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	clear_refs_smap(task->mm->mmap);
+	mm = get_task_mm(task);
+	if (mm) {
+		down_read(&mm->mmap_sem);
+		clear_refs_smap(mm->mmap);
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
