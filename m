Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbZBZDB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbZBZDB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZBZDBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:01:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZBZDBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:01:18 -0500
Date: Thu, 26 Feb 2009 04:00:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090226030050.GA3361@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl> <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl> <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com> <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain> <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com> <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
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

> 
> 
> On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
> >
> > On the msm platform the keyboard driver currently leave the interrupts
> > enabled when suspended. If the interrupt handler is called, we use a
> > wakelock to abort suspend (without wakelocks you would need to set a
> > flag and abort in suspend_late instead). If the interrupt occurs after
> > local_irq_disable, it will still be pending when we get to the suspend
> > enter hook and suspend will be aborted there.
> > 
> > As far as I can tell, this change breaks this. If you press a key at
> > the right time, it will be ignored.
> 
> Is the irq on a private non-shared interrupt line? If so, you 
> could just mark it as IRQF_TIMER, and the irq disable logic 
> won't touch it.

Hm, if that solves the problem then it would be nice to have a 
new IRQF_NO_SUSPEND flag for it, in addition to IRQF_TIMER:

./interrupt.h: * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
./interrupt.h:#define IRQF_TIMER		0x00000200

to express such quirks cleanly.

and the suspend code can check the (IRQF_TIMER | 
IRQF_NO_SUSPEND) mask - so no extra cost.

Right now we have a clean enumeration of timer interrupts, would 
be nice to keep that.

	Ingo
