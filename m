Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYJWGac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYJWGac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJWGaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:30:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47064 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbYJWGaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:30:22 -0400
Date: Thu, 23 Oct 2008 08:29:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitri Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add block device speciffic splice write method
Message-ID: <20081023062921.GQ22217@kernel.dk>
References: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org> <20081020174931.GH19428@kernel.dk> <20081020181156.GI19428@kernel.dk> <20081022223928.a6ce476f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022223928.a6ce476f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22 2008, Andrew Morton wrote:
> On Mon, 20 Oct 2008 20:11:56 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > +ssize_t generic_file_splice_write_file_nolock(struct pipe_inode_info *pipe,
> > +					      struct file *out, loff_t *ppos,
> > +					      size_t len, unsigned int flags)
> > +{
> > +	struct address_space *mapping = out->f_mapping;
> > +	struct inode *inode = mapping->host;
> > +	struct splice_desc sd = {
> > +		.total_len = len,
> > +		.flags = flags,
> > +		.pos = *ppos,
> > +		.u.file = out,
> > +	};
> > +	ssize_t ret;
> > +
> > +	mutex_lock(&pipe->inode->i_mutex);
> > +	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
> > +	mutex_unlock(&pipe->inode->i_mutex);
> > +
> > +	if (ret > 0) {
> > +		unsigned long nr_pages;
> > +
> > +		*ppos += ret;
> > +		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
> > +
> > +		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
> > +			int er;
> > +
> > +			er = sync_page_range_nolock(inode, mapping, *ppos, ret);
> > +			if (er)
> > +				ret = er;
> > +		}
> > +		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
> > +	}
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(generic_file_splice_write_file_nolock);
> 
> I don't think the balance_dirty_pages() is needed if we just did the
> sync_page_range().

Good point, I think we can get rid of that.
> 
> 
> But really it'd be better if the throttling happened down in
> pipe_to_file(), on a per-page basis.  As it stands we can dirty an
> arbitrary number of pagecache pages without throttling.  I think?

That's pretty exactly why it isn't done in the actor, to avoid doing it
per-page. As it's going to be PIPE_BUFFERS (16) pages max, I think this
is better.

Back in the splice early days, the balance_dirty_pages() actually showed
up in profiles when it was done on a per-page basis. So I'm reluctant to
change it :-)

-- 
Jens Axboe

