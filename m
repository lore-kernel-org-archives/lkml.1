Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYBPPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYBPPGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYBPPGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:06:10 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34042 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYBPPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:06:09 -0500
Date: Sat, 16 Feb 2008 18:09:48 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] free_pidmap: turn it into free_pidmap(struct upid *)
Message-ID: <20080216150948.GA9880@tv-sign.ru>
References: <20080215180204.GA4359@tv-sign.ru> <20080215193756.9e5b8205.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215193756.9e5b8205.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers of free_pidmap() pass 2 members of "struct upid", we can just pass
"struct upid *" instead. Shaves off 10 bytes from pid.o.

Also, simplify the alloc_pid's "out_free:" error path a little bit. This way it
looks more clear which subset of pid->numbers[] we are freeing.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/pid.c~	2008-02-15 16:59:17.000000000 +0300
+++ 25/kernel/pid.c	2008-02-16 17:51:17.000000000 +0300
@@ -111,10 +111,11 @@ EXPORT_SYMBOL(is_container_init);
 
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(pidmap_lock);
 
-static void free_pidmap(struct pid_namespace *pid_ns, int pid)
+static void free_pidmap(struct upid *upid)
 {
-	struct pidmap *map = pid_ns->pidmap + pid / BITS_PER_PAGE;
-	int offset = pid & BITS_PER_PAGE_MASK;
+	int nr = upid->nr;
+	struct pidmap *map = upid->ns->pidmap + nr / BITS_PER_PAGE;
+	int offset = nr & BITS_PER_PAGE_MASK;
 
 	clear_bit(offset, map->page);
 	atomic_inc(&map->nr_free);
@@ -232,7 +233,7 @@ void free_pid(struct pid *pid)
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
 	for (i = 0; i <= pid->level; i++)
-		free_pidmap(pid->numbers[i].ns, pid->numbers[i].nr);
+		free_pidmap(pid->numbers + i);
 
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
@@ -278,8 +279,8 @@ out:
 	return pid;
 
 out_free:
-	for (i++; i <= ns->level; i++)
-		free_pidmap(pid->numbers[i].ns, pid->numbers[i].nr);
+	while (++i <= ns->level)
+		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
 	pid = NULL;

