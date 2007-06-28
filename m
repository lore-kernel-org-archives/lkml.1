Return-Path: <linux-kernel-owner+w=401wt.eu-S1765353AbXF1S1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765353AbXF1S1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762597AbXF1S1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:27:25 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:47592 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762321AbXF1S1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:27:24 -0400
Date: Thu, 28 Jun 2007 20:27:22 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
In-Reply-To: <20070628110644.a530cfef.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706282017450.30789@anakin>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
 <20070628110644.a530cfef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Andrew Morton wrote:
> On Thu, 28 Jun 2007 15:37:15 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > check_signature() uses readb() and therefore should only be build on
> > CONFIG_HAS_IOMEM.
> > 
> > Otherwise breaks s390:
> > lib/check_signature.c: In function `check_signature':
> > lib/check_signature.c:19: error: implicit declaration of function `readb'
> > 
> 
> Ah, right, I've been discussing identical m68k breakage with Roman and Geert.
> 
> > ---
> >  lib/Makefile |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6.22-rc6-mm1/lib/Makefile
> > ===================================================================
> > --- linux-2.6.22-rc6-mm1.orig/lib/Makefile
> > +++ linux-2.6.22-rc6-mm1/lib/Makefile
> > @@ -5,8 +5,7 @@
> >  lib-y := ctype.o string.o vsprintf.o cmdline.o \
> >  	 rbtree.o radix-tree.o dump_stack.o \
> >  	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
> > -	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
> > -	 check_signature.o
> > +	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
> >  
> >  lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
> >  lib-$(CONFIG_SMP) += cpumask.o
> > @@ -22,7 +21,7 @@ CFLAGS_kobject_uevent.o += -DDEBUG
> >  endif
> >  
> >  obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
> > -obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
> > +obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o check_signature.o
> >  obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
> >  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
> >  lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
> 
> We didn't think of that.
> 
> Alas, m68k `make allmodconfig' creates CONFIG_ISA=n, CONFIG_PCI=n,
> CONFIG_HAS_IOMEM=y, so it will still be busted.
> 
> But this seems to be the correct fix.  Perhaps m68k config needs
> attention?

Euh, I don't think this is the correct fix.

CONFIG_HAS_IOMEM is apparently used in two meanings:
  1. The architecture has support for memory mapped I/O (s390 obviously
     hasn't)
  2. The architecture has ISA/PCI-style memory mapped I/O (readb() and
     friends)

check_signature() falls under the second category.

Setting NO_IOMEM on m68k will make us loose some drivers (e.g.
drivers/video/Kconfig depends on HAS_IOMEM).
 
Apart from many Kconfig dependencies on HAS_IOMEM, CONFIG_HAS_IOMEM is
further only used to control the build of lib/iomap_copy.c, which
doesn't use readb() and friends, but the __raw*() operations.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
