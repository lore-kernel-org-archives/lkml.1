Return-Path: <linux-kernel-owner+w=401wt.eu-S1763186AbXEPRjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763186AbXEPRjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbXEPRjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:39:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:8538 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbXEPRjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qY2IozNLsE688yKqC2LwSTd3lda8WV9CgKu2s5aexlU9mqIx+Sebf4MzGlH+rR7Smy2bh2+CEjLTv/Vj+RDOnIWvFWdFs+/czQ7Uf92ElWZX0Oi8cHvarWW1PwLS7KeSZP/qe7f/lk/+y2eLsyV63L2DR4huSh58FnarmnPnsr8=
Message-ID: <a781481a0705161039v56ae211di8b6e5b92d3dec93@mail.gmail.com>
Date: Wed, 16 May 2007 23:09:11 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Pagecache zeroing: zero_user_segment, zero_user_segments and zero_user
Cc: "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Nate Diller" <nate.diller@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070515202442.eeaa49a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com>
	 <20070515202442.eeaa49a0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > 2. It has a useless parameter specifying the kmap slot.
> >    The functions above default to KM_USER0 which is also always used when
> >    zero_user_page was called except in one single case. We open code that
> >    single case to draw attention to the spot.
> >
>
> Dunno.  fwiw, we decided to _not_ embed KM_USER0 in the callee: we have had
> some pretty ghastly bugs in the past due to misuse of kmap slots so the
> idea was to shove the decision into the caller's face, make them think
> about what they're doing

Christoph hasn't really _replaced_ any !KM_USER0 case with
KM_USER0 in this patch. AFAIR, we had originally decided to not
embed KM_USER0 in zero_user_page because of this complaint
from Anton Altaparmakov:
http://lkml.org/lkml/2007/4/10/62

But Christoph's patch here seems to have left that fs/ntfs/aops.c case
alone, and used the zero_xxx helpers only for KM_USER0 cases, so
we should probably be safe.

> > +static inline void zero_user_segments(struct page *page,
> > +     unsigned start1, unsigned end1,
> > +     unsigned start2, unsigned end2)
> > +{
> > +     void *kaddr = kmap_atomic(page, KM_USER0);
> > +
> > +     BUG_ON(end1 > PAGE_SIZE ||
> > +             end2 > PAGE_SIZE);
> > +
> > +     if (end1 > start1)
> > +             memset(kaddr + start1, 0, end1 - start1);
> > +
> > +     if (end2 > start2)
> > +             memset(kaddr + start2, 0, end2 - start2);
> > +
> > +     flush_dcache_page(page);
> > +     kunmap_atomic(kaddr, KM_USER0);
> > +}
>
> For some reason we've always done the flush_dcache_page() while holding the
> kmap.  There's no reason for doing it this way and it just serves to worsen
> scheduling latency a tiny bit.

Wonder if any arch requires a valid mapping when doing the flush?

(reading Documentation/cachetlb.txt)

Documentation/cachetlb.txt is silent on whether flush_dcache_page()
really must be called before a kunmap(), but mentions that
flush_kernel_dcache_page() _must_ be called _before_ kunmap.
And I saw that parisc implements flush_dcache_page() using
flush_kernel_dcache_page itself (but then, we've not implemented a
meaningful kmap for parisc in the first place), so we've _just_
managed to be fine here ...

Still, flush_dcache_page() before kunmap'ing is an old practice,
would be wise to get this whetted by linux-arch first?

Satyam
