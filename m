Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZBCVFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZBCVFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBCVFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:05:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZBCVFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:05:23 -0500
Date: Tue, 3 Feb 2009 22:04:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090203210442.GA27804@elte.hu>
References: <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain> <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain> <20090203191334.GA2797@elte.hu> <alpine.LFD.2.00.0902031120080.3247@localhost.localdomain> <20090203195304.GA31049@elte.hu> <alpine.LFD.2.00.0902031209280.3247@localhost.localdomain> <20090203205727.GA4460@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203205727.GA4460@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

[...]
> That principle works both for networking and for other IO transports - but 
> we have little support for it yet. It would work really well for workloads 
> where one physical device is shared by many CPUs.

Which is really what we have in _practice_ - only benchmarketing sets up one 
physical device per CPU and avoids all the ugly consequences of 
gathering/spreadig a channel of information from/to a single device to 
multiple CPUs.

> (A lesser method that approximates this is the use of lots of 
> submission/completion rings per device and their binding to cpus - but 
> that can never really approach the number of CPUs really possible in a 
> system.)

btw., more advanced device IRQ models was one of the thinking behind sparse 
IRQ support: defining a really large NR_IRQS limit on x86 by default, on all 
form factors, and making it really easy and cheap to have a _ton_ of IRQs in 
a Linux system might give hw designers ideas to create such hardware.

/me dreams on ;-)

> And in this most advanced mode of MSI IRQs, and if MSI devices had the 
> ability to direct IRQs to a specific CPU (they dont have that right now 
> AFAICT), we'd run into the overhead scenarios you describe above, and your 
> edge-triggered flow is the most performant one.

So i'd still like your tentative Signed-off-by for your patch - it's i think 
not v2.6.29 material but if it stays problem free in testing we can try it 
in v2.6.30. If it causes problem it will be clearly bisectable and clearly 
revertable.

Maybe we could split it in two: and for MSI we could introduce a 'simpler 
and faster' edge flow as well - and keep the legacy handler untouched. That 
way it's low-risk in its entirety. (and avoids the MSI ->mask complication 
as well.)

	Ingo
