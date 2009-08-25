Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbZHYTYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbZHYTYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZHYTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:24:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbZHYTYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:24:45 -0400
Date: Tue, 25 Aug 2009 21:24:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825192416.GA6974@elte.hu>
References: <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain> <20090825191231.GA22821@elte.hu> <4A9438D1.4030608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9438D1.4030608@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> On Tue, 25 Aug 2009, Yinghai Lu wrote:
> >>> initial apic id and apic id could be different.
> >>>
> >>> and we should use initial apic id to get correct phys pkg id in 
> >>> case BIOS set crazy apic id.
> >> Yinghai - I think you missed Cyrills' point.  Let me repeat it:
> >>
> >> 	"cpu_has_apic bit turned off"
> >>
> >> there's no apic. No "initial apic id". No "phys pkg id". No 
> >> nothing.
> >>
> >> Discussions about "correct phys pkg id" are pointless.
> > 
> > that's not the case here though:
> > 
> > [    8.713916] Total of 32 processors activated (162314.96 BogoMIPS).
> > 
> > so APICs are active. The real difference is i think this aspect of 
> > commit 2759c3287:
> > 
> >  static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
> >  {
> > -       return hard_smp_processor_id() >> index_msb;
> > +       return initial_apic_id >> index_msb;
> >  }
> > 
> > We need to revert back to .30 behavior here. (In case of which 
> > environment to trust we almost always trust whatever booted millions 
> > of Linux boxes in the past already.)
> > 
> > Furthermore, commit 2759c3287 did not declare any side-effects and 
> > clearly causes a side-effect on vSMP which apparently has an 
> > overlapping set of initial APIC ids.
> > 
> > Ravikiran, your patch does not do a clear revert of this bit though. 
> > If you do a plain revert of the line above alone, does that fix the 
> > problem too?
> 
> how about patch phys_pkg_id for vsmp?
> 
> diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
> index f3b1037..65edc18 100644
> --- a/arch/x86/kernel/apic/probe_64.c
> +++ b/arch/x86/kernel/apic/probe_64.c
> @@ -44,6 +44,11 @@ static struct apic *apic_probe[] __initdata = {
>  	NULL,
>  };
>  
> +static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
> +{
> +	return hard_smp_processor_id() >> index_msb;
> +}
> +
>  /*
>   * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
>   */
> @@ -69,6 +74,11 @@ void __init default_setup_apic_routing(void)
>  		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
>  	}
>  
> +	if (is_vsmp_box()) {
> +		/* need to update phys_pkg_id */
> +		apic->phys_pkg_id = apicid_phys_pkg_id;
> +	}

Hm, this is rather tempting simply because it only affects vSMP 
systems and we are in late -rc's. Ravikiran, does Yinghai's patch 
solve the crash for you too?

	Ingo
