Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZBCSmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZBCSmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBCSmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:42:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZBCSmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:42:14 -0500
Date: Tue, 3 Feb 2009 19:41:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
	standard config registers of all devices early)
Message-ID: <20090203184133.GA18323@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <1233633061.16867.41.camel@pasglop> <200902031026.34093.rjw@sisk.pl> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <alpine.LFD.2.00.0902031022390.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902031022390.3247@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 3 Feb 2009, Linus Torvalds wrote:
> > 
> > So don't worry about putting devices in D3 - disable_irq() will not care 
> > AT ALL whether the device is alive or not, and will never try to touch 
> > it anyway.
> 
> Btw, this is very much the case for MSI irq's in particular. If you ask to 
> _mask_ them, it will go to the look up the device list and try to mask 
> them (quite frankly, that sounds insane to me, but whatever), but that not 
> what the irq layer does for the simple "disable()" case.
> 
> It will literally just set the flag, and then even if an interrupt happens 
> afterwards, it will just ->ack it, and then call the ->end thing - and 
> doesn't need to do anything else in the whole "disable" path because MSI's 
> are obviously edge-triggered.
> 
> And the ACK is a pure (x2/io)apic thing, and again doesn't actually touch 
> the device itself, only the irq controller itself.
> 
> So while it is possible in theory that some irq controller ends up trying 
> to access the device for disable_irq, I don't think it's ever true in 
> reality.
> 
> But it's possible that I overlooked some really odd case, of course.

Sidenote: one future usecase that moves towards this might be threaded IRQ 
handlers - but it's not a real problem.

For them to run well we want to split IRQ processing into two bits: the 
"fast and atomic" bit, which just goes in, checks which hw generated the 
IRQ, then disables that hw via its device, and then wakes up the irq kernel 
thread to do all the fancy stuff.

[ at this point that 'complete the IRQ' processing might even be done on
  another CPU - if we decide that the irq was requested from a given CPU. So 
  there's even performance advantage to such a splitup. We have not yet 
  built up much local CPU state so we can migrate the work cheaply. ]

But it's not an issue: this too will be driven centrally and disable_irq() 
will obviously inhibit irqs to all handlers on the chain [to stay 
compatible] and not touch the device hw in the suspend case.

So the 'disable the device irq itself' functionality is hidden behind the 
irq flow machinery - and never executed once you've done a widespread 
disable_irq() calls on (almost) all devices.

	Ingo
