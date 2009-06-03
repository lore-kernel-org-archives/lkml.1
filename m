Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZFCXGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZFCXGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZFCXGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:06:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60380 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZFCXGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dind6usQRamvbSBNaAh9tZWdxSq5Dv8UQ9359uD/7PIgWkjlLNBYgAm8TydzjBo+b0
         AyxzE2p6AiZsgq8+086G5oUhRl0+zo+qrhE3dreCZ0cLTDbtgiFVzMxoDBrTU0+WEa0t
         12LXLPLOJuWbh2IooJG+edDVBG4E9X0AJE+g4=
Date: Thu, 4 Jun 2009 03:06:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/9] exec_path 5/9: make struct spu_context::owner
	task_struct
Message-ID: <20090603230637.GF853@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603230422.GB853@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cell SPU code is going to use ->exec_path to get dcookies and stuff
so it needs task_struct saved, not mm_struct.

Export __put_task_struct() to allow link.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/powerpc/platforms/cell/spufs/context.c |    9 +++++----
 arch/powerpc/platforms/cell/spufs/file.c    |    2 +-
 arch/powerpc/platforms/cell/spufs/sched.c   |    2 +-
 arch/powerpc/platforms/cell/spufs/spufs.h   |    2 +-
 kernel/fork.c                               |    1 +
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/context.c b/arch/powerpc/platforms/cell/spufs/context.c
index db5398c..7ad45e1 100644
--- a/arch/powerpc/platforms/cell/spufs/context.c
+++ b/arch/powerpc/platforms/cell/spufs/context.c
@@ -57,7 +57,8 @@ struct spu_context *alloc_spu_context(struct spu_gang *gang)
 	init_waitqueue_head(&ctx->run_wq);
 	ctx->state = SPU_STATE_SAVED;
 	ctx->ops = &spu_backing_ops;
-	ctx->owner = get_task_mm(current);
+	get_task_struct(current);
+	ctx->owner = current;
 	INIT_LIST_HEAD(&ctx->rq);
 	INIT_LIST_HEAD(&ctx->aff_list);
 	if (gang)
@@ -111,7 +112,7 @@ int put_spu_context(struct spu_context *ctx)
 /* give up the mm reference when the context is about to be destroyed */
 void spu_forget(struct spu_context *ctx)
 {
-	struct mm_struct *mm;
+	struct task_struct *tsk;
 
 	/*
 	 * This is basically an open-coded spu_acquire_saved, except that
@@ -122,9 +123,9 @@ void spu_forget(struct spu_context *ctx)
 	if (ctx->state != SPU_STATE_SAVED)
 		spu_deactivate(ctx);
 
-	mm = ctx->owner;
+	tsk = ctx->owner;
 	ctx->owner = NULL;
-	mmput(mm);
+	put_task_struct(tsk);
 	spu_release(ctx);
 }
 
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index d6a519e..d781304 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1545,7 +1545,7 @@ static int spufs_mfc_open(struct inode *inode, struct file *file)
 	struct spu_context *ctx = i->i_ctx;
 
 	/* we don't want to deal with DMA into other processes */
-	if (ctx->owner != current->mm)
+	if (ctx->owner != current)
 		return -EINVAL;
 
 	if (atomic_read(&inode->i_count) != 1)
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index f085369..9fbd87a 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -230,7 +230,7 @@ static void spu_bind_context(struct spu *spu, struct spu_context *ctx)
 	ctx->stats.slb_flt_base = spu->stats.slb_flt;
 	ctx->stats.class2_intr_base = spu->stats.class2_intr;
 
-	spu_associate_mm(spu, ctx->owner);
+	spu_associate_mm(spu, ctx->owner->mm);
 
 	spin_lock_irq(&spu->register_lock);
 	spu->ctx = ctx;
diff --git a/arch/powerpc/platforms/cell/spufs/spufs.h b/arch/powerpc/platforms/cell/spufs/spufs.h
index ae31573..70a7813 100644
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -95,7 +95,7 @@ struct spu_context {
 	struct mutex state_mutex;
 	struct mutex run_mutex;
 
-	struct mm_struct *owner;
+	struct task_struct *owner;
 
 	struct kref kref;
 	wait_queue_head_t ibox_wq;
diff --git a/kernel/fork.c b/kernel/fork.c
index c0ee931..b396c07 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -160,6 +160,7 @@ void __put_task_struct(struct task_struct *tsk)
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
+EXPORT_SYMBOL(__put_task_struct);
 
 /*
  * macro override instead of weak attribute alias, to workaround
