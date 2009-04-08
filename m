Return-Path: <linux-kernel-owner+w=401wt.eu-S1764458AbZDHNX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764458AbZDHNX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761189AbZDHNXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:23:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974AbZDHNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:23:15 -0400
Date: Wed, 8 Apr 2009 09:22:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: felixb@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [PATCH 4/6] xfs: use memdup_user()
Message-ID: <20090408132254.GA5957@infradead.org>
References: <49DC4CC0.9050805@cn.fujitsu.com> <49DC4D54.3020001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DC4D54.3020001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 03:08:04PM +0800, Li Zefan wrote:
> Remove open-coded memdup_user()
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/xfs/linux-2.6/xfs_ioctl.c   |   23 +++++++----------------
>  fs/xfs/linux-2.6/xfs_ioctl32.c |   12 ++++--------
>  2 files changed, 11 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index d0b4994..34eaab6 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -489,17 +489,12 @@ xfs_attrmulti_attr_set(
>  	if (len > XATTR_SIZE_MAX)
>  		return EINVAL;
>  
> -	kbuf = kmalloc(len, GFP_KERNEL);
> -	if (!kbuf)
> -		return ENOMEM;
> -
> -	if (copy_from_user(kbuf, ubuf, len))
> -		goto out_kfree;
> +	kbuf = memdup_user(ubuf, len);
> +	if (IS_ERR(kbuf))
> +		return PTR_ERR(kbuf);

wouldn't NULL be a better error return for this kind of interface,
matching kmalloc?


Otherwise the patch looks good to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>
