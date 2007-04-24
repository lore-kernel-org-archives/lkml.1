Return-Path: <linux-kernel-owner+w=401wt.eu-S1423081AbXDXUL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423081AbXDXUL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423090AbXDXUL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:11:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423081AbXDXULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:11:25 -0400
Date: Tue, 24 Apr 2007 13:10:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070424131042.38c8cbff.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704241256470.12907@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
	<20070423154224.15ebf8f7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241234341.12753@schroedinger.engr.sgi.com>
	<20070424124922.d406aac1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241256470.12907@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 12:59:17 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 24 Apr 2007, Andrew Morton wrote:
> 
> > No, think of the following scenario:
> > 
> > - file I/O causes a read of an ext2 file's bitmap.  The bitmap is
> >   brought into /dev/hda1's pagecache using !__GFP_HIGHMEM
> > 
> > - references are released against that page and it's now just clean
> >   reclaimable pagecache
> > 
> > - someone (say, an online filesystem checker or something) mmaps
> >   /dev/hda1 and reads that page.
> > 
> > - migration comes alnog and migrates that page into highmem
> > 
> > - file I/O causes a read of that bitmap again.  We find it in
> >   /dev/hda's pagecache.
> 
> Read of the bitmap? How would that work? Page cache lookup right?

yup.

	sb_bread
	->__bread
	  ->__getblk
	    ->__find_get_block
	      ->__find_get_block_slow
	        ->find_get_page

> >   Here's set_bh_page().
> 
> A highmem page can have buffers???

yep.  Take a 4k page which is stored in four discontiguous 1k disk blocks. The
data at page_buffers(page) is the sole way in which we track which parts of
the page belong to which blocks of the disk.

