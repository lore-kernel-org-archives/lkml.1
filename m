Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYBISYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYBISYN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYBISX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:23:59 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:41507 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbYBISX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:23:58 -0500
Date: Sat, 9 Feb 2008 20:23:53 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
Message-ID: <20080209202353.0e83e337@daedalus.pq.iki.fi>
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
	<20080207125327.GB27234@elte.hu>
	<20080207125622.GA7111@infradead.org>
	<20080209195255.584d4157@daedalus.pq.iki.fi>
	<20080209100133.60406c00@laptopd505.fenrus.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 10:01:33 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> >  	default n
> >  	help
> >  	  This will build a kernel module called mmiotrace.
> > +	  Making this a built-in is heavily discouraged.
> 
> why is this? Wouldn't it be nice if distros just shipped with this in their kernel by default
> for example?

It's currently not too nice as a built-in. Originally I did have it depend
on 'm' but maybe Ingo removed it? It's not depending on 'm' anymore in
x86/mm git tree Kconfig.

By default it reserves 32 MB/cpu of relay buffers during module init.
It's this big based on experimentation with the nvidia proprietary driver.
There is no other way than unloading the module to free the buffers, or
even to clear them. This means that every time you start the user space
logger application, it gets old data first. Also poking the module
parameters via /sys is not allowed.

So it's not actually broken as far as I know, it's just not nice IMHO.
And I've never tried it as built-in. I don't think anyone ever has.
I do have a plan to make it a nicer built-in, but it's a long way.

> > +#ifdef CONFIG_MMIOTRACE_HOOKS
> > +static pf_handler_func mmiotrace_pf_handler; /* protected by RCU */
> > +static DEFINE_SPINLOCK(mmiotrace_handler_lock);
> >  
> > +int mmiotrace_register_pf(pf_handler_func new_pfh)
> >  {
> > +	int ret = 0;
> >  	unsigned long flags;
> > +	spin_lock_irqsave(&mmiotrace_handler_lock, flags);
> > +	if (mmiotrace_pf_handler)
> > +		ret = -EBUSY;
> > +	else
> > +		mmiotrace_pf_handler = new_pfh;
> > +	spin_unlock_irqrestore(&mmiotrace_handler_lock, flags);
> > +	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(mmiotrace_register_pf);
> 
> why not use a weak function instead? should be a ton simpler.

Ookay, this is the first time I hear about weak functions, and
that I could accomplish something like this with them.
I'll be googling around. These are completely new beasts to me.

Thanks for the keywords, finally I have a clue to follow.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
