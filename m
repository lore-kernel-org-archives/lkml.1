Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbXBVREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbXBVREF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXBVREF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:04:05 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4015 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXBVREC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:04:02 -0500
Date: Thu, 22 Feb 2007 17:03:54 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070222170354.GB633@flint.arm.linux.org.uk>
Mail-Followup-To: Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk> <45DDB096.2020807@inov.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DDB096.2020807@inov.pt>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 03:02:46PM +0000, Jose Goncalves wrote:
> It could be a silly question (tamper with me as I'm not familiar with
> such low level programming), but couldn't it be possible for a interrupt
> to hit in the middle of the serial_in() calls and mess with %ebx?

I'm no expert on x86, but if an interrupt was messing with %ebx, you'd
have random crashes verywhere - userspace, kernel space in unpredicatable
ways.

> What I find real hard to understand is why a hardware fault happens
> always in the same software instruction! I would expect a hardware fault
> to hit randomly...

Well, compared with your previous report, your latest report is different.
Your first report had  both EIP and %ebx being zero (because they got
corrupted when returning from serial_in).  This time only %ebx was
corrupted.

Consequently, this time we oopsed in the subsequent serial_in() rather
than trying to return to serial8250_startup() as last time.

> I left my application running this night, with a 2.6.16.41 kernel
> unpatched  on the serial driver (my last Oops report was with Frederik
> patch to remove the insertion made in 2.6.12) and it crashed again on
> exactly the same point!

>From that I take it that you removed the test in serial8250_startup which
sets UART_BUG_TXEN, and the problem persisted.  That tends to suggest
that it's not the culpret.

> > For all we know, it could be a one-off fault on the hardware you
> > happen to have - other identical units may not behave the same (can
> > you check?)
> 
> Yes I have other units that I can test it. I'll do that to see if it's
> really a one-off fault on the hardware.

Would be nice to know.

> If it continues to crash with other units I will then test with the
> msleep(10) before the "And clear the interrupt registers again for
> luck.", as you suggested earlier.
> 
> > If it is a one off case, you are welcome to patch that test out in
> > your kernel build to remove the problem, and if it's an isolated case
> > I encourage you to do this.  This is one of the great advantages of
> > open source - if you hit such a problem rather than throwing the
> > hardware away you can work around such issues.
> 
> I didn't understand what you mean by "you are welcome to patch that test
> out in your kernel build to remove the problem". Which test are you
> talking about?

The one which sets UART_BUG_TXEN.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
