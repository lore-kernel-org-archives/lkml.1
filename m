Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZHPV2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZHPV2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZHPV2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:28:41 -0400
Received: from www.tglx.de ([62.245.132.106]:52195 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZHPV2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:28:40 -0400
Date: Sun, 16 Aug 2009 23:28:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
In-Reply-To: <200908162301.21775.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.0908162316150.2782@localhost.localdomain>
References: <200908161153.14081.mb@bu3sch.de> <200908161951.13988.mb@bu3sch.de> <alpine.LFD.2.00.0908162201220.2782@localhost.localdomain> <200908162301.21775.mb@bu3sch.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009, Michael Buesch wrote:
> On Sunday 16 August 2009 22:05:59 Thomas Gleixner wrote:
> > Hmm. Nothing interesting AFAICT, but it would be really interesting to
> > find out why the IRQ_DISABLED flag is set.
> > 
> > Can you add some debug into disable_irq() e.g. WARN_ON(irq ==
> > BC43_IRQ_NR); so we can see what disables that interrupt.
> 
> I do not see a warning, if I put this into __disable_irq():
> WARN_ON(irq == 52);
> /proc/interrupts shows 52 as IRQ number for b43.
> And dmesg shows "... irq 52 on host ... mapped to virtual irq 52".
> So I guess the test is OK and the flag is added by some other means.
> Maybe by some weird powerpc architecture code?
> 
> It seems a little bit weird, however, that the WARN_ON does not even trigger
> on module unload, which as far as I can tell should disable the IRQ line
> in the free_irq() call (no other shared devices on this IRQ).

free_irq does not call disable_irq().

There are only a few places which set that flag.

dynamic_irq_init() which should not be called in your system

__set_irq_handler() only if a handler gets uninstalled and replaced by
handle_bad_irq

__disable_irq() which you already excluded

__freq_irq() which should not be called

note_interrupt() which should be visible in dmesg, but we do not see
such a thing.

IRQ_DISABLED is cleared at even less places:

request_irq() and __enable_irq() 

I'm really confused. Can you please add debug into those places and
provide the output. Also please print desc->status of irq 52 before
and after calling request_threaded_irq().

Thanks,

	tglx







