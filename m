Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYJTSnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYJTSnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYJTSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:43:08 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13291 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYJTSnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:43:07 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add block device speciffic splice write method
References: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org>
	<20081020174931.GH19428@kernel.dk> <20081020181156.GI19428@kernel.dk>
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Mon, 20 Oct 2008 22:42:25 +0400
In-Reply-To: <20081020181156.GI19428@kernel.dk> (Jens Axboe's message of "Mon\, 20 Oct 2008 20\:11\:56 +0200")
Message-ID: <m31vybf6r2.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Mon, Oct 20 2008, Jens Axboe wrote:
>> On Sun, Oct 19 2008, Dmitri Monakhov wrote:
>> > Block device write procedure is different from regular file:
>> >  - Actual write performed without i_mutex.
>> >  - It has no metadata, so generic_osync_inode(O_SYNCMETEDATA) can not livelock.
>> >  - We do not have to worry about S_ISUID/S_ISGID bits.
>> 
>> I already did an O_DIRECT part of block device splicing [1], I'll fold
>> this into the splice branch and double check with some testing.
>> 
>> [1] http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=fbb724a0484aba938024d41ca1dd86337d2550c9;hp=08c7910b275a4c580ad646ae8654439c8dfae4c5
>
> The below is what I merged. Note that I changed the naming and made the
> function look a lot more like the other splice helpers, so it's more
> apparent how it differs. Let me know if I can add you Signed-off-by to
Off course yes.
> this one (preferably after you test it as well :-)
currently i'm testing this stuff.
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 4d154dc..083198a 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1288,7 +1288,7 @@ new_bio:
>   * Splice to file opened with O_DIRECT. Bypass caching completely and
>   * just go direct-to-bio
>   */
> -static ssize_t __block_splice_write(struct pipe_inode_info *pipe,
> +static ssize_t __block_splice_direct_write(struct pipe_inode_info *pipe,
>  				    struct file *out, loff_t *ppos, size_t len,
>  				    unsigned int flags)
>  {
> @@ -1318,6 +1318,9 @@ static ssize_t __block_splice_write(struct pipe_inode_info *pipe,
>  	if (bsd.bio)
>  		submit_bio(WRITE, bsd.bio);
>  
> +	if (ret > 0)
> +		*ppos += ret;
> +
>  	return ret;
>  }
>  
> @@ -1327,12 +1330,11 @@ static ssize_t block_splice_write(struct pipe_inode_info *pipe,
>  {
>  	ssize_t ret;
>  
> -	if (out->f_flags & O_DIRECT) {
> -		ret = __block_splice_write(pipe, out, ppos, len, flags);
> -		if (ret > 0)
> -			*ppos += ret;
> -	} else
> -		ret = generic_file_splice_write(pipe, out, ppos, len, flags);
> +	if (out->f_flags & O_DIRECT)
> +		ret = __block_splice_direct_write(pipe, out, ppos, len, flags);
> +	else
> +		ret = generic_file_splice_write_file_nolock(pipe, out, ppos,
> +								len, flags);
>  
>  	return ret;
>  }
> diff --git a/fs/splice.c b/fs/splice.c
> index 4108264..eb1e1ac 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -788,6 +788,59 @@ ssize_t splice_from_pipe(struct pipe_inode_info *pipe, struct file *out,
>  }
>  
>  /**
> + * generic_file_splice_write_file_nolock - splice data from a pipe to a file
> + * @pipe:	pipe info
> + * @out:	file to write to
> + * @ppos:	position in @out
> + * @len:	number of bytes to splice
> + * @flags:	splice modifier flags
> + *
> + * Description:
> + *    Will either move or copy pages (determined by @flags options) from
> + *    the given pipe inode to the given block device.
> + *    Note: this is like @generic_file_splice_write, except that we
> + *    don't bother locking the output file. Useful for splicing directly
> + *    to a block device.
> + */
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
> +
> +/**
>   * generic_file_splice_write_nolock - generic_file_splice_write without mutexes
>   * @pipe:	pipe info
>   * @out:	file to write to
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a6a625b..5c9b880 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1957,6 +1957,8 @@ extern ssize_t generic_file_splice_write(struct pipe_inode_info *,
>  		struct file *, loff_t *, size_t, unsigned int);
>  extern ssize_t generic_file_splice_write_nolock(struct pipe_inode_info *,
>  		struct file *, loff_t *, size_t, unsigned int);
> +extern ssize_t generic_file_splice_write_file_nolock(struct pipe_inode_info *,
> +		struct file *, loff_t *, size_t, unsigned int);
>  extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
>  		struct file *out, loff_t *, size_t len, unsigned int flags);
>  extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
