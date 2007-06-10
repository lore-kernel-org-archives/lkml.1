Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXFJVDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXFJVDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 17:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXFJVDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 17:03:42 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:50133 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXFJVDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 17:03:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sun, 10 Jun 2007 15:03:28 -0600
User-Agent: KMail/1.9.6
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <20070607204759.GA6809@sortiz.org> <200706101047.12118.arvidjaar@mail.ru>
In-Reply-To: <200706101047.12118.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706101503.29156.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2007 12:47:07 am Andrey Borzenkov wrote:
> > Maybe we should also run the legacy probe when the PnP one fails. I
> > don't know how the preconfiguration stuff will behave with the device
> > being PnP enabled, but with your patch Andrey will still need to
> > modprobe smsc-ircc with smsc_nopnp.
> 
> One thing that makes me uneasy - ideally we have to do it *after* PnP probe 
> fails. Currently we lie to PnP layer that we successfully probed for device 
> while in effect we did not (at least, not where PnP told us to).
> 
> > So, here is the patch I propose (I had to move smsc_ircc_legacy_probe()
> > a bit earlier in the code to avoid forward declaration, but it's
> > basically your patch plus a call to smsc_ircc_legacy_probe() from the
> > pnp_probe() routine):

This patch does the legacy probe if PNP says we have an SMCf010, but
we couldn't make it work.  In that situation, I think we need a PNP
quirk or other kernel PNP fix.  Ultimately, we should only use the
legacy probe if we don't have PNP at all.  

But we're a long ways from that.  First, we have to figure out how
to make PNP detection work at all, then make sure it works for all
the machines we know about.

> Yes this patch works:
> 
> [58674.337465] pnp: Device 00:0a activated.
> [58674.337465] smsc_ircc_present(), addr 0x02e8 - no device found!
> [58674.337465] PnP probe failed
> [58674.340799] Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC 
> IrDA chip, pre-configuring device.

So while this patch works, I don't think it's the right long-term
direction.

> {pts/1}% lspnp -vv 00:0a
> 00:0a SMCf010 SMC Fast Infrared Port
>     state = active
>     allocated resources:
>         io 0x100-0x107
> ...

> {pts/1}% cat /proc/ioports
> ...
> 0100-013f : pcmcia_socket0
> ...

> {pts/1}% sudo cat /sys/class/pcmcia_socket/pcmcia_socket0/available_resources_io
> 0x00000100 - 0x000003af
> 0x000003e0 - 0x000004ff
> 0x00000820 - 0x000008ff
> 0x00000a00 - 0x00000aff
> 0x00000c00 - 0x00000cf7

It's indeed very interesting that pcmcia_socket0 seems to have its
fingers in the same ioport range the IR device thinks it's using.
I don't know much about PCMCIA, but I can see I'm going to have to
learn something :-)

Can you send me your "lspci -vv" output, the whole /proc/ioports and
/proc/iomem, and your dmesg log?  And maybe your pcmcia_socket
available_resources_io and available_resources_mem for good measure.

Bjorn
