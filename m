Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYIEJUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYIEJUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYIEJUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:20:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:59107 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753927AbYIEJUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:20:23 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/yRqsnDr7ySsoaDIWpIb9rp1rTtEAl3dBZylFQP6
	QCGWqel7Ok0/Qq
Date: Fri, 5 Sep 2008 11:20:17 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org
Subject: Re: __getblk infinite loop
Message-ID: <20080905092017.GA2712@alice>
References: <20080905032411.GB13208@hash.localnet> <20080904223836.54fbabb1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080904223836.54fbabb1.akpm@linux-foundation.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc5-00099-gd26acd9 (x86_64)
X-Uptime: 11:13:10 up 20 min,  1 user,  load average: 0.06, 0.28, 0.31
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 4 Sep 2008 23:24:11 -0400 Bob Copeland <me@bobcopeland.com> wrote:
> 
> > Hi all,
> > 
> > Eric Sesterhenn and I were puzzling over a lockup found by his fsfuzzer.
> > 
> > sb_bread() calls __getblk, which says:
> > 
> > /*
> >  * __getblk will locate (and, if necessary, create) the buffer_head
> >  * which corresponds to the passed block_device, block and size. The
> >  * returned buffer has its reference count incremented.
> >  *
> >  * __getblk() cannot fail - it just keeps trying.  If you pass it an
> >  * illegal block number, __getblk() will happily return a buffer_head
> >  * which represents the non-existent block.  Very weird.
> >  *
> >  * __getblk() will lock up the machine if grow_dev_page's try_to_free_buffers()
> >  * attempt is failing.  FIXME, perhaps?
> >  */
> > 
> > In fact the following will cause an infinite loop when mounting omfs 
> > loopback (on 32 bit x86 at least):
> > 
> > diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
> > index a95fe59..80eacc8 100644
> > --- a/fs/omfs/inode.c
> > +++ b/fs/omfs/inode.c
> > @@ -413,6 +413,15 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
> >  	sector_t start;
> >  	int ret = -EINVAL;
> >  
> > +	if (1) {
> > +		sector_t foo = 0x1d4000004ULL;
> > +
> > +		sb_set_blocksize(sb, 2048);
> > +		bh = sb_bread(sb, foo);
> > +		brelse(bh);
> > +		goto end;
> > +	}
> > +
> >  	save_mount_options(sb, (char *) data);
> >  
> >  	sbi = kzalloc(sizeof(struct omfs_sb_info), GFP_KERNEL);
> > 
> > What's supposed to happen here?  I would have thought that sb_bread
> > would realize foo was outside the block dev and bail out, but instead
> > it just gets stuck.  Do I need to bounds-check anything passed to
> > sb_bread?
> 
> That loop does lock up on people occasionally - last time was in isofs,
> because it had done an insane set_blocksize() earlier on.
> 
> Yes, it's always a case of garbage in, garbage out (or nothing out, as
> the case may be).
> 
> No, it's not particularly programmer-friendly behaviour.

Wouldnt it make sense to limit the loop in __getblk_slow()?

Like only try five times and drop a warning?
Yesterday I changed free_more_memory() to
return the number of pages freed by try_to_free_pages() and abort
if no pages where freed. But it seems it always frees exactly one
page...

Greetings, Eric
