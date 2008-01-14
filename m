Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYANKEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYANKEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbYANKEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:04:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58963 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYANKEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:04:31 -0500
Date: Mon, 14 Jan 2008 10:04:15 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: nigel@nigel.suspend2.net
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't drain
Message-ID: <20080114100415.GC22818@flint.arm.linux.org.uk>
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk> <20080111101721.GA4463@ucw.cz> <478A95DB.80407@suspend2.net> <20080114004959.0f533fef@lxorguk.ukuu.org.uk> <478ACB90.3040709@suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478ACB90.3040709@suspend2.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 01:40:16PM +1100, nigel@suspend2.net wrote:
> Hi.
> 
> Alan Cox wrote:
> >>> Is printk() enough for 'we've just lost your data' condition? Maybe we
> >>> should abort suspend if we can't drain fifo?
> >> No way. Think about this from a users' perspective. No one wants suspend
> >> to ram or hibernate functionality that works sometimes and not others.
> >> They want it to work reliably so they don't have to worry about their
> >> laptop overheating while they're getting on the bus or airplane.
> >> Aborting isn't an option.
> > 
> > Dumb question on the printk however - what if the port that is sticking
> > is the console - don't we recurse and die ?
> 
> I don't know, but I'd argue that we shouldn't die. Things should be as
> robust as possible.

Of course we should never die.  That's precisely what I'm trying to work
towards here.

Currently without this patch, various platforms I have here do precisely
that - you ask them to suspend and they shut down the majority of devices
and then die.  The recovery is either system reboot or a power cycle -
especially when the port in question is connected to something other than
an external serial port (eg, a serial port for connection to a non-existent
bluetooth module.)

While we're talking about robustness, since the serial wakeup support has
gone in, another couple of issues have appeared:

1. We no longer suspend ports marked as wakeup sources.  That means we
   never place them into a low power state (which might be required by
   hardware) - we need a flag from the driver or something to indicate
   that.

2. As a direct consequence, we no longer re-initialise the port at resume
   time, resulting in a completely deconfigured but open port.  Such a
   port may be the system console, which will cause any printks may be
   damned slow and the output will be garbage.

(2) is quite a serious problem for ARM platforms - you lose the console
entirely and you also lose control of the system.  Again, recovery from
such events is by either a power cycle or system reboot.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
