Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbZACShl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbZACShl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbZACShd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:37:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:3013 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbZACShc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BqoGoZDb52sxmtEdGgjPeXuDBCGO9pZ4jS7uX/Xy8hi6ei4BCAlcxx1bXfPtdUZuBb
         hatVXqjUEs/sAvpNus1W4XxuiJ6eQIrTO0nsI4V9K8E5fNQHs/54/w9020tfGvUsO3RH
         W1wwdOJvcatVwO4G16L6tKmxJ/PQLoqcd2AXk=
Message-ID: <6cf66ee10901031037ia2fdd57wdb7494dd6ff6a282@mail.gmail.com>
Date: Sat, 3 Jan 2009 08:37:30 -1000
From: "charles gagalac" <charles.gagalac@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: reiserfs broken with 2.6.28-17244-gb58602a
Cc: "Marc Koschewski" <marc@osknowledge.org>,
       Linux-LKLM <linux-kernel@vger.kernel.org>
In-Reply-To: <20090102132308.GE28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090102083645.GA3635@stiffy>
	 <20090102132308.GE28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 3:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Arrgh.  See if that helps:
>
> now that we use ih.key earlier, we need to do all its setup early enough
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index 145c2d3..1306d4f 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -1782,6 +1782,12 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
>                goto out_bad_inode;
>        }
>        args.objectid = inode->i_ino = le32_to_cpu(ih.ih_key.k_objectid);
> +       if (old_format_only(sb))
> +               make_le_item_head(&ih, NULL, KEY_FORMAT_3_5, SD_OFFSET,
> +                                 TYPE_STAT_DATA, SD_V1_SIZE, MAX_US_INT);
> +       else
> +               make_le_item_head(&ih, NULL, KEY_FORMAT_3_6, SD_OFFSET,
> +                                 TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
>        memcpy(INODE_PKEY(inode), &(ih.ih_key), KEY_SIZE);
>        args.dirid = le32_to_cpu(ih.ih_key.k_dir_id);
>        if (insert_inode_locked4(inode, args.objectid,
> @@ -1834,13 +1840,6 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
>        reiserfs_init_acl_default(inode);
>        reiserfs_init_xattr_rwsem(inode);
>
> -       if (old_format_only(sb))
> -               make_le_item_head(&ih, NULL, KEY_FORMAT_3_5, SD_OFFSET,
> -                                 TYPE_STAT_DATA, SD_V1_SIZE, MAX_US_INT);
> -       else
> -               make_le_item_head(&ih, NULL, KEY_FORMAT_3_6, SD_OFFSET,
> -                                 TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
> -
>        /* key to search for correct place for new stat data */
>        _make_cpu_key(&key, KEY_FORMAT_3_6, le32_to_cpu(ih.ih_key.k_dir_id),
>                      le32_to_cpu(ih.ih_key.k_objectid), SD_OFFSET,
> --

the patch fixed the reiserfs problem for me.  thanks.

charles
