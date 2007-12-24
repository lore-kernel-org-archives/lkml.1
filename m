Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXLXCuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXLXCuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 21:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXLXCup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 21:50:45 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2415 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbXLXCup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 21:50:45 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] UPDATED: hfs: handle more on-disk corruptions without oopsing
Date: Mon, 24 Dec 2007 03:16:41 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <47699C29.4010706@redhat.com> <476A8F36.2050007@redhat.com>
In-Reply-To: <476A8F36.2050007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712240316.43308.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 20 December 2007, Eric Sandeen wrote:

> Index: linux-2.6.24-rc3/fs/hfs/brec.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/hfs/brec.c
> +++ linux-2.6.24-rc3/fs/hfs/brec.c
> @@ -44,10 +44,21 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
>  		recoff = hfs_bnode_read_u16(node, node->tree->node_size - (rec + 1) *
> 2); if (!recoff)
>  			return 0;
> -		if (node->tree->attributes & HFS_TREE_BIGKEYS)
> +		if (node->tree->attributes & HFS_TREE_BIGKEYS) {
>  			retval = hfs_bnode_read_u16(node, recoff) + 2;
> -		else
> +			if (retval > node->tree->max_key_len + 2) {
> +				printk(KERN_ERR "hfs: keylen %d too large\n",
> +					retval);
> +				retval = HFS_BAD_KEYLEN;
> +			}
> +		} else {
>  			retval = (hfs_bnode_read_u8(node, recoff) | 1) + 1;
> +			if (retval > node->tree->max_key_len + 1) {
> +				printk(KERN_ERR "hfs: keylen %d too large\n",
> +					retval);
> +				retval = HFS_BAD_KEYLEN;
> +			}
> +		}
>  	}
>  	return retval;
>  }

You can reuse 0 as failure value, a key has to be of nonzero size.

> Index: linux-2.6.24-rc3/fs/hfs/btree.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/hfs/btree.c
> +++ linux-2.6.24-rc3/fs/hfs/btree.c
> @@ -81,6 +81,17 @@ struct hfs_btree *hfs_btree_open(struct
>  		goto fail_page;
>  	if (!tree->node_count)
>  		goto fail_page;
> +	if ((id == HFS_EXT_CNID) && (tree->max_key_len != HFS_MAX_EXT_KEYLEN)) {
> +		printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
> +			tree->max_key_len);
> +		goto fail_page;
> +	}
> +	if ((id == HFS_CAT_CNID) && (tree->max_key_len != HFS_MAX_CAT_KEYLEN)) {
> +		printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
> +			tree->max_key_len);
> +		goto fail_page;
> +	}
> +
>  	tree->node_size_shift = ffs(size) - 1;
>  	tree->pages_per_bnode = (tree->node_size + PAGE_CACHE_SIZE - 1) >>
> PAGE_CACHE_SHIFT;
>

I'd prefer a switch statement here.

It would be nice if you could do the same changes for hfsplus, so both stay in 
sync.
Thanks.

bye, Roman
