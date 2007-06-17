Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbXFQJi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbXFQJi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbXFQJiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:38:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:39536 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756970AbXFQJiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:38:16 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19sDFlsHUls5BGTj2w82RaNSPJ1bPJpGe4PBA1B3n
	CiU7J1y83Wa99B
Date: Sun, 17 Jun 2007 11:38:55 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Replace obscure constructs in fs/block_dev.c
Message-ID: <20070617093855.GA30197@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070615134632.GA11666@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070615134632.GA11666@saeurebad.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.15 15:46:32 +0200, Johannes Weiner wrote:
> Hi,
> 
> Andrew, I promised it [1], here goes. Patched against Linus' git-tree.
> 
> [1] http://lkml.org/lkml/2007/3/22/226
> 
> This patch replaces some obscure code-paths in fs/block_dev.c with more
> readable versions.
> 
> Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>
> 

> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index ea1480a..1ffbb6d 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -660,26 +660,16 @@ void bd_forget(struct inode *inode)
>  
>  int bd_claim(struct block_device *bdev, void *holder)
>  {
> -	int res;
> +	int res = 0;
>  	spin_lock(&bdev_lock);
>  
> -	/* first decide result */
> -	if (bdev->bd_holder == holder)
> -		res = 0;	 /* already a holder */
> -	else if (bdev->bd_holder != NULL)
> -		res = -EBUSY; 	 /* held by someone else */
> -	else if (bdev->bd_contains == bdev)
> -		res = 0;  	 /* is a whole device which isn't held */
> -
> -	else if (bdev->bd_contains->bd_holder == bd_claim)
> -		res = 0; 	 /* is a partition of a device that is being partitioned */
> -	else if (bdev->bd_contains->bd_holder != NULL)
> -		res = -EBUSY;	 /* is a partition of a held device */
> -	else
> -		res = 0;	 /* is a partition of an un-held device */
> +	/* If already held by someone else or we have a
> +	 * partition of a held device, we do nothing. */
>  
> -	/* now impose change */
> -	if (res==0) {
> +	if (bdev->bd_holder || bdev->bd_contains->bd_holder)
> +		res = -EBUSY;

Hm, that actually ignores the "someone else" part of the comment and
introduces a semantic change. No idea, if it breaks anything though.

Björn
