Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbYKFUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbYKFUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYKFUjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:39:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54923 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYKFUjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:39:04 -0500
Date: Thu, 6 Nov 2008 21:38:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] restore sched_exec load balance heuristics
Message-ID: <20081106203853.GF3578@elte.hu>
References: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com> <20081106200746.GA3578@elte.hu> <b040c32a0811061232j49a40ce8md32ff5e614441e38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811061232j49a40ce8md32ff5e614441e38@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> On Thu, Nov 6, 2008 at 12:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > ok, this should be solved - but rather at the level of
> > sched_balance_self(): it should never migrate this task over to
> > another cpu, it should take away this task's load from the current
> > CPU's load when considering migration.
> 
> There are two callers to sched_balance_self().  In the sched_fork 
> path, sched_balance_self will balance the newly forked task.  I 
> think it is OK to bounce a newly forked task to another CPU since 
> current CPU will be busy when fork returns in the parent process.
> 
> And if sched_balance_self() needs to different between fork / exec 
> load balance, it has to check a flag from function argument, which I 
> think it is better to just short circuit in sched_exec() directly.

yes, but the problem is deeper than that and your fix only addresses 
teh most obvious case: when a single task is exec()-ing. But if we 
exec while there are two tasks on this CPU, and one task on every 
other CPU, we bounce around the "new" task unnecessarily just as much.

So the best solution is to pass in not a flag, but a 'load bias' 
offset - which is 0 in the fork case and -self-weight in the exec 
case.

Ok?

	Ingo
