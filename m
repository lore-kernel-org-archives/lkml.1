Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0CCAs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:48:26 -0500
Received: from mail.openrapids.net ([64.15.138.104]:44078 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755254Ab0CCAsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:48:20 -0500
Date: Tue, 2 Mar 2010 19:48:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip v3&10 07/18] x86: Add text_poke_smp for SMP cross
	modifying code
Message-ID: <20100303004814.GA15029@Krystal>
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6> <20100225133438.6725.80273.stgit@localhost6.localdomain6> <20100225153305.GC12635@Krystal> <4B8745AC.2070702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8745AC.2070702@redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:36:36 up 39 days,  3:14,  4 users,  load average: 1.12, 1.73,
	1.78
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> > * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> [...]
> >> +
> >> +/*
> >> + * Cross-modifying kernel text with stop_machine().
> >> + * This code originally comes from immediate value.
> >> + */
> >> +static atomic_t stop_machine_first;
> >> +static int wrote_text;
> >> +
> >> +struct text_poke_params {
> >> +	void *addr;
> >> +	const void *opcode;
> >> +	size_t len;
> >> +};
> >> +
> >> +static int __kprobes stop_machine_text_poke(void *data)
> >> +{
> >> +	struct text_poke_params *tpp = data;
> >> +
> >> +	if (atomic_dec_and_test(&stop_machine_first)) {
> >> +		text_poke(tpp->addr, tpp->opcode, tpp->len);
> >> +		smp_wmb();	/* Make sure other cpus see that this has run */
> >> +		wrote_text = 1;
> >> +	} else {
> >> +		while (!wrote_text)
> >> +			smp_rmb();
> >> +		sync_core();
> >
> > Hrm, there is a problem in there. The last loop, when wrote_text becomes
> > true, does not perform any smp_mb(), so you end up in a situation where
> > cpus in the "else" branch may never issue any memory barrier. I'd rather
> > do:
> 
> Hmm, so how about this? :)
> ---
> } else {
> 	do {
> 		smp_rmb();
> 	while (!wrote_text);
> 	sync_core();
> }
> ---
> 

The ordering we are looking for here are:

Write-side: smp_wmb() orders text_poke stores before store to wrote_text.

Read-side: order wrote_text load before subsequent execution of modified
           instructions.

Here again, strictly speaking, wrote_text load is not ordered with respect to
following instructions. So maybe it's fine on x86-TSO specifically, but I would
not count on this kind of synchronization to work in the general case.

Given the very small expected performance impact of this code path, I would
recomment using the more solid/generic alternative below. If there is really a
gain to get by creating this weird wait loop with strange memory barrier
semantics, fine, otherwise I'd be reluctant to accept your proposals as
obviously correct.

If you really, really want to go down the route of proving the correctness of
your memory barrier usage, I can recommend looking at the memory barrier formal
verification framework I did as part of my thesis. But, really, in this case,
the performance gain is just not there, so there is no point in spending time
trying to prove this.

Thanks,

Mathieu

> >
> > +static volatile int wrote_text;
> >
> > ...
> >
> > +static int __kprobes stop_machine_text_poke(void *data)
> > +{
> > +	struct text_poke_params *tpp = data;
> > +
> > +	if (atomic_dec_and_test(&stop_machine_first)) {
> > +		text_poke(tpp->addr, tpp->opcode, tpp->len);
> > +		smp_wmb();	/* order text_poke stores before store to wrote_text */
> > +		wrote_text = 1;
> > +	} else {
> > +		while (!wrote_text)
> > +			cpu_relax();
> > +		smp_mb();	/* order wrote_text load before following execution */
> > +	}
> >
> > If you don't like the "volatile int" definition of wrote_text, then we
> > should probably use the ACCESS_ONCE() macro instead.
> 
> hm, yeah, volatile will be required.
> 
> Thank you,
> 
> 
> -- 
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
