Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbZDNSlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbZDNSlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbZDNSkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:40:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39170 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbZDNSkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:40:39 -0400
Date: Tue, 14 Apr 2009 20:40:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Message-ID: <20090414184038.GJ5178@kernel.dk>
References: <200904141636.26557.knikanth@novell.com> <20090414111838.GG5178@kernel.dk> <200904141711.20378.knikanth@suse.de> <20090414181632.GI955@mit.edu> <20090414182049.GI5178@kernel.dk> <20090414183351.GK955@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414183351.GK955@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14 2009, Theodore Tso wrote:
> On Tue, Apr 14, 2009 at 08:20:49PM +0200, Jens Axboe wrote:
> > 
> > It's a bio_alloc() guarantee, it uses a mempool backing. And if you use
> > a mempool backing, any allocation that can wait will always be
> > satisfied.
> > 
> 
> Am I missing something?  I don't see anything in
> include/linux/mempool.h or mm/mempool.c, or in block/blk-core.c or
> include/linux/bio.h which documents that GFP_WAIT implies that
> bio_alloc() will always succeed.   

Read mempool.c:mempool_alloc(). If __GFP_WAIT is set, it'll never turn
without having done the allocation. It's a bit weird that it isn't
documented in bio_alloc() itself, but there are several other places in
bio.c that references the fact that it cannot fail.

> My concern is that at some point in the future, someone either in the
> block device layer or in mm/mempool.c will consider this an
> implementation detail, and all of sudden calls to bio_alloc() with
> GFP_WAIT will start failing and the resulting hilarty which ensues
> won't be easily predicted by the developer making this change.

It's the entire premise of a mempool, so trust me, it'll never go away.
It is the reason they were added in the first place, for eg swap you
need the mempool guarantee or you risk deadlocking.

-- 
Jens Axboe

