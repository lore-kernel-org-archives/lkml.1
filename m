Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbZJMS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbZJMS3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760722AbZJMS33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:29:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:39763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760664AbZJMS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:29:28 -0400
Subject: Re: [PATCH 01/45] writeback: reduce calls to global_page_state in
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091013181214.GA31440@duck.suse.cz>
References: <20091007073818.318088777@intel.com>
	 <20091007074901.251116016@intel.com> <20091009151230.GF7654@duck.suse.cz>
	 <20091010213339.GA8644@localhost> <20091012211838.GA3965@duck.suse.cz>
	 <20091013032405.GA20405@localhost>  <20091013181214.GA31440@duck.suse.cz>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 20:28:19 +0200
Message-Id: <1255458499.8967.711.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 20:12 +0200, Jan Kara wrote:
> >       for (;;) {
> >               nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> >                                global_page_state(NR_UNSTABLE_NFS);
> >               nr_writeback = global_page_state(NR_WRITEBACK) +
> >                              global_page_state(NR_WRITEBACK_TEMP);
> > 
> >               global_dirty_thresh(&background_thresh, &dirty_thresh);
> > 
> >               /*
> >                * Throttle it only when the background writeback cannot
> >                * catch-up. This avoids (excessively) small writeouts
> >                * when the bdi limits are ramping up.
> >                */
> >               if (nr_reclaimable + nr_writeback <
> >                   (background_thresh + dirty_thresh) / 2)
> >                       break;
> > 
> >               bdi_thresh = bdi_dirty_thresh(bdi, dirty_thresh);
> > 
> >               /*
> >                * In order to avoid the stacked BDI deadlock we need
> >                * to ensure we accurately count the 'dirty' pages when
> >                * the threshold is low.
> >                *
> >                * Otherwise it would be possible to get thresh+n pages
> >                * reported dirty, even though there are thresh-m pages
> >                * actually dirty; with m+n sitting in the percpu
> >                * deltas.
> >                */
> >               if (bdi_thresh < 2*bdi_stat_error(bdi)) {
> >                       bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
> >                       bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
> >               } else {
> >                       bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> >                       bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> >               }
> > 
> >               /*
> >                * The bdi thresh is somehow "soft" limit derived from the
> >                * global "hard" limit. The former helps to prevent heavy IO
> >                * bdi or process from holding back light ones; The latter is
> >                * the last resort safeguard.
> >                */
> >               dirty_exceeded =
> >                       (bdi_nr_reclaimable + bdi_nr_writeback >= bdi_thresh)
> >                       || (nr_reclaimable + nr_writeback >= dirty_thresh);
> > 
> >               if (!dirty_exceeded)
> >                       break;
> > 
> >               bdi->dirty_exceed_time = jiffies;
> > 
> >               bdi_writeback_wait(bdi, write_chunk);
>   Hmm, probably you've discussed this in some other email but why do we
> cycle in this loop until we get below dirty limit? We used to leave the
> loop after writing write_chunk... So the time we spend in
> balance_dirty_pages() is no longer limited, right?

Wu was saying that without the loop nr_writeback wasn't limited, but
since bdi_writeback_wakeup() is driven from writeout completion, I'm not
sure how again that was so.

We can move all of bdi_dirty to bdi_writeout, if the bdi writeout queue
permits, but it cannot grow beyond the total limit, since we're actually
waiting for writeout completion.

Possibly unstable is peculiar.



