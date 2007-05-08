Return-Path: <linux-kernel-owner+w=401wt.eu-S966894AbXEHR6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966894AbXEHR6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966005AbXEHR6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:58:01 -0400
Received: from www.osadl.org ([213.239.205.134]:39833 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965983AbXEHR55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:57:57 -0400
Subject: Re: [PATCH 1/2] LogFS proper
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
In-Reply-To: <20070508163226.GA22443@lazybastard.org>
References: <20070507215913.GA15054@lazybastard.org>
	 <20070507220036.GB15054@lazybastard.org>
	 <1178608950.3042.273.camel@localhost.localdomain>
	 <20070508163226.GA22443@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 08 May 2007 20:00:41 +0200
Message-Id: <1178647242.3042.404.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 18:32 +0200, Jörn Engel wrote:
> > Please sort includes alphabetically and seperate the 
> > #include <linux/mtd/mtd.h> from the #include <linux/...> ones
> 
> Sort: will do.
> Seperation: Any particular reason for that?

Easier to see the different <include/xxx> categories

> > > +typedef __be16 be16;
> > > +typedef __be32 be32;
> > > +typedef __be64 be64;
> > 
> > Why are those typedefs necessary ?
> 
> Not strictly.  I tend to use the be* types fairly often in the code and
> simply grew weary of seeing the underscores.
>
> Any objections if I seperate out the userspace headers and keep the
> shorthands for kernel code only?

I guess not.

> > > +#define packed __attribute__((__packed__))
> > 
> > Please use the __attribute__((__packed__)) on your structs instead of
> > creating some extra "needs lookup" magic.
> 
> Actually I would prefer to understand what that attribute actually does.

It ensures that gcc does not align things accourding to its own idea of
optimized access.

> All structure members should be properly aligned, so having this
> attribute is pure paranoia.  The definition is just there to make my
> eyes tear less.
> 
> Would anything potentially break if I just ripped that out?

It's gcc :)

> > > +#define LOGFS_BLOCK_SECTORS	(8)
> > > +#define LOGFS_BLOCK_BITS	(9)	/* 512 pointers, used for shifts */
> > > +#define LOGFS_BLOCKSIZE		(4096ull)
> > > +#define LOGFS_BLOCK_FACTOR (LOGFS_BLOCKSIZE / sizeof(u64))
> > > +#define LOGFS_BLOCK_MASK (LOGFS_BLOCK_FACTOR-1)
> > 
> > for the whole defines:
> > 
> > Please align them so it does not look like a jigsaw puzzle.
> 
> Will do.
> 
> > Please avoid tail comments as it makes it harder to parse
> 
> My personal impression is just the opposite.  Is there a common
> consensus one way or the other?

It's my personal preference. Tail comments disturb my reading :)

> > 
> > #define I2_INDEX	(I1_INDEX + 1)
> > ....
> 
> I don't see a big advantage.  Any change to these constants will change
> the filesystem format.  Any problem you might be hinting at will pale in
> comparison.  But if you have a stong preference, sure.

No, was more a question

> > > +struct logfs_disk_super {
> > > +	be64	ds_magic;
> > > +	be32	ds_crc;			/* crc32 of everything below */
> > > +	u8	ds_ifile_levels;	/* max level of ifile */
> > > +	u8	ds_iblock_levels;	/* max level of regular files */
> > > +	u8	ds_data_levels;		/* number of segments to leaf blocks */
> > > +	u8	pad0;
> > > +
> > > +	be64	ds_feature_incompat;
> > > +	be64	ds_feature_ro_compat;
> > > +
> > > +	be64	ds_feature_compat;
> > > +	be64	ds_flags;
> > > +
> > > +	be64	ds_filesystem_size;	/* filesystem size in bytes */
> > > +	u8	ds_segment_shift;	/* log2 of segment size */
> > > +	u8	ds_block_shift;		/* log2 if block size */
> > > +	u8	ds_write_shift;		/* log2 of write size */
> > > +	u8	pad1[5];
> > > +
> > > +	/* the segments of the primary journal.  if fewer than 4 segments are
> > > +	 * used, some fields are set to 0 */
> > > +#define LOGFS_JOURNAL_SEGS 4
> > 
> > Please avoid defines inside of structures
> 
> Will move it.
> 
> > > +	be64	ds_journal_seg[LOGFS_JOURNAL_SEGS];
> > > +
> > > +	be64	ds_root_reserve;	/* bytes reserved for root */
> > > +
> > > +	be64	pad2[19];		/* align to 256 bytes */
> > > +}packed;
> > 
> > Please comment the structure with kernel doc comments and avoid the tail
> > comments.
> 
> I'd like to hear your rationale.

Kernel doc comments as:

/**
 * struct hrtimer - the basic hrtimer structure
 * @node:       red black tree node for time ordered insertion
 * @expires:    the absolute expiry time in the hrtimers internal
 *              representation. The time is related to the clock on
 *              which the timer is based.

give you a nice overview with enough space for good explanations and can
be converted to kernel doc as well.

> > > +
> > > +#define LOGFS_MAX_NAMELEN 255
> > 
> > Please put define on top
> 
> On top of what?

of the file, where the other defines are

> > > +struct logfs_disk_dentry {
> > > +	be64	ino;		/* inode pointer */
> > > +	be16	namelen;
> > > +	u8	type;
> > > +	u8	name[LOGFS_MAX_NAMELEN];
> > > +}packed;
> > > +
> > > +
> > > +#define OBJ_TOP_JOURNAL	1	/* segment header for master journal */
> > > +#define OBJ_JOURNAL	2	/* segment header for journal */
> > > +#define OBJ_OSTORE	3	/* segment header for ostore */
> > > +#define OBJ_BLOCK	4	/* data block */
> > > +#define OBJ_INODE	5	/* inode */
> > > +#define OBJ_DENTRY	6	/* dentry */
> > 
> > enum please
> 
> I don't care much one way or another.  Do enums have a significant
> advantage?

yes, type checking

> > > +
> > > +struct logfs_segment_header {
> > > +	be32	crc;		/* checksum */
> > > +	be16	len;		/* length of object, header not included */
> > > +	u8	type;		/* node type */
> > > +	u8	level;		/* GC level */
> > > +	be32	segno;		/* segment number */
> > > +	be32	ec;		/* erase count */
> > > +	be64	gec;		/* global erase count (write time) */
> > > +}packed;
> > > +
> > > +enum {
> > > +	COMPR_NONE	= 0,
> > > +	COMPR_ZLIB	= 1,
> > > +};
> > 
> > Please name the enums and use the same enum for the according fields and
> > the function arguments.
> 
> Does sparse check on that?  That would be quite useful and stop my
> ambivalence.

also the compiler complains

> > > +
> > > +/* Journal entries come in groups of 16.  First group contains individual
> > > + * entries, next groups contain one entry per level */
> > > +enum {
> > > +	JEG_BASE	= 0,
> > > +	JE_FIRST	= 1,
> > > +
> > > +	JE_COMMIT	= 1,	/* commits all previous entries */
> > > +	JE_ABORT	= 2,	/* aborts all previous entries */
> > > +	JE_DYNSB	= 3,
> > > +	JE_ANCHOR	= 4,
> > > +	JE_ERASECOUNT	= 5,
> > > +	JE_SPILLOUT	= 6,
> > > +	JE_DELTA	= 7,
> > > +	JE_BADSEGMENTS	= 8,
> > > +	JE_AREAS	= 9,	/* area description sans wbuf */
> > > +	JEG_WBUF	= 0x10,	/* write buffer for segments */
> > > +
> > > +	JE_LAST		= 0x1f,
> > > +};
> > 
> > same here
> 
> Not sure.  Those constants are actually in groups of 16, so they are a
> weird mixture of bitfields and enums.  There is code roughly along these
> lines:
> 
> 	switch (i >> 4) {
> 	case 0:
> 		switch (i & 0xf) {
> 		case JE_COMMIT:
> 		case JE_ABORT:
> 		...
> 	case 1:
> 	...
> 
> I'll have to check whether enums support this.

Hmm, ok. But this needs some comment then

> > > +
> > > +////////////////////////////////////////////////////////////////////////////////
> > > +////////////////////////////////////////////////////////////////////////////////
> > 
> > Eew.
> 
> Anything on top should get moved to include/logfs.h.  Anything below
> should stay here.  And now might be an excellent time to do just that.

yup

> > > +
> > > +#define LOGFS_SUPER(sb) ((struct logfs_super*)(sb->s_fs_info))
> > > +#define LOGFS_INODE(inode) container_of(inode, struct logfs_inode, vfs_inode)
> > 
> > lowercase inlines please
> 
> #define JFFS2_INODE_INFO(i) (list_entry(i, struct jffs2_inode_info, vfs_inode))
> #define OFNI_EDONI_2SFFJ(f)  (&(f)->vfs_inode)
> #define JFFS2_SB_INFO(sb) (sb->s_fs_info)
> #define OFNI_BS_2SFFJ(c)  ((struct super_block *)c->os_priv)
> 
> static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
> {
> 	return sb->s_fs_info;
> }
> 
> I can see the point for an inline function.  But lowercase would change
> a style that appears to be common in Linux filesystems.  

Well, we have uppercase MACROs and lower case function names.

> Will you send the janitorial patches for existing code?

:)

> Speaking of janitorials, I noticed that removing the equivalent of
> OFNI_EDONI_2SFFJ(f) and OFNI_BS_2SFFJ(c) made LogFS look much nicer.

:)

> > > +
> > > +			/*	0	reserved for gc markers */
> > > +#define LOGFS_INO_MASTER	1	/* inode file */
> > > +#define LOGFS_INO_ROOT		2	/* root directory */
> > > +#define LOGFS_INO_ATIME		4	/* atime for all inodes */
> > > +#define LOGFS_INO_BAD_BLOCKS	5	/* bad blocks */
> > > +#define LOGFS_INO_OBSOLETE	6	/* obsolete block count */
> > > +#define LOGFS_INO_ERASE_COUNT	7	/* erase count */
> > > +#define LOGFS_RESERVED_INOS	16
> > 
> > enum ?
> 
> Istr enums having severe problems for anything larger than int.  LogFS
> inodes are 64bit.  Hmm.  And how do enums behave wrt. cpu_to_beXX and
> sparse?

Hmm, good question.

> > Please comment the non obvious ones instead of the self explaining
> 
> At some time I started commenting all new ones.  Are there any other
> non-obvious ones remaining?

Just comment the structs as I pointed out above

> > > +	u64	 s_free_bytes;			/* number of free bytes */
> > 
> > 
> > > +#define journal_for_each(__i) for (__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)
> > 
> > 	__i = 0; __i < LOGFS_JOURNAL_SEGS;
> 
> Will that make the code look better or just slavishly follow indentation
> guidelines?  Adding spaces where you suggested weakens the grouping of
> the three for(;;) parameters, imo.
> 
	(__i = 0; __i < LOGFS_JOURNAL_SEGS; __i++)

	is way simpler to parse than

	(__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)

> > +void logfs_crash_dump(struct super_block *sb);
> > > +#define LOGFS_BUG(sb) do {		\
> > > +	struct super_block *__sb = sb;	\
> > 
> > Why do we need a local variable here ?
> 
> Trying to add type safety.  It cannot be an inline function if without
> making the file/line information useless.

#define LOGFS_BUG(sb) logfs_bug(sb, __FUNCTION__, __LINE__)

Also the BUG itself will give you enough clue where it happened, so
having the function/line info is not really necessary

> > > +static inline u8 logfs_type(struct inode *inode)
> > > +{
> > > +	return (inode->i_mode >> 12) & 15;
> > 
> > What's 12 and 15 ? Constants perhaps ?
> 
> There should be a generic function doing just the same.  At least this
> is better than the open-coded variants elsewhere:
> 
> fs/jffs2/dir.c: type = (old_dentry->d_inode->i_mode & S_IFMT) >> 12;
> fs/jffs2/dir.c: type = (old_dentry->d_inode->i_mode & S_IFMT) >> 12;
> fs/libfs.c:     return (inode->i_mode >> 12) & 15;
> fs/nfs/dir.c:   return (inode->i_mode >> 12) & 15;
> fs/proc/base.c:         type = inode->i_mode >> 12;
> 
> Maybe the libfs version could get moved to a header somewhere.

Yes please

> > > +int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen);
> > > +int logfs_compress(void *in, void *out, size_t inlen, size_t outlen);
> > > +int logfs_compress_vec(struct kvec *vec, int count, void *out, size_t outlen);
> > > +int logfs_uncompress(void *in, void *out, size_t inlen, size_t outlen);
> > > +int logfs_uncompress_vec(void *in, size_t inlen, struct kvec *vec, int count);
> > 
> > are those global ? If yes, please add extern, else remove
> 
> What purpose does "extern" have?  To my understanding it makes zero
> difference.  About half the headers use it, the other half doesn't.

and yours uses it in one place and not in the other.

extern is an empty macro, but it makes it clear that this is a global
function declaration

> > 
> > > +
> > > +static inline u64 dev_ofs(struct super_block *sb, u32 segno, u32 ofs)
> > > +{
> > > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > 
> > Seperate variables and code by an empty line please
> 
> In general: sure.  But for 1-2 line functions the empty lines seem to
> hurt more than they help.

No, it's about pattern recognition. Consistent patterns allow faster
parsing.

> As much as I agree with the kernel coding style, I have never liked to
> slavishly follow any written doctrine.  The overall goal should be easy
> to read.  If "easy to read" would match the wording 100%, someone should
> adjust the Lindent parameters and run the whole kernel through.
> 
> > > +	LOGFS_BUG_ON(err, sb);
> > 
> > Please open code this instead of nesting mtdread into device_read and
> > therefor avoid the error handling pathes in those places where
> > device_read is used.
> 
> Open code the LOGFS_BUG_ON()?  What purpose would that serve?

No, open code device_read and add the error path at the place where
device_read is used and put a bug in the error path for now.

> > > +
> > > +typedef int (*dir_callback)(struct inode *dir, struct dentry *dentry,
> > > +		struct logfs_disk_dentry *dd, loff_t pos);
> > 
> > Why is this in the middle of something else ?
> 
> History.  It used to be right above logfs_dir_walk().  I assume you want
> this moved to the top?

yup

> > > +
> > > +static s64 dir_seek_data(struct inode *inode, s64 pos)
> > > +{
> > > +	s64 new_pos = logfs_seek_data(inode, pos);
> > 
> > new line please
> > 
> > > +	return max((s64)pos, new_pos - 1);
> > 
> > 	max_t please 
> 
> That would remove all type checking, wouldn't it?

max_t enforces type checking 

> And looking at it again, the code has changed and the cast become
> useless.  Let's kill it.
> 
> > > +static int __logfs_dir_walk(struct inode *dir, struct dentry *dentry,
> > > +		dir_callback handler, struct logfs_disk_dentry *dd, loff_t *pos)
> > > +{
> > > +	struct qstr *name = dentry ? &dentry->d_name : NULL;
> > > +	int ret;
> > > +
> > > +	for (; ; (*pos)++) {
> > > +		ret = read_dir(dir, dd, *pos);
> > > +		if (ret == -EOF)
> > > +			return 0;
> > > +		if (ret == -ENODATA) {/* deleted dentry */
> > 
> > Please move the comment away. It makes parsing hard
> 
> ENOPARSE
> 
> Do you want an extra space or tab?

No, please remove the tail comment after the {

> 
> > > +			*pos = dir_seek_data(dir, *pos);
> > > +			continue;
> > > +		}
> > > +		if (ret)
> > > +			return ret;
> > > +		BUG_ON(dd->namelen == 0);
> > > +
> > > +		if (name) {
> > > +			if (name->len != be16_to_cpu(dd->namelen))
> > > +				continue;
> > > +			if (memcmp(name->name, dd->name, name->len))
> > > +				continue;
> > > +		}
> > > +
> > > +		return handler(dir, dentry, dd, *pos);
> > > +	}
> > > +	return ret;
> > 
> > 	Where do you break out of the loop ?
> 
> I don't.  But if I remove the return statement the compiler will barf.
> Add a comment?

Please

> > > +/* FIXME: readdir currently has it's own dir_walk code.  I don't see a good
> > > + * way to combine the two copies */
> > > +#define IMPLICIT_NODES 2
> > > +static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
> > > +{
> > > +	struct logfs_disk_dentry dd;
> > > +	loff_t pos = file->f_pos - IMPLICIT_NODES;
> > > +	int err;
> > > +
> > > +	BUG_ON(pos<0);
> > > +	for (;; pos++) {
> > > +		struct inode *dir = file->f_dentry->d_inode;
> > 
> > new line please
> 
> I'll move the variable definition up instead.
> 
> > > +		err = read_dir(dir, &dd, pos);
> > > +		if (err == -EOF)
> > > +			break;
> > 
> > 	-EOF results in a return code 0 ?
> 
> 	The readdir() function returns a pointer to a dirent structure, or NULL
> 	if an error occurs or end-of-file is reached.  On error, errno  is  set
> 	appropriately.
> 
> Seems to match what the manpage sais and other kernel code does.  Apart
> from that, see the comment to the EOF definition.

Ok

> What is the rationale here?

Pattern recognition

> > > +	if (dest) /* symlink */
> > > +		ret = logfs_inode_write(inode, dest, destlen, 0);
> > > +	else /* creat/mkdir/mknod */
> > > +		ret = __logfs_write_inode(inode);
> > 
> > 
> > Please remove this confusing tail comments
> 
> ?!?
> Imo they explain what is going on in either of those cases.  Do you
> consider that to be self-explanatory?

if you think you need comments, then please use new lines, i.e:

	if (dest) {
		 /* symlink */
		ret = logfs_inode_write(inode, dest, destlen, 0);
	} else {
		/* creat/mkdir/mknod */
		ret = __logfs_write_inode(inode);
	}

> > > +static struct inode_operations ext2_symlink_iops = {
> > > +	.readlink	= generic_readlink,
> > > +	.follow_link	= page_follow_link_light,
> > > +};
> > 
> > s/ext2/logfs/ maybe ?
> 
> What was I thinking?  Or rather, was I thinking at all?

/me refrains from answering this question

> > > +static int logfs_delete_dd(struct inode *dir, struct logfs_disk_dentry *dd,
> > > +		loff_t pos)
> > > +{
> > > +	int err;
> > > +
> > > +	err = read_dir(dir, dd, pos);
> > > +	if (err == -EOF) /* don't expose internal errnos */
> > > +		err = -EIO;
> > 
> > Interesting. Why is EOF morphed to EIO ?
> 
> Because deleting something beyond EOF is indeed an error.  Although in
> two cases, this should be a BUG() instead, if anything at all.
> 
> Journal replay is special.  Garbage and/or malicious data on the medium
> cause this error.  The journal CRCs should protect us against garbage,
> which leaves only the prepared filesystem image to worry about.
> 
> I guess I'll just BUG in any case.

At least provide a comment for the ignorami.

> > > +static int logfs_rename(struct inode *old_dir, struct dentry *old_dentry,
> > > +		struct inode *new_dir, struct dentry *new_dentry)
> > > +{
> > > +	if (new_dentry->d_inode) /* target exists */
> > > +		return logfs_rename_target(old_dir, old_dentry, new_dir, new_dentry);
> > > +	else if (old_dir == new_dir) /* local rename */
> > > +		return logfs_rename_local(old_dir, old_dentry, new_dentry);
> > 
> > Comment style
> 
> So what should this code look like?

See above

> > > +	return logfs_rename_cross(old_dir, old_dentry, new_dir, new_dentry);
> > > +}
> > > +
> > > --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> > > +++ linux-2.6.21logfs/fs/logfs/file.c	2007-05-07 13:32:12.000000000 +0200
> > > @@ -0,0 +1,82 @@
> > 
> > Comment missing. License missing.
> 
> License should be obvious for any kernel code.  I can add "GPLv2" but
> please don't expect me to spam every file with the full preamble.

That's enough

> Copyright lines might be useful.  A short explanation of what the file
> does even more so.  Anything else?

That's fine

> > > +#include "logfs.h"
> > > +
> > > +
> > > +static int logfs_prepare_write(struct file *file, struct page *page,
> > > +		unsigned start, unsigned end)
> > > +{
> > > +	if (PageUptodate(page))
> > > +		return 0;
> > > +
> > > +	if ((start == 0) && (end == PAGE_CACHE_SIZE))
> > > +		return 0;
> > 
> > 	Self explaining logic ?
> 
> Boilerplate code that every filesystem uses.

I know, I have seen it elsewhere. It still does not make much sense.

> > > +static int logfs_readpage(struct file *file, struct page *page)
> > > +{
> > > +	int ret = logfs_readpage_nolock(page);
> > 
> > empty line
> 
> Three lines, you win again.

Wrong, you lose always independently of the number of lines :)

> > > +#if 0
> > 
> > Can you please remove this ?
> 
> Nope.  That code will get used in the future.

So why don't you add it when it you start to use it ?

> > Interestingly enough this unused function is better commented than
> > anything else in this patch.
> 
> With the exception of dir.c.  In both cases I was documenting the
> algorithm used, which is far from obvious.  Most other things are fairly
> straightforward for people used to existing filesystems.

Hmm. Comments are of general use and it's way easier to understand code
when it has comments to functions and tricks used in the code. You don't
write code for people used to existing filesystems. You write code which
is understandable and allows debugging without twisting the brain for
non filesystem wizzards who use it and trap into the occasional problem

> > > +	sh = (void*)&h;
> > 
> > Please use proper type casting !
> 
> How would that improve the code?  (void*) clearly states that "I don't
> care what the base type it, just cast this thing to the new pointer
> type."  (struct logfs_segment_header*) would state the same but be less
> concise.

Hell no. It documents that you actually want to do this IMHO.

> And on the tail comments.  Your problem with them really puzzles me.

Simply because they force me to figure out where the heck code ends.
It's way easier to parse the comment on top of some statement while you
read through.

> > > +#include "logfs.h"
> > > +#include <linux/backing-dev.h>
> > > +#include <linux/writeback.h> /* for inode_lock */
> > 
> > Please remove the stupid comment
> 
> Or rather replace it with something longer.  In principle, filesystems
> shouldn't have to muck with <linux/writeback.h> at all.  Sadly I have to
> in order to solve another deadlock race, similar to the one fixed with
> the I_SYNC patch.
> 
> > > +	/* This is a blatant copy of alloc_inode code.  We'd need alloc_inode
> > > +	 * to be nonstatic, alas. */
> > > +	{
> > > +		static const struct address_space_operations empty_aops;
> > > +		struct address_space * const mapping = &inode->i_data;
> > 
> > Please remove the brackets and move the variables to the top of the
> > fucntion
> 
> Erm?  Did you read the comment?  I have copied the code from
> alloc_inode() without changes.  That is bad enough as it is.  If I were
> to change the code format, chances of detecting changes in one function
> not followed in the other would increase even more.

I read the comment, but it did not make any sense versus the brackets.

> I'm sure this particular gem can use some discussion, as long as it's
> not limited to formatting issues.

well, both.

> > > +	case S_IFCHR: /* fall through */
> > 
> > Sigh. Could you please add useful comments ?
> 
> These _are_ useful.  You can grep the kernel and will find plenty of
> existing code using them.  One of the reasons is that it allows code
> checkers to distinguish fall-through cases that the programmer did
> (claim to) think about from others.
>
> Using such a code checker I have found several bugs in the kernel and
> another one in my own code.  My own code used to be correct, but Frank
> didn't notice the fall-though and rearranged it, introducing the bug.
> So the comment seems to help humans as well.

Fair enough

> > > +
> > > +	if ( !(li->li_flags&LOGFS_IF_VALID) || (li->li_flags&LOGFS_IF_INVALID))
> > > +		return -EIO;
> > 
> > 	Is this really an IO error ?
> 
> According to some, almost everything is.  Do you have a better
> suggestion for corrupt data?

No, I just tried to understand it.

> > > +		level = i & 0xf;
> > 
> > what is 0xf ?
> > 
> > > +		area = super->s_area[level];
> > > +		switch (i & ~0xf) {
> > > +		case JEG_BASE:
> > > +			switch (i) {
> > 
> > Represents I an enum or a bitfield or both ?
> 
> Both.  High nibble groups the journal entries.  High nibble 0 are the
> normal journal entries.  High nibble 1 are the summaries for all levels.
> 
> "Levels" is something I should document, seeing that most people haven't
> watched my LCA presentation.

I know roughly how it works. It just is not obvious and really needs
some comments.

> > > +static void journal_get_free_segment(struct logfs_area *area)
> > > +{
> > > +	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
> > > +	int i;
> > > +
> > > +	journal_for_each(i) {
> > > +		if (area->a_segno != super->s_journal_seg[i])
> > > +			continue;
> > > +empty_seg:
> > > +		i++;
> > > +		if (i == LOGFS_JOURNAL_SEGS)
> > > +			i = 0;
> > > +		if (!super->s_journal_seg[i])
> > > +			goto empty_seg;
> > 
> > 
> > Does this loop for ever or is there a guranteed exit ?
> > Please use a do while loop instead of the goto
> 
> There is a guaranteed exit.  mkfs can specify up to four segments (read
> erase blocks) for the journal to live in.  Two are the required minimum.
> In order to specify just two segments, the array will be initialized
> like {1, 2, 0, 0}.
>
> This code shall find the current segment from that array, then pick the
> next one and skip over any entries that are zero.

I thought that, but it needs a comment as well

> Will use do..while.
> 
> > > +static s64 logfs_get_free_entry(struct super_block *sb)
> > > +{
> > > +	s64 ret;
> > > +
> > > +	mutex_lock(&LOGFS_SUPER(sb)->s_log_mutex);
> > > +	ret = __logfs_get_free_entry(sb);
> > > +	mutex_unlock(&LOGFS_SUPER(sb)->s_log_mutex);
> > > +	BUG_ON(ret <= 0); /* not sure, but it's safer to BUG than to accept */
> > 
> > It might be safer to do proper error handling.
> 
> Send me a testcase. :)

Use nand error injection :)

> As above, I prefer explicitly stating "this has never happened, I have
> no clue what should be done" over some half-assed "I hope this works,
> even though noone ever tested it".
> 
> Both are lame, one just happens to be slightly less wicked and a lot
> more honest.

Well, at least it would be good to return the problem back to the place,
where it actually would do damage and BUG there, so it is more obvious
where you need to work on error handling. Bugs in the middle of nowhere
are not really helpful

> > > +	ret = mtdwrite(sb, ofs, sb->s_blocksize, block);
> > > +	if (ret)
> > > +		return ret;
> > > +	return 0;
> > 
> > 	Interesting way to reyl on compiler smartness
> 
> Que?

	if (ret)
		return ret;
	return 0;

might be optimized by a smart compiler to

	return ret;

but you should do it yourself, as gcc is not always smart

> > > + */
> > > +#include "logfs.h"
> > > +
> > > +
> > > +static int logfs_read_empty(void *buf, int read_zero)
> > > +{
> > > +	if (!read_zero)
> > > +		return -ENODATA;
> > > +
> > > +	memset(buf, 0, PAGE_CACHE_SIZE);
> > 
> > 	Is buf guaranteed to be at least sizeof(PAGE_CACHE_SIZE) ?
> 
> It is guaranteed to be exactly PAGE_CACHE_SIZE.  And if PAGE_CACHE_SIZE
> is not guaranteed to be 4KiB, I am guaranteed to receive a bug report.
> 
> Testing for endianness was fairly simple by having a big-endian format.
> Testing for PAGE_CACHE_SIZE would require an actual itanic or similar
> system.  So I willfully screwed ~1% of my potential users in exchange
> for "will fix later" scribbled on a used envelope.

Ok

> > > +	for (i=count; i>=0; i--) {
> > 
> > 	....
> > 
> > > +		ret = logfs_segment_read(inode->i_sb, rblock, bofs);
> > > +		if (ret)
> > > +			goto fail;
> > 
> > 	please use break and do a return !ret;
> 
> Not much nicer if you ask me.  How about if I split the function and
> have the inner one return directly without having to worry
> aboutlogfs_put_rblock()?

Yup.

> > > +#if 0
> > > +	/* Any data belonging to dirty inodes must be considered valid until
> > > +	 * the inode is written back.  If we prematurely deleted old blocks
> > > +	 * and crashed before the inode is written, the filesystem goes boom.
> > > +	 */
> > > +	if (inode->i_state & I_DIRTY)
> > > +		ret = 2;
> > > +	else
> > 
> > There seems to be a patternm, that unused code is surprisingly well
> > commented.
> 
> This is the "will eat your data" bug mentioned in the initial mail.  I
> simply haven't replaced the comment with working code yet.
> 
> Any comments to used code you would like to see?  Your pattern appears
> to be "remove comment". :)

No, "move comment away from the tail" :)

Comments to functions and tricky non obvious code would be really
appreciated.

> > > +	if (*ppos >= size)
> > > +		return 0;
> > > +	if (count > size - *ppos)
> > > +		count = size - *ppos;
> > > +
> > > +	BUG_ON(logfs_index(*ppos) != logfs_index(*ppos + count - 1));
> > > +
> > > +	block_data = kzalloc(LOGFS_BLOCKSIZE, GFP_KERNEL);
> > > +	if (!block_data)
> > > +		goto fail;
> > > +
> > > +	err = logfs_read_block(inode, logfs_index(*ppos), block_data,
> > > +			read_zero);
> > > +	if (err)
> > > +		goto fail;
> > > +
> > > +	memcpy(buf, block_data + (*ppos % LOGFS_BLOCKSIZE), count);
> > > +	*ppos += count;
> > > +	kfree(block_data);
> > > +	return count;
> > 
> > 	err = count; and fall trough ?
> 
> Then I would change *ppos.

err ?

> +     if (err)
> +             goto fail;
> +
> +     memcpy(buf, block_data + (*ppos % LOGFS_BLOCKSIZE), count);
> +     *ppos += count;
> +     err = count;
> +
> +fail:
> +     kfree(block_data);
> +     return err;

> > > +	pr_debug("write to %lld, count %zd\n", *ppos, count);
> > 
> > 	Please add some hint, where this comes from
> 
> Where what comes from?  The pr_debug will go, I haven't used it for
> ages, so it clearly is pointless.

	pr_debug("LOGFS ......\n");

> > > +	kfree(block_data);
> > > +	return count;
> > 
> > 	err = count; fall trhough ?
> 
> *ppos again.

Same as above :)

> > > +	ret = ret==n ? 0 : -EIO;
> > 
> > 	return ret == n ? ..... perhaps ?
> 
> Again I consider the lack of spaces to give better grouping.  It is
> similar to brackets.  In general they help, but then there is Lisp...

dickhead :)

> What is your opinion on that code pattern anyway.  Unless something
> dramatically changed in the last few month, mtd->erase() is a synchonous
> operation with an asynchronous interface.  Does it still make sense to
> hope for our first asynchronous driver ever or is this a target for some
> code removal?

Probably. Would make a nice cleanup.

> > > +int mtderase(struct super_block *sb, loff_t ofs, size_t len)
> > > +{
> > > +	struct mtd_info *mtd = LOGFS_SUPER(sb)->s_mtd;
> > > +	struct inode *inode = LOGFS_SUPER(sb)->s_dev_inode;
> > > +	struct erase_info ei;
> > > +	int ret;
> > > +
> > > +	BUG_ON(len % mtd->erasesize);
> > > +
> > > +	truncate_inode_pages_range(&inode->i_data, ofs, ofs+len-1);
> > > +	if (mtd->block_isbad(mtd, ofs))
> > > +		return -EIO;
> > 
> > this actually leads to a double check of block_isbad for blocks which
> > are not bad. 
> 
> Does it?  Where is the second check happening?

	in mtd->erase()

> > > +static u32 logfs_free_bytes(struct super_block *sb, u32 segno)
> > > +{
> > 
> > > +static void logfsck_blocks(struct super_block *sb)
> > > +{
> > > +	struct logfs_super *super = LOGFS_SUPER(sb);
> > > +	int i;
> > > +	int free;
> > > +
> > > +	for (i=0; i<super->s_no_segs; i++) {
> > > +		free = logfs_free_bytes(sb, i);
> > > +		free_bytes += free;
> > > +		printk(" %3x", free);
> > > +		if (i % 8 == 7)
> > > +			printk(" : ");
> > > +		if (i % 16 == 15)
> > > +			printk("\n");
> > > +	}
> > > +	printk("\n");
> > 
> > printk with loglevels and identifiable origin please
> 
> No.  This one will print a little statistic about segment usage.
> Something like:
> 
> 0 0 0 0 20000 12345 01234 ...
> 
> It is useful as-is for fsck purposes, except that the lines wrap since I
> count bytes instead of blocks now.  "blocks" is a strange concept once
> they get compressed.

Still something like:

LOGFS 0 0 0 0 20000 12345 01234 ...
LOGFS 0 0 0 0 20000 12345 01234 ...

makes it easier to find in the logs

> > > +		err = read_one_dd(dir, pos, &ino, &type);
> > > +		//yield();
> > 
> > 	great. cond_resched() if you really need to
> 
> Not anymore, this can go.  But since we are on the subject, what is the
> difference between yield() and cond_resched()?  Those two functions
> could also use slightly better comments.

cond_resched() calls schedule, when the need_resched flag of the task is
set. yield() goes through schedule always and should not be used in the
kernel.

> > > 
> Humm.  So far those functions are unused.  And I'm starting to doubt
> their usefulness.  The commented-out code should be pure paranoia, but
> that hardly matters now, does it.

In a review it matters, as it raises questions, doesn't it.

> > > +static void ostore_get_free_segment(struct logfs_area *area)
> > > +{
> > > +	struct logfs_super *super = LOGFS_SUPER(area->a_sb);
> > > +	struct logfs_segment *seg;
> > > +
> > > +	BUG_ON(list_empty(&super->s_free_list));
> > > +
> > > +	seg = list_entry(super->s_free_list.prev, struct logfs_segment, list);
> > > +	list_del(&seg->list);
> > > +	area->a_segno = seg->segno;
> > > +	kfree(seg);
> > > +	super->s_free_count -= 1;
> > 
> > get_free_segment actually kfree's a segment ? Please use a less
> > misleading function name
> 
> It actually gets a free segment.  It also kfree's an object that happens
> to be called logfs_segment.  Both names make sense on their own.  The
> combination... can be confusing.
> 
> I'm not exactly sure what to do here.

At least add a comment !

> > > +++ linux-2.6.21logfs/fs/logfs/memtree.c	2007-05-07 13:32:12.000000000 +0200
> > > @@ -0,0 +1,199 @@
> > > +/* In-memory B+Tree. */
> > 
> > license and a little bit more description
> 
> For sure.  This could potentially move to lib/

yup

> > > +	if (fill-1 < BTREE_NODES/2) {
> > > +		/* XXX */
> > 
> > 	YYYY perhaps ?
> 
> Or maybe even so actual code?

Might be even better.

> As it is, this is a somewhat generic btree implementation using lazy
> removal (or else there must be code here).  I hacked it up just for
> learning purposes, but later found it to be useful.  And while I haven't
> done any tests, it should significantly beat rbtrees performance-wise.

Put this explanation into the comment with a FIXME. Is far better than
"XXX" :)

	tglx


