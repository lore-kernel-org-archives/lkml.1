Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbZKVGGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbZKVGGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 01:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZKVGGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 01:06:32 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:62705 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZKVGGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 01:06:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=D3Q1eHR2QX/0GFCR/cetvMrbDFHqFvruK9jCQqrCSFeG8puE9H6SG5C5Tpb8dND3u/
         3gBk2WFqzBBUjvR1oWNCGBce2zrVnlwJISZZaRVGkCsgJ6Y/FQx+UeigWNccvPU679fc
         pxYtl+f0wFMiPgT+t5+qZ/I8hj3X6i3wihWg4=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Oleg Nesterov <oleg@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH] pid: tighten pidmap_lock critical section
Date: Sat, 21 Nov 2009 04:04:34 -0200
Message-Id: <80d3c5c680300de7ebd41aba89723a5cf45396ed.1258783305.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.3.148.g785c5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid calling kfree() under pidmap_lock and doing unnecessary work.
It doesn't change behavior.

It decreases code size by 16 bytes on my gcc 4.4.1 on Core 2:
   text    data     bss     dec     hex filename
   4314    2216       8    6538    198a kernel/pid.o-BEFORE
   4298    2216       8    6522    197a kernel/pid.o-AFTER

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 kernel/pid.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index d3f722d..ec06912 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			 * installing it:
 			 */
 			spin_lock_irq(&pidmap_lock);
-			if (map->page)
-				kfree(page);
-			else
+			if (!map->page) {
 				map->page = page;
+				page = NULL;
+			}
 			spin_unlock_irq(&pidmap_lock);
+			kfree(page);
 			if (unlikely(!map->page))
 				break;
 		}
@@ -225,11 +226,11 @@ static void delayed_put_pid(struct rcu_head *rhp)
 void free_pid(struct pid *pid)
 {
 	/* We can be called with write_lock_irq(&tasklist_lock) held */
-	int i;
+	int i = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&pidmap_lock, flags);
-	for (i = 0; i <= pid->level; i++)
+	for ( ; i <= pid->level; i++)
 		hlist_del_rcu(&pid->numbers[i].pid_chain);
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
@@ -268,12 +269,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
+	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
-	for (i = ns->level; i >= 0; i--) {
-		upid = &pid->numbers[i];
+	for ( ; upid >= pid->numbers; --upid)
 		hlist_add_head_rcu(&upid->pid_chain,
 				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
-	}
 	spin_unlock_irq(&pidmap_lock);
 
 out:
-- 
1.6.5.3.148.g785c5

