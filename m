Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZHTNTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZHTNTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZHTNTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:19:10 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:44610 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbZHTNTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:19:09 -0400
Subject: Re: [PATCH 2/4] direct-io: make O_DIRECT IO path be page based
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
	 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
	 <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
	 <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 09:19:04 -0400
Message-Id: <1250774344.5352.34.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 10 msgs/h 2 sum rcpts/h 13 sum msgs/h 3 total rcpts 1128 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A96E83BDEF0DFA65A0509F009C7ED4A0E003172E
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 153 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 12:17 +0200, Jens Axboe wrote:
> Currently we pass in the iovec array and let the O_DIRECT core
> handle the get_user_pages() business. This work, but it means that
> we can ever only use user pages for O_DIRECT.
> 
> Switch the aops->direct_IO() and below code to use page arrays
> instead, so that it doesn't make any assumptions about who the pages
> belong to. This works directly for all users but NFS, which just
> uses the same helper that the generic mapping read/write functions
> also call.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
> -						 const struct iovec *iov,
> -						 loff_t pos, int sync)
> +						 struct dio_args *args,
> +						 int sync)
>  {
>  	struct nfs_open_context *ctx = dreq->ctx;
>  	struct inode *inode = ctx->path.dentry->d_inode;
> -	unsigned long user_addr = (unsigned long)iov->iov_base;
> -	size_t count = iov->iov_len;
> +	unsigned long user_addr = args->user_addr;
> +	size_t count = args->length;
>  	struct rpc_task *task;
>  	struct rpc_message msg = {
>  		.rpc_cred = ctx->cred,
> @@ -726,24 +702,8 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
>  		if (unlikely(!data))
>  			break;
>  
> -		down_read(&current->mm->mmap_sem);
> -		result = get_user_pages(current, current->mm, user_addr,
> -					data->npages, 0, 0, data->pagevec, NULL);
> -		up_read(&current->mm->mmap_sem);
> -		if (result < 0) {
> -			nfs_writedata_free(data);
> -			break;
> -		}
> -		if ((unsigned)result < data->npages) {
> -			bytes = result * PAGE_SIZE;
> -			if (bytes <= pgbase) {
> -				nfs_direct_release_pages(data->pagevec, result);
> -				nfs_writedata_free(data);
> -				break;
> -			}
> -			bytes -= pgbase;
> -			data->npages = result;
> -		}
> +		data->pagevec = args->pages;
> +		data->npages = args->nr_segs;
>  
>  		get_dreq(dreq);
>  

This looks a bit odd. What guarantees that args->pages contain <= wsize
bytes? The server will not accept larger segments in a single RPC call.

Cheers
  Trond

