Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbXDKMJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbXDKMJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXDKMJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:09:12 -0400
Received: from styx.suse.cz ([82.119.242.94]:40587 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752226AbXDKMJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:09:11 -0400
Date: Wed, 11 Apr 2007 14:17:03 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH] Improve heuristic detecting sequential reads
Message-ID: <20070411121703.GA3769@duck.suse.cz>
References: <20070410155411.GF13445@duck.suse.cz> <20070410192722.9e6efc8b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410192722.9e6efc8b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-04-07 19:27:22, Andrew Morton wrote:
> On Tue, 10 Apr 2007 17:54:11 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > Introduce ra.offset and store in it an offset where the previous read ended. This way
> > we can detect whether reads are really sequential (and thus we should not mark the page
> > as accessed repeatedly) or whether they are random and just happen to be in the same page
> > (and the page should really be marked accessed again).
> 
> (less columns, please)
  Oops, sorry.

> OK.  So prev_page and prev_offset are now a complexified representation of a
> loff_t, no?  
  Yes.

> So why don't we just use a loff_t for this?
 I did not merge them because most other things in file_ra_state are in
pages and thus comparisons and assignments would require additional
shifts, which would IMHO make the whole thing less clear.

> Anyway, the asymmetry in our handling of prev_index (sometimes called
> prev_page!) and prev_offset is unpleasing.  This:
  prev_page is a member of the file_ra_state. Probably prev_index would be
better name there...

> --- a/mm/filemap.c~readahead-improve-heuristic-detecting-sequential-reads-tidy
> +++ a/mm/filemap.c
> @@ -933,6 +933,7 @@ page_ok:
>  		if (prev_index != index || offset != prev_offset)
>  			mark_page_accessed(page);
>  		prev_index = index;
> +		prev_offset = ra.offset = offset;
>  
>  		/*
>  		 * Ok, we have the page, and it's up-to-date, so
> @@ -948,7 +949,6 @@ page_ok:
>  		offset += ret;
>  		index += offset >> PAGE_CACHE_SHIFT;
>  		offset &= ~PAGE_CACHE_MASK;
> -		prev_offset = ra.offset = offset;
>  
>  		page_cache_release(page);
>  		if (ret == nr && desc->count)
> 
> improves things somewhat.  But I think it would be nicer if their handling
> was unified, or at least consistent.  We update ra.offset here, and we
> update ra.prev_page over there.
  It's clearer but wrong, as Wu already noted :). But the assignment
prev_index = index
  can be shifted somewhat lower (definitely after the comment) which makes
things slightly more readable.

> And shouldn't offset be called prev_offset?  Or should prev_page be called
> page?  Or index?  Or prev_index?  Or Marmaduke?  The naming is all a mess.
  I vote for prev_index and 'offset' could be prev_offset. I'll create a
tidy-up patch...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
