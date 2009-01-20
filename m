Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbZATQUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbZATQUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbZATQUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:20:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:34583 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbZATQUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:20:07 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, Avi Kivity <avi@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20090120160613.GA32650@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	 <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera>
	 <1232410363.4768.21.camel@kulgan.wumi.org.au>
	 <20090120113546.GA26571@elte.hu>
	 <1232455343.4895.4.camel@kulgan.wumi.org.au>
	 <20090120125652.GA1457@elte.hu>
	 <1232461380.4895.33.camel@kulgan.wumi.org.au>
	 <20090120142515.GC10224@elte.hu>
	 <1232466686.4895.45.camel@kulgan.wumi.org.au>
	 <20090120160613.GA32650@elte.hu>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 17:19:36 +0100
Message-Id: <1232468376.4886.88.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 17:06 +0100, Ingo Molnar wrote:
> se.wait_max                        :           -92.027877
> 
> that field is not supposed to be negative. Mike, Peter, any ideas?

Possibly unrelated, but whilst I was poking at try_to_wake_up yesterday,
I thought I spotted a site where we fail to update rq clock.

Since we just moved the task to a new cpu (and thus rq) we need to
update_rq_clock() again.

diff --git a/kernel/sched.c b/kernel/sched.c
index d7ae5f4..6cd5e52 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2398,6 +2398,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (cpu != orig_cpu) {
 		set_task_cpu(p, cpu);
 		task_rq_unlock(rq, &flags);
+		update_rq_clock(rq);
 		/* might preempt at this point */
 		rq = task_rq_lock(p, &flags);
 		old_state = p->state;


