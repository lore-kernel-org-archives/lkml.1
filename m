Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZKDLcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZKDLcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZKDLcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:32:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:65358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbZKDLcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:32:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,679,1249282800"; 
   d="scan'208";a="207409156"
Date: Wed, 4 Nov 2009 19:32:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "npiggin@suse.de" <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hch@infradead.org" <hch@infradead.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] [PATCH] Avoid livelock for fsync
Message-ID: <20091104113211.GA23859@localhost>
References: <20091026181314.GE7233@duck.suse.cz> <20091103131434.GA9648@localhost> <20091103145654.GC29873@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103145654.GC29873@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

On Tue, Nov 03, 2009 at 10:56:54PM +0800, Jan Kara wrote:
[snip]
> > > inodes really does not make any sence - why should be a page in a file
> > > penalized and written later only because there are lots of other dirty
> > > pages in the file? It is enough to make sure that we don't write one file
> > > indefinitely when there are new dirty pages continuously created - and my
> > > patch achieves that.
> > 
> > This is a big policy change. Imagine dirty files A=4GB, B=C=D=1MB.
> > With current policy, it could be
> > 
> >         sync 4MB of A
> >         sync B
> >         sync C
> >         sync D
> >         sync 4MB of A
> >         sync 4MB of A
> >         ...
> > 
> > And you want to change to
> > 
> >         sync A (all 4GB)
> >         sync B
> >         sync C
> >         sync D
> > 
> > This means the writeback of B,C,D won't be able to start at 30s, but
> > delayed to 80s because of A. This is not entirely fair. IMHO writeback
> > of big files shall not delay small files too much. 
>   Yes, I'm aware of this change. It's just that I'm not sure we really
> care. There are few reasons to this: What advantage does it bring that we
> are "fair among files"? User can only tell the difference if after a crash,

I'm not all that sure, too. The perception is, big files normally
contain less valuable information per-page than small files ;)

If crashed, it's much better to lose one single big file, than to lose
all the (big and small) files.

Maybe nobody really care that - sync() has always been working file
after file (ignoring nr_to_write) and no one complained.

> files he wrote long time ago are still not on disk. But we shouldn't
> accumulate too many dirty data (like minutes of writeback) in caches
> anyway... So the difference should not be too big. Also how is the case
> "one big and a few small files" different from the case "many small files"
> where to be fair among files does not bring anything? 
>   It's just that see some substantial code complexity and also performance
> impact (because of smaller chunks of sequential IO) in trying to be fair
> among files and I don't really see adequate advantages of that approach.
> That's why I'm suggesting we should revisit the decision and possibly go in
> a different direction.

Anyway, if this is not a big concern, nr_to_write could be removed.

Note that requeue_io() (or requeue_io_wait) still cannot be removed
because sometimes we have (temporary) problems on writeback an inode.

Thanks,
Fengguang
