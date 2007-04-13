Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXDMSnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXDMSnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 14:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXDMSnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 14:43:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45656 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbXDMSnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 14:43:19 -0400
Date: Fri, 13 Apr 2007 11:42:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeffrey Layton <jlayton@redhat.com>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] make iunique use a do/while loop rather than its
 obscure goto loop
Message-Id: <20070413114214.cb9328f5.akpm@linux-foundation.org>
In-Reply-To: <200704112158.l3BLwunk023090@dantu.rdu.redhat.com>
References: <200704112158.l3BLwunk023090@dantu.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 17:58:56 -0400
Jeffrey Layton <jlayton@redhat.com> wrote:

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

hm.

ino_t iunique(struct super_block *sb, ino_t max_reserved)
{
	static ino_t counter;
	struct inode *inode;
	struct hlist_head * head;
	ino_t res;

	spin_lock(&inode_lock);
	do {
		if (counter <= max_reserved)
			counter = max_reserved + 1;
		res = counter++;
		head = inode_hashtable + hash(sb, res);
		inode = find_inode_fast(sb, head, res);
	} while (inode != NULL);
	spin_unlock(&inode_lock);

	return res;
}

The counter-vs-max_reserved test can be moved outside the loop, can't it?

Shouldn't counter be per-sb?

