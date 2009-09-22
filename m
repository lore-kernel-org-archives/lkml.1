Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZIVIv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZIVIv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZIVIvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:51:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:29437 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbZIVIvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:51:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,431,1249282800"; 
   d="scan'208";a="190228207"
Date: Tue, 22 Sep 2009 16:51:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: regression in page writeback
Message-ID: <20090922085124.GA25927@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins> <20090922082427.GA24888@localhost> <1253608335.8439.283.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253608335.8439.283.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 04:32:14PM +0800, Peter Zijlstra wrote:
> On Tue, 2009-09-22 at 16:24 +0800, Wu Fengguang wrote:
> > On Tue, Sep 22, 2009 at 04:09:25PM +0800, Peter Zijlstra wrote:
> > > On Tue, 2009-09-22 at 16:05 +0800, Wu Fengguang wrote:
> > > > 
> > > > I'm not sure how this patch stopped the "overshooting" behavior.
> > > > Maybe it managed to not start the background pdflush, or the started
> > > > pdflush thread exited because it found writeback is in progress by
> > > > someone else?
> > > > 
> > > > -               if (bdi_nr_reclaimable) {
> > > > +               if (bdi_nr_reclaimable > bdi_thresh) {
> > > 
> > > The idea is that we shouldn't move more pages from dirty -> writeback
> > > when there's not actually that much dirty left.
> > 
> > IMHO this makes little sense given that pdflush will move all dirty
> > pages anyway. pdflush should already be started to do background
> > writeback before the process is throttled, and it is designed to sync
> > all current dirty pages as quick as possible and as much as possible.
> 
> Not so, pdflush (or now the bdi writer thread thingies) should not
> deplete all dirty pages but should stop writing once they are below the
> background limit.

(add CC to fs people for more thoughts :)

> > > Now, I'm not sure about the > bdi_thresh part, I've suggested to maybe
> > > use bdi_thresh/2 a few times, but it generally didn't seem to make much
> > > of a difference.
> > 
> > One possible difference is, the process may end up waiting longer time
> > in order to sync write_chunk pages and quit the throttle. This could
> > hurt the responsiveness of the throttled process.
> 
> Well, that's all because this congestion_wait stuff is borken..

Yes congestion_wait is bad.. I do like the idea of lowering
bdi_thresh to help reduce the uncertainty of throttle time :)

Thanks,
Fengguang
