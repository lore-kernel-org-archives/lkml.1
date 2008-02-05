Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYBEAPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYBEAPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbYBEAOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:14:55 -0500
Received: from relay2.sgi.com ([192.48.171.30]:33272 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756296AbYBEAOy (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:14:54 -0500
Date: Tue, 5 Feb 2008 11:14:19 +1100
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Chinner <dgc@sgi.com>, Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ak@suse.de,
       jens.axboe@oracle.com, James.Bottomley@SteelEye.com, andrea@suse.de,
       clameter@sgi.com, akpm@linux-foundation.org, andrew.vasquez@qlogic.com,
       willy@linux.intel.com, Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080205001419.GG155407@sgi.com>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <20080204021052.GD155407@sgi.com> <47A69135.3060306@linux.intel.com> <20080204044020.GE155407@sgi.com> <20080204100959.GA15210@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204100959.GA15210@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 11:09:59AM +0100, Nick Piggin wrote:
> You get better behaviour in the slab and page allocators and locality
> and cache hotness of memory. For example, I guess in a filesystem /
> pagecache heavy workload, you have to touch each struct page, buffer head,
> fs private state, and also often have to wake the thread for completion.
> Much of this data has just been touched at submit time, so doin this on
> the same CPU is nice...

[....]

> I'm surprised that the xfs global state bouncing would outweigh the
> bouncing of all the per-page/block/bio/request/etc data that gets touched
> during completion. We'll see.

per-page/block.bio/request/etc is local to a single I/O. the only
penalty is a cacheline bounce for each of the structures from one
CPU to another.  That is, there is no global state modified by these
completions.

The real issue is metadata. The transaction log I/O completion
funnels through a state machine protected by a single lock, which
means completions on different CPUs pulls that lock to all
completion CPUs. Given that the same lock is used during transaction
completion for other state transitions (in task context, not intr),
the more cpus active at once touches, the worse the problem gets.

Then there's metadata I/O completion, which funnels through a larger
set of global locks in the transaction subsystem (e.g. the active
item list lock, the log reservation locks, the log state lock, etc)
which once again means the more CPUs we have delivering I/O
completions, the worse the problem gets.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
