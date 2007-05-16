Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbXEPMal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbXEPMal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759304AbXEPMac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:30:32 -0400
Received: from lazybastard.de ([212.112.238.170]:40209 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbXEPMab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:30:31 -0400
Date: Wed, 16 May 2007 14:26:06 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516122603.GE5472@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <Pine.LNX.4.64.0705161319060.5152@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0705161319060.5152@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 13:21:11 +0300, Pekka J Enberg wrote:
> 
> > +#define LOGFS_BUG(sb) do {           \
> > +     struct super_block *__sb = sb;  \
> > +     logfs_crash_dump(__sb);         \
> > +     BUG();                          \
> > +} while(0)
> 
> Note that BUG() can be a no-op so dumping something on disk might not make 
> sense there. This seems useful, but you probably need to make this bit 
> more generic so that using BUG() proper in your filesystem code does the 
> right thing. Inventing your own wrapper should be avoided.

Hmm.  I am not sure how this could be generic and still make sense.

LogFS has some unused write-once space in the superblock segment.
Embedded people always have problems debugging and were suggesting using
this to store debug information.  That allows me to ask for a filesystem
image and get both the offending image plus a crash dump.  It also
allows me to abort mounting if I ever see an existing crash dump (not
implemented yet).  "First failure data capture" was an old IBM slogal
and the "first" really makes a difference.

So how should I deal with BUG() as a no-op?  I _think_ it should not
make a difference.  People choosing that option should know that their
kernels will continue running with errors and can potentially do any
kind of damage.  My wrapper doesn't seem to change that one way or
another.

What I _should_ do is make the filesystem read-only after this point.
That would actually be quite simple.  Onto my list.

> > +static inline struct logfs_super *LOGFS_SUPER(struct super_block *sb)
> > +{
> > +     return sb->s_fs_info;
> > +}
> > +
> > +static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
> > +{
> > +     return container_of(inode, struct logfs_inode, vfs_inode);
> > +}
> 
> No need for upper case in function names.

Will change.

> > +int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen)
> > +{
> > +     if (outlen < inlen)
> > +             return -EIO;
> > +     memcpy(out, in, inlen);
> > +     return inlen;
> > +}
> 
> Please drop this wrapper function. It's better to open-code the error
> handling in the callers (there are total of three of them).

Is it?  The advantage of having the wrapper is that the compression case
and the non-compressed case look identical and the code just repeats the
same pattern twice.

I'll try to open-code it and see how it looks.

> > +/* FIXME: combine with per-sb journal variant */
> > +static unsigned char compressor_buf[LOGFS_MAX_OBJECTSIZE];
> > +static DEFINE_MUTEX(compr_mutex);
> 
> This looks fishy. All reads and writes are serialized by compr_mutex 
> because they share a scratch buffer for compression and uncompression?

s/fishy/lame/

Will move to superblock.

> > +/* FIXME: all this mess should get replaced by using the page cache */
> > +static void fixup_from_wbuf(struct super_block *sb, struct logfs_area 
> *area,
> > +             void *read, u64 ofs, size_t readlen)
> > +{
> 
> Indeed. And I think you're getting some more trouble because of this... 

More trouble?

Sadly squeezing bugs out of that beast was easier than wrapping my brain
around the proper solution.  And now it works and has moved to a less
urgent position in my todo list.

> > +int logfs_segment_read(struct super_block *sb, void *buf, u64 ofs)
> > +{
> > +     struct logfs_object_header *h;
> > +     u16 len;
> > +     int err, bs = sb->s_blocksize;
> > +
> > +     mutex_lock(&compr_mutex);
> > +     err = wbuf_read(sb, ofs, bs + LOGFS_HEADERSIZE, compressor_buf);
> > +     if (err)
> > +             goto out;
> > +     h = (void*)compressor_buf;
> > +     len = be16_to_cpu(h->len);
> > +
> > +     switch (h->compr) {
> > +     case COMPR_NONE:
> > +             logfs_memcpy(compressor_buf + LOGFS_HEADERSIZE, buf, bs, 
> bs);
> > +             break;
> 
> Seems wasteful to first read the data in a scratch buffer and then 
> memcpy() it immediately for the COMPR_NONE case. Any reason why we can't 
> read a full struct page, for example, and simply use that if we don't need 
> to uncompress anything?

No technical reason.  Just a case of "make it work now and optimize
later".

> > +     case COMPR_ZLIB:
> > +             err = logfs_uncompress(compressor_buf + LOGFS_HEADERSIZE, 
> buf,
> > +                             len, bs);
> > +             BUG_ON(err);
> > +             break;
> 
> Not claiming to undestand your on-disk format, but wouldn't it make more 
> sense if we knew whether a given segment is compressed or not _before_ we 
> actually read it?

[ Objects are the units that get compressed.  Segments can contain both
compressed and uncompressed objects. ]

It is a trade-off.  Each object has a 24 Byte header plus X Bytes of
data.  Whether the data is compressed or not is indicated in the header.
So we have to do one of two things.  Either:
- read the complete object, then either uncompress or memcpy, or
- read just the header, then either read uncompressed data or read
  compressed data and uncompress.

The former does an unnecessary memcpy() in the uncompressed case.  The
latter does an extra IO operation.  I haven't done any benchmarks to see
which variant is faster on which hardware.

An advantage of the second approach is that no buffer and no mutex is
needed in the uncompressed case.  That could help read performance on an
SMP system.  I'll put it on my list, just not at the top.  Ok?

Jörn

-- 
When in doubt, punt.  When somebody actually complains, go back and fix it...
The 90% solution is a good thing.
-- Rob Landley
