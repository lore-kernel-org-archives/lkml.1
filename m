Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYAIDf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYAIDf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYAIDfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:35:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbYAIDfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:35:17 -0500
Date: Tue, 8 Jan 2008 19:33:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mingo@elte.hu, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-Id: <20080108193350.ffc94e44.akpm@linux-foundation.org>
In-Reply-To: <200801091420.19273.rusty@rustcorp.com.au>
References: <20080108063113.GA21287@fattire.cabal.ca>
	<200801082250.06828.rusty@rustcorp.com.au>
	<20080108162159.9f37d856.akpm@linux-foundation.org>
	<200801091420.19273.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 14:20:18 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 09 January 2008 11:21:59 Andrew Morton wrote:
> > The string handling in here has become a bit scruffy.
> 
> Yes, that patch also evokes a const warning.  Fixed below.

No patch was included.

>  I assume you've
> queued these because you're thinking of applying them before 2.6.24?  I'd say
> only modules-de-mutex-more-symbol-lookup-paths-in-the-module-code.patch
> warrants that (the other is unlikely and not a regression).

Actually I was thinking 2.6.25 on both.

<looks>

   Kyle McMartin reports sysrq_timer_list_show() can hit the module
   mutex; these paths don't need to though, since we long ago changed all
   the module list manipulation to occur via stop_machine().

   Disabling preemption is enough.

Ah.  sysrq_timer_list_show() is called from interrupt.

<fixes changelog, thwaps its author>

OK, 2.6.24 seems reasonable.

> > afacit the `namebuf[KSYM_NAME_LEN - 1] = 0;' would be unneeded if we were
> > to use strlcpy() and I suspect the `namebuf[0] = 0;' isn't needed either.
> >
> > And the use of strlcpy() means we don't need to subtract 1 from
> > KSYM_NAME_LEN and we don't need to fret about weird strncpy semantics when
> > the input string is too large.
> >
> >
> > And the fact that incoming arg `namebuf' MUST point at a
> > KSYM_NAME_LEN-sized buffer could be better communicated by using a
> > dedicated struct for this, or by giving the arg a type of `char
> > namebuf[KSYM_NAME_LEN]'.  Or by adding a comment. Or by just ignoring
> > me and doing something more useful.
> 
> Or better, rework all the name lookup interfaces, rather than having: 
> 
> struct module *module_text_address(unsigned long addr);
> struct module *__module_text_address(unsigned long addr);
> int is_module_address(unsigned long addr);
> int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
> 			char *name, char *module_name, int *exported);
> char *module_address_lookup(unsigned long addr,
> 			    unsigned long *symbolsize,
> 			    unsigned long *offset,
> 			    char **modname,
> 			    char *namebuf);
> int lookup_module_symbol_name(unsigned long addr, char *symname);
> int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
> 			       unsigned long *offset, char *modname, char *name);
> unsigned long module_kallsyms_lookup_name(const char *name);
> 
> unsigned long kallsyms_lookup_name(const char *name);
> extern int kallsyms_lookup_size_offset(unsigned long addr,
> 				  unsigned long *symbolsize,
> 				  unsigned long *offset);
> const char *kallsyms_lookup(unsigned long addr,
> 			    unsigned long *symbolsize,
> 			    unsigned long *offset,
> 			    char **modname, char *namebuf);
> extern int sprint_symbol(char *buffer, unsigned long address);
> extern void __print_symbol(const char *fmt, unsigned long address);
> int lookup_symbol_name(unsigned long addr, char *symname);
> int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
> 		        unsigned long *offset, char *modname, char *name);

Yes, it could all do with a revisit.
