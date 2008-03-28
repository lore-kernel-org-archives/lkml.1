Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbYC1EBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbYC1EBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbYC1EBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:01:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbYC1EBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:01:00 -0400
Date: Thu, 27 Mar 2008 21:00:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org> <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2008, Christoph Lameter wrote:
> 
> Slab allocations can never use GFP_HIGHMEM.

Totally irrelevant.

The page allocation path does

        if (gfp_flags & __GFP_ZERO)
                prep_zero_page(page, order, gfp_flags);

and that will cause a warning REGARDLESS of whether the page is a HIGHMEM 
page or not.

And the fact is, passing in GFP_ZERO from the SLUB code is a bug 
regardless, because it unnecessarily does the dual memset().

So here's a damn big clue:
 - SLUB does its own GFP_ZERO handling
 - so passing GFP_ZERO down to the page allocator is a f*cking bug
 - and this has NOTHING what-so-ever to do with GFP_HIGHMEM or even 
   whether the warning is "valid" or not - it's a bug even if the warning 
   had never happened.

So stop blathering, and just admit that this was buggy. It was also 
fundamentally fragile to leave GFP_ZERO around when it was known to not be 
valid at that point (exactly because GFP_ZERO was handled by the caller).

		Linus
