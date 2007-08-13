Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbXHMRIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbXHMRIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945649AbXHMQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:47:56 -0400
Received: from tayrelbas03.tay.hp.com ([161.114.80.246]:52629 "EHLO
	tayrelbas03.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031734AbXHMQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:47:52 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 12:47:46 EDT
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Mon, 13 Aug 2007 10:09:46 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706300545.43181.bjorn.helgaas@hp.com> <200708112239.37475.arvidjaar@mail.ru>
In-Reply-To: <200708112239.37475.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131009.46641.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 August 2007 12:39:35 pm Andrey Borzenkov wrote:
> This stopped working again in 2.6.23-rc. In 2.6.22 we decided to disable PnP 
> by default; it is apparently enabled now and fails to activte IrDA 
> completely. So it moves to post-2.6.22 regressions :)
> 
> let me know which information you need
> 
> [ 2192.666450] pnp: PnP ACPI init
> [ 2192.666589] ACPI: bus type pnp registered
> [ 2192.686035] pnp: Device 00:0a activated.
> [ 2192.686089]  00:0a: SMCf010 not responding at SIR 0x100, FIR 0x2e8; 
> auto-configuring
> [ 2192.687610] pnp: Device 00:0a disabled.
> [ 2192.693179] pnp: Device 00:0a activated.
> [ 2192.693210]  00:0a: not responding at SIR 0x100, FIR 0x2e8; swapping 
> SIR/FIR and reconfiguring
> [ 2192.694720] pnp: Device 00:0a disabled.
> [ 2192.701232] pnp: Device 00:0a activated.
> [ 2192.701259]  00:0a: responds at SIR 0x2e8, FIR 0x100
> [ 2192.709309] pnp: PnP ACPI: found 12 devices
> [ 2192.709351] ACPI: ACPI bus type pnp unregistered
> 
> ....
> 
> [ 2207.986550] Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC 
> IrDA chip, pre-configuring device.
> [ 2207.986587] Activated ALi 1533 ISA bridge port 0x02e8.
> [ 2207.986602] Activated ALi 1533 ISA bridge port 0x02f8.
> [ 2207.986817] found SMC SuperIO Chip (devid=0x5a rev=00 base=0x002e): 
> LPC47N227
> [ 2207.986851] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7, 
> mode: 0x0e
> [ 2207.986873] smsc_ircc_present: can't get sir_base of 0x2e8

As of 2.6.23-rc2, we should have:
  - probes for 8250 legacy devices (as in 2.6.21 and previous)
  - smsc PNP probes turned off by default (2.6.21 and previous had no
    PNP probes for smsc at all)
  - some complicated PNP quirks for SMCf010 devices

In other words, I think we're basically back where we started.  The 8250
driver should find a ttyS3 device at 0x2e8, and it should claim those
ports, which will prevent smsc from claiming them.

If you use "setserial /dev/ttyS3 none", the 8250 driver should release
the ports at 0x2e8, and then the smsc-ircc2 driver should be able to
load correctly.  I think this is what we always had to do in the past,
right?

If that doesn't work, try removing the body of quirk_smc_enable() in
drivers/pnp/quirks.c in addition.  It's possible that the quirk changes
the config in a way that messes up the smsc-ircc2 probe.

Bjorn
