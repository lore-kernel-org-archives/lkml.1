Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYFERTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYFERTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYFERTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:19:22 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47499 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbYFERTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:19:19 -0400
Date: Thu, 5 Jun 2008 10:49:57 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] devscgroup: check for device permissions at mount
	time
Message-ID: <20080605154956.GC11919@us.ibm.com>
References: <4847A67D.9060006@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4847A67D.9060006@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Currently even if a task sits in an all-denied cgroup it can still 
> mount any block device in any mode it wants.
> 
> Put a proper check in do_open for block device to prevent this.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Crud.  Tested and confirmed, and this patches fixes it.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  fs/block_dev.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index a0e9596..7e1c7a3 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -24,6 +24,7 @@
>  #include <linux/namei.h>
>  #include <linux/log2.h>
>  #include <linux/hardirq.h>
> +#include <linux/device_cgroup.h>
> 
>  #include <asm/uaccess.h>
>  #include "internal.h"
> @@ -933,9 +934,14 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
>  {
>  	struct module *owner = NULL;
>  	struct gendisk *disk;
> -	int ret = -ENXIO;
> +	int ret;
>  	int part;
> 
> +	ret = devcgroup_inode_permission(bdev->bd_inode, file->f_mode);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = -ENXIO;
>  	file->f_mapping = bdev->bd_inode->i_mapping;
>  	lock_kernel();
>  	disk = get_gendisk(bdev->bd_dev, &part);
> -- 
> 1.5.3.4
