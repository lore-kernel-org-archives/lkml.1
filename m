Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbZH2ObH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbZH2ObH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 10:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZH2ObG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 10:31:06 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39458 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbZH2ObF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 10:31:05 -0400
Subject: Re: [PATCH 2/2] kmemleak: Ignore the aperture memory hole on x86_64
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090829133152.GC24123@elte.hu>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
	 <20090827170258.27901.83613.stgit@pc1117.cambridge.arm.com>
	 <20090829133152.GC24123@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Sat, 29 Aug 2009 15:30:08 +0100
Message-Id: <1251556208.5518.5.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Aug 2009 14:30:08.0954 (UTC) FILETIME=[35C169A0:01CA28B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-29 at 15:31 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > --- a/arch/x86/kernel/aperture_64.c
> > +++ b/arch/x86/kernel/aperture_64.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/bitops.h>
> >  #include <linux/ioport.h>
> >  #include <linux/suspend.h>
> > +#include <linux/kmemleak.h>
> >  #include <asm/e820.h>
> >  #include <asm/io.h>
> >  #include <asm/iommu.h>
> > @@ -94,6 +95,11 @@ static u32 __init allocate_aperture(void)
> >  	 * code for safe
> >  	 */
> >  	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
> > +	/*
> > +	 * Kmemleak should not scan this block as it may not be mapped via the
> > +	 * kernel direct mapping.
> > +	 */
> > +	kmemleak_ignore(p);
> >  	if (!p || __pa(p)+aper_size > 0xffffffff) {
> >  		printk(KERN_ERR
> >  			"Cannot allocate aperture memory hole (%p,%uK)\n",
> 
> This sure does not look right for the rare but theoretically 
> possible !p case, does it?

All the kmemleak_* callbacks check for (p && !IS_ERR(p)), just to
simplify the calling site.

-- 
Catalin

