Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZCSAGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZCSAGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 20:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZCSAGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 20:06:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53601 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZCSAGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 20:06:25 -0400
Date: Thu, 19 Mar 2009 09:04:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 24/27] Convert gfp_zone() to use a table of
 precalculated values
Message-Id: <20090319090456.fb11e23c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090318194604.GD24462@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
	<1237226020-14057-25-git-send-email-mel@csn.ul.ie>
	<alpine.DEB.1.10.0903161500280.20024@qirst.com>
	<20090318135222.GA4629@csn.ul.ie>
	<alpine.DEB.1.10.0903181011210.7901@qirst.com>
	<20090318153508.GA24462@csn.ul.ie>
	<alpine.DEB.1.10.0903181300540.15570@qirst.com>
	<20090318181717.GC24462@csn.ul.ie>
	<alpine.DEB.1.10.0903181507120.10154@qirst.com>
	<20090318194604.GD24462@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 19:46:04 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, Mar 18, 2009 at 03:07:48PM -0400, Christoph Lameter wrote:
> > On Wed, 18 Mar 2009, Mel Gorman wrote:
> > 
> > > Thanks.At a quick glance, it looks ok but I haven't tested it. As the intention
> > > was to get one pass of patches that are not controversial and are "obvious",
> > > I have dropped my version of the gfp_zone patch and the subsequent flag
> > > cleanup and will revisit it after the first lot of patches has been dealt
> > > with. I'm testing again with the remaining patches.
> > 
> > This fixes buggy behavior of gfp_zone so it would deserve a higher
> > priority.
> > 
> 
> It is buggy behaviour in response to a flag combination that makes no sense
> which arguably is a buggy caller. Now that I get to think about it a bit more,
> you can't define a const table in a header. If it's declared extern, then
> the compiler doesn't know what the constant value is so it can't generate
> better code.  At best, you end up with equivalent code to what my patch did
> in the first place except __GFP_DMA32|__GFP_HIGHMEM will return ZONE_NORMAL.
> 

I wonder why you have to make the bad caller work insane way ?
Is this bad ?
==
const int gfp_zone_table[GFP_ZONEMASK] = {
	ZONE_NORMAL,		/* 00 No flags set */
	ZONE_DMA,		/* 01 Only GFP_DMA set */
	ZONE_HIGHMEM,		/* 02 Only GFP_HIGHMEM set */
	BAD_ZONE,		/* 03 GFP_HIGHMEM and GFP_DMA set */
	ZONE_DMA32,		/* 04 Only GFP_DMA32 set */
	BAD_ZONE,		/* 05 GFP_DMA and GFP_DMA32 set */
	BAD_ZONE,		/* 06 GFP_DMA32 and GFP_HIGHMEM set */
	BAD_ZONE,		/* 07 GFP_DMA, GFP_DMA32 and GFP_DMA32 set */
	ZONE_MOVABLE,		/* 08 Only ZONE_MOVABLE set */
	ZONE_DMA,		/* 09 MOVABLE + DMA */
	ZONE_MOVABLE,		/* 0A MOVABLE + HIGHMEM */
	BAD_ZONE,		/* 0B MOVABLE + DMA + HIGHMEM */
	ZONE_DMA32,		/* 0C MOVABLE + DMA32 */
	BAD_ZONE,		/* 0D MOVABLE + DMA + DMA32 */
	BAD_ZONE,		/* 0E MOVABLE + DMA32 + HIGHMEM */
	BAD_ZONE		/* 0F MOVABLE + DMA32 + HIGHMEM + DMA
};
==

Thanks,
-Kame



> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

