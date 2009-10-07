Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZJGWXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZJGWXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZJGWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:23:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50872 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZJGWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:23:15 -0400
Date: Thu, 8 Oct 2009 00:22:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091007222235.GC1656@one.firstfloor.org>
References: <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain> <20091007210651.GB1656@one.firstfloor.org> <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain> <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 02:57:20PM -0700, Linus Torvalds wrote:
> There's no question that prefetching cannot help, but it helps only if 
> it's about fetching data that you would need anyway early. In contrast, if 
> the option is "don't touch the other cacheline at all", prefetching is 
> _always_ a loss. No ifs, buts and maybes about it.

My point (probably not very well written expressed)
was that in a typical VFS operation there are hundreds
of cache lines touched for various things (code, global, various
objects, random stuff) and one more or less in the final dentry 
is not that big a difference in the global picture.
(ok I realize final in this case means the elements in the path)

Also typical operations don't do the same VFS operation in
a loop, but other things that cools the caches first
and then have to fetch everything in again.

I agree that touching more cache lines on the hash chain
walk for immediates would be dumb because there can
be potentially a lot of them, but the final referenced
ones are much fewer.

Or rather if minimizing total foot-print is the goal
there are lower hanging fruit than in the dentry itself
by just cutting fat from the whole path.

(e.g. I liked Mathieu's immediate value work recently
reposted because it had the nice potential to remove a lot of
"global" cache lines in such paths by pushing them
into the icache). 

And if it's possible to do less dcache locks or less 
looping in a seqlock by paying with one cache 
line that could be a reasonable trade off, assuming you
can hide the latency.

Or maybe not and I'm totally wrong on that.
I'll shut up on this now.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
