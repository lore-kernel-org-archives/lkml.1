Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbXGVKpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbXGVKpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 06:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbXGVKpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 06:45:31 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:44473 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284AbXGVKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 06:45:31 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] [9/11] x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.
Date: Sun, 22 Jul 2007 12:45:26 +0200
User-Agent: KMail/1.9.4
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070720532.949522000@suse.de> <20070720153253.D17F214E7B@wotan.suse.de> <20070721120001.GA5832@martell.zuzino.mipt.ru>
In-Reply-To: <20070721120001.GA5832@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221245.27778.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 14:00, Alexey Dobriyan wrote:
> On Fri, Jul 20, 2007 at 05:32:53PM +0200, Andi Kleen wrote:
> > --- /dev/null
> > +++ linux/include/asm-i386/processor-cyrix.h
> > @@ -0,0 +1,30 @@
> > +/*
> > + * NSC/Cyrix CPU indexed register access. Must be inlined instead of
> > + * macros to ensure correct access ordering
> > + * Access order is always 0x22 (=offset), 0x23 (=value)
> > + *
> > + * When using the old macros a line like
> > + *   setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > + * gets expanded to:
> > + *  do {
> > + *    outb((CX86_CCR2), 0x22);
> > + *    outb((({
> > + *        outb((CX86_CCR2), 0x22);
> > + *        inb(0x23);
> > + *    }) | 0x88), 0x23);
> > + *  } while (0);
> > + *
> > + * which in fact violates the access order (= 0x22, 0x22, 0x23, 0x23).
> > + */
> > +
> > +static inline u8 getCx86(u8 reg)
> > +{
> > +	outb(reg, 0x22);
> > +	return inb(0x23);
> > +}
> > +
> > +static inline void setCx86(u8 reg, u8 data)
> > +{
> > +	outb(reg, 0x22);
> > +	outb(data, 0x23);
> > +}
>
> Why bother with new header, just make static inline in asm/processor.h.

Already tried. But it requires asm/io.h everywhere, because it contains 
inb/outb. When they where macros that doesn't matter. Just included asm/io.h 
when these macros where used. But as inlined functions you need asm/io.h all 
the time.

Juergen
