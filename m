Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXFWIIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXFWIIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXFWIIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:08:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47206 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFWIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:08:07 -0400
Date: Sat, 23 Jun 2007 09:08:04 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeffrey Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] make iunique use a do/while loop rather than its obscure goto loop
Message-ID: <20070623080804.GD28898@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeffrey Layton <jlayton@redhat.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200704112158.l3BLwunk023090@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704112158.l3BLwunk023090@dantu.rdu.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 05:58:56PM -0400, Jeffrey Layton wrote:
> A while back, Christoph mentioned that he thought that iunique ought to be
> cleaned up to use a more conventional loop construct. This patch does that,
> turning the strange goto loop into a do/while.
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
>  }
>  
>  EXPORT_SYMBOL(iunique);
---end quoted text---
