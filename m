Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZCBWYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZCBWYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZCBWYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:24:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43825 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbZCBWYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:24:04 -0500
Date: Mon, 2 Mar 2009 23:22:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
Message-ID: <20090302222254.GA31962@elte.hu>
References: <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AC5A87.7000604@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Mathieu Desnoyers wrote:
>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>> Index: linux-2.6/init/main.c
>>> ===================================================================
>>> --- linux-2.6.orig/init/main.c
>>> +++ linux-2.6/init/main.c
>>> @@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
>>>  	taskstats_init_early();
>>>  	delayacct_init();
>>>
>>> +#ifdef CONFIG_X86
>>> +	text_poke_init();
>>> +#endif
>>
>> All good, except this above. There should be an empty text_poke_init()
>> in some header file, and an implementation for the X86 arch rather than
>> a ifdef in init/main.c.
>
> Hmm, I'd rather use __weak function instead of defining it in some header
> files, because text_poke() and alternatives exist only on x86.
>
> I know that we need to discuss cross modifying code on x86 with
> Arjan or other Intel engineers. This patch may still be useful
> for removing unnecessary vm_area allocation in text_poke().
>
> Thank you,
>
> ---
>
> Use map_vm_area() instead of vmap() in text_poke() for 
> avoiding page allocation and delayed unmapping, and call 
> vunmap_page_range() and local_flush_tlb() directly because 
> this mapping is temporary and local.
>
> At the result of above change, text_poke() becomes atomic and 
> can be called from stop_machine() etc.

That looks like a good fix in itself - see a few minor details 
below.

(Note, i could not try your patch because it has widespread 
whitespace damage - please watch out for this for future 
patches.)

> +static struct vm_struct *text_poke_area[2];
> +static DEFINE_SPINLOCK(text_poke_lock);
> +
> +void __init text_poke_init(void)
> +{
> +	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
> +	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);
> +	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);

BUG_ON() for non-100%-essential init code is a no-no. Please 
change it to WARN_ON() so that people have a chance to report i.

Also, i think all these vma complications came from the decision 
to use vmap - and vmap enhancements in .29 complicated this 
supposedly-simple interface.

So perhaps another approach to (re-)consider would be to go back 
to atomic fixmaps here. It spends 3 slots but that's no big 
deal.

In exchange it will be conceptually simpler, and will also scale 
much better than a global spinlock. What do you think?

	Ingo
