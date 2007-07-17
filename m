Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXGQPly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXGQPly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934563AbXGQPkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:40:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934557AbXGQPkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:40:52 -0400
Message-Id: <20070717173756.740824000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 01/12] lockdep: annotate journal_start()
Content-Disposition: inline; filename=jbd-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 02:05 -0700, Andrew Morton wrote:

> Except lockdep doesn't know about journal_start(), which has ranking
> requirements similar to a semaphore.  

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/jbd/transaction.c |    9 +++++++++
 include/linux/jbd.h  |    5 +++++
 2 files changed, 14 insertions(+)

Index: linux-2.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd/transaction.c
+++ linux-2.6/fs/jbd/transaction.c
@@ -233,6 +233,8 @@ out:
 	return ret;
 }
 
+static struct lock_class_key jbd_handle_key;
+
 /* Allocate a new handle.  This should probably be in a slab... */
 static handle_t *new_handle(int nblocks)
 {
@@ -243,6 +245,8 @@ static handle_t *new_handle(int nblocks)
 	handle->h_buffer_credits = nblocks;
 	handle->h_ref = 1;
 
+	lockdep_init_map(&handle->h_lockdep_map, "jbd_handle", &jbd_handle_key, 0);
+
 	return handle;
 }
 
@@ -286,6 +290,9 @@ handle_t *journal_start(journal_t *journ
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
 	}
+
+	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+
 	return handle;
 }
 
@@ -1411,6 +1418,8 @@ int journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
+	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+
 	jbd_free_handle(handle);
 	return err;
 }
Index: linux-2.6/include/linux/jbd.h
===================================================================
--- linux-2.6.orig/include/linux/jbd.h
+++ linux-2.6/include/linux/jbd.h
@@ -30,6 +30,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
+#include <linux/lockdep.h>
 
 #include <asm/semaphore.h>
 #endif
@@ -405,6 +406,10 @@ struct handle_s
 	unsigned int	h_sync:		1;	/* sync-on-close */
 	unsigned int	h_jdata:	1;	/* force data journaling */
 	unsigned int	h_aborted:	1;	/* fatal error on handle */
+
+#ifdef CONFIG_LOCKDEP
+	struct lockdep_map	h_lockdep_map;
+#endif
 };
 
 

--

