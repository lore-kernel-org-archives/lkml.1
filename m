Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZIVIYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZIVIYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZIVIYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:24:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:34586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZIVIYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,430,1249282800"; 
   d="scan'208";a="190221681"
Date: Tue, 22 Sep 2009 16:24:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090922082427.GA24888@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253606965.8439.281.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 04:09:25PM +0800, Peter Zijlstra wrote:
> On Tue, 2009-09-22 at 16:05 +0800, Wu Fengguang wrote:
> > 
> > I'm not sure how this patch stopped the "overshooting" behavior.
> > Maybe it managed to not start the background pdflush, or the started
> > pdflush thread exited because it found writeback is in progress by
> > someone else?
> > 
> > -               if (bdi_nr_reclaimable) {
> > +               if (bdi_nr_reclaimable > bdi_thresh) {
> 
> The idea is that we shouldn't move more pages from dirty -> writeback
> when there's not actually that much dirty left.

IMHO this makes little sense given that pdflush will move all dirty
pages anyway. pdflush should already be started to do background
writeback before the process is throttled, and it is designed to sync
all current dirty pages as quick as possible and as much as possible.

> Now, I'm not sure about the > bdi_thresh part, I've suggested to maybe
> use bdi_thresh/2 a few times, but it generally didn't seem to make much
> of a difference.

One possible difference is, the process may end up waiting longer time
in order to sync write_chunk pages and quit the throttle. This could
hurt the responsiveness of the throttled process.

Thanks,
Fengguang
