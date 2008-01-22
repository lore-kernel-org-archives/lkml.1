Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbYAVAts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbYAVAts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 19:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYAVAtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 19:49:39 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:44857 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbYAVAti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 19:49:38 -0500
Date: Mon, 21 Jan 2008 19:49:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       John Stultz <johstul@us.ibm.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 12/23 -v4] Use RCU algorithm for monotonic cycles.
In-Reply-To: <200801221120.59792.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.58.0801211946370.21442@gandalf.stny.rr.com>
References: <20080121152231.579118762@goodmis.org> <20080121152352.789802471@goodmis.org>
 <200801221120.59792.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Jan 2008, Nick Piggin wrote:

> On Tuesday 22 January 2008 02:22, Steven Rostedt wrote:
> > From: john stultz <johnstul@us.ibm.com>
>
> >  static inline cycle_t
> > -clocksource_get_cycles(struct clocksource *cs, cycle_t now)
> > +clocksource_get_basecycles(struct clocksource *cs)
> >  {
> > -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> > -	offset += cs->cycle_accumulated;
> > +	int num;
> > +	cycle_t now, offset;
> > +
> > +	preempt_disable();
> > +	num = cs->base_num;
> > +	smp_read_barrier_depends();
>
> All barriers need comments in the code. eg. with read barriers, the
> comment should contain a list of the loads being ordered, and a
> reference to the places where stores come from.
>
> I know it isn't too hard to follow _now_, but it makes the code more
> maintainable.

Yep, thanks for the reminder. This was a quick patch from John. I'll add
the necessary comment for the next release. Hmm, I'm surprised that
checkpatch didn't complain.

>
>
> > +	now = clocksource_read(cs);
> > +	offset = (now - cs->base[num].cycle_base_last);
> > +	offset &= cs->mask;
> > +	offset += cs->base[num].cycle_base;
> > +	preempt_enable();
> > +
> >  	return offset;
> >  }
> >
> > @@ -197,14 +215,26 @@ clocksource_get_cycles(struct clocksourc
> >   * @now:	current cycle value
> >   *
> >   * Used to avoids clocksource hardware overflow by periodically
> > - * accumulating the current cycle delta. Must hold xtime write lock!
> > + * accumulating the current cycle delta. Uses RCU-like update, but
> > + * ***still requires the xtime_lock is held for writing!***
> >   */
> >  static inline void clocksource_accumulate(struct clocksource *cs, cycle_t
> > now) {
> > -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> > +	/* First update the monotonic base portion.
> > +	 * The dual array update method allows for lock-free reading.
> > +	 */
> > +	int num = 1 - cs->base_num;
> > +	cycle_t offset = (now - cs->base[1-num].cycle_base_last);
> > +	offset &= cs->mask;
> > +	cs->base[num].cycle_base = cs->base[1-num].cycle_base + offset;
> > +	cs->base[num].cycle_base_last = now;
> > +	wmb();
> > +	cs->base_num = num;
>
> Ditto for the wmb. Also, I think the wmb() can probably just be
> smp_wmb().

Yep, this too. We suggested earlier to John to switch this to a
smp_wmb, but I took his patch before the update. This will be fixed in the
next round too.

Thanks,

-- Steve

