Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXKGKgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXKGKgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 05:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbXKGKgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 05:36:14 -0500
Received: from lazybastard.de ([212.112.238.170]:59206 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbXKGKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:36:12 -0500
Date: Wed, 7 Nov 2007 11:31:24 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 14/23] inodes: Support generic defragmentation
Message-ID: <20071107103124.GD7374@lazybastard.org>
References: <20071107011130.382244340@sgi.com> <20071107011229.893091119@sgi.com> <20071107101748.GC7374@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071107101748.GC7374@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 November 2007 11:17:48 +0100, Jörn Engel wrote:
> > +/*
> > + * Function for filesystems that embedd struct inode into their own
> > + * structures. The offset is the offset of the struct inode in the fs inode.
> > + */
> > +void *fs_get_inodes(struct kmem_cache *s, int nr, void **v,
> > +						unsigned long offset)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr; i++)
> > +		v[i] += offset;
> > +
> > +	return get_inodes(s, nr, v);
> > +}
> > +EXPORT_SYMBOL(fs_get_inodes);
> 
> The fact that all pointers get changed makes me a bit uneasy:
> 	struct foo_inode v[20];
> 	...
> 	fs_get_inodes(..., v, ...);
> 	...
> 	v[0].foo_field = bar;
> 	
> No warning, but spectacular fireworks.
> 
> > +void kick_inodes(struct kmem_cache *s, int nr, void **v, void *private)
> > +{
> > +	struct inode *inode;
> > +	int i;
> > +	int abort = 0;
> > +	LIST_HEAD(freeable);
> > +	struct super_block *sb;
> > +
> > +	for (i = 0; i < nr; i++) {
> > +		inode = v[i];
> > +		if (!inode)
> > +			continue;
> 
> NULL is legal here?  Then fs_get_inodes should check for NULL as well
> and not add the offset to NULL pointers, I guess.

Ignore these two comments.  Reading further before making them would
have helped. ;)

Jörn

-- 
Fancy algorithms are slow when n is small, and n is usually small.
Fancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
