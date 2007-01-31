Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbXAaIQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbXAaIQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXAaIQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:16:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45342 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXAaIQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:16:50 -0500
Date: Wed, 31 Jan 2007 08:16:49 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeffrey Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH] make iunique use a do/while loop rather than its obscure goto loop
Message-ID: <20070131081649.GA25032@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeffrey Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200701301545.l0UFjsCw027749@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701301545.l0UFjsCw027749@dantu.rdu.redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 10:45:54AM -0500, Jeffrey Layton wrote:
> While working on a case, Christoph mentioned that he thought that iunique
> ought to be cleaned up to use a more conventional loop construct. This patch
> does that, turning the strange goto loop into a do/while.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 23fc1fd..90e7587 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -689,21 +689,18 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
>  	struct inode *inode;
>  	struct hlist_head * head;
>  	ino_t res;
> +
>  	spin_lock(&inode_lock);
> -retry:
> -	if (counter > max_reserved) {
> -		head = inode_hashtable + hash(sb,counter);
> +	do {
> +		if (counter <= max_reserved)
> +			counter = max_reserved + 1;
>  		res = counter++;
> +		head = inode_hashtable + hash(sb, res);
>  		inode = find_inode_fast(sb, head, res);
> -		if (!inode) {
> -			spin_unlock(&inode_lock);
> -			return res;
> -		}
> -	} else {
> -		counter = max_reserved + 1;
> -	}
> -	goto retry;
> -	
> +	} while (inode != NULL);
> +	spin_unlock(&inode_lock);
> +
> +	return res;

Looks good, thanks
