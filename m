Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbYDSV3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbYDSV3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYDSV3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:29:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:54903 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYDSV33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=immjRw2L6S8em+PLwYXcEgQO+PmKx3Pdnlhrrs/6hDOjLMIfyDXLprFH1Bz+OivsroIpJR9MI+8PfEOKM/tLPIiRyvHSOaCHo9JEeNegtVTFbVwQGqfReEAu4Zxxp3n0LTxkiY9nCjponxU+3nvzaQm1hUDKw22cKaTnVrM22og=
Date: Sat, 19 Apr 2008 23:28:49 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/8] omfs: add inode routines
Message-ID: <20080419212842.GA7888@joi>
References: <1208637457-24969-4-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208637457-24969-4-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 04:37:32PM -0400, Bob Copeland wrote:
> +static int omfs_get_imap(struct super_block *sb)
> +{
> +	int bitmap_size;
> +	int array_size;
> +	int count;
> +	struct omfs_sb_info *sbi = OMFS_SB(sb);
> +	struct buffer_head *bh;
> +	unsigned long **ptr;
> +	sector_t block;
> +
> +	bitmap_size = (sbi->s_num_blocks + 7) / 8;
> +	array_size = (bitmap_size + sb->s_blocksize - 1) / sb->s_blocksize;
these are DIV_ROUND_UP

> +
> +	if (sbi->s_bitmap_ino == ~0ULL)
> +		goto out;
> +
> +	sbi->s_imap_size = array_size;
> +	sbi->s_imap = kzalloc(array_size * sizeof(unsigned long *), GFP_KERNEL);
> +	if (!sbi->s_imap)
> +		goto nomem;
> +
> +	block = clus_to_blk(sbi, sbi->s_bitmap_ino);
> +	ptr = sbi->s_imap;
> +	for (count = bitmap_size; count > 0; count -= sb->s_blocksize) {
> +		bh = sb_bread(sb, block++);
> +		if (!bh)
> +			goto nomem_free;
> +		*ptr = kmalloc(sb->s_blocksize, GFP_KERNEL);
> +		if (!*ptr) {
> +			brelse(bh);
> +			goto nomem_free;
> +		}
> +		memcpy(*ptr, bh->b_data, sb->s_blocksize);
> +		if (count < sb->s_blocksize)
> +			memset((void *)*ptr + count, 0xff,
> +				sb->s_blocksize - count);
> +		brelse(bh);
> +		ptr++;
> +	}
> +out:
> +	return 0;
> +
> +nomem_free:
> +	for (count = 0; count < array_size; count++)
> +		kfree(sbi->s_imap[count]);
> +
> +	kfree(sbi->s_imap);
> +nomem:
> +	sbi->s_imap = NULL;
> +	sbi->s_imap_size = 0;
> +	return -ENOMEM;
> +}
> +
> +static void set_block_shift(struct omfs_sb_info *sbi)
> +{
> +	unsigned int scale = sbi->s_blocksize / sbi->s_sys_blocksize;
> +	sbi->s_block_shift = 0;
> +	for (scale >>= 1; scale; scale >>= 1)
> +		sbi->s_block_shift++;
> +}
isn't it get_bitmask_order(scale - 1)?

Marcin
