Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXIUTkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXIUTkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761427AbXIUTkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:40:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761421AbXIUTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:40:00 -0400
Date: Fri, 21 Sep 2007 12:40:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <Pine.LNX.4.64.0709211221560.17698@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.999.0709211235220.16478@woody.linux-foundation.org>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211221560.17698@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Sep 2007, Christoph Lameter wrote:
> > The only way to fix it would be to integrate the quicklist stuff *with* 
> > the mmu_gather stuff, so that these kinds of implementation issues are 
> > explicitly shown in the relationship, instead of havign two "independent" 
> > pieces of code where one piece very subtly depends on the exact 
> > implementation of the other.
> 
> Right. But will that not mean that quicklists would have to be used on all 
> platforms in a generic way?

No. Each architecture can already choose how it does its own "mmu_gather".

*IF* the architecture uses a per-cpu variable for this, *THEN* the 
architecture could also embed a "quicklist" in that per-cpu variable, and 
make use of that. If you were to do it that way, it would all work fine. 

So for example, if you actually want to use quicklists in the "generic" 
TLB-gather implementation, you should replace the

	struct page *pages[FREE_PTE_NR];

entry in the "struct mmu_gather" with a set of quicklists instead. 

Or, alternatively, you could decide to not use the generic version at all, 
and instead do a per-architecture one that uses the quicklists.

The problem with that commit that I just reverted was that it mixed the 
two, but not completely. It still kept them separate.

		Linus
