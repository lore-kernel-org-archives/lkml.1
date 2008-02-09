Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbYBISBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbYBISBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYBISBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:01:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55654 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYBISBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:01:46 -0500
Date: Sat, 9 Feb 2008 10:01:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, pq@iki.fi
Subject: Re: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
Message-ID: <20080209100133.60406c00@laptopd505.fenrus.org>
In-Reply-To: <20080209195255.584d4157@daedalus.pq.iki.fi>
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
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	default n
>  	help
>  	  This will build a kernel module called mmiotrace.
> +	  Making this a built-in is heavily discouraged.

why is this? Wouldn't it be nice if distros just shipped with this in their kernel by default
for example?

> -#ifdef CONFIG_PAGE_FAULT_HANDLERS
> -static HLIST_HEAD(pf_handlers); /* protected by RCU */
> -static DEFINE_SPINLOCK(pf_handlers_writer);
> +#ifdef CONFIG_MMIOTRACE_HOOKS
> +static pf_handler_func mmiotrace_pf_handler; /* protected by RCU */
> +static DEFINE_SPINLOCK(mmiotrace_handler_lock);
>  
> -void register_page_fault_handler(struct pf_handler *new_pfh)
> +int mmiotrace_register_pf(pf_handler_func new_pfh)
>  {
> +	int ret = 0;
>  	unsigned long flags;
> -	spin_lock_irqsave(&pf_handlers_writer, flags);
> -	hlist_add_head_rcu(&new_pfh->hlist, &pf_handlers);
> -	spin_unlock_irqrestore(&pf_handlers_writer, flags);
> +	spin_lock_irqsave(&mmiotrace_handler_lock, flags);
> +	if (mmiotrace_pf_handler)
> +		ret = -EBUSY;
> +	else
> +		mmiotrace_pf_handler = new_pfh;
> +	spin_unlock_irqrestore(&mmiotrace_handler_lock, flags);
> +	return ret;
>  }
> -EXPORT_SYMBOL_GPL(register_page_fault_handler);
> +EXPORT_SYMBOL_GPL(mmiotrace_register_pf);

why not use a weak function instead? should be a ton simpler.
