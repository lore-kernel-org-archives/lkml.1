Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZIRLdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZIRLdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZIRLdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:33:07 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:44793 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZIRLdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:33:06 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, jorg@ml1.net
Subject: Re: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to volume label
References: <1252420131.5782.2.camel@jorg-desktop>
	<1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
Date: Fri, 18 Sep 2009 20:33:06 +0900
In-Reply-To: <1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	(Jorg Schummer's message of "Tue, 8 Sep 2009 17:34:08 +0300")
Message-ID: <878wgcsd1p.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jorg Schummer <ext-jorg.2.schummer@nokia.com> writes:

> Standard FAT implementations cannot store any of the FAT root directory's
> timestamps. This commit adds the mount option 'rootts', which allows saving
> the FAT root directory timestamps as the timestamps of the FAT volume label
> directory entry. At least Mac OS X is known to support the same mechanism
> and interoperate with this commit.
>
> When mounting, the following values can be specified for the 'rootts' mount
> option:
>
>   "rootts=ignore"   ignores root directory timestamps. All timestamps are
>                     reset to 0 (1/1/1970). This has been the FAT behaviour
>                     prior to this patch.
>
>   "rootts=preserve" tries to load and save the root directory's timestamps
>                     if a volume label entry exists. The mtime and atime are
>                     corrected based on root directory entries' ctime. This
>                     is the default.
>
>   "rootts=save"     tries to load and save the root directory's timestamps.
>                     The mtime and atime are corrected based on root
>                     directory entries' ctime. If the root directory was
>                     accessed but no volume label entry exists, the label
>                     "NO NAME" is created.

Um..., I'm still not sure though. rootts=save may not be needed for
this, because it seems a bit complex, and it can do on userland...

And some quick review of implement..

> +	if (inode->i_ino == MSDOS_ROOT_INO) {
> +		if (sbi->options.root_ts == FAT_ROOT_TS_IGNORE)
> +			return 0;
> +
> +		/* Write the timestamps of a FAT file system's root directory
> +		 * as the timestamps of the file system's label dir entry. */
> +
> +		if (!MSDOS_I(inode)->i_pos) {
> +			struct buffer_head *bh;
> +			struct msdos_dir_entry *de;
> +			loff_t i_pos;
> +
> +			if (sbi->options.root_ts != FAT_ROOT_TS_SAVE)
> +				/* No label present, but we should not
> +				   create one. Thus not complaining. */
> +				return 0;
> +
> +			printk(KERN_INFO "FAT: creating volume label "
> +			       "on %s to save root dir timestamps\n",
> +			       sb->s_id);
> +
> +			err = fat_add_label_entry(inode, NULL);
> +			if (err)
> +				return err;
> +			err = fat_get_label_entry(inode, &bh, &de, &i_pos);
> +			if (err)
> +				return err;

In this path, we don't have inode->i_mutex, so to look directry up is
wrong. I think adding label may move to userland.

I guess we should do all of preparation in fill_super().

> +			remove_inode_hash(inode);
> +			fat_attach(inode, i_pos);
> +			insert_inode_hash(inode);
> +			brelse(bh);

Root inode should never change the position, so this shouldn't be
needed.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
