Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYJWFk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYJWFk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 01:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYJWFkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:40:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbYJWFkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:40:11 -0400
Date: Wed, 22 Oct 2008 22:39:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dmitri Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add block device speciffic splice write method
Message-Id: <20081022223928.a6ce476f.akpm@linux-foundation.org>
In-Reply-To: <20081020181156.GI19428@kernel.dk>
References: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org>
	<20081020174931.GH19428@kernel.dk>
	<20081020181156.GI19428@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 20:11:56 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> +ssize_t generic_file_splice_write_file_nolock(struct pipe_inode_info *pipe,
> +					      struct file *out, loff_t *ppos,
> +					      size_t len, unsigned int flags)
> +{
> +	struct address_space *mapping = out->f_mapping;
> +	struct inode *inode = mapping->host;
> +	struct splice_desc sd = {
> +		.total_len = len,
> +		.flags = flags,
> +		.pos = *ppos,
> +		.u.file = out,
> +	};
> +	ssize_t ret;
> +
> +	mutex_lock(&pipe->inode->i_mutex);
> +	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
> +	mutex_unlock(&pipe->inode->i_mutex);
> +
> +	if (ret > 0) {
> +		unsigned long nr_pages;
> +
> +		*ppos += ret;
> +		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> +
> +		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
> +			int er;
> +
> +			er = sync_page_range_nolock(inode, mapping, *ppos, ret);
> +			if (er)
> +				ret = er;
> +		}
> +		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(generic_file_splice_write_file_nolock);

I don't think the balance_dirty_pages() is needed if we just did the
sync_page_range().


But really it'd be better if the throttling happened down in
pipe_to_file(), on a per-page basis.  As it stands we can dirty an
arbitrary number of pagecache pages without throttling.  I think?

