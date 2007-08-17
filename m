Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbXHQQMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbXHQQMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765385AbXHQQMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:12:09 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47529 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765140AbXHQQMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:12:06 -0400
Date: Fri, 17 Aug 2007 12:10:55 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH 11/23] mm: bdi init hooks
Message-ID: <20070817161055.GE24323@filer.fsl.cs.sunysb.edu>
References: <20070816074525.065850000@chello.nl> <20070816074627.235952000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816074627.235952000@chello.nl>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 09:45:36AM +0200, Peter Zijlstra wrote:
> provide BDI constructor/destructor hooks
...
> Index: linux-2.6/drivers/block/rd.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/rd.c
> +++ linux-2.6/drivers/block/rd.c
...
> @@ -419,7 +422,19 @@ static void __exit rd_cleanup(void)
>  static int __init rd_init(void)
>  {
>  	int i;
> -	int err = -ENOMEM;
> +	int err;
> +
> +	err = bdi_init(&rd_backing_dev_info);
> +	if (err)
> +		goto out2;
> +
> +	err = bdi_init(&rd_file_backing_dev_info);
> +	if (err) {
> +		bdi_destroy(&rd_backing_dev_info);
> +		goto out2;

How about this...

if (err)
	goto out3;

> +	}
> +
> +	err = -ENOMEM;
>  
>  	if (rd_blocksize > PAGE_SIZE || rd_blocksize < 512 ||
>  			(rd_blocksize & (rd_blocksize-1))) {
> @@ -473,6 +488,9 @@ out:
>  		put_disk(rd_disks[i]);
>  		blk_cleanup_queue(rd_queue[i]);
>  	}
> +	bdi_destroy(&rd_backing_dev_info);
> +	bdi_destroy(&rd_file_backing_dev_info);

	bdi_destroy(&rd_file_backing_dev_info);
out3:
	bdi_destroy(&rd_backing_dev_info);

Sure you might want to switch from numbered labels to something a bit more
descriptive.

> +out2:
>  	return err;
>  }
>  

Josef 'Jeff' Sipek.

-- 
The box said "Windows XP or better required". So I installed Linux.
