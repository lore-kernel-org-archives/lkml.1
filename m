Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbXHZFod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbXHZFod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 01:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXHZFoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 01:44:24 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54598
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751209AbXHZFoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 01:44:23 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Date: Sun, 26 Aug 2007 00:44:17 -0500
User-Agent: KMail/1.9.6
Cc: Jeff Dike <jdike@addtoit.com>, LKML <linux-kernel@vger.kernel.org>
References: <20070824184616.GA9442@c2.user-mode-linux.org> <20070824172027.0ad5d2c0.akpm@linux-foundation.org>
In-Reply-To: <20070824172027.0ad5d2c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708260044.18490.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 7:20:27 pm Andrew Morton wrote:
> On Fri, 24 Aug 2007 14:46:16 -0400
>
> Jeff Dike <jdike@addtoit.com> wrote:
> > [ This looks non-urgent to me ]
> >
> > Without linux/pagemap.h, asm-generic/tlb.h is missing declarations of
> > page_cache_release and release_pages.
> >
> > Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> > --
> >  include/asm-generic/tlb.h |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > Index: linux-2.6.22/include/asm-generic/tlb.h
> > ===================================================================
> > --- linux-2.6.22.orig/include/asm-generic/tlb.h	2007-07-08
> > 19:32:17.000000000 -0400 +++
> > linux-2.6.22/include/asm-generic/tlb.h	2007-08-22 17:29:45.000000000
> > -0400 @@ -13,6 +13,7 @@
> >  #ifndef _ASM_GENERIC__TLB_H
> >  #define _ASM_GENERIC__TLB_H
> >
> > +#include <linux/pagemap.h>
> >  #include <linux/swap.h>
> >  #include <asm/pgalloc.h>
> >  #include <asm/tlbflush.h>
>
> This is worrisome.  If you look at pagemap.h, it includes a pile of things
> which could easily themsleves try to include tlb.h via some path or
> another.  I fear that this patch will cause explosions with some config
> and/or architecture.
>
> If you like, tlb.h is a low-level sort of thing whereas pagemap.h is a
> higher-level VFS thing.  It is more appropriate that pagemap.h be including
> tlb.h.
>
>
> So I think a better fix would be better, but I'm not able to suggest what,
> as there is little detail about the failure here and I can find no mention
> of page_cache_release and release_pages in asm-generic/tlb.h.

To reproduce it, do this in -rc3:

cat > mini.conf << EOF
CONFIG_MODE_SKAS=y
CONFIG_BINFMT_ELF=y
CONFIG_HOSTFS=y
CONFIG_SYSCTL=y
CONFIG_STDERR_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_LBD=y
CONFIG_EXT2_FS=y
CONFIG_PROC_FS=y
EOF
make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf
make ARCH=um

Rob

(P.S. I note that in order for CONFIG_BLK_DEV_LOOP to actually trigger work 
now, I have to add CONFIG_BLK_DEV=y to the above, which I didn't have to do 
in 2.6.22 or in any previous version all the way back to 2.6.12.  Not a major 
regression, but still a bit of a surprise.  That said, the above is what 
triggered the break for me.)
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
