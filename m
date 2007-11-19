Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbXKSVT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbXKSVT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXKSVTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:19:49 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42778 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXKSVTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:19:48 -0500
Subject: Re: [PATCH] Cast page_to_pfn to unsigned long in CONFIG_SPARSEMEM
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071119130801.bd7b7021.akpm@linux-foundation.org>
References: <20071113194025.150641834@polymtl.ca>
	 <1195160783.7078.203.camel@localhost> <20071115215142.GA7825@Krystal>
	 <1195164977.27759.10.camel@localhost> <20071116144742.GA17255@Krystal>
	 <1195495626.27759.119.camel@localhost> <20071119185258.GA998@Krystal>
	 <1195501381.27759.127.camel@localhost> <20071119195257.GA3440@Krystal>
	 <1195502983.27759.134.camel@localhost> <20071119202023.GA5086@Krystal>
	 <20071119130801.bd7b7021.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 13:19:43 -0800
Message-Id: <1195507183.27759.150.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 13:08 -0800, Andrew Morton wrote:
> 
> >  #else
> > -#define page_to_pfn __page_to_pfn
> > +#define page_to_pfn ((unsigned long)__page_to_pfn)
> >  #define pfn_to_page __pfn_to_page
> >  #endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
> 
> I'd have thought that __pfn_to_page() was the place to fix this: the
> lower-level point.  Because someone might later start using
> __pfn_to_page()
> for something.
> 
> Heaven knows why though - why does __pfn_to_page() even exist?

I think it's this stuff:
        
        #ifdef CONFIG_OUT_OF_LINE_PFN_TO_PAGE
        struct page *pfn_to_page(unsigned long pfn)
        {
                return __pfn_to_page(pfn);
        }
        unsigned long page_to_pfn(struct page *page)
        {
                return __page_to_pfn(page);
        }
        EXPORT_SYMBOL(pfn_to_page);
        EXPORT_SYMBOL(page_to_pfn);
        #endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
        
Which comes from:
        
        config OUT_OF_LINE_PFN_TO_PAGE
                def_bool X86_64
                depends on DISCONTIGMEM
        
and only on x86_64.  Perhaps it can go away with the
discontig->sparsemem-vmemmap conversion.

-- Dave


