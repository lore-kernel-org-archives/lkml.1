Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbZJGKsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbZJGKsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbZJGKsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:48:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:31614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827AbZJGKsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:48:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="196015425"
Date: Wed, 7 Oct 2009 18:47:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/45] writeback: quit on wrap for .range_cyclic (afs)
Message-ID: <20091007104711.GA11014@localhost>
References: <20091007074902.913463607@intel.com> <20091007073818.318088777@intel.com> <32495.1254910626@redhat.com> <20091007102130.GQ30316@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007102130.GQ30316@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 06:21:30PM +0800, Nick Piggin wrote:
> On Wed, Oct 07, 2009 at 11:17:06AM +0100, David Howells wrote:
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
> > > of the inode, which instructs writeback_single_inode() to delay it for
> > > a while if necessary.
> > > 
> > > It removes one inefficient .range_cyclic IO pattern when writeback_index
> > > wraps:
> > > 	submit [10000-10100], (wrap), submit [0-100]
> > > In which the submitted pages may be consisted of two distant ranges.
> > > 
> > > It also prevents submitting pointless IO for busy overwriters.
> > > 
> > > CC: David Howells <dhowells@redhat.com>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > Acked-by: David Howells <dhowells@redhat.com>
> 
> I don't see why. Then the inode is given less write bandwidth than
> those which don't wrap (or wrap on "nice" boundaries).

The "return on wrapped" behavior itself only offers a natural seek
boundary to the upper layer.  It's mainly the "whether to delay"
policy that will affect (overall) bandwidth.

If we choose to not sleep, and to go on with other inodes and then
back to this inode, no bandwidth will be lost.

If we have done work with other inodes (if any), and choose to sleep
for a while before restarting this inode, then we could lose bandwidth.
The plus side is, we possibly avoid submitting extra IO if this inode
is being busy overwritten. So it's a tradeoff.

The behavior after this patchset is, to keep busy as long as we can
write any pages (in patch 38/45). So we still opt for bandwidth :)

Thanks,
Fengguang
