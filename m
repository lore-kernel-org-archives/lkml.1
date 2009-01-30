Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZA3NuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZA3NuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZA3Nt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:49:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44886 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbZA3Nt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:49:57 -0500
Date: Fri, 30 Jan 2009 14:49:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090130134935.GC17401@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901291213.32959.rusty@rustcorp.com.au> <20090128181205.3b15fa4a.akpm@linux-foundation.org> <200901301633.54013.rusty@rustcorp.com.au> <20090129223042.47dc42a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129223042.47dc42a1.akpm@linux-foundation.org>
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

> On Fri, 30 Jan 2009 16:33:53 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Thursday 29 January 2009 12:42:05 Andrew Morton wrote:
> > > On Thu, 29 Jan 2009 12:13:32 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > 
> > > > On Thursday 29 January 2009 06:14:40 Andrew Morton wrote:
> > > > > It's vulnerable to the same deadlock, I think?  Suppose we have:
> > > > ...
> > > > > - A calls work_on_cpu() and takes woc_mutex.
> > > > > 
> > > > > - Before function_which_takes_L() has started to execute, task B takes L
> > > > >   then calls work_on_cpu() and task B blocks on woc_mutex.
> > > > > 
> > > > > - Now function_which_takes_L() runs, and blocks on L
> > > > 
> > > > Agreed, but now it's a fairly simple case.  Both sides have to take lock L, and both have to call work_on_cpu.
> > > > 
> > > > Workqueues are more generic and widespread, and an amazing amount of stuff gets called from them.  That's why I felt uncomfortable with removing the one known problematic caller.
> > > > 
> > > 
> > > hm.  it's a bit of a timebomb.
> > > 
> > > y'know, the original way in which acpi-cpufreq did this is starting to
> > > look attractive.  Migrate self to that CPU then just call the dang
> > > function.  Slow, but no deadlocks (I think)?
> > 
> > Just buggy.  What random thread was it mugging?  If there's any path 
> > where it's not a kthread, what if userspace does the same thing at the 
> > same time? We risk running on the wrong cpu, *then* overriding 
> > userspace when we restore it.
> 
> hm, Ok, not unficable but not pleasant.
> 
> > In general these cpumask games are a bad idea.
> 
> So we still don't have any non-buggy proposal.

Current upstream code is not pretty (due to the extra workqueue) but not 
buggy either. You'd be right to point out that it is easy to insert a bug 
into it and thus it's not pleasant (more of a workaround than a real fix) 
but if it's outright buggy then please talk up.

	Ingo
