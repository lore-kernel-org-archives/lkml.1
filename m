Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYKUSly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYKUSly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYKUSlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:41:45 -0500
Received: from styx.suse.cz ([82.119.242.94]:59274 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751026AbYKUSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:41:44 -0500
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
Date: Fri, 21 Nov 2008 19:42:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Frank Mayhar <fmayhar@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1224694989.8431.23.camel@oberon> <1226015568.2186.20.camel@bobble.smo.corp.google.com> <1226053744.7803.5851.camel@twins>
In-Reply-To: <1226053744.7803.5851.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211942.43848.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Friday 07 of November 2008 11:29:04 Peter Zijlstra napsal(a):
> (fwiw your email doesn't come across properly, evo refuses to display
> them, there's some mangling of headers which makes it think there's an
> attachment)
>
> On Thu, 2008-11-06 at 15:52 -0800, Frank Mayhar wrote:
> > On Thu, 2008-11-06 at 16:08 +0100, Peter Zijlstra wrote:
> > > On Thu, 2008-11-06 at 09:03 -0600, Christoph Lameter wrote:
> > > > On Thu, 6 Nov 2008, Peter Zijlstra wrote:
> > > > > Also, you just introduced per-cpu allocations for each
> > > > > thread-group, while Christoph is reworking the per-cpu allocator,
> > > > > with one unfortunate side-effect - its going to have a limited size
> > > > > pool. Therefore this will limit the number of thread-groups we can
> > > > > have.
> > > >
> > > > Patches exist that implement a dynamically growable percpu pool
> > > > (using virtual mappings though). If the cost of the additional
> > > > complexity / overhead is justifiable then we can make the percpu pool
> > > > dynamically extendable.
> > >
> > > Right, but I don't think the patch under consideration will fly anyway,
> > > doing a for_each_possible_cpu() loop on every tick on all cpus isn't
> > > really healthy, even for moderate sized machines.
> >
> > I personally think that you're overstating this.  First, the current
> > implementation walks all threads for each tick, which is simply not
> > scalable and results in soft lockups with large numbers of threads.
> > This patch fixes a real bug.  Second, this only happens "on every tick"
> > for processes that have more than one thread _and_ that use posix
> > interval timers.  Roland and I went to some effort to keep loops like
> > the on you're referring to out of the common paths.
> >
> > In any event, while this particular implementation may not be optimal,
> > at least it's _right_.  Whatever happened to "make it right, then make
> > it fast?"
>
> Well, I'm not thinking you did it right ;-)
>
> While I agree that the linear loop is sub-optimal, but it only really
> becomes a problem when you have hundreds or thousands of threads in your
> application, which I'll argue to be insane anyway.

This is just not true. I've seen a very real example of a lockup with a very 
sane number of threads (one per CPU), but on a very large machine (1024 CPUs 
IIRC). The application set per-process CPU profiling with an interval of 1 
tick, which translates to 1024 timers firing off with each tick...

Well, yes, that was broken, too, but that's the way one quite popular FORTRAN 
compiler works...

Petr
