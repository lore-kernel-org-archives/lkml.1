Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZAENUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZAENUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZAENUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:20:08 -0500
Received: from genesysrack.ru ([195.178.208.66]:48164 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZAENUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:20:07 -0500
Date: Mon, 5 Jan 2009 16:20:04 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: Re: [PATCH V3 01/17] Squashfs: inode operations
Message-ID: <20090105132004.GB14147@ioremap.net>
References: <E1LJnJn-0002L2-GZ@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LJnJn-0002L2-GZ@dylan.lougher.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Jan 05, 2009 at 11:08:23AM +0000, Phillip Lougher (phillip@lougher.demon.co.uk) wrote:
> +int squashfs_read_inode(struct inode *inode, long long ino)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	struct squashfs_sb_info *msblk = sb->s_fs_info;
> +	u64 block = SQUASHFS_INODE_BLK(ino) + msblk->inode_table;
> +	int err, type, offset = SQUASHFS_INODE_OFFSET(ino);
> +	union squashfs_inode squashfs_ino;
> +	struct squashfs_base_inode *sqshb_ino = &squashfs_ino.base;
> +

What's the size of that union? If big enough it will lead to some
problems.

> +	TRACE("Entered squashfs_read_inode\n");
> +
> +	/*
> +	 * Read inode base common to all inode types.
> +	 */
> +	err = squashfs_read_metadata(sb, sqshb_ino, &block,
> +				&offset, sizeof(*sqshb_ino));
> +	if (err < 0)
> +		goto failed_read;
> +
> +	err = squashfs_new_inode(sb, inode, sqshb_ino);
> +	if (err)
> +		goto failed_read;
> +
> +	block = SQUASHFS_INODE_BLK(ino) + msblk->inode_table;
> +	offset = SQUASHFS_INODE_OFFSET(ino);
> +
> +	type = le16_to_cpu(sqshb_ino->inode_type);
> +	switch (type) {
> +	case SQUASHFS_REG_TYPE: {
> +		unsigned int frag_offset, frag_size, frag;
> +		u64 frag_blk;

Above variables can be moved out of the switch, since they are used in
some other cases too.

-- 
	Evgeniy Polyakov
