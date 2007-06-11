Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbXFKV0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbXFKV0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbXFKV02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:26:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53642 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751388AbXFKV01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:26:27 -0400
Date: Mon, 11 Jun 2007 23:26:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070611212608.GB3917@elf.ucw.cz>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070611120034.f6d972de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611120034.f6d972de.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Starting beeper as soon as ACPI sleep returns is very useful in
> > debugging "apparently dead" machines. If it beeps at all, it makes
> > sense to start playing with CMOS tracer.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> > index b781b38..cbf136e 100644
> > --- a/arch/i386/kernel/acpi/wakeup.S
> > +++ b/arch/i386/kernel/acpi/wakeup.S
> > @@ -11,7 +11,22 @@ # Do we need to deal with A20? It is oka
> >  #
> >  # If physical address of wakeup_code is 0x12345, BIOS should call us with
> >  # cs = 0x1234, eip = 0x05
> > -# 
> > +#
> > +
> > +#define BEEP \
> > +	inb	$97, %al; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$3, %al; 	\
> > +	outb	%al, $97; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$-74, %al; 	\
> > +	outb	%al, $67; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$-119, %al; 	\
> > +	outb	%al, $66; 	\
> > +	outb	%al, $0x80; 	\
> > +	movb	$15, %al; 	\
> > +	outb	%al, $66;
> >  
> >  ALIGN
> >  	.align	4096
> > @@ -20,6 +35,9 @@ wakeup_code:
> >  	wakeup_code_start = .
> >  	.code16
> >  
> > +# Uncomment this to make your computer start producing ugly noise as soon
> > +# as BIOS returns to this real-mode entry point.
> > +#	BEEP
> >   	movw	$0xb800, %ax
> >  	movw	%ax,%fs
> >  	movw	$0x0e00 + 'L', %fs:(0x10)
> > 
> 
> How does the beep get turned off again?

Typically, pcmcia beeps after resume, making it quiet. If not, echo ^G
does it.

> Should the BEEP line be uncommented (in -mm at least)?

It's too gross a hack, I'd say. It is only ever useful if machine is
completely dead after s2ram.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
