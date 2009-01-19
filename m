Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZASRgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZASRgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZASRgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:36:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:20992 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZASRgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:36:05 -0500
From: Vitaliy Gusev <vgusev@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kthread: Don't looking for a task in create_kthread()
Date: Mon, 19 Jan 2009 20:28:34 +0300
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Hellwig <hch@lst.de>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192028.34594.vgusev@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let a process fill result, as 'current' is the same
in all pid namespaces.

Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>

---
 kernel/kthread.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4fbc456..fd765f9 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -76,6 +76,7 @@ static int kthread(void *_create)
 
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
+	create->result = current;
 	complete(&create->started);
 	schedule();
 
@@ -101,9 +102,6 @@ static void create_kthread(struct kthread_create_info *create)
 	} else {
 		struct sched_param param = { .sched_priority = 0 };
 		wait_for_completion(&create->started);
-		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid_ns(pid, &init_pid_ns);
-		read_unlock(&tasklist_lock);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
