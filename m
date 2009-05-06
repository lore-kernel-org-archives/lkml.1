Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbZEFVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbZEFVTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZEFVTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:19:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60303 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZEFVTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:19:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
Date: Wed, 6 May 2009 23:18:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com> <87y6tb3x6r.fsf@deeprootsystems.com> <871vr22upr.fsf@deeprootsystems.com>
In-Reply-To: <871vr22upr.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905062318.23572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 May 2009, Kevin Hilman wrote:
> Kevin Hilman <khilman@deeprootsystems.com> writes:
> 
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >
> >> On Wednesday 06 May 2009, Kevin Hilman wrote:
> 
> [...]
> 
> >>> 
> >>> [...]
> >>> 
> >>> >>>
> >>> >>> If this fixes some bug then please provide a description of that bug?
> >>> >>
> >>> >> The bug is that on TI OMAP, interrupts that are used for wakeup events
> >>> >> are disabled by this code causing the system to no longer wake up.
> >>> >
> >>> > What do you do if the interrupt triggers right after your driver has
> >>> > returned from its late suspend hook?  
> >>> 
> >>> If it's a wakeup IRQ, I assume you want it to prevent suspend.
> >>> 
> >>> But I don't see how that can happen in the current code. IIUC, by the
> >>> time your late suspend hook is run, your device IRQ is already
> >>> disabled, so it won't trigger an interrupt that will be caught by
> >>> check_wakeup_irqs() anyways.
> >>
> >> My understanding of __disable_irq() was that it didn't actually disable the
> >> IRQ at the hardware level, allowing the CPU to actually receive the interrupt
> >> and acknowledge it, but preventing the device driver for receiving it.  
> >
> >> Does it work differently on the affected systems?
> >
> > Yes.
> >
> > __disable_irq() calls the irq_chip's disable method which is platform
> > specific.  On OMAP, this masks the IRQ at the hardware level
> > preventing the CPU from seeing the interrupt.
> 
> Looking at x86, the i8259 disable hook also seems to mask the IRQ at
> the PIC level.
> 
> The various IO-APIC irq_chips do not have a disable hook so the
> __disable_irq() here is a NOP.

Except that it sets IRQ_DISABLED.

All right there.

We can either avoid disabling wake-up interrupts, in which case we should
drop check_wakeup_irqs() IMO, or rework things so that check_wakeup_irqs() will
catch them.  Doing both doesn't seem to make sense to me.

Which one would be the right approach, then?

Rafael
