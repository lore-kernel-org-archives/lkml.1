Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbZBTRa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbZBTRa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZBTRat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:30:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49680 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbZBTRas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:30:48 -0500
Date: Fri, 20 Feb 2009 18:30:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090220173035.GI24538@elte.hu>
References: <20090220163846.709775139@goodmis.org> <20090220164045.827841413@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220164045.827841413@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index b55b4a7..5564cf3 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -80,4 +80,14 @@ extern void return_to_handler(void);
>  #endif /* __ASSEMBLY__ */
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
> +#ifndef __ASSEMBLY__
> +#ifdef CONFIG_DEBUG_RODATA
> +void set_kernel_text_rw(void);
> +void set_kernel_text_ro(void);
> +#else
> +static inline void set_kernel_text_rw(void) { }
> +static inline void set_kernel_text_ro(void) { }
> +#endif
> +#endif /* __ASSEMBLY__ */

The proper place for this is where the other pagetable attribute 
functions reside: arch/x86/include/asm/cacheflush.h.

> +/* used by ftrace */
> +void set_kernel_text_rw(void)
> +{
> +	unsigned long start = PFN_ALIGN(_text);
> +	unsigned long size = PFN_ALIGN(_etext) - start;
> +
> +	printk(KERN_INFO "Set kernel text: %lx - %lx for read write\n",
> +	       start, start+size);
> +
> +	set_pages_rw(virt_to_page(start), size >> PAGE_SHIFT);

Wont this be executed by every suspend/resume cycle? I'm not 
sure we want a KERN_INFO printout every time.

> +/* used by ftrace */
> +void set_kernel_text_rw(void)

i'd leave out the 'used by ftrace' bit - more uses might arise. 
How does kprobes get around readonly pages, it uses these APIs 
too, right?

	Ingo
