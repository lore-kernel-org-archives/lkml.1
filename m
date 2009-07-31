Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbZGaJb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbZGaJb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZGaJb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:31:26 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53158 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZGaJbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=d3UEF+zer2ylLAvKWYQ1xb4s3Rld8XI2YpGbx1efu0/BcxH2Wx06xPQhRDxcLZvRS3
         fi8L/8k4mVwnksxIo3iYPQ4O7yBQW6YXj/if2AcjKKBuTOJfsymfczlk4B6Lgi5j4+Js
         vXjzKg+db7kXHD/q8eejDL37skDmfvbELVZuQ=
Date: Fri, 31 Jul 2009 12:32:19 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ttm: Fix ttm in-kernel copying of pages with
 non-standard caching attributes.
Message-ID: <20090731123219.2961640e@iki.fi>
In-Reply-To: <4A72B28D.8050801@shipmail.org>
References: <1248422254-32193-1-git-send-email-thellstrom@vmware.com>
	<1248422254-32193-2-git-send-email-thellstrom@vmware.com>
	<20090730190010.649589ba@iki.fi>
	<4A72B28D.8050801@shipmail.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 10:59:57 +0200
Thomas Hellström <thomas@shipmail.org> wrote:

> Pekka Paalanen wrote:
> >> @@ -145,17 +146,35 @@ static int ttm_copy_io_ttm_page(struct ttm_tt *ttm, void *src,
> >>  		return -ENOMEM;
> >>  
> >>  	src = (void *)((unsigned long)src + (page << PAGE_SHIFT));
> >> -	dst = kmap(d);
> >> +
> >> +#ifdef CONFIG_X86
> >> +	dst = kmap_atomic_prot(d, KM_USER0, prot);
> >> +#else
> >> +	if (prot != PAGE_KERNEL)
> >> +		dst = vmap(&d, 1, 0, prot);
> >> +	else
> >> +		dst = kmap(d);
> >> +#endif
> >>     
> >
> > What are the implications of choosing the non-CONFIG_X86 path
> > even on x86?
> >   
> 
> The only implication is a slowdown if dealing with highmem pages or 
> pages with
> a non standard caching policy. Also you need the patch I just posted to 
> dri-devel / lkml to make it compile.
> I should've done more thorough testing of the non-x86 path.
> 
> > Is kmap_atomic_prot() simply an optimization allowed by the x86
> > arch, and the alternate way also works, although it uses the
> > precious vmalloc address space?
> >   
> 
> Exactly, although it's only using one page out of vmalloc space and for 
> the time it
> takes to copy a page to / from io.
> 
> > Since kmap_atomic_prot() is not exported on earlier kernels,
> > I'm tempted to just do the non-CONFIG_X86 path.
> >   
> For compat I think that should be fine. If your driver is using 
> accelerated copy to / from
> VRAM, you shouldn't even hit this path.

Okay, thank you very much.

-- 
Pekka Paalanen
http://www.iki.fi/pq/

