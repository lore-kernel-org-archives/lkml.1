Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZEVPG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZEVPG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZEVPGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:06:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZEVPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:06:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
Date: Fri, 22 May 2009 17:05:53 +0200
User-Agent: KMail/1.9.9
Cc: jgarzik@pobox.com, hancockrwd@gmail.com, htejun@gmail.com,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp,
       grundler@google.com
References: <200905191822.48420.arnd@arndb.de> <200905221607.34025.arnd@arndb.de> <20090522233846I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090522233846I.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221705.54426.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+nXe/5mcVitTKNlSk/dhC9R6I0bFZ7F9zkN3t
 YQwxhH4eCqQejgd3M8yuCcZV/kHpQNBgX+K+BUEQX0pgaYFYpt
 Cei0Fci0kdP23F1QXYR4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 May 2009, FUJITA Tomonori wrote:
> I'm not sure. And only mips internally uses CONFIG_DMA_COHERENT.
> 
> The reason why many architectures need architecture-specific
> alloc_coherent() is not about coherent or not.
> 
> I like a new helper header file having only generic functions without
> any ifdef.

Ok, fair enough. Fixing dma_alloc_coherent to handle
coherent_dma_mask and debug_dma correctly would also
make it even bigger, and it was already doing more than
you'd want from a commonly used inline function.
It may be useful to put it into kernel/dma-coherent.c
under an #ifdef, but I'll leave this one alone for now.

I'll leave dma_alloc_coherent and dma_free_coherent
as extern declarations then, and leave out the
simple dma_coherent_dev() and dma_cache_sync() that
all architectures would need to override.

dma_get_cache_alignment() is still less generic than
the other functions, as this is still architecture
specific. Should I leave that out as well then?

One more idea I had was to rename all the functions in
this file from dma_* to dma_linear_*. This would mean
that all architectures using it would still need to
do something like #define dma_map_sg dma_linear_map_sg
for each function they want to use but can easily chose
to provide their own ones for those they need different.

It might also help architectures that work with dma_ops,
which could then define their own
struct dma_ops dma_ops_linear = {
	.map_single = dma_linear_map_single,
	.map_sg = dma_linear_map_sg,
	...
};

Would you prefer me to do it this way, or just keep the
standard function names as in the current patch?

	Arnd <><
