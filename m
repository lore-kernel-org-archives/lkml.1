Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZBCM2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZBCM2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZBCM1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:27:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41919 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZBCM1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:27:50 -0500
Date: Tue, 3 Feb 2009 13:27:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: x86's nmi_hz wrt. oprofile's nmi_timer_int.c
Message-ID: <20090203122732.GF19979@elte.hu>
References: <20090129.155852.161923905.davem@davemloft.net> <20090130150125.GF31009@elte.hu> <20090130.135409.180077287.davem@davemloft.net> <20090202.151439.124517945.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202.151439.124517945.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Fri, 30 Jan 2009 13:54:09 -0800 (PST)
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri, 30 Jan 2009 16:01:25 +0100
> > 
> > > 
> > > * David Miller <davem@davemloft.net> wrote:
> > > 
> > > Reducing it to 1 HZ was kind of a performance hack: running NMIs at HZ 
> > > needlessly interrupts the CPU HZ times a second. It's more than enough to 
> > > have 1 nmi-watchdog tick per second to notice deadlocks that take longer 
> > > than 5 seconds.
> > 
> > For the NMI watchdog's purposes I understand the intent, and this
> > is perfectly fine.
> > 
> > The problem is that it stays at '1' when oprofile starts using the NMI
> > watchdog, and we certainly want more than one oprofile tick per second
> > :-)
> 
> Just making sure you understand the problem, here is the
> sequence of events:
> 
> 1) At bootup, the NMI watchdog is tested.
> 
>    It is tested with nmi_hz=HZ
> 
> 2) If the test passes, nmi_hz is reduced down to '1'
> 
> As I stated, everything up to this point is fine.  Next:
> 
> 3) oprofile initializes and if we choose to use the NMI
>    timer for oprofile profiling it is implemented using
>    a simple DIE_NMI notifier.
> 
>    However, nmi_hz is still just '1' which means that oprofile
>    will only receive one sample per-second.  And this is definitely
>    not what we want.
> 
> Somehow the code in arch/x86/oprofile/nmi_timer_int.c needs to have an 
> interface into the NMI watchdog core so that it can increase nmi_hz back 
> up to "HZ" when the NMI timer profiling is enabled and back down to "1" 
> when such profiling stops.

btw., these types of interactions will be solved in a natural way via 
perfcounters: in that model the NMI watchdog is a set of per-CPU counters 
running on each CPU [with a NMI watchdog callback in the IRQ handling 
routine] - and oprofile uses its own perfcounter - what is left of the PMU 
hardware.

I.e. each PMU using facility can just use performance counters transparently 
and interactions will be solved naturally by perfcounters resource 
management.

	Ingo
