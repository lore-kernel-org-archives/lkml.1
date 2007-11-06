Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbXKFQ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbXKFQ5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbXKFQ5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:57:25 -0500
Received: from waste.org ([66.93.16.53]:55106 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbXKFQ5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:57:24 -0500
Date: Tue, 6 Nov 2007 10:57:08 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Loopback mounts should update the mtime of the underlying file on writes
Message-ID: <20071106165708.GF19691@waste.org>
References: <20071106010924.GT17536@waste.org> <20071105185241.7ff1d8f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105185241.7ff1d8f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 06:52:41PM -0800, Andrew Morton wrote:
> On Mon, 5 Nov 2007 19:09:24 -0600 Matt Mackall <mpm@selenic.com> wrote:
> 
> > Noticed by a Mercurial user. I think this should fix it.
> > 
> 
> "should".  That pitter patter sound your hear is little akpm feet running
> away.

Well I did actually test it.

> > Index: l/drivers/block/loop.c
> > ===================================================================
> > --- l.orig/drivers/block/loop.c	2007-11-05 17:50:07.000000000 -0600
> > +++ l/drivers/block/loop.c	2007-11-05 19:03:51.000000000 -0600
> > @@ -221,6 +221,7 @@ static int do_lo_send_aops(struct loop_d
> >  	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
> >  	bv_offs = bvec->bv_offset;
> >  	len = bvec->bv_len;
> > +	file_update_time(file);
> >  	while (len > 0) {
> >  		sector_t IV;
> >  		unsigned size;
> > @@ -299,6 +300,7 @@ static int __do_lo_send_write(struct fil
> >  
> >  	set_fs(get_ds());
> >  	bw = file->f_op->write(file, buf, len, &pos);
> > +	file_update_time(file);
> >  	set_fs(old_fs);
> >  	if (likely(bw == len))
> >  		return 0;
> 
> Probably makes sense, but bear in mind that we can be fairly deep in
> filesystem A functions here, and file_update_time() can do stuff like
> starting journal transactions on filesystem B.

I think that can alread happen, no? Especially if we're filling in
holes.

-- 
Mathematics is the supreme nostalgia of our time.
