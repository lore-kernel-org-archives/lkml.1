Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZHQKX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZHQKX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZHQKX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:23:59 -0400
Received: from bu3sch.de ([62.75.166.246]:52573 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZHQKX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:23:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupt handlers broken?
Date: Mon, 17 Aug 2009 12:23:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200908161153.14081.mb@bu3sch.de> <200908162301.21775.mb@bu3sch.de> <alpine.LFD.2.00.0908162316150.2782@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908162316150.2782@localhost.localdomain>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908171223.57412.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 August 2009 23:28:37 Thomas Gleixner wrote:
> On Sun, 16 Aug 2009, Michael Buesch wrote:
> > On Sunday 16 August 2009 22:05:59 Thomas Gleixner wrote:
> > > Hmm. Nothing interesting AFAICT, but it would be really interesting to
> > > find out why the IRQ_DISABLED flag is set.
> > > 
> > > Can you add some debug into disable_irq() e.g. WARN_ON(irq ==
> > > BC43_IRQ_NR); so we can see what disables that interrupt.
> > 
> > I do not see a warning, if I put this into __disable_irq():
> > WARN_ON(irq == 52);
> > /proc/interrupts shows 52 as IRQ number for b43.
> > And dmesg shows "... irq 52 on host ... mapped to virtual irq 52".
> > So I guess the test is OK and the flag is added by some other means.
> > Maybe by some weird powerpc architecture code?
> > 
> > It seems a little bit weird, however, that the WARN_ON does not even trigger
> > on module unload, which as far as I can tell should disable the IRQ line
> > in the free_irq() call (no other shared devices on this IRQ).
> 
> free_irq does not call disable_irq().
> 
> There are only a few places which set that flag.
> 
> dynamic_irq_init() which should not be called in your system
> 
> __set_irq_handler() only if a handler gets uninstalled and replaced by
> handle_bad_irq
> 
> __disable_irq() which you already excluded
> 
> __freq_irq() which should not be called
> 
> note_interrupt() which should be visible in dmesg, but we do not see
> such a thing.
> 
> IRQ_DISABLED is cleared at even less places:
> 
> request_irq() and __enable_irq() 
> 
> I'm really confused. Can you please add debug into those places and
> provide the output. Also please print desc->status of irq 52 before
> and after calling request_threaded_irq().
> 
> Thanks,
> 
> 	tglx

Ok, I added some more debugging code:
http://bu3sch.de/patches/wireless-testing/20090817-1219/patches/001-hack-threaded-irqs.patch

Here's the result:
http://bu3sch.de/misc/dmesg2

Is it possible that the irq_to_desc() in irq_thread() fails and the resulting desc
pointer points to something random? That could probably explain why the bit is set
and why the spinlock is uninitialized. But it would not explain why desc->lock would
still work... Maybe irq_to_desc() returns a descriptor to another irq (!= 52)?

-- 
Greetings, Michael.
