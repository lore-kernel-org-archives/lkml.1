Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYGNEpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYGNEpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYGNEpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:45:10 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:32703 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751494AbYGNEpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:45:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=f1n04BN83KwbZ2FV+vGnU2Sz1Uo3uqSqZyf7zL/LX7Mh1GkX6XGiuEA/1E9IlVYNq/D9SED3x3q1Qs0+RHLb3OIpfkyZ9C6qbPNNa14eSC0BRuJHDrc8jylsSp0ph7+wMLnv8eJKpZXOkz338lFVwZIGD0uqpXhnOiN9p+LmznI=  ;
X-YMail-OSG: tGDUtwEVM1nMqWDq3_CKSFkxtICIg1ZMbzYr61T3Pdt8F4ybSQpbhZ8QGxYNntFJxdSAkmVgWUWdmNgWYiV3KoPu_echbuErjOMl_7YOgxJlo6zz1oCi33q2DypmqF8tVok-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: SL*B: drop kmem cache argument from constructor
Date: Mon, 14 Jul 2008 14:44:57 +1000
User-Agent: KMail/1.9.5
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
References: <20080710011132.GA8327@martell.zuzino.mipt.ru> <48763C60.9020805@linux.vnet.ibm.com> <20080711122228.eb40247f.akpm@linux-foundation.org>
In-Reply-To: <20080711122228.eb40247f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141444.57802.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 July 2008 05:22, Andrew Morton wrote:
> On Thu, 10 Jul 2008 11:44:16 -0500 Jon Tollefson <kniht@linux.vnet.ibm.com> 
wrote:
> > Alexey Dobriyan wrote:
> > > Kmem cache passed to constructor is only needed for constructors that
> > > are themselves multiplexeres. Nobody uses this "feature", nor does
> > > anybody uses passed kmem cache in non-trivial way, so pass only pointer
> > > to object.
> > >
> > > Non-trivial places are:
> > > 	arch/powerpc/mm/init_64.c
> > > 	arch/powerpc/mm/hugetlbpage.c
> >
> > ...<snip>...
> >
> > > --- a/arch/powerpc/mm/hugetlbpage.c
> > > +++ b/arch/powerpc/mm/hugetlbpage.c
> > > @@ -595,9 +595,9 @@ static int __init hugepage_setup_sz(char *str)
> > >  }
> > >  __setup("hugepagesz=", hugepage_setup_sz);
> > >
> > > -static void zero_ctor(struct kmem_cache *cache, void *addr)
> > > +static void zero_ctor(void *addr)
> > >  {
> > > -	memset(addr, 0, kmem_cache_size(cache));
> > > +	memset(addr, 0, HUGEPTE_TABLE_SIZE);
> >
> > This isn't going to work with the multiple huge page size support.  The
> > HUGEPTE_TABLE_SIZE macro now takes a parameter with of the mmu psize
> > index to indicate the size of page.
>
> hrm.  I suppose we could hold our noses and use ksize(), assuming that
> we're ready to use ksize() at this stage in the object's lifetime.
>
> Better would be to just use kmem_cache_zalloc()?

As this is hugepages we're talking about, probably yes. But note that
page tables are one of those things where we (I?) think constructors are
probably a good idea -- they tend to be very sparse.
