Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbXEOGTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbXEOGTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbXEOGT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:19:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44792 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbXEOGTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:19:25 -0400
Date: Tue, 15 May 2007 11:56:49 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 13/14] ext3 whiteout support
Message-ID: <20070515062649.GA3465@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094450.GO4139@in.ibm.com> <1179173817.2836.69.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179173817.2836.69.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 01:16:57PM -0700, Badari Pulavarty wrote:
> On Mon, 2007-05-14 at 15:14 +0530, Bharata B Rao wrote:
> > From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > Subject: ext3 whiteout support
> > 
> > Introduce whiteout support for ext3.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > ---
> >  fs/ext3/dir.c           |    2 -
> >  fs/ext3/namei.c         |   62 ++++++++++++++++++++++++++++++++++++++++++++----
> >  fs/ext3/super.c         |   11 +++++++-
> >  include/linux/ext3_fs.h |    5 +++
> >  4 files changed, 72 insertions(+), 8 deletions(-)
> > 
> > --- a/fs/ext3/dir.c
> > +++ b/fs/ext3/dir.c
> > @@ -29,7 +29,7 @@
> >  #include <linux/rbtree.h>
> >  
> >  static unsigned char ext3_filetype_table[] = {
> > -	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> > +	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK, DT_WHT
> >  };
> >  
> >  static int ext3_readdir(struct file *, void *, filldir_t);
> > --- a/fs/ext3/namei.c
> > +++ b/fs/ext3/namei.c
> > @@ -1071,6 +1071,7 @@ static unsigned char ext3_type_by_mode[S
> >  	[S_IFIFO >> S_SHIFT]	= EXT3_FT_FIFO,
> >  	[S_IFSOCK >> S_SHIFT]	= EXT3_FT_SOCK,
> >  	[S_IFLNK >> S_SHIFT]	= EXT3_FT_SYMLINK,
> > +	[S_IFWHT >> S_SHIFT]	= EXT3_FT_WHT,
> >  };
> >  
> >  static inline void ext3_set_de_type(struct super_block *sb,
> > @@ -1786,7 +1787,7 @@ out_stop:
> >  /*
> >   * routine to check that the specified directory is empty (for rmdir)
> >   */
> > -static int empty_dir (struct inode * inode)
> > +static int empty_dir (handle_t *handle, struct inode * inode)
> 
> Is there a reason for passing the handle ? Why couldn't you get it from
> journal_current_handle() if needed to do the delete the whiteout ?

Yes, using journal_current_handle() is possible, didn't realize it earlier.

> 
> >  {
> >  	unsigned long offset;
> >  	struct buffer_head * bh;
> > @@ -1848,8 +1849,28 @@ static int empty_dir (struct inode * ino
> >  			continue;
> >  		}
> >  		if (le32_to_cpu(de->inode)) {
> > -			brelse (bh);
> > -			return 0;
> > +			/* If this is a whiteout, remove it */
> > +			if (de->file_type == EXT3_FT_WHT) {
> > +				unsigned long ino = le32_to_cpu(de->inode);
> > +				struct inode *tmp_inode = iget(inode->i_sb, ino);
> > +				if (!tmp_inode) {
> > +					brelse (bh);
> > +					return 0;
> > +				}
> > +
> > +				if (ext3_delete_entry(handle, inode, de, bh)) {
> > +					iput(tmp_inode);
> > +					brelse (bh);
> > +					return 0;
> > +				}
> > +
> > +				tmp_inode->i_ctime = inode->i_ctime;
> > +				tmp_inode->i_nlink--;
> > +				iput(tmp_inode);
> > +			} else {
> > +				brelse (bh);
> > +				return 0;
> > +			}
> >  		}
> >  		offset += le16_to_cpu(de->rec_len);
> >  		de = (struct ext3_dir_entry_2 *)
> > @@ -2031,7 +2052,7 @@ static int ext3_rmdir (struct inode * di
> >  		goto end_rmdir;
> >  
> >  	retval = -ENOTEMPTY;
> > -	if (!empty_dir (inode))
> > +	if (!empty_dir (handle, inode))
> >  		goto end_rmdir;
> >  
> >  	retval = ext3_delete_entry(handle, dir, de, bh);
> > @@ -2060,6 +2081,36 @@ end_rmdir:
> >  	return retval;
> >  }
> >  
> > +static int ext3_whiteout(struct inode *dir, struct dentry *dentry)
> > +{
> > +	struct inode * inode;
> > +	int err, retries = 0;
> > +	handle_t *handle;
> > +
> > +retry:
> > +	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
> > +					EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> > +					2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> > +	if (IS_ERR(handle))
> > +		return PTR_ERR(handle);
> > +
> > +	if (IS_DIRSYNC(dir))
> > +		handle->h_sync = 1;
> > +
> > +	inode = ext3_new_inode (handle, dir, S_IFWHT | S_IRUGO);
> > +	err = PTR_ERR(inode);
> > +	if (IS_ERR(inode))
> > +		goto out_stop;
> 
> Don't you need to call init_special_inode() here ?
> Or this is handled somewhere else ?

Whiteout doesn't have any attributes and hence we are not explicitly
doing init_special_inode() on this. Accesses to whiteout files are trapped
at the VFS lookup itself and creation and deletion of whiteouts are handled
automatically by VFS. So I believe init_special_inode() isn't necessary
on a whiteout file.

Regards,
Bharata.
