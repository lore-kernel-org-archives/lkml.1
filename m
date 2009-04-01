Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbZDALhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbZDALhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZDALg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:36:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60798 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803AbZDALg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:36:58 -0400
Date: Wed, 1 Apr 2009 12:36:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bmap-vs-truncate race
Message-ID: <20090401113649.GA28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0903301518120.23576@hs20-bc2-1.build.redhat.com> <20090331175451.GA19484@infradead.org> <Pine.LNX.4.64.0903311728530.32061@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903311728530.32061@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 06:42:34PM -0400, Mikulas Patocka wrote:
> On Tue, 31 Mar 2009, Christoph Hellwig wrote:
> 
> > On Mon, Mar 30, 2009 at 03:20:24PM -0400, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > I'm submitting this patch for 2.6.30 merge window.
> > 
> > Please not.  i_alloc_sem is really a horrible hack needed for a couple
> > filesystems only and we should not leak it into more generic code but
> > rather move the few instances into the filesystem.
> 
> Could you please document locking rules for get_block(), truncate, bmap & 
> direct i/o in Documentation/filesystems/Locking ?
> 
> There is a lot of text about directories, but nothing about locking of 
> block mappings.
> 
> I was living under an impression that get_block() cannot be called on a 
> block that is being truncated. That's what read/write/direct-io vs 
> truncate seems to guarante --- truncate will first lower i_size 
> (preventing any new pages past i_size from being created), then destroy 
> any existing pages past i_size (that includes waiting for pagelock until 
> all get_blocks on that page end) and finally truncate the metadata on the 
> filesystem.
> 
> So there should be no situation when you truncate block and call get_block 
> on it simultaneously. If get_block can race with truncate, document it.
> 
> There are filesystems that don't do any locking on get_block() (for 
> example UFS, HPFS; FAT does it only for bmap and doesn't do it for general 
> accesses) and other filesystems verify indirect block chains obsessively 
> if they were truncated under get_block (why? because of bmap? or some 
> other possibility?) --- so the rules should really be documented.

Indirect chain stuff used to be [1] about truncate that *wouldn't* affect page
in question.  Look: we have e.g. 4Kb blocks and data at offset 80Kb.  We do
allocation at offset 40Kb *and* truncate to 60Kb at the same time.

Both 40Kb (block 10) and 80Kb (block 20) are covered by the first indirect
block.  It's there, so get_block() reads it and gets ready to allocate
a block and put its number in the very beginning of indirect block.  In
the meanwhile, truncate() sees that the boundary falls within the first
indirect block (at entry 15).  It sees that we have no blocks prior to
that, so the indirect block ought to be freed.

Now ext2_get_block() comes back with allocated data block and has nowhere
to stick it anymore - indirect one just got freed.

_That_ is where verify_chain() came from.  As far as anything outside of
ext2 can know, this truncate() won't come anywhere near the page we are
working with.  And it won't - for data, that is.

Disclaimer: this code has been changed several times since the last time
I worked with it, so this might not match the current situation anymore.

[1] see disclaimer above.
