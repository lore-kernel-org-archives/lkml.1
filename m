Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab0BLOAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:00:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:59005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab0BLOAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:00:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,460,1262592000"; 
   d="scan'208";a="491980210"
Date: Fri, 12 Feb 2010 21:59:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Matt Mackall <mpm@selenic.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH 03/11] readahead: bump up the default readahead size
Message-ID: <20100212135949.GA22686@localhost>
References: <20100207041013.891441102@intel.com> <20100207041043.147345346@intel.com> <4B6FBB3F.4010701@linux.vnet.ibm.com> <20100208134634.GA3024@localhost> <1265924254.15603.79.camel@calx> <20100211234249.GE407@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211234249.GE407@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 07:42:49AM +0800, Jamie Lokier wrote:
> Matt Mackall wrote:
> > On Mon, 2010-02-08 at 21:46 +0800, Wu Fengguang wrote:
> > > Chris,
> > > 
> > > Firstly inform the linux-embedded maintainers :)
> > > 
> > > I think it's a good suggestion to add a config option
> > > (CONFIG_READAHEAD_SIZE). Will update the patch..
> > 
> > I don't have a strong opinion here beyond the nagging feeling that we
> > should be using a per-bdev scaling window scheme rather than something
> > static.

It's good to do dynamic scaling -- in fact this patchset has code to do
- scale down readahead size (per-bdev) for small devices
- scale down readahead size (per-stream) to thrashing threshold

At the same time, I'd prefer
- to _only_ do scale down (below the default size) for low end
- and have a uniform default readahead size for the mainstream

IMHO scaling up automatically
- would be risky
- hurts to build one common expectation on Linux behavior
  (not only developers, but also admins will run into the question:
  "what on earth is the readahead size?")
- and still not likely to please the high end guys ;)

> I agree with both.  100Mb/s isn't typical on little devices, even if a
> fast ATA disk is attached.  I've got something here where the ATA
> interface itself (on a SoC) gets about 10MB/s max when doing nothing
> else, or 4MB/s when talking to the network at the same time.
> It's not a modern design, but you know, it's junk we try to use :-)

Good to know this. I guess the same situation for some USB-capable
wireless routers -- they typically don't have powerful hardware to
exert the full 100MB/s disk speed.

> It sounds like a calculation based on throughput and seek time or IOP
> rate, and maybe clamped if memory is small, would be good.
> 
> Is the window size something that could be meaningfully adjusted
> according to live measurements?

We currently have live adjustment for
- small devices
- thrashed read streams

We could add new adjustments based on throughput (estimation is the
problem) and memory size.

Note that it does not really hurt to have big _readahead_ size on low
throughput or small memory conditions, because it's merely _max_
readahead size, the actual readahead size scales up step-by-step, and
scales down if thrashed, and the sequential readahead hit ratio is
pretty high (so no memory/bandwidth is wasted).

What may hurt is to have big mmap _readaround_ size. The larger
readaround size, the more readaround miss ratio (but still not
disastrous), hence more memory pages and bandwidth wasted. It's not a
big problem for mainstream, however embedded systems may be more
sensitive.

I would guess most embedded systems put executables on MTD devices
(anyone to confirm this?). And I wonder if MTDs have general
characteristics that are suitable for smaller readahead/readaround
size (the two sizes are bundled for simplicity)?

Thanks,
Fengguang
