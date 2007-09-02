Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXIBEU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXIBEU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbXIBEUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:20:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:34543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbXIBEUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:20:15 -0400
Date: Sun, 2 Sep 2007 06:20:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jason Lunz <lunz@falooley.org>
Cc: David Woodhouse <dwmw2@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       jffs-dev@axis.com, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [jffs2] [rfc] fix write deadlock regression
Message-ID: <20070902042012.GA5864@wotan.suse.de>
References: <20070830182354.GA25077@falooley.org> <20070831212636.GB12868@falooley.org> <20070901190602.GA5926@falooley.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901190602.GA5926@falooley.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 12:06:03PM -0700, Jason Lunz wrote:
> 
> It introduced a wait to read_cache_page, as well as a
> read_cache_page_async function equivalent to the old read_cache_page
> without any callers.
> 
> Switching jffs2_gc_fetch_page to read_cache_page_async for the old
> behavior makes the deadlocks go away, but maybe reintroduces the
> use-before-uptodate problem? I don't understand the mm/fs interaction
> well enough to say.
> 
> Someone more knowledgable should see if similar deadlock issues may have
> been introduced for other read_cache_page callers, including the other
> two in jffs2.

Hmm, thanks for that. It does sound like it is deadlocking via
commit_write(). OTOH, it seems like it could be using the page
before it is uptodate -- it _may_ only be dealing with uptodate
data at that point... but if so, why even read_cache_page at
all?

However, it is a regression. So unless David can come up with a
more satisfactory approach, I guess we'd have to go with your
patch.



> 
>     Signed-off-by: Jason Lunz <lunz@falooley.org>
> 
> ---
>  fs/jffs2/fs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
> index 1d3b7a9..8bc727b 100644
> --- a/fs/jffs2/fs.c
> +++ b/fs/jffs2/fs.c
> @@ -627,7 +627,7 @@ unsigned char *jffs2_gc_fetch_page(struct jffs2_sb_info *c,
>  	struct inode *inode = OFNI_EDONI_2SFFJ(f);
>  	struct page *pg;
>  
> -	pg = read_cache_page(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
> +	pg = read_cache_page_async(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
>  			     (void *)jffs2_do_readpage_unlock, inode);
>  	if (IS_ERR(pg))
>  		return (void *)pg;
