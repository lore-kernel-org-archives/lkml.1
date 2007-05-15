Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbXEOVZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbXEOVZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXEOVYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:24:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754467AbXEOVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:24:55 -0400
Date: Tue, 15 May 2007 14:23:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johann Lombardi <johann@clusterfs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-Id: <20070515142339.4d9098f3.akpm@linux-foundation.org>
In-Reply-To: <20070515210124.GA23698@chiva>
References: <20070515143726.GC2160@chiva>
	<20070515101144.f7072476.akpm@linux-foundation.org>
	<20070515210124.GA23698@chiva>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 23:01:24 +0200
Johann Lombardi <johann@clusterfs.com> wrote:

> On Tue, May 15, 2007 at 10:11:44AM -0700, Andrew Morton wrote:
> > We need to make sure that this page has PG_uptodate cleared, so
> > that a re-read is forced.  And the affected buffer_head, if any, should have
> > buffer_uptodate() cleared.
> 
> ok.
> 
> > This change might have horrid interactions with readahead and various
> > application access patterns: if for some reason a dud sector takes 30
> > seconds of driver futzing to return -EIO and someone (application or
> > kernel) tries to read the same sector tens or hundreds of times, suckiness
> > ensues.  This will be hard to test for.
> 
> Yes, I agree. So according to you, what's the best way to address the
> initial problem (i.e. PG_error never cleared)?

ooh, hard.

umm, a very safe way would be to free the dang page.  Make sure that we
have no references on it and that we have a ref on the inode (ie: we're
within a syscall which was passed an fd) then run
invalidate_mapping_pages()

> > Most reads don't (or shouldn't) go through block_read_full_page().
> > mpage_readpages() does the heavy lifting.
> 
> Yes, indeed. However, as soon as a call to get_block() fails,
> do_mpage_readpage() will call block_read_full_page() which will attach
> buffers to this page.
> Consequently, all subsequent reads will go through block_read_full_page().

hm, confused.  Why is get_block() failing?  That has to go and read
metadata.  If get_block() failed then we don't know what blocks to read to
bring this page uptodate, so the pagecache page should remain in state
!PageUptodate(), !PageError().  But then, we shouldn't have populated
pagecache at that offset at all.

I think I'm missing something here.  I suspect you're referring to a mix
of reading the blockdev via /dev/hda1 and then using the already-populated
pagecache as filesystem metadata, or something?

Is the PageError page part of an S_ISREG file, or is it part of an S_ISBLK
file?
