Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXAXXHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXAXXHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 18:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbXAXXHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 18:07:06 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:50741
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbXAXXHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 18:07:04 -0500
Date: Wed, 24 Jan 2007 15:06:57 -0800
To: Ingo Molnar <mingo@elte.hu>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@mvista.com>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lock stat for -rt 2.6.20-rc2-rt2.2.lock_stat.patch
Message-ID: <20070124230657.GA5362@gnuppy.monkey.org>
References: <9D2C22909C6E774EBFB8B5583AE5291C019998CA@fmsmsx414.amr.corp.intel.com> <20061229232618.GA11239@gnuppy.monkey.org> <20061230111940.GA8412@elte.hu> <20070103074124.GA25594@gnuppy.monkey.org> <20070104044659.GA3097@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070104044659.GA3097@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 04, 2007 at 05:46:59AM +0100, Ingo Molnar wrote:
> thanks. It's looking better, but there's still quite a bit of work left:
> 
> there's considerable amount of whitespace noise in it - lots of lines 
> with space/tab at the end, lines with 8 spaces instead of tabs, etc.

These comments from me are before the hand merge I'm going to do tonight.

> comment style issues:
> 
> +/* To be use for avoiding the dynamic attachment of spinlocks at runtime
> + * by attaching it inline with the lock initialization function */
> 
> the proper multi-line style is:
> 
> /*
>  * To be used for avoiding the dynamic attachment of spinlocks at 
>  * runtime by attaching it inline with the lock initialization function:
>  */

I fixed all of those I can find.

> (note i also fixed a typo in the one above)
> 
> more unused code:
> 
> +/*
> +static DEFINE_LS_ENTRY(__pte_alloc);
> +static DEFINE_LS_ENTRY(get_empty_filp);
> +static DEFINE_LS_ENTRY(init_waitqueue_head);
> ...
> +*/

Removed. They are for annotation which isn't important right now.

> +static int lock_stat_inited = 0;
> 
> should not be initialized to 0, that is implicit for static variables.

Removed.

> weird alignment here:
> 
> +void lock_stat_init(struct lock_stat *oref)
> +{
> +       oref->function[0]       = 0;
> +       oref->file      = NULL;
> +       oref->line      = 0;
> +
> +       oref->ntracked  = 0;

I reduced that all to a single space without using huge tabs.

> funky branching:
> 
> +       spin_lock_irqsave(&free_store_lock, flags);
> +       if (!list_empty(&lock_stat_free_store)) {
> +               struct list_head *e = lock_stat_free_store.next;
> +               struct lock_stat *s;
> +
> +               s = container_of(e, struct lock_stat, list_head);
> +               list_del(e);
> +
> +               spin_unlock_irqrestore(&free_store_lock, flags);
> +
> +               return s;
> +       }
> +       spin_unlock_irqrestore(&free_store_lock, flags);
> +
> +       return NULL;
> 
> that should be s = NULL in the function scope and a plain unlock and 
> return s.

I made this change.

> assignments mixed with arithmetics:
> 
> +static
> +int lock_stat_compare_objs(struct lock_stat *x, struct lock_stat *y)
> +{
> +       int a = 0, b = 0, c = 0;
> +
> +       (a = ksym_strcmp(x->function, y->function))     ||
> +       (b = ksym_strcmp(x->file, y->file))             ||
> +       (c = (x->line - y->line));
> +
> +       return a | b | c;
> 
> the usual (and more readable) style is to separate them out explicitly:
> 
> 	a = ksym_strcmp(x->function, y->function);
> 	if (!a)
> 		return 0;
> 	b = ksym_strcmp(x->file, y->file);
> 	if (!b)
> 		return 0;
> 
> 	return x->line == y->line;
> 
> (detail: this btw also fixes a bug in the function above AFAICS, in the 
> a && !b case.)

Not sure what you mean here but I made the key comparison so that it would
treat each struct field in most to least significant order evaluation. The
old code worked fine. What you're seeing is the newer stuff.

> also, i'm not fully convinced we want that x->function as a string. That 
> makes comparisons alot slower. Why not make it a void *, and resolve to 
> the name via kallsyms only when printing it in /proc, like lockdep does 
> it?

I've made your suggested change, but I'm not done with it.

> 
> no need to put dates into comments:
> 
> +        * Fri Oct 27 00:26:08 PDT 2006
> 
> then:
> 
> +       while (node)
> +       {
> 
> proper style is:
> 
> +	while (node) {

Done. I misinterpreted the style guide and have made the changes to
conform to it..

> this function definition:
> 
> +static
> +void lock_stat_insert_object(struct lock_stat *o)
> 
> can be single-line. We make it multi-line only when needed.

Done for all the instances I remember off hand.

> these are only samples of the types of style problems still present in 
> the code.

I'm a bit of a space cadet so I might have missed something.

Latest patch here.

	http://finfin.is-a-geek.org/~billh/contention/patch-2.6.20-rc2-rt2.4.lock_stat.patch

I'm going to review and hand merge your changes to the older patch tonight.

Thanks for the comments.

bill

