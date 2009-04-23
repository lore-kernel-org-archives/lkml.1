Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZDWMcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZDWMcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbZDWMb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:31:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbZDWMb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:31:28 -0400
Date: Thu, 23 Apr 2009 08:31:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] vfs: Merge sync_supers(), sync_filesystems() and
	sync_blockdevs()
Message-ID: <20090423123126.GA25313@infradead.org>
References: <1240415781-17834-1-git-send-email-jack@suse.cz> <1240415781-17834-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240415781-17834-3-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 05:56:21PM +0200, Jan Kara wrote:
> These three functions are quite similar so merge them to save superblock list
> traversal code. As a bonus we get livelock avoidance for all these superblock
> traversals. Also remove the condition that if wait == 0 and sb->s_dirt is
> not set, then ->sync_fs() is not called. This does not really make much sence
> since s_dirt is generally used by filesystem to mean that ->write_super() needs
> to be called. But ->sync_fs() does different things. I even suspect that some
> filesystems (btrfs?) sets s_dirt just to fool this logic.

Some more comments after looking at it in more details:

 - the FSSYNC_SUPER case really needs to do a trylock on the mutex,
   otherwise any in-progress sync would block pdflush for a long time.
   And as any real sync should write out the superblock it's not needed
   anyway during that time.  (Need to double-check the filesystems,
   though)
 - sync_filesystems really should move to fs/sync.c
 - I get more and more inclined to make sync just case of looping over
   the superblocks and do an fsync_super.  A plain sync fsync_super
   might be too slow so we can try to do an async one first and then
   a sync one as a second pass
 - that wakeup_pdflush in do_sync looks extremly fishy, we need to do
   all page writeback via sync_inodes_(sb) anyway, and doing this in
   parallel from pdflush just introduced tons of potential race
   opportunities
 - now if sync_filesystems just ends up calling __fsync_super for
   the normal sync path I wonder if there really is a point unifying
   it with the periodic write_super case.
