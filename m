Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYAPUPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYAPUPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYAPUO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:14:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53756 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYAPUOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:14:55 -0500
Date: Wed, 16 Jan 2008 20:14:38 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/2] serial: explicitly request ttyS0-3 for COM1-4
Message-ID: <20080116201438.GD23371@flint.arm.linux.org.uk>
References: <20080116170541.511233227@ldl.fc.hp.com> <20080116183933.GB23371@flint.arm.linux.org.uk> <200801161259.28723.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801161259.28723.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 12:59:27PM -0700, Bjorn Helgaas wrote:
> On Wednesday 16 January 2008 11:39:34 am Russell King wrote:
> > On Wed, Jan 16, 2008 at 10:05:41AM -0700, Bjorn Helgaas wrote:
> > > When 8250_pnp discovers COM ports, we only get the correct ttyS names
> > > by accident -- we rely on serial8250_isa_init_ports(), which discovers
> > > the COM ports earlier using the addresses in SERIAL_PORT_DFNS.
> > 
> > It's not by accident but by design.  It's quite intentional that it
> > remembers the addresses of serial ports, and if another port is
> > registered later with the same base address, it gets the same name.
> 
> It's certainly by design that if we register a port twice, it gets
> the same name both times.

Incorrect - if it's not detected first time around (eg, the port isn't
accessible at that time), its slot will still be reserved due to the
way slots are given out.

Slots are given to users in order of:

1. does the IO type and base address of a previously known port match
   the new port?  If so, use that.
2. do we have a slot which has never been used - use that.
3. find the first slot which is not currently in use.

So, the only way we'd get the first set of ttyS slots used is if all of
the following are true:

a) the ISA probe doesn't detect them
b) some other driver registers many ports which don't correspond with any
   of the ISA listed addresses and we run out of empty slots
c) 8250_pnp initialises after this driver

(c) is unlikely, except in the modular case - we explicitly list 8250_pnp
immediately after the 8250 driver so that it gets first call on the
slots during initialisation time, before we probe for PCI devices.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
