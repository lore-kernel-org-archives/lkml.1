Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbXLWKoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbXLWKoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 05:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXLWKoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 05:44:22 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:46479 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXLWKoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 05:44:20 -0500
Date: Sun, 23 Dec 2007 11:43:35 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] initrd: Fix virtual/physical mix-up in overwrite test
In-Reply-To: <20071218123119.54262974.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712231142190.24252@anakin>
References: <Pine.LNX.4.64.0712161148340.5869@anakin>
 <20071218030131.8b272833.akpm@linux-foundation.org> <Pine.LNX.4.64.0712182051050.24841@anakin>
 <20071218123119.54262974.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007, Andrew Morton wrote:
> On Tue, 18 Dec 2007 20:52:07 +0100 (CET) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, 18 Dec 2007, Andrew Morton wrote:
> > > On Sun, 16 Dec 2007 11:51:00 +0100 (CET) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On recent kernels, I get the following error when using an initrd:
> > > > 
> > > > | initrd overwritten (0x00b78000 < 0x07668000) - disabling it.
> > > > 
> > > > My Amiga 4000 has 12 MiB of RAM at physical address 0x07400000 (virtual
> > > > 0x00000000).
> > > > The initrd is located at the end of RAM: 0x00b78000 - 0x00c00000 (virtual).
> > > > The overwrite test compares the (virtual) initrd location to the (physical)
> > > > first available memory location, which fails.
> > > > 
> > > > This patch converts initrd_start to a page frame number, so it can be safely
> > > > compared with min_low_pfn.
> > > > 
> > > > Before the introduction of discontiguous memory support on m68k
> > > > (12d810c1b8c2b913d48e629e2b5c01d105029839), min_low_pfn was just left
> > > > untouched by the m68k-specific code (zero, I guess), and everything worked
> > > > fine.
> > > 
> > > breaks x86.
> > > 
> > > init/main.c: In function 'start_kernel':
> > > init/main.c:601: error: implicit declaration of function 'virt_to_pfn'
> > > init/main.c:603: warning: format '%08lx' expects type 'long unsigned int', but argument 2 has type 'int'
> > 
> > Interestingly, virt_to_pfn() exists on a few architectures only :-(
> > 
> > So what's the correct portable construct to use instead?
> > 
> 
> I guess page_to_pfn(virt_to_page(addr))?

New version below. Tested on Amiga. Compile-tested on ia32 (i386_defconfig) and
pp64 (ps3_defconfig).

Subject: initrd: Fix virtual/physical mix-up in overwrite test

From: Geert Uytterhoeven <geert@linux-m68k.org>

On recent kernels, I get the following error when using an initrd:

| initrd overwritten (0x00b78000 < 0x07668000) - disabling it.

My Amiga 4000 has 12 MiB of RAM at physical address 0x07400000 (virtual
0x00000000).
The initrd is located at the end of RAM: 0x00b78000 - 0x00c00000 (virtual).
The overwrite test compares the (virtual) initrd location to the (physical)
first available memory location, which fails.

This patch converts initrd_start to a page frame number, so it can be safely
compared with min_low_pfn.

Before the introduction of discontiguous memory support on m68k
(12d810c1b8c2b913d48e629e2b5c01d105029839), min_low_pfn was just left
untouched by the m68k-specific code (zero, I guess), and everything worked
fine.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
On several platforms, initrd_below_start_ok is set to 1:

| arch/mips/kernel/setup.c:       initrd_below_start_ok = 1;
| arch/parisc/mm/init.c:                  initrd_below_start_ok = 1;
| arch/powerpc/kernel/prom.c:                     initrd_below_start_ok = 1;
| arch/ppc/platforms/hdpu.c:                      initrd_below_start_ok = 1;
| arch/xtensa/kernel/setup.c:             initrd_below_start_ok = 1;

Some of these may be workarounds for this bug. Please check.

 init/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -598,9 +598,10 @@ asmlinkage void __init start_kernel(void
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
-			initrd_start < min_low_pfn << PAGE_SHIFT) {
+	    page_to_pfn(virt_to_page(initrd_start)) < min_low_pfn) {
 		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
-		    "disabling it.\n",initrd_start,min_low_pfn << PAGE_SHIFT);
+		    "disabling it.\n",
+		    page_to_pfn(virt_to_page(initrd_start)), min_low_pfn);
 		initrd_start = 0;
 	}
 #endif

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
