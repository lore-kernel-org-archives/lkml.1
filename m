Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbYA3SIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbYA3SIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYA3SIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:08:32 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:53491 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbYA3SIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:08:31 -0500
Date: Wed, 30 Jan 2008 20:08:27 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jan Beulich <jbeulich@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Add a list for custom page fault handlers.
Message-ID: <20080130200827.322c4f7d@daedalus.pq.iki.fi>
In-Reply-To: <1201660453.8837.13.camel@brick>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 18:34:13 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Sorry, attached the wrong version to my last message missing the
> kdebug.h hunk.  This is still just a straight port to current x86.git.

Wow, thanks.

I have to say I already did this for myself, but I had to
change too many things to simply resubmit without testing. And it turned
out porting mmiotrace to x86/mm was a non-trivial task. I have not
been able to test yet even though I have been working on it every night.
Today I will see if things work for me, and hopefully also for someone else.
I might send new patches today or tomorrow, if all goes well.

btw. I have a bad feeling about global_flush_tlb() disappearing, it was used
in mmiotrace code, and I don't know what to use instead. The obvious
replacement for it is a static function elsewhere. Currently I am simply
hoping it was a redundant leftover from the time when we had trouble making
mmiotrace stable.

To be honest, I haven't yet had the time to educate myself about what is
TLB.

> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index e28cc52..c6c8164 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -49,6 +49,54 @@
>  #define PF_RSVD		(1<<3)
>  #define PF_INSTR	(1<<4)
>  
> +#ifdef CONFIG_PAGE_FAULT_HANDLERS
> +static HLIST_HEAD(pf_handlers); /* protected by RCU */
> +static DEFINE_SPINLOCK(pf_handlers_writer);
> +
> +void register_page_fault_handler(struct pf_handler *new_pfh)
> +{
> +	spin_lock(&pf_handlers_writer);
> +	hlist_add_head_rcu(&new_pfh->hlist, &pf_handlers);
> +	spin_unlock(&pf_handlers_writer);

Here I had to change to irqsave/irqrestore versions, as I found a possible
lock dependency issue. Lockdep debugging code pointed it out. I'm not sure
I fixed it completely, but using spin_lock_irqsave() is a safe bet.

> +}
> +EXPORT_SYMBOL_GPL(register_page_fault_handler);
> +
> +void unregister_page_fault_handler(struct pf_handler *old_pfh)
> +{
> +	might_sleep();
> +	spin_lock(&pf_handlers_writer);
> +	hlist_del_rcu(&old_pfh->hlist);
> +	spin_unlock(&pf_handlers_writer);
> +	synchronize_rcu();
> +}

And here. And I also removed sync RCU and might_sleep().

> +EXPORT_SYMBOL_GPL(unregister_page_fault_handler);
> +#endif
> +
> +/* returns non-zero if do_page_fault() should return */
> +static int handle_custom_pf(struct pt_regs *regs, unsigned long error_code,
> +			    unsigned long address)
> +{
> +#ifdef CONFIG_PAGE_FAULT_HANDLERS
> +	int ret = 0;
> +	struct pf_handler *cur;
> +	struct hlist_node *ncur;
> +
> +	if (hlist_empty(&pf_handlers))
> +		return 0;

This looks prettier than my code. I might change my code to this.

> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(cur, ncur, &pf_handlers, hlist) {
> +		ret = cur->handler(regs, error_code, address);
> +		if (ret)
> +			break;
> +	}
> +	rcu_read_unlock();
> +	return ret;
> +#else
> +	return 0;
> +#endif
> +}
> +
>  static inline int notify_page_fault(struct pt_regs *regs)
>  {
>  #ifdef CONFIG_KPROBES
> @@ -588,6 +636,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	if (notify_page_fault(regs))
>  		return;
>  
> +	if (handle_custom_pf(regs, error_code, address))
> +		return;
> +

This is the non-trivial change that I really want to test before
submitting again. The call site of the handlers changes, and vmalloc
related faults reach the custom handlers. I don't think this would be a
problem for mmiotrace, but I don't know enough to be sure.
I guess using vmalloc'd memory from a page fault handler would be doomed,
anyway, so no point worrying about it, right?

if (unlikely(handle_custom_pf(regs, error_code, address)))
Maybe like this, even?

It is still supposedly making a function call every time, at least
when CONFIG_PAGE_FAULT_HANDLERS is defined. Would it have a non-negligible
impact on performance when no custom handlers are registered?

My original version had the separate inline function to check if the list
is empty. Which one is preferrable?

I'm hoping distros would ship some kernels with PAGE_FAULT_HANDLERS
enabled as it would make contributors' lives easier. IIRC some
already have enabled RELAY and DEBUG_FS for mmiotrace. This is why I
think keeping the performance impact to the minimum here is important,
for the case of no custom handlers registered.


Thanks,

-- 
Pekka Paalanen
http://www.iki.fi/pq/
