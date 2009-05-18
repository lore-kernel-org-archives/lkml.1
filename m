Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZERXYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZERXYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZERXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:24:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:48446 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbZERXYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:24:24 -0400
Date: Tue, 19 May 2009 08:22:34 +0900
To: jgarzik@pobox.com
Cc: arnd@arndb.de, hancockrwd@gmail.com, htejun@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, schmitz@biophys.uni-duesseldorf.de,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A11E739.6080106@pobox.com>
References: <4A106E22.1010705@pobox.com>
	<200905172245.23774.arnd@arndb.de>
	<4A11E739.6080106@pobox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090519082230S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 19 May 2009 08:22:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 18:54:49 -0400
Jeff Garzik <jgarzik@pobox.com> wrote:

> Arnd Bergmann wrote:
> > h8300 and m32r currently do not provide a DMA mapping API
> > and therefore cannot use the ATA drivers. This adds a
> > generic version of dma-mapping.h for architectures that
> > have none or very minimal actual support for DMA in hardware
> > and makes the two architectures use it.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > On Sunday 17 May 2009 20:05:54 Jeff Garzik wrote:
> > 
> >> That's what needs to happen.  We provide no-op functions for e.g. PCI 
> >> and x86 DMI, for platforms where this support does not exist.
> >>
> >> Pretty much all architectures support some form of ATA.  m68k, m32r, 
> >> h8300 and microblaze all have IDE interface, which means that libata 
> >> needs to work on that platform.
> >>
> >> The only !ATA arch in the entire kernel is s390, AFAICT.
> > 
> > m68k only defines NO_DMA for Sun3 and Dragonball. Sun3 does
> > not have ATA, Dragonball could probably just enable HAS_DMA.
> > 
> > ---
> >  arch/h8300/Kconfig                   |    2 +-
> >  arch/h8300/include/asm/dma-mapping.h |    1 +
> >  arch/m32r/Kconfig                    |    2 +-
> >  arch/m32r/include/asm/dma-mapping.h  |    1 +
> >  include/asm-generic/dma-mapping.h    |  399 ++++++++++++++++++++++++++++++++++
> >  5 files changed, 403 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/h8300/include/asm/dma-mapping.h
> >  create mode 100644 arch/m32r/include/asm/dma-mapping.h
> >  create mode 100644 include/asm-generic/dma-mapping.h
> 
> My main comment is a bit non-specific...   I tend to think that all 
> no-dma platforms should provide an API whose implementation always 
> returns errors, e.g. an inlined version of dma-mapping-broken.h.
> 
> That sort of setup permits the compiler's dead code elimination to work 
> on these no-dma platforms, while not crapping up the libata code with a 
> bunch of ifdefs.

Just adding one ifdef to libata.h works? What libata needs is just
wrapping dma_map_sg and dma_unmap_sg like the old ide stack does.

I'm not against the idea of an inlined version of dma-mapping-broken.h
but having two ways to handle this issue is a bit confusing; so far
what we done to handle this problem is using NO_DMA, like SCSI-ml
does, not putting the dma code in non-architecture code and having
something like scsi_lib_dma.c.

Is it theoretically correct that the dma mapping API lives in low
level drivers instead of libata-core (like how SCSI-ml does)?
