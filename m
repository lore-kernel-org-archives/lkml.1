Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbZGFHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbZGFHoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZGFHof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:44:35 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:41786 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZGFHoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:44:34 -0400
Message-ID: <4A51AAFB.1000601@oracle.com>
Date: Mon, 06 Jul 2009 15:42:51 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
       Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <jbacik@redhat.com>,
       Arjan <arjan@infradead.org>, Chris Mason <chris.mason@oracle.com>,
       akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
       Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [Patch v2] btrfs: use file_remove_suid() after i_mutex is held
References: <20090706072043.6555.13669.sendpatchset@localhost.localdomain>
In-Reply-To: <20090706072043.6555.13669.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A51AB02.00B4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amerigo,

Amerigo Wang wrote:
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
> 
> ---
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 7c3cd24..09ef5d6 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -944,14 +944,17 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
>  	if (count == 0)
>  		goto out_nolock;
>  
> +	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
> +	if (!pages)
> +		goto out_nolock;
I guess you need to set err to -ENOMEM here so that the caller knows 
what's wrong. With your patch, this function just return 0(since 
num_written and err are both 0) with no error, and I guess it is worse 
than kernel BUG out when the NULL pages is used later.

Regards,
Tao
