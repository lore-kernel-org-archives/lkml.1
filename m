Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZAZT7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZAZT7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZAZT7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:59:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbZAZT7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:59:22 -0500
Date: Mon, 26 Jan 2009 20:59:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [git pull] x86 fixes
Message-ID: <20090126195910.GA13471@elte.hu>
References: <20090126171723.GA32030@elte.hu> <20090126110539.2000cd30.akpm@linux-foundation.org> <20090126192016.GA1211@elte.hu> <20090126114038.a2f6606f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126114038.a2f6606f.akpm@linux-foundation.org>
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

* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Jan 2009 20:20:16 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Mon, 26 Jan 2009 18:17:23 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Rusty Russell (2):
> > > >       ...
> > > >       work_on_cpu: Use our own workqueue.
> > > 
> > > wtf?
> > 
> > an x86 fix depends on it:
> > 
> > 7285908: cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> > 
> 
> Right.  And these are currently under active (albeit rather slow) 
> discussion.
> 
> The changelogs suck, nobody can be assed actually telling us what the 
> bug is and the patches just casually toss yet another gaggle of kernel 
> threads into there.

One problem is that for example do_dbs_timer() [used both in the 
cpufreq_ondemand and cpufreq_conservative cpufreq drivers] gets queued 
into the generic kevent workqueue via schedule_work(). But work_on_cpu() 
needs to serialize on the worklet - i.e. it needs to do a flush_work() - 
and does this with the cpufreq lock held.

So we have a 'worklet inversion' bug here - and this got reported as a 
hard to debug boot hang on some systems.
The root cause is that kevents is not that do_dbs_timer() uses 
schedule_work() - the root cause is that kevents workqueue is a too 
generic workqueue that is the union of all casual workqueue users in the 
kernel. That is fine (and it is its purpose) but it should not be used for 
core kernel facilities such as work_on_cpu() - precisely because doing so 
would limit that facility's genericity.

This bug was always there but dormant until work_on_cpu() was used from a 
deep enough codepath.

So the solution here is to isolate work_on_cpu()s mechanisms from the 
'misc' workqueue that schedule_work() deals with - this is what Rusty's 
patch does.

Your observation about there being too many workqueue threads is correct 
but this commit is IMO a valid use of the workqueue facility. This 
workqueue it only gets created on CONFIG_SMP so there cost is about ~10K 
RAM per CPU.

I also agree that the commit should have included this description.

	Ingo
