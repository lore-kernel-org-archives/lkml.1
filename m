Return-Path: <linux-kernel-owner+w=401wt.eu-S937986AbXG0WpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937986AbXG0WpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765640AbXG0Woz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:44:55 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:50592 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765552AbXG0Woy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:44:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
Date: Fri, 27 Jul 2007 16:43:13 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, linux-kernel@vger.kernel.org
References: <20070725040304.111550f4.akpm@linux-foundation.org> <5208.1185508832@turing-police.cc.vt.edu> <23912.1185542889@turing-police.cc.vt.edu>
In-Reply-To: <23912.1185542889@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271643.14028.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 07:28:09 am Valdis.Kletnieks@vt.edu wrote:
> Looks like the problematic code is in tpm_tis.c tpm_tis_init() near here:
> 
>                 for (i = 3; i < 16 && chip->vendor.irq == 0; i++) {
>                         iowrite8(i, chip->vendor.iobase +
>                                     TPM_INT_VECTOR(chip->vendor.locality));
>                         if (request_irq
>                             (i, tis_int_probe, IRQF_SHARED,
>                              chip->vendor.miscdev.name, chip) != 0) {
>                                 dev_info(chip->dev,
>                                          "Unable to request irq: %d for probe\n"
> ,           
>                                          i);
>                                 continue;
>                         }
> 
> This seems to be misbehaving differently for the two different DEBUG_SHIRQ
> cases.
> 
> With DEBUG_SHIRQ=n, it starts at IRQ3, gets to at least 8 (where it complains
> it can't request it for probing), and possibly all the way to 15, without ever
> actually selecting and assigning an IRQ (to refresh memories, in that range
> /proc/interrupts only lists:
> 
>   8:          0          0   IO-APIC-edge      rtc
>   9:          3          0   IO-APIC-fasteoi   acpi
>  12:         94          0   IO-APIC-edge      i8042
>  14:     148166          0   IO-APIC-edge      libata
>  15:         94          0   IO-APIC-edge      libata
> 
> So there's certainly IRQ's available.  No idea why it doesn't choose one. But
> since it never chose one, it never gets into the "wait for the IRQ" protected
> by 'if (chip->vendor.irq)' at the end of tpm_tis_send.
> 
> With DEBUG_SHIRQ=y, It starts at IRQ3, and assigns it (which seems a good thing).
> Unfortunately, this then hits the timeouts in tpm_tis_send.
> 
> Anybody got an idea what *should* be happening here?

I don't know why tpm_tis_init() is messing around trying different
IRQs between 3 and 16.  That looks suspiciously x86-dependent.

Maybe if you don't have PNP (though I doubt TPMs exist on any
pre-PNPBIOS machines) the "check-IRQ" loop would be necessary.

But you're using the PNP probe, and PNP should just tell you what
IRQ the device is configured for (and whether the IRQ can be
shared -- see 8250_pnp.c for an example).

The BIOS should have configured the TPM IRQ, and if we go and
mess with that IRQ setting without going through the PNP interface,
e.g., the ACPI _SRS method, we're liable to mess something up.  The
TPM is often behind a few bridges, and if the bridge has any IRQ
routing configuration, only the BIOS knows how to keep that in
sync with the TPM IRQ configuration.

> Just for the record, I see this in /sys:
> 
> % cat /sys/bus/pnp/devices/00:0e/id
> BCM0102
> PNP0c31

What's in /sys/bus/pnp/devices/00:0e/resources?

Bjorn

