Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbZAWLF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbZAWLF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbZAWLFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:05:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbZAWLFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:05:10 -0500
Date: Fri, 23 Jan 2009 12:04:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Miklos Vajna <vmiklos@frugalware.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Message-ID: <20090123110439.GK15188@elte.hu>
References: <20090121171423.GI21473@genesis.frugalware.org> <1f1b08da0901211200l88fa89s78a51c4e90878d85@mail.gmail.com> <20090121210726.GK21473@genesis.frugalware.org> <1232573646.6997.21.camel@localhost.localdomain> <20090122195132.GZ21473@genesis.frugalware.org> <20090122235727.GB21473@genesis.frugalware.org> <1232674994.6678.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232674994.6678.45.camel@localhost.localdomain>
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


* john stultz <johnstul@us.ibm.com> wrote:

> On Fri, 2009-01-23 at 00:57 +0100, Miklos Vajna wrote:
> > On Thu, Jan 22, 2009 at 12:03:14PM -0800, john stultz 
> > > CONFIG_X86_VISWS: If I recall, this is support for SGI workstations that
> > > had different apics then most systems, and might be related.
> > > 
> > I just did a new build with CONFIG_X86_VISWS and CONFIG_X86_RDC321X
> > disabled, but I kept CONFIG_PARAVIRT_GUEST enabled and that works fine
> > as well. So CONFIG_PARAVIRT_GUEST seems to be unrelated.
> 
> Ah. CONFIG_X86_RDC321X is indeed the issue.
> 
> >From arch/x86/include/asm/timex.h:
> 
> #ifdef CONFIG_X86_ELAN
> #  define PIT_TICK_RATE 1189200 /* AMD Elan has different frequency! */
> #elif defined(CONFIG_X86_RDC321X)
> #  define PIT_TICK_RATE 1041667 /* Underlying HZ for R8610 */
> #else
> #  define PIT_TICK_RATE 1193182 /* Underlying HZ */
> #endif
> 
> This gives the kernel an incorrect slower frequency for the PIT hardware 
> on your system and is why the TSC calibration is off and why the ACPI PM 
> gets thrown out.
> 
> I'd think this would ideally be more of a subarch in the config 
> selection like the AMD Elan is, so folks know it really is not just a 
> extra-support feature and in fact limits what hardware you can use the 
> resulting kernel on.

a better solution is that if RDC is set [it is unset by default] we should 
turn PIT_TICK_RATE into a variable, defaulting it to 1193182. If a real 
RDC or ELAN system is running, that variable is changed during early 
bootup, in the init functions for those platforms.

	Ingo
