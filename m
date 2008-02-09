Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYBISko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYBISko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbYBISkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:40:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbYBISkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:40:02 -0500
Subject: Re: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080209100133.60406c00@laptopd505.fenrus.org>
References: <1201660453.8837.13.camel@brick>
	 <20080130200827.322c4f7d@daedalus.pq.iki.fi>
	 <20080131150746.GB11996@elte.hu>
	 <20080131180253.6c007852@daedalus.pq.iki.fi>
	 <20080131081507.5edcde10@laptopd505.fenrus.org>
	 <20080203085522.2b63e15b@daedalus.pq.iki.fi>
	 <20080203070321.GA8293@elte.hu>
	 <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	 <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
	 <20080207125327.GB27234@elte.hu> <20080207125622.GA7111@infradead.org>
	 <20080209195255.584d4157@daedalus.pq.iki.fi>
	 <20080209100133.60406c00@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 19:39:47 +0100
Message-Id: <1202582388.16505.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-09 at 10:01 -0800, Arjan van de Ven wrote:
> >  	default n
> >  	help
> >  	  This will build a kernel module called mmiotrace.
> > +	  Making this a built-in is heavily discouraged.
> 
> why is this? Wouldn't it be nice if distros just shipped with this in their kernel by default
> for example?

so default m?

> > -#ifdef CONFIG_PAGE_FAULT_HANDLERS
> > -static HLIST_HEAD(pf_handlers); /* protected by RCU */
> > -static DEFINE_SPINLOCK(pf_handlers_writer);
> > +#ifdef CONFIG_MMIOTRACE_HOOKS
> > +static pf_handler_func mmiotrace_pf_handler; /* protected by RCU */
> > +static DEFINE_SPINLOCK(mmiotrace_handler_lock);
> >  
> > -void register_page_fault_handler(struct pf_handler *new_pfh)
> > +int mmiotrace_register_pf(pf_handler_func new_pfh)
> >  {
> > +	int ret = 0;
> >  	unsigned long flags;
> > -	spin_lock_irqsave(&pf_handlers_writer, flags);
> > -	hlist_add_head_rcu(&new_pfh->hlist, &pf_handlers);
> > -	spin_unlock_irqrestore(&pf_handlers_writer, flags);
> > +	spin_lock_irqsave(&mmiotrace_handler_lock, flags);
> > +	if (mmiotrace_pf_handler)
> > +		ret = -EBUSY;
> > +	else
> > +		mmiotrace_pf_handler = new_pfh;
> > +	spin_unlock_irqrestore(&mmiotrace_handler_lock, flags);
> > +	return ret;
> >  }
> > -EXPORT_SYMBOL_GPL(register_page_fault_handler);
> > +EXPORT_SYMBOL_GPL(mmiotrace_register_pf);
> 
> why not use a weak function instead? should be a ton simpler.

AFAIC weak functions are a built time thing, not fixed up on module
load. So I'm not seeing the applicability there.

Also, it would force a function call, even for the unlikely case the
tracer is set.



