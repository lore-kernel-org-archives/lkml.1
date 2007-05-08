Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbXEHGSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbXEHGSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXEHGSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:18:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35302 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754406AbXEHGSV (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:18:21 -0400
Date: Tue, 8 May 2007 16:18:10 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>
Subject: Re: sleeping function called from invalid context at block/cfq-iosched.c (Was: Re: 2.6.21-mm1)
Message-ID: <20070508061810.GI32602149@melbourne.sgi.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org> <463FAF1C.8060500@simon.arlott.org.uk> <20070507162349.0790706f.akpm@linux-foundation.org> <463FB697.6060902@simon.arlott.org.uk> <20070507163335.f5f5ea6e.akpm@linux-foundation.org> <463FFD0A.2050708@goop.org> <20070507222409.2d597a86.akpm@linux-foundation.org> <46400CD0.8050309@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46400CD0.8050309@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:38:24PM -0700, Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> > On Mon, 07 May 2007 21:31:06 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >   
> >> I've found that XFS+lvm+4k stacks is completely unusable with current
> >> kernels.  I get hangs/oopes after ~10mins of work.
> >>     
> >
> > Sounds like this is new behaviour?
> >
> > I wonder why.  Same compiler version?
> 
> I've only recently started using xfs, so I couldn't say if its new
> behaviour.  I did notice that it took a week or so for problems to set
> in; my theory is that as the filesystem got a bit aged, its
> datastructures got a bit more complex, and cause the kernel code to use
> more stack.  But that's just a guess.

The worst case stack usage through XFS occurs when it has to read
metadata blocks in the writeback path when doing an allocation
transaction. This happens when walking the freespace btrees looking
for an extent matching the allocation requirements. As the fileystem
fills up, these btrees will grow and you are more likely not to have
a block inthe btree cached in memory.

So yes, this is a possible reason you hadn't seen any problems early
on.

FWIW, there's also been recent reports of both ext3 and reiser on
LVM blowing 4k stacks, so if you use LVM it probably advisable to
go back to 8k stacks....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
