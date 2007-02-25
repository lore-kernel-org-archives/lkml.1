Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXBYCPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXBYCPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 21:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbXBYCPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 21:15:47 -0500
Received: from holomorphy.com ([66.93.40.71]:40883 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933631AbXBYCPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 21:15:46 -0500
Date: Sat, 24 Feb 2007 18:15:34 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: David Miller <davem@davemloft.net>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070225021534.GB9222@holomorphy.com>
References: <20070224042444.GU21484@holomorphy.com> <20070224050937.GA16601@wotan.suse.de> <20070224225631.GA9222@holomorphy.com> <20070224.165631.78711967.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224.165631.78711967.davem@davemloft.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: William Lee Irwin III <wli@holomorphy.com>
> Date: Sat, 24 Feb 2007 14:56:31 -0800
>> just do it on a per-directory basis so you don't intermix children
>> of different parents in some boot-time -allocated global trainwreck
>> and you're home free.  Benchmarking is probably needed to gauge
>> which performs best.

On Sat, Feb 24, 2007 at 04:56:31PM -0800, David Miller wrote:
> The original dentry implementation in the kernel did things
> per-directory and it sucked.
> The problem you run into is that you end up with recursive algorithms
> all over the place, which chew up and overflow the kernel stack.
> So it would be a regression to go to a per-directory type
> lookup data structure for dentries.

Recursive code is clearly inadmissible in kernel environments. Any
implementations would clearly be required to be coded iteratively.
It's unclear to me where the choice of data structure would make a
demand for recursive code, but wherever it ostensibly does so, an
explicitly-allocated stack (or queue or worklist of whatever sort)
should be able to unravel it. There are furthermore rather stringent
bounds on balanced tree heights due to address space limits, so
whatever explicitly-allocated stacks may be required for e.g. tree
balancing algorithms are tightly bounded in depth.

The usual objection is to lexicographically ordered balanced trees
such as B+ trees on the grounds that string comparison is cache-
intensive. Hash tries resolve that concern, albeit at the amortized
cost of expansion and contraction of what are effectively nodes in
a radix tree with a large radix as well as undoing path compression
where required (speaking of which, lib/radix-tree.c should really do
path compression instead of the ->depth hack). The quest, as I see it,
is for self-sizing data structures with as little restructuring and
direct key (string) comparison as possible. Should the obvious
candidates not incur significant overhead on account of where they
do such, maybe they're good enough.

So I'm not sure what else to say as far as the per-directory lookup
structure commentary goes. There's no way I'd propose putting
recursive code in the kernel. I don't believe any of what I'm talking
about requires such. I'm aware of various drawbacks the algorithms
have, and have in mind that they should pass benchmark criteria in
addition to reducing kernel memory consumption in order to prove that
they don't overwhelm the putative benefits. So I think I've got all the
bases covered.

Am I off-base on any of this? Is there anything I missed?


-- wli

(P.S.: The only time I ever proposed putting something "recursive"
in the kernel, it used a flag to limit the recursion depth to two
stack frames. It was for the purpose of simplifying the reservation
of metadata in an allocator, and so not strictly necessary. A 
simplified metadata allocator could've easily been devised, albeit at
the cost of some code duplication.)
