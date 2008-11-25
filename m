Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYKYQzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYKYQzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYKYQzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:55:42 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43686 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbYKYQzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:55:41 -0500
Message-ID: <492C2E0B.4020209@sgi.com>
Date: Tue, 25 Nov 2008 08:55:39 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Slight fix for locking-fix patch to remove compiler
 warning
References: <200811250238.53883.rusty@rustcorp.com.au> <200811250957.52031.rusty@rustcorp.com.au> <200811250958.41573.rusty@rustcorp.com.au> <200811250959.20652.rusty@rustcorp.com.au>
In-Reply-To: <200811250959.20652.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> We can't call cpuset_cpus_allowed_locked() with the rq lock held.
> However, the rq lock merely protects us from (1) cpu_online_mask changing
> and (2) someone else changing p->cpus_allowed.
> 
> The first can't happen because we're being called from a cpu hotplug
> notifier.  The second doesn't really matter: we are forcing the task off
> a CPU it was affine to, so we're not doing very well anyway.
> 
> So we remove the rq lock from this path, and all is good.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 

Remove rq since it's no longer referenced.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.28-tip-cpumasks.orig/kernel/sched.c
+++ linux-2.6.28-tip-cpumasks/kernel/sched.c
@@ -6126,7 +6126,6 @@ static int __migrate_task_irq(struct tas
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	struct rq *rq;
 	int dest_cpu;
 	/* FIXME: Use cpumask_of_node here. */
 	cpumask_t _nodemask = node_to_cpumask(cpu_to_node(dead_cpu));
