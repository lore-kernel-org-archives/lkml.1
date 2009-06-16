Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZFPTxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZFPTxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZFPTx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:53:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60281 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbZFPTx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:53:27 -0400
Date: Tue, 16 Jun 2009 21:53:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, dedekind1@gmail.com, fweisbec@gmail.com
Subject: Re: [PATCH 0/15] Per-bdi writeback flusher threads v10
Message-ID: <20090616195329.GH11363@kernel.dk>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com> <1245114397.2560.368.camel@ymzhang> <20090616080036.GO11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616080036.GO11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16 2009, Jens Axboe wrote:
> On Tue, Jun 16 2009, Zhang, Yanmin wrote:
> > On Fri, 2009-06-12 at 14:54 +0200, Jens Axboe wrote:
> > > Hi,
> > > 
> > > Here's the 10th version of the writeback patches. Changes since v9:
> > > 
> > > - Fix bdi task exit race leaving work on the list, flush it after we
> > >   know we cannot be found anymore.
> > > - Rename flusher tasks from bdi-foo to flush-foo. Should make it more
> > >   clear to the casual observer.
> > > - Fix a problem with the btrfs bdi register patch that would spew
> > >   warnings for > 1 mounted btrfs file system.
> > > - Rebase to current -git, there were some conflicts with the latest work
> > >   from viro/hch.
> > > - Fix a block layer core problem were stacked devices would overwrite
> > >   the bdi state, causing problems and warning spew.
> > > - In bdi_writeback_all(), in the race occurence of a work allocation
> > >   failure, restart scanning from the beginning. Then we can drop the
> > >   bdi_lock mutex before diving into bdi specific writeback.
> > > - Convert bdi_lock to a spinlock.
> > > - Use spin_trylock() in bdi_writeback_all(), if this isn't a data
> > >   integrity writeback. Debatable, I kind of like it...
> > > - Get rid of BDI_CAP_FLUSH_FORKER, just check for match with the
> > >   default_backing_dev_info.
> > > - Fix race in list checking in bdi_forker_task().
> > > 
> > > 
> > > For ease of patching, I've put the full diff here:
> > > 
> > >   http://kernel.dk/writeback-v10.patch
> > Jens,
> > 
> > I applied the patch to 2.6.30 and got a confliction. The attachment is
> > the patch I ported to 2.6.30. Did I miss anything?
> > 
> > 
> > With the patch, kernel reports below messages on 2 machines.
> > 
> > INFO: task sync:29984 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > sync          D ffff88002805e300  6168 29984  24581
> >  ffff88022f84b780 0000000000000082 7fffffffffffffff ffff880133dbfe70
> >  0000000000000000 ffff88022e2b4c50 ffff88022e2b4fd8 00000001000c7bb8
> >  ffff88022f513fd0 ffff880133dbfde8 ffff880133dbfec8 ffff88022d5d13c8
> > Call Trace:
> >  [<ffffffff802b69e4>] ? bdi_sched_wait+0x0/0xd
> >  [<ffffffff80780fde>] ? schedule+0x9/0x1d
> >  [<ffffffff802b69ed>] ? bdi_sched_wait+0x9/0xd
> >  [<ffffffff8078158d>] ? __wait_on_bit+0x40/0x6f
> >  [<ffffffff802b69e4>] ? bdi_sched_wait+0x0/0xd
> >  [<ffffffff80781628>] ? out_of_line_wait_on_bit+0x6c/0x78
> >  [<ffffffff8024a426>] ? wake_bit_function+0x0/0x23
> >  [<ffffffff802b67ac>] ? bdi_writeback_all+0x12a/0x152
> >  [<ffffffff802b6805>] ? generic_sync_sb_inodes+0x31/0xde
> >  [<ffffffff802b6935>] ? sync_inodes_sb+0x83/0x88
> >  [<ffffffff802b6980>] ? __sync_inodes+0x46/0x8f
> >  [<ffffffff802b94f2>] ? do_sync+0x36/0x5a
> >  [<ffffffff802b9538>] ? sys_sync+0xe/0x12
> >  [<ffffffff8020b9ab>] ? system_call_fastpath+0x16/0x1b
> 
> I don't think it is your backport, for some reason the v10 missed a
> change that I think could solve this race. If not, there's another in
> there that I need to look at.
> 
> So against your current base, could you try with the below added as
> well? The printk() is just so we can see if this triggers for you or
> not.

OK that wont work, since we need to actually wait for the work to be
flushed, otherwise we wreak things when we free the bdi immediately
after that.

Can you try with this patch?

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5a1837f..4a6859e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -409,7 +409,7 @@ static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
 /*
  * Retrieve work items and do the writeback they describe
  */
-static long wb_writeback(struct bdi_writeback *wb)
+static long wb_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct bdi_work *work;
@@ -418,7 +418,12 @@ static long wb_writeback(struct bdi_writeback *wb)
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		struct super_block *sb = bdi_work_sb(work);
 		long nr_pages = work->nr_pages;
-		enum writeback_sync_modes sync_mode = work->sync_mode;
+		enum writeback_sync_modes sync_mode;
+
+		if (force_wait)
+			sync_mode = WB_SYNC_ALL;
+		else
+			sync_mode = work->sync_mode;
 
 		/*
 		 * If this isn't a data integrity operation, just notify
@@ -444,7 +449,7 @@ static long wb_writeback(struct bdi_writeback *wb)
  * This will be inlined in bdi_writeback_task() once we get rid of any
  * dirty inodes on the default_backing_dev_info
  */
-long wb_do_writeback(struct bdi_writeback *wb)
+long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	long wrote;
 
@@ -461,7 +466,7 @@ long wb_do_writeback(struct bdi_writeback *wb)
 	if (list_empty(&wb->bdi->work_list))
 		wrote = wb_kupdated(wb);
 	else
-		wrote = wb_writeback(wb);
+		wrote = wb_writeback(wb, force_wait);
 
 	return wrote;
 }
@@ -477,7 +482,7 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 	long pages_written;
 
 	while (!kthread_should_stop()) {
-		pages_written = wb_do_writeback(wb);
+		pages_written = wb_do_writeback(wb, 0);
 
 		if (pages_written)
 			last_active = jiffies;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 0d4e31d..e070b91 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -68,7 +68,7 @@ struct writeback_control {
 void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
-long wb_do_writeback(struct bdi_writeback *wb);
+long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 23013d5..0c91add 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -389,7 +389,7 @@ static int bdi_start_fn(void *ptr)
 	 * will be added, since this bdi isn't discoverable anymore.
 	 */
 	if (!list_empty(&bdi->work_list))
-		wb_do_writeback(wb);
+		wb_do_writeback(wb, 1);
 
 	bdi_put_wb(bdi, wb);
 	return ret;
@@ -484,7 +484,7 @@ static int bdi_forker_task(void *ptr)
 		 * dirty data on the default backing_dev_info
 		 */
 		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
-			wb_do_writeback(me);
+			wb_do_writeback(me, 0);
 
 		spin_lock(&bdi_lock);
 

-- 
Jens Axboe

