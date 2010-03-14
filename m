Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0CNKjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:39:05 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52893 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0CNKiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:55 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 09/11] Adopt rcu_read_lock() to lock monitor
Date: Sun, 14 Mar 2010 19:38:46 +0900
Message-Id: <1268563128-6486-10-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_read_lock() issues lock_acquire() and rcu_read_unlock() issues lock_release().
They don't lock actual locks like spinlock or mutex.

So I replaced these calling of lock_acquire() and lock_release() with
lockdep_acquire() and lockdep_release().

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 24440f4..e45c223 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -80,8 +80,8 @@ extern void rcu_init(void);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+			lockdep_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release()	lockdep_release(&rcu_lock_map, 1, _THIS_IP_)
 #else
 # define rcu_read_acquire()	do { } while (0)
 # define rcu_read_release()	do { } while (0)
-- 
1.6.5.2

