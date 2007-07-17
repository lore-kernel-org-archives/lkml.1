Return-Path: <linux-kernel-owner+w=401wt.eu-S935735AbXGQUb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935735AbXGQUb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933934AbXGQUbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:31:22 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:36825 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566AbXGQUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:31:20 -0400
Date: Tue, 17 Jul 2007 22:31:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, jdike@karaya.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: uninline check_signature()
In-Reply-To: <alpine.LFD.0.999.0707171102040.19166@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707172225260.23024@anakin>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin>
 <20070717163328.GG7965@c2.user-mode-linux.org> <Pine.LNX.4.64.0707171842590.10600@anakin>
 <alpine.LFD.0.999.0707171102040.19166@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Linus Torvalds wrote:
> On Tue, 17 Jul 2007, Geert Uytterhoeven wrote:
> > M68k uses I/O memory for all I/O (hence it sets CONFIG_HAS_IOMEM), but
> > many m68k machines don't have PCI or ISA (hence it doesn't set
> > CONFIG_PCI resp. CONFIG_ISA).
> 
> It doesn't matter whether the machine has PCI or ISA. The only thing that 
> matters is whether the thing compiles (which in turn depends on whether it 
> has "readb()", which in turn is what HAS_IOMEM is all about).
> 
> So I do think that HAS_IOMEM is the right thing here.

Good, I guess then either I'll have to do something similar to what ARM does:

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

(but use the real BUG() instead, I don't think the above will still
 compile now check_signature() is out-of-line)

And we'll all live with a check_signature() in our kernel, which is used
only by a few legacy drivers that depend on ISA || PCI...

OR I'll have to disable HAS_IOMEM on m68k, and invent a new Kconfig
symbol for lots of other stuff that currently depends on HAS_IOMEM...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
