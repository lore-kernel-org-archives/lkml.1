Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZCKLfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZCKLfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZCKLfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:35:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZCKLfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:35:03 -0400
Date: Wed, 11 Mar 2009 12:34:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
Message-ID: <20090311113450.GE2282@elte.hu>
References: <1236684201.3301.11.camel@localhost.localdomain> <20090310122806.GE5794@elte.hu> <1236697752.3387.2.camel@localhost.localdomain> <20090310152029.GN3850@elte.hu> <1236701373.3387.4.camel@localhost.localdomain> <20090310174535.GA2963@elte.hu> <1236729310.7004.2.camel@localhost.localdomain> <20090311105333.GC2282@elte.hu> <1236770749.2836.10.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1236770749.2836.10.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Wed, 2009-03-11 at 11:53 +0100, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Tue, 2009-03-10 at 18:45 +0100, Ingo Molnar wrote:
> > > > Thanks - picked it up into tip:x86/debug. (Note that i 
> > > > rearranged the Makefile details a bit so that it does not 
> > > > conflict with tip:perfcounters)
> > > > 
> > > > Not yet in tip:master, because it triggers this build failure:
> > > > 
> > > > arch/x86/kernel/cpu/cpu_debug.c: In function ‘print_dt’:
> > > > arch/x86/kernel/cpu/cpu_debug.c:475: error: implicit declaration of function ‘store_ldt’
> > > > 
> > > 
> > > Here is the fix.
> > > 
> > > The following changes since commit 259ef6fcea4046fe24495b1e3631c1b905c531c1:
> > >   Jaswinder Singh Rajput (1):
> > >         x86: cpu architecture debug code
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> > > 
> > > Jaswinder Singh Rajput (1):
> > >       x86: cpu_debug.c remove some dependency
> > > 
> > >  arch/x86/kernel/cpu/cpu_debug.c |    8 ++++----
> > >  1 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > Complete diff:
> > > diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> > > index 0bdf4da..08c365a 100755
> > > --- a/arch/x86/kernel/cpu/cpu_debug.c
> > > +++ b/arch/x86/kernel/cpu/cpu_debug.c
> > > @@ -464,19 +464,19 @@ static void print_dt(void *seq)
> > >  	unsigned long ldt;
> > >  
> > >  	/* IDT */
> > > -	store_idt((struct desc_ptr *)&dt);
> > > +	native_store_idt((struct desc_ptr *)&dt);
> > 
> > hm, this wont work on Xen then.
> > 
> 
> Strange it should work for Xen, Are you getting any error.

s/Xen/virtualization

Look at how the native_*() primitives are used. They are not 
there to be open-coded in generic code. They are there for 
paravirt-internal reasons: they are the native version but a 
guest implementation might decide to override it.

> > >  	print_desc_ptr("IDT", seq, dt);
> > >  
> > >  	/* GDT */
> > > -	store_gdt((struct desc_ptr *)&dt);
> > > +	native_store_gdt((struct desc_ptr *)&dt);
> > >  	print_desc_ptr("GDT", seq, dt);
> > >  
> > >  	/* LDT */
> > > -	store_ldt(ldt);
> > > +	asm volatile("sldt %0" : "=m" (ldt));
> > >  	seq_printf(seq, " LDT\t: %016lx\n", ldt);
> > >  
> > >  	/* TR */
> > > -	store_tr(ldt);
> > > +	asm volatile("str %0" : "=r" (ldt));
> > >  	seq_printf(seq, " TR\t: %016lx\n", ldt);
> > 
> > we do have a store_tr() primitive - why open code the assembly?
> > 
> 
> It is a single line code to avoid further conflicts, so i 
> moved it here.

and that's wrong.

	Ingo
