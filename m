Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZGFFrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZGFFrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZGFFrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:47:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:35317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZGFFra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:47:30 -0400
Date: Sun, 5 Jul 2009 22:48:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
       Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <jbacik@redhat.com>,
       Chris Mason <chris.mason@oracle.com>, Amerigo Wang <amwang@redhat.com>,
       akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
       Sven Wegener <sven.wegener@stealer.net>
Subject: Re: [Patch] btrfs: use file_remove_suid() after i_mutex is held
Message-ID: <20090705224823.5679075f@infradead.org>
In-Reply-To: <20090706053128.6318.16410.sendpatchset@localhost.localdomain>
References: <20090706053128.6318.16410.sendpatchset@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 01:29:14 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> 
> file_remove_suid() should be called with i_mutex held,
> file_update_time() too. So move them after mutex_lock().
> 
> Plus, check the return value of kmalloc().
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 7c3cd24..cd36301 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -944,14 +944,17 @@ static ssize_t btrfs_file_write(struct file
> *file, const char __user *buf, if (count == 0)
>  		goto out_nolock;
>  
> +	mutex_lock(&inode->i_mutex);
> +
>  	err = file_remove_suid(file);
>  	if (err)
> -		goto out_nolock;
> +		goto out;
>  	file_update_time(file);
>  
>  	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
> +	if (!pages)
> +		goto out;
>  
Hi,

I don't think you can keep this at GFP_KERNEL once you hold i_mutex....
very likely this needs to now turn into GFP_NOFS!



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
