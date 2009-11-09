Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZKIIAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZKIIAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZKIIAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:00:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39271 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbZKIIAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:00:07 -0500
Date: Mon, 9 Nov 2009 08:59:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: under bios control, restore AP's APIC_LVTTHMR to
 the BSP value
Message-ID: <20091109075957.GH453@elte.hu>
References: <20091109042134.GA9169@ywang-moblin2.bj.intel.com>
 <20091109070844.GA453@elte.hu>
 <20091109072528.GA2646@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109072528.GA2646@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Mon, Nov 09, 2009 at 08:08:44AM +0100, Ingo Molnar wrote:
> > 
> > * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> > 
> > > Changes since v2:
> > > Incorporate Ingo's comments to get BSP's thermal init value in a
> > > 'boot-CPU-only' function.
> > 
> > > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > > index e09f0e2..2323771 100644
> > > --- a/arch/x86/kernel/setup.c
> > > +++ b/arch/x86/kernel/setup.c
> > > @@ -1002,6 +1002,7 @@ void __init setup_arch(char **cmdline_p)
> > >  
> > >  	init_apic_mappings();
> > >  	ioapic_init_mappings();
> > > +	get_bsp_lvtthmr_init();
> > >  
> > >  	/* need to wait for io_apic is mapped */
> > >  	probe_nr_irqs_gsi();
> > 
> > Ok - it's almost good in this form - it would be nice to name the new 
> > function something more generic, like mcheck_intel_therm_init(), and 
> > call it from arch/x86/kernel/cpu/mcheck/mce.c's mcheck_init() function.
> > 
> 
> I just checked that arch/x86/kernel/cpu/mcheck/mce.c's mcheck_init() 
> will not only run on BSP but also on APs. I put get_bsp_lvtthmr_init() 
> right behind init_apic_mappings() because init_apic_mappings() will 
> setup the fixmap for LAPIC so that I can call apic_read from inside 
> get_bsp_lvtthmr_init().

That's true in Linus's tree but Boris Petkov fixed the MCE init 
functions naming mess in the x86 tree, in these commits:

 b33a636: x86, mce: Add a global MCE init helper
 5e09954: x86, mce: Fix up MCE naming nomenclature

Please base your patch on:

  http://people.redhat.com/mingo/tip.git/README

to have the latest MCE code. So if you stick that init function into 
mcheck_init() in -tip it should be called once per bootup only. (I have 
not checked the other boot dependencies, please do that.)

Thanks,

	Ingo
