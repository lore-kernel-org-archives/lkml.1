Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbYFFJYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbYFFJYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 05:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYFFJY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 05:24:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19053 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYFFJY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 05:24:26 -0400
Date: Fri, 6 Jun 2008 11:24:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Added in user-injected messages into blk traces
Message-ID: <20080606092423.GN5757@kernel.dk>
References: <4847DA2D.3030603@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4847DA2D.3030603@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05 2008, Alan D. Brunelle wrote:

> This allows a user to annotate the blk trace stream: writing a suitable
> message to {/sys/kernel/debug}/block/<dsf>/msg will have it propagated
> into the trace stream.

Looks good to me, I think this can be useful for ease of trace
annotation. Comments below.

> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> ---
>  block/blktrace.c             |   42 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blktrace_api.h |    1 +
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index 38e6b83..b9c4df2 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -253,6 +253,7 @@ err:
>  static void blk_trace_cleanup(struct blk_trace *bt)
>  {
>  	relay_close(bt->rchan);
> +	debugfs_remove(bt->msg_file);
>  	debugfs_remove(bt->dropped_file);
>  	blk_remove_tree(bt->dir);
>  	free_percpu(bt->sequence);
> @@ -299,6 +300,41 @@ static const struct file_operations blk_dropped_fops = {
>  	.read =		blk_dropped_read,
>  };
>  
> +static int blk_msg_open(struct inode *inode, struct file *filp)
> +{
> +	filp->private_data = inode->i_private;
> +
> +	return 0;
> +}
> +
> +static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	ssize_t ret = count;
> +
> +	if (count > BLK_TN_MAX_MSG)
> +		ret = -EINVAL;
> +	else {
> +		char *msg = kmalloc(BLK_TN_MAX_MSG, GFP_KERNEL);
> +
> +		if (copy_from_user(msg, buffer, count))
> +			ret = -EFAULT;
> +		else {
> +			struct blk_trace *bt = filp->private_data;
> +			__trace_note_message(bt, "%s", msg);
> +		}
> +		kfree(msg);

Would be cleaner with an explicit !msg check, though I think
copy_from_user() will notice and it'll work as-is.

if (count > BLK_TN_MAX_MSG)
        return -EINVAL;

msg = kmalloc(BLK_TN_MAX_MSG, GFP_KERNEL);
if (!msg)
        return -ENOMEM;

if (copy_from_user(msg, buffer, count))
        return -EFAULT;

...

is just a lot easier to directly follow imho. Otherwise I have no
problems with it, if you fix that up we can queue it for 2.6.27
inclusion.

-- 
Jens Axboe

