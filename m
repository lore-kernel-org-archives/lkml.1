Return-Path: <linux-kernel-owner+w=401wt.eu-S1946344AbXBQBB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946344AbXBQBB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 20:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946349AbXBQBB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 20:01:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43266 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946344AbXBQBB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 20:01:28 -0500
Date: Fri, 16 Feb 2007 17:01:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH] 9p: add write-cache support to loose cache mode (take
 4)
Message-Id: <20070216170122.4cdafd78.akpm@linux-foundation.org>
In-Reply-To: <11716732192318-git-send-email-ericvh@gmail.com>
References: <1171640221420-git-send-email-ericvh@gmail.com>
	<11716732192318-git-send-email-ericvh@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 18:46:59 -0600
Eric Van Hensbergen <ericvh@gmail.com> wrote:

> Loose cache mode was added primarily to asssist exclusive, read-only
> mounts (like venti) -- however, there is also a case for using loose
> write cacheing in support of read/write exclusive mounts.  This feature
> is linked to the loose cache option and is disabled by default.
> 
> This code adds the necessary code to support writes through the page
> cache.  Write caches are not used for synthetic files or for files opened
> in APPEND mode.
> 

Me again ;)

> +int v9fs_prepare_write(struct file *file, struct page *page,
> +		       unsigned from, unsigned to)
> +{
> +	if(!PageUptodate(page)) {
> +		if (to - from != PAGE_CACHE_SIZE) {
> +			void *kaddr = kmap_atomic(page, KM_USER0);
> +			memset(kaddr, 0, from);
> +			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> +			flush_dcache_page(page);
> +			kunmap_atomic(kaddr, KM_USER0);
> +		}
> +		if ((file->f_flags & O_ACCMODE) != O_WRONLY)
> +			v9fs_vfs_readpage_worker(file, page);
> +	}
> +
> +	return 0;
> +}

Seems strange to memset part of the page and to then go and fill the page
in from backing store.  Perhaps some optimisation is possible here?

And did the error from v9fs_vfs_readpage_worker() just get lost?

> +/**
> + * v9fs_commit_write - prepare for mmap or page-cache I/O
> + *
> + * @file: file being read

"written"

> + * @page: structure to page
> + * @offset: starting offset
> + * @to: ending offset
> + *
> + */
> +
>
