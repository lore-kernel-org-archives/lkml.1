Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZHBTUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZHBTUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZHBTUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:20:17 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:46600 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbZHBTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=P4jlU2yYmMXA4cB1dbRv0o9j6TxjAUJlOJ8JBhkCs/W9awG2vMHq5NcYcNLgHBLqfI
         V/yfPZQtyF2dDhPT5siuGNMZFvYrdjNIRKAw/Dudgl19ryfnTIrG5Ve8RdDmUTxNQ687
         Mv3FFY8Pozk9MalPJoUax9sEz+1kIvuXVboQE=
Date: Sun, 2 Aug 2009 22:21:13 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thellstrom@vmware.com>
Cc: "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] ttm: Fix a potential comparison of structs.
Message-ID: <20090802222113.0738d5a1@iki.fi>
In-Reply-To: <4A75D702.6010804@vmware.com>
References: <1249030071-17763-1-git-send-email-thellstrom@vmware.com>
	<20090802203643.5b638eb6@iki.fi>
	<4A75D702.6010804@vmware.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Aug 2009 20:12:18 +0200
Thomas Hellström <thellstrom@vmware.com> wrote:

> Pekka Paalanen skrev:
> > From 5e2851952729b287a82efa002b28a2095404d44d Mon Sep 17 00:00:00 2001
> > From: Thomas Hellstrom <thellstrom@vmware.com>
> > Date: Fri, 31 Jul 2009 10:47:51 +0200
> > Subject: [PATCH] ttm: Fix a potential comparison of structs.
> >
> > On some architectures the comparison may cause a compilation failure.
> >
> > Original partial fix Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> >
> > Signed-off-by: Pekka Paalanen <pq@iki.fi>
> > ---
> >
> > Thomas, you forgot two more of these :-)
> > Here's a patch that actually compiles on x86_64.
> >   
> 
> Pekka,
> Thanks for fixing this! (Just for clarity, i assume you mean that the 
> non-x86 part now compiles on x86?)

Ah yes, that's what I mean. I changed the #ifdefs for my compat fix in
http://cgit.freedesktop.org/nouveau/linux-2.6/log/?h=master-compat
and tried compiling it the both ways.

> Dave, is there a chance to have this in 2.6.31? Compilation errors are 
> bad, although probably nobody has been hitting this yet..

Well, Nouveau master-compat users would have hit it, but I added your
fix, too. Users with x86_32 highmem kernels already hit the
kmap_atomic_prot not exported bug while building the latest DRM,
TTM and Nouveau bits against distro kernels.

So yeah, no-one anyone (else) would care about ;-)


Thanks.

> 
> /Thomas
> 
> >  drivers/gpu/drm/ttm/ttm_bo_util.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
> > index f4e2eba..999fbe7 100644
> > --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> > +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> > @@ -151,7 +151,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
> >  #ifdef CONFIG_X86
> >  	dst = kmap_atomic_prot(d, KM_USER0, prot);
> >  #else
> > -	if (prot != PAGE_KERNEL)
> > +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
> >  		dst = vmap(&d, 1, 0, prot);
> >  	else
> >  		dst = kmap(d);
> > @@ -164,7 +164,7 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
> >  #ifdef CONFIG_X86
> >  	kunmap_atomic(dst, KM_USER0);
> >  #else
> > -	if (prot != PAGE_KERNEL)
> > +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
> >  		vunmap(dst);
> >  	else
> >  		kunmap(d);
> > @@ -187,7 +187,7 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
> >  #ifdef CONFIG_X86
> >  	src = kmap_atomic_prot(s, KM_USER0, prot);
> >  #else
> > -	if (prot != PAGE_KERNEL)
> > +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
> >  		src = vmap(&s, 1, 0, prot);
> >  	else
> >  		src = kmap(s);
> > @@ -200,7 +200,7 @@ static int ttm_copy_ttm_io_page(struct ttm_tt *ttm, void *dst,
> >  #ifdef CONFIG_X86
> >  	kunmap_atomic(src, KM_USER0);
> >  #else
> > -	if (prot != PAGE_KERNEL)
> > +	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL))
> >  		vunmap(src);
> >  	else
> >  		kunmap(s);

-- 
Pekka Paalanen
http://www.iki.fi/pq/

