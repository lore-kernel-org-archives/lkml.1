Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062Ab0AKV25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0AKV25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761Ab0AKV2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:28:54 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60356 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0AKV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AEtTFxqhNlnsj7ZPhMTRpMSLXYt6QG5xSrEPeWHwehSVgOXe0YI//M620GgnBzdOGj
         KQGYu3v8NpDhJSKIe5QTjT0gJZOvhjGNv5eBqETFOva+QHNllv8RYvuwvqPzLOheS9nz
         WoArdC6Sef+5Y1Zmfq0voGmiHQY1OaLghjJBQ=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 21/26] percpu_counter: Convert to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:51 +0100
Message-Id: <1263245216-14754-22-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-21-git-send-email-jkacur@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot be sleeping locks in preempt-rt to raw_spinlocks.

See also 609368d881acb7c5bcf5560cb4098a202f2e0ba6

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/percpu_counter.h |    2 +-
 lib/percpu_counter.c           |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index a7684a5..7823c33 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -16,7 +16,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index aeaa6d7..10fb740 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -16,13 +16,13 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	raw_spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	raw_spin_unlock(&fbc->lock);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -35,10 +35,10 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 	pcount = per_cpu_ptr(fbc->counters, cpu);
 	count = *pcount + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
+		raw_spin_lock(&fbc->lock);
 		fbc->count += count;
 		*pcount = 0;
-		spin_unlock(&fbc->lock);
+		raw_spin_unlock(&fbc->lock);
 	} else {
 		*pcount = count;
 	}
@@ -55,13 +55,13 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
+	raw_spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
-	spin_unlock(&fbc->lock);
+	raw_spin_unlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -69,7 +69,7 @@ EXPORT_SYMBOL(__percpu_counter_sum);
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 			  struct lock_class_key *key)
 {
-	spin_lock_init(&fbc->lock);
+	raw_spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
 	fbc->counters = alloc_percpu(s32);
@@ -126,11 +126,11 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 		s32 *pcount;
 		unsigned long flags;
 
-		spin_lock_irqsave(&fbc->lock, flags);
+		raw_spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
-		spin_unlock_irqrestore(&fbc->lock, flags);
+		raw_spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif
-- 
1.6.5.2

