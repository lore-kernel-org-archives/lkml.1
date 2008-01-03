Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYACSe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYACSe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYACSeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:34:50 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:34158 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbYACSet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:34:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJm5fEdMROHU/2dsb2JhbACBV6hv
Date: Thu, 3 Jan 2008 13:34:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 03/11] Annotate core code that should not be traced
Message-ID: <20080103183446.GA2030@Krystal>
References: <20080103071609.478486470@goodmis.org> <20080103072227.087067007@goodmis.org> <20080103174250.GC30582@Krystal> <Pine.LNX.4.58.0801031256240.4826@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801031256240.4826@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:23:44 up 60 days, 23:29,  5 users,  load average: 1.12, 0.71,
	0.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
 ....
> >
> > >  {
> > >  	struct irq_desc *desc = irq_desc + irq;
> > >  	struct irqaction *action;
> > > Index: linux-compile.git/kernel/lockdep.c
> > > ===================================================================
> > > --- linux-compile.git.orig/kernel/lockdep.c	2007-12-20 01:00:29.000000000 -0500
> > > +++ linux-compile.git/kernel/lockdep.c	2007-12-20 01:00:48.000000000 -0500
> > > @@ -270,14 +270,14 @@ static struct list_head chainhash_table[
> > >  	((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
> > >  	(key2))
> > >
> > > -void lockdep_off(void)
> > > +notrace void lockdep_off(void)
> > >  {
> > >  	current->lockdep_recursion++;
> > >  }
> > >
> >
> > Due to interrupt disabling in your tracing code I suppose.
> 
> probably. Again, this came from the RT patch. And this stuff has been in
> the patch for ages. So some of it was just plain paranoia. Others were
> needed for some kind of tracing.
> 
> BTW, I'm curious? How do you handle NMIs and tracing. Do you use a
> separate buffer for storing your data on NMIs or do you have some kind of
> cmpxchg that can atomically reserve parts of the trace buffer?
> 

Because I want to deal with weird cases like :

kernel calling tracing code, causing a user-space page fault, which
calls the tracer, which could be interrupted by an NMI, it would become
tricky to find out how many contexts could be stacked in the worse case
for each architecture. Therefore, using a cmpxchg-based algorithm is the
solution I used. However, in order to make this fast, I extented the
"local atomic operations" to offer a local_cmpxchg.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
