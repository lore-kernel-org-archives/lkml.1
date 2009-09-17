Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZIQH35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZIQH35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbZIQH34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:29:56 -0400
Received: from www.tglx.de ([62.245.132.106]:44585 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379AbZIQH3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:29:55 -0400
Date: Thu, 17 Sep 2009 09:29:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Knut Petersen <Knut_Petersen@t-online.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.31-rt10
In-Reply-To: <4AB16A02.5050607@t-online.de>
Message-ID: <alpine.LFD.2.00.0909170928050.2889@localhost.localdomain>
References: <4AB16A02.5050607@t-online.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Knut,

On Thu, 17 Sep 2009, Knut Petersen wrote:
> Hi Thomas!
> 
> Well, I thought it was a good idea to test the rt patch.
> Never did that before. Cyclictest output looked great, but then
> i tried to do some audio recording. I used "chrt 80 arecord ..."
> to record at 96kHz/16bit stereo from an RME Digi96/PAD.
> That seemed to work fine on an idle machine. So I put
> some extra load on the machine. A "make -j 16" kernel
> compilation locks keyboard and screen within minutes,
> no matter if X is running or not. The attached part of
> /var/log/messages shows two of those events - I deleted all
> but the very first log entries.

Duh, never used latencytop on RT. Patch below should fix that.

Thanks,

	tglx
---
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index ca07c5c..34311e1 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -59,7 +59,7 @@
 #include <linux/slab.h>
 #include <linux/stacktrace.h>
 
-static DEFINE_SPINLOCK(latency_lock);
+static DEFINE_ATOMIC_SPINLOCK(latency_lock);
 
 #define MAXLR 128
 static struct latency_record latency_record[MAXLR];
@@ -73,19 +73,19 @@ void clear_all_latency_tracing(struct task_struct *p)
 	if (!latencytop_enabled)
 		return;
 
-	spin_lock_irqsave(&latency_lock, flags);
+	atomic_spin_lock_irqsave(&latency_lock, flags);
 	memset(&p->latency_record, 0, sizeof(p->latency_record));
 	p->latency_record_count = 0;
-	spin_unlock_irqrestore(&latency_lock, flags);
+	atomic_spin_unlock_irqrestore(&latency_lock, flags);
 }
 
 static void clear_global_latency_tracing(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&latency_lock, flags);
+	atomic_spin_lock_irqsave(&latency_lock, flags);
 	memset(&latency_record, 0, sizeof(latency_record));
-	spin_unlock_irqrestore(&latency_lock, flags);
+	atomic_spin_unlock_irqrestore(&latency_lock, flags);
 }
 
 static void __sched
@@ -191,7 +191,7 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	lat.max = usecs;
 	store_stacktrace(tsk, &lat);
 
-	spin_lock_irqsave(&latency_lock, flags);
+	atomic_spin_lock_irqsave(&latency_lock, flags);
 
 	account_global_scheduler_latency(tsk, &lat);
 
@@ -233,7 +233,7 @@ __account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
 	memcpy(&tsk->latency_record[i], &lat, sizeof(struct latency_record));
 
 out_unlock:
-	spin_unlock_irqrestore(&latency_lock, flags);
+	atomic_spin_unlock_irqrestore(&latency_lock, flags);
 }
 
 static int lstats_show(struct seq_file *m, void *v)

