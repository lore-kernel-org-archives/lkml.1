Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZABQGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZABQGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZABQGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:06:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45690 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbZABQGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:06:32 -0500
Date: Fri, 2 Jan 2009 17:06:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tip/master merge problem?
Message-ID: <20090102160621.GE1180@elte.hu>
References: <495BED6D.8040307@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495BED6D.8040307@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> 
> Hi Ingo,
> 
> I found this code snippet in kernel/sched.c in the tip/master tree.  It
> appears to be a merge mistake:  (cut and pasted - no tabs)
> 
> 292                 /*
> 293                  * If this cpu is the one which updates jiffies, then
> 294                  * give up the assignment and let it be taken by the
> 295                  * cpu which runs the tick timer next, which might be
> 296                  * this cpu as well. If we don't drop this here the
> 297                  * jiffies might be stale and do_timer() never
> 298                  * invoked.
> 299                  */
> 300                 if (cpu == tick_do_timer_cpu)
> 301                         tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> 302
> 303                 if (delta_jiffies > 1)
> 304
> 305                 /* Skip reprogram of event if its not changed */
> 306                 if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
> 307                         goto out;
> 308
> 309                         cpumask_set_cpu(cpu, nohz_cpu_mask);
> 
> I think the "Skip reprogram" was inserted into the middle of a previous
> if-then statement.

indeed, this is plain broken. It happened to build and boot but still it's 
broken.

> git blames it on:
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 292)              /*
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 293)               * If this cpu is the one which updates jiffies, then
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 294)               * give up the assignment and let it be taken by the
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 295)               * cpu which runs the tick timer next, which might be
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 296)               * this cpu as well. If we don't drop this here the
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 297)               * jiffies might be stale and do_timer() never
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 298)               * invoked.
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 299)               */
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 300)              if (cpu == tick_do_timer_cpu)
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 301)                      tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 302)
> 6ba9b346 (Ingo Molnar       2007-02-19 18:11:56 +0000 303)              if (delta_jiffies > 1)
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 304)
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 305)              /* Skip reprogram of event if its not changed */
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 306)              if (ts->tick_stopped && ktime_equal(expires, dev->next_event))
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 307)                      goto out;
> 00147449 (Woodruff, Richard 2008-12-01 14:18:11 -0800 308)
> 6a7b3dc3 (Rusty Russell     2008-11-25 02:35:04 +1030 309)                      cpumask_set_cpu(cpu, nohz_cpu_mask);
> 
> I've Cc'd both interested parties.

purely my fault. I've zapped that conflict resolution and picked up yours.

	Ingo
