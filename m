Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZIWGlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZIWGlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZIWGlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:41:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:29017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbZIWGlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:41:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,436,1249282800"; 
   d="scan'208";a="450873466"
Date: Wed, 23 Sep 2009 14:41:20 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: regression in page writeback
Message-ID: <20090923064120.GA3194@sli10-desk.sh.intel.com>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins> <20090922082427.GA24888@localhost> <1253608335.8439.283.camel@twins> <20090922155259.GL10825@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922155259.GL10825@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 11:52:59PM +0800, Chris Mason wrote:
> On Tue, Sep 22, 2009 at 10:32:14AM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-09-22 at 16:24 +0800, Wu Fengguang wrote:
> > > On Tue, Sep 22, 2009 at 04:09:25PM +0800, Peter Zijlstra wrote:
> > > > On Tue, 2009-09-22 at 16:05 +0800, Wu Fengguang wrote:
> > > > > 
> > > > > I'm not sure how this patch stopped the "overshooting" behavior.
> > > > > Maybe it managed to not start the background pdflush, or the started
> > > > > pdflush thread exited because it found writeback is in progress by
> > > > > someone else?
> > > > > 
> > > > > -               if (bdi_nr_reclaimable) {
> > > > > +               if (bdi_nr_reclaimable > bdi_thresh) {
> > > > 
> > > > The idea is that we shouldn't move more pages from dirty -> writeback
> > > > when there's not actually that much dirty left.
> > > 
> > > IMHO this makes little sense given that pdflush will move all dirty
> > > pages anyway. pdflush should already be started to do background
> > > writeback before the process is throttled, and it is designed to sync
> > > all current dirty pages as quick as possible and as much as possible.
> > 
> > Not so, pdflush (or now the bdi writer thread thingies) should not
> > deplete all dirty pages but should stop writing once they are below the
> > background limit.
> > 
> > > > Now, I'm not sure about the > bdi_thresh part, I've suggested to maybe
> > > > use bdi_thresh/2 a few times, but it generally didn't seem to make much
> > > > of a difference.
> > > 
> > > One possible difference is, the process may end up waiting longer time
> > > in order to sync write_chunk pages and quit the throttle. This could
> > > hurt the responsiveness of the throttled process.
> > 
> > Well, that's all because this congestion_wait stuff is borken..
> > 
> 
> I'd suggest retesting with a new baseline against the code in Linus' git
> today.  Overall I think the change to make balance_dirty_pages() sleep
> instead of kick more IO out is a very good one.  It helps in most
> workloads here.
I tested today's git tree v2.6.31-7068-g43c1266, looks the regression
disappears. the disk io is almost stable to about 480m/s with/without the patch.

Thanks,
Shaohua
