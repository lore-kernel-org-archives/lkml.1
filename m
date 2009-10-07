Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbZJGPTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbZJGPTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZJGPTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:19:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:19595 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZJGPTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:19:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,519,1249282800"; 
   d="scan'208";a="196106571"
Date: Wed, 7 Oct 2009 23:18:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Staubach <staubach@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/45] some writeback experiments
Message-ID: <20091007151822.GA9574@localhost>
References: <20091007073818.318088777@intel.com> <4ACC9BE2.5070409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACC9BE2.5070409@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 09:47:14PM +0800, Peter Staubach wrote:
> Wu Fengguang wrote:
> > Hi all,
> > 
> > Here is a collection of writeback patches on
> > 
> > - larger writeback chunk sizes
> > - single per-bdi flush thread (killing the foreground throttling writeouts)
> > - lumpy pageout
> > - sync livelock prevention
> > - writeback scheduling
> > - random fixes
> > 
> > Sorry for posting a too big series - there are many direct or implicit
> > dependencies, and one patch lead to another before I can stop..
> > 
> > The lumpy pageout and nr_segments support is not complete and do not
> > cover all filesystems for now. It may be better to first convert some of
> > the ->writepages to the generic routines to avoid duplicate work.
> > 
> > I managed to address many issues in past week, however there are still known
> > problems. Hints from filesystem developers are highly appreciated. Thanks!
> > 
> > The estimated writeback bandwidth is about 1/2 the real throughput
> > for ext2/3/4 and btrfs; noticeable bigger than real throughput for NFS; and
> > cannot be estimated at all for XFS.  Very interesting..
> > 
> > NFS writeback is very bumpy. The page numbers and network throughput "freeze"
> > together from time to time:
> > 
> 
> Yes.  It appears that the problem is that too many pages get dirtied
> and the network/server get overwhelmed by the NFS client attempting
> to write out all of the pages as quickly as it possibly can.

In theory it should push pages as quickly as possible at first,
to fill up the server side queue.

> I think that it would be better if we could better match the
> number of pages which can be dirty at any given point with the
> bandwidth available through the network and the server file
> system and storage.

And then go into this steady state of matched network/disk bandwidth.

> One approach that I have pondered is immediately queuing an
> asynchronous request when enough pages are dirtied to be able
> to completely fill an over the wire transfer.  This sort of
> seems like a per-file bdi, which doesn't seem quite like the
> right approach to me.  What would y'all think about that?

Hmm, it sounds like unnecessary complexity. Because it is not going to
help the busy-dirtier case anyway. And if we can do good on heavy IO,
the pre-flushing policy becomes less interesting.

> 
> > # vmmon -d 1 nr_writeback nr_dirty nr_unstable      # (per 1-second samples)
> >      nr_writeback         nr_dirty      nr_unstable
> >             11227            41463            38044
> >             11227            41463            38044
> >             11227            41463            38044
> >             11227            41463            38044

I guess in the above 4 seconds, either client or (more likely) server
is blocked. A blocked server cannot send ACKs to knock down both
nr_writeback/nr_unstable. And the stuck nr_writeback will freeze
nr_dirty as well, because the dirtying process is throttled until
it receives enough "PG_writeback cleared" event, however the bdi-flush
thread is also blocked when trying to clear more PG_writeback, because
the client side nr_writeback limit has been reached. In summary,

server blocked => nr_writeback stuck => nr_writeback limit reached
=> bdi-flush blocked => no end_page_writeback() => dirtier blocked
=> nr_dirty stuck

Thanks,
Fengguang

> >             11045            53987             6490
> >             11033            53120             8145
> >             11195            52143            10886
> >             11211            52144            10913
> >             11211            52144            10913
> >             11211            52144            10913
> > 
> > btrfs seems to maintain a private pool of writeback pages, which can go out of
> > control:
> > 
> >      nr_writeback         nr_dirty
> >            261075              132
> >            252891              195
> >            244795              187
> >            236851              187
> >            228830              187
> >            221040              218
> >            212674              237
> >            204981              237
> > 
> > XFS has very interesting "bumpy writeback" behavior: it tends to wait
> > collect enough pages and then write the whole world.
> > 
> >      nr_writeback         nr_dirty
> >             80781                0
> >             37117            37703
> >             37117            43933
> >             81044                6
> >             81050                0
> >             43943            10199
> >             43930            36355
> >             43930            36355
> >             80293                0
> >             80285                0
> >             80285                0
> > 
> > Thanks,
> > Fengguang
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
