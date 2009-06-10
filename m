Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbZFJQKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbZFJQKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbZFJQKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:10:05 -0400
Received: from thunk.org ([69.25.196.29]:49238 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZFJQKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:10:02 -0400
Date: Wed, 10 Jun 2009 12:09:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: next-20090609 hangs in early user mode
Message-ID: <20090610160930.GB10240@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20090610180058.99bd3dda.sfr@canb.auug.org.au> <20090610130054.GR8633@ZenIV.linux.org.uk> <20090610131909.GB6647@mit.edu> <20090610150839.GS8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610150839.GS8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 04:08:39PM +0100, Al Viro wrote:
> We can, but... it's again a matter of combining things with different
> locking.  i_flags is protected by i_mutex, so if you put another
> unsigned short next to it, you'd better make sure that i_mutex
> is necessary and sufficient for modifying it.
> 
> Depending on the target, gcc may turn 16bit read-modify-store into 32bit one,
> so if you have two 16bit fields next to each other, you can run into
> 
> CPU1:                     CPU2:
> r1 = *(u32 *)p;           r2 = *(u32 *)p;
> r1 |= 1;                  r2 |= 1 << 16;
> *(u32 *)p = r1;           *(u32 *)p = r2;
> 
> with obvious results.  So we need the same locking for both such fields...

Yelch....  good point.  I'll look and see if there's some other 8 or
16-bit type to combine it with, but we may have started to hit
diminishing returns with this this approach to sliming the inode slab
caches.  I'm beginning to think if I want to make the inodes smaller,
I'm going to have to create a separate substructure for fields only
used when a file descriptor is opened on that inode, both in struct
inode and in struct ext4_inode_info.  (Lifetime management of the
substructure is going to be non-trivial, though.)

					- Ted
