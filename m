Return-Path: <linux-kernel-owner+w=401wt.eu-S1762292AbXEPKVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762292AbXEPKVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 06:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbXEPKVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 06:21:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33501 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbXEPKVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 06:21:13 -0400
Date: Wed, 16 May 2007 13:21:11 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: "=?utf-8?B?SsO2cm4=?= Engel" <joern@lazybastard.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
In-Reply-To: <20070515151919.GA32510@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0705161319060.5152@sbz-30.cs.Helsinki.FI>
References: <20070515151919.GA32510@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joern,

> +#define LOGFS_BUG(sb) do {           \
> +     struct super_block *__sb = sb;  \
> +     logfs_crash_dump(__sb);         \
> +     BUG();                          \
> +} while(0)

Note that BUG() can be a no-op so dumping something on disk might not make 
sense there. This seems useful, but you probably need to make this bit 
more generic so that using BUG() proper in your filesystem code does the 
right thing. Inventing your own wrapper should be avoided.

> +static inline struct logfs_super *LOGFS_SUPER(struct super_block *sb)
> +{
> +     return sb->s_fs_info;
> +}
> +
> +static inline struct logfs_inode *LOGFS_INODE(struct inode *inode)
> +{
> +     return container_of(inode, struct logfs_inode, vfs_inode);
> +}

No need for upper case in function names.

> +int logfs_memcpy(void *in, void *out, size_t inlen, size_t outlen)
> +{
> +     if (outlen < inlen)
> +             return -EIO;
> +     memcpy(out, in, inlen);
> +     return inlen;
> +}

Please drop this wrapper function. It's better to open-code the error
handling in the callers (there are total of three of them).

> +/* FIXME: combine with per-sb journal variant */
> +static unsigned char compressor_buf[LOGFS_MAX_OBJECTSIZE];
> +static DEFINE_MUTEX(compr_mutex);

This looks fishy. All reads and writes are serialized by compr_mutex 
because they share a scratch buffer for compression and uncompression?

> +/* FIXME: all this mess should get replaced by using the page cache */
> +static void fixup_from_wbuf(struct super_block *sb, struct logfs_area 
*area,
> +             void *read, u64 ofs, size_t readlen)
> +{

Indeed. And I think you're getting some more trouble because of this... 

> +int logfs_segment_read(struct super_block *sb, void *buf, u64 ofs)
> +{
> +     struct logfs_object_header *h;
> +     u16 len;
> +     int err, bs = sb->s_blocksize;
> +
> +     mutex_lock(&compr_mutex);
> +     err = wbuf_read(sb, ofs, bs + LOGFS_HEADERSIZE, compressor_buf);
> +     if (err)
> +             goto out;
> +     h = (void*)compressor_buf;
> +     len = be16_to_cpu(h->len);
> +
> +     switch (h->compr) {
> +     case COMPR_NONE:
> +             logfs_memcpy(compressor_buf + LOGFS_HEADERSIZE, buf, bs, 
bs);
> +             break;

Seems wasteful to first read the data in a scratch buffer and then 
memcpy() it immediately for the COMPR_NONE case. Any reason why we can't 
read a full struct page, for example, and simply use that if we don't need 
to uncompress anything?

> +     case COMPR_ZLIB:
> +             err = logfs_uncompress(compressor_buf + LOGFS_HEADERSIZE, 
buf,
> +                             len, bs);
> +             BUG_ON(err);
> +             break;

Not claiming to undestand your on-disk format, but wouldn't it make more 
sense if we knew whether a given segment is compressed or not _before_ we 
actually read it?
