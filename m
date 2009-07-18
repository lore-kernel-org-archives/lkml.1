Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbZGRLUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbZGRLUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbZGRLUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:20:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175AbZGRLUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:20:45 -0400
Date: Sat, 18 Jul 2009 13:19:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
Message-ID: <20090718111948.GD27287@elte.hu>
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com> <1247521235.7178.1.camel@johannes.local> <4A5BAABF.9020708@gmail.com> <1247521789.7178.2.camel@johannes.local> <4A5BAC77.9010503@gmail.com> <1247522068.7178.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247522068.7178.4.camel@johannes.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2009-07-13 at 23:51 +0200, Jiri Slaby wrote:
> > On 07/13/2009 11:49 PM, Johannes Berg wrote:
> > > On Mon, 2009-07-13 at 23:44 +0200, Jiri Slaby wrote:
> > > 
> > >>> I've had local hacks
> > >>> many times to make sparse aware of mutexes, is there a reason they are
> > >>> not annotated with __acquire(s)/__release(s) like spinlocks etc.?
> > >>
> > >> Mutexes are often locked/unlocked interprocedural which I think sparse
> > >> can't do much about.
> > > 
> > > Well, you annotate those functions too, of course.
> > 
> > Sorry, I don't understand. What functions I annotate?
> 
> Well those that take the mutex, e.g.
> 
> void acquire_foo(struct foo *f)
> {
> 	mutex_lock(&f->mtx);
> }
> 
> 
> turns to
> 
> void acquire_foo(struct foo *f)
> 	__acquires(f->mtx)
> {
> 	mutex_lock(&f->mtx);
> }
> 
> johannes

Yes. And in fact 'nice' code wants to be either annotated explicitly 
as 'I am taking locks', or should be balanced.

I was thinking about also using lockdep plus the function-graph 
tracer for that (in the dynamic lock debugging department).

It would work like this: __acquires()/__releases() would also emit 
section markers like __lockfunc, and lockdep would warn about 
functions that return with unbalanced locks, irqs or preempt counts 
and do not declare themselves as locking related functions.

This would help catch imbalances at their source.

Plus static tools like Jiri is working on are very useful as well. I 
think Coverty does that too and it's a pity we dont have free tools 
for that. In fact Covery will sweep clean the kernel of such bugs, 
giving OSS tools like 'stanse' the false impression that there are 
no such bugs. There are such bugs - there's a constant influx of 
them. So please work on this, it looks very useful.

	Ingo
