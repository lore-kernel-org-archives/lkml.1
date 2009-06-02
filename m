Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbZFBFhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbZFBFhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbZFBFhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:37:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46828 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbZFBFhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:37:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18980.47776.940214.789245@drongo.ozlabs.ibm.com>
Date: Tue, 2 Jun 2009 15:37:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Provide functions for locking and
	pinning the context for a task
In-Reply-To: <20090601231428.GF749@elte.hu>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
	<18979.35192.995732.609215@cargo.ozlabs.ibm.com>
	<20090601162109.GA8459@elte.hu>
	<18980.19019.158462.125715@cargo.ozlabs.ibm.com>
	<20090601231428.GF749@elte.hu>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Yeah, indeed that box has a CPU hotplug testcase - sets cpu1 to 
> offline then online.
> 
> There should be no counters active anywhere during that.

OK, I can't reproduce this on powerpc.  I guess you have dynamic
per-cpu patches in there, and per-cpu areas are getting reinitialized
when cpus come up.  That, combined with the fact that the
migration_notifier in kernel/sched.c puts itself at priority 10, means
that we're getting a call to perf_counter_task_migration() for a
newly-added CPU before perf_cpu_notify() has been called for that CPU,
and so we're trying to use an uninitialized perf_cpu_context and we go
boom.

Could you try the same test with this patch?  If this fixes it, then
that's what the problem is.  It's up to you whether increasing the
priority on perf_cpu_nb is the right solution or whether we should
solve the problem some other way.

Paul.

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3902,8 +3902,12 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
+/*
+ * This has to have a higher priority than migration_notifier in sched.c.
+ */
 static struct notifier_block __cpuinitdata perf_cpu_nb = {
 	.notifier_call		= perf_cpu_notify,
+	.priority		= 20,
 };
 
 void __init perf_counter_init(void)
