Return-Path: <linux-kernel-owner+w=401wt.eu-S1762274AbXEJWrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274AbXEJWrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbXEJWrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:47:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbXEJWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:47:24 -0400
Date: Thu, 10 May 2007 15:46:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-Id: <20070510154640.c0299a52.akpm@linux-foundation.org>
In-Reply-To: <20070510140000.GA12399@cvg>
References: <20070510140000.GA12399@cvg>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 18:00:00 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch adds cheking for granted memory while
> filling up inode data to prevent possible NULL
> pointer usage. If there is not enough memory to
> fill inode data we just mark it as "bad".
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Please check the patch, maybe just marking inode as
> "bad" is not a good solution.
> 

yes, make_bad_inode() is appropriate here.

> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index c846155..91cddae 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1144,6 +1144,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  		UDF_I_EFE(inode) = 1;
>  		UDF_I_USE(inode) = 0;
>  		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
> +		if (!UDF_I_DATA(inode))
> +		{
> +			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
> +			       inode->i_ino);
> +			make_bad_inode(inode);
> +			return;
> +		}

But please let's not add three copies of identical code.  Do something like:

static int udf_check_inode(struct inode *inode)
{
	if (!UDF_I_DATA(inode)) {
		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
			inode->i_ino);
		make_bad_inode(inode);
		return -1;
	}
	return 0;
}


	if (udf_check_inode(inode))
		return;

In fact you can also do the kmalloc in that helper function too:

static int udf_alloc_i_data(struct inode *inode, size_t size)
{
	UDF_I_DATA(inode) = kmalloc(...);
	...
}
