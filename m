Return-Path: <linux-kernel-owner+w=401wt.eu-S1161861AbXECMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161861AbXECMIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161866AbXECMIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:08:35 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3217 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161863AbXECMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:08:34 -0400
Date: Thu, 3 May 2007 13:08:15 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: Serial 8250: clear the lsr_break_flag at open
Message-ID: <20070503120815.GA21024@flint.arm.linux.org.uk>
Mail-Followup-To: Corey Minyard <minyard@acm.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org
References: <20070430220858.GA28890@localdomain> <20070501092933.GB18233@flint.arm.linux.org.uk> <46373F42.4080305@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46373F42.4080305@acm.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 08:23:14AM -0500, Corey Minyard wrote:
> Russell King wrote:
> >On Mon, Apr 30, 2007 at 05:08:59PM -0500, Corey Minyard wrote:
> >  
> >>I'm having a hard time understanding why the lsr_break_flag
> >>is necessary.
> >>    
> >
> >Merely reading the LSR clears status bits.  We read the LSR repeatedly
> >so that we can monitor the transmit FIFO when outputting serial console
> >messages.
> >
> >This means that if you have a busy serial console, and you want to send
> >it a sysrq request, there's a chance that the break flag in the LSR will
> >be cleared by the transmit FIFO status polling code thereby being lost.
> >
> >So, we need to remember that status, and we do this via the lsr_break_flag.
> >  
> I should have said a little more.  I couldn't find anywhere in any docs
> for this that said it was a destructive read.

The TI 16550A data sheet says:

* Bit 1: This bit is the overrun error (OE) indicator. ... The OE indicator
  is cleared every time the CPU reads the contents of the LSR.

* Bit 2.: This bit is the parity error (PE) indicator. ... The PE bit is
  cleared every time the CPU reads the contents of the LSR.

* Bit 3: This bit is the framing error (FE) indicator. ... The FE bit is
  cleared every time the CPU reads the contents of the LSR.

* Bit 4: This bit is the break interrupt (BI) indicator. ... The BI bit is
  cleared every time the CPU reads the contents of the LSR.

> So two things:
> 
> There are other bits in this register that also appear to be destroyed on
> read: framing, parity, and overrun.  Should those be saved, too?

Yes.

> There are several places where the LSR is read and nothing is done
> for this, in serial8250_start_tx, serial8250_backup_timeout, and
> serial8250_tx_empty.  It seems like these would need to be handled,
> too.

The backup code is something I never properly reviewed, so no comments
there.  The tx_empty code I assumed would be a relatively rare event,
except when closing the port (at which point you don't particularly care
about errors anyway, not even the break flag since chances are you'll
miss the following character.)

Given that people might want to poll it for various reasons, I guess
saving the status away should be done.  However, there's a slight issue
with working out which character the error is associated with.  Careful
locking may be the answer to that though.

As for start_tx, yes, though slightly harder to check.  Maybe the code
should be modified to reduce the number of potential LSR reads by reading
the IIR first, and only if that shows no interrupt pending should the LSR
be read (and the error flags remembered.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
