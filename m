Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZI3UrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZI3UrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZI3UrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:47:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60074 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZI3UrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:47:16 -0400
Date: Wed, 30 Sep 2009 22:46:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       torvalds@osdl.org
Subject: Re: x86: mce: Please revert
	22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20090930204643.GA24862@elte.hu>
References: <20090930140904.GA6150@one.firstfloor.org> <20090930194049.GA17712@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930194049.GA17712@liondog.tnic>
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


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Wed, Sep 30, 2009 at 04:09:04PM +0200, Andi Kleen wrote:
> > 
> > Can someone please revert this incorrect commit that's in mainline
> > now? 
> > 
> > Obviously kernels compiled with AMD support can still run on non
> > AMD systems, so messages like this can never be removed at compile time.
> > 
> > -andi
> > 
> > Commit 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
> > Author: Borislav Petkov <borislav.petkov@amd.com>
> > Date:   Tue Jul 28 14:47:10 2009 +0200
> > 
> >     x86, mce: do not compile mcelog message on AMD
> >     
> >     Now that decoding is done in-kernel, suppress mcelog message part.
> >     
> >     CC: Andi Kleen <andi@firstfloor.org>
> >     Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index b82866f..9bfe9d2 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -222,7 +222,10 @@ static void print_mce_head(void)
> >  static void print_mce_tail(void)
> >  {
> >         printk(KERN_EMERG "This is not a software problem!\n"
> > -              "Run through mcelog --ascii to decode and contact your hardware vendor\n");
> > +#if (!defined(CONFIG_EDAC) || !defined(CONFIG_CPU_SUP_AMD))
> 
> how about
> 
> 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> 		pr_emerg("Run through mcelog --ascii to decode and contact your	hardware vendor\n");
> 
> instead?

Yeah, a runtime check like that would be fine - but i'd suggest 
something more clearly and more specifically connected to in-kernel 
decoding: please define a new x86_mce_can_decode_errors capability flag 
or so.

Obviously the Intel CPU side should be fixed and improved to decode MCE 
errors in the kernel too.

Please also fix that printk to say something like:

  "MCE error decoding not supported on this CPU: run through mcelog --ascii to decode\n"

Thanks,

	Ingo
