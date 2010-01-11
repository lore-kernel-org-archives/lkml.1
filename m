Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155Ab0AKV2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0AKV2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975Ab0AKV21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:28:27 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50852 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0AKV1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=A3lEhvi2IuHcCXTg45N5z4V5qJzzAj5ZVYwesr6VxOInUEX8jQEkSp1NRrPiMC/z+8
         BqCnZ9ROAIHKsS/PuhTi0Iti7yzy3jCbuzpG0ouJ6XO3qgdIKeUvEUZqQqmsUysSiSYd
         aboJ+4lXATJ0V/9Cg9ZWM8DxxtqcgtgNSowsM=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 25/26] kprobes: Convert to raw_spinlocks
Date: Mon, 11 Jan 2010 22:26:55 +0100
Message-Id: <1263245216-14754-26-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-25-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
 <1263245216-14754-19-git-send-email-jkacur@redhat.com>
 <1263245216-14754-20-git-send-email-jkacur@redhat.com>
 <1263245216-14754-21-git-send-email-jkacur@redhat.com>
 <1263245216-14754-22-git-send-email-jkacur@redhat.com>
 <1263245216-14754-23-git-send-email-jkacur@redhat.com>
 <1263245216-14754-24-git-send-email-jkacur@redhat.com>
 <1263245216-14754-25-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot be sleeping locks in preempt-rt to raw_spinlocks.

See also dc23e836d8d25fe5aa4057d54dae2094fbc614f6

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/kprobes.h |    2 +-
 kernel/kprobes.c        |   34 +++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 1b672f7..620df87 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -170,7 +170,7 @@ struct kretprobe {
 	int nmissed;
 	size_t data_size;
 	struct hlist_head free_instances;
-	spinlock_t lock;
+	raw_spinlock_t lock;
 };
 
 struct kretprobe_instance {
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b7df302..40547e6 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -73,10 +73,10 @@ static bool kprobes_all_disarmed;
 static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
-	spinlock_t lock ____cacheline_aligned_in_smp;
+	raw_spinlock_t lock ____cacheline_aligned_in_smp;
 } kretprobe_table_locks[KPROBE_TABLE_SIZE];
 
-static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
+static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 {
 	return &(kretprobe_table_locks[hash].lock);
 }
@@ -410,9 +410,9 @@ void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 	hlist_del(&ri->hlist);
 	INIT_HLIST_NODE(&ri->hlist);
 	if (likely(rp)) {
-		spin_lock(&rp->lock);
+		raw_spin_lock(&rp->lock);
 		hlist_add_head(&ri->hlist, &rp->free_instances);
-		spin_unlock(&rp->lock);
+		raw_spin_unlock(&rp->lock);
 	} else
 		/* Unregistering */
 		hlist_add_head(&ri->hlist, head);
@@ -422,34 +422,34 @@ void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
-	spinlock_t *hlist_lock;
+	raw_spinlock_t *hlist_lock;
 
 	*head = &kretprobe_inst_table[hash];
 	hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_lock_irqsave(hlist_lock, *flags);
+	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
 
 static void __kprobes kretprobe_table_lock(unsigned long hash,
 	unsigned long *flags)
 {
-	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_lock_irqsave(hlist_lock, *flags);
+	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_lock_irqsave(hlist_lock, *flags);
 }
 
 void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
 	unsigned long *flags)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
-	spinlock_t *hlist_lock;
+	raw_spinlock_t *hlist_lock;
 
 	hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_unlock_irqrestore(hlist_lock, *flags);
+	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
 void __kprobes kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
 {
-	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
-	spin_unlock_irqrestore(hlist_lock, *flags);
+	raw_spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	raw_spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
 /*
@@ -982,12 +982,12 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
 	hash = hash_ptr(current, KPROBE_HASH_BITS);
-	spin_lock_irqsave(&rp->lock, flags);
+	raw_spin_lock_irqsave(&rp->lock, flags);
 	if (!hlist_empty(&rp->free_instances)) {
 		ri = hlist_entry(rp->free_instances.first,
 				struct kretprobe_instance, hlist);
 		hlist_del(&ri->hlist);
-		spin_unlock_irqrestore(&rp->lock, flags);
+		raw_spin_unlock_irqrestore(&rp->lock, flags);
 
 		ri->rp = rp;
 		ri->task = current;
@@ -1004,7 +1004,7 @@ static int __kprobes pre_handler_kretprobe(struct kprobe *p,
 		kretprobe_table_unlock(hash, &flags);
 	} else {
 		rp->nmissed++;
-		spin_unlock_irqrestore(&rp->lock, flags);
+		raw_spin_unlock_irqrestore(&rp->lock, flags);
 	}
 	return 0;
 }
@@ -1040,7 +1040,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 		rp->maxactive = num_possible_cpus();
 #endif
 	}
-	spin_lock_init(&rp->lock);
+	raw_spin_lock_init(&rp->lock);
 	INIT_HLIST_HEAD(&rp->free_instances);
 	for (i = 0; i < rp->maxactive; i++) {
 		inst = kmalloc(sizeof(struct kretprobe_instance) +
@@ -1227,7 +1227,7 @@ static int __init init_kprobes(void)
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		INIT_HLIST_HEAD(&kprobe_table[i]);
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
-		spin_lock_init(&(kretprobe_table_locks[i].lock));
+		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}
 
 	/*
-- 
1.6.5.2

