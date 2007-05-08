Return-Path: <linux-kernel-owner+w=401wt.eu-S968414AbXEHQg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968414AbXEHQg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968080AbXEHQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:36:54 -0400
Received: from lazybastard.de ([212.112.238.170]:41089 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbXEHQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:36:49 -0400
Date: Tue, 8 May 2007 18:32:27 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
Message-ID: <20070508163226.GA22443@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1178608950.3042.273.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 09:22:30 +0200, Thomas Gleixner wrote:
>
> > +	help
> > +	  Successor of JFFS2, using explicit filesystem hierarchy.
> 
> Why is it a successor ? Does it build upon JFFS2 ?

Nope.  That description appears to be two years old and could use a 
facelift.

> > @@ -0,0 +1,14 @@
> > +obj-$(CONFIG_LOGFS)	+= logfs.o
> > +
> > +logfs-y += compr.o
> > +logfs-y	+= dir.o
> > +logfs-y	+= file.o
> > +logfs-y	+= gc.o
> > +logfs-y	+= inode.o
> > +logfs-y	+= journal.o
> > +logfs-y += memtree.o
> > +logfs-y	+= readwrite.o
> > +logfs-y	+= segment.o
> > +logfs-y	+= super.o
> > +logfs-y += progs/fsck.o
> > +logfs-y += progs/mkfs.o
> 
> Please use either tabs or spaces. Preferrably tabs

Will do.

> > --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> > +++ linux-2.6.21logfs/fs/logfs/logfs.h	2007-05-07 13:32:12.000000000 +0200
> > @@ -0,0 +1,626 @@
> > +#ifndef logfs_h
> > +#define logfs_h
> > +
> > +#define __CHECK_ENDIAN__
> > +
> > +
> > +#include <linux/crc32.h>
> > +#include <linux/fs.h>
> > +#include <linux/kallsyms.h>
> > +#include <linux/kernel.h>
> > +#include <linux/mtd/mtd.h>
> > +#include <linux/pagemap.h>
> > +#include <linux/statfs.h>
> 
> Please sort includes alphabetically and seperate the 
> #include <linux/mtd/mtd.h> from the #include <linux/...> ones

Sort: will do.
Seperation: Any particular reason for that?

> > +typedef __be16 be16;
> > +typedef __be32 be32;
> > +typedef __be64 be64;
> 
> Why are those typedefs necessary ?

Not strictly.  I tend to use the be* types fairly often in the code and
simply grew weary of seeing the underscores.

Any objections if I seperate out the userspace headers and keep the
shorthands for kernel code only?

> > +struct btree_head {
> > +	struct btree_node *node;
> > +	int height;
> > +	void *null_ptr;
> > +};
> 
> Please document structures

Will do.  This one could potentially become a seperate patch and move to
lib/.

> > +#define packed __attribute__((__packed__))
> 
> Please use the __attribute__((__packed__)) on your structs instead of
> creating some extra "needs lookup" magic.

Actually I would prefer to understand what that attribute actually does.
All structure members should be properly aligned, so having this
attribute is pure paranoia.  The definition is just there to make my
eyes tear less.

Would anything potentially break if I just ripped that out?

> > +
> > +#define TRACE() do {						\
> > +	printk("trace: %s:%d: ", __FILE__, __LINE__);		\
> > +	printk("->%s\n", __func__);				\
> > +} while(0)
> 
> Oh no. Not again another "I'm in function X tracer". 

Proved very useful during development yet has nothing lost in the final
patch.  Will go.

> > +
> > +#define LOGFS_MAGIC 0xb21f205ac97e8168ull
> > +#define LOGFS_MAGIC_U32 0xc97e8168ull
> 
> why is an U32 constant ull ?

Oversight.  Hell, I'll sell the ll.

> > +#define LOGFS_BLOCK_SECTORS	(8)
> > +#define LOGFS_BLOCK_BITS	(9)	/* 512 pointers, used for shifts */
> > +#define LOGFS_BLOCKSIZE		(4096ull)
> > +#define LOGFS_BLOCK_FACTOR (LOGFS_BLOCKSIZE / sizeof(u64))
> > +#define LOGFS_BLOCK_MASK (LOGFS_BLOCK_FACTOR-1)
> 
> for the whole defines:
> 
> Please align them so it does not look like a jigsaw puzzle.

Will do.

> Please avoid tail comments as it makes it harder to parse

My personal impression is just the opposite.  Is there a common
consensus one way or the other?

> > +#define I0_BLOCKS	(4+16)
> > +#define I1_BLOCKS LOGFS_BLOCK_FACTOR
> > +#define I2_BLOCKS (LOGFS_BLOCK_FACTOR * I1_BLOCKS)
> > +#define I3_BLOCKS (LOGFS_BLOCK_FACTOR * I2_BLOCKS)
> > +#define I4_BLOCKS (LOGFS_BLOCK_FACTOR * I3_BLOCKS)
> > +#define I5_BLOCKS (LOGFS_BLOCK_FACTOR * I4_BLOCKS)
> 
> Some explanation for that magic math might be helpful

Will do.

> > +#define I1_INDEX	(4+16)
> 
> same constant as IO_BLOCKS. coincidence ?

Nope.  One can use the other in the definition.

> > +#define I2_INDEX	(5+16)
> > +#define I3_INDEX	(6+16)
> > +#define I4_INDEX	(7+16)
> > +#define I5_INDEX	(8+16)
> 
> #define I2_INDEX	(I1_INDEX + 1)
> ....

I don't see a big advantage.  Any change to these constants will change
the filesystem format.  Any problem you might be hinting at will pale in
comparison.  But if you have a stong preference, sure.

> > +struct logfs_disk_super {
> > +	be64	ds_magic;
> > +	be32	ds_crc;			/* crc32 of everything below */
> > +	u8	ds_ifile_levels;	/* max level of ifile */
> > +	u8	ds_iblock_levels;	/* max level of regular files */
> > +	u8	ds_data_levels;		/* number of segments to leaf blocks */
> > +	u8	pad0;
> > +
> > +	be64	ds_feature_incompat;
> > +	be64	ds_feature_ro_compat;
> > +
> > +	be64	ds_feature_compat;
> > +	be64	ds_flags;
> > +
> > +	be64	ds_filesystem_size;	/* filesystem size in bytes */
> > +	u8	ds_segment_shift;	/* log2 of segment size */
> > +	u8	ds_block_shift;		/* log2 if block size */
> > +	u8	ds_write_shift;		/* log2 of write size */
> > +	u8	pad1[5];
> > +
> > +	/* the segments of the primary journal.  if fewer than 4 segments are
> > +	 * used, some fields are set to 0 */
> > +#define LOGFS_JOURNAL_SEGS 4
> 
> Please avoid defines inside of structures

Will move it.

> > +	be64	ds_journal_seg[LOGFS_JOURNAL_SEGS];
> > +
> > +	be64	ds_root_reserve;	/* bytes reserved for root */
> > +
> > +	be64	pad2[19];		/* align to 256 bytes */
> > +}packed;
> 
> Please comment the structure with kernel doc comments and avoid the tail
> comments.

I'd like to hear your rationale.

> > +
> > +#define LOGFS_IF_VALID		0x00000001 /* inode exists */
> > +#define LOGFS_IF_EMBEDDED	0x00000002 /* data embedded in block pointers */
> > +#define LOGFS_IF_ZOMBIE		0x00000004 /* inode was already deleted */
> > +#define LOGFS_IF_STILLBORN	0x40000000 /* couldn't write inode in creat() */
> > +#define LOGFS_IF_INVALID	0x80000000 /* inode does not exist */
> 
> Are these bit values or enum type ?

Bit values.

> > +struct logfs_disk_inode {
> > +	be16	di_mode;
> > +	be16	di_pad;
> > +	be32	di_flags;
> > +	be32	di_uid;
> > +	be32	di_gid;
> > +
> > +	be64	di_ctime;
> > +	be64	di_mtime;
> > +
> > +	be32	di_refcount;
> > +	be32	di_generation;
> > +	be64	di_used_bytes;
> > +
> > +	be64	di_size;
> > +	be64	di_data[LOGFS_EMBEDDED_FIELDS];
> > +}packed;
> > +
> > +
> > +#define LOGFS_MAX_NAMELEN 255
> 
> Please put define on top

On top of what?

> > +struct logfs_disk_dentry {
> > +	be64	ino;		/* inode pointer */
> > +	be16	namelen;
> > +	u8	type;
> > +	u8	name[LOGFS_MAX_NAMELEN];
> > +}packed;
> > +
> > +
> > +#define OBJ_TOP_JOURNAL	1	/* segment header for master journal */
> > +#define OBJ_JOURNAL	2	/* segment header for journal */
> > +#define OBJ_OSTORE	3	/* segment header for ostore */
> > +#define OBJ_BLOCK	4	/* data block */
> > +#define OBJ_INODE	5	/* inode */
> > +#define OBJ_DENTRY	6	/* dentry */
> 
> enum please

I don't care much one way or another.  Do enums have a significant
advantage?

> > +
> > +struct logfs_segment_header {
> > +	be32	crc;		/* checksum */
> > +	be16	len;		/* length of object, header not included */
> > +	u8	type;		/* node type */
> > +	u8	level;		/* GC level */
> > +	be32	segno;		/* segment number */
> > +	be32	ec;		/* erase count */
> > +	be64	gec;		/* global erase count (write time) */
> > +}packed;
> > +
> > +enum {
> > +	COMPR_NONE	= 0,
> > +	COMPR_ZLIB	= 1,
> > +};
> 
> Please name the enums and use the same enum for the according fields and
> the function arguments.

Does sparse check on that?  That would be quite useful and stop my
ambivalence.

> > +
> > +/* Journal entries come in groups of 16.  First group contains individual
> > + * entries, next groups contain one entry per level */
> > +enum {
> > +	JEG_BASE	= 0,
> > +	JE_FIRST	= 1,
> > +
> > +	JE_COMMIT	= 1,	/* commits all previous entries */
> > +	JE_ABORT	= 2,	/* aborts all previous entries */
> > +	JE_DYNSB	= 3,
> > +	JE_ANCHOR	= 4,
> > +	JE_ERASECOUNT	= 5,
> > +	JE_SPILLOUT	= 6,
> > +	JE_DELTA	= 7,
> > +	JE_BADSEGMENTS	= 8,
> > +	JE_AREAS	= 9,	/* area description sans wbuf */
> > +	JEG_WBUF	= 0x10,	/* write buffer for segments */
> > +
> > +	JE_LAST		= 0x1f,
> > +};
> 
> same here

Not sure.  Those constants are actually in groups of 16, so they are a
weird mixture of bitfields and enums.  There is code roughly along these
lines:

	switch (i >> 4) {
	case 0:
		switch (i & 0xf) {
		case JE_COMMIT:
		case JE_ABORT:
		...
	case 1:
	...

I'll have to check whether enums support this.

> > +
> > +////////////////////////////////////////////////////////////////////////////////
> > +////////////////////////////////////////////////////////////////////////////////
> 
> Eew.

Anything on top should get moved to include/logfs.h.  Anything below
should stay here.  And now might be an excellent time to do just that.

> > +
> > +#define LOGFS_SUPER(sb) ((struct logfs_super*)(sb->s_fs_info))
> > +#define LOGFS_INODE(inode) container_of(inode, struct logfs_inode, vfs_inode)
> 
> lowercase inlines please

#define JFFS2_INODE_INFO(i) (list_entry(i, struct jffs2_inode_info, vfs_inode))
#define OFNI_EDONI_2SFFJ(f)  (&(f)->vfs_inode)
#define JFFS2_SB_INFO(sb) (sb->s_fs_info)
#define OFNI_BS_2SFFJ(c)  ((struct super_block *)c->os_priv)

static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
{
	return sb->s_fs_info;
}

I can see the point for an inline function.  But lowercase would change
a style that appears to be common in Linux filesystems.  Will you send
the janitorial patches for existing code?

Speaking of janitorials, I noticed that removing the equivalent of
OFNI_EDONI_2SFFJ(f) and OFNI_BS_2SFFJ(c) made LogFS look much nicer.

> > +
> > +			/*	0	reserved for gc markers */
> > +#define LOGFS_INO_MASTER	1	/* inode file */
> > +#define LOGFS_INO_ROOT		2	/* root directory */
> > +#define LOGFS_INO_ATIME		4	/* atime for all inodes */
> > +#define LOGFS_INO_BAD_BLOCKS	5	/* bad blocks */
> > +#define LOGFS_INO_OBSOLETE	6	/* obsolete block count */
> > +#define LOGFS_INO_ERASE_COUNT	7	/* erase count */
> > +#define LOGFS_RESERVED_INOS	16
> 
> enum ?

Istr enums having severe problems for anything larger than int.  LogFS
inodes are 64bit.  Hmm.  And how do enums behave wrt. cpu_to_beXX and
sparse?

> > +struct logfs_super {
> > +	//struct super_block *s_sb;		/* should get removed... */
> 
> Please do so

Aye.

> > +	be64	*s_rblock;
> > +	be64	*s_wblock[LOGFS_MAX_LEVELS];
> 
> Please comment the non obvious ones instead of the self explaining

At some time I started commenting all new ones.  Are there any other
non-obvious ones remaining?

> > +	u64	 s_free_bytes;			/* number of free bytes */
> 
> 
> > +#define journal_for_each(__i) for (__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)
> 
> 	__i = 0; __i < LOGFS_JOURNAL_SEGS;

Will that make the code look better or just slavishly follow indentation
guidelines?  Adding spaces where you suggested weakens the grouping of
the three for(;;) parameters, imo.

> > +void logfs_crash_dump(struct super_block *sb);
> > +#define LOGFS_BUG(sb) do {		\
> > +	struct super_block *__sb = sb;	\
> 
> Why do we need a local variable here ?

Trying to add type safety.  It cannot be an inline function if without
making the file/line information useless.

> > +static inline u8 logfs_type(struct inode *inode)
> > +{
> > +	return (inode->i_mode >> 12) & 15;
> 
> What's 12 and 15 ? Constants perhaps ?

There should be a generic function doing just the same.  At least this
is better than the open-coded variants elsewhere:

fs/jffs2/dir.c: type = (old_dentry->d_inode->i_mode & S_IFMT) >> 12;
fs/jffs2/dir.c: type = (old_dentry->d_inode->i_mode & S_IFMT) >> 12;
fs/libfs.c:     return (inode->i_mode >> 12) & 15;
fs/nfs/dir.c:   return (inode->i_mode >> 12) & 15;
fs/proc/base.c:         type = inode->i_mode >> 12;

Maybe the libfs version could get moved to a header somewhere.

> > +}
> > +static inline struct logfs_disk_sum *alloc_disk_sum(struct super_block *sb)
> > +{
> > +	return kzalloc(sb->s_blocksize, GFP_ATOMIC);
> > +}
> 
> No, please do not add another alias for kzalloc

I thought I had already killed that one.  Will check.

> > +
> > +/* compr.c */
> > +#define logfs_compress_none logfs_memcpy
> > +#define logfs_uncompress_none logfs_memcpy
> 
> can you please use logfs_memcpy instead ?

Sure.

> > +int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen);
> > +int logfs_compress(void *in, void *out, size_t inlen, size_t outlen);
> > +int logfs_compress_vec(struct kvec *vec, int count, void *out, size_t outlen);
> > +int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen);
> > +int logfs_uncompress_vec(void *in, size_t inlen, struct kvec *vec, int count);
> 
> are those global ? If yes, please add extern, else remove

What purpose does "extern" have?  To my understanding it makes zero
difference.  About half the headers use it, the other half doesn't.

> 
> > +
> > +static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> 
> Seperate variables and code by an empty line please

In general: sure.  But for 1-2 line functions the empty lines seem to
hurt more than they help.

As much as I agree with the kernel coding style, I have never liked to
slavishly follow any written doctrine.  The overall goal should be easy
to read.  If "easy to read" would match the wording 100%, someone should
adjust the Lindent parameters and run the whole kernel through.

> > +	LOGFS_BUG_ON(err, sb);
> 
> Please open code this instead of nesting mtdread into device_read and
> therefor avoid the error handling pathes in those places where
> device_read is used.

Open code the LOGFS_BUG_ON()?  What purpose would that serve?

No doubt I have to work on the error path.  But above anything else that
involves _testing_.  Without a proper test case, any changes from BUG()
to more sophisticated error handling are doing more harm than good.
There is no place to second-guess what might happen if someone in the
future possibly triggers this code.

> > +}
> > +
> > +
> > +#define EOF	256
> 
> 1. very intuitive name
> 2. why is this constant not at the top, where the other constants are
> 3. why 256

Looking at the code again, it might be a better idea to kill the
constant and check for EOF in the caller.  So just for amusement value,
it means end of file and I just picked a constant higher than anything
in include/asm-generic/errno*.h.  Time to kill that hack.

> > +
> > +typedef int (*dir_callback)(struct inode *dir, struct dentry *dentry,
> > +		struct logfs_disk_dentry *dd, loff_t pos);
> 
> Why is this in the middle of something else ?

History.  It used to be right above logfs_dir_walk().  I assume you want
this moved to the top?

> > +
> > +static s64 dir_seek_data(struct inode *inode, s64 pos)
> > +{
> > +	s64 new_pos = logfs_seek_data(inode, pos);
> 
> new line please
> 
> > +	return max((s64)pos, new_pos - 1);
> 
> 	max_t please 

That would remove all type checking, wouldn't it?

And looking at it again, the code has changed and the cast become
useless.  Let's kill it.

> > +static int __logfs_dir_walk(struct inode *dir, struct dentry *dentry,
> > +		dir_callback handler, struct logfs_disk_dentry *dd, loff_t *pos)
> > +{
> > +	struct qstr *name = dentry ? &dentry->d_name : NULL;
> > +	int ret;
> > +
> > +	for (; ; (*pos)++) {
> > +		ret = read_dir(dir, dd, *pos);
> > +		if (ret == -EOF)
> > +			return 0;
> > +		if (ret == -ENODATA) {/* deleted dentry */
> 
> Please move the comment away. It makes parsing hard

ENOPARSE

Do you want an extra space or tab?

> > +			*pos = dir_seek_data(dir, *pos);
> > +			continue;
> > +		}
> > +		if (ret)
> > +			return ret;
> > +		BUG_ON(dd->namelen == 0);
> > +
> > +		if (name) {
> > +			if (name->len != be16_to_cpu(dd->namelen))
> > +				continue;
> > +			if (memcmp(name->name, dd->name, name->len))
> > +				continue;
> > +		}
> > +
> > +		return handler(dir, dentry, dd, *pos);
> > +	}
> > +	return ret;
> 
> 	Where do you break out of the loop ?

I don't.  But if I remove the return statement the compiler will barf.
Add a comment?

> > +}
> > +
> > +
> > +static int logfs_dir_walk(struct inode *dir, struct dentry *dentry,
> > +		dir_callback handler)
> > +{
> > +	struct logfs_disk_dentry dd;
> > +	loff_t pos = 0;
> 
> New line please

Three lines.  Ok, you win this one.

> > +	return __logfs_dir_walk(dir, dentry, handler, &dd, &pos);
> > +}
> > +
> > +
> > +static struct dentry *logfs_lookup(struct inode *dir, struct dentry *dentry,
> > +		struct nameidata *nd)
> > +{
> > +	struct dentry *ret;
> > +
> > +	ret = ERR_PTR(logfs_dir_walk(dir, dentry, logfs_lookup_handler));
> > +	return ret;
> 
> 	return ERR_PTR(.....);

Will do.  (It is surprising how many such things can accumulate through
400odd patch revisions.)

> > +}
> > +
> > +static int logfs_unlink(struct inode *dir, struct dentry *dentry)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(dir->i_sb);
> > +	struct inode *inode = dentry->d_inode;
> > +	int ret;
> > +
> > +	mutex_lock(&super->s_victim_mutex);
> > +	super->s_victim_ino = inode->i_ino;
> > +
> > +	/* remove dentry */
> > +	if (inode->i_mode & S_IFDIR)
> > +		dir->i_nlink--;
> > +	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> > +	ret = logfs_dir_walk(dir, dentry, logfs_unlink_handler);
> > +	super->s_victim_ino = 0;
> > +	if (ret)
> > +		goto out;
> > +
> > +	/* remove inode */
> > +	ret = logfs_remove_inode(inode);
> 
> Please remove this goto / label construct and  do
> 
> 	if (likely(!ret))
> 		ret = logfs_remove_inode(inode);
> 
> instead

In general I don't like to do that.  But however much code was here
before has all moved into logfs_remove_inode(), so there is little use
of a goto around a single line.  Will do.

> > +out:
> > +	mutex_unlock(&super->s_victim_mutex);
> > +	return ret;
> > +}
> > +
> > +
> > +/* FIXME: readdir currently has it's own dir_walk code.  I don't see a good
> > + * way to combine the two copies */
> > +#define IMPLICIT_NODES 2
> > +static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
> > +{
> > +	struct logfs_disk_dentry dd;
> > +	loff_t pos = file->f_pos - IMPLICIT_NODES;
> > +	int err;
> > +
> > +	BUG_ON(pos<0);
> > +	for (;; pos++) {
> > +		struct inode *dir = file->f_dentry->d_inode;
> 
> new line please

I'll move the variable definition up instead.

> > +		err = read_dir(dir, &dd, pos);
> > +		if (err == -EOF)
> > +			break;
> 
> 	-EOF results in a return code 0 ?

	The readdir() function returns a pointer to a dirent structure, or NULL
	if an error occurs or end-of-file is reached.  On error, errno  is  set
	appropriately.

Seems to match what the manpage sais and other kernel code does.  Apart
from that, see the comment to the EOF definition.

> > +	if (file->f_pos == 1) {
> > +		ino_t pino = parent_ino(file->f_dentry);
> 
> empty line

Aye.

> > +	/* FIXME: the file size should actually get aligned when writing,
> > +	 * not when reading. */
> 
> Please use 
> 
> 	/*
> 	 * kernel style 
> 	 * multi line comments
> 	 */

What is the rationale here?

> > +	if (dest) /* symlink */
> > +		ret = logfs_inode_write(inode, dest, destlen, 0);
> > +	else /* creat/mkdir/mknod */
> > +		ret = __logfs_write_inode(inode);
> 
> 
> Please remove this confusing tail comments

?!?

Imo they explain what is going on in either of those cases.  Do you
consider that to be self-explanatory?

> > +/* FIXME: This should really be somewhere in the 64bit area. */
> > +#define LOGFS_LINK_MAX (1<<30)
> 
> Please move the define to the header file or some other useful place

Will do.

> > +
> > +static struct inode_operations ext2_symlink_iops = {
> > +	.readlink	= generic_readlink,
> > +	.follow_link	= page_follow_link_light,
> > +};
> 
> s/ext2/logfs/ maybe ?

What was I thinking?  Or rather, was I thinking at all?

> > +static int logfs_nop_handler(struct inode *dir, struct dentry *dentry,
> > +		struct logfs_disk_dentry *dd, loff_t pos)
> > +{
> > +	return 0;
> > +}
> 
> New line

Sure.

> > +static int logfs_delete_dd(struct inode *dir, struct logfs_disk_dentry *dd,
> > +		loff_t pos)
> > +{
> > +	int err;
> > +
> > +	err = read_dir(dir, dd, pos);
> > +	if (err == -EOF) /* don't expose internal errnos */
> > +		err = -EIO;
> 
> Interesting. Why is EOF morphed to EIO ?

Because deleting something beyond EOF is indeed an error.  Although in
two cases, this should be a BUG() instead, if anything at all.

Journal replay is special.  Garbage and/or malicious data on the medium
cause this error.  The journal CRCs should protect us against garbage,
which leaves only the prepared filesystem image to worry about.

I guess I'll just BUG in any case.

> > +static int logfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> > +		struct inode *new_dir, struct dentry *new_dentry)
> > +{
> > +	if (new_dentry->d_inode) /* target exists */
> > +		return logfs_rename_target(old_dir, old_dentry, new_dir, new_dentry);
> > +	else if (old_dir == new_dir) /* local rename */
> > +		return logfs_rename_local(old_dir, old_dentry, new_dentry);
> 
> Comment style

So what should this code look like?

> > +	return logfs_rename_cross(old_dir, old_dentry, new_dir, new_dentry);
> > +}
> > +
> > --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> > +++ linux-2.6.21logfs/fs/logfs/file.c	2007-05-07 13:32:12.000000000 +0200
> > @@ -0,0 +1,82 @@
> 
> Comment missing. License missing.

License should be obvious for any kernel code.  I can add "GPLv2" but
please don't expect me to spam every file with the full preamble.

Copyright lines might be useful.  A short explanation of what the file
does even more so.  Anything else?

> > +#include "logfs.h"
> > +
> > +
> > +static int logfs_prepare_write(struct file *file, struct page *page,
> > +		unsigned start, unsigned end)
> > +{
> > +	if (PageUptodate(page))
> > +		return 0;
> > +
> > +	if ((start == 0) && (end == PAGE_CACHE_SIZE))
> > +		return 0;
> 
> 	Self explaining logic ?

Boilerplate code that every filesystem uses.

> > +	return logfs_readpage_nolock(page);
> > +}
> > +
> > +
> > +static int logfs_readpage(struct file *file, struct page *page)
> > +{
> > +	int ret = logfs_readpage_nolock(page);
> 
> empty line

Three lines, you win again.

> > +	unlock_page(page);
> > +	return ret;
> > +}
> > +
> > +
> > +static int logfs_writepage(struct page *page, struct writeback_control *wbc)
> > +{
> > +	BUG();
> 
> Is this a permanent solution ?

I can rip that function out.  read-write mmap() currently isn't
supported and will be harder to implement than it used to be before
compression support was added.

> > +#if 0
> 
> Can you please remove this ?

Nope.  That code will get used in the future.

> Interestingly enough this unused function is better commented than
> anything else in this patch.

With the exception of dir.c.  In both cases I was documenting the
algorithm used, which is far from obvious.  Most other things are fairly
straightforward for people used to existing filesystems.

> > +		//printk("%x %x (%llx, %llx, %llx)(%x, %x)\n", h.type, h.compr, ofs, ino, pos, valid, size);
> 
> 	Please remove

Will do.  Most of these printk()s fall into the same category as any
TRACE() statement still left in the code.

> > +static void __logfs_gc_segment(struct super_block *sb, u32 segno)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	struct logfs_object_header h;
> > +	struct logfs_segment_header *sh;
> > +	u64 ofs, ino, pos;
> > +	u32 seg_ofs;
> > +	int level;
> > +
> > +	device_read(sb, segno, 0, sizeof(h), &h);
> 
> 
> 	See above comment about device_read() implementation.
> 
> > +	sh = (void*)&h;
> 
> Please use proper type casting !

How would that improve the code?  (void*) clearly states that "I don't
care what the base type it, just cast this thing to the new pointer
type."  (struct logfs_segment_header*) would state the same but be less
concise.

> > +static void __add_segment(struct list_head *list, int *count, u32 segno,
> > +		int valid)
> > +{
> > +	struct logfs_segment *seg = kzalloc(sizeof(*seg), GFP_KERNEL);
> 
> empty line

Aye.

> > +	if (!seg)
> > +		return;
> > +
> > +	seg->segno = segno;
> > +	seg->valid = valid;
> > +	list_add(&seg->list, list);
> > +	*count += 1;
> > +}
> 
> Also __add_segment() can fail. Why is there no return code ?

Lack of sleep when writing this?  Not sure.  Will look into it.

> > +
> > +
> > +static void add_segment(struct list_head *list, int *count, u32 segno,
> > +		int valid)
> > +{
> > +	struct logfs_segment *seg;
> > +	list_for_each_entry(seg, list, list)
> > +		if (seg->segno == segno)
> > +			return;
> > +	__add_segment(list, count, segno, valid);
> 
> 	Can fail. Error handling ?

dito

> > +static void scan_segment(struct super_block *sb, u32 segno)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	u32 full = super->s_segsize - sb->s_blocksize - 0x18; /* one header */
> 
> Please use a understandable constant instead of 0x18

Will do.

> > +	for (i = super->s_sweeper+1; i != super->s_sweeper; i++) {
> 
> 	for (i = super->s_sweeper + 1; i != super->s_sweeper; i++) {

We disagree on this one in general.

> > +		if (i >= super->s_no_segs)
> > +			i=1;	/* skip superblock */
> 
> 			i = 1;
> 	and remove tail comment

And on the tail comments.  Your problem with them really puzzles me.

> > +/* GC all the low-count segments.  If necessary, rescan the medium.
> > + * If we made enough room, return */
> > +static void logfs_gc_several(struct super_block *sb)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	int rounds;
> > +
> > +	rounds = super->s_low_count;
> > +
> > +	for (; rounds; rounds--) {
> > +		if (super->s_free_count >= super->s_total_levels)
> > +			return;
> > +		if (super->s_free_count < 3) {
> > +			logfs_scan_pass(sb);
> > +			printk("s");
> 
> 	Debug leftover ?
> 
> > +		}
> > +		logfs_gc_once(sb);
> > +#if 1
> > +		if (super->s_free_count >= super->s_total_levels)
> > +			return;
> > +		printk(".");
> > +#endif
> 
> 	Dito ?

More or less.  These might still make sense, although they can use a
properly wrapped #ifdef DEBUG or so.

> > +void logfs_gc_pass(struct super_block *sb)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	int i;
> > +
> > +	for (i=4; i; i--) {
> 
> 	(i = 4; ...
> 
> 	Please use a constant instead of 4

Or rather add a comment?  This code is quite strange.  In principle it
should not work and yet it does.  I am secretly hoping for someone to
trip over it so I finally have a testcase.

Or I should just overhaul the whole GC code and add usage counts to the
medium.  That should speed things up as well.

> > +		if (super->s_free_count >= super->s_total_levels)
> > +			return;
> > +		logfs_scan_pass(sb);
> > +
> > +		if (super->s_free_count >= super->s_total_levels)
> > +			return;
> > +		printk("free:%8d, low:%8d, sweeper:%8lld\n",
> > +				super->s_free_count, super->s_low_count,
> > +				super->s_sweeper);
> 
> Debug leftover ? Otherwise please add loglevel and some hint from which
> code this originates

pr_debug and loglevel it is.

> > +void logfs_cleanup_gc(struct logfs_super *super)
> > +{
> > +	free_all_segments(super);
> > +}
> 
> Can we add another wrapper to this please ?

Must be historical.  I'll wrap it as a gift and spray it with cheap
parfume.

> > +#include "logfs.h"
> > +#include <linux/backing-dev.h>
> > +#include <linux/writeback.h> /* for inode_lock */
> 
> Please remove the stupid comment

Or rather replace it with something longer.  In principle, filesystems
shouldn't have to muck with <linux/writeback.h> at all.  Sadly I have to
in order to solve another deadlock race, similar to the one fixed with
the I_SYNC patch.

> > +	/* This is a blatant copy of alloc_inode code.  We'd need alloc_inode
> > +	 * to be nonstatic, alas. */
> > +	{
> > +		static const struct address_space_operations empty_aops;
> > +		struct address_space * const mapping = &inode->i_data;
> 
> Please remove the brackets and move the variables to the top of the
> fucntion

Erm?  Did you read the comment?  I have copied the code from
alloc_inode() without changes.  That is bad enough as it is.  If I were
to change the code format, chances of detecting changes in one function
not followed in the other would increase even more.

I'm sure this particular gem can use some discussion, as long as it's
not limited to formatting issues.

> > +		mapping->a_ops = &empty_aops;
> > +		mapping->host = inode;
> > +		mapping->flags = 0;
> > +		mapping_set_gfp_mask(mapping, GFP_HIGHUSER);
> > +		mapping->assoc_mapping = NULL;
> > +		mapping->backing_dev_info = &default_backing_dev_info;
> > +		inode->i_mapping = mapping;
> > +	}
> > +
> > +	return inode;
> > +}

[...]

> > +static be64 timespec_to_be64(struct timespec tsp)
> > +{
> > +	u64 time = ((u64)tsp.tv_sec << 32) + (tsp.tv_nsec & 0xffffffff);
> 
> tsp.tv_nsec & 0xffffffff ????
> 
> timespecs need to be normalized, so tv_nsec can never be greater than
> 999999999 == 0x3B9AC9FF

Good point.  And I don't even remember anymore when or why I did this.
Will look into it.

> > +	case S_IFCHR: /* fall through */
> 
> Sigh. Could you please add useful comments ?

These _are_ useful.  You can grep the kernel and will find plenty of
existing code using them.  One of the reasons is that it allows code
checkers to distinguish fall-through cases that the programmer did
(claim to) think about from others.

Using such a code checker I have found several bugs in the kernel and
another one in my own code.  My own code used to be correct, but Frank
didn't notice the fall-though and rearranged it, introducing the bug.
So the comment seems to help humans as well.

> > +static int __logfs_read_inode(struct inode *inode)
> > +{
> > +	struct logfs_inode *li = LOGFS_INODE(inode);
> > +	struct logfs_disk_inode di;
> > +	int ret;
> > +
> > +	ret = logfs_read_disk_inode(&di, inode);
> > +	/* FIXME: move back to mkfs when format has settled */
> > +	if (ret == -ENODATA && inode->i_ino == LOGFS_INO_ROOT) {
> > +		memset(&di, 0, sizeof(di));
> > +		di.di_flags	= cpu_to_be32(LOGFS_IF_VALID);
> > +		di.di_mode	= cpu_to_be16(S_IFDIR | 0755);
> > +		di.di_refcount	= cpu_to_be32(2);
> > +		ret = 0;
> > +	}
> > +	if (ret)
> > +		return ret;
> > +	logfs_disk_to_inode(&di, inode);
> > +
> > +	if ( !(li->li_flags&LOGFS_IF_VALID) || (li->li_flags&LOGFS_IF_INVALID))
> > +		return -EIO;
> 
> 	Is this really an IO error ?

According to some, almost everything is.  Do you have a better
suggestion for corrupt data?

> > +/**
> 
> Do not use kernel doc comment start sequence for non kernel doc comments
> please 

Will change.

> > +	/* FIXME: ino allocation should work in two modes:
> > +	 * o nonsparse - ifile is mostly occupied, just append
> > +	 * o sparse - ifile has lots of holes, fill them up
> > +	 */
> 
> Comment style

sure.

> > +	for (i=0; i<JE_LAST; i++) {
> > +		struct logfs_journal_entry *spec = super->s_speculative + i;
> > +		struct logfs_journal_entry *retired = super->s_retired + i;
> 
> empty line

Yup.

> > +		if (!super->s_first.used) { /* remember first version */
> 
> 	Comment style

joern@Galway:/usr/src/kernel/linux-2.6.20$ rgrep -e '[a-zA-Z].*/\*.*\*/' .|wc
 299763 2549211 24838554

Some has managed to smuggle almost 300k of those comments past Linus.  I
would love to hear your reasons for not liking them.

> > +static void reserve_sb_and_journal(struct super_block *sb)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	struct btree_head *head = &super->s_reserved_segments;
> > +	int i, err;
> > +
> > +	err = btree_insert(head, 0, (void*)1);
> 
> What stands 1 for ?

Anything but NULL.  I could have picked 2.

Will add a comment.

> > +		struct logfs_journal_entry *je = super->s_retired + i;
> > +		if (!super->s_retired[i].used)
> 
> 		if (!super->s_retired[i].used) {

If you prefer, sure.

> > +		err = mtdread(sb, je->offset, sb->s_blocksize, block);
> > +		if (err)
> > +			return err;
> 
> > +		level = i & 0xf;
> 
> what is 0xf ?
> 
> > +		area = super->s_area[level];
> > +		switch (i & ~0xf) {
> > +		case JEG_BASE:
> > +			switch (i) {
> 
> Represents I an enum or a bitfield or both ?

Both.  High nibble groups the journal entries.  High nibble 0 are the
normal journal entries.  High nibble 1 are the summaries for all levels.

"Levels" is something I should document, seeing that most people haven't
watched my LCA presentation.

> > +static void journal_get_free_segment(struct logfs_area *area)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
> > +	int i;
> > +
> > +	journal_for_each(i) {
> > +		if (area->a_segno != super->s_journal_seg[i])
> > +			continue;
> > +empty_seg:
> > +		i++;
> > +		if (i == LOGFS_JOURNAL_SEGS)
> > +			i = 0;
> > +		if (!super->s_journal_seg[i])
> > +			goto empty_seg;
> 
> 
> Does this loop for ever or is there a guranteed exit ?
> Please use a do while loop instead of the goto

There is a guaranteed exit.  mkfs can specify up to four segments (read
erase blocks) for the journal to live in.  Two are the required minimum.
In order to specify just two segments, the array will be initialized
like {1, 2, 0, 0}.

This code shall find the current segment from that array, then pick the
next one and skip over any entries that are zero.

Will use do..while.

> > +static s64 logfs_get_free_entry(struct super_block *sb)
> > +{
> > +	s64 ret;
> > +
> > +	mutex_lock(&LOGFS_SUPER(sb)->s_log_mutex);
> > +	ret = __logfs_get_free_entry(sb);
> > +	mutex_unlock(&LOGFS_SUPER(sb)->s_log_mutex);
> > +	BUG_ON(ret <= 0); /* not sure, but it's safer to BUG than to accept */
> 
> It might be safer to do proper error handling.

Send me a testcase. :)

As above, I prefer explicitly stating "this has never happened, I have
no clue what should be done" over some half-assed "I hope this works,
even though noone ever tested it".

Both are lame, one just happens to be slightly less wicked and a lot
more honest.

> > +static void *logfs_write_areas(struct super_block *sb, void *_a,
> > +		u16 *type, size_t *len)
> > +{
> > +	struct logfs_area *area;
> > +	struct logfs_je_areas *a = _a;
> > +	int i;
> > +
> > +	for (i=0; i<16; i++) { /* FIXME: have all 16 areas */
> > +		a->used_bytes[i] = 0;
> > +		a->segno[i] = 0;
> > +	}
> 
> 	memset perhaps ?

Perhaps, but it would be better to heed the comment and remove this
loop.

> > +int logfs_write_anchor(struct inode *inode)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	void *block = super->s_compressed_je;
> > +	u64 ofs;
> > +	size_t jpos;
> > +	int i, ret;
> > +
> > +	ofs = logfs_get_free_entry(sb);
> > +	BUG_ON(ofs >= super->s_size);
> > +
> > +	memset(block, 0, sb->s_blocksize);
> > +	jpos = 0;
> > +	for (i=0; i<LOGFS_NO_AREAS; i++) {
> 
> 	i = 0; ...
> > +		super->s_sum_index = i;
> > +		jpos += logfs_write_je(sb, jpos, logfs_write_wbuf);
> > +	}
> > +	jpos += logfs_write_je(sb, jpos, logfs_write_bb);
> > +	jpos += logfs_write_je(sb, jpos, logfs_write_erasecount);
> > +	jpos += logfs_write_je(sb, jpos, __logfs_write_anchor);
> > +	jpos += logfs_write_je(sb, jpos, logfs_write_dynsb);
> > +	jpos += logfs_write_je(sb, jpos, logfs_write_areas);
> > +	jpos += logfs_write_je(sb, jpos, logfs_write_commit);
> > +
> > +	BUG_ON(jpos > sb->s_blocksize);
> > +
> > +	ret = mtdwrite(sb, ofs, sb->s_blocksize, block);
> > +	if (ret)
> > +		return ret;
> > +	return 0;
> 
> 	Interesting way to reyl on compiler smartness

Que?

> > +int logfs_init_journal(struct super_block *sb)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	int ret;
> > +
> > +	mutex_init(&super->s_log_mutex);
> > +
> > +	super->s_je = kzalloc(sb->s_blocksize, GFP_KERNEL);
> > +	if (!super->s_je)
> > +		goto err0;
> > +
> > +	super->s_compressed_je = kzalloc(sb->s_blocksize, GFP_KERNEL);
> > +	if (!super->s_compressed_je)
> > +		goto err1;
> > +
> > +	super->s_bb_array = kzalloc(sb->s_blocksize, GFP_KERNEL);
> > +	if (!super->s_bb_array)
> > +		goto err2;
> > +
> > +	super->s_master_inode = logfs_new_meta_inode(sb, LOGFS_INO_MASTER);
> > +	if (!super->s_master_inode)
> > +		goto err3;
> > +
> > +	super->s_master_inode->i_nlink = 1; /* lock it in ram */
> > +
> > +	/* logfs_scan_journal() is looking for the latest journal entries, but
> > +	 * doesn't copy them into data structures yet.  logfs_read_journal()
> > +	 * then re-reads those entries and copies their contents over. */
> > +	ret = logfs_scan_journal(sb);
> > +	if (ret)
> > +		return ret;
> 
> 	what about the allocated buffers ?

Those just leaked.  Someone should get a rope and try to catch them.
Will fix.

> > + */
> > +#include "logfs.h"
> > +
> > +
> > +static int logfs_read_empty(void *buf, int read_zero)
> > +{
> > +	if (!read_zero)
> > +		return -ENODATA;
> > +
> > +	memset(buf, 0, PAGE_CACHE_SIZE);
> 
> 	Is buf guaranteed to be at least sizeof(PAGE_CACHE_SIZE) ?

It is guaranteed to be exactly PAGE_CACHE_SIZE.  And if PAGE_CACHE_SIZE
is not guaranteed to be 4KiB, I am guaranteed to receive a bug report.

Testing for endianness was fairly simple by having a big-endian format.
Testing for PAGE_CACHE_SIZE would require an actual itanic or similar
system.  So I willfully screwed ~1% of my potential users in exchange
for "will fix later" scribbled on a used envelope.

> > +	//printk("ino=%lx, index=%lx, blocks=%llx\n", inode->i_ino, index, block);
> 
> Please remove

Yup.

> > +	return logfs_segment_read(inode->i_sb, buf, block);
> > +}
> > +
> > +
> > +
> > +static unsigned long get_bits(u64 val, int skip, int no)
> > +{
> > +	u64 ret = val;
> > +
> > +	ret >>= skip * no;
> > +	ret <<= 64 - no;
> > +	ret >>= 64 - no;
> > +	BUG_ON((unsigned long)ret != ret);
> 
> 	????

I guess that can go now.  A fairly common bug I encountered was to deal
with some insanely large 64bit number, often 0xffff_ffff_ffff_ffff.
This would catch such a bug early, if it occured here.  And I'm sure it
once did.

> > +static u64 seek_data_loop(struct inode *inode, u64 pos, int count)
> > +{
> > +	struct logfs_inode *li = LOGFS_INODE(inode);
> > +	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
> > +	be64 *rblock;
> > +	u64 bofs = li->li_data[I1_INDEX + count];
> > +	int bits = LOGFS_BLOCK_BITS;
> > +	int i, ret, slot;
> > +
> > +	BUG_ON(!bofs);
> > +
> > +	rblock = logfs_get_rblock(super);
> > +
> > +	for (i=count; i>=0; i--) {
> > +		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
> > +		if (ret)
> > +			goto out;
> 
> 	break;
> 
> > +		slot = get_bits(pos, i, bits);
> > +		while (slot < LOGFS_BLOCK_FACTOR && rblock[slot] == 0) {
> > +			slot++;
> > +			pos += 1 << (LOGFS_BLOCK_BITS * i);
> > +		}
> > +		if (slot >= LOGFS_BLOCK_FACTOR)
> > +			goto out;
> 
> 	break;

Must be historical.  Will do.

> > +static int logfs_is_valid_loop(struct inode *inode, pgoff_t index,
> > +		int count, u64 ofs)
> > +{
> > +	struct logfs_inode *li = LOGFS_INODE(inode);
> > +	struct logfs_super *super = LOGFS_SUPER(inode->i_sb);
> > +	be64 *rblock;
> > +	u64 bofs = li->li_data[I1_INDEX + count];
> > +	int bits = LOGFS_BLOCK_BITS;
> > +	int i, ret;
> > +
> > +	if (!bofs)
> > +		return 0;
> > +
> > +	if (bofs == ofs)
> > +		return 1;
> > +
> > +	rblock = logfs_get_rblock(super);
> > +
> > +	for (i=count; i>=0; i--) {
> 
> 	....
> 
> > +		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
> > +		if (ret)
> > +			goto fail;
> 
> 	please use break and do a return !ret;

Not much nicer if you ask me.  How about if I split the function and
have the inner one return directly without having to worry
aboutlogfs_put_rblock()?

> > +	//printk("%lx, %x, %x\n", inode->i_ino, inode->i_nlink, atomic_read(&inode->i_count));
> 
> 	Sigh

Will kill.

> > +	if ((u64)(u_long)ino != ino) {
> > +		printk("%llx, %llx, %llx\n", ofs, ino, pos);
> 
> 	more sigh

Running out of rat poison.  Will hit it with a stick until dead.

> > +#if 0
> > +	/* Any data belonging to dirty inodes must be considered valid until
> > +	 * the inode is written back.  If we prematurely deleted old blocks
> > +	 * and crashed before the inode is written, the filesystem goes boom.
> > +	 */
> > +	if (inode->i_state & I_DIRTY)
> > +		ret = 2;
> > +	else
> 
> There seems to be a patternm, that unused code is surprisingly well
> commented.

This is the "will eat your data" bug mentioned in the initial mail.  I
simply haven't replaced the comment with working code yet.

Any comments to used code you would like to see?  Your pattern appears
to be "remove comment". :)

> > +	pr_debug("read from %lld, count %zd\n", *ppos, count);
> 
> Loglevel missing

Actually that one should be ripped out.  Will do.

> > +	if (*ppos >= size)
> > +		return 0;
> > +	if (count > size - *ppos)
> > +		count = size - *ppos;
> > +
> > +	BUG_ON(logfs_index(*ppos) != logfs_index(*ppos + count - 1));
> > +
> > +	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
> > +	if (!block_data)
> > +		goto fail;
> > +
> > +	err = logfs_read_block(inode, logfs_index(*ppos), block_data,
> > +			read_zero);
> > +	if (err)
> > +		goto fail;
> > +
> > +	memcpy(buf, block_data + (*ppos % LOGFS_BLOCKSIZE), count);
> > +	*ppos += count;
> > +	kfree(block_data);
> > +	return count;
> 
> 	err = count; and fall trough ?

Then I would change *ppos.

> > +		//TRACE();
> 
> 	Sigh.

*CLUB*

> > +		//TRACE();
> 
> 	more sigh

*SPLAT*

> > +			//TRACE();
> 
> 	again

*KICK*

> > +		//TRACE();
> 
> 	yet more

*STRANGLE*

> > +	//printk("(%lx, %lx, %llx, %x)\n", inode->i_ino, index, ofs, level);
> 
> 	yay !

I'm getting out of breath.

> > +	wblocks = super->s_wblock;
> > +	buf = wblocks[LOGFS_MAX_INDIRECT];
> > +	ret = __logfs_rewrite_block(inode, index, buf, wblocks, level);
> > +	return ret;
> > +}
> > +
> > +
> > +/**
> 
> Please do not use /** here, it is the start sequence for kernel doc
> comments

Aye.

> > +/* FIXME: move to super */
> 
> Please do so

Yep.

> > +static u64 logfs_factor[] = {
> > +	LOGFS_BLOCKSIZE,
> > +	LOGFS_I1_SIZE,
> > +	LOGFS_I2_SIZE,
> > +	LOGFS_I3_SIZE
> > +};
> > +
> 
> > +
> > +static ssize_t __logfs_inode_write(struct inode *inode, const char *buf,
> > +		size_t count, loff_t *ppos)
> > +{
> > +	void *block_data = NULL;
> > +	int err = -ENOMEM;
> > +
> > +	pr_debug("write to 0x%llx, count %zd\n", *ppos, count);
> > +
> > +	BUG_ON(logfs_index(*ppos) != logfs_index(*ppos + count - 1));
> > +
> > +	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
> > +	if (!block_data)
> > +		goto fail;
> > +
> > +	err = logfs_read_block(inode, logfs_index(*ppos), block_data, 1);
> > +	if (err)
> > +		goto fail;
> > +
> > +	memcpy(block_data + (*ppos % LOGFS_BLOCKSIZE), buf, count);
> > +
> > +	if (i_size_read(inode) < *ppos + count)
> > +		i_size_write(inode, *ppos + count);
> > +
> > +	err = logfs_write_buf(inode, logfs_index(*ppos), block_data);
> > +	if (err)
> > +		goto fail;
> > +
> > +	*ppos += count;
> > +	pr_debug("write to %lld, count %zd\n", *ppos, count);
> 
> 	Please add some hint, where this comes from

Where what comes from?  The pr_debug will go, I haven't used it for
ages, so it clearly is pointless.

> > +	kfree(block_data);
> > +	return count;
> 
> 	err = count; fall trhough ?

*ppos again.

> > +	ret = ret==n ? 0 : -EIO;
> 
> 	return ret == n ? ..... perhaps ?

Again I consider the lack of spaces to give better grouping.  It is
similar to brackets.  In general they help, but then there is Lisp...

> > +
> > +
> > +#define FAIL_ON(cond) do { if (unlikely((cond))) return -EINVAL; } while(0)
> 
> Please open code

Done.  I'd have to check the archives to see when the last user of this
was removed.  Will kill the definition as well.

> > +int mtdread(struct super_block *sb, loff_t ofs, size_t len, void *buf)
> > +{
> > +	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
> > +	size_t retlen;
> > +	int ret;
> > +
> > +	ret = mtd->read(mtd, ofs, len, &retlen, buf);
> > +	if (ret || (retlen != len)) {
> > +		printk("ret: %x\n", ret);
> > +		printk("retlen: %x, len: %x\n", retlen, len);
> > +		printk("ofs: %llx, mtd->size: %x\n", ofs, mtd->size);
> 
> 	Sigh

Will kill.

> > +		dump_stack();
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +
> > +static void check(void *buf, size_t len)
> > +{
> > +	char value[8] = {0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a, 0x5a};
> > +	void *poison = buf, *end = buf + len;
> > +
> > +	while (poison) {
> > +		poison = memchr(poison, value[0], end-poison);
> > +		if (!poison || poison + 8 > end)
> > +			return;
> > +		if (! memcmp(poison, value, 8)) {
> > +			printk("%p %p %p\n", buf, poison, end);
> 
> 	More sigh
> 
> > +			BUG();
> > +		}
> > +		poison++;
> > +	}
> > +}

I guess the whole function can go.  Leaking uninitialized data was a
problem when I had to change the format.  That shouldn't happen very
often anymore.

> > +int mtdwrite(struct super_block *sb, loff_t ofs, size_t len, void *buf)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	struct mtd_info *mtd = super->s_mtd;
> > +	struct inode *inode = super->s_dev_inode;
> > +	size_t retlen;
> > +	loff_t page_start, page_end;
> > +	int ret;
> > +
> > +	if (0) /* FIXME: this should be a debugging option */
> > +		check(buf, len);
> > +
> > +	//printk("write ofs=%llx, len=%x\n", ofs, len);
> 
> 	hrmpf
> 
> > +	BUG_ON((ofs >= mtd->size) || (len > mtd->size - ofs));
> > +	BUG_ON(ofs != (ofs >> super->s_writeshift) << super->s_writeshift);
> > +	//BUG_ON(len != (len >> super->s_blockshift) << super->s_blockshift);
> 
> 	hrmpf

*grabs some more bullets*

> > +	/* FIXME: fix all callers to write PAGE_CACHE_SIZE'd chunks */
> > +	BUG_ON(len > PAGE_CACHE_SIZE);
> > +	page_start = ofs & PAGE_CACHE_MASK;
> > +	page_end = PAGE_CACHE_ALIGN(ofs + len) - 1;
> > +	truncate_inode_pages_range(&inode->i_data, page_start, page_end);
> > +	ret = mtd->write(mtd, ofs, len, &retlen, buf);
> > +	if (ret || (retlen != len))
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +
> > +static DECLARE_COMPLETION(logfs_erase_complete);
> 
> empty line
> 
> > +static void logfs_erase_callback(struct erase_info *ei)
> > +{
> > +	complete(&logfs_erase_complete);
> > +}
> 
> dito

What is your opinion on that code pattern anyway.  Unless something
dramatically changed in the last few month, mtd->erase() is a synchonous
operation with an asynchronous interface.  Does it still make sense to
hope for our first asynchronous driver ever or is this a target for some
code removal?

> > +int mtderase(struct super_block *sb, loff_t ofs, size_t len)
> > +{
> > +	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
> > +	struct inode *inode = LOGFS_SUPER(sb)->s_dev_inode;
> > +	struct erase_info ei;
> > +	int ret;
> > +
> > +	BUG_ON(len % mtd->erasesize);
> > +
> > +	truncate_inode_pages_range(&inode->i_data, ofs, ofs+len-1);
> > +	if (mtd->block_isbad(mtd, ofs))
> > +		return -EIO;
> 
> this actually leads to a double check of block_isbad for blocks which
> are not bad. 

Does it?  Where is the second check happening?

> > +	memset(&ei, 0, sizeof(ei));
> > +	ei.mtd = mtd;
> > +	ei.addr = ofs;
> > +	ei.len = len;
> > +	ei.callback = logfs_erase_callback;
> > +	ret = mtd->erase(mtd, &ei);
> > +	if (ret)
> > +		return -EIO;
> > +
> > +	wait_for_completion(&logfs_erase_complete);
> > +	if (ei.state != MTD_ERASE_DONE)
> > +		return -EIO;
> > +	return 0;
> > +}
> > +
> > +
> > +
> > +void *logfs_device_getpage(struct super_block *sb, u64 offset,
> > +		struct page **page)
> > +{
> > +	struct inode *inode = LOGFS_SUPER(sb)->s_dev_inode;
> > +
> > +	*page = read_cache_page(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
> > +			logfs_readdevice, NULL);
> > +	BUG_ON(IS_ERR(*page));	/* TODO: use mempool here */
> 
> 				For the BUG ?

At least for the cases where IS_ERR(*page) equals -ENOMEM.

> > +#if 1
> > +	err = logfs_fsck(sb);
> > +#else
> > +	err = 0;
> > +#endif
> 
> 	Please cleanup

Should become a config option or finally go to userspace.  fsck() will,
as one can expect, read the complete device.  Very useful during
development to catch bugs early, but killing mount time.

> > +static int logfs_get_sb(struct file_system_type *type, int flags,
> > +		const char *devname, void *data, struct vfsmount *mnt)
> > +{
> > +	ulong mtdnr;
> > +	struct mtd_info *mtd;
> > +
> > +#if 0
> > +	if (!devname)
> > +		return ERR_PTR(-EINVAL);
> > +	if (strncmp(devname, "mtd", 3))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	{
> > +		char *garbage;
> > +		mtdnr = simple_strtoul(devname+3, &garbage, 0);
> > +		if (*garbage)
> > +			return ERR_PTR(-EINVAL);
> > +	}
> > +#else
> > +	mtdnr = 0;
> > +#endif
> > +
> 
> 	Please cleanup

I haven't touched that code for... two years!
Will do.

> > +-- /dev/null	2007-04-18 05:32:26.652341749 +0200
> > +++ linux-2.6.21logfs/fs/logfs/progs/mkfs.c	2007-05-07 13:32:12.000000000 +0200
> 
> why needs this to be in a sub directory ? And shouldn't this be user
> space tools - or what I'm missing here ?

During development it was helpful to have them in the kernel.  Changing
the filesystem format goes much faster that way.

It might be about time to move these to userspace now.

> > +#include "../logfs.h"
> > +
> > +#define OFS_SB		0
> > +#define OFS_JOURNAL	1
> > +#define OFS_ROOTDIR	3
> > +#define OFS_IFILE	4
> > +#define OFS_COUNT	5
> 
> enum ?

Maybe, yes.

> > +#if 0
> > +/* rootdir */
> > +static int make_rootdir(struct super_block *sb)
> > +{
> > +	struct logfs_disk_inode *di;
> > +	int ret;
> > +
> > +	di = kzalloc(blocksize, GFP_KERNEL);
> > +	if (!di)
> > +		return -ENOMEM;
> > +
> > +	di->di_flags	= cpu_to_be32(LOGFS_IF_VALID);
> > +	di->di_mode	= cpu_to_be16(S_IFDIR | 0755);
> > +	di->di_refcount	= cpu_to_be32(2);
> > +	ret = mtdwrite(sb, segment_offset[OFS_ROOTDIR], blocksize, di);
> > +	kfree(di);
> > +	return ret;
> > +}
> > +
> > +
> > +/* summary */
> > +static int make_summary(struct super_block *sb)
> > +{
> > +	struct logfs_disk_sum *sum;
> > +	u64 sum_ofs;
> > +	int ret;
> > +
> > +	sum = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
> > +	if (!sum)
> > +		return -ENOMEM;
> > +	memset(sum, 0xff, LOGFS_BLOCKSIZE);
> > +
> > +	sum->oids[0].ino = cpu_to_be64(LOGFS_INO_MASTER);
> > +	sum->oids[0].pos = cpu_to_be64(LOGFS_INO_ROOT);
> > +	sum_ofs = segment_offset[OFS_ROOTDIR];
> > +	sum_ofs += segsize - blocksize;
> > +	sum->level = LOGFS_MAX_LEVELS;
> > +	ret = mtdwrite(sb, sum_ofs, LOGFS_BLOCKSIZE, sum);
> > +	kfree(sum);
> > +	return ret;
> > +}
> > +#endif
> 
> Please remove

Err, no.  You were not supposed to see that little magic trick.  While
adding compression I removed the root dir from mkfs and added it instead
in the kernel.  That is a hack, but works as long as one writes the
dirty inode out before the filesystem fills up (guess what one of my
testcases does).

Now would be a good time to add it back to mkfs.  And quickly, before
anyone else sees it.

> > +#if 0
> > +	da->da_used_bytes = cpu_to_be64(blocksize);
> > +	da->da_data[LOGFS_INO_ROOT] = cpu_to_be64(3*segsize);
> > +#else
> > +	da->da_data[LOGFS_INO_ROOT] = 0;
> > +#endif
> 
> Please cleanup

I believe that falls into the same category.

> > +	*type = JE_ANCHOR;
> > +	return sizeof(*da);
> > +}
> 
> Empty line
> 
> > +static size_t je_dynsb(void *_dynsb, u16 *type)
> > +{
> > +	struct logfs_dynsb *dynsb = _dynsb;
> > +
> > +	memset(dynsb, 0, sizeof(*dynsb));
> > +	dynsb->ds_used_bytes	= cpu_to_be64(blocksize);
> > +	*type = JE_DYNSB;
> > +	return sizeof(*dynsb);
> > +}
> 
> Same
> 
> > +static size_t je_commit(void *h, u16 *type)
> > +{
> > +	*type = JE_COMMIT;
> > +	return 0;
> > +}
> 
> Same

Yup, yup, yup.

> > +/* superblock */
> > +static int make_super(struct super_block *sb, struct logfs_disk_super *ds)
> > +{
> > +	void *sector;
> > +	int ret;
> > +
> > +	sector = kzalloc(4096, GFP_KERNEL);
> > +	if (!sector)
> > +		return -ENOMEM;
> > +
> > +	memset(ds, 0, sizeof(*ds));
> > +
> > +	ds->ds_magic		= cpu_to_be64(LOGFS_MAGIC);
> > +#if 0	/* sane defaults */
> > +	ds->ds_ifile_levels	= 3; /* 2+1, 1GiB */
> > +	ds->ds_iblock_levels	= 4; /* 3+1, 512GiB */
> > +	ds->ds_data_levels	= 3; /* old, young, unknown */
> > +#else
> > +	ds->ds_ifile_levels	= 1; /* 0+1, 80kiB */
> > +	ds->ds_iblock_levels	= 4; /* 3+1, 512GiB */
> > +	ds->ds_data_levels	= 1; /* unknown */
> > +#endif
> 
> Please cleanup

This one will take some thought on a not-so-rainy day.  Will do, just
not immediatly.

> > +#if 0
> > +	ret = make_rootdir(sb);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = make_summary(sb);
> > +	if (ret)
> > +		return ret;
> > +#endif
> 
> Same

Magic trick, see above.

> > +static void safe_read(struct super_block *sb, u32 segno, u32 ofs,
> > +		size_t len, void *buf)
> > +{
> > +	BUG_ON(wbuf_read(sb, dev_ofs(sb, segno, ofs), len, buf));
> > +}
> 
> Empty line

Yep.

> > +static u32 logfs_free_bytes(struct super_block *sb, u32 segno)
> > +{
> 
> > +static void logfsck_blocks(struct super_block *sb)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	int i;
> > +	int free;
> > +
> > +	for (i=0; i<super->s_no_segs; i++) {
> > +		free = logfs_free_bytes(sb, i);
> > +		free_bytes += free;
> > +		printk(" %3x", free);
> > +		if (i % 8 == 7)
> > +			printk(" : ");
> > +		if (i % 16 == 15)
> > +			printk("\n");
> > +	}
> > +	printk("\n");
> 
> printk with loglevels and identifiable origin please

No.  This one will print a little statistic about segment usage.
Something like:

0 0 0 0 20000 12345 01234 ...

It is useful as-is for fsck purposes, except that the lines wrap since I
count bytes instead of blocks now.  "blocks" is a strange concept once
they get compressed.

> > +
> > +
> > +static s64 dir_seek_data(struct inode *inode, s64 pos)
> > +{
> > +	s64 new_pos = logfs_seek_data(inode, pos);
> 
> new line

Yup.

> > +static int __logfsck_dirs(struct inode *dir)
> > +{
> > +	struct inode *inode;
> > +	loff_t pos;
> > +	u64 ino;
> > +	u8 type;
> > +	int cookie, err, ret = 0;
> > +
> > +	for (pos=0; ; pos++) {
> > +		err = read_one_dd(dir, pos, &ino, &type);
> > +		//yield();
> 
> 	great. cond_resched() if you really need to

Not anymore, this can go.  But since we are on the subject, what is the
difference between yield() and cond_resched()?  Those two functions
could also use slightly better comments.

> > +		if (err == -ENODATA) { /* dentry was deleted */
> > +			pos = dir_seek_data(dir, pos);
> > +			continue;
> > +		}
> > +		if (err == -EOF)
> > +			break;
> > +		if (err)
> > +			goto error0;
> > +
> > +		err = -EIO;
> > +		if (ino > last_ino) {
> > +			printk("ino %llx > last_ino %llx\n", ino, last_ino);
> 
> 	loglevel .....

Yup for all of them.

> > +	//yield();
> 
> 	See above instance of //yield();

Will go.

> > +int logfs_fsck(struct super_block *sb)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > +	int ret = -ENOMEM;
> > +
> > +	used_bytes = 0;
> > +	free_bytes = 0;
> > +	last_ino = super->s_last_ino;
> > +	inode_bytes = kzalloc(last_ino * sizeof(be64), GFP_KERNEL);
> > +	if (!inode_bytes)
> > +		goto out0;
> 
> 	return ret;

Yep.

> > +	inode_links = kzalloc(last_ino * sizeof(be64), GFP_KERNEL);
> > +	if (!inode_links)
> > +		goto out1;
> > +
> > +	ret = __logfs_fsck(sb);
> > +
> > +	kfree(inode_links);
> > +	inode_links = NULL;
> > +out1:
> > +	kfree(inode_bytes);
> > +	inode_bytes = NULL;
> > +out0:
> > +	return ret;
> > +}
> > --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> > +++ linux-2.6.21logfs/fs/logfs/Locking	2007-05-07 13:32:12.000000000 +0200
> > @@ -0,0 +1,45 @@
> 
> Can you move this into documentation please

Just like fs/jffs2/README.Locking?

I don't care much one way or another.

> > +int logfs_compress_vec(struct kvec *vec, int count, void *out, size_t outlen)
> > +{
> > +	int i, ret;
> > +
> > +	mutex_lock(&compr_mutex);
> > +	ret = zlib_deflateInit(&stream, COMPR_LEVEL);
> > +	if (ret != Z_OK)
> > +		goto error;
> > +
> > +	stream.total_in = 0;
> > +	stream.total_out = 0;
> > +
> > +	for (i=0; i<count-1; i++) {
> > +		stream.next_in = vec[i].iov_base;
> > +		stream.avail_in = vec[i].iov_len;
> > +		stream.next_out = out + stream.total_out;
> > +		stream.avail_out = outlen - stream.total_out;
> > +
> > +		ret = zlib_deflate(&stream, Z_NO_FLUSH);
> > +		if (ret != Z_OK)
> > +			goto error;
> > +		/* if (stream.total_out >= outlen)
> > +			goto error; */
> 
> 	???
> 
> > +	}
> > +
> > +	stream.next_in = vec[count-1].iov_base;
> > +	stream.avail_in = vec[count-1].iov_len;
> > +	stream.next_out = out + stream.total_out;
> > +	stream.avail_out = outlen - stream.total_out;
> > +
> > +	ret = zlib_deflate(&stream, Z_FINISH);
> > +	if (ret != Z_STREAM_END)
> > +		goto error;
> > +	/* if (stream.total_out >= outlen)
> > +		goto error; */
> 
> 	???

Humm.  So far those functions are unused.  And I'm starting to doubt
their usefulness.  The commented-out code should be pure paranoia, but
that hardly matters now, does it.

> > +	mutex_unlock(&compr_mutex);
> > +	return ret;
> > +error:
> > +	mutex_unlock(&compr_mutex);
> > +	return -EIO;
> 
> 	Sigh. Can you please make this a bit more clever  ?

Sure.

> > +	h = (void*)compressor_buf;
> 
> 	please use proper typecasts

As before...

> > +static u64 logfs_block_mask[] = {
> > +	~0,
> > +	~(I1_BLOCKS-1),
> > +	~(I2_BLOCKS-1),
> > +	~(I3_BLOCKS-1)
> > +};
> 
> Empty line please
> 
> > +static int check_pos(struct super_block *sb, u64 pos1, u64 pos2, int level)
> > +{
> > +	LOGFS_BUG_ON(	(pos1 & logfs_block_mask[level]) !=
> > +			(pos2 & logfs_block_mask[level]), sb);
> > +}
> 
> empty line

Sure, sure.

> > +int logfs_open_area(struct logfs_area *area)
> > +{
> > +	if (area->a_is_open)
> > +		return 0; /* nothing to do */
> 
> 	yeah, another really helpful comment

:)

> > +static void ostore_get_free_segment(struct logfs_area *area)
> > +{
> > +	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
> > +	struct logfs_segment *seg;
> > +
> > +	BUG_ON(list_empty(&super->s_free_list));
> > +
> > +	seg = list_entry(super->s_free_list.prev, struct logfs_segment, list);
> > +	list_del(&seg->list);
> > +	area->a_segno = seg->segno;
> > +	kfree(seg);
> > +	super->s_free_count -= 1;
> 
> get_free_segment actually kfree's a segment ? Please use a less
> misleading function name

It actually gets a free segment.  It also kfree's an object that happens
to be called logfs_segment.  Both names make sense on their own.  The
combination... can be confusing.

I'm not exactly sure what to do here.

> > +	area->a_erase_count = be32_to_cpu(h.ec) + 1;
> > +}
> > +
> > +
> > +
> > +static int ostore_erase_segment(struct logfs_area *area)
> > +{
> > +	struct logfs_segment_header h;
> > +	u64 ofs;
> > +	int err;
> > +
> > +	err = logfs_erase_segment(area->a_sb, area->a_segno);
> > +	if (err)
> > +		return err;
> > +
> > +	h.len = 0;
> > +	h.type = OBJ_OSTORE;
> > +	h.level = area->a_level;
> > +	h.segno = cpu_to_be32(area->a_segno);
> > +	h.ec = cpu_to_be32(area->a_erase_count);
> > +	h.gec = cpu_to_be64(LOGFS_SUPER(area->a_sb)->s_gec);
> > +	h.crc = logfs_crc32(&h, sizeof(h), 4);
> > +	/* FIXME: write it out */
> 
> 	isn't that what buf_write() does ?

It is.  History leaking out again.  Will remove.

> > +	ofs = dev_ofs(area->a_sb, area->a_segno, 0);
> > +	area->a_used_bytes = sizeof(h);
> > +	return buf_write(area, ofs, &h, sizeof(h));
> > +}

[...]

> > --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> > +++ linux-2.6.21logfs/fs/logfs/memtree.c	2007-05-07 13:32:12.000000000 +0200
> > @@ -0,0 +1,199 @@
> > +/* In-memory B+Tree. */
> 
> license and a little bit more description

For sure.  This could potentially move to lib/

> > +#include "logfs.h"
> > +
> > +#define BTREE_NODES 16	/* 32bit, 128 byte cacheline */
> > +//#define BTREE_NODES 8	/* 32bit,  64 byte cacheline */
> 
> Please cleanup

Will do.

> > +	if (fill-1 < BTREE_NODES/2) {
> > +		/* XXX */
> 
> 	YYYY perhaps ?

Or maybe even so actual code?

As it is, this is a somewhat generic btree implementation using lazy
removal (or else there must be code here).  I hacked it up just for
learning purposes, but later found it to be useful.  And while I haven't
done any tests, it should significantly beat rbtrees performance-wise.

One of the lose ends I could pick up when the TODO list is melting down.

> > +	}
> > +	if (fill-1 == 0) {
> > +		btree_remove_level(head, val, level+1);
> > +		kfree(node);
> > +		return 0;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> 

Jörn

-- 
Das Aufregende am Schreiben ist es, eine Ordnung zu schaffen, wo
vorher keine existiert hat.
-- Doris Lessing
