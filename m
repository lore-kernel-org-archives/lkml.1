Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZJCKnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZJCKnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZJCKnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:43:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55533 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbZJCKnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:43:46 -0400
Date: Sat, 3 Oct 2009 12:43:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com
Subject: Re: [PATCH 1/4] jump label - make init_kernel_text() global
Message-ID: <20091003104335.GB15919@elte.hu>
References: <cover.1253831945.git.jbaron@redhat.com> <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com> <20091001112003.GA2962@elte.hu> <20091001203905.GD2660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001203905.GD2660@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> On Thu, Oct 01, 2009 at 01:20:03PM +0200, Ingo Molnar wrote:
> > * Jason Baron <jbaron@redhat.com> wrote:
> > 
> > > allow usage of init_kernel_text - we need this in jump labeling to 
> > > avoid attemtpting to patch code that has been freed as in the __init 
> > > sections
> > 
> > s/attemtpting/attempting
> > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > ---
> > >  include/linux/kernel.h |    1 +
> > >  kernel/extable.c       |    2 +-
> > >  2 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > > index f61039e..9d3419f 100644
> > > --- a/include/linux/kernel.h
> > > +++ b/include/linux/kernel.h
> > > @@ -295,6 +295,7 @@ extern int get_option(char **str, int *pint);
> > >  extern char *get_options(const char *str, int nints, int *ints);
> > >  extern unsigned long long memparse(const char *ptr, char **retptr);
> > >  
> > > +extern int init_kernel_text(unsigned long addr);
> > >  extern int core_kernel_text(unsigned long addr);
> > >  extern int __kernel_text_address(unsigned long addr);
> > >  extern int kernel_text_address(unsigned long addr);
> > > diff --git a/kernel/extable.c b/kernel/extable.c
> > > index 7f8f263..f6893ad 100644
> > > --- a/kernel/extable.c
> > > +++ b/kernel/extable.c
> > > @@ -52,7 +52,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
> > >  	return e;
> > >  }
> > >  
> > > -static inline int init_kernel_text(unsigned long addr)
> > > +int init_kernel_text(unsigned long addr)
> > >  {
> > >  	if (addr >= (unsigned long)_sinittext &&
> > >  	    addr <= (unsigned long)_einittext)
> > 
> > i'm confused. Later on jump_label_update() does:
> > 
> > +                       if (!(system_state == SYSTEM_RUNNING &&
> > +                                       (init_kernel_text(iter->code))))
> > +                               jump_label_transform(iter, type);
> > 
> > which is:
> > 
> > +                       if (system_state != SYSTEM_RUNNING ||
> > +                                       !init_kernel_text(iter->code)))
> > +                               jump_label_transform(iter, type);
> > 
> > What is the logic behind that? System going into SYSTEM_RUNNING does not 
> > coincide with free_initmem() precisely.
> > 
> 
> The specific case I hit was in modifying code in arch_kdebugfs_init()
> which is '__init' after the system was up and running. The tracepoint is
> in 'kmalloc()' which is marked as __always_inline.
> 
> 
> > Also, do we ever want to patch init-text tracepoints? I think we want to 
> > stay away from them as much as possible.
> 
> I was trying to make sure that tracepoints in init-text were honored.
> 
> > 
> > It appears to me that what we want here is a straight:
> > 
> >                        if (kernel_text(iter->code))
> >                                jump_label_transform(iter, type);
> > 
> > Also, maybe a WARN_ONCE(!kernel_text()) - we should never even attempt 
> > to transform non-patchable code. If yes then we want to know about that 
> > in a noisy way and not skip it silently.
> > 
> 
> hmmm....indeed, kernel_text_address() does do what I want here (I must 
> have mis-read its definition). Although, I'm not sure there isn't a 
> race here betweeen freeing the init sections and possibly updating 
> them. For modules, there is no race since the module init free code 
> takes the module_mutex, and I do as well in this code...
> 
> I've now also tested this code on 32-bit x86 system, and it seems to 
> perform nicely. I'm seeing a 15 cycle improvement per tracepoint.
> 
> I've based the text section updating on text_poke_fixup(), which has 
> recently come into question about safety of cross modifying code. I 
> could rebase my patches back to use stop_machine()? I guess I'm 
> looking for some advice on how to proceed here.

I think this very limited form of code patching that you are using here 
(patching a JMP) _should_ be safe - so we can avoid stop_machine().

	Ingo
