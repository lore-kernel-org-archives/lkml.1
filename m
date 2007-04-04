Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXDDUJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXDDUJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXDDUJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:09:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbXDDUJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:09:40 -0400
Message-ID: <461405F5.6010303@redhat.com>
Date: Wed, 04 Apr 2007 16:09:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [S390] page_mkclean data corruption.
References: <200704041759.l34HxCnm014838@hera.kernel.org>
In-Reply-To: <200704041759.l34HxCnm014838@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6e1beb3c22496f6e1f1feba8ae74da16f131684c
> Commit:     6e1beb3c22496f6e1f1feba8ae74da16f131684c
> Parent:     348e3fd19487534d9d4dd70c3ad0b751afd35792
> Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
> AuthorDate: Wed Apr 4 14:37:10 2007 +0200
> Committer:  Martin Schwidefsky <schwidefsky@de.ibm.com>
> CommitDate: Wed Apr 4 14:37:39 2007 +0200
> 
>     [S390] page_mkclean data corruption.
>     
>     The git commit c2fda5fed81eea077363b285b66eafce20dfd45a which
>     added the page_test_and_clear_dirty call to page_mkclean and the
>     git commit 7658cc289288b8ae7dd2c2224549a048431222b3 which fixes
>     the "nasty and subtle race in shared mmap'ed page writeback"
>     problem in clear_page_dirty_for_io cause data corruption on s390.
>     
>     The effect of the two changes is that for every call to
>     clear_page_dirty_for_io a page_test_and_clear_dirty is done. If
>     the per page dirty bit is set set_page_dirty is called. Strangly
>     clear_page_dirty_for_io is called for not-uptodate pages, e.g.
>     over this call-chain:
>     
>      [<000000000007c0f2>] clear_page_dirty_for_io+0x12a/0x130
>      [<000000000007c494>] generic_writepages+0x258/0x3e0
>      [<000000000007c692>] do_writepages+0x76/0x7c
>      [<00000000000c7a26>] __writeback_single_inode+0xba/0x3e4
>      [<00000000000c831a>] sync_sb_inodes+0x23e/0x398
>      [<00000000000c8802>] writeback_inodes+0x12e/0x140
>      [<000000000007b9ee>] wb_kupdate+0xd2/0x178
>      [<000000000007cca2>] pdflush+0x162/0x23c
>     
>     The bad news now is that page_test_and_clear_dirty might claim
>     that a not-uptodate page is dirty since SetPageUptodate which
>     resets the per page dirty bit has not yet been called. The page
>     writeback that follows clobbers the data on disk.
>     
>     The simplest solution to this problem is to move the call to
>     page_test_and_clear_dirty under the "if (page_mapped(page))".
>     If a file backed page is mapped it is uptodate.
>     
>     Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  mm/rmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 22ed3f7..b82146e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -498,9 +498,9 @@ int page_mkclean(struct page *page)
>  		struct address_space *mapping = page_mapping(page);
>  		if (mapping)
>  			ret = page_mkclean_file(mapping, page);
> +		if (page_test_and_clear_dirty(page))
> +			ret = 1;
>  	}
> -	if (page_test_and_clear_dirty(page))
> -		ret = 1;
>  
>  	return ret;
>  }

This changes generic mm code. Is S390 really the only affected architecture?
