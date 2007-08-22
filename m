Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXHVJYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXHVJYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXHVJXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:23:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52203 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbXHVJXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:23:52 -0400
Date: Wed, 22 Aug 2007 10:23:32 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Gustavo de Nardin <gustavodn@mandriva.com.br>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.17 review 27/58] Include serial_reg.h with userspace headers
Message-ID: <20070822092331.GA17947@flint.arm.linux.org.uk>
References: <20070822083844.%N@1wt.eu> <20070822084015.%N@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822084015.%N@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:39:11AM +0200, Willy Tarreau wrote:
> As reported by Gustavo de Nardin <gustavodn@mandriva.com.br>, while trying to
> compile xosview (http://xosview.sourceforge.net/) with upstream kernel
> headers being used you get the following errors:
> serialmeter.cc:48:30: error: linux/serial_reg.h: No such file or directory
> serialmeter.cc: In member function 'virtual void
> SerialMeter::checkResources()':
> serialmeter.cc:71: error: 'UART_LSR' was not declared in this scope
> serialmeter.cc:71: error: 'UART_MSR' was not declared in this scope
> ..

It's probably a good thing to repeat what I said privately about this,
which is:

| It should be noted that reading the MSR or LSR of an active 8250 UART
| has side effects.  In the case of MSR, it clears the bits which indicate
| that the modem status signals have changed, and clears the associated
| interrupt.  This can result in loss of hardware flow control on the port.
| 
| For LSR, a read clears the error status reported in that register and
| clears the interrupt associated with the error status, resulting in
| errors being missed.
| 
| So, reading the LSR and MSR of an active port is Bad News(tm) and is
| something that userspace should absolutely avoid.  Instead, userspace
| should open the port in non-blocking mode and use the TIOCGICOUNT
| ioctl to retrieve the various activity counters and TIOCMGET to obtain
| the current modem status line state.
| 
| I would encourage xosview folk to switch to use these ioctls rather than
| reading the registers direct for the following reasons:
| 
| 1. It's supported by a wide variety of serial port implementations.
| 2. Avoids the mess associated with ioperm support noted in serialmeter.cc
|    revision 1.11
| 3. Avoids including kernel private kernel headers.
| 4. Avoids the buggy "autodetection" of serial IO base (which ignores the
|    IO type of the port, which may be MMIO.)
| 5. Avoids side effects associated with reading the ports registers.
| 
| For a tool which presumably is to assist diagnosing serial problems, it
| would seem to have the capability of causing further additional problems.

I leave it up to others to decide that keeping backwards compatibility
with userspace which is quite obviously broken is more important than
providing userspace with the persuasion to fix their broken code.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
