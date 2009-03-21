Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbZCUPXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbZCUPXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759798AbZCUPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:22:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41550 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759698AbZCUPWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:22:35 -0400
Date: Sat, 21 Mar 2009 16:22:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: ptrace performance (was: [Bug #12208] uml is very slow on
	2.6.28 host)
Message-ID: <20090321152217.GB1073@elte.hu>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.c1H.2PCvJB@chimera> <49C4FD41.4030504@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C4FD41.4030504@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Riepe <michael.riepe@googlemail.com> wrote:

> Disclaimer: I'm not using UML, but these problems may be related.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> > Subject		: uml is very slow on 2.6.28 host
> > Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> > Date		: 2008-12-12 9:35 (93 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4
> 
> The other day I noticed a dramatic ptrace slowdown between 2.6.27 and
> 2.6.28.x (verified with 2.6.28.8). In particular, a command like
> 
> 	dd if=/dev/zero of=/dev/null bs=1024k count=1024
> 
> will normally report a throughput in the GB/s range. On 2.6.27, this is
> also true if you run
> 
> 	strace -o /dev/null <dd command as above>
> 
> which is only a little slower. But if I do the same on 2.6.28.x, I 
> get a throughput of about 100 MB/s or less, i.e. less than 10%. I 
> tried the commands on three different machines (an Athlon64 3000+, 
> a Core Duo T2400 and an Atom 330), and they all behave similar. 
> The more system calls a program uses, the worse the slowdown (try 
> the dd command with bs=16k and count=65536, for example - but 
> don't hold your breath).
> 
> Interestingly, the CPUs are mostly idle while the command is 
> executing on 2.6.28.x, but there is a high (system) load on 
> 2.6.27. Therefore, I suspect that it's a scheduling or maybe timer 
> problem that was introduced between 2.6.27 and 2.6.28. I haven't 
> had the time to check the rc kernels yet; perhaps someone else can 
> run a quick check to verify that it's gone in the latest 
> 2.6.29-rc.

that's almost certainly due to the wait_task_inactive() change. Does 
the patch below improve things?

	Ingo

diff --git a/kernel/sched.c b/kernel/sched.c
index 3e827b8..2d60f23 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2119,7 +2119,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * yield - it could be a while.
 		 */
 		if (unlikely(on_rq)) {
-			schedule_timeout_uninterruptible(1);
+			cpu_relax();
+			cond_resched();
 			continue;
 		}
 
