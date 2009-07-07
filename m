Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZGGKu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZGGKu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZGGKuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:50:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51032 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZGGKuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:50:13 -0400
Date: Tue, 7 Jul 2009 06:50:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [2/2] Optimize touch_time too
Message-ID: <20090707105016.GB23619@infradead.org>
References: <20090706924.495556466@firstfloor.org> <20090706192447.9D0531D024A@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706192447.9D0531D024A@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 09:24:47PM +0200, Andi Kleen wrote:
> 
> Do a similar optimization as earlier for touch_atime. Getting
> the lock in mnt_get_write is relatively costly, so try all
> avenues to avoid it first.
> 
> This patch is careful to still only update inode fields
> inside the lock region.
> 
> This didn't show up in benchmarks, but it's easy enough
> to do.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  fs/inode.c |   43 +++++++++++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 20 deletions(-)
> 
> Index: linux-2.6.31-rc1-ak/fs/inode.c
> ===================================================================
> --- linux-2.6.31-rc1-ak.orig/fs/inode.c
> +++ linux-2.6.31-rc1-ak/fs/inode.c
> @@ -1431,34 +1431,37 @@ void file_update_time(struct file *file)
>  {
>  	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct timespec now;
> -	int sync_it = 0;
> -	int err;
> +	enum { S_MTIME = 1, S_CTIME = 2, S_VERSION = 4 } sync_it = 0;

Looks good, and makes sense to keep thise in sync with
file_update_atime.
