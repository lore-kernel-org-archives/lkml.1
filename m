Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYARCYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYARCYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbYARCYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:24:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:12443 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYARCY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZFy16SzPE4kYDCwViBf6j8CT4A2I8LFL010mv7dBRqRmbMjeKlL0Ctv9EaiebaFHR3WdegX+mOFUHz8gLeZA/Tir9S8eE2xs8sDO5c4493KCHpirWowFzXH+nXMCoJo4/I/+Zb68xdayP+6OLfqDsyuqEXsGvQtHGxW5T4O7Ors=
Subject: Re: [mm patch] i915: fix invalid opcode exception on cpus without
	clflush
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, akpm@linux-foundation.org,
       airlied@linux.ie, linux-kernel@vger.kernel.org
In-Reply-To: <479008E5.1070706@zytor.com>
References: <20080117235203.GB21681@phobos.i.cabal.ca>
	 <479008E5.1070706@zytor.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 18:24:28 -0800
Message-Id: <1200623068.5724.111.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-17 at 21:03 -0500, H. Peter Anvin wrote:
> Kyle McMartin wrote:
> > i915_flush_ttm was unconditionally executing a clflush instruction
> > to (obviously) flush the cache. Instead, check if the cpu supports
> > clflush, and if not, fall back to calling wbinvd to flush the entire
> > cache.
> > 
> > Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
> > 
> > --- a/drivers/char/drm/i915_buffer.c
> > +++ b/drivers/char/drm/i915_buffer.c
> > @@ -286,7 +286,18 @@ void i915_flush_ttm(struct drm_ttm *ttm)
> >  		return;
> >  
> >  	DRM_MEMORYBARRIER();
> > +
> > +#ifdef CONFIG_X86_32
> > +	/* Hopefully nobody has built an x86-64 processor without clflush */
> > +	if (!cpu_has_clflush) {
> > +		wbinvd();
> > +		DRM_MEMORYBARRIER();
> > +		return;
> > +	}
> > +#endif
> > +
> >  	for (i = ttm->num_pages - 1; i >= 0; i--)
> >  		drm_cache_flush_page(drm_ttm_get_page(ttm, i));
> > +
> >  	DRM_MEMORYBARRIER();
> >  }
> 
> The #ifdef is bogus.  If it's required, it should go into 
> asm-x86/required_features.h and then cpu_has_clflush is static; 
> otherwise it's just plain wrong.

I think Andi's CPA patches have some changes regarding wbinvd and
clflush handling, perhaps you can leverage some of his work?

Harvey

