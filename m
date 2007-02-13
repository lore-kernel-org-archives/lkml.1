Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbXBMOYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbXBMOYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbXBMOXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:23:44 -0500
Received: from thunk.org ([69.25.196.29]:41899 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbXBMOXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:23:41 -0500
Date: Tue, 13 Feb 2007 09:23:35 -0500
From: Theodore Tso <tytso@mit.edu>
To: William Cohen <wcohen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Looking at space used by objects in slab allocator
Message-ID: <20070213142335.GC8670@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	William Cohen <wcohen@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45D0B78F.4030309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D0B78F.4030309@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 01:53:03PM -0500, William Cohen wrote:
> After last week's experiment reducing size of task_struct on I was
> The is a signficant amount of space wasted for ext3_inode_cache. If
> the struct used for ext3_inode_cache struct could be made smaller,
> three objects rather than two could fit in a slab. Fitting 3 objects
> to a page would decrease the space required for ext3_inod_cache from
> 20.4MB to 13.6MB in this example.

The problem is the size of "struct inode" (which is included in struct
ext3_inode_info).  There is quite a few fields in struct inode which
are only used when the inode has been opened and being referenced by
one or more file descriptors, but which take up a huge amount of
space.  One of the biggies is inode.i_data; struct address_space is
*huge*, and we're keeping a copy of it in every single inode which
we're caching.

It was next on my list on my inode-diet project that I worked on about
six months ago, but it was non-trivial, and my time got sucked away
with other projects, so I never got back to it.  But if you want to
try to save space, that's the next logical step --- we've already done
all or most of the low-hanging fruit to save space wasted by struct
inode and by extension in the ext3_inode_cache.

						- Ted

