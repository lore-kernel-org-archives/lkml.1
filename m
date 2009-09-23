Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZIWB1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZIWB1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 21:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZIWB1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 21:27:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:26689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZIWB1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 21:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,434,1249282800"; 
   d="scan'208";a="190575105"
Date: Wed, 23 Sep 2009 09:27:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090923012700.GA10464@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com> <1253601612.8439.274.camel@twins> <20090922080505.GB9192@localhost> <1253606965.8439.281.camel@twins> <20090922082427.GA24888@localhost> <1253608335.8439.283.camel@twins> <20090922155259.GL10825@think> <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923011758.GC6382@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:17:58AM +0800, Wu Fengguang wrote:
> On Wed, Sep 23, 2009 at 08:54:52AM +0800, Andrew Morton wrote:
> > On Wed, 23 Sep 2009 08:22:20 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Jens' per-bdi writeback has another improvement. In 2.6.31, when
> > > superblocks A and B both have 100000 dirty pages, it will first
> > > exhaust A's 100000 dirty pages before going on to sync B's.
> > 
> > That would only be true if someone broke 2.6.31.  Did they?
> > 
> > SYSCALL_DEFINE0(sync)
> > {
> > 	wakeup_pdflush(0);
> > 	sync_filesystems(0);
> > 	sync_filesystems(1);
> > 	if (unlikely(laptop_mode))
> > 		laptop_sync_completion();
> > 	return 0;
> > }
> > 
> > the sync_filesystems(0) is supposed to non-blockingly start IO against
> > all devices.  It used to do that correctly.  But people mucked with it
> > so perhaps it no longer does.
> 
> I'm referring to writeback_inodes(). Each invocation of which (to sync
> 4MB) will do the same iteration over superblocks A => B => C ... So if
> A has dirty pages, it will always be served first.
> 
> So if wbc->bdi == NULL (which is true for kupdate/background sync), it
> will have to first exhaust A before going on to B and C.
> 
> There are no "cursor" in the superblock level iterations.

I even have an old patch for it. But Jens' patches are more general solution.

Thanks,
Fengguang
---
writeback: continue from the last super_block in syncing

Cc: David Chinner <dgc@sgi.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c         |   12 ++++++++++++
 include/linux/writeback.h |    2 ++
 2 files changed, 14 insertions(+)

--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -494,11 +494,19 @@ void
 writeback_inodes(struct writeback_control *wbc)
 {
 	struct super_block *sb;
+	int i;
+
+	if (wbc->sb_index)
+		wbc->more_io = 1;
 
 	might_sleep();
 	spin_lock(&sb_lock);
 restart:
+	i = -1;
 	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
+		i++;
+		if (i < wbc->sb_index)
+			continue;
 		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
@@ -520,9 +528,13 @@ restart:
 			if (__put_super_and_need_restart(sb))
 				goto restart;
 		}
+		if (list_empty(&sb->s_io))
+			wbc->sb_index++;
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
+	if (&sb->s_list == &super_blocks)
+		wbc->sb_index = 0;
 	spin_unlock(&sb_lock);
 }
 
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -48,6 +48,8 @@ struct writeback_control {
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
 
+	int sb_index;			/* the superblock to continue from */
+
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is
 	 * a hint that the filesystem need only write out the pages inside that
