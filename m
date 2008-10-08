Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYJHO54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYJHO54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 10:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYJHO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 10:57:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbYJHO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 10:57:44 -0400
Message-ID: <48ECCA5F.4070905@redhat.com>
Date: Wed, 08 Oct 2008 09:57:35 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
CC: Andreas Dilger <adilger@Sun.COM>, Eric Sandeen <sandeen@sandeen.net>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext4 deadlocks
References: <48EBB9E9.4030105@goop.org> <48EBC6B9.7000608@sandeen.net> <20081007214637.GA2009@webber.adilger.int> <1223441351.4007.137.camel@localhost>
In-Reply-To: <1223441351.4007.137.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kalpak Shah wrote:

> ext4_xattr_set_handle() eventually ends up calling
> ext4_mark_inode_dirty() which tries to expand the inode by shifting the
> EAs. This leads to the xattr_sem being downed again and leading to a
> deadlock.
> 
> This patch makes sure that if ext4_xattr_set_handle() is in the
> call-chain, ext4_mark_inode_dirty() will not expand the inode.
> 
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

Yes, this fixes my testcase.  Thanks, Kalpak.

-Eric

> Index: linux-2.6.27-rc7/fs/ext4/xattr.c
> ===================================================================
> --- linux-2.6.27-rc7.orig/fs/ext4/xattr.c
> +++ linux-2.6.27-rc7/fs/ext4/xattr.c
> @@ -959,6 +959,7 @@ ext4_xattr_set_handle(handle_t *handle, 
>  	struct ext4_xattr_block_find bs = {
>  		.s = { .not_found = -ENODATA, },
>  	};
> +	unsigned long no_expand;
>  	int error;
>  
>  	if (!name)
> @@ -966,6 +967,9 @@ ext4_xattr_set_handle(handle_t *handle, 
>  	if (strlen(name) > 255)
>  		return -ERANGE;
>  	down_write(&EXT4_I(inode)->xattr_sem);
> +	no_expand = EXT4_I(inode)->i_state & EXT4_STATE_NO_EXPAND;
> +	EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
> +
>  	error = ext4_get_inode_loc(inode, &is.iloc);
>  	if (error)
>  		goto cleanup;
> @@ -1042,6 +1046,8 @@ ext4_xattr_set_handle(handle_t *handle, 
>  cleanup:
>  	brelse(is.iloc.bh);
>  	brelse(bs.bh);
> +	if (no_expand == 0)
> +		EXT4_I(inode)->i_state &= ~EXT4_STATE_NO_EXPAND;
>  	up_write(&EXT4_I(inode)->xattr_sem);
>  	return error;
>  }
> 
> Thanks,
> Kalpak
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

