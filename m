Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbXGQNWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbXGQNWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXGQNWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:22:22 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:53629 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXGQNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:22:22 -0400
Date: Tue, 17 Jul 2007 15:22:16 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
In-Reply-To: <20070716230307.GB12230@osiris.ibm.com>
Message-ID: <Pine.LNX.4.64.0707171519300.10600@anakin>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <20070716230307.GB12230@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Heiko Carstens wrote:
> On Mon, Jul 16, 2007 at 03:35:34PM -0700, Linus Torvalds wrote:
> > On Mon, 16 Jul 2007, Andrew Morton wrote:
> > > 
> > > No, no revert, please.  If the architecture doesn't support readb() then we
> > > need some reliable way of working that out within Kconfig.
> > 
> > Isn't that CONFIG_HAS_IOMEM?
> 
> That was my understanding as well considering commits  
> 5ea8176994003483a18c8fed580901e2125f8a83 and  
> 23db764d3db5a4bb1e104ad9310e5dc18e4ffa1b  
>   
> so the patch below should be correct... Geert, Roman?
> 
> Subject: [PATCH] Make check_signature() depend on CONFIG_HAS_IOMEM
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> check_signature() uses readb() and therefore should only be build on
> CONFIG_HAS_IOMEM.
> 
> Otherwise breaks s390:
> lib/check_signature.c: In function `check_signature':
> lib/check_signature.c:19: error: implicit declaration of function `readb'
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  lib/Makefile |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/lib/Makefile
> ===================================================================
> --- linux-2.6.orig/lib/Makefile
> +++ linux-2.6/lib/Makefile
> @@ -13,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
>  lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
>  
>  obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
> -	 bust_spinlocks.o hexdump.o check_signature.o
> +	 bust_spinlocks.o hexdump.o
>  
>  ifeq ($(CONFIG_DEBUG_KOBJECT),y)
>  CFLAGS_kobject.o += -DDEBUG
> @@ -21,7 +21,7 @@ CFLAGS_kobject_uevent.o += -DDEBUG
>  endif
>  
>  obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
> -obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
> +obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o check_signature.o
>  obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
>  lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o

I saw this patch went in.

iomap_copy.o ues the raw I/O memory accessors, so it truly depends on
CONFIG_HAS_IOMEM.

check_signature.o depends on ISA/PCI I/O memory, not on generic I/O
memory.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
