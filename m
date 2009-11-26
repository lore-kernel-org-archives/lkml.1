Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbZKZOU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbZKZOU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbZKZOU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:20:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:58593 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270AbZKZOU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:20:58 -0500
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259244563.31676.53.camel@laptop>
References: <1258891781.14325.34.camel@marge.simson.net>
	 <1259173672.4027.732.camel@laptop>
	 <1259197270.6186.17.camel@marge.simson.net>
	 <1259199068.6186.33.camel@marge.simson.net> <1259228139.4273.6.camel@twins>
	 <1259230578.15079.12.camel@marge.simson.net>
	 <1259244563.31676.53.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 15:21:01 +0100
Message-ID: <1259245261.31676.73.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 15:09 +0100, Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 11:16 +0100, Mike Galbraith wrote:
> > > min_vruntime should only ever be poked at when holding the respective
> > > rq->lock, even with a barrier a 64bit read on a 32bit machine can go all
> > > funny.
> > 
> > Yeah, but we're looking at an unlocked runqueue.  But never mind...
> 
> The patch is also poking at rq->clock without rq->lock held... not very
> nice.
> 
> Gah, I hate that we're doing migration things without holding both rq's,
> this is making live so very interesting ;-)

so the problem is this bit in kernel/fork.c, which is ran with
tasklist_lock held for writing:

	/*
	 * The task hasn't been attached yet, so its cpus_allowed mask will
	 * not be changed, nor will its assigned CPU.
	 *
	 * The cpus_allowed mask of the parent may have changed after it was
	 * copied first time - so re-copy it here, then check the child's CPU
	 * to ensure it is on a valid CPU (and if not, just force it back to
	 * parent's CPU). This avoids alot of nasty races.
	 */
	p->cpus_allowed = current->cpus_allowed;
	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
			!cpu_online(task_cpu(p))))
		set_task_cpu(p, smp_processor_id());


The problem is that that doesn't close any races at all since
tasklist_lock doesn't fully serialize changes to ->cpus_allowed.

In fact, there is nothing that protects that mask at all.

The second problem is that set_task_cpu() is accessing data from both
the old and the new rq, which basically requires is being ran with both
rq's locked, and the regular migration paths do so.

However things like ttwu() try to be cute and do not, opening the doors
to all kinds of funny.

Clearly we don't really want to do double_rq_lock() in ttwu(), that's
one of the hotter paths around (and looking at it we ought to seriously
look at trimming some of it).

Which sort of leaves us in a predicament all-right...

/me goes puzzle.

