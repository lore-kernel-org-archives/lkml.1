Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYBJVJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYBJVJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYBJVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:09:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbYBJVJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:09:32 -0500
Date: Sun, 10 Feb 2008 22:09:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [patch] kgdb light, v6
Message-ID: <20080210210900.GA27162@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210093128.GA11350@infradead.org> <20080210171742.GF7088@elte.hu> <200802102155.46505.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802102155.46505.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> > +} breakinfo[4] = {
> > +	{ .enabled = 0 },
> > +	{ .enabled = 0 },
> > +	{ .enabled = 0 },
> > +	{ .enabled = 0 },
> > +};
> 
> is this initialization really needed?  the whole thing is static 
> anyway

good point! It's not needed at all: fixed.

> > +			case 3:
> > +				set_debugreg(breakinfo[3].addr, 3);
> > +				break;
> 
> 			if (breakno >= 0 && breakno <= 3)
> 				set_debugreg(breakinfo[breakno].addr, breakno);

nice! I've added your simplification.

> > + */
> > +int kgdb_arch_init(void)
> > +{
> > +	register_die_notifier(&kgdb_notifier);
> > +	return 0;
> 
> return register_die_notifier();

agreed - done. (btw., for kicks i checked kernel/notifier.c - 
register_die_notifier() never fails and always returns 0!)

> [...]
> 
> > +MODULE_DESCRIPTION("KGDB Console TTY Driver");
> > +MODULE_LICENSE("GPL");
> 
> should be at the bottom of the file

agreed - i moved it.

> > +static int kgdboc_option_setup(char *opt)
> 
> __init

done.

> > +__setup("kgdboc=", kgdboc_option_setup);
> 
> no need for obsolete __setup, we have module_param_call() below

it's needed for bzImage kernels. I just tested it and without __setup() 
no init sequence is run and KGDB is not activated.

> > +static int configure_kgdboc(void)
> 
> __init

ok, done.

> > +static int init_kgdboc(void)
> 
> __init

done.

> > +#ifdef CONFIG_CONSOLE_POLL
> > +
> 
> unnecessary new line

(that is a personal taste/style thing - to me it simply looks more 
readable if there's an empty line before function declarations.)

> > +/* The maximum number of KGDB I/O modules that can be loaded */
> > +#define KGDB_MAX_IO_HANDLERS	3
> 
> unused

good - zapped it.

> > +#ifndef KGDB_MAX_BREAKPOINTS
> > +# define KGDB_MAX_BREAKPOINTS	1000
> > +#endif
> > +
> > +#define KGDB_HW_BREAKPOINT	1
> 
> unused

hm, both KGDB_MAX_BREAKPOINTS and KGDB_HW_BREAKPOINT are used.

> > + * @late_init: Pointer to a function that will do any setup that has
> 
> there is no late_init in the structure

zapped it.

> identical cache flushing code is present in
> kgdb_deactivate_sw_breakpoints() below
> 
> maybe it would make sense to have some common helper

agreed. Incidentally, while looking at uaccess patterns i noticed this 
and i've already written one: kgdb_flush_swbreak_addr().

> if kgdb_isremovedbreak() helper is moved before kgdb_set_sw_break() 
> and converted to return 'i' on success and '-1' on failure then it can 
> be used instead the above for () loop

dunno - that would complicate arch/x86/kernel/kgdb.c's use of 
kgdb_isremovedbreak() and looks a bit complex. If you feel strongly 
about it, could you send a patch?

in any case, thanks Bartlomiej for the many very useful comments, i 
fixed all of the the things you noticed in my current tree.

	Ingo
