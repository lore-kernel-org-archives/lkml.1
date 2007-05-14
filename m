Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXENUQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXENUQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXENUQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:16:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52423 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbXENUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:16:19 -0400
Subject: Re: [RFC][PATCH 13/14] ext3 whiteout support
From: Badari Pulavarty <pbadari@us.ibm.com>
To: bharata@linux.vnet.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
In-Reply-To: <20070514094450.GO4139@in.ibm.com>
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094450.GO4139@in.ibm.com>
Content-Type: text/plain
Date: Mon, 14 May 2007 13:16:57 -0700
Message-Id: <1179173817.2836.69.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 15:14 +0530, Bharata B Rao wrote:
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Subject: ext3 whiteout support
> 
> Introduce whiteout support for ext3.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/ext3/dir.c           |    2 -
>  fs/ext3/namei.c         |   62 ++++++++++++++++++++++++++++++++++++++++++++----
>  fs/ext3/super.c         |   11 +++++++-
>  include/linux/ext3_fs.h |    5 +++
>  4 files changed, 72 insertions(+), 8 deletions(-)
> 
> --- a/fs/ext3/dir.c
> +++ b/fs/ext3/dir.c
> @@ -29,7 +29,7 @@
>  #include <linux/rbtree.h>
>  
>  static unsigned char ext3_filetype_table[] = {
> -	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> +	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK, DT_WHT
>  };
>  
>  static int ext3_readdir(struct file *, void *, filldir_t);
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1071,6 +1071,7 @@ static unsigned char ext3_type_by_mode[S
>  	[S_IFIFO >> S_SHIFT]	= EXT3_FT_FIFO,
>  	[S_IFSOCK >> S_SHIFT]	= EXT3_FT_SOCK,
>  	[S_IFLNK >> S_SHIFT]	= EXT3_FT_SYMLINK,
> +	[S_IFWHT >> S_SHIFT]	= EXT3_FT_WHT,
>  };
>  
>  static inline void ext3_set_de_type(struct super_block *sb,
> @@ -1786,7 +1787,7 @@ out_stop:
>  /*
>   * routine to check that the specified directory is empty (for rmdir)
>   */
> -static int empty_dir (struct inode * inode)
> +static int empty_dir (handle_t *handle, struct inode * inode)

Is there a reason for passing the handle ? Why couldn't you get it from
journal_current_handle() if needed to do the delete the whiteout ?

>  {
>  	unsigned long offset;
>  	struct buffer_head * bh;
> @@ -1848,8 +1849,28 @@ static int empty_dir (struct inode * ino
>  			continue;
>  		}
>  		if (le32_to_cpu(de->inode)) {
> -			brelse (bh);
> -			return 0;
> +			/* If this is a whiteout, remove it */
> +			if (de->file_type == EXT3_FT_WHT) {
> +				unsigned long ino = le32_to_cpu(de->inode);
> +				struct inode *tmp_inode = iget(inode->i_sb, ino);
> +				if (!tmp_inode) {
> +					brelse (bh);
> +					return 0;
> +				}
> +
> +				if (ext3_delete_entry(handle, inode, de, bh)) {
> +					iput(tmp_inode);
> +					brelse (bh);
> +					return 0;
> +				}
> +
> +				tmp_inode->i_ctime = inode->i_ctime;
> +				tmp_inode->i_nlink--;
> +				iput(tmp_inode);
> +			} else {
> +				brelse (bh);
> +				return 0;
> +			}
>  		}
>  		offset += le16_to_cpu(de->rec_len);
>  		de = (struct ext3_dir_entry_2 *)
> @@ -2031,7 +2052,7 @@ static int ext3_rmdir (struct inode * di
>  		goto end_rmdir;
>  
>  	retval = -ENOTEMPTY;
> -	if (!empty_dir (inode))
> +	if (!empty_dir (handle, inode))
>  		goto end_rmdir;
>  
>  	retval = ext3_delete_entry(handle, dir, de, bh);
> @@ -2060,6 +2081,36 @@ end_rmdir:
>  	return retval;
>  }
>  
> +static int ext3_whiteout(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode * inode;
> +	int err, retries = 0;
> +	handle_t *handle;
> +
> +retry:
> +	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
> +					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> +					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	if (IS_DIRSYNC(dir))
> +		handle->h_sync = 1;
> +
> +	inode = ext3_new_inode (handle, dir, S_IFWHT | S_IRUGO);
> +	err = PTR_ERR(inode);
> +	if (IS_ERR(inode))
> +		goto out_stop;

Don't you need to call init_special_inode() here ?
Or this is handled somewhere else ?

> +
> +	err = ext3_add_nondir(handle, dentry, inode);
> +
> +out_stop:
> +	ext3_journal_stop(handle);
> +	if (err == -ENOSPC && ext3_should_retry_alloc(dir->i_sb, &retries))
> +		goto retry;
> +	return err;
> +}
> +

Thanks,
Badari

