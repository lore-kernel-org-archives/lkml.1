Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYHOMVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYHOMVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYHOMTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:19:15 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:53220
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753422AbYHOMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:18:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC v2 5/8] RT: wrap the rt_rwlock "add reader" logic
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, David.Holmes@sun.com
Date: Fri, 15 Aug 2008 08:08:36 -0400
Message-ID: <20080815120836.24722.42976.stgit@dev.haskins.net>
In-Reply-To: <20080815120722.24722.66516.stgit@dev.haskins.net>
References: <20080815120722.24722.66516.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use this later in the series to add PI functions on "add".

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 12de859..62fdc3d 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1122,6 +1122,12 @@ static void rw_check_held(struct rw_mutex *rwm)
 # define rw_check_held(rwm)	do { } while (0)
 #endif
 
+static inline void
+rt_rwlock_add_reader(struct reader_lock_struct *rls, struct rw_mutex *rwm)
+{
+	list_add(&rls->list, &rwm->readers);
+}
+
 /*
  * The fast path does not add itself to the reader list to keep
  * from needing to grab the spinlock. We need to add the owner
@@ -1163,7 +1169,7 @@ rt_rwlock_update_owner(struct rw_mutex *rwm, struct task_struct *own)
 	if (rls->list.prev && !list_empty(&rls->list))
 		return;
 
-	list_add(&rls->list, &rwm->readers);
+	rt_rwlock_add_reader(rls, rwm);
 
 	/* change to reader, so no one else updates too */
 	rt_rwlock_set_owner(rwm, RT_RW_READER, RT_RWLOCK_CHECK);
@@ -1197,7 +1203,7 @@ static int try_to_take_rw_read(struct rw_mutex *rwm, int mtx)
 			 * it hasn't been added to the link list yet.
 			 */
 			if (!rls->list.prev || list_empty(&rls->list))
-				list_add(&rls->list, &rwm->readers);
+				rt_rwlock_add_reader(rls, rwm);
 			rt_rwlock_set_owner(rwm, RT_RW_READER, 0);
 			rls->count++;
 			incr = 0;
@@ -1276,7 +1282,7 @@ static int try_to_take_rw_read(struct rw_mutex *rwm, int mtx)
 			rls->lock = rwm;
 			rls->count = 1;
 			WARN_ON(rls->list.prev && !list_empty(&rls->list));
-			list_add(&rls->list, &rwm->readers);
+			rt_rwlock_add_reader(rls, rwm);
 		} else
 			WARN_ON_ONCE(1);
 		spin_unlock(&current->pi_lock);
@@ -1473,7 +1479,7 @@ __rt_read_fasttrylock(struct rw_mutex *rwm)
 			spin_lock(&mutex->wait_lock);
 			rls = &current->owned_read_locks[reader_count];
 			if (!rls->list.prev || list_empty(&rls->list))
-				list_add(&rls->list, &rwm->readers);
+				rt_rwlock_add_reader(rlw, rwm);
 			spin_unlock(&mutex->wait_lock);
 		} else
 			spin_unlock(&current->pi_lock);
@@ -2083,7 +2089,7 @@ rt_mutex_downgrade_write(struct rw_mutex *rwm)
 
 	/* Set us up for multiple readers or conflicts */
 
-	list_add(&rls->list, &rwm->readers);
+	rt_rwlock_add_reader(rls, rwm);
 	rwm->owner = RT_RW_READER;
 
 	/*

