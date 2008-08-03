Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYHCUQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYHCUQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYHCUQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:16:24 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:52223 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYHCUQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:16:23 -0400
Date: Sun, 3 Aug 2008 22:16:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
cc: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
In-Reply-To: <4892A719.5090302@snapgear.com>
Message-ID: <Pine.LNX.4.64.0808032205120.23329@anakin>
References: <20080728200500.GA14284@uranus.ravnborg.org> <48900EE4.8030606@snapgear.com>
 <20080730083853.GB18366@uranus.ravnborg.org> <4892A719.5090302@snapgear.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, Greg Ungerer wrote:
> Sam Ravnborg wrote:
> > On Wed, Jul 30, 2008 at 04:49:08PM +1000, Greg Ungerer wrote:
> > > Sam Ravnborg wrote:
> > > > The traditional location of the arch specific Makefiles
> > > > has been at:
> > > > 
> > > > 	include/asm-$ARCH
> > > > 
> > > > But as suggested by several people over time and lately
> > > > by Linus in the following post:
> > > > http://kerneltrap.org/mailarchive/linux-kernel/2008/5/21/1903924
> > > > 
> > > > is is suggested to move the arch specific files under arch/
> > > > and for the header files this is arch/$ARCH/include.
> > > > 
> > > > So I have hacked up support for this in kbuild so
> > > > for the simpler cases a simple move of header files as
> > > > in:
> > > > 	git mv include/asm-$ARCH arch/$ARCH/include/asm
> > > > 
> > > > is enough.
> > > > 
> > > > If Linus will accept it then I think -rc1 is a perfect
> > > > time to do it as people has less stuff pending touching
> > > > the header files that are moved.
> > > > Validation is easy - does the usual configs build?
> > > > 
> > > > For the archs that plays games with symlinks this is a
> > > > splendid opportunity to get rid af these.
> > > > The receipe is simple:
> > > > Use 	KBUILD_CFLAGS += -Iarch/$ARCH/include/$CPU
> > > > 
> > > > to select the CPU and then do a copy of the header files
> > > > like this:
> > > > 
> > > > 	git mv include/asm-$ARCH/$CPU arch/$ARCH/include/$CPU/cpu
> > > > 
> > > > Then the code can continue to use:
> > > > 
> > > > 	#include <cpu/foo.h>
> > > > 
> > > > I already converted sparc to use arch/sparc/include -
> > > > while I merged the header files for sparc and sparc64.
> > > > This change is already upstream.
> > > > 
> > > > And for SH I posted a receipe which you can read here:
> > > > http://lkml.org/lkml/2008/7/28/83
> > > > 
> > > > It is SH specific but anyway pretty generic.
> > > > 
> > > > I am limited in time and resources at the moment but I
> > > > would be glad to help out as time permits should there
> > > > be any questions.
> > > I just tried moving the include/asm-m68knommu directory
> > > to arch/m68knommu/include/asm and it all worked fine.
> > > Clean compile first go :-)  Nice.  (As noted
> > > asm-offsets.h was still generated in incldue/asm-m68knommu
> > > afterwards though).
> > > 
> > > So what is the status, should I prepare git/patch
> > > for Linus?
> > Yes please do so.
> 
> The move change can be pulled from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus
> 
> If there is no complaints I'll send Linus a pull request in a
> couple of days time.

I did:

    mkdir arch/m68k/include
    mv include/asm-m68k arch/m68k/include/asm

and m68k still builds fine (I applied Stephen's patch for the
asm-sparc inclusion problem for Sun 3/3x first, of course).

As (a) I'm not using git (yet) for merging with Linus, and (b) this will
cause some breakage in the m68knommu tree anyway, perhaps it's easiest if Greg
takes care of it in m68knommu.git?

Greg, is that OK for you?
You can add my Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

There seem to be 3 classes of m68knommu header files:
  1. Plain files (some of them may be (nearly) identical copies of the
     m68k variants,
  2. Files that just include the m68k variant,
  3. Files that include the m68k variant and do something more (pci.h and
     setup.h).

Since I don't think we want to do the m68k/m68knommu merge right now
(Sorry Arnd, I'll keep your script in mind anyway!), the simplest way is to:
  - Remove all files from class 2, and add to the Makefile:

	ccflags-y += -Iarch/m68k/include

  - Include verbatim the contents of the m68k variant for class 3, cfr.
    Stephen patch for the asm-sparc inclusion problem for Sun 3/3x).

Do you agree?

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
