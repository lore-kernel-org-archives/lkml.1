Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZCITVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZCITVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZCITVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:21:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59288 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZCITVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:21:25 -0400
Date: Mon, 9 Mar 2009 20:21:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix memory leak in bio_clone()
Message-ID: <20090309192122.GZ11787@kernel.dk>
References: <49B4DD9C.5030902@cn.fujitsu.com> <20090309092407.GI11787@kernel.dk> <yq1prgqy8wc.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1prgqy8wc.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09 2009, Martin K. Petersen wrote:
> Jens> The second bug is that it should be using its own bioset, as it is
> Jens> illegal to do multiple __GFP_WAIT allocations on a single mempool
> Jens> and always expect progress.
> 
> So how do you propose I go about this?
> 
> The original intent was to contain all the integrity blah inside the
> bio_set to make it completely transparent to the caller.  That's why the
> bip mempool is hanging off of the bio_set.  But obviously two bvecs are
> needed per bio, one to describe data and to describe the integrity
> buffer.
> 
> Having two bvec mempools per bio_set seems icky.  I guess what you are
> suggesting is that we could have a dedicated bio_integrity_set akin to
> the bio_split_pool.  That removes the caller's option of passing a
> dedicated bio_set to the clone command, though.  Will that have forward
> progress implications for stacking drivers?

I was just wondering why you wanted to pass the bio_set in to
bio_integrity_clone(), why would the caller care?

Even two mempools isn't that bad. You can reuse the slab of course, and
the mempool should only have a single entry preallocated. But I agree,
it should not be in the bio_set. A dedicated bio_set for the integrity
stuff would be the way to go, and that should provide you all the
forward progress guarantees you need.

-- 
Jens Axboe

