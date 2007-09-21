Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbXIUNCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbXIUNCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbXIUNCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:02:34 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33483 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbXIUNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:02:33 -0400
Date: Fri, 21 Sep 2007 09:01:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Add CRC checksum for RCU lists
In-Reply-To: <20070921140221.000a416a@twins>
Message-ID: <Pine.LNX.4.58.0709210824220.23295@gandalf.stny.rr.com>
References: <1190313251.4518.14.camel@localhost.localdomain>
 <20070921140221.000a416a@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Fri, 21 Sep 2007, Peter Zijlstra wrote:

> On Thu, 20 Sep 2007 14:34:11 -0400 Steven Rostedt <rostedt@goodmis.org>
> wrote:
>
>
> > +static inline void rcu_crc_check(struct rcu_head *head)
> > +{
> > +	static int once;
> > +	if (unlikely(head->crc != rcu_crc_calc(head)) && !once) {
> > +		once++;
> > +		printk("BUG: RCU check failed!");
> > +		if (head->caller)
> > +			printk(" (caller=%p)",
> > +			       head->caller);
>
> 		char sym[KSYM_SYMBOL_LEN];
> 		sprint_symbol(sym, head->caller);
> 		printk(" (caller: [<%p>] %s)", head->caller, sym);
>

Yes, good point!

Although I may do it this way:

              printk(" (caller: [<%p>]", head->caller);
              print_symbol(" %s)\n", (unsigned long)head->caller);

and eliminate the temp variable.

-- Steve

> > +		printk("\n");
> > +		printk("  CRC was %08lx, expected %08lx\n",
> > +		       head->crc, rcu_crc_calc(head));
> > +		printk("  %p %p\n",
> > +		       head->next, head->func);
> > +		dump_stack();
> > +	}
> > +}
>
>
