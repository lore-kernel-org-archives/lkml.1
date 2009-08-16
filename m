Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZHPVto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZHPVto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbZHPVtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:49:43 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:63190 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755545AbZHPVtl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:49:41 -0400
Subject: Re: [PATCH] kmemleak: Ignore the aperture memory hole on x86_64
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090816100820.GA26474@elte.hu>
References: <20090812205215.GA21451@elte.hu>
	 <1250289913.5085.17.camel@pc1117.cambridge.arm.com>
	 <1250290118.5085.21.camel@pc1117.cambridge.arm.com>
	 <20090816100820.GA26474@elte.hu>
Content-Type: text/plain; charset=utf-8
Organization: ARM Ltd
Date: Sun, 16 Aug 2009 22:48:55 +0100
Message-Id: <1250459335.8085.12.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Aug 2009 21:48:56.0048 (UTC) FILETIME=[5A8E6700:01CA1EBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 12:08 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> > index 676debf..cb690b3 100644
> > --- a/arch/x86/kernel/aperture_64.c
> > +++ b/arch/x86/kernel/aperture_64.c
> > @@ -94,6 +94,11 @@ static u32 __init allocate_aperture(void)
> >  	 * code for safe
> >  	 */
> >  	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
> > +	/*
> > +	 * Kmemleak should not scan this block as it may not be mapped via the
> > +	 * kernel direct mapping.
> > +	 */
> > +	kmemleak_ignore(p);
> 
> i tried this in -tip, it causes this build error:
> 
> arch/x86/kernel/aperture_64.c: In function ‘allocate_aperture’:
> arch/x86/kernel/aperture_64.c:101: error: implicit declaration of function ‘kmemleak_ignore’

Missing the #include. Here's the updated patch:


kmemleak: Ignore the aperture memory hole on x86_64

From: Catalin Marinas <catalin.marinas@arm.com>

This block is allocated with alloc_bootmem() and scanned by kmemleak but
the kernel direct mapping may no longer exist. This patch tells kmemleak
to ignore this memory hole.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/aperture_64.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 676debf..128111d 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -20,6 +20,7 @@
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/suspend.h>
+#include <linux/kmemleak.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/iommu.h>
@@ -94,6 +95,11 @@ static u32 __init allocate_aperture(void)
 	 * code for safe
 	 */
 	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
+	/*
+	 * Kmemleak should not scan this block as it may not be mapped via the
+	 * kernel direct mapping.
+	 */
+	kmemleak_ignore(p);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%p,%uK)\n",

Thanks.

-- 
Catalin

