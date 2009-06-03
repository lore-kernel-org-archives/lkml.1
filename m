Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZFCXOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZFCXOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZFCXNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:13:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:20331 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbZFCXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JFo79f74WP14H2BK2MZXmihSUwFFi/JVP5fDSEgfPxXs2wQn/H6etc/yBIqYgn33Hw
         G3MlHOWdV7fIVQIPGAPNpcLR2cQSpBLpEGw8sZ2VjMktLj53AYskEdWg6TBU4bCaTek3
         Uoo6VOSuarOb2Mkx6TFNy5OjQM2Ny0roSsDac=
Date: Thu, 4 Jun 2009 03:06:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/9] exec_path 6/9: add struct spu::tsk
Message-ID: <20090603230656.GG853@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603230422.GB853@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass down task_struct too.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/powerpc/include/asm/spu.h            |    3 ++-
 arch/powerpc/platforms/cell/spu_base.c    |   11 ++++++-----
 arch/powerpc/platforms/cell/spufs/sched.c |    4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/spu.h b/arch/powerpc/include/asm/spu.h
index 0ab8d86..f9b1bcf 100644
--- a/arch/powerpc/include/asm/spu.h
+++ b/arch/powerpc/include/asm/spu.h
@@ -135,6 +135,7 @@ struct spu {
 	u64 class_1_dsisr;
 	size_t ls_size;
 	unsigned int slb_replace;
+	struct task_struct *tsk;
 	struct mm_struct *mm;
 	struct spu_context *ctx;
 	struct spu_runqueue *rq;
@@ -212,7 +213,7 @@ static inline void crash_register_spus(struct list_head *list)
 #endif
 
 extern void spu_invalidate_slbs(struct spu *spu);
-extern void spu_associate_mm(struct spu *spu, struct mm_struct *mm);
+extern void spu_associate_task(struct spu *spu, struct task_struct *tsk);
 int spu_64k_pages_available(void);
 
 /* Calls from the memory management to the SPU */
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index 9abd210..46f4a63 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -117,17 +117,18 @@ static inline void mm_needs_global_tlbie(struct mm_struct *mm)
 	bitmap_fill(cpumask_bits(mm_cpumask(mm)), nr);
 }
 
-void spu_associate_mm(struct spu *spu, struct mm_struct *mm)
+void spu_associate_task(struct spu *spu, struct task_struct *tsk)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&spu_full_list_lock, flags);
-	spu->mm = mm;
+	spu->tsk = tsk;
+	spu->mm = tsk ? tsk->mm : NULL;
 	spin_unlock_irqrestore(&spu_full_list_lock, flags);
-	if (mm)
-		mm_needs_global_tlbie(mm);
+	if (tsk && tsk->mm)
+		mm_needs_global_tlbie(tsk->mm);
 }
-EXPORT_SYMBOL_GPL(spu_associate_mm);
+EXPORT_SYMBOL_GPL(spu_associate_task);
 
 int spu_64k_pages_available(void)
 {
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 9fbd87a..2f7e497 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -230,7 +230,7 @@ static void spu_bind_context(struct spu *spu, struct spu_context *ctx)
 	ctx->stats.slb_flt_base = spu->stats.slb_flt;
 	ctx->stats.class2_intr_base = spu->stats.class2_intr;
 
-	spu_associate_mm(spu, ctx->owner->mm);
+	spu_associate_task(spu, ctx->owner);
 
 	spin_lock_irq(&spu->register_lock);
 	spu->ctx = ctx;
@@ -470,7 +470,7 @@ static void spu_unbind_context(struct spu *spu, struct spu_context *ctx)
 	spu->ctx = NULL;
 	spin_unlock_irq(&spu->register_lock);
 
-	spu_associate_mm(spu, NULL);
+	spu_associate_task(spu, NULL);
 
 	ctx->stats.slb_flt +=
 		(spu->stats.slb_flt - ctx->stats.slb_flt_base);
