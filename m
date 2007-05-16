Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbXEPPjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbXEPPjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbXEPPjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:39:25 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:51590 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXEPPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:39:24 -0400
Date: Wed, 16 May 2007 17:39:19 +0200
From: Johann Lombardi <johann@clusterfs.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Clear PG_error before reading a page
Message-ID: <20070516153919.GC2630@chiva>
Mail-Followup-To: Johann Lombardi <johann@clusterfs.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070515143726.GC2160@chiva> <20070515101144.f7072476.akpm@linux-foundation.org> <20070515210124.GA23698@chiva> <20070515142339.4d9098f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515142339.4d9098f3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 02:23:39PM -0700, Andrew Morton wrote:
> > Yes, indeed. However, as soon as a call to get_block() fails,
> > do_mpage_readpage() will call block_read_full_page() which will attach
> > buffers to this page.
> > Consequently, all subsequent reads will go through block_read_full_page().
> 
> hm, confused.  Why is get_block() failing?  That has to go and read
> metadata. 

In fact, I am referring to the first part of my test case (i.e. mount the ext3
fs, enable medium errors in scsi_debug and try to read a file from the fs).

So, when I try to read a file, ext3_get_block() needs to read metadata from the
disk. However, given that the SCSI disk simulated by scsi_debug reports medium
errors, ext3_get_block() returns EIO to the caller (i.e. do_mpage_readpage()).
That's why get_block() is failing.

Then, do_mpage_readpage() calls block_read_full_page() (via "goto confused").
block_read_full_page() attaches buffers to this page and calls ext3_get_block()
which fails for the same reason as before. Consequently, block_read_full_page()
sets the PG_error flag.
Moreover, all subsequent readpage calls will go through block_read_full_page()
because the page has now buffers attached.

Basically, my problem is that afterwards, when the device no longer returns
any errors, the PG_error flag is never cleared and, as a result, I keep
getting -EIO. That's the problem I'd like to address.

> If get_block() failed then we don't know what blocks to read to
> bring this page uptodate, so the pagecache page should remain in state
> !PageUptodate(), !PageError().  But then, we shouldn't have populated
> pagecache at that offset at all.

Yes, indeed. do_generic_mapping_read() doesn't populate the pagecache if an
error occurred.
Still, __do_page_cache_readahead()->read_pages()->ext3_readpages()->mpage_readpages()
does populate the pagecache even if the page reads failed.

> I think I'm missing something here.  I suspect you're referring to a mix
> of reading the blockdev via /dev/hda1 and then using the already-populated
> pagecache as filesystem metadata, or something?

I don't think so, unless I'm missing something.

> Is the PageError page part of an S_ISREG file, or is it part of an S_ISBLK
> file?

The PageError pages are part of a regular file and have been read through
readahead.

Johann
