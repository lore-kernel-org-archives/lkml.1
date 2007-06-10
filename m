Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXFJRnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXFJRnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757718AbXFJRna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:43:30 -0400
Received: from lazybastard.de ([212.112.238.170]:47884 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXFJRn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:43:29 -0400
Date: Sun, 10 Jun 2007 19:38:29 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: Re: [Patch 15/18] fs/logfs/super.c
Message-ID: <20070610173828.GA32619@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org> <20070603184927.GP8952@lazybastard.org> <200706101827.50948.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706101827.50948.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 June 2007 18:27:49 +0200, Arnd Bergmann wrote:
> On Sunday 03 June 2007, Jörn Engel wrote:
> > +static int mtdwrite(struct super_block *sb, loff_t ofs, size_t len, void *buf)
> > +{
> > +	struct logfs_super *super = logfs_super(sb);
> > +	struct mtd_info *mtd = super->s_mtd;
> > +	struct inode *inode = super->s_dev_inode;
> > +	size_t retlen;
> > +	loff_t page_start, page_end;
> > +	int ret;
> > +
> > +	if (super->s_flags & LOGFS_SB_FLAG_RO)
> > +		return -EROFS;
> > +
> > +	BUG_ON((ofs >= mtd->size) || (len > mtd->size - ofs));
> > +	BUG_ON(ofs != (ofs >> super->s_writeshift) << super->s_writeshift);
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
> 
> It seems that these functions are completely synchronous and afaics, the
> writes are called in the pdflush context, effectively blocking out operations
> on other file systems at the time. Not sure if this is something that
> should be fixed, but it seems to limit scalability on mtd backends.
> 
> It seems that jffs2 has the same behaviour.

Most flash chips are synchronous.  Some support erase suspend - an erase
operation can be indefinitely suspended to give faster read and write
operations priority.  That's about it.

For the foreseeable future I believe synchronous operations are the
correct way to deal with raw flash chips.

> > +static int bdwrite(struct super_block *sb, loff_t to, size_t len, void *buf)
> > +{
> > +	struct block_device *bdev = logfs_super(sb)->s_bdev;
> > +	struct address_space *mapping = bdev->bd_inode->i_mapping;
> > +	struct page *page;
> > +	long index = to >> PAGE_SHIFT;
> > +	long offset = to & (PAGE_SIZE-1);
> > +	long copylen;
> > +
> > +	while (len) {
> > +		copylen = min((ulong)len, PAGE_SIZE - offset);
> > +
> > +		page = read_cache_page(mapping, index,
> > +				(filler_t*)mapping->a_ops->readpage, NULL);
> > +		if (!page)
> > +			return -ENOMEM;
> > +		if (IS_ERR(page))
> > +			return PTR_ERR(page);
> > +		lock_page(page);
> > +		memcpy(page_address(page) + offset, buf, copylen);
> > +		set_page_dirty(page);
> > +		unlock_page(page);
> > +		page_cache_release(page);
> > +
> > +		buf += copylen;
> > +		len -= copylen;
> > +		offset = 0;
> > +		index++;
> > +	}
> > +	return 0;
> > +}
> 
> How about using submit_bio here instead of going to the page cache?
> That would avoid doubling all the memory consumption here.

That may make sense, yes.  "May", because there is no simple mapping
between physical data and logical data.  In ext3, everything is
block-aligned, usually to 4KiB == PAGE_SIZE.  So the exact same content
would exists in two pages.  In LogFS, data is compressed and
byte-aligned.  A bdev page can contain several full objects that after
uncompression get stored in one page each.

> > +/*
> > + * logfs_crash_dump - dump debug information to device
> > + *
> > + * The LogFS superblock only occupies part of a segment.  This function will
> > + * write as much debug information as it can gather into the spare space.
> > + */
> > +void logfs_crash_dump(struct super_block *sb)
> > +{
> > +	struct logfs_super *super = logfs_super(sb);
> > +	int i, blockno = 2, bs = sb->s_blocksize;
> > +	void *scratch = super->s_wblock[0];
> > +	void *stack = (void *) ((ulong)current & ~0x1fffUL);
> > +
> > +	/* all wbufs */
> > +	for (i=0; i<LOGFS_NO_AREAS; i++) {
> > +		void *wbuf = super->s_area[i]->a_wbuf;
> > +		u64 ofs = sb->s_blocksize + i*super->s_writesize;
> > +		mtdwrite(sb, ofs, super->s_writesize, wbuf);
> > +	}
> 
> shouldn't this use the ->write() function instead of hardcoding mtdwrite.

It should and I've already fixed it since sending the patches.

> > +module_init(logfs_init);
> > +module_exit(logfs_exit);
> 
> You are missing at least a MODULE_LICENSE and should probably
> add the MODULE_AUTHOR and MODULE_DESCRIPTION tags as well.
> Right now, it's impossible to even load the module, because
> it uses a few GPL-only symbols.

Indeed.  Will do.

Jörn

-- 
A defeated army first battles and then seeks victory.
-- Sun Tzu
