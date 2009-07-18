Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZGRRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZGRRXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZGRRXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 13:23:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZGRRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 13:23:44 -0400
Subject: Re: [tip:core/locking] lockdep: Update memory usage introduced by
 BFS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-292264ece1ffdc9dacc1af486e28ee91cc66fb2d@git.kernel.org>
References: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
	 <tip-292264ece1ffdc9dacc1af486e28ee91cc66fb2d@git.kernel.org>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 19:23:30 +0200
Message-Id: <1247937810.6597.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 14:24 +0000, tip-bot for Ming Lei wrote:
> Commit-ID:  292264ece1ffdc9dacc1af486e28ee91cc66fb2d
> Gitweb:     http://git.kernel.org/tip/292264ece1ffdc9dacc1af486e28ee91cc66fb2d
> Author:     Ming Lei <tom.leiming@gmail.com>
> AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 18 Jul 2009 16:02:56 +0200
> 
> lockdep: Update memory usage introduced by BFS
> 
> Also account the BFS memory usage.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/lockdep.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index b896f23..930335d 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3429,7 +3429,8 @@ void __init lockdep_info(void)
>  		sizeof(struct list_head) * CLASSHASH_SIZE +
>  		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
>  		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
> -		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024);
> +		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024 +
> +		sizeof(struct circular_queue) + sizeof(bfs_accessed));
>  
>  	printk(" per task-struct memory footprint: %lu bytes\n",
>  		sizeof(struct held_lock) * MAX_LOCK_DEPTH);

/usr/src/linux-2.6/kernel/lockdep.c:3493: error: invalid application of
'sizeof' to incomplete type 'struct circular_queue'

This wants the following folded in.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3718a98..33fdda9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3489,8 +3489,11 @@ void __init lockdep_info(void)
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
-		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024 +
-		sizeof(struct circular_queue) + sizeof(bfs_accessed));
+		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024
+#ifdef CONFIG_PROVE_LOCKING
+		+ sizeof(struct circular_queue) + sizeof(bfs_accessed)
+#endif
+		);
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);


