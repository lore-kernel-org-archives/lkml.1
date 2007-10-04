Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbXJDQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbXJDQQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762577AbXJDQQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:16:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57708 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbXJDQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:16:23 -0400
Date: Thu, 4 Oct 2007 10:16:21 -0600
From: Matthew Wilcox <willy@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: SLUB performance regression vs SLAB
Message-ID: <20071004161621.GO12049@parisc-linux.org>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> <200709281514.48293.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 01:50:44PM -0700, Christoph Lameter wrote:
> The problem is with the weird way of Intel testing and communication. 
> Every 3-6 month or so they will tell you the system is X% up or down on 
> arch Y (and they wont give you details because its somehow secret). And 
> then there are conflicting statements by the two or so performance test 
> departments. One of them repeatedly assured me that they do not see any 
> regressions.

Could you cut out the snarky remarks?  It takes a long time to run a
test, and testing every one of the patches you send really isn't high
on anyone's priority list.  The performance team have also been having
problems getting stable results with recent kernels, adding to the delay.
The good news is that we do now have committment to testing upstream
kernels, so you should see results more frequently than you have been.

I'm taking over from Suresh as liason for the performance team, so
if you hear *anything* from *anyone* else at Intel about performance,
I want you to cc me about it.  OK?  And I don't want to hear any more
whining about hearing different things from different people.

So, on "a well-known OLTP benchmark which prohibits publishing absolute
numbers" and on an x86-64 system (I don't think exactly which model
is important), we're seeing *6.51%* performance loss on slub vs slab.
This is with a 2.6.23-rc3 kernel.  Tuning the boot parameters, as you've
asked for before (slub_min_order=2, slub_max_order=4, slub_min_objects=8)
gets back 0.38% of that.  It's still down 6.13% over slab.

For what it's worth, 2.6.23-rc3 already has a 1.19% regression versus
RHEL 4.5, so the performance guys are really unhappy about going up to
almost 8% regression.

In the detailed profiles, __slab_free is the third most expensive
function, behind only spin locks.  get_partial_node is right behind it
in fourth place, and kmem_cache_alloc is sixth.  __slab_alloc is eight
and kmem_cache_free is tenth.  These positions don't change with the
slub boot parameters.

Now, where do we go next?  I suspect that 2.6.23-rc9 has significant
changes since -rc3, but I'd like to confirm that before kicking off
another (expensive) run.  Please, tell me what useful kernels are to test.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
