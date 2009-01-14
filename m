Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbZANJ4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbZANJ4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbZANJ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:56:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:54709 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZANJ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:56:39 -0500
Subject: Re: 2.6.28 has unconfigurable group sched?
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Glines <mark@glines.org>
Cc: Ingo Molnar <mingo@elte.hu>, L-K <linux-kernel@vger.kernel.org>
In-Reply-To: <496CDDE9.3050008@glines.org>
References: <496CDDE9.3050008@glines.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jan 2009 10:56:32 +0100
Message-Id: <1231926992.7141.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 10:31 -0800, Mark Glines wrote:
> Hi,
> 
> I've got an issue on x86-64 where I can't configure the system to allow
> RT tasks for a non-root user.
> 
> In 2.6.26.5, I was able to do the following to set things up nicely:
> echo 450000 >/sys/kernel/uids/0/cpu_rt_runtime
> echo 450000 >/sys/kernel/uids/1000/cpu_rt_runtime
> 
> I've searched lkml archives and am unable to figure out what changed.
> As far as I can tell, the documentation (sched-rt-group.txt) says this
> should work, and indeed, it did work with 2.6.26.
> 
> Seems like every value I try to echo into the /sys files returns EINVAL.
>  Even when I'm just writing the same value it already had:
> 
> chirp uids # pwd
> /sys/kernel/uids
> chirp uids # cat 0/cpu_rt_period
> 1000000
> chirp uids # cat 0/cpu_rt_runtime
> 950000
> chirp uids # cat 1000/cpu_rt_period
> 1000000
> chirp uids # cat 1000/cpu_rt_runtime
> 0
> chirp uids # echo 450000 >0/cpu_rt_runtime
> echo: write error: invalid argument
> chirp uids # echo 450000 >1000/cpu_rt_runtime
> echo: write error: invalid argument
> chirp uids # echo 950000 >0/cpu_rt_runtime
> echo: write error: invalid argument
> chirp uids # echo 0 >0/cpu_rt_runtime
> echo: write error: invalid argument
> 
> So it seems rt_schedulable() is never succeeding.  Any ideas?

Yeah, I should test this user grouping stuff more often :/

The below fixes it for me.
---
Subject: sched: fix bandwidth validation for UID grouping 

For UID grouping we initialize the root group with infinite bandwidth
which by default is actually more than the global limit, therefore the
bandwidth check always fails.

Because the root group is a phantom group (for UID grouping) we cannot
runtime adjust it, therefore we let it reflect the global bandwidth
settings.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: stable@kernel.org
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 02f35a1..a61fb0e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9195,6 +9195,13 @@ static int tg_schedulable(struct task_group *tg, void *data)
 		runtime = d->rt_runtime;
 	}
 
+#ifdef CONFIG_USER_SCHED
+	if (tg == &root_task_group) {
+		period = global_rt_period();
+		runtime = global_rt_runtime();
+	}
+#endif
+
 	/*
 	 * Cannot have more runtime than the period.
 	 */

