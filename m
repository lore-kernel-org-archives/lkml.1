Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZGKHbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZGKHbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZGKHbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:31:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZGKHbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:31:12 -0400
Date: Sat, 11 Jul 2009 09:30:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Message-ID: <20090711073037.GA28414@elte.hu>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <20090710112403.GC3760@elte.hu> <200907111537.03191.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907111537.03191.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Fri, 10 Jul 2009 08:54:03 pm Ingo Molnar wrote:
> > * Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> > >  #define ARCH_SHF_SMALL 0
> > >  #endif
> > >
> > > +/* Modules' sections will be aligned on page boundaries
> > > + * to ensure complete separation of code and data, but
> > > + * only when CONFIG_DEBUG_RODATA=y */
> >
> > please use the customary comment style:
> >
> >   /*
> >    * Comment .....
> >    * ...... goes here:
> >    */
> 
> Please don't.  There's one spot in that file which does it, and 
> frankly it's a distracting waste of space.

What are you talking about? There's _16_ places in kernel/module.c 
that use the above standard comment style.

Furthermore, why do we have _five_ different, inconsisent looking 
comment styles mixed into this same file, often mixed within the 
_same function_.

It is rather distracting and annoying when code uses non-standard 
multi-line comments like:

/* Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
   might -- code, read-only data, read-write data, small data.  Tally
   sizes, and place the offsets into sh_entsize fields: high bit means it
   belongs in init. */

Mixed with the standard style:

/*
 * Ensure that an exported symbol [global namespace] does not already exist
 * in the kernel or in some other module's exported symbol table.
 */

Mixed with a weird mix of the two styles:

/* Generate the signature for all relevant module structures here.
 * If these change, we don't want to try to parse the module. */

Mixed with a second weird mix of these styles:

        /* Now sew it into the lists so we can get lockdep and oops
         * info during argument parsing.  Noone should access us, since
         * strong_try_module_get() will fail.
         * lockdep/oops can run asynchronous, so use the RCU list insertion
         * function to insert in a way safe to concurrent readers.
         * The mutex protects against concurrent writers.
         */

Mixed with a third weird mix of these styles:

/* Format: modulename size refcount deps address

   Where refcount is a number or -, and deps is a comma-separated list
   of depends or -.
*/

I fully recognize your right to disagree with fine details in the 
standard style rules - they _are_ partly arbitrary - but that's 
pretty much the point: predictable looking patterns help us 
pinpointing weird looking _structure_ in code.

But that finer argument does not even apply here because you dont 
actually use any styles consistently - you use absolutely no 
consistent style at all in kernel/module.c! You claim that you have 
some different comment style from what others use in the kernel - 
yet you dont apply it consistently at all.

It is not helpful at all if you lace your code with extra comment 
noise, in five different flavors. _You_ apparently do not even 
notice and probably you dont even care, but others like me do.

It is doubly not helpful if you compound this by resisting, opposing 
and obstructing the review activities of others who do care.

And it is not helpful square two if you teach new contributors to 
not care about clean patches.

> But better is to try to stick with pithy one-line comments!

Sure. My remark was limited to multi-line comments.

> > > +			"  text size: %lu\n"
> > > +			"  ro size: %lu\n"
> > > +			"  total size: %lu\n",
> > > +			(unsigned long)base,
> > > +			text_size, ro_size, total_size);
> >
> > Please remove all DEBUGP() lines - they uglify the code.
> 
> I don't know if anyone ever turns them on any more, but this usage 
> is entirely consistent with how they work at the moment: detailing 
> the module layout.

Just like you requested multi-line comments to be shortened or 
eliminated above (because if used incorrectly they distract from 
code readability), do i request unused in-source debugging code to 
be removed - for exactly the same reasons.

Half of this patch was debug statements that distracted me (and 
others) from reviewing the merits of the patch.

> > > +		begin_pfn = PFN_DOWN((unsigned long)base);
> > > +		end_pfn = PFN_DOWN((unsigned long)base + ro_size);
> >
> > Why is base a void * then cast to unsigned long? Use the more 
> > natural type as a parameter to avoid dangerous type-casts.
> 
> Because this is how PFN_DOWN works?

You did not read and apparently did not understand my review 
suggestion at all. The type of 'base' should be changed to the 
natural type: unsigned long.

This has nothing to do with how 'PFN_DOWN works', whatsoever.

> > Please also fix many other instances of this.
> 
> Please don't.  Fix the credit comment if you want, but I've 
> applied the current version for now.

Sigh, and now you apply this incomplete and unclean patch. The thing 
is, unpatched upstream kernel/module.c is quite a readability mess 
right now, even on the most trivial level and beyond comments:
 
 - Inconsistent function prototypes.

 - Mid-string broken up printks.

 - Code flow confusion: inconsistent checks for allocation errors
   within the same function.

 - Huge functions that should be broken up. load_module() is 470
   lines long (!).

 - Stuff like casting the same variable four times in 2 lines:

  static void *module_alloc_update_bounds(unsigned long size)
  {
        void *ret = module_alloc(size);

        if (ret) {
                /* Update module bounds. */
                if ((unsigned long)ret < module_addr_min)
                        module_addr_min = (unsigned long)ret;
                if ((unsigned long)ret + size > module_addr_max)
                        module_addr_max = (unsigned long)ret + size;
        }
        return ret;
  }

  Can you read that function at a glance? I sure cannot.

And i'm sure there's more - this is what 2 minutes of looking 
showed. If we cannot even get the trivial stuff right how can we get 
the more complex stuff right?

_Please_ work on making it more readabe before piling more features 
on it ...

Thanks,

	Ingo
