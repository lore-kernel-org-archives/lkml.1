Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZKZPhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZKZPhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZKZPhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:37:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49192 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbZKZPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:37:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=tzpJGxHsJMdXTl9EkrFmqdnTtiVkYC8WRnEdYW3TIKiYwlV8hyyLp6kqDqEHpCSP3w
         MEVejE4k+N7kk5sbTrKjGkayMdOnS0dxiLWrn3XeWrtJRStEUxJhLZ3cfdhBsm64f67d
         eDTk4yhtof3rBeIWEW8wLN7aFMwhd0IoHibvA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 36/86] pata_it8213: add UDMA100 and UDMA133 support
Date: Thu, 26 Nov 2009 16:36:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <4B0E9928.2020809@ru.mvista.com> <4B0E9C1F.4000104@ru.mvista.com>
In-Reply-To: <4B0E9C1F.4000104@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <200911261636.28139.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 04:17:51 pm Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >> There shouldn't be any problems with it as IDE it8213 host driver
> >> has been supporting UDMA100 and UDMA133 for years.
> 
> >> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> >> Index: b/drivers/ata/pata_it8213.c
> >> ===================================================================
> >> --- a/drivers/ata/pata_it8213.c
> >> +++ b/drivers/ata/pata_it8213.c
> >> @@ -164,7 +164,7 @@ static void it8213_set_dmamode (struct a
> >>  
> >>          /* Clocks follow the PIIX style */
> >>          u_speed = min(2 - (udma & 1), udma);
> >> -        if (udma == 5)
> >> +        if (udma > 4)
> >>              u_clock = 0x1000;    /* 100Mhz */
> >>          else if (udma > 2)
> >>              u_clock = 1;        /* 66Mhz */
> >> @@ -264,7 +264,7 @@ static int it8213_init_one (struct pci_d
> >>          .flags        = ATA_FLAG_SLAVE_POSS,
> >>          .pio_mask    = ATA_PIO4,
> >>          .mwdma_mask    = ATA_MWDMA2,
> >> -        .udma_mask     = ATA_UDMA4, /* FIXME: want UDMA 100? */
> >> +        .udma_mask     = ATA_UDMA6,
> >>          .port_ops    = &it8213_ops,
> >>      };
> >>      /* Current IT8213 stuff is single port */
> 
> >    Well, at 100 MHz it's probably not really UDMA6 but UDMA5 in 
> > disguise... though u_speed would be 2 instead of 1 which should 
> > correspond to either 3 clocks or 1 clock according to Intel's 
> > documentation (different Intel docs give different figures and even ICH 
> > PRM gives *both* clocks).
> 
>     If we take 3 clocks as correct (1 clock doesn't seem correct anyways, as 
> with UDMA mode 5 UDMA cycle must be 20 ns and 1 clock gives only 10 ns). 
> Well, then UDMA5 doesn't seem different from UDMA4 with ICH controllers and 
> it's not clear why all the fuss about 100 MHz bit was necessary... :-/

Sergei, please remember that IT8213 is a _custom_ spin-off from ICH chipset
and it gets some things in rather radically different way (i.e. value of PPE
bit is reversed on IT8213).

>     Returning to IT8213, with UDMA6 we have 'u_speed' of 2 that should 
> correspond to 2 clocks which is 20 ns at 100 MHz and really is an UDMA5 
> speed. Well, given UDMA5's slowness, that's definitely a gain. The question 
> remains however, isn't this value reserved like on original ICH?

It is not according to the official documentation for IT8213 (+ the chip
officially claims to support UDMA6) and pata_it8213 behavior now matches
the behavior of it8213 host driver.

I would love to be able to explain IT8213 chip internals in more detail
but unfortunately the documentation is rather cryptic in this regard as
it only gives you specific values that you should program into specific
registers to get chip properly configured for specific transfer modes...

--
Bartlomiej Zolnierkiewicz
