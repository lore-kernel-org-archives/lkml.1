Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYE1JBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYE1JBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYE1JB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:01:27 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:20501 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750854AbYE1JB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:01:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=v74e0n3tnp3Wh3JdKH0NSnyDijJ477RTMHtuyixY+M9txEeTt8fDy1KYI3JSrNgsIWNAUXNX3Q5QMMU+O4VpwbYTYgAtKUuwoFkuLFzEeDGlOF1Jz/kLUg5prx5H1Sk9BG/ayRr755DRn79zjJz1rQICJheCK3CdWEVdHM486Mo=  ;
X-YMail-OSG: cXoMqC8VM1nIu2ncHibbZuYF3SHFy5c8M9KFxFz5JBS93OCWlFNZol2uoYpuaPRqPbsrCBM0MzqAuTRh26ipibYVXQeeXzAVrXDIAOLnQffnVDDyk_KjWpaUwADvxt9cTA8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: Latest gpio gumph
Date: Wed, 28 May 2008 02:01:24 -0700
User-Agent: KMail/1.9.9
Cc: Ben Nizette <bn@niasdigital.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
References: <1211942475.27810.37.camel@moss.renham> <200805272144.33334.david-b@pacbell.net> <20080528101425.611e0145@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080528101425.611e0145@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805280201.24256.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008, Haavard Skinnemoen wrote:
> > 
> >  * gpio_direction_output() should disable the pullups just like
> >    at32_select_gpio(... AT32_GPIOF_OUTPUT) does, for consistency
> >    between those alternative initialization paths.
> 
> But then we need to keep track of whether pullups used to be enabled so
> that we can re-enable it in gpio_direction_input(), don't we?

"Need"?  I'd figure that changing direction like that would be
uncommon without something determining signal level (like an
external driver or pullup) ... and if nothing did so, then it'd
be important to use the AVR32-private API with pullup control.


> I can't see the harm of keeping the pullup enabled while the port is
> configured as output. For consistency, I'd rather honor the pullup flag
> in at32_select_gpio() regardless of AT32_GPIOF_OUTPUT.

I guess I don't like the idea of facilitating the constant current
waste that implies if output is being driven low.  Even if it's not
a huge current waste!  (These pullups being a lot weaker than I'd
have expected, at typically 190 kOhm.)  No big deal here I guess.

For an open drain output it's probably less of an issue, unless
there are too many pullups.


> >  * On the odd chance some code uses a pin as a GPIO IRQ without
> >    calling gpio_request() or gpio_direction_input(), the debug
> >    dump should still show its pin status.
> 
> Hmm. I guess that makes sense, though I would be lying if I said I care
> all that much. I think gpiolib is going pretty far to accommodate buggy
> drivers that don't call gpio_request() as it is.

For diagnostic/debug code, I'd say it's reasonably useful to cope
with buglets like that. 

I actually observed that happening.  Setup code was passing the irq
to the driver, and everything worked fine because the reset default
was fine.  I happened to notice that /sys/kernel/debug/gpio output
didn't match up to /proc/interrupts (bug) ... but it would have been
much faster to see the bug if the listing for that pin had a "?" label
showing that it hadn't been requested.

- Dave

