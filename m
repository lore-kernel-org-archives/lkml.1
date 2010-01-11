Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219Ab0AKV3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0AKV3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141Ab0AKV24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:28:56 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50852 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab0AKV1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=lTtYeobxsIkD+sCQ9hZggoK2D8s617SlgZ6jV7CBEyULmk7LytLfQ5W/NObhqJxRy7
         CxwCfSRRVLJHsnsVMbzugCPsAsC9zZnM6D0OZxvAhCpfcFO9g1M4OXnbH5CjKJF4wRT3
         NdAIK4Ey5QYB09V3iUT6SUtnftSk3ULTJJHbw=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 20/26] proportions: Convert spinlocks to raw_spinlocks.
Date: Mon, 11 Jan 2010 22:26:50 +0100
Message-Id: <1263245216-14754-21-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-20-git-send-email-jkacur@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot be sleeping locks in preempt-rt to
raw_spinlocks

See also: 0fc7741cfd53c5c5ca710e075e05808e1bf9be71

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/proportions.h |    6 +++---
 lib/proportions.c           |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index cf793bb..ef35bb7 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -58,7 +58,7 @@ struct prop_local_percpu {
 	 */
 	int shift;
 	unsigned long period;
-	spinlock_t lock;		/* protect the snapshot state */
+	raw_spinlock_t lock;		/* protect the snapshot state */
 };
 
 int prop_local_init_percpu(struct prop_local_percpu *pl);
@@ -106,11 +106,11 @@ struct prop_local_single {
 	 */
 	unsigned long period;
 	int shift;
-	spinlock_t lock;		/* protect the snapshot state */
+	raw_spinlock_t lock;		/* protect the snapshot state */
 };
 
 #define INIT_PROP_LOCAL_SINGLE(name)			\
-{	.lock = __SPIN_LOCK_UNLOCKED(name.lock),	\
+{	.lock = __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 }
 
 int prop_local_init_single(struct prop_local_single *pl);
diff --git a/lib/proportions.c b/lib/proportions.c
index d50746a..05df848 100644
--- a/lib/proportions.c
+++ b/lib/proportions.c
@@ -190,7 +190,7 @@ prop_adjust_shift(int *pl_shift, unsigned long *pl_period, int new_shift)
 
 int prop_local_init_percpu(struct prop_local_percpu *pl)
 {
-	spin_lock_init(&pl->lock);
+	raw_spin_lock_init(&pl->lock);
 	pl->shift = 0;
 	pl->period = 0;
 	return percpu_counter_init(&pl->events, 0);
@@ -226,7 +226,7 @@ void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
 	if (pl->period == global_period)
 		return;
 
-	spin_lock_irqsave(&pl->lock, flags);
+	raw_spin_lock_irqsave(&pl->lock, flags);
 	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
 
 	/*
@@ -247,7 +247,7 @@ void prop_norm_percpu(struct prop_global *pg, struct prop_local_percpu *pl)
 		percpu_counter_set(&pl->events, 0);
 
 	pl->period = global_period;
-	spin_unlock_irqrestore(&pl->lock, flags);
+	raw_spin_unlock_irqrestore(&pl->lock, flags);
 }
 
 /*
@@ -324,7 +324,7 @@ void prop_fraction_percpu(struct prop_descriptor *pd,
 
 int prop_local_init_single(struct prop_local_single *pl)
 {
-	spin_lock_init(&pl->lock);
+	raw_spin_lock_init(&pl->lock);
 	pl->shift = 0;
 	pl->period = 0;
 	pl->events = 0;
@@ -356,7 +356,7 @@ void prop_norm_single(struct prop_global *pg, struct prop_local_single *pl)
 	if (pl->period == global_period)
 		return;
 
-	spin_lock_irqsave(&pl->lock, flags);
+	raw_spin_lock_irqsave(&pl->lock, flags);
 	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
 	/*
 	 * For each missed period, we half the local counter.
@@ -367,7 +367,7 @@ void prop_norm_single(struct prop_global *pg, struct prop_local_single *pl)
 	else
 		pl->events = 0;
 	pl->period = global_period;
-	spin_unlock_irqrestore(&pl->lock, flags);
+	raw_spin_unlock_irqrestore(&pl->lock, flags);
 }
 
 /*
-- 
1.6.5.2

