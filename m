Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXBNAQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXBNAQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXBNAQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:16:39 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095AbXBNAQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:16:38 -0500
Date: Tue, 13 Feb 2007 16:16:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       ericvh@gmail.com
Subject: Re: [RESEND][PATCH] 9p: add write-cache support to loose cache mode
Message-Id: <20070213161607.0ca21ea4.akpm@linux-foundation.org>
In-Reply-To: <11714109311262-git-send-email-ericvh@gmail.com>
References: <11714109311262-git-send-email-ericvh@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Feb 2007 17:55:31 -0600 Eric Van Hensbergen <ericvh@gmail.com> wrote:
> +int v9fs_prepare_write(struct file *file, struct page *page,
> +		       unsigned from, unsigned to)
> +{
> +	if (!PageUptodate(page)) {
> +		if (to - from != PAGE_CACHE_SIZE) {
> +			void *kaddr = kmap_atomic(page, KM_USER0);
> +			memset(kaddr, 0, from);
> +			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> +			flush_dcache_page(page);
> +			kunmap_atomic(kaddr, KM_USER0);
> +		}
> +		SetPageUptodate(page);
> +	}

This will mark the page uptodate while the piece between `to' and `from' is
uninitialised.  A concurrent pagefault can come in and permit a read of
that uninitialised data.  Because filemap_nopage() doesn't lock the page if
it is uptodate.
