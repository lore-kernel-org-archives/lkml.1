Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYGAJag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYGAJag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbYGAJ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:29:24 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:24462
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758060AbYGAJ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:29:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEyVaUjLO9AP/2dsb2JhbACxfw
X-IronPort-AV: E=Sophos;i="4.27,730,1204470000"; 
   d="scan'208";a="350438443"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 5/5] autofs4 - fix waitq memory leak
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2008 17:26:23 +0800
Message-ID: <20080701092621.12041.86472.stgit@raven.themaw.net>
In-Reply-To: <20080701092548.12041.69868.stgit@raven.themaw.net>
References: <20080701092548.12041.69868.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an autofs mount becomes catatonic before autofs4_wait_release() is
called the wait queue counter will not be decremented down to zero
and the entry will never be freed. There are also races decrementing
the wait counter in the wait release function. To deal with this the
counter needs to be updated while holding the wait queue mutex and
waiters need to be woken up unconditionally when the wait is removed
from the queue to ensure we eventually free the wait.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/autofs_i.h |    2 +-
 fs/autofs4/waitq.c    |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index da8882f..058e180 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -84,7 +84,7 @@ struct autofs_wait_queue {
 	pid_t tgid;
 	/* This is for status reporting upon return */
 	int status;
-	atomic_t wait_ctr;
+	unsigned int wait_ctr;
 };
 
 #define AUTOFS_SBI_MAGIC 0x6d4a556d
diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index aa7b526..bcb6c52 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -46,6 +46,7 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
 			kfree(wq->name.name);
 			wq->name.name = NULL;
 		}
+		wq->wait_ctr--;
 		wake_up_interruptible(&wq->queue);
 		wq = nwq;
 	}
@@ -384,7 +385,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		wq->pid = current->pid;
 		wq->tgid = current->tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
-		atomic_set(&wq->wait_ctr, 2);
+		wq->wait_ctr = 2;
 		mutex_unlock(&sbi->wq_mutex);
 
 		if (sbi->version < 5) {
@@ -410,7 +411,7 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 		/* autofs4_notify_daemon() may block */
 		autofs4_notify_daemon(sbi, wq, type);
 	} else {
-		atomic_inc(&wq->wait_ctr);
+		wq->wait_ctr++;
 		mutex_unlock(&sbi->wq_mutex);
 		kfree(qstr.name);
 		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
@@ -446,8 +447,10 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	status = wq->status;
 
 	/* Are we the last process to need status? */
-	if (atomic_dec_and_test(&wq->wait_ctr))
+	mutex_lock(&sbi->wq_mutex);
+	if (!--wq->wait_ctr)
 		kfree(wq);
+	mutex_unlock(&sbi->wq_mutex);
 
 	return status;
 }
@@ -471,14 +474,11 @@ int autofs4_wait_release(struct autofs_sb_info *sbi, autofs_wqt_t wait_queue_tok
 	*wql = wq->next;	/* Unlink from chain */
 	kfree(wq->name.name);
 	wq->name.name = NULL;	/* Do not wait on this queue */
-	mutex_unlock(&sbi->wq_mutex);
-
 	wq->status = status;
-
-	if (atomic_dec_and_test(&wq->wait_ctr))	/* Is anyone still waiting for this guy? */
+	wake_up_interruptible(&wq->queue);
+	if (!--wq->wait_ctr)
 		kfree(wq);
-	else
-		wake_up_interruptible(&wq->queue);
+	mutex_unlock(&sbi->wq_mutex);
 
 	return 0;
 }
