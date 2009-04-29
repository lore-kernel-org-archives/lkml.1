Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZD2Maa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZD2Maa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZD2MaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:30:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZD2MaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:30:19 -0400
Date: Wed, 29 Apr 2009 14:30:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git-pull -tip] x86: cpu_debug patches
Message-ID: <20090429123000.GB23380@elte.hu>
References: <1240190145.3106.90.camel@ht.satnam> <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam> <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam> <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam> <20090429105021.GG2373@elte.hu> <1241007294.3061.12.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241007294.3061.12.camel@ht.satnam>
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

> On Wed, 2009-04-29 at 12:50 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Tue, 2009-04-28 at 19:28 +0200, Ingo Molnar wrote:
> > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > 
> > > > > @@ -850,10 +903,10 @@ static int cpu_init_cpu(void)
> > > > >  		cpui = &cpu_data(cpu);
> > > > >  		if (!cpu_has(cpui, X86_FEATURE_MSR))
> > > > >  			continue;
> > > > > -		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
> > > > > -					   (cpui->x86 << 8) |
> > > > > -					   (cpui->x86_model));
> > > > > -		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
> > > > > +		per_cpu(cpu_modelflag, cpu) = get_cpu_flag(cpui);
> > > > > +		if (!per_cpu(cpu_modelflag, cpu))
> > > > > +			send_report(per_cpu(cpu_priv_count, cpu), cpui);
> > > > 
> > > > This means that if the CPU is not enumerated in the model table 
> > > > explicitly, we'll fall back to some really minimal output, right?
> > > > 
> > > 
> > > Yes.
> > 
> > That's a bug really: it means that for every new CPU type that comes 
> > around we need to update this code. I.e. precisely for those CPUs 
> > where we might need the most help from such a debug facility, we 
> > wont have much info to look at ... New CPUs generally support all 
> > the CPU features that are displayed here, in a compatible manner.
> > 
> > So that needs to be improved/changed to not be tied to such a static 
> > 'cpu model' enumeration but instead be CPU feature flags driven. See 
> > all the existing cpu_has_*() tests we have.
> > 
> 
> cpu_has_*() is based on boot_cpu. So you mean cpu_has tests. right ?

Correct.

> We can use cpu_has tests for unknown processors but 'cpu model' is 
> accurate and cover all range.

So is cpu_has. If it's not accurate then various other pieces of x86 
code might break as well.

> cpu_has does not cover following registers:
> 1. platform
> 2. poweron
> 3. control
> 4. bios
> 5. freq
> 6. cache
> 7. misc
> 8. base
> 9. ver
> 10. conf
> 
> So is this looks OK to you:
> 
> 1. first check for 'cpu model' if CPU not supported then goto 2
> 2. check for cpu_has tests 

No, please get rid of the 'cpu model' based feature tests altogether 
and extend the _existing_ feature flags with the above details, when 
needed.

That way we reuse the existing cpu_has checks and extend them. 
Instead of implementing a private facility in cpu_debug.c.

	Ingo
