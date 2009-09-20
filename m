Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZITRn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZITRn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbZITRnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:43:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:55181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbZITRny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:43:54 -0400
Date: Sun, 20 Sep 2009 19:43:56 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090920174356.GA16919@duck.suse.cz>
References: <1253121768-20673-1-git-send-email-jack@suse.cz> <20090920023528.GA13114@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920023528.GA13114@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 20-09-09 10:35:28, Wu Fengguang wrote:
> On Thu, Sep 17, 2009 at 01:22:48AM +0800, Jan Kara wrote:
> > If all inodes are under writeback (e.g. in case when there's only one inode
> > with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> > to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> > waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> > write anything.
> 
> Sorry, I realized that inode_wait_for_writeback() waits for I_SYNC.
> But inodes in b_more_io are not expected to have I_SYNC set. So your
> patch looks like a big no-op?
  Hmm, I don't think so. writeback_single_inode() does:
        if (inode->i_state & I_SYNC) {
                /*
                 * If this inode is locked for writeback and we are not
                 * doing
                 * writeback-for-data-integrity, move it to b_more_io so
                 * that
                 * writeback can proceed with the other inodes on s_io.
                 *
                 * We'll have another go at writing back this inode when we
                 * completed a full scan of b_io.
                 */
                if (!wait) {
                        requeue_io(inode);
                        return 0;
                }

  So when we see inode under writeback, we put it to b_more_io. So I think
my patch really fixes the issue when two threads are racing on writing the
same inode.

> The busy loop does exists, when bdi is congested.
> In this case, write_cache_pages() will refuse to write anything,
> we used to be calling congestion_wait() to take a breath, but now
> wb_writeback() purged that call and thus created a busy loop.
  I don't think congestion is an issue here. The device needen't be
congested for the busyloop to happen.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
