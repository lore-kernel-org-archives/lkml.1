Return-Path: <linux-kernel-owner+w=401wt.eu-S966951AbXEHMwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966951AbXEHMwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965908AbXEHMwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:52:22 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45431 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934528AbXEHMwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:52:21 -0400
Date: Tue, 8 May 2007 14:46:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Thomas Gleixner <tglx@linutronix.de>
cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
In-Reply-To: <1178608950.3042.273.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705081439270.17280@yvahk01.tjqt.qr>
References: <20070507215913.GA15054@lazybastard.org>  <20070507220036.GB15054@lazybastard.org>
 <1178608950.3042.273.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
On May 8 2007 09:22, Thomas Gleixner wrote:

>> @@ -0,0 +1,14 @@
>> +obj-$(CONFIG_LOGFS)	+= logfs.o
>> +
>> +logfs-y += compr.o
>> +logfs-y	+= dir.o
>> +logfs-y	+= file.o
>> +logfs-y	+= gc.o
>> +logfs-y	+= inode.o
>> +logfs-y	+= journal.o
>> +logfs-y += memtree.o
>> +logfs-y	+= readwrite.o
>> +logfs-y	+= segment.o
>> +logfs-y	+= super.o
>> +logfs-y += progs/fsck.o
>> +logfs-y += progs/mkfs.o
>
>Please use either tabs or spaces. Preferrably tabs

Or just put it on one line?

	logfs-y += compr.o dir.o file.o gc.o ...


>> +
>> +#define LOGFS_IF_VALID		0x00000001 /* inode exists */
>> +#define LOGFS_IF_EMBEDDED	0x00000002 /* data embedded in block pointers */
>> +#define LOGFS_IF_ZOMBIE		0x00000004 /* inode was already deleted */
>> +#define LOGFS_IF_STILLBORN	0x40000000 /* couldn't write inode in creat() */
>> +#define LOGFS_IF_INVALID	0x80000000 /* inode does not exist */
>
>Are these bit values or enum type ?

Does it make any difference? As long as a bitvalue fits into an 'int',
I don't think so.

>
>> +struct logfs_disk_inode {
>> +	be16	di_mode;
>> +	be16	di_pad;
>> +	be32	di_flags;
>> +	be32	di_uid;
>> +	be32	di_gid;
>> +
>> +	be64	di_ctime;
>> +	be64	di_mtime;
>> +
>> +	be32	di_refcount;
>> +	be32	di_generation;
>> +	be64	di_used_bytes;
>> +
>> +	be64	di_size;
>> +	be64	di_data[LOGFS_EMBEDDED_FIELDS];
>> +}packed;
>> +
>> +
>> +#define LOGFS_MAX_NAMELEN 255
>
>Please put define on top
>
>> +struct logfs_disk_dentry {
>> +	be64	ino;		/* inode pointer */
>> +	be16	namelen;
>> +	u8	type;
>> +	u8	name[LOGFS_MAX_NAMELEN];
>> +}packed;
>> +
>> +
>> +#define OBJ_TOP_JOURNAL	1	/* segment header for master journal */
>> +#define OBJ_JOURNAL	2	/* segment header for journal */
>> +#define OBJ_OSTORE	3	/* segment header for ostore */
>> +#define OBJ_BLOCK	4	/* data block */
>> +#define OBJ_INODE	5	/* inode */
>> +#define OBJ_DENTRY	6	/* dentry */
>
>enum please
>
>> +struct logfs_object_header {
>> +	be32	crc;		/* checksum */
>> +	be16	len;		/* length of object, header not included */
>> +	u8	type;		/* node type */
>> +	u8	compr;		/* compression type */
>> +	be64	ino;		/* inode number */
>> +	be64	pos;		/* file position */
>> +}packed;
>
>For all structs:
>
>Please use kernel doc struct comments.
>
>> +
>> +struct logfs_segment_header {
>> +	be32	crc;		/* checksum */
>> +	be16	len;		/* length of object, header not included */
>> +	u8	type;		/* node type */
>> +	u8	level;		/* GC level */
>> +	be32	segno;		/* segment number */
>> +	be32	ec;		/* erase count */
>> +	be64	gec;		/* global erase count (write time) */
>> +}packed;
>> +
>> +enum {
>> +	COMPR_NONE	= 0,
>> +	COMPR_ZLIB	= 1,
>> +};
>
>Please name the enums and use the same enum for the according fields and
>the function arguments.
>
>> +
>> +/* Journal entries come in groups of 16.  First group contains individual
>> + * entries, next groups contain one entry per level */
>> +enum {
>> +	JEG_BASE	= 0,
>> +	JE_FIRST	= 1,
>> +
>> +	JE_COMMIT	= 1,	/* commits all previous entries */
>> +	JE_ABORT	= 2,	/* aborts all previous entries */
>> +	JE_DYNSB	= 3,
>> +	JE_ANCHOR	= 4,
>> +	JE_ERASECOUNT	= 5,
>> +	JE_SPILLOUT	= 6,
>> +	JE_DELTA	= 7,
>> +	JE_BADSEGMENTS	= 8,
>> +	JE_AREAS	= 9,	/* area description sans wbuf */
>> +	JEG_WBUF	= 0x10,	/* write buffer for segments */
>> +
>> +	JE_LAST		= 0x1f,
>> +};
>
>same here
>
>> +
>> +////////////////////////////////////////////////////////////////////////////////
>> +////////////////////////////////////////////////////////////////////////////////
>
>Eew.
>
>> +
>> +#define LOGFS_SUPER(sb) ((struct logfs_super*)(sb->s_fs_info))
>> +#define LOGFS_INODE(inode) container_of(inode, struct logfs_inode, vfs_inode)
>
>lowercase inlines please
>
>> +
>> +			/*	0	reserved for gc markers */
>> +#define LOGFS_INO_MASTER	1	/* inode file */
>> +#define LOGFS_INO_ROOT		2	/* root directory */
>> +#define LOGFS_INO_ATIME		4	/* atime for all inodes */
>> +#define LOGFS_INO_BAD_BLOCKS	5	/* bad blocks */
>> +#define LOGFS_INO_OBSOLETE	6	/* obsolete block count */
>> +#define LOGFS_INO_ERASE_COUNT	7	/* erase count */
>> +#define LOGFS_RESERVED_INOS	16
>
>enum ?
>
>> +struct logfs_super {
>> +	//struct super_block *s_sb;		/* should get removed... */
>
>Please do so
>
>> +	be64	*s_rblock;
>> +	be64	*s_wblock[LOGFS_MAX_LEVELS];
>
>Please comment the non obvious ones instead of the self explaining
>
>> +	u64	 s_free_bytes;			/* number of free bytes */
>
>
>> +#define journal_for_each(__i) for (__i=0; __i<LOGFS_JOURNAL_SEGS; __i++)
>
>	__i = 0; __i < LOGFS_JOURNAL_SEGS;
>
>> +void logfs_crash_dump(struct super_block *sb);
>> +#define LOGFS_BUG(sb) do {		\
>> +	struct super_block *__sb = sb;	\
>
>Why do we need a local variable here ?
>
>> +	logfs_crash_dump(__sb);		\
>> +	BUG();				\
>> +} while(0)
>
>> +static inline u8 logfs_type(struct inode *inode)
>> +{
>> +	return (inode->i_mode >> 12) & 15;
>
>What's 12 and 15 ? Constants perhaps ?

12 bits, that's "07777" in octal, and means to get rid of the permissions
to get at the filetype. Though I am not sure if & 15 is still needed then.

>> +static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
>> +{
>> +		err = read_dir(dir, &dd, pos);
>> +		if (err == -EOF)
>> +			break;
>
>	-EOF results in a return code 0 ?

Results in a return code -256.

>> +static int logfs_delete_dd(struct inode *dir, struct logfs_disk_dentry *dd,
>> +		loff_t pos)
>> +{
>> +	int err;
>> +
>> +	err = read_dir(dir, dd, pos);
>> +	if (err == -EOF) /* don't expose internal errnos */
>> +		err = -EIO;
>
>Interesting. Why is EOF morphed to EIO ?

..and if that was right, why is not the same thing done above?


Jan
-- 
