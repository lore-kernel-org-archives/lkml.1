Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYBISkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYBISkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYBISj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:39:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbYBISjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:39:49 -0500
Subject: Re: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
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
	 <20080207125327.GB27234@elte.hu> <20080207125622.GA7111@infradead.org>
	 <20080209195255.584d4157@daedalus.pq.iki.fi>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 19:39:30 +0100
Message-Id: <1202582370.16505.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-09 at 19:52 +0200, Pekka Paalanen wrote:

> +int mmiotrace_register_pf(pf_handler_func new_pfh)
>  {
> +	int ret = 0;
>  	unsigned long flags;

> +	spin_lock_irqsave(&mmiotrace_handler_lock, flags);
> +	if (mmiotrace_pf_handler)
> +		ret = -EBUSY;
> +	else
> +		mmiotrace_pf_handler = new_pfh;
> +	spin_unlock_irqrestore(&mmiotrace_handler_lock, flags);
> +	return ret;
>  }
> +EXPORT_SYMBOL_GPL(mmiotrace_register_pf);
>  
>  /**
> + * mmiotrace_unregister_pf:
>   * The caller must ensure @old_pfh is not in use anymore before freeing it.
> + * This function does not guarantee it. The handler function pointer is
> + * protected by RCU, so you can do this by e.g. calling synchronize_rcu().
>   */
> +int mmiotrace_unregister_pf(pf_handler_func old_pfh)
>  {
> +	int ret = 0;
>  	unsigned long flags;

> +	spin_lock_irqsave(&mmiotrace_handler_lock, flags);
> +	if (mmiotrace_pf_handler != old_pfh)
> +		ret = -EPERM;
> +	else
> +		mmiotrace_pf_handler = NULL;
> +	spin_unlock_irqrestore(&mmiotrace_handler_lock, flags);
> +	return ret;
>  }

So here you set/unset mmiotrace_pf_handler under protection of a
spinlock.

 
>  /* returns non-zero if do_page_fault() should return */
> +static inline int call_mmiotrace(struct pt_regs *regs,
> +					unsigned long error_code,
> +					unsigned long address)
>  {
> +#ifdef CONFIG_MMIOTRACE_HOOKS
>  	int ret = 0;
>  	rcu_read_lock();
> +	if (mmiotrace_pf_handler)
> +		ret = mmiotrace_pf_handler(regs, error_code, address);
>  	rcu_read_unlock();
>  	return ret;
>  #else

But here you use it under rcu_read_lock(). This doesn't match.



