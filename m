Return-Path: <linux-kernel-owner+w=401wt.eu-S1763448AbZEAOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763448AbZEAOiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZEAOiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:38:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbZEAOiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:38:11 -0400
Date: Fri, 1 May 2009 10:35:17 -0400
From: Josef Bacik <josef@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <jbacik@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com, stable@kernel.org
Subject: Re: [PATCH] fiemap: fix problem with setting FIEMAP_EXTENT_LAST
Message-ID: <20090501143517.GF7076@unused.rdu.redhat.com>
References: <1241113491-9031-1-git-send-email-jbacik@redhat.com> <20090430154047.5485759f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430154047.5485759f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:40:47PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 13:44:51 -0400
> Josef Bacik <jbacik@redhat.com> wrote:
> 
> > This patch fixes a problem where the generic block based fiemap stuff would not
> > properly set FIEMAP_EXTENT_LAST on the last extent.  I've reworked things to
> > keep track if we go past the EOF, and mark the last extent properly.  The
> > problem was reported by and tested by Eric Sandeen.
> > 
> 
> bleeearrggh.  __generic_block_fiemap() needs to be dragged out, shot,
> stabbed and doused in gasoline.
> 
> - uses stupid helper macros (blk_to_logical, logical_to_blk), thus
>   carefully obscuring the types of their incoming args and return value.
> 
> - has kerneldoc which documents non-existent arguments and fails to
>   document the actual arguments.
> 
> - has a local variable called `tmp'.
> 
> - Uses random and seemingly irrational mixture of u64's and `long
>   long's, thus carefully confusing readers who would prefer to see
>   loff_t, sector_t, etc so they have a fighting chance of understanding
>   what the hell the thing does.
> 
> - exists as useful counterexample for Documentation/CodingStyle
> 
> - has undocumented locals called "length", "len" and "map_len", to
>   avoid any possibility of confusion.
> 
> - has a local called `start_blk' which has a suspiciously-small
>   32-bit type.  Because of all the above intense obfuscation efforts I
>   just cannot be assed working out whether or not if this is an actual
>   bug.
> 
> 
> Who the heck merged this turkey?
> 
> <checks>
> 
> Oh good, it wasn't me.
> 
> your patch:
> 
> - adds a string of booleans, unhelpfully typed with plain old `int'.
> 
> - seems to think that sentences start with lower-case letters.
> 
> 
> Sigh.
> 
> Does this bugfix need to be backported into 2.6.29?  Earlier?  If so, why?
>

Here is an updated patch.  What am I supposed to do about these types?
inode->i_size is loff_t, bh->b_size is size_t, bh->b_blocknr is sector_t, not to
mention that all of the fieinfo fields are either u64 or u32.  Is what I've done
acceptable, or is there some other magic I'm supposed to be doing?  I've looked
around some and it seems that people just kind of ignore the types, they're just
there to explain the variables.  I just would like to better understand this so
I can avoid getting chewed out in the future.  Thanks,

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
