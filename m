Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXDNIps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXDNIps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXDNIps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:45:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXDNIpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=sCz8relMTwe1/3ODecZuUE600SiOe2Rl7UcJ9/BmRUFWaZ816v6jvzE0r/KWFAJGGJY0+jU8/FvXW1HMtJDpHItziXturFVAeZS7fO525a4Wvg2HmSDA9oPs12dGTRJpfXgylp5iQHW6AELg0Vt9gIBNYYkDW+2g4hZJeB/FBII=
Date: Sat, 14 Apr 2007 14:17:46 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org, jfs-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       shaggy@austin.ibm.com
Subject: [KJ][PATCH 01/04]use set_current_state in fs
Message-ID: <20070414084746.GB14084@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


use set_current_state(TASK_*) instead of current->state = TASK_*, in fs/jfs

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 jfs_lock.h   |    2 +-
 jfs_logmgr.c |    4 ++--
 jfs_txnmgr.c |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/jfs/jfs_lock.h b/fs/jfs/jfs_lock.h
index df48ece..9e504bc 100644
--- a/fs/jfs/jfs_lock.h
+++ b/fs/jfs/jfs_lock.h
@@ -45,7 +45,7 @@ do {							\
 		io_schedule();				\
 		lock_cmd;				\
 	}						\
-	current->state = TASK_RUNNING;			\
+	set_current_state(TASK_RUNNING);			\
 	remove_wait_queue(&wq, &__wait);		\
 } while (0)
 
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 5065baa..9e61514 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1590,7 +1590,7 @@ void jfs_flush_journal(struct jfs_log *log, int wait)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		LOGGC_UNLOCK(log);
 		schedule();
-		current->state = TASK_RUNNING;
+		set_current_state(TASK_RUNNING);
 		LOGGC_LOCK(log);
 		remove_wait_queue(&target->gcwait, &__wait);
 	}
@@ -2361,7 +2361,7 @@ int jfsIOWait(void *arg)
 		} else {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
-			current->state = TASK_RUNNING;
+			set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 03893ac..8fe4ced 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -136,7 +136,7 @@ static inline void TXN_SLEEP_DROP_LOCK(wait_queue_head_t * event)
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	TXN_UNLOCK();
 	io_schedule();
-	current->state = TASK_RUNNING;
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(event, &wait);
 }
 
@@ -2798,7 +2798,7 @@ int jfs_lazycommit(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			LAZY_UNLOCK(flags);
 			schedule();
-			current->state = TASK_RUNNING;
+			set_current_state(TASK_RUNNING);
 			remove_wait_queue(&jfs_commit_thread_wait, &wq);
 		}
 	} while (!kthread_should_stop());
@@ -2990,7 +2990,7 @@ int jfs_sync(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			TXN_UNLOCK();
 			schedule();
-			current->state = TASK_RUNNING;
+			set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
-- 
Milind Arun Choudhary
