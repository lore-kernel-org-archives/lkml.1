Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbXJFIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbXJFIr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 04:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXJFIru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 04:47:50 -0400
Received: from smtp118.plus.mail.mud.yahoo.com ([209.191.106.149]:47615 "HELO
	smtp118.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752880AbXJFIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 04:47:49 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2007 04:47:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=Ryxv9OnKcDQ33vIqFEGkKGr0+ksCGqP0/ktFtr1pbjp0n9/qkc1S9yphBFUnnhWL6xA/MJjh+WNu90CCpCVJS7Wq43tEiF8OHRVNUFvgQ93Pgt1bka7IeORFfpc8nVJf7yHLLJQdDILOdB8VhsEcDLzKwz4P+zIjVDWkO7OFAR4=  ;
X-YMail-OSG: jzBoeI8VM1lHo3EgaX2G7JwLieqacQ1KwMb6CnTSsvs8HbZM4b3gRCkhSYArKinLXlp752JktQ--
Date: Sat, 6 Oct 2007 10:37:35 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       muli@il.ibm.com, satyam@infradead.org, amitkale@netxen.com,
       achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
Message-ID: <20071006083734.GB8930@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070918194647.GA23800@gollum.tnic> <20071005124705.6584e2f9.akpm@linux-foundation.org> <4706A20A.5060603@goop.org> <20071005140050.655b7727.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071005140050.655b7727.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 02:00:50PM -0700, Andrew Morton wrote:
> On Fri, 05 Oct 2007 13:43:54 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Andrew Morton wrote:
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > >
> > > Now that we have DMA_BIT_MASK(), these macros are pointless.
> > >   
> > 
> > Except, unfortunately, DMA_64BIT_MASK.  I guess we could special case
> > it, assuming this works in all the contexts the macro is used in (ie,
> > compile-time constant?):
> > 
> > #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
> > 
> 
> doh.  Thanks.
> 
> --- a/include/linux/dma-mapping.h~stop-using-dma_xxbit_mask-fix
> +++ a/include/linux/dma-mapping.h
> @@ -13,7 +13,7 @@ enum dma_data_direction {
>  	DMA_NONE = 3,
>  };
>  
> -#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
> +#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
>  
>  /*
>   * NOTE: do not use the below macros in new code and do not add new definitions
> @@ -21,7 +21,7 @@ enum dma_data_direction {
>   *
>   * Instead, just open-code DMA_BIT_MASK(n) within your driver
>   */
> -#define DMA_64BIT_MASK	(~0ULL)
> +#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
>  #define DMA_48BIT_MASK	DMA_BIT_MASK(48)
>  #define DMA_47BIT_MASK	DMA_BIT_MASK(47)
>  #define DMA_40BIT_MASK	DMA_BIT_MASK(40)
>

Hi and sorry for the late reply. IMHO, this solution is the most concise and still
clear enough a macro to understand what it does after a quick scan (unlike
uglies like IO_COND() in lib/iomap.cπ, :)) And, as a next step, we probably
should do

perl -pi -e 's/DMA_(..)BIT_MASK/DMA_BIT_MASK($1)/g' *

after removing the #define DMA_..BIT_MASK defines in /include/linux/dma-mapping.h
and the other two headers in the original patch after the x86 merge.
Current git (9f34073b4e54ad58541e0e2b4a87f4f6c1460e21) contains about 394
instances of usage of those macros, including the #definitions.


π this is not a flame!
-- 
Regards/Gruﬂ,
    Boris.
