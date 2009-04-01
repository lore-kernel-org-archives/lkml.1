Return-Path: <linux-kernel-owner+w=401wt.eu-S1765127AbZDANA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765127AbZDANA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764128AbZDANAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:00:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:40783 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763831AbZDANAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:00:42 -0400
Date: Wed, 1 Apr 2009 21:59:26 +0900
To: tj@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, tj@kenel.org
Subject: Re: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using
 blk_rq_map_user_iov()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49D36329.20004@kernel.org>
References: <1238583884-13517-9-git-send-email-tj@kernel.org>
	<20090401214415W.fujita.tomonori@lab.ntt.co.jp>
	<49D36329.20004@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090401215933S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 01 Apr 2009 21:59:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 21:50:49 +0900
Tejun Heo <tj@kernel.org> wrote:

> FUJITA Tomonori wrote:
> >> * Because each call to bio_map/copy_user() is independent, segment
> >>   limit check was done only per each bio, so it was possible to create
> >>   requests which are larger than the driver and hardware limits, which
> >>   could lead to disastrous outcome.
> > 
> > What do you mean? blk_rq_append_bio properly checks the segment and
> > limit, I think.
> 
> Right, ll_back_merge_fn() does that.  Sorry about that.
> 
> >> * Layers under FS may call blk_rq_map*() functions during request
> >>   processing.  Under severe memory pressure and with enough bad luck,
> >>   this can lead to deadlock.  As fs bvec pool is quite small, the
> >>   possibility isn't completely theoretical.
> >>
> >> This patch reimplement blk_rq_map_user() in terms of
> >> blk_rq_map_user_iov() which doesn't support multi-bio mappping and
> >> drop multi bio handling from blk_rq_unmap_user().  Note that with the
> >> previous patch to remove bio max size limit and to add null mapping
> >> support to blk_rq_map_user_iov(), this change doesn't remove any
> >> functionality.
> > 
> > I don't think that we can drop multi bio handling from
> > blk_rq_unmap_user(). It may make some users angry. Mike Christie added
> > it because it was necessary.
> 
> The only user of blk_rq_append_bio() is scsi_lib.c.  Is Mike
> Christie's code chaining bio's directly into rq?

No, we are not talking about blk_rq_append_bio().

We are talking about the multiple bio handling in blk_rq_map_user,
which is the feature that Mike added long time ago. The feature is
surely necessary for some users. So you can't remote it.
