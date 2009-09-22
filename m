Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZIVIws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZIVIws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZIVIwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:52:46 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:47624 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbZIVIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:52:46 -0400
Subject: Re: regression in page writeback
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <1253608335.8439.283.camel@twins>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com>
	 <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost>
	 <1253606965.8439.281.camel@twins>  <20090922082427.GA24888@localhost>
	 <1253608335.8439.283.camel@twins>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 09:52:48 +0100
Message-Id: <1253609568.2282.11.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 10:32 +0200, Peter Zijlstra wrote:
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
> 
> > > Now, I'm not sure about the > bdi_thresh part, I've suggested to maybe
> > > use bdi_thresh/2 a few times, but it generally didn't seem to make much
> > > of a difference.
> > 
> > One possible difference is, the process may end up waiting longer time
> > in order to sync write_chunk pages and quit the throttle. This could
> > hurt the responsiveness of the throttled process.
> 
> Well, that's all because this congestion_wait stuff is borken..
> 

The problem occurred as pdflush stopped when the number of dirty pages
reached the background threshold but balance_dirty_pages kept moving
pages to writeback because the total of dirty + writeback was over the
limit. 

I tried Peter's suggestion of using bdi_thresh/2 but I didn't see any
difference on my desktop hardware, but it may help RAID setups. I don't
think anyone tried it though.

Since Jens Axboe's per-bdi code got merged in the latest kernel tree,
there's a lot of change in these code paths so I'm not sure how that
reacts and if this change is still needed or relevant. 

regards
Richard


