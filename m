Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbXIUTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbXIUTU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbXIUTUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:20:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760281AbXIUTUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:20:51 -0400
Date: Fri, 21 Sep 2007 12:21:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Sep 2007, Christoph Lameter wrote:
> 
> The final flush does only check if there are too many pages on the
> quicklists. Otherwise the quicklist is not dumped/freed (unlike the
> mmu_gather list) but kept for the following page table page allocations
> since we have cache hot cpu objects there.

Yeah, and the whole thing seems totally bogus. It totally depends on 
mmu_gather doing everything right (which very much includes the dependency 
on mmu gathering disabling preempt).

For exmaple, if we were to go back to the original small tlb_gather with a 
simple quicklist on the stack, rather than the per-cpu datastructure, the 
quicklists would immediately break horribly - simply because they are 
incorrectly now depending on the internal semantics of that tlb-gather.

As it is, the quicklists try to be something separate, but by virtue of 
being separate, they will always be buggy.

The only way to fix it would be to integrate the quicklist stuff *with* 
the mmu_gather stuff, so that these kinds of implementation issues are 
explicitly shown in the relationship, instead of havign two "independent" 
pieces of code where one piece very subtly depends on the exact 
implementation of the other.

		Linus
