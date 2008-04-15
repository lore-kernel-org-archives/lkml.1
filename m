Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbYDOSik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbYDOSik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYDOSic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:38:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:25707 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYDOSic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ivvgjhrOtWDxl9rw3y0pziyPsdA4fDLwylwRhZp/PXyeJ37bZnD29ed6qY0tNCVCdshth1FVhVRIDUf0AIykjHG1eDBENPZm9+PHGbl0BQR+l/0GaH7iJsKigWUMvsmhE+zhUDrfLonABTA9179ektUL+9nVfuMB4cUKCfhm0gI=
Date: Tue, 15 Apr 2008 20:30:59 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] omfs: add inode routines
Message-ID: <20080415183054.GA7176@joi>
References: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 06:58:36PM -0400, Bob Copeland wrote:
> +static int omfs_fill_super(struct super_block *sb, void *data, int silent)
> +{
> +	struct buffer_head *bh = NULL, *bh2 = NULL;
> +	struct omfs_super_block *omfs_sb;
> +	struct omfs_root_block *omfs_rb;
> +	struct omfs_sb_info *sbi;
> +	struct inode *root;
> +	sector_t start;
> +	int ret = 0;
> +
> +	sbi = kzalloc(sizeof(struct omfs_sb_info), GFP_KERNEL);
> +	if (!sbi)
> +		return -ENOMEM;
> +	sb->s_fs_info = sbi;
> +
> +	sb->s_maxbytes = 0xffffffff;
> +
> +	sb_set_blocksize(sb, 0x200);
> +
> +	bh = sb_bread(sb, 0);
> +	if (!bh)
> +		goto out;
> +
> +	omfs_sb = (struct omfs_super_block *)bh->b_data;
> +
> +	if (be32_to_cpu(omfs_sb->s_magic) != OMFS_MAGIC) {

can be omfs_sb->s_magic != cpu_to_be32(OMFS_MAGIC)
(cpu_to_be32 can be optimized away even on LE)


> +		if (!silent)
> +			printk(KERN_ERR "omfs: Invalid superblock (%x)\n",
> +				   omfs_sb->s_magic);
> +		goto out;
> +	}
> +	sb->s_magic = OMFS_MAGIC;
> +
> +	sbi->s_num_blocks = be64_to_cpu(omfs_sb->s_num_blocks);
> +	sbi->s_blocksize = be32_to_cpu(omfs_sb->s_blocksize);
> +	sbi->s_mirrors = be32_to_cpu(omfs_sb->s_mirrors);
> +	sbi->s_root_ino = be64_to_cpu(omfs_sb->s_root_block);
> +	sbi->s_sys_blocksize = be32_to_cpu(omfs_sb->s_sys_blocksize);
> +	mutex_init(&sbi->s_bitmap_lock);
> +
> +	/*
> +	 * Use sys_blocksize as the fs block since it is smaller than a
> +	 * page while the fs blocksize can be larger.
> +	 */
> +	sb_set_blocksize(sb, sbi->s_sys_blocksize);
> +
> +	/*
> +	 * ...and the difference goes into a shift.  sys_blocksize is always
> +	 * a power of two factor of blocksize.
> +	 */
> +	set_block_shift(sbi);
> +
> +	start = clus_to_blk(sbi, be64_to_cpu(omfs_sb->s_root_block));
> +	bh2 = sb_bread(sb, start);
> +	if (!bh2)
> +		goto out;
> +
> +	omfs_rb = (struct omfs_root_block *)bh2->b_data;
> +
> +	sbi->s_bitmap_ino = be64_to_cpu(omfs_rb->r_bitmap);
> +	sbi->s_clustersize = be32_to_cpu(omfs_rb->r_clustersize);
> +
> +	ret = omfs_get_imap(sb);
> +	if (ret)
> +		goto end;
> +
> +	sb->s_op = &omfs_sops;
> +
> +	root = omfs_iget(sb, be64_to_cpu(omfs_rb->r_root_dir));
> +	if (IS_ERR(root)) {
> +		ret = PTR_ERR(root);
> +		goto end;
> +	}
> +
> +	sb->s_root = d_alloc_root(root);
> +	if (!sb->s_root) {
> +		iput(root);
> +		goto out;
> +	}
> +	printk(KERN_DEBUG "omfs: Mounted volume %s\n", omfs_rb->r_name);
> +	goto end;
> +
> +out:
> +	ret = -EINVAL;
> +
> +end:
> +	if (bh2)
> +		brelse(bh2);
> +	if (bh)
> +		brelse(bh);
brelse(NULL) is safe to call

> +	return ret;
> +}
> +

this code leaks omfs_sbi_info (sbi)
