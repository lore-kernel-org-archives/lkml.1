Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbYA3NIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbYA3NIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYA3NIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:08:31 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:60916 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYA3NIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:08:30 -0500
Date: Wed, 30 Jan 2008 08:08:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler instrumentation
In-Reply-To: <1201682801.28547.162.camel@lappy>
Message-ID: <Pine.LNX.4.58.0801300806100.29020@gandalf.stny.rr.com>
References: <20080130031521.258552785@goodmis.org>  <20080130031840.337019504@goodmis.org>
 <1201682801.28547.162.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jan 2008, Peter Zijlstra wrote:

>
> On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:
>
> > +int register_mcount_function(struct mcount_ops *ops)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&mcount_func_lock, flags);
> > +	ops->next = mcount_list;
> > +	/* must have next seen before we update the list pointer */
> > +	smp_wmb();
>
> That comment does not explain which race it closes; this is esp
> important as there is no paired barrier to give hints.

OK, fair enough. I'll explain it a bit more.

How's this:

 /*
  * We are entering ops into the mcount_list but another
  * CPU might be walking that list. We need to make sure
  * the ops->next pointer is valid before another CPU sees
  * the ops pointer included into the mcount_list.
  */

-- Steve

>
> > +	mcount_list = ops;
> > +	/*
> > +	 * For one func, simply call it directly.
> > +	 * For more than one func, call the chain.
> > +	 */
> > +	if (ops->next == &mcount_list_end)
> > +		mcount_trace_function = ops->func;
> > +	else
> > +		mcount_trace_function = mcount_list_func;
> > +	spin_unlock_irqrestore(&mcount_func_lock, flags);
> > +
> > +	return 0;
> > +}
>
>
>
