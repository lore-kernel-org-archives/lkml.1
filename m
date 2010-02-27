Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968325Ab0B0NaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:30:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968306Ab0B0NaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:30:07 -0500
Date: Sat, 27 Feb 2010 14:29:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core/ipi changes for v2.6.34
Message-ID: <20100227132955.GA26908@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-ipi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-ipi-for-linus

One small optimization.

 Thanks,

	Ingo

------------------>
Milton Miller (1):
      generic-ipi: Optimize accesses by using DEFINE_PER_CPU_SHARED_ALIGNED for IPI data


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
