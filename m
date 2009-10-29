Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZJ2Ml3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZJ2Ml3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 08:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZJ2Ml3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 08:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZJ2Ml2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 08:41:28 -0400
Date: Thu, 29 Oct 2009 08:40:56 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Hommey <mh@glandium.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Josef Bacik <jbacik@redhat.com>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Fix generic_block_fiemap for files bigger than 4GB
Message-ID: <20091029124055.GB7436@localhost.localdomain>
References: <1256577868-30484-1-git-send-email-mh@glandium.org> <20091028230022.e15b1e9c.akpm@linux-foundation.org> <20091029123153.GA7436@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029123153.GA7436@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 08:31:54AM -0400, Josef Bacik wrote:
> On Wed, Oct 28, 2009 at 11:00:22PM -0700, Andrew Morton wrote:
> > On Mon, 26 Oct 2009 18:24:28 +0100 Mike Hommey <mh@glandium.org> wrote:
> > 
> > > Because of an integer overflow on start_blk, various kind of wrong results
> > > would be returned by the generic_block_fiemap handler, such as no extents
> > > when there is a 4GB+ hole at the beginning of the file, or wrong fe_logical
> > > when an extent starts after the first 4GB.
> > > 
> > > Signed-off-by: Mike Hommey <mh@glandium.org>
> > > ---
> > >  fs/ioctl.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > > index 7b17a14..6c75110 100644
> > > --- a/fs/ioctl.c
> > > +++ b/fs/ioctl.c
> > > @@ -254,7 +254,7 @@ int __generic_block_fiemap(struct inode *inode,
> > >  			   u64 len, get_block_t *get_block)
> > >  {
> > >  	struct buffer_head tmp;
> > > -	unsigned int start_blk;
> > > +	unsigned long long start_blk;
> > >  	long long length = 0, map_len = 0;
> > >  	u64 logical = 0, phys = 0, size = 0;
> > >  	u32 flags = FIEMAP_EXTENT_MERGED;
> > 
> > Well.  Should it be unsigned long long, or u64 or sector_t?  Or even loff_t.
> > 
> > The code's a bit confused about types in there.  And it's made much
> > more confusing by the moronic and wholly unnecessary use of macros for
> > blk_to_logical() and logical_to_blk().
> > 
> > It's also unhelpful that the `u64 start' argument forgot to get itself
> > documented in the kerneldoc comment.  Sigh.
> > 
> > Ah, generic_block_fiemap() has it:
> > 
> >  * @start: The initial block to map
> > 
> > I guess u64 was logical there as it comes in from userspace.  But at
> > some boundary we should start talking kernel types so I suspect the
> > correct thing to do here is to use sector_t?
> > 
> 
> Hmm this is strange, I had sent a patch a few months ago after you chewed me out
> the first time for this to change all the types and such and make the macro's
> inlined functions.  I will see if I can find it and resend it.  Thanks,
> 

Ok here it is.  I've fixed all the type issues and there were other problems
with not setting FIEMAP_EXTENT_LAST last properly.  If this is more reasonable
to you I will update it and send it along properly.  Thanks,

Josef

diff --git a/fs/ioctl.c b/fs/ioctl.c
index ac2d47e..ee9fba0 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -228,13 +228,22 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 
 #ifdef CONFIG_BLOCK
 
-#define blk_to_logical(inode, blk) (blk << (inode)->i_blkbits)
-#define logical_to_blk(inode, offset) (offset >> (inode)->i_blkbits);
+static inline sector_t logical_to_blk(struct inode *inode, loff_t offset)
+{
+	return (offset >> inode->i_blkbits);
+}
+
+static inline loff_t blk_to_logical(struct inode *inode, sector_t blk)
+{
+	return (blk << inode->i_blkbits);
+}
 
 /**
  * __generic_block_fiemap - FIEMAP for block based inodes (no locking)
  * @inode - the inode to map
- * @arg - the pointer to userspace where we copy everything to
+ * @fieinfo - the fiemap info struct that will be passed back to userspace
+ * @start - where to start mapping in the inode
+ * @len - how much space to map
  * @get_block - the fs's get_block function
  *
  * This does FIEMAP for block based inodes.  Basically it will just loop
@@ -250,43 +259,63 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
  */
 
 int __generic_block_fiemap(struct inode *inode,
-			   struct fiemap_extent_info *fieinfo, u64 start,
-			   u64 len, get_block_t *get_block)
+			   struct fiemap_extent_info *fieinfo, loff_t start,
+			   loff_t len, get_block_t *get_block)
 {
-	struct buffer_head tmp;
-	unsigned int start_blk;
-	long long length = 0, map_len = 0;
+	struct buffer_head map_bh;
+	sector_t start_blk;
+	loff_t end;
 	u64 logical = 0, phys = 0, size = 0;
 	u32 flags = FIEMAP_EXTENT_MERGED;
+	bool past_eof = false, whole_file = false;
 	int ret = 0;
 
-	if ((ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC)))
+	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
+	if (ret)
 		return ret;
 
 	start_blk = logical_to_blk(inode, start);
 
-	length = (long long)min_t(u64, len, i_size_read(inode));
-	map_len = length;
+	if (len >= i_size_read(inode)) {
+		whole_file = true;
+		len = i_size_read(inode);
+	}
+
+	end = start + len;
 
 	do {
 		/*
-		 * we set b_size to the total size we want so it will map as
+		 * We set b_size to the total size we want so it will map as
 		 * many contiguous blocks as possible at once
 		 */
-		memset(&tmp, 0, sizeof(struct buffer_head));
-		tmp.b_size = map_len;
+		memset(&map_bh, 0, sizeof(struct buffer_head));
+		map_bh.b_size = len;
 
-		ret = get_block(inode, start_blk, &tmp, 0);
+		ret = get_block(inode, start_blk, &map_bh, 0);
 		if (ret)
 			break;
 
 		/* HOLE */
-		if (!buffer_mapped(&tmp)) {
+		if (!buffer_mapped(&map_bh)) {
+			start_blk++;
+
 			/*
-			 * first hole after going past the EOF, this is our
+			 * We want to handle the case where there is an
+			 * allocated block at the front of the file, and then
+			 * nothing but holes up to the end of the file properly,
+			 * to make sure that extent at the front gets properly
+			 * marked with FIEMAP_EXTENT_LAST
+			 */
+			if (!past_eof &&
+			    blk_to_logical(inode, start_blk) >=
+			    blk_to_logical(inode, 0) + i_size_read(inode))
+				past_eof = true;
+
+			/*
+			 * First hole after going past the EOF, this is our
 			 * last extent
 			 */
-			if (length <= 0) {
+			if (past_eof && size) {
 				flags = FIEMAP_EXTENT_MERGED|FIEMAP_EXTENT_LAST;
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
@@ -294,15 +323,39 @@ int __generic_block_fiemap(struct inode *inode,
 				break;
 			}
 
-			length -= blk_to_logical(inode, 1);
-
-			/* if we have holes up to/past EOF then we're done */
-			if (length <= 0)
+			/* If we have holes up to/past EOF then we're done */
+			if (blk_to_logical(inode, start_blk) >= end
+			    || past_eof)
 				break;
-
-			start_blk++;
 		} else {
-			if (length <= 0 && size) {
+			/*
+			 * We have gone over the length of what we wanted to
+			 * map, and it wasn't the entire file, so add the extent
+			 * we got last time and exit.
+			 *
+			 * This is for the case where say we want to map all the
+			 * way up to the second to the last block in a file, but
+			 * the last block is a hole, making the second to last
+			 * block FIEMAP_EXTENT_LAST.  In this case we want to
+			 * see if there is a hole after the second to last block
+			 * so we can mark it properly.  If we found data after
+			 * we exceeded the length we were requesting, then we
+			 * are good to go, just add the extent to the fieinfo
+			 * and break
+			 */
+			if (blk_to_logical(inode, start_blk) >= end
+			    && !whole_file) {
+				ret = fiemap_fill_next_extent(fieinfo, logical,
+							      phys, size,
+							      flags);
+				break;
+			}
+
+			/*
+			 * If size != 0 then we know we already have an extent
+			 * to add, so add it.
+			 */
+			if (size) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
 							      flags);
@@ -311,32 +364,26 @@ int __generic_block_fiemap(struct inode *inode,
 			}
 
 			logical = blk_to_logical(inode, start_blk);
-			phys = blk_to_logical(inode, tmp.b_blocknr);
-			size = tmp.b_size;
+			phys = blk_to_logical(inode, map_bh.b_blocknr);
+			size = map_bh.b_size;
 			flags = FIEMAP_EXTENT_MERGED;
 
-			length -= tmp.b_size;
 			start_blk += logical_to_blk(inode, size);
 
 			/*
-			 * if we are past the EOF we need to loop again to see
-			 * if there is a hole so we can mark this extent as the
-			 * last one, and if not keep mapping things until we
-			 * find a hole, or we run out of slots in the extent
-			 * array
+			 * If we are past the EOF, then we need to make sure as
+			 * soon as we find a hole that the last extent we found
+			 * is marked with FIEMAP_EXTENT_LAST
 			 */
-			if (length <= 0)
-				continue;
-
-			ret = fiemap_fill_next_extent(fieinfo, logical, phys,
-						      size, flags);
-			if (ret)
-				break;
+			if (!past_eof &&
+			    logical + size >=
+			    blk_to_logical(inode, 0) + i_size_read(inode))
+				past_eof = true;
 		}
 		cond_resched();
 	} while (1);
 
-	/* if ret is 1 then we just hit the end of the extent array */
+	/* If ret is 1 then we just hit the end of the extent array */
 	if (ret == 1)
 		ret = 0;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..b23c725 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2305,8 +2305,9 @@ extern int vfs_fstatat(int , char __user *, struct kstat *, int);
 extern int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
 extern int __generic_block_fiemap(struct inode *inode,
-				  struct fiemap_extent_info *fieinfo, u64 start,
-				  u64 len, get_block_t *get_block);
+				  struct fiemap_extent_info *fieinfo,
+				  loff_t start, loff_t len,
+				  get_block_t *get_block);
 extern int generic_block_fiemap(struct inode *inode,
 				struct fiemap_extent_info *fieinfo, u64 start,
 				u64 len, get_block_t *get_block);
