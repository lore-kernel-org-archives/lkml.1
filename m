Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZIAVvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZIAVvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 17:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZIAVvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 17:51:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZIAVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 17:51:30 -0400
Date: Tue, 1 Sep 2009 17:51:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: move super_block argument to struct
	writeback_control
Message-ID: <20090901215130.GA24397@infradead.org>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com> <1251803946-9243-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251803946-9243-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 01:18:59PM +0200, Jens Axboe wrote:
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/staging/pohmelfs/inode.c |    3 ++-
>  fs/fs-writeback.c                |   14 +++++++-------
>  fs/ubifs/budget.c                |    5 +++--
>  fs/ubifs/super.c                 |    3 ++-
>  include/linux/fs.h               |    3 +--
>  include/linux/writeback.h        |    2 ++

I think we need better calling conventions here.  Currently this whole
area is on crack, we have from highest to lowest layer:


 - sync_inodes_sb - does two totally different things based on the
   wait flag.  If the wait flag is set does a WB_SYNC_ALL writeout
   of all pages.  If not does a WB_SYNC_NONE based on some whacky
   heuristics despite actually wanting to write out everything.
 - sync_sb_inodes - toally useless wrapper.  Introduces because reiser4
   eventually wanted to hook in there, but that needs some major
   rethinking before it can happen.
 - generic_sync_inodes_sb - used to implement both cases of
   sync_inodes_sb, plus:

    - UBIFS budgeting writeouts, in either blocking or non-blocking
      way
    - UBIFS sync use that is gone in -next because we fixed sync
    - a complete crackpot usage in pohmelfs, which we fortunately can
      simply ignore because it's in -staging.


So instead of exporting generic_sync_sb_inodes which now takes just
a wbc we should just export two helpers to either data integrity sync
and SB or do a SYNC_NONE on it, both taking no other parameter than
the superblock.

