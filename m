Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbXF2NJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbXF2NJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765739AbXF2NJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:09:06 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:38207 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765241AbXF2NJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:09:03 -0400
Date: Fri, 29 Jun 2007 15:08:59 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
In-Reply-To: <20070628232537.02ced21c@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706291506090.4381@anakin>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
 <20070628110644.a530cfef.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282017450.30789@anakin>
 <20070628113819.c24e592d.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282044360.30789@anakin>
 <20070628132947.e3378811.akpm@linux-foundation.org> <20070628232537.02ced21c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Alan Cox wrote:
> > check_signature() needs readb() but with some setups (s390, m68k allmodconfig)
> > there is no implementation of readb.  This causes build errors with
> > -Werror-implicit-function-declaration.
> 
> This completely bogus. readb() should be present on M68K, fix the
> platform to implement readb() for MMIO, even if your MMIO readb is a
> moveb instruction.
> 
> check_signature is relevant for anything with MMIO space (for example you
> can legitimately want to check_signature a MAC68K Nubus ROM).

To make it more generic, it should probably use the raw*() version, and
the caller should handle bus address conversion. But even that
isn't possible, as there's no guarantee readb(x+1) == raw_readb(x+1).

Anyway, here's a list of its users, as I responded to Andrew in a private
mail before this thread was started:

| drivers/block/xd.c: config BLK_DEV_XD depends on ISA && ISA_DMA_API
| drivers/input/misc/wistron_btns.c: config INPUT_WISTRON_BTNS depends on X86 && !X86_64

That should be X86_32 these days?

| drivers/scsi/aha152x.c: config SCSI_AHA152X depends on ISA && SCSI && !64BIT
| drivers/scsi/dtc.c: config SCSI_DTC3280 depends on ISA && SCSI
| drivers/scsi/fdomain.c: config SCSI_FUTURE_DOMAIN depends on (ISA || PCI) && SCSI
| drivers/scsi/seagate.c: config SCSI_SEAGATE depends on X86 && ISA && SCSI
| drivers/scsi/t128.c: config SCSI_T128 depends on ISA && SCSI
| drivers/scsi/wd7000.c: config SCSI_7000FASST depends on ISA && SCSI && ISA_DMA_API

BTW, include/asm-arm/io.h looks interesting:

| #elif !defined(readb)
| 
| #define readb(c)                        (__readwrite_bug("readb"),0)
| #define readw(c)                        (__readwrite_bug("readw"),0)
| #define readl(c)                        (__readwrite_bug("readl"),0)
| #define writeb(v,c)                     __readwrite_bug("writeb")
| #define writew(v,c)                     __readwrite_bug("writew")
| #define writel(v,c)                     __readwrite_bug("writel")
| 
| #define check_signature(io,sig,len)     (0)
| 
| #endif  /* __mem_pci */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
