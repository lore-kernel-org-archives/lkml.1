Return-Path: <linux-kernel-owner+w=401wt.eu-S934706AbXKPVMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706AbXKPVMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762641AbXKPVLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:11:49 -0500
Received: from thunk.org ([69.25.196.29]:41315 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945AbXKPVLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:11:48 -0500
Date: Fri, 16 Nov 2007 16:11:33 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Rai <abhishekrai@google.com>, Andreas Dilger <adilger@sun.com>,
       linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Message-ID: <20071116211133.GJ11339@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Abhishek Rai <abhishekrai@google.com>,
	Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
	Ken Chen <kenchen@google.com>, Mike Waychison <mikew@google.com>
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com> <20071115230219.1fe9338c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115230219.1fe9338c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 11:02:19PM -0800, Andrew Morton wrote:
> 
> Presmably it starts around 50% of the way into the blockgroup?

Yes.

> How do you decide its size?

It's fixed at 1/128th (0.78%) of the blockgroup.

> What happens when it fills up but we still have room for more data blocks
> in that blockgroup?

It does fall back, but it does so starting from the beginning of the
block group by using the old-style allocation routines if it can't
find any space in the metacluster region.  What I'd suggest that it do
instead is to start searching from the end of metacluster region, and
then wrap around to the beginning of the block group, and then if it
can't find any blocks when it reaches the beginning of the metacluster
region, then go to the next block group that would be used by
ext3_new_blocks(), and start searching in the metacluster region ---
that way a smart e2fsck that is doing clustering could just arrange to
pre-read the metacluster region for each block group, and if it finds
an indirect block that is another block group's metacluster region, it
could try reading in those blocks too.

In order to do this, I'd suggest considering to fold ext3_new_blocks
and ext3_new_indirect_blocks() into the same function, with just a
passed-in flag to indicate whether for each block group the
metacluster region or the non-metacluster region should be searched
first.  This would also make elimiate some duplicated code.

> Can this reserved area cause disk space wastage (all data blocks used,
> metacluster area not yet full).

No, not as far as I can see.

> Less speedup, for more-and-smaller files, it appears.
> 
> An important question is: how does it stand up over time?  Simply laying
> files out a single time on a fresh fs is the easy case.  But what happens
> if that disk has been in continuous create/delete/truncate/append usage for
> six months?

Another question is how does it stand up if the average size of files
is different from what you anticipate?  If the files are bigger than
you expect, or smaller than you expect, then the ratio of indirect
blocks to data blocks will be different, at which point allocations
won't be perfectly split up between metacluster region.

For this reason, the exact size of the metacluster region should
probably be a superblock tunable --- and once we have the superblock
tunable, I'd use the non-zero metacluster size to determine whether or
not to enable this feature, and not to use a mount option.  Mount
options really should be avoided whenever possible, in favor of
settings in the superblock.

						- Ted
