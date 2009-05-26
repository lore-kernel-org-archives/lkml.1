Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZEZMGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZEZMGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZEZMGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:06:09 -0400
Received: from www.tglx.de ([62.245.132.106]:42828 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZEZMGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:06:08 -0400
Date: Tue, 26 May 2009 14:04:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH resend4 2/3] itimers: fix periodic tics precision
In-Reply-To: <20090526084455.672c652f@dhcp-lab-109.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.0905261350450.3582@localhost.localdomain>
References: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com> <alpine.LFD.2.00.0905221611380.3570@localhost.localdomain> <20090525132814.442877e5@dhcp-lab-109.englab.brq.redhat.com> <alpine.LFD.2.00.0905251423490.3582@localhost.localdomain>
 <20090525145132.03915e19@dhcp-lab-109.englab.brq.redhat.com> <20090526084455.672c652f@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Stanislaw Gruszka wrote:
> On Mon, 25 May 2009 14:51:32 +0200
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > On Mon, 25 May 2009 14:32:14 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Mon, 25 May 2009, Stanislaw Gruszka wrote:
> > > > @@ -904,6 +905,7 @@ void __init time_init(void)
> > > >  	tb_ticks_per_usec = ppc_tb_freq / 1000000;
> > > >  	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
> > > >  	calc_cputime_factors();
> > > > +	cputime_one = jiffies_to_cputime(1);
> > > 
> > >   1) The variable name is misleading.
> > 
> > What about cputime_one_jiffy ?
> > 
> > >   2) The patch breaks all powerpc platforms which have
> > >   CONFIG_VIRT_CPU_ACCOUNTING=n and ia64 with
> > >   CONFIG_VIRT_CPU_ACCOUNTING=y
> > 
> > Stupid me, in asm-generic/cputime.h should be 
> > #define cputime_one jiffies_to_cputime(1)
> 
> Hmmm, I'm confused. Perhaps I missed something, but I think patch was ok.
> For powerpc and ia64 and CONFIG_VIRT_CPU_ACCOUNTING=n definitions from
> asm-generic/cputime.h where used. In this file was:
> 
> #define cputime_one (1UL) 

  In time_init you add unconditionally:

> > > > @@ -904,6 +905,7 @@ void __init time_init(void)
> > > >         tb_ticks_per_usec = ppc_tb_freq / 1000000;
> > > >         tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
> > > >         calc_cputime_factors();
> > > > +       cputime_one = jiffies_to_cputime(1);

  I doubt that the compiler will happy about that as it expands to

      (1UL) = jiffies_to_cputime(1)
  or 
      jiffies_to_cputime(1) = jiffies_to_cputime(1)

  in the CONFIG_VIRT_CPU_ACCOUTING=n case.
 
> and that correct as jiffies_to_cputime(x) is just (x)
> 
> For CONFIG_VIRT_CPU_ACCOUTING=y:
> - For powerpc additional variable was  declared and computed in
>   initialization  time. Declaration of was in __KERENEL__ scope.
> - For ia64: cputime_one was defined as jiffies_to_cputime(1)

  My bad, I missed the ia64 hunk.
 
> Does we really need such optimization (because before usage of
> jiffies_to_cputime(1) was just fine) ?

Well, there is a subtle difference between working and nobody noticing
the overhead.

If we notice such heavy instructions in a code path we change then
ignoring the optimization with the argument that it worked before is
just plain wrong.

Thanks,

	tglx
