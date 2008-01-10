Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbYAJVb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbYAJVb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYAJVbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:31:51 -0500
Received: from lazybastard.de ([212.112.238.170]:37315 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbYAJVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:31:50 -0500
Date: Thu, 10 Jan 2008 22:25:20 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
Message-ID: <20080110212519.GA29847@lazybastard.org>
References: <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI> <1199641910.8215.28.camel@cinder.waste.org> <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> <1199906151.6245.57.camel@cinder.waste.org> <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <1199987366.5331.92.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1199987366.5331.92.camel@cinder.waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 January 2008 11:49:25 -0600, Matt Mackall wrote:
> 
> b) grouping objects of the same -type- (not size) together should mean
> they have similar lifetimes and thereby keep fragmentation low
> 
> (b) is known to be false, you just have to look at our dcache and icache
> pinning.

(b) is half-true, actually.  The grouping by lifetime makes a lot of
sense.  LogFS has a similar problem to slabs (only full segments are
useful, a single object can pin the segment).  And when I grouped my
objects very roughly by their life expectency, the impact was *HUGE*!

In both cases, you want slabs/segments that are either close to 100%
full or close to 0% full.  It matters a lot when you have to move
objects around and I would bet it matters even more when you cannot move
objects and the slab just remains pinned.

So just because the type alone is a relatively bad heuristic for life
expectency does not make the concept false.  Bonwick was onto something.
He just failed in picking a good heuristic.  Quite likely spreading by
type was even a bonus when slab was developed, because even such a crude
heuristic is slightly better than completely randomized lifetimes.

I've been meaning to split the dentry cache into 2-3 seperate ones for a
while and kept spending my time elsewhere.  But I remain convinced that
this will make a measurable difference.

Jörn

-- 
Never argue with idiots - first they drag you down to their level,
then they beat you with experience.
-- unknown
