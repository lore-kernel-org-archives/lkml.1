Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYCZAot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYCZAot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbYCZAol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:44:41 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48144 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757407AbYCZAol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:44:41 -0400
Message-ID: <406492300.07067@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 26 Mar 2008 08:44:36 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix lock inversion in drop_pagecache_sb()
References: <20080325181227.GE5125@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325181227.GE5125@duck.suse.cz>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1JeJkq-0001bZ-6Z@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 07:12:27PM +0100, Jan Kara wrote:
> Fix longstanding lock inversion in drop_pagecache_sb by dropping inode_lock
> before calling __invalidate_mapping_pages(). We just have to make sure
> inode won't go away from under us by keeping reference to it and putting
> the reference only after we have safely resumed the scan of the inode
> list. A bit tricky but not too bad...

Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

It's a handy trick to iterate through the list_head :-)
I have practiced this in my filecache code, and it works nice.

Fengguang

> Signed-off-by: Jan Kara <jack@suse.cz>
> CC: Fengguang Wu <wfg@mail.ustc.edu.cn>
> CC: David Chinner <dgc@sgi.com>
> 
> ---
>  fs/drop_caches.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 59375ef..f5aae26 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -14,15 +14,21 @@ int sysctl_drop_caches;
>  
>  static void drop_pagecache_sb(struct super_block *sb)
>  {
> -	struct inode *inode;
> +	struct inode *inode, *toput_inode = NULL;
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>  		if (inode->i_state & (I_FREEING|I_WILL_FREE))
>  			continue;
> +		__iget(inode);
> +		spin_unlock(&inode_lock);
>  		__invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
> +		iput(toput_inode);
> +		toput_inode = inode;
> +		spin_lock(&inode_lock);
>  	}
>  	spin_unlock(&inode_lock);
> +	iput(toput_inode);
>  }
>  
>  void drop_pagecache(void)
> -- 
> 1.5.2.4
> 

