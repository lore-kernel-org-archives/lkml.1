Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYLGN2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYLGN2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYLGN2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:28:38 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:43910 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYLGN2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:28:37 -0500
Message-ID: <493BCF60.1080409@cosmosbay.com>
Date: Sun, 07 Dec 2008 14:28:00 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
References: <4936D287.6090206@cosmosbay.com>	<4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org>
In-Reply-To: <20081206202233.3b74febc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 07 Dec 2008 14:28:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Eric Dumazet a __crit :
>>
>> 1) __percpu_counter_sum() is buggy, it should not write
>> on per_cpu_ptr(fbc->counters, cpu), or another cpu
>> could get its changes lost.
>>
>> __percpu_counter_sum should be read only (const struct percpu_counter *fbc),
>> and no locking needed.
> 
> No, we can't do this - it will break ext4.
> 
> Take a closer look at 1f7c14c62ce63805f9574664a6c6de3633d4a354 and at
> e8ced39d5e8911c662d4d69a342b9d053eaaac4e.
> 
> I suggest that what we do is to revert both those changes.  We can
> worry about the possibly-unneeded spin_lock later, in a separate patch.
> 
> It should have been a separate patch anyway.  It's conceptually
> unrelated and is not a bugfix, but it was mixed in with a bugfix.
> 
> Mingming, this needs urgent consideration, please.  Note that I had to
> make additional changes to ext4 due to the subsequent introduction of
> the dirty_blocks counter.
> 
> 
> Please read the below changelogs carefully and check that I have got my
> head around this correctly - I may not have done.
> 


Hum... e8ced39d5e8911c662d4d69a342b9d053eaaac4e is probably following
the wrong path, but I see the intent. Even in the 'nr_files' case, it could
help to reduce excessive calls to percpu_counter_sum()

What we can do is to use two s64 counters (only in SMP):

s64 reference_count
s64 shadow_count

One that is guaranteed to be touched with appropriate locking
in __percpu_counter_add()

Another one that might be changed by percpu_counter_sum(), without
any locking, acting as a shadow.

Thanks

[PATCH] percpu_counter: Fix __percpu_counter_sum()

commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e (percpu_counter: 
new function percpu_counter_sum_and_set) was to make __percpu_counter_sum()
being able to recompute the estimate of a percpu_counter value.

Problem is that we cannot write on other cpus counters without racing.

What we can do is to use two s64 counter, one acting as a reference
that we should not change in __percpu_counter_sum(), another one, shadowing
the reference.

percpu_counter_read() is reading the shadow
percpu_counter_sum() reads the reference and recompute the shadow.

If a given percpu_counter is never 'summed', then its shadow_counter
is always equal to its reference.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/percpu_counter.h |    9 +++++----
 lib/percpu_counter.c           |   27 +++++++++++++++++----------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 9007ccd..71b5c5d 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -17,7 +17,8 @@
 
 struct percpu_counter {
 	spinlock_t lock;
-	s64 count;
+	s64	   reference_count;
+	s64	   shadow_count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
@@ -55,7 +56,7 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return fbc->shadow_count;
 }
 
 /*
@@ -65,9 +66,9 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
-	barrier();		/* Prevent reloads of fbc->count */
+	barrier();		/* Prevent reloads of fbc->shadow_count */
 	if (ret >= 0)
 		return ret;
 	return 1;
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..44ec857 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -14,6 +14,9 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
+/*
+ * Note : This function is racy
+ */
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
@@ -23,7 +26,8 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
-	fbc->count = amount;
+	fbc->reference_count = amount;
+	fbc->shadow_count = amount;
 	spin_unlock(&fbc->lock);
 }
 EXPORT_SYMBOL(percpu_counter_set);
@@ -38,7 +42,8 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 	count = *pcount + amount;
 	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
-		fbc->count += count;
+		fbc->reference_count += count;
+		fbc->shadow_count += count;
 		*pcount = 0;
 		spin_unlock(&fbc->lock);
 	} else {
@@ -57,16 +62,16 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
-	ret = fbc->count;
+	ret = fbc->reference_count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
-		*pcount = 0;
 	}
-	fbc->count = ret;
-
-	spin_unlock(&fbc->lock);
+	/*
+	 * Update fbc->shadow_count so that percpu_counter_read()
+	 * can have a better idea of this counter 'value'
+	 */
+	fbc->shadow_count = ret;
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -76,7 +81,8 @@ static struct lock_class_key percpu_counter_irqsafe;
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	spin_lock_init(&fbc->lock);
-	fbc->count = amount;
+	fbc->shadow_count = amount;
+	fbc->reference_count = amount;
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -132,7 +138,8 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 
 		spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
-		fbc->count += *pcount;
+		fbc->reference_count += *pcount;
+		fbc->shadow_count += *pcount;
 		*pcount = 0;
 		spin_unlock_irqrestore(&fbc->lock, flags);
 	}

