Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYC1Sfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYC1Sfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYC1SfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:35:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51873 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756963AbYC1SfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:35:13 -0400
Date: Fri, 28 Mar 2008 11:33:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl>
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Linus Torvalds wrote:

> Totally irrelevant.
> 
> The page allocation path does
> 
>         if (gfp_flags & __GFP_ZERO)
>                 prep_zero_page(page, order, gfp_flags);
> 
> and that will cause a warning REGARDLESS of whether the page is a HIGHMEM 
> page or not.


prep_zero_page does:

static inline void prep_zero_page(struct page *page, int order, gfp_t 
gfp_flags)
{
        int i;

        /*
         * clear_highpage() will use KM_USER0, so it's a bug to use __GFP_ZERO
         * and __GFP_HIGHMEM from hard or soft interrupt context.
         */
        VM_BUG_ON((gfp_flags & __GFP_HIGHMEM) && in_interrupt());
        for (i = 0; i < (1 << order); i++)
                clear_highpage(page + i);
}

So we forbit __GFP_HIGHMEM and in_interrupt which makes sense. The simple 
forwarding of large kmallocs to the page allocator as done by SLUB / SLOB 
is fine.

Then clear_highpage calls additional checking functions that have 
the effect of generally forbiding zeroing in interrupt context if 
CONFIG_HIGHMEM is set. This is wrong and needs to be fixed.

> And the fact is, passing in GFP_ZERO from the SLUB code is a bug 
> regardless, because it unnecessarily does the dual memset().

Well that is only the fallback path of __slab_alloc which is not triggered 
here and not performance sensitive. We could clear the flag there but 
that is irrevelant for this issue.
