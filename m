Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbXJVNGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbXJVNGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXJVNGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:06:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:2526 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXJVNGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QoFQ7NQnLxIeSoDULfmb9VcZc2tU1Ew+nKyG+m9JjZYB6pqUl5vIvCnZmFPIyj8OoKgx/tVc+CZXnLX+GRIBHVOQHDWnIJgAy8HeCArjDUGZIErt5PG6qKzj6NC/qnZPCqIVtGrlTRluL5E82FXjEVKRTdDR4lcpeNvqwvkH/+c=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: 100% iowait on one of cpus in current -git
Date: Mon, 22 Oct 2007 15:05:35 +0200
User-Agent: KMail/1.9.6
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221421.21439.maximlevitsky@gmail.com> <393056632.00561@ustc.edu.cn>
In-Reply-To: <393056632.00561@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221505.35397.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 14:37:07 Fengguang Wu wrote:
> On Mon, Oct 22, 2007 at 02:21:21PM +0200, Maxim Levitsky wrote:
> > I Bisected this bug to exactly this commit:
> > 
> > 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b
> > writeback: introduce writeback_control.more_io to indicate more io
> > 
> > Reverting it and compiling latest git shows no more signs of that bug.
> 
> Thank you very much.
> 
> I guess your system has some difficulty in writing back some inodes.
> (i.e. a bug disclosed by this patch, the 100% iowait only makes it
> more obvious)
> 
> I cannot reproduce it with your .config, so would you recompile and
> run the kernel with the above commit _and_ the below debugging patch?
> 
> Thank you,
> Fengguang
> ---
> 
>  fs/fs-writeback.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.23-git17.orig/fs/fs-writeback.c
> +++ linux-2.6.23-git17/fs/fs-writeback.c
> @@ -164,12 +164,25 @@ static void redirty_tail(struct inode *i
>  	list_move(&inode->i_list, &sb->s_dirty);
>  }
>  
> +#define requeue_io(inode)						\
> +	do {								\
> +		__requeue_io(inode, __LINE__);				\
> +	} while (0)
> +
>  /*
>   * requeue inode for re-scanning after sb->s_io list is exhausted.
>   */
> -static void requeue_io(struct inode *inode)
> +static void __requeue_io(struct inode *inode, int line)
>  {
>  	list_move(&inode->i_list, &inode->i_sb->s_more_io);
> +
> +	printk(KERN_DEBUG "redirtied inode %lu size %llu at %02x:%02x(%s), line %d.\n",
> +			inode->i_ino,
> +			i_size_read(inode),
> +			MAJOR(inode->i_sb->s_dev),
> +			MINOR(inode->i_sb->s_dev),
> +			inode->i_sb->s_id,
> +			line);
>  }
>  
>  static void inode_sync_complete(struct inode *inode)
> 
> 

Hi,
Thank you very much too, for helping me.


Applied.
Had to kill klogd, since kernel generates tons of redirtied inode messages.
Size of the kern.log is 863 KB, thus I I don't think it is polite to attachit.
Don't know whenever it is ok to put it on pastebin too.

Anyway, it shows lots of redirtied inode... messages,
and while most of them are "at 08:02(sda2)" , my reiserfs root partition, some are

"Oct 22 14:50:27 MAIN kernel: [   73.643794] redirtied inode 2582 size 0 at 00:0f(tmpfs), line 300."

" line 300" is shown always

(I have /var/run, /var/lock, /dev mounted as tmpfs, default kubuntu setup)


Best regards,
	Maxim Levitsky
