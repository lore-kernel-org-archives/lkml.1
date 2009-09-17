Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZIQJJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZIQJJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZIQJJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:09:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:48692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZIQJJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:09:12 -0400
Date: Thu, 17 Sep 2009 11:09:14 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090917090914.GA16381@duck.suse.cz>
References: <1253121768-20673-1-git-send-email-jack@suse.cz> <20090916184106.GT23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916184106.GT23126@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-09-09 20:41:06, Jens Axboe wrote:
> On Wed, Sep 16 2009, Jan Kara wrote:
> > If all inodes are under writeback (e.g. in case when there's only one inode
> > with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> > to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> > waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> > write anything.
> 
> Interesting, so this will happen if the dirtier and flush thread end up
> "fighting" each other over the same inode. I'll throw this into the
> testing mix.
  Yes, exactly. When you do "dd if=/dev/zero of=/mnt/mydisk" you're quite
likely to observe that.

> How did you notice?
  Well, UML linux doesn't seem to preempt when a process when it is in the
kernel and thus such busyloop simply deadlocks it. BTW another similar
deadlock happens in UML linux in balance_dirty_pages() (process cycles
there waiting for nr_writeback to drop but that never seems to happen). But
I'd blame that to a problem in UML scheduling...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
