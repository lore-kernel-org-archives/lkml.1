Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0CNKkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:40:35 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52867 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab0CNKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:53 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 06/11] Adopt rwsem of x86 to lock monitor
Date: Sun, 14 Mar 2010 19:38:43 +0900
Message-Id: <1268563128-6486-7-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current struct rw_semaphore holds struct lockdep_map,
but it is a special thing of lockdep subsystem.

So I replaced it with struct lock_monitor.
Now it contains lockdep_map, and adding new members is easy.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/rwsem.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index ca7517d..a6862f1 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -68,22 +68,22 @@ struct rw_semaphore {
 	signed long		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
+#ifdef CONFIG_LOCK_MONITOR
+	struct lock_monitor     monitor;
 #endif
 };
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+#ifdef CONFIG_LOCK_MONITOR
+# define __RWSEM_LOCK_MONITOR_INIT(lockname) , .monitor = { __LOCK_MONITOR_INIT(lockname) }
 #else
-# define __RWSEM_DEP_MAP_INIT(lockname)
+# define __RWSEM_LOCK_MONITOR_INIT(lockname)
 #endif
 
 
 #define __RWSEM_INITIALIZER(name)				\
 {								\
 	RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
-	LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) \
+	LIST_HEAD_INIT((name).wait_list) __RWSEM_LOCK_MONITOR_INIT(name) \
 }
 
 #define DECLARE_RWSEM(name)					\
-- 
1.6.5.2

