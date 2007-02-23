Return-Path: <linux-kernel-owner+w=401wt.eu-S1751724AbXBWGNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbXBWGNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXBWGNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:13:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40825 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbXBWGNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:13:21 -0500
Date: Fri, 23 Feb 2007 07:08:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>,
       tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
Message-ID: <20070223060802.GA8562@elte.hu>
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com> <1172008584.25076.0.camel@localhost.localdomain> <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com> <1172072023.25076.64.camel@localhost.localdomain> <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com> <1172088044.25076.125.camel@localhost.localdomain> <45DCF644.9040009@googlemail.com> <45DD756D.3040006@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD756D.3040006@googlemail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.9 required=5.9 tests=ALL_TRUSTED,BAYES_00,PLING_QUERY autolearn=no SpamAssassin version=3.0.3
	0.4 PLING_QUERY            Subject has exclamation mark and question mark
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Michal,

* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Here is more
> 
> hardirqs last  enabled at (30787): [<c0104249>] syscall_exit_work+0x11/0x26
> hardirqs last disabled at (30788): [<c0103fc9>] ret_from_exception+0x9/0xc
> softirqs last  enabled at (30202): [<c01265df>] __do_softirq+0xe4/0xea
> softirqs last disabled at (30193): [<c0106a75>] do_softirq+0x64/0xd1

could you please try the patch below? This is pretty much the only 
condition under which we can silently 'leak' pending softirqs, and 
trigger the new warning: if something does cond_resched_softirq() in 
non-runnable state. (which is a no-no, but nothing enforced this, so it 
could in theory happen.) So the question is, with this patch applied, do 
you get these new warnings from sched.c?

	Ingo

-------------------------->
Subject: [patch] add warning to cond_resched_softirq()
From: Ingo Molnar <mingo@elte.hu>

make sure that cond_resched_softirq() is always called with a runnable 
task - so that we do not leave softirq work pending indefinitely.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4689,6 +4689,7 @@ int __sched cond_resched_softirq(void)
 	BUG_ON(!in_softirq());
 
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
+		WARN_ON(current->state != TASK_RUNNING);
 		raw_local_irq_disable();
 		_local_bh_enable();
 		raw_local_irq_enable();
