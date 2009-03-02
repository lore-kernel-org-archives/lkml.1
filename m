Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZCBStQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZCBStQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZCBStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:49:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:33134 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZCBSs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Pt5+x1qUd4LHDftht2c7gJ61c7pyPRt4vFzxurS0P8K8vPDZ3KzIXp2WOJYsdSj85J
         7sfGgJNJvsoVQ0mHxtnL3brokIWTxCEZqE5NP5IW8cutu5FoFXIvfCfL7q/vwbG2xfWu
         TPh/TK5gtEc9znfiO78yNOI/QW9xaSirit0bk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Date: Mon, 2 Mar 2009 19:48:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090227; KDE/4.2.0; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-arch" <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1235996477.5330.174.camel@laptop> <200903021855.02765.bzolnier@gmail.com> <alpine.LFD.2.00.0903021012080.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903021012080.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021948.51500.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Could we make just the IDE driver itself enable interrupts? Sure. But that 
> > 
> > Actually it has been doing it for years (some host drivers don't do this by
> > default and still need "hdparm -u" or equivalent but I was planning to change
> > it for 2.6.30).
> 
> The IDE layer has the option to enable irq's during the transfer itself, 
> yes.  But it actually works the reverse way from what you think: the irq 

Hmm, I said nothing about how it is implemented in the IDE code itself. :)

> layer will enable interrupts, and the IDE layer will then _not_ disable 
> them during the transfer if you use "hdparm -u".
> 
> Look at ide_intr: it generally gets called with interrupts _enabled_ 
> (because it doesn't use IRQF_DISABLED) and then it does:
> 
>         spin_lock_irqsave(&hwif->lock, flags);
> 	..
>         spin_unlock(&hwif->lock);
> 	..
>         if (drive->dev_flags & IDE_DFLAG_UNMASK)
>                 local_irq_enable_in_hardirq();
> 	...
> 	spin_lock_irq(&hwif->lock);
> 	...
> 	spin_unlock_irqrestore(&hwif->lock, flags);
> 
> where the magic thing is how it enables irqs again if the "irq unmask" 
> flag is set.
> 
> The point I'm making is that 
> 
>  - as far as the generic irq layer is concerned, IDE might as well have 
>    interrupts enabled all the time (and disabling them is a local issue, 
>    more to do with locking and with timing-induced hardware _bugs_ rather 
>    than anything else)
> 
>  - .. and more importantly, that is AS IT MUST BE. Because quite frankly, 
>    if the irq handler enables interrupts (like IDE does), the generic IRQ 
>    layer really _must_ know about it, because it may depend on 
>    non-reentrancy of that interrupt.

Fixing this is on long-term TODO (there was just a ton of more high-prio
stuff to take care of first).

Thanks,
Bart
