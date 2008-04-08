Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYDHJkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYDHJkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYDHJj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:39:57 -0400
Received: from lazybastard.de ([212.112.238.170]:34114 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbYDHJjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:39:54 -0400
Date: Tue, 8 Apr 2008 11:39:46 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch 2/15] fs/logfs/logfs_abi.h
Message-ID: <20080408093946.GA31266@logfs.org>
References: <20080401181308.512473173@logfs.org> <20080401181332.853833002@logfs.org> <200804080224.18014.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804080224.18014.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 April 2008 02:24:17 +0200, Arnd Bergmann wrote:
> 
> Great to see a new version finally posted again!

As Artem already noted, the transition to write-back caching was a
significant change and initially caused a huge drop in quality.  Took a
while.

> On Tuesday 01 April 2008, joern@logfs.org wrote:
> > --- /dev/null	2008-04-02 16:29:12.813336657 +0200
> > +++ linux-2.6.24logfs/fs/logfs/logfs_abi.h	2008-04-01 21:02:34.980239877 +0200
> > @@ -0,0 +1,523 @@
> > +/*
> > + * fs/logfs/logfs.h
> 
> The comment doesn't match the file name, and the file name doesn't
> match the purpose -- you are not defining an "application" binary
> interface but rather the medium format, with the small exception
> of the chattr flags.

Now it matches the file name.  If you have a better name than "abi",
I'll use that.

> > +#ifndef fs_logfs_logfs_abi_h
> > +#define fs_logfs_logfs_abi_h
> 
> Everyone else uses capital letters for these.

Changed.

> > +/*
> > + * LOGFS_HEADERSIZE is the size of a single header in the object store,
> > + * LOGFS_MAX_OBJECTSIZE the size of the largest possible object, including
> > + * its header,
> > + * LOGFS_SEGMENT_RESERVE is the amount of space reserved for each segment for
> > + * its segment header and the padded space at the end when no further objects
> > + * fit.
> > + */
> > +#define LOGFS_HEADERSIZE	(0x1c)
> > +#define LOGFS_SEGMENT_HEADERSIZE (0x18)
> > +#define LOGFS_MAX_OBJECTSIZE	(LOGFS_HEADERSIZE + LOGFS_BLOCKSIZE)
> > +#define LOGFS_SEGMENT_RESERVE	(LOGFS_HEADERSIZE + LOGFS_MAX_OBJECTSIZE - 1)
> 
> The comment makes it sound like the last line should be
> 
> #define LOGFS_SEGMENT_RESERVE (LOGFS_SEGMENT_HEADERSIZE + LOGFS_MAX_OBJECTSIZE - 1)

Correct.  Changed.

> > +/**
> > + * struct logfs_disk_dentry - on-medium dentry structure
> > + *
> > + * @ino:			inode number
> > + * @namelen:			length of file name
> > + * @type:			file type, identical to bits 12..15 of mode
> > + * @name:			file name
> > + */
> > +struct logfs_disk_dentry {
> > +	__be64	ino;
> > +	__be16	namelen;
> > +	__u8	type;
> > +	__u8	name[LOGFS_MAX_NAMELEN];
> > +} __attribute__((packed));
> 
> With LOGFS_MAX_NAMELEN == 255, this data structure is not aligned to 64
> bits, which means that accessing the inode number requires unaligned
> memory accesses when you have an array of logfs_disk_dentry structures
> on the medium. Is that intentional?
> 
> If you add another 32 bits here, you don't need the __packed any more.

6 bytes, actually.  Not a bad idea.  I just have to make sure they are
properly zeroed and don't cause an information leak.

> > +/**
> > + * struct logfs_object_header - per-object header in the ostore
> > + *
> > + * @crc:			crc32 of header, excluding data_crc
> > + * @len:			length of data
> > + * @type:			object type, see above
> > + * @compr:			compression type
> > + * @ino:			inode number
> > + * @bix:			block index
> > + * @data_crc:			crc32 of payload
> > + */
> > +struct logfs_object_header {
> > +	__be32	crc;
> > +	__be16	len;
> > +	__u8	type;
> > +	__u8	compr;
> > +	__be64	ino;
> > +	__be64	bix;
> > +	__be32	data_crc;
> > +} __attribute__((packed));
> 
> Similarly, this structure contains 8 byte members but has a smaller
> size.

I really don't want to enlarge the structure.  Every single block gets
one of them, so they cause a significant overhead.  Adding padding for
the in-memory structure and not copying it to/from the medium would make
sense, but that's not a trivial change.  Needs more thought.

For the record, I removed the __packed on all other structures and
replaced it with something like this:

#define SIZE_CHECK(type, size)					\
static inline void check_##type(void)				\
{								\
	BUILD_BUG_ON(sizeof(struct type) != (size));		\
}

...

struct logfs_journal_header {
	__be32	h_crc;
	__be16	h_len;
	__be16	h_datalen;
	__be16	h_type;
	__be16	h_version;
	__u8	h_compr;
	__u8	h_pad[3];
};

SIZE_CHECK(logfs_journal_header, 16);

Jörn

-- 
Do not stop an army on its way home.
-- Sun Tzu
