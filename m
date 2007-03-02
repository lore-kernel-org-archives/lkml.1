Return-Path: <linux-kernel-owner+w=401wt.eu-S1422788AbXCBC3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422788AbXCBC3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422790AbXCBC3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:29:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37665 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422788AbXCBC3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:29:24 -0500
Date: Fri, 2 Mar 2007 02:29:19 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: support@coraid.com, "Ed L. Cashin" <ecashin@coraid.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-ID: <20070302022919.GA26285@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, support@coraid.com,
	"Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <20070301231510.GC8524@coraid.com> <20070301174204.a550dd3a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301174204.a550dd3a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 05:42:04PM -0800, Andrew Morton wrote:
> Something funny is going on here.

Not so funny for those who've tried to sort out the issue over
the past years and just got ignored..

> Generally, one should increment the refcount of a page when it is put into
> some container.  That means that the page should get +1 when it is added to
> a bio.  (direct-io does this, but the mpage.c pagecache code cheats, and
> relies upon PG_locked and PG-writeback protecting the page).

It's a slab page, and slab pages aren't refcounted (which is a good thing
as you don't own the whole page)

> Similarly, the network code (or its caller) should be incrementing the
> page's refcount as the page goes into a container (ie: the skb) and
> decrementing it as the page is removed.
> 
> But someone somewhere is breaking those rules.  Who?

slab code.  

> So.  Who is breaking refcounting protocol here?  Perhaps it is AOE, failing
> to increment the refcount on pages as they are added to an skb?
> 
> (Do we know which callsite in XFS is adding zero-ref pages to a BIO, btw?)

For example all log I/O is done from kmalloce pages.

Anyway, to rehash what I've been trying to get clarified for ages:


 (1) should we allow to pass slab pages into bios

and

 (2) if yes what's the way lower layers are supposed to handle them
     for any possible refcounting operations like networking or rdma.

There's also a pontial caller in ext3 that can send down kmalloc'ed
buffers: journal_write_metadata_buffer() in need_copy_out && !done_copy_out
case.  But apparently that's an almost dead code path as I've never
seen anyone tripping this one, it's always XFS that people report.
