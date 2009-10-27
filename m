Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbZJ0Djq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbZJ0Djq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZJ0Djp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:39:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbZJ0Djo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:39:44 -0400
Date: Tue, 27 Oct 2009 04:39:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       hch@infradead.org, chris.mason@oracle.com
Subject: Re: [RFC] [PATCH] Avoid livelock for fsync
Message-ID: <20091027033947.GB11828@wotan.suse.de>
References: <20091026181314.GE7233@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026181314.GE7233@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 07:13:14PM +0100, Jan Kara wrote:
>   Hi,
> 
>   on my way back from Kernel Summit, I've coded the attached patch which
> implements livelock avoidance for write_cache_pages. We tag patches that
> should be written in the beginning of write_cache_pages and then write
> only tagged pages (see the patch for details). The patch is based on Nick's
> idea.
>   The next thing I've aimed at with this patch is a simplification of
> current writeback code. Basically, with this patch I think we can just rip
> out all the range_cyclic and nr_to_write (or other "fairness logic"). The
> rationalle is following:
>   What we want to achieve with fairness logic is that when a page is
> dirtied, it gets written to disk within some reasonable time (like 30s or
> so). We track dirty time on per-inode basis only because keeping it
> per-page is simply too expensive. So in this setting fairness between
> inodes really does not make any sence - why should be a page in a file
> penalized and written later only because there are lots of other dirty
> pages in the file? It is enough to make sure that we don't write one file
> indefinitely when there are new dirty pages continuously created - and my
> patch achieves that.
>   So with my patch we can make write_cache_pages always write from
> range_start (or 0) to range_end (or EOF) and write all tagged pages. Also
> after changing balance_dirty_pages() so that a throttled process does not
> directly submit the IO (Fengguang has the patches for this), we can
> completely remove the nr_to_write logic because nothing really uses it
> anymore. Thus also the requeue_io logic should go away etc...
>   Fengguang, do you have the series somewhere publicly available? You had
> there a plenty of changes and quite some of them are not needed when the
> above is done. So could you maybe separate out the balance_dirty_pages
> change and I'd base my patch and further simplifications on top of that?
> Thanks.

Like I said (and as we concluded when I last posted my tagging patch),
I think this idea should work fine, but there is perhaps a little bit of
overhead/complexity so provided that we can get some numbers or show a
real improvement in behaviour or code simplifications then I think we
could justify the patch.

I would be interested to know how it goes.

Thanks,
Nick
