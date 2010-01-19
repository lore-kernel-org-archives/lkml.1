Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434Ab0ASOX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0ASOX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260Ab0ASOX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:23:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:58343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0ASOX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:23:56 -0500
Date: Tue, 19 Jan 2010 14:22:54 GMT
From: tip-bot for Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
       miltonm@bga.com, jens.axboe@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       miltonm@bga.com, peterz@infradead.org, jens.axboe@oracle.com,
       npiggin@suse.de, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100118020051.GR12666@kryten>
References: <20100118020051.GR12666@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/ipi] generic-ipi: Optimize accesses by using DEFINE_PER_CPU_SHARED_ALIGNED for IPI data
Message-ID: <tip-e03bcb68629c7f0728c95f1afe06ce48565c7713@git.kernel.org>
Git-Commit-ID: e03bcb68629c7f0728c95f1afe06ce48565c7713
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 14:22:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e03bcb68629c7f0728c95f1afe06ce48565c7713
Gitweb:     http://git.kernel.org/tip/e03bcb68629c7f0728c95f1afe06ce48565c7713
Author:     Milton Miller <miltonm@bga.com>
AuthorDate: Mon, 18 Jan 2010 13:00:51 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Jan 2010 09:02:59 +0100

generic-ipi: Optimize accesses by using DEFINE_PER_CPU_SHARED_ALIGNED for IPI data

The smp ipi data is passed around and given write access by
other cpus and should be separated from per-cpu data consumed by
this cpu.

Looking for hot lines, I saw call_function_data shared with
tick_cpu_sched.

Signed-off-by: Milton Miller <miltonm@bga.com>
Acked-by: Anton Blanchard <anton@samba.org>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: : Nick Piggin <npiggin@suse.de>
LKML-Reference: <20100118020051.GR12666@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/smp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index f104084..9867b6b 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,8 +12,6 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
-static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-
 static struct {
 	struct list_head	queue;
 	raw_spinlock_t		lock;
@@ -33,12 +31,14 @@ struct call_function_data {
 	cpumask_var_t		cpumask;
 };
 
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
+
 struct call_single_queue {
 	struct list_head	list;
 	raw_spinlock_t		lock;
 };
 
-static DEFINE_PER_CPU(struct call_function_data, cfd_data);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
 
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -256,7 +256,7 @@ void generic_smp_call_function_single_interrupt(void)
 	}
 }
 
-static DEFINE_PER_CPU(struct call_single_data, csd_data);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
