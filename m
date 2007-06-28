Return-Path: <linux-kernel-owner+w=401wt.eu-S1765024AbXF1SHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765024AbXF1SHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXF1SHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:07:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbXF1SHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:07:13 -0400
Date: Thu, 28 Jun 2007 11:06:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-Id: <20070628110644.a530cfef.akpm@linux-foundation.org>
In-Reply-To: <20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 15:37:15 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> check_signature() uses readb() and therefore should only be build on
> CONFIG_HAS_IOMEM.
> 
> Otherwise breaks s390:
> lib/check_signature.c: In function `check_signature':
> lib/check_signature.c:19: error: implicit declaration of function `readb'
> 

Ah, right, I've been discussing identical m68k breakage with Roman and Geert.

> ---
>  lib/Makefile |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.22-rc6-mm1/lib/Makefile
> ===================================================================
> --- linux-2.6.22-rc6-mm1.orig/lib/Makefile
> +++ linux-2.6.22-rc6-mm1/lib/Makefile
> @@ -5,8 +5,7 @@
>  lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 rbtree.o radix-tree.o dump_stack.o \
>  	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
> -	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
> -	 check_signature.o
> +	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
>  
>  lib-$(CONFIG_MMU) += ioremap.o pagewalk.o
>  lib-$(CONFIG_SMP) += cpumask.o
> @@ -22,7 +21,7 @@ CFLAGS_kobject_uevent.o += -DDEBUG
>  endif
>  
>  obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
> -obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
> +obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o check_signature.o
>  obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
>  lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o

We didn't think of that.

Alas, m68k `make allmodconfig' creates CONFIG_ISA=n, CONFIG_PCI=n,
CONFIG_HAS_IOMEM=y, so it will still be busted.

But this seems to be the correct fix.  Perhaps m68k config needs
attention?
