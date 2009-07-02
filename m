Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZGBNqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZGBNqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZGBNqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:46:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbZGBNqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:46:05 -0400
Date: Thu, 2 Jul 2009 15:46:08 +0200
From: Nick Piggin <npiggin@suse.de>
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: mark page accessed before we write_end
Message-ID: <20090702134608.GH2714@wotan.suse.de>
References: <20090702130500.GF16713@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702130500.GF16713@dhcp231-156.rdu.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:05:00AM -0400, Josef Bacik wrote:
> Hello,
> 
> In testing a backport of the write_begin/write_end AOPs, a 10% re-read
> regression was noticed when running iozone.  This regression was introduced
> because the old AOPs would always do a mark_page_accessed(page) after the
> commit_write, but when the new AOPs where introduced, the only place this was
> kept was in pagecache_write_end().  This patch does the same thing in the
> generic case as what is done in pagecache_write_end(), which is just to mark
> the page accessed before we do write_end().  Thank you,
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>

Nasty bug. I'm sure (without looking at history) it's my fault :(
Good catch, thanks.

Acked-by: Nick Piggin <npiggin@suse.de>

> ---
>  mm/filemap.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 2239671..ccea3b6 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2272,6 +2272,7 @@ again:
>  		pagefault_enable();
>  		flush_dcache_page(page);
>  
> +		mark_page_accessed(page);
>  		status = a_ops->write_end(file, mapping, pos, bytes, copied,
>  						page, fsdata);
>  		if (unlikely(status < 0))
> -- 
> 1.5.4.3
