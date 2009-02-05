Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZBEEAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZBEEAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 23:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZBED76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:59:58 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:21357 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751708AbZBED75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:59:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TVUgIxkn81TnBzthBrRDLWmsqZsCdVSe42FuCNTYyi4T7A/Jwq21u1vzZvmL9tbNfbd667jfKwTdIhUSdiSsZeb3feC2AsJm+CCARUvvSn/uZupooOYUj3wn3Gk4bSWcr5y3Yw3GOK5wOY8+GQvX+HnMrcfwi6RWCaq4Mgz54NQ=  ;
X-YMail-OSG: KT6MtOQVM1lxw1cST0R7WW5.n2rfOCyqdSHC0ns4gQXqW4DsYM12TWOhyO3ND7EuKKzZVCFZi7aZtTpa5dkwKFEDb1fvc35FTvDvmJ4UZnNa60z6ayjmfunYDUa1AxEVVkoz3tP4K5EXMSxBmrfGPNItIb11Ne.u3m4o8O5RggGVvH2KetaVPL0UOZ4L2A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch] SLQB slab allocator (try 2)
Date: Thu, 5 Feb 2009 14:59:29 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20090123154653.GA14517@wotan.suse.de> <200902041748.41801.nickpiggin@yahoo.com.au> <20090204152709.GA4799@csn.ul.ie>
In-Reply-To: <20090204152709.GA4799@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051459.30064.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 02:27:10 Mel Gorman wrote:
> On Wed, Feb 04, 2009 at 05:48:40PM +1100, Nick Piggin wrote:

> > It couldn't hurt, but it's usually tricky to read anything out of these
> > from CPU cycle profiles. Especially if they are due to cache or tlb
> > effects (which tend to just get spread out all over the profile).
>
> Indeed. To date, I've used them for comparing relative counts of things
> like TLB and cache misses on the basis "relatively more misses running test
> X is bad" or working out things like tlb-misses-per-instructions but it's a
> bit vague. We might notice if one of the allocators is being particularly
> cache unfriendly due to a spike in cache misses.

Very true. Total counts of TLB and cache misses could show some insight.


> PPC64 Test Machine
> Sysbench-Postgres
> -----------------
> Client           slab  slub-default  slub-minorder            slqb
>      1         1.0000        1.0153         1.0179          1.0051
>      2         1.0000        1.0273         1.0181          1.0269
>      3         1.0000        1.0299         1.0195          1.0234
>      4         1.0000        1.0159         1.0130          1.0146
>      5         1.0000        1.0232         1.0192          1.0264
>      6         1.0000        1.0238         1.0142          1.0088
>      7         1.0000        1.0240         1.0063          1.0076
>      8         1.0000        1.0134         0.9842          1.0024
>      9         1.0000        1.0154         1.0152          1.0077
>     10         1.0000        1.0126         1.0018          1.0009
>     11         1.0000        1.0100         0.9971          0.9933
>     12         1.0000        1.0112         0.9985          0.9993
>     13         1.0000        1.0131         1.0060          1.0035
>     14         1.0000        1.0237         1.0074          1.0071
>     15         1.0000        1.0098         0.9997          0.9997
>     16         1.0000        1.0110         0.9899          0.9994
> Geo. mean      1.0000        1.0175         1.0067          1.0078
>
> The order SLUB uses does not make much of a difference to SPEC CPU on
> either test machine or sysbench on x86-64. Howeer, on the ppc64 machine,
> the performance advantage SLUB has over SLAB appears to be eliminated if
> high-order pages are not used. I think I might run SLUB again incase the
> higher average performance was a co-incidence due to lucky cache layout.
> Otherwise, Christoph can probably put together a plausible theory on this
> result faster than I can.

It's interesting, thanks. It's a good result for SLQB I guess. 1% is fairly
large here (if it is statistically significant), but I don't think the
drawbacks of using higher order pages warrant changing anything by default
in SLQB. It does encourage me to add a boot or runtime parameter, though
(even if just for testing purposes).


> On the TLB front, it is perfectly possible that the workloads on x86-64 are
> not allocator or memory intensive enough to take advantage of fewer calls
> to the page allocator or potentially reduced TLB pressure. As the kernel
> portion of the address space already uses huge pages slab objects may have
> to occupy a very large percentage of memory before TLB pressure became an
> issue. The L1 TLBs on both test machines are fully associative making
> testing reduced TLB pressure practically impossible. For bonus points, 1G
> pages are being used on the x86-64 so I have nowhere near enough memory to
> put that under TLB pressure.

TLB pressure... I would be interested in. I'm not exactly sold on the idea
that higher order allocations will give a significant TLB improvement.
Although for benchmark runs, maybe it is more likely (ie. if memory hasn't
been too fragmented).

Suppose you have a million slab objects scattered all over memory, the fact
you might have them clumped into 64K regions rather than 4K regions... is
it going to be significant? How many access patterns are likely to soon touch
exactly those objects that are in the same page?

Sure it is possible to come up with a scenario where it does help. But also
others where it will not.

OTOH, if it is a win on ppc but not x86-64, then that may point to TLB...

