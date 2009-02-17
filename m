Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZBQWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZBQWNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZBQWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:13:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZBQWNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:13:09 -0500
Date: Tue, 17 Feb 2009 23:09:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4] generic-ipi: remove kmalloc()
Message-ID: <20090217220925.GB13189@redhat.com>
References: <20090216163847.431174825@chello.nl> <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop> <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop> <1234898958.4744.225.camel@laptop> <20090217200247.GA8158@redhat.com> <1234901512.4744.230.camel@laptop> <1234901777.4744.233.camel@laptop> <1234903781.4744.235.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234903781.4744.235.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Peter Zijlstra wrote:
>
> On Tue, 2009-02-17 at 21:16 +0100, Peter Zijlstra wrote:
> > On Tue, 2009-02-17 at 21:11 +0100, Peter Zijlstra wrote:
> > >
> > > > As for the previous version. I am almost sure I missed something
> > > > again, but do we really need both CSD_FLAG_WAIT and CSD_FLAG_LOCK
> > > > flags? smp_call_function_many(wait => 1) can just wait for
> > > > !CSD_FLAG_LOCK.
> > >
> > > I suppose we can.
> >
> > Ah, no, that would mean we cannot distinguish between the sync and async
> > case in generic_exec_single().
>
> Which can of course be solved like so, we could even drop the new .wait
> argument to __smp_call_function_single() as CSD_FLAG_WAIT wasn't exposed
> before and non of the current users use it.

Yes, I think this should work.

Or, if you prefer to stay with with 2 flags for now, then perhaps it makes
sense to at least clear both flags in xxx_interrupt() at once.

I guess you should re-send your previous patch in any case,

		} else if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
	-               struct call_single_data *data;
	+               struct call_single_data *data = {
	+                       .flags = 0,
	+               };

this looks a bit suspicious ;)

Oleg.

