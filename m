Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZGFLm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZGFLm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZGFLms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:42:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35670 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZGFLmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:42:47 -0400
Date: Mon, 6 Jul 2009 07:45:58 -0400
From: Josef Bacik <josef@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
       Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <jbacik@redhat.com>,
       Arjan <arjan@infradead.org>, Chris Mason <chris.mason@oracle.com>,
       tao.ma@oracle.com, akpm@linux-foundation.org,
       linux-btrfs@vger.kernel.org, Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [Patch v3] btrfs: use file_remove_suid() after i_mutex is held
Message-ID: <20090706114558.GA19798@dhcp231-156.rdu.redhat.com>
References: <20090706091747.6656.91812.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706091747.6656.91812.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 05:15:33AM -0400, Amerigo Wang wrote:
> 
> V2 -> V3:
> set 'err' to -ENOMEM when kmalloc() fails. Thanks to Tao.
> 
> V1 -> V2:
> Move kmalloc() before mutex_lock(), suggested by Arjan.
> 
> file_remove_suid() should be called with i_mutex held,
> file_update_time() too. So move them after mutex_lock().
> 
> Plus, check the return value of kmalloc().
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Arjan <arjan@infradead.org>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Yan Zheng <zheng.yan@oracle.com>
> Cc: Sven Wegener <sven.wegener@stealer.net>
> Cc: Josef Bacik <jbacik@redhat.com>
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Tao Ma <tao.ma@oracle.com>
> 
> ---
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 7c3cd24..e7b0d81 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -944,14 +944,19 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
>  	if (count == 0)
>  		goto out_nolock;
>  
> +	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
> +	if (!pages) {
> +		err = -ENOMEM;
> +		goto out_nolock;
> +	}
> +
> +	mutex_lock(&inode->i_mutex);
> +
>  	err = file_remove_suid(file);
>  	if (err)
> -		goto out_nolock;
> +		goto out;
>  	file_update_time(file);
>  
> -	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
> -
> -	mutex_lock(&inode->i_mutex);
>  	BTRFS_I(inode)->sequence++;
>  	first_index = pos >> PAGE_CACHE_SHIFT;
>  	last_index = (pos + count) >> PAGE_CACHE_SHIFT;

Acked-by: Josef Bacik <jbacik@redhat.com>

Thanks,

Josef
