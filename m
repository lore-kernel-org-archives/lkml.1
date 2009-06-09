Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbZFILOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbZFILOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZFILOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:14:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:56855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbZFILOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:14:31 -0400
Date: Tue, 9 Jun 2009 13:14:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh.dickins@tiscali.co.uk, riel@redhat.com, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v5
Message-ID: <20090609111432.GL14820@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090603184648.2E2131D028F@basil.firstfloor.org> <20090609095155.GA14820@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609095155.GA14820@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 11:51:55AM +0200, Nick Piggin wrote:
> On Wed, Jun 03, 2009 at 08:46:47PM +0200, Andi Kleen wrote:
> > +static int me_pagecache_clean(struct page *p, unsigned long pfn)
> > +{
> > +	struct address_space *mapping;
> > +
> > +	if (!isolate_lru_page(p))
> > +		page_cache_release(p);
> > +
> > +	/*
> > +	 * Now truncate the page in the page cache. This is really
> > +	 * more like a "temporary hole punch"
> > +	 * Don't do this for block devices when someone else
> > +	 * has a reference, because it could be file system metadata
> > +	 * and that's not safe to truncate.
> > +	 */
> > +	mapping = page_mapping(p);
> > +	if (mapping && S_ISBLK(mapping->host->i_mode) && page_count(p) > 1) {
> > +		printk(KERN_ERR
> > +			"MCE %#lx: page looks like a unsupported file system metadata page\n",
> > +			pfn);
> > +		return FAILED;
> > +	}
> 
> page_count check is racy. Hmm, S_ISBLK should handle xfs's private mapping.
> AFAIK btrfs has a similar private mapping but a quick grep does not show
> up S_IFBLK anywhere, so I don't know what the situation is there.
> 
> Unfortunately though, the linear mapping is not the only metadata mapping
> a filesystem might have. Many work on directories in seperate mappings
> (ext2, for example, which is where I first looked and will still oops with
> your check).
> 
> Also, others may have other interesting inodes they use for metadata. Do
> any of them go through the pagecache? I dont know. The ext3 journal,
> for example? How does that work?
> 
> Unfortunately I don't know a good way to detect regular data mappings
> easily. Ccing linux-fsdevel. Until that is worked out, you'd need to
> use the safe pagecache invalidate rather than unsafe truncate.

Maybe just testing S_ISREG would be better. Definitely safer than
ISBLK.

Note that for !ISREG files, then you can still attempt the
non-destructive invalidate (after extracting a suitable function
similarly to the truncate one). Most likely the fs is not using
the page right now, so it should give bit more coverage.

I still don't exactly know about, say, ext3 journal. Probably
it doesn't use pagecache anyway. Do any other filesystems do
crazy things with S_ISREG files? They probably deserve to oops
if they do ;)

