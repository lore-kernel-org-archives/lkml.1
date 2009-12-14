Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZLNOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZLNOQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbZLNOQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:16:09 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40259 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbZLNOQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:16:07 -0500
Date: Mon, 14 Dec 2009 06:16:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
	assumptions
Message-ID: <20091214141607.GD7710@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091210001308.247025548@linutronix.de> <20091210022825.GG6938@linux.vnet.ibm.com> <alpine.LFD.2.00.0912091914540.3560@localhost.localdomain> <1260422031.4165.1.camel@twins> <20091210053457.GB6720@linux.vnet.ibm.com> <1260730577.4165.7.camel@twins> <20091214015347.GB7710@linux.vnet.ibm.com> <1260785859.4165.136.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260785859.4165.136.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 11:17:39AM +0100, Peter Zijlstra wrote:
> On Sun, 2009-12-13 at 17:53 -0800, Paul E. McKenney wrote:
> > On Sun, Dec 13, 2009 at 07:56:17PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2009-12-09 at 21:34 -0800, Paul E. McKenney wrote:
> > > 
> > > > Ah -- I have a related lockdep question.  Is there a primitive that says
> > > > whether or not the current task holds at least one lock of any type?
> > > > If so, I would like to make rcu_dereference() do at least a little crude
> > > > checking for this problem.
> > > 
> > > Hmm, no, but that's not hard to do, however I actually implemented
> > > something like that for RCU a long while ago and that gives a metric TON
> > > of false positives due to things like the radix tree which are RCU-safe
> > > but are not required to be used with RCU.
> > 
> > Understood -- my current guess is that there needs to be a way to tag
> > a variant of the rcu_dereference() API with the conditions that must be
> > met, for example, either in an rcu-sched read-side critical section or
> > holding a specific type of lock.
> > 
> > This does make it a little harder to retroactively add checking to
> > existing calls to rcu_dereference(), but should allow a good balance
> > between false positives and false negatives going forward.
> > 
> > Seem reasonable, or am I still missing something?
> 
> The only concern is drowning in rcu_dereference() annotations. But I
> guess that is unavoidable.

So far, I haven't been able to think of anything better.  :-/

> I think you can use lock_is_held(&rcu_lock_map), except you need to deal
> with the !debug_locks case, because lockdep stops once debug_locks
> becomes false, which means lock_is_held() will return rubbish.

OK, so I need to do something like the following, then?

	debug_locks ? lock_is_held(&rcu_lock_map) : 1

							Thanx, Paul
