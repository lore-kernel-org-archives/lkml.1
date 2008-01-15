Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYAOJhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYAOJhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYAOJg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:36:56 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9127 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYAOJgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:36:55 -0500
Date: Tue, 15 Jan 2008 10:36:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, peterz@infradead.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080115093651.GW6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <20080114121021.0d392102@think.oraclecorp.com> <20080114175359.GS6258@kernel.dk> <20080115092503.GV6258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115092503.GV6258@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15 2008, Jens Axboe wrote:
> On Mon, Jan 14 2008, Jens Axboe wrote:
> > On Mon, Jan 14 2008, Chris Mason wrote:
> > > Hello everyone,
> > > 
> > > Here is a modified version of Jens' patch.  The basic idea is to push
> > > the mapping maintenance out of loop and down into the filesystem (ext2
> > > in this case).
> > > 
> > > Two new address_space operations are added, one to map
> > > extents and the other to provide call backs into the FS as io is
> > > completed.
> > > 
> > > Still TODO for this patch:
> > > 
> > > * Add exclusion between filling holes and readers.  This is partly
> > > implemented, when a hole is filled by the FS, the extent is flagged as
> > > having a hole.  The idea is to check this flag before trying to read
> > > the blocks and just send back all zeros.
> > > 
> > > The flag would be cleared when the blocks filling the hole have been
> > > written.
> > > 
> > > * Exclude page cache readers and writers
> > > 
> > > * Add a way for the FS to request a commit before telling the higher
> > > layers the IO is complete.  This way we can make sure metadata related
> > > to holes is on disk before claiming the IO is really done.  COW based
> > > filesystems will also needed it.
> > > 
> > > * Change loop to use fast mapping only when the new address_space op is
> > > provided (whoops, forgot about this until just now)
> > > 
> > > * A few other bits for COW, not really relevant until there
> > > is...something COW using it.
> > 
> > Looks pretty good. Essentially the loop side is 100% the same, it just
> > offloads the extent ownership to the fs (where it belongs). So I like
> > it. Attaching a small cleanup/fixup patch for loop, don't think it needs
> > further explanations.
> > 
> > One suggestion - free_extent_map(), I would call that put_extent_map()
> > instead.
> 
> I split and merged the patch into five bits (added ext3 support), so
> perhaps that would be easier for people to read/review. Attached and
> also exist in the loop-extent_map branch here:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=loop-extent_map

Seems my ext3 version doesn't work, it craps out in
ext3_get_blocks_handle() triggering this bug:

J_ASSERT(handle != NULL || create == 0);

I'll see if I can fix that, being fairly fs ignorant...

-- 
Jens Axboe

