Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYA3IsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYA3IsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYA3IsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:48:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39359 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYA3IsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:48:08 -0500
Subject: Re: [PATCH 02/22 -v7] Add basic support for gcc profiler
	instrumentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20080130031840.337019504@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
	 <20080130031840.337019504@goodmis.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 09:46:41 +0100
Message-Id: <1201682801.28547.162.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:

> +int register_mcount_function(struct mcount_ops *ops)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&mcount_func_lock, flags);
> +	ops->next = mcount_list;
> +	/* must have next seen before we update the list pointer */
> +	smp_wmb();

That comment does not explain which race it closes; this is esp
important as there is no paired barrier to give hints.

> +	mcount_list = ops;
> +	/*
> +	 * For one func, simply call it directly.
> +	 * For more than one func, call the chain.
> +	 */
> +	if (ops->next == &mcount_list_end)
> +		mcount_trace_function = ops->func;
> +	else
> +		mcount_trace_function = mcount_list_func;
> +	spin_unlock_irqrestore(&mcount_func_lock, flags);
> +
> +	return 0;
> +}


