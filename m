Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYAIAXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYAIAXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYAIAXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:23:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbYAIAXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:23:23 -0500
Date: Tue, 8 Jan 2008 16:21:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mingo@elte.hu, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-Id: <20080108162159.9f37d856.akpm@linux-foundation.org>
In-Reply-To: <200801082250.06828.rusty@rustcorp.com.au>
References: <20080108063113.GA21287@fattire.cabal.ca>
	<200801082228.05218.rusty@rustcorp.com.au>
	<20080108113323.GB11083@elte.hu>
	<200801082250.06828.rusty@rustcorp.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 22:50:06 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 08 January 2008 22:33:23 Ingo Molnar wrote:
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > +/* FIXME: Risky: returns a pointer into a module w/o lock */
> >
> > stupid question: since module unloads are so rare, why isnt this via the
> > same mechanism that CPU hotplug uses to securely unregister CPUs? I.e.
> > quiet all CPUs, disable irqs on all of them, then unlink the module.
> 
> That's what we do.  This old locking stuff is legacy.
> 
> And here's the patch for the FIXME (which I put in to remind myself):
> 
> Make module_address_lookup safe
> 
> module_address_lookup releases preemption then returns a pointer into
> the module space.  The only user (kallsyms) copies the result, so just
> do that under the preempt disable.
> 
> ...
>
> -/* For kallsyms to ask for address resolution.  NULL means not found.
> -   We don't lock, as this is used for oops resolution and races are a
> -   lesser concern. */
> -/* FIXME: Risky: returns a pointer into a module w/o lock */
> -const char *module_address_lookup(unsigned long addr,
> -				  unsigned long *size,
> -				  unsigned long *offset,
> -				  char **modname)
> +/* For kallsyms to ask for address resolution.  NULL means not found.  Careful
> + * not to lock to avoid deadlock on oopses, simply disable preemption. */
> +char *module_address_lookup(unsigned long addr,
> +			    unsigned long *size,
> +			    unsigned long *offset,
> +			    char **modname,
> +			    char *namebuf)
>  {
>  	struct module *mod;
>  	const char *ret = NULL;
> @@ -2256,6 +2255,11 @@ const char *module_address_lookup(unsign
>  			ret = get_ksymbol(mod, addr, size, offset);
>  			break;
>  		}
> +	}
> +	/* Make a copy in here where it's safe */
> +	if (ret) {
> +		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
> +		ret = namebuf;
>  	}
>  	preempt_enable();
>  	return ret;

The string handling in here has become a bit scruffy.

afacit the `namebuf[KSYM_NAME_LEN - 1] = 0;' would be unneeded if we were
to use strlcpy() and I suspect the `namebuf[0] = 0;' isn't needed either. 

And the use of strlcpy() means we don't need to subtract 1 from
KSYM_NAME_LEN and we don't need to fret about weird strncpy semantics when
the input string is too large.


And the fact that incoming arg `namebuf' MUST point at a
KSYM_NAME_LEN-sized buffer could be better communicated by using a
dedicated struct for this, or by giving the arg a type of `char
namebuf[KSYM_NAME_LEN]'.  Or by adding a comment. Or by just ignoring
me and doing something more useful.
