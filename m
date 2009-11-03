Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZKCNOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZKCNOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZKCNOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:14:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:26922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZKCNOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:14:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,674,1249282800"; 
   d="scan'208";a="206959769"
Date: Tue, 3 Nov 2009 21:14:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       hch@infradead.org, chris.mason@oracle.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] [PATCH] Avoid livelock for fsync
Message-ID: <20091103131434.GA9648@localhost>
References: <20091026181314.GE7233@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026181314.GE7233@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Sorry for being late! - for some reason I was just able to see your email.

On Mon, Oct 26, 2009 at 07:13:14PM +0100, Jan Kara wrote:
>   Hi,
> 
>   on my way back from Kernel Summit, I've coded the attached patch which
> implements livelock avoidance for write_cache_pages. We tag patches that
> should be written in the beginning of write_cache_pages and then write
> only tagged pages (see the patch for details). The patch is based on Nick's
> idea.

Yes, tagging is a very fine grained way for livelock avoidance.
However I doubt this patch can achieve the simplification goals
listed below..

>   The next thing I've aimed at with this patch is a simplification of
> current writeback code. Basically, with this patch I think we can just rip
> out all the range_cyclic and nr_to_write (or other "fairness logic"). The
> rationalle is following:
>   What we want to achieve with fairness logic is that when a page is
> dirtied, it gets written to disk within some reasonable time (like 30s or

Right.

> so). We track dirty time on per-inode basis only because keeping it
> per-page is simply too expensive. So in this setting fairness between

Right.

> inodes really does not make any sence - why should be a page in a file
> penalized and written later only because there are lots of other dirty
> pages in the file? It is enough to make sure that we don't write one file
> indefinitely when there are new dirty pages continuously created - and my
> patch achieves that.

This is a big policy change. Imagine dirty files A=4GB, B=C=D=1MB.
With current policy, it could be

        sync 4MB of A
        sync B
        sync C
        sync D
        sync 4MB of A
        sync 4MB of A
        ...

And you want to change to

        sync A (all 4GB)
        sync B
        sync C
        sync D

This means the writeback of B,C,D won't be able to start at 30s, but
delayed to 80s because of A. This is not entirely fair. IMHO writeback
of big files shall not delay small files too much. 

>   So with my patch we can make write_cache_pages always write from
> range_start (or 0) to range_end (or EOF) and write all tagged pages. Also
> after changing balance_dirty_pages() so that a throttled process does not
> directly submit the IO (Fengguang has the patches for this), we can
> completely remove the nr_to_write logic because nothing really uses it
> anymore. Thus also the requeue_io logic should go away etc...

For the above reason I think we should think twice on removing
nr_to_write and requeue_io()..

>   Fengguang, do you have the series somewhere publicly available? You had
> there a plenty of changes and quite some of them are not needed when the
> above is done. So could you maybe separate out the balance_dirty_pages
> change and I'd base my patch and further simplifications on top of that?
> Thanks.

Sorry I don't maintain a public git tree. However it's a good idea to
break down the big patchset to smaller pieces, and submit/review them
bits by bits.

I'm on leave tomorrow and will do that after coming back.

Thanks,
Fengguang
