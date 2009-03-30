Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZC3PS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZC3PS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZC3PSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:18:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZC3PSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:18:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
Date: Mon, 30 Mar 2009 17:17:56 +0200
User-Agent: KMail/1.9.9
Cc: michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       David Miller <davem@davemloft.net>
References: <49D071A8.4010703@petalogix.com> <200903301558.10598.arnd@arndb.de> <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
In-Reply-To: <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301717.57184.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/wzs1/6WC0FH62BjHATzBNeWnW7ZLthwqPeCr
 Zv/WZvoU5zFEIYMulp7aI0TlhYZiZ3m94nSauFRWsVunvfUwmM
 qf/Mo3tj7XkkkabHdYxZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Geert Uytterhoeven wrote:
> On Mon, Mar 30, 2009 at 15:58, Arnd Bergmann <arnd@arndb.de> wrote:
> > +/*
> > + * int-ll64 is used on all 32 bit architectures and on x86-64,
> > + * so use it as a reasonable default.
> > + */
> > +#include <asm-generic/int-ll64.h>
> > +
> 
> Most 64-bit archs have been migrated to ll64 by now.
> Alpha, ia64, and mips64 are the remaining exceptions.

Right, the comment is stale.

> > +/*
> > + * DMA addresses may be larger than pointers, but not smaller.
> > + * Do not define the dma64_addr_t type, which never really
> > + * worked.
> > + */
> > +#if defined(CONFIG_64BIT) || defined(CONFIG_PHYS_64BIT)
> > +typedef u64 dma_addr_t;
> > +#else
> > +typedef u32 dma_addr_t;
> > +#endif /* 64 bit DMA pointer */
> 
> Is there any specific reason why dma_addr_t is in <asm/types.h>, while
> phys_addr_t is in
> <linux/types.h>?

dma_addr_t is a big mess that was traditionally defined per
architecture, in lots of wrong ways, including the misconception
of dma64_addr_t. Sparc64 still uses a 32 bit dma_addr_t, possibly
because it always uses an IOMMU (?). It can save some space in
scatterlists, but might come back to bite us if someone tries
to build a sparc64 system with actual 64-bit DMA.

phys_addr_t is a new definition that was added last August (after
I did my patch) by Jeremy Fitzhardinge and is for DMA purposes.

> Furthermore, CONFIG_PHYS_64BIT is used on PPC only. Probably it should be
> replaced by CONFIG_PHYS_ADDR_T_64BIT, which is always set if CONFIG_64BIT,
> so the #ifdef above becomes even simpler?

Yes, they could be consolidated now, which would make the default
dma_addr_t the same as phys_addr_t, with the possible exception of
sparc64.

	Arnd <><
