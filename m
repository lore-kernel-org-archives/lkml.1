Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZBXEA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZBXEA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZBXEAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:00:12 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:46010 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751711AbZBXEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:00:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gjW0rFitQP8e2LjukMK4Am2vdSjWTT2qSg3xl2g4X9CuMME9G0G+KBAzS5dhK6tSCqeAdzuRAy0Nw4sLUY/tqFLBcrjHePfi3NRUBliuiz1GgqK2ji1wL5pnjG3dMWquSQ0RcXEF8b/NrpBXCfT8epql2oRRSzOe7RP9vGlIw2Q=  ;
X-YMail-OSG: ATQyN_kVM1nUfr6R40VUkh55Z.mf6mG1XWaqfDFogPAEpNe9ZKXn_WXlziRl3_jil2Ny4fkFxTUnd6PUMWdUkLf4GpqSXpSaub76axmn9e9t8u.t43IemOgNWJjy.IlTRmfqNlr9ZBYV455zgFs2YdNFnfMQfpDnEtwBXrK.NRWy_1wN9QQSIBDgb1hT_Gejg3ZXlGVh1PO63A6aOgmQx6V2
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of precalculated value
Date: Tue, 24 Feb 2009 14:59:34 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <20090223164047.GO6740@csn.ul.ie> <20090224103226.e9e2766f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090224103226.e9e2766f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241459.35435.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 12:32:26 KAMEZAWA Hiroyuki wrote:
> On Mon, 23 Feb 2009 16:40:47 +0000
>
> Mel Gorman <mel@csn.ul.ie> wrote:
> > On Mon, Feb 23, 2009 at 10:43:20AM -0500, Christoph Lameter wrote:
> > > On Tue, 24 Feb 2009, Nick Piggin wrote:
> > > > > Are you sure that this is a benefit? Jumps are forward and pretty
> > > > > short and the compiler is optimizing a branch away in the current
> > > > > code.
> > > >
> > > > Pretty easy to mispredict there, though, especially as you can tend
> > > > to get allocations interleaved between kernel and movable (or simply
> > > > if the branch predictor is cold there are a lot of branches on
> > > > x86-64).
> > > >
> > > > I would be interested to know if there is a measured improvement.
> >
> > Not in kernbench at least, but that is no surprise. It's a small
> > percentage of the overall cost. It'll appear in the noise for anything
> > other than micro-benchmarks.
> >
> > > > It
> > > > adds an extra dcache line to the footprint, but OTOH the instructions
> > > > you quote is more than one icache line, and presumably Mel's code
> > > > will be a lot shorter.
> >
> > Yes, it's an index lookup of a shared read-only cache line versus a lot
> > of code with branches to mispredict. I wasn't happy with the cache line
> > consumption but it was the first obvious alternative.
> >
> > > Maybe we can come up with a version of gfp_zone that has no branches
> > > and no lookup?
> >
> > Ideally, yes, but I didn't spot any obvious way of figuring it out at
> > compile time then or now. Suggestions?
>
> Assume
>   ZONE_DMA=0
>   ZONE_DMA32=1
>   ZONE_NORMAL=2
>   ZONE_HIGHMEM=3
>   ZONE_MOVABLE=4
>
> #define __GFP_DMA       ((__force gfp_t)0x01u)
> #define __GFP_DMA32     ((__force gfp_t)0x02u)
> #define __GFP_HIGHMEM   ((__force gfp_t)0x04u)
> #define __GFP_MOVABLE   ((__force gfp_t)0x08u)
>
> #define GFP_MAGIC (0400030102) ) #depends on config.
>
> gfp_zone(mask) = ((GFP_MAGIC >> ((mask & 0xf)*3) & 0x7)

Clever!

But I wonder if it is even valid to perform bitwise operations on
the zone bits of the gfp mask? Hmm, I see a few places doing it,
but if we stamped that out, we could just have a simple zone mask
that takes the zone idx out of the gfp, which would be slightly
simpler again and more extendible.

But if it's too hard to avoid the bitwise operations, then your idea
is pretty cool ;)

