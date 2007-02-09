Return-Path: <linux-kernel-owner+w=401wt.eu-S1423237AbXBITPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423237AbXBITPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992761AbXBITPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:15:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38681 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423209AbXBITPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:15:00 -0500
Date: Fri, 9 Feb 2007 11:14:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] ext2: use perform_write aop
Message-Id: <20070209111455.67a69783.akpm@linux-foundation.org>
In-Reply-To: <20070208105508.26443.7806.sendpatchset@linux.site>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	<20070208105508.26443.7806.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Feb 2007 14:07:46 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:

> +void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
> +{
> +	unsigned int block_start, block_end;
> +	struct buffer_head *head, *bh;
> +
> +	BUG_ON(!PageLocked(page));
> +	if (!page_has_buffers(page))
> +		return;
> +
> +	bh = head = page_buffers(page);
> +	block_start = 0;
> +	do {
> +		block_end = block_start + bh->b_size;
> +
> +		if (buffer_new(bh)) {
> +			if (block_end > from && block_start < to) {
> +				if (!PageUptodate(page)) {
> +					unsigned start, end;
> +					void *kaddr;
> +
> +					start = max(from, block_start);
> +					end = min(to, block_end);
> +
> +					kaddr = kmap_atomic(page, KM_USER0);
> +					memset(kaddr+start, 0, block_end-end);
> +					flush_dcache_page(page);
> +					kunmap_atomic(kaddr, KM_USER0);
> +					set_buffer_uptodate(bh);
> +				}

I don't see how this differs from the previous attempts to solve the
deadlock via atomic copt_from_user().  Here we temporarily zero out the
pagecache page then block_perform_write() unlocks the page.  So another
thread can come in, read the page and see the temporary zeroes?  

If so, that might be preventable by leaving the buffer nonuptodate.

