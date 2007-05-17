Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbXEQU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbXEQU0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXEQU0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:26:08 -0400
Received: from lazybastard.de ([212.112.238.170]:55543 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXEQU0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:26:06 -0400
Date: Thu, 17 May 2007 22:21:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070517202139.GD15676@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <200705171708.53038.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705171708.53038.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 17:08:51 +0200, Arnd Bergmann wrote:
> On Tuesday 15 May 2007, Jörn Engel wrote:
> > Add LogFS, a scalable flash filesystem.
> 
> Sorry for not commenting earlier, there were so many discussions on version
> two that I wanted to wait for the fallout of that instead of duplicating
> all the comments.

You are the last person that has to be sorry. ;)

> Here are a few things I notice while going through the third version:
> 
> > +/*
> > + * Private errno for accessed beyond end-of-file.  Only used internally to
> > + * logfs.  If this ever gets exposed to userspace or even other parts of the
> > + * kernel, it is a bug.  256 was chosen as a number sufficiently above all
> > + * used errno #defines.
> > + *
> > + * It can be argued that this is a hack and should be replaced with something
> > + * else.  My last attempt to do this failed spectacularly and there are more
> > + * urgent problems that users actually care about.  This will remain for the
> > + * moment.  Patches are wellcome, of course.
> > + */
> > +#define EOF	256
> 
> It should at least be in the kernel-only errno range between 512 and 4095,
> that way it can eventually be added to include/linux/errno.h.

Fair enough.  512 it is.

> > + * Target rename works in three atomic steps:
> > + * 1. Attach old inode to new dentry (remember old dentry and new inode)
> > + * 2. Remove old dentry (still remember the new inode)
> > + * 3. Remove new inode
> > + *
> > + * Here we remember both an inode an a dentry.  If we get interrupted
> > + * between steps 1 and 2, we delete both the dentry and the inode.  If
> > + * we get interrupted between steps 2 and 3, we delete just the inode.
> > + * In either case, the remaining objects are deleted on next mount.  From
> > + * a users point of view, the operation succeeded.
> 
> This description had me confused for a while: why would you remove the
> new inode. Maybe change the text to say 'target inode' or 'victim inode'?

'Victim inode' sounds good.  Will do.

> > +static int logfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
> > +{
> > +	struct inode *inode;
> > +
> > +	if (dir->i_nlink >= LOGFS_LINK_MAX)
> > +		return -EMLINK;
> 
> Why is i_nlink limited? Don't you run out of space for inodes before
> overflowing?

I don't know.  With the current limit of 2^31, a sufficiently large
device can reach the limit.  And it is imaginable that overflowing the
s32 number space can expose security holes.  Not that I actually know,
the check is pure paranoia.

> > + * In principle, this function should loop forever, looking for GC candidates
> > + * and moving data.  LogFS is designed in such a way that this loop is
> > + * guaranteed to terminate.
> > + *
> > + * Limiting the loop to four iterations serves purely to catch cases when
> > + * these guarantees have failed.  An actual endless loop is an obvious bug
> > + * and should be reported as such.
> > + *
> > + * But there is another nasty twist to this.  As I have described in my LCA
> > + * presentation, Garbage collection would have to limit itself to higher
> > + * levels if the number of available free segments goes down.  This code
> > + * doesn't and should fail spectacularly.  Yet - hard as I tried I haven't
> > + * been able to make it fail (short of a bug elsewhere).
> > + *
> > + * So in a way this code is intentionally wrong as a desperate cry for a
> > + * better testcase.  And I do expect to get blamed for it one day. :(
> > + */
> 
> Could you bug the code to reserve fewer segments for GC than you really
> need, in order to stress test GC?

I could.  Wear leveling will cause changes in the area, so I'll have a
closer look when implementing that.

> > +static struct inode *logfs_alloc_inode(struct super_block *sb)
> > +{
> > +	struct logfs_inode *li;
> > +
> > +	li = kmem_cache_alloc(logfs_inode_cache, GFP_KERNEL);
> > +	if (!li)
> > +		return NULL;
> > +	logfs_init_inode(&li->vfs_inode);
> > +	return &li->vfs_inode;
> > +}
> > +
> > +
> > +struct inode *logfs_new_meta_inode(struct super_block *sb, u64 ino)
> > +{
> > +	struct inode *inode;
> > +
> > +	inode = logfs_alloc_inode(sb);
> > +	if (!inode)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	logfs_init_inode(inode);
> 
> logfs_alloc_inode() returns an initialized inode, so no need to call
> logfs_init_inode() again, right?

Right.  Will change.

> > +static __be64 timespec_to_be64(struct timespec tsp)
> > +{
> > +	u64 time = ((u64)tsp.tv_sec << 32) + (tsp.tv_nsec & 0xffffffff);
> > +
> > +	WARN_ON(tsp.tv_nsec > 999999999);
> > +	return cpu_to_be64(time);
> > +}
> 
> Why not just store 64 bit nanoseconds? that would avoid the problem
> with ns overflow and the year-2038 bug. OTOH, that would require
> a 64 bit integer division when reading the data, so it gets you
> a runtime overhead.

I like the idea.  Do conversion function exist both way?

What I don't get is the year-2038 bug.  Isn't that the 31bit limit,
while 32bit would last to 2106?

> > +static void logfs_read_inode(struct inode *inode)
> > +{
> > +	int ret;
> > +
> > +	BUG_ON(inode->i_ino == LOGFS_INO_MASTER);
> > +
> > +	ret = __logfs_read_inode(inode);
> > +
> > +	/* What else can we do here? */
> > +	BUG_ON(ret);
> > +}
> 
> ext2 returns make_bad_inode(inode) in this case, which seems to be
> a better solution than crashing.

Excellent!  Will do.

> > +int __logfs_write_inode(struct inode *inode)
> > +{
> > +	/*
> > +	 * FIXME: Those two inodes are 512 bytes in total.  Not good to
> > +	 * have on the stack.  Possibly the best solution would be to bite
> > +	 * the bullet and do another format change before release and
> > +	 * shrink the inodes.
> > +	 */
> > +	struct logfs_disk_inode old, new;
> > +
> > +	BUG_ON(inode->i_ino == LOGFS_INO_MASTER);
> > +
> > +	/* read and compare the inode first.  If it hasn't changed, don't
> > +	 * bother writing it. */
> > +	logfs_inode_to_disk(inode, &new);
> > +	if (logfs_read_disk_inode(&old, inode))
> > +		return logfs_write_disk_inode(&new, inode);
> > +	if (memcmp(&old, &new, sizeof(old)))
> > +		return logfs_write_disk_inode(&new, inode);
> > +	return 0;
> > +}
> 
> Instead of the memcmp, you could do a new logfs_cmp_disk_inode function, so this code turns
> into
> 
> {
> 	struct logfs_inode_to_disk dinode;
> 	BUG_ON(inode->i_ino == LOGFS_INO_MASTER);
> 
> 	/* nothing to do if identical */
> 	if (!logfs_read_disk_inode(&dinode, inode) &&
>             !logfs_cmp_disk_inode(&dinode, inode)
> 		return 0;
> 
> 	/* write changed data */
> 	logfs_inode_to_disk(inode, &dinode);
> 	return logfs_write_disk_inode(&dinode, inode);
> }
> 
> This at least gets the wasted stack size down to a single inode structure.

Sounds good.  Will do.

> > +static void *unpack(void *from, void *to)
> > +{
> 
> Almost all your static functions start with logfs_, why not this one?

Because after a while I discovered how silly it is to start every
function with logfs_.  That prefix doesn't add much unless the function
has global scope.  What I didn't do was remove the prefix from older
functions.

> > + * Second trick is to special-case the key "0" or NUL.  As seen above, this
> > + * value indicates an unused slot, so such a value should not be stored in the
> > + * tree itself.  Instead it is stored in the null_ptr field in the btree_head.
> > + */
> > +#include "logfs.h"
> 
> Maybe split out the btree bits to a different header, that would make it
> really self-contained.
> 
> > +#define BTREE_NODES 16	/* 32bit, 128 byte cacheline */
> 
> And this should probably go to the header as well if you want it to end
> up in include/linux/btree.h

Looks like Peter Zijlstra is already working on a btree library.  His
code is more complete and likely faster than mine:
http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/21-rc6/cpc-test.patch

My secret hope is that his code is merged soon and I can just remove
mine.

> > +/* TODO: might make sense to turn inode into embedded again */
> 
> I'd guess that the only interesting case is truncate to zero length.
> If that is the same as truncate to embedded, it's probably good
> to implement that.

Truncate to zero sounds like the 99.99% solution.  I like it.

> > +
> > +
> > +int mtdread(struct super_block *sb, loff_t ofs, size_t len, void *buf)
> > +{
> > +	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
> > +	size_t retlen;
> > +	int ret;
> > +
> > +	ret = mtd->read(mtd, ofs, len, &retlen, buf);
> > +	BUG_ON(ret == -EINVAL);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Not sure if we should loop instead. */
> > +	if (retlen != len)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> 
> mtdread is not a good name for a global function specific to one file system,
> it should really be logfs_mtdread(). I'm also not sure if super.c is
> the right file for the mtd access functions.

super.c is a dump space for functions that don't have a good place
otherwise.  Maybe the accessor functions should go into mtd.c.

What would make more sense than renaming them is to hide them in a
struct logfs_device_ops and only have static functions.  Then another
set can be named bdread(), bdwrite(), etc. and live in bd.c.

> > +/*
> > + * For as long as I can remember (since about 2001) mtd->erase has been an
> > + * asynchronous interface lacking the first driver to actually use the
> > + * asynchronous properties.  So just to prevent the first implementor of such
> > + * a thing from breaking logfs in 2350, we do the usual pointless dance to
> > + * declare a completion variable and wait for completion before returning
> > + * from mtderase().  What an excercise in futility!
> > + */
> > +static DECLARE_COMPLETION(logfs_erase_complete);
> > +
> > +
> > +static void logfs_erase_callback(struct erase_info *ei)
> > +{
> > +	complete(&logfs_erase_complete);
> > +}
> 
> Is this safe if you have multiple file systems mounted on different
> mtd devices, and both call the callback at the same time?

I doubt it.  Guess I'll just remove the completion thing and wait for
LogFS to be broken in 2350 instead.

> > +
> > +
> > +int all_ff(void *buf, size_t len)
> > +{
> > +	unsigned char *c = buf;
> > +	int i;
> > +
> > +	for (i=0; i<len; i++)
> > +		if (c[i] != 0xff)
> > +			return 0;
> > +	return 1;
> > +}
> 
> Again not a good name for a global symbol

What would a better name be?  I had expected to find a similar function
somewhere in lib/string.c, right between memcmp() and memscan().  JFFS2
has some similar home-brewn code.  Maybe others as well.  Maybe a
function like this should go in lib/string.c?

/**
 * memchr_inv - Find a character in an area of memory.
 * @s: The memory area
 * @c: The byte to search for
 * @n: The size of the area.
 *
 * returns the address of the first character other than @c, or %NULL
 * if the whole buffer contains just @c.
 */
int memchr_inv(const void *s, int c, size_t n)
{
	const unsigned char *p = s;
	while (n-- != 0) {
		if ((unsigned char)c != *p++) {
			return (void *)(p - 1);
		}
	}
	return NULL;
}

> > +static u64 segment_offset[OFS_COUNT];
> > +
> > +static u64 fssize;
> > +static u64 no_segs;
> > +static u64 free_blocks;
> > +
> > +static u32 segsize;
> > +static u32 blocksize;
> > +static int segshift;
> > +static int blockshift;
> > +static int writeshift;
> > +
> > +static u32 blocks_per_seg;
> > +static u16 version;
> > +
> > +static __be32 bb_array[1024];
> > +static int bb_count;
> > +
> > +
> 
> How do you serialize access to these variables?

I don't.  Note to self: move this to userspace to avoid any further
embarrassment.

> > +/*
> > + * Number of blocks at various levels of indirection.  Each inode originally
> > + * had 9 block pointers.  Later the inode size was doubled and there are now
> > + * 9+16 pointers - the notation is just historical.
> > + *
> > + * I0_BLOCKS is the number of direct block pointer in each inode.  The
> > + * remaining five pointers are for indirect pointers, up to 5x indirect.
> > + * Only 3x is tested and supported at the moment.  5x would allow for truly
> > + * humongous files if the need ever arises.
> > + * I1_BLOCKS is the number of blocks behind a 1x indirect block,
> > + * I2_BLOCKS is the number of blocks behind a 2x indirect block, not counting
> > + * the 1x indirect blocks.  etc.
> > + */
> > +#define I0_BLOCKS		(4+16)
> > +#define I1_BLOCKS		LOGFS_BLOCK_FACTOR
> > +#define I2_BLOCKS		(LOGFS_BLOCK_FACTOR * I1_BLOCKS)
> > +#define I3_BLOCKS		(LOGFS_BLOCK_FACTOR * I2_BLOCKS)
> > +#define I4_BLOCKS		(LOGFS_BLOCK_FACTOR * I3_BLOCKS)
> > +#define I5_BLOCKS		(LOGFS_BLOCK_FACTOR * I4_BLOCKS)
> > +
> > +/* The indices in the block array where the Nx indirect block pointers reside */
> > +#define I1_INDEX		(4+16)
> > +#define I2_INDEX		(5+16)
> > +#define I3_INDEX		(6+16)
> > +#define I4_INDEX		(7+16)
> > +#define I5_INDEX		(8+16)
> > +
> > +/* The total number of block pointers in each inode */
> > +#define LOGFS_EMBEDDED_FIELDS	(9+16)
> 
> Now that the inodes are compressed, is there still a benefit of
> having the uncompressed size be a power of two? I don't remember
> the exact tradeoffs that we discussed for this, but IIRC the
> biggest problem with making them larger is filling up the journal,
> and there is no benefit in larger inodes unless you get to the
> point where embedded files are a win (at 4KiB uncompressed inodes), 
> while with really small inodes you don't have enough space
> for direct block pointers.
> 
> Still, something tells me that it should either go down to
> something like LOGFS_EMBEDDED_FIELDS == 16, or up to make sizeof
> (logfs_disk_inode) == block_size, in which case embedded files
> should be loaded into the page cache instead of the logfs_inode.

It should go down to LOGFS_EMBEDDED_FIELDS == 17, I believe.  16 direct
pointers are nice, as there are also 16 special inodes.  And a single
indirect pointer is sufficient if the inode also has a height field.  If
an access beyond 64KiB has to go through double indirection instead of
single indirection, that will hardly show up in benchmarks let alone
real life.

Part of me would like to make such a change now before the format is
fixed.  Another part wants to finally release LogFS and rather keep the
inodes as-is than have people suffer JFFS2 limitations much longer.

The change will happen either way.  Whether it should follow with an
INCOMPAT feature flag or be done now is the only question.

> > +/* FIXME: why do these not work? */
> > +#if 0
> > +BUILD_BUG_ON(sizeof(struct logfs_object_header) != LOGFS_HEADERSIZE);
> > +BUILD_BUG_ON(sizeof(struct logfs_segment_header) != LOGFS_HEADERSIZE);
> > +#endif
> 
> Because BUILD_BUG_ON only works inside of a function. You could
> put them into a dummy inline function.

Ok, will do.

Jörn

-- 
To announce that there must be no criticism of the President, or that we
are to stand by the President, right or wrong, is not only unpatriotic
and servile, but is morally treasonable to the American public.
-- Theodore Roosevelt, Kansas City Star, 1918
