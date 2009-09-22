Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZIVIbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZIVIbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZIVIbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:31:09 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:34456 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZIVIbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:31:08 -0400
X-SourceIP: 213.93.53.227
Subject: Re: regression in page writeback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20090922082427.GA24888@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com>
	 <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost>
	 <1253606965.8439.281.camel@twins>  <20090922082427.GA24888@localhost>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 10:32:14 +0200
Message-Id: <1253608335.8439.283.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:24 +0800, Wu Fengguang wrote:
> On Tue, Sep 22, 2009 at 04:09:25PM +0800, Peter Zijlstra wrote:
> > On Tue, 2009-09-22 at 16:05 +0800, Wu Fengguang wrote:
> > > 
> > > I'm not sure how this patch stopped the "overshooting" behavior.
> > > Maybe it managed to not start the background pdflush, or the started
> > > pdflush thread exited because it found writeback is in progress by
> > > someone else?
> > > 
> > > -               if (bdi_nr_reclaimable) {
> > > +               if (bdi_nr_reclaimable > bdi_thresh) {
> > 
> > The idea is that we shouldn't move more pages from dirty -> writeback
> > when there's not actually that much dirty left.
> 
> IMHO this makes little sense given that pdflush will move all dirty
> pages anyway. pdflush should already be started to do background
> writeback before the process is throttled, and it is designed to sync
> all current dirty pages as quick as possible and as much as possible.

Not so, pdflush (or now the bdi writer thread thingies) should not
deplete all dirty pages but should stop writing once they are below the
background limit.

> > Now, I'm not sure about the > bdi_thresh part, I've suggested to maybe
> > use bdi_thresh/2 a few times, but it generally didn't seem to make much
> > of a difference.
> 
> One possible difference is, the process may end up waiting longer time
> in order to sync write_chunk pages and quit the throttle. This could
> hurt the responsiveness of the throttled process.

Well, that's all because this congestion_wait stuff is borken..

