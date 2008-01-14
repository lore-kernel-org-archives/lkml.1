Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYANJlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYANJlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYANJk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:40:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34484 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYANJk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:40:58 -0500
Date: Mon, 14 Jan 2008 09:35:25 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't drain
Message-ID: <20080114093525.GA22818@flint.arm.linux.org.uk>
References: <20080108115148.GB10546@flint.arm.linux.org.uk> <20080108115703.GA27179@flint.arm.linux.org.uk> <20080111101721.GA4463@ucw.cz> <20080114002912.GA19195@flint.arm.linux.org.uk> <20080114090459.GB4024@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114090459.GB4024@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 10:04:59AM +0100, Pavel Machek wrote:
> On Mon 2008-01-14 00:29:12, Russell King wrote:
> > If you're suspending because your battery is almost dead what would you
> > prefer - the system being prevented from suspending and losing complete
> > power unexpectedly, resulting in complete data loss, or losing the
> > characters in the serial port and suspending?
> > 
> > Which is the lesser of two evils?
> 
> Not sure, but there's third option -- correct but more work. What
> about saving/restoring fifo state? That will not stall suspend, nor
> will loose data.

The only way you could do that on 8250 is to clear the RX FIFO, enable
loopback, wait for the port to transmit all its characters into the RX
FIFO and read them out that way.

That brings up other questions though:

- what if its a port with 256 characters in the FIFO, and its programmed
  for 110 baud?
- what if loopback isn't supported?
- what if, while doing this operation, the remote end is sending characters
  because you can't deassert RTS?

Finally, on many non-8250 ports, you don't have a loopback mode to
enable, so you have no way to read back the contents of the FIFO.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
