Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYAQQHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYAQQHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 11:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYAQQHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 11:07:03 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:37781 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYAQQHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 11:07:00 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [patch 0/2] serial: explicitly request ttyS0-3 for COM1-4
Date: Thu, 17 Jan 2008 09:07:29 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080116170541.511233227@ldl.fc.hp.com> <200801161259.28723.bjorn.helgaas@hp.com> <20080116201438.GD23371@flint.arm.linux.org.uk>
In-Reply-To: <20080116201438.GD23371@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801170907.31162.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 01:14:38 pm Russell King wrote:
> On Wed, Jan 16, 2008 at 12:59:27PM -0700, Bjorn Helgaas wrote:
> > On Wednesday 16 January 2008 11:39:34 am Russell King wrote:
> > > On Wed, Jan 16, 2008 at 10:05:41AM -0700, Bjorn Helgaas wrote:
> > > > When 8250_pnp discovers COM ports, we only get the correct ttyS names
> > > > by accident -- we rely on serial8250_isa_init_ports(), which discovers
> > > > the COM ports earlier using the addresses in SERIAL_PORT_DFNS.
> > > 
> > > It's not by accident but by design.  It's quite intentional that it
> > > remembers the addresses of serial ports, and if another port is
> > > registered later with the same base address, it gets the same name.
> > 
> > It's certainly by design that if we register a port twice, it gets
> > the same name both times.
> 
> Incorrect - if it's not detected first time around (eg, the port isn't
> accessible at that time), its slot will still be reserved due to the
> way slots are given out.
> 
> Slots are given to users in order of:
> 
> 1. does the IO type and base address of a previously known port match
>    the new port?  If so, use that.
> 2. do we have a slot which has never been used - use that.
> 3. find the first slot which is not currently in use.
> 
> So, the only way we'd get the first set of ttyS slots used is if all of
> the following are true:
> 
> a) the ISA probe doesn't detect them
> b) some other driver registers many ports which don't correspond with any
>    of the ISA listed addresses and we run out of empty slots
> c) 8250_pnp initialises after this driver
> 
> (c) is unlikely, except in the modular case - we explicitly list 8250_pnp
> immediately after the 8250 driver so that it gets first call on the
> slots during initialisation time, before we probe for PCI devices.

Let me back up a minute.  I was merely trying to make the point that
if we skip the ISA probe (which uses SERIAL_PORT_DFNS), the 8250_pnp
probe will discover the COM ports but won't necessarily name them the
way we expect (e.g., http://lkml.org/lkml/2007/8/10/409).

Bjorn
