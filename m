Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbZD2LgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbZD2LgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbZD2LgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:36:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbZD2LgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:36:11 -0400
Date: Wed, 29 Apr 2009 13:36:05 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sachin Sant <sachinp@in.ibm.com>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090429113604.GE3398@wotan.suse.de>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 02:22:06PM +0300, Pekka Enberg wrote:
> Nick,
> 
> Here's another one. I think we need to either fix these rather quickly
> or make SLUB the defaut for linux-next again so we don't interfere
> with other testing.
> 
>                                      Pekka
> 
> On Tue, Apr 28, 2009 at 2:10 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
> > Today's next tree fails to boot on variety of powerpc boxes (Power5, power6)
> >
> > Memory: 3882624k/4194304k available (8384k kernel code, 311680k reserved,
> > 2048k data, 4285k bss, 512k init)
> > Kernel panic - not syncing: kmem_cache_create(): failed to create slab
> > `kmalloc'
> >
> > Call Trace:
> > [c000000000a33c30] [c000000000011668] .show_stack+0x6c/0x16c (unreliable)
> > [c000000000a33ce0] [c000000000563c8c] .panic+0x80/0x1a8
> > [c000000000a33d70] [c0000000001410d8] .kmem_cache_open+0x4e8/0x51c
> > [c000000000a33e20] [c0000000007d90b8] .kmem_cache_init+0x264/0x35c
> > [c000000000a33ee0] [c0000000007b0b68] .start_kernel+0x404/0x51c
> > [c000000000a33f90] [c0000000000083d8] .start_here_common+0x1c/0x44

OK I think the problem is that with 64K pages you get a default MAX_ORDER
of 9, and slqb is trying to create slabs which exceed that size..

Does this help?
---

SLQB: fix slab calculation

SLQB didn't consider MAX_ORDER when defining which sizes of kmalloc
slabs to create. It panics at boot if it tries to create a cache
which exceeds MAX_ORDER-1.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/include/linux/slqb_def.h
===================================================================
--- linux-2.6.orig/include/linux/slqb_def.h	2009-04-29 21:27:30.000000000 +1000
+++ linux-2.6/include/linux/slqb_def.h	2009-04-29 21:28:13.000000000 +1000
@@ -172,7 +172,8 @@ struct kmem_cache {
 #endif
 
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
-#define KMALLOC_SHIFT_SLQB_HIGH (PAGE_SHIFT + 9)
+#define KMALLOC_SHIFT_SLQB_HIGH ((PAGE_SHIFT + 9) < MAX_ORDER ? \
+				(PAGE_SHIFT + 9) : (MAX_ORDER - 1))
 
 extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_SLQB_HIGH + 1];
 extern struct kmem_cache kmalloc_caches_dma[KMALLOC_SHIFT_SLQB_HIGH + 1];

