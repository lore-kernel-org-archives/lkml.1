Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbZFRMfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbZFRMfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZFRMfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:35:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48033 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZFRMfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:35:02 -0400
Date: Thu, 18 Jun 2009 14:35:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, dedekind1@gmail.com, fweisbec@gmail.com
Subject: Re: [PATCH 0/15] Per-bdi writeback flusher threads v10
Message-ID: <20090618123503.GV11363@kernel.dk>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com> <1245114397.2560.368.camel@ymzhang> <20090616080036.GO11363@kernel.dk> <20090616195329.GH11363@kernel.dk> <1245286866.2560.407.camel@ymzhang> <20090618051338.GH11363@kernel.dk> <1245302369.2560.410.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245302369.2560.410.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18 2009, Zhang, Yanmin wrote:
> On Thu, 2009-06-18 at 07:13 +0200, Jens Axboe wrote:
> > On Thu, Jun 18 2009, Zhang, Yanmin wrote:
> > > On Tue, 2009-06-16 at 21:53 +0200, Jens Axboe wrote:
> > > > On Tue, Jun 16 2009, Jens Axboe wrote:
> > > > > On Tue, Jun 16 2009, Zhang, Yanmin wrote:
> > > > > > On Fri, 2009-06-12 at 14:54 +0200, Jens Axboe wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > Here's the 10th version of the writeback patches. Changes since v9:
> > > > > > > 
> > > > > > > - Fix bdi task exit race leaving work on the list, flush it after we
> > > > > > >   know we cannot be found anymore.
> > > > > > > - Rename flusher tasks from bdi-foo to flush-foo. Should make it more
> > > > > > >   clear to the casual observer.
> > > > > > > - Fix a problem with the btrfs bdi register patch that would spew
> > > > > > >   warnings for > 1 mounted btrfs file system.
> > > > > > > - Rebase to current -git, there were some conflicts with the latest work
> > > > > > >   from viro/hch.
> > > > > > > - Fix a block layer core problem were stacked devices would overwrite
> > > > > > >   the bdi state, causing problems and warning spew.
> > > > > > > - In bdi_writeback_all(), in the race occurence of a work allocation
> > > > > > >   failure, restart scanning from the beginning. Then we can drop the
> > > > > > >   bdi_lock mutex before diving into bdi specific writeback.
> > > > > > > - Convert bdi_lock to a spinlock.
> > > > > > > - Use spin_trylock() in bdi_writeback_all(), if this isn't a data
> > > > > > >   integrity writeback. Debatable, I kind of like it...
> > > > > > > - Get rid of BDI_CAP_FLUSH_FORKER, just check for match with the
> > > > > > >   default_backing_dev_info.
> > > > > > > - Fix race in list checking in bdi_forker_task().
> > > > > > > 
> > > > > > > 
> > > > > > > For ease of patching, I've put the full diff here:
> > > > > > > 
> > > > > > >   http://kernel.dk/writeback-v10.patch
> > > > > > Jens,
> > > > > > 
> > > > > > I applied the patch to 2.6.30 and got a confliction. The attachment is
> > > > > > the patch I ported to 2.6.30. Did I miss anything?
> > > > > > 
> > > > > > 
> > > > > > With the patch, kernel reports below messages on 2 machines.
> > > > > > 
> > > > > > INFO: task sync:29984 blocked for more than 120 seconds.
> > > > > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > > > sync          D ffff88002805e300  6168 29984  24581
> > > > > >  ffff88022f84b780 0000000000000082 7fffffffffffffff ffff880133dbfe70
> > > > > >  0000000000000000 ffff88022e2b4c50 ffff88022e2b4fd8 00000001000c7bb8
> > > > > >  ffff88022f513fd0 ffff880133dbfde8 ffff880133dbfec8 ffff88022d5d13c8
> > > > > > Call Trace:
> > > > > >  [<ffffffff802b69e4>] ? bdi_sched_wait+0x0/0xd
> > > > > >  [<ffffffff80780fde>] ? schedule+0x9/0x1d
> > > > > >  [<ffffffff802b69ed>] ? bdi_sched_wait+0x9/0xd
> > > > > >  [<ffffffff8078158d>] ? __wait_on_bit+0x40/0x6f
> > > > > >  [<ffffffff802b69e4>] ? bdi_sched_wait+0x0/0xd
> > > > > >  [<ffffffff80781628>] ? out_of_line_wait_on_bit+0x6c/0x78
> > > > > >  [<ffffffff8024a426>] ? wake_bit_function+0x0/0x23
> > > > > >  [<ffffffff802b67ac>] ? bdi_writeback_all+0x12a/0x152
> > > > > >  [<ffffffff802b6805>] ? generic_sync_sb_inodes+0x31/0xde
> > > > > >  [<ffffffff802b6935>] ? sync_inodes_sb+0x83/0x88
> > > > > >  [<ffffffff802b6980>] ? __sync_inodes+0x46/0x8f
> > > > > >  [<ffffffff802b94f2>] ? do_sync+0x36/0x5a
> > > > > >  [<ffffffff802b9538>] ? sys_sync+0xe/0x12
> > > > > >  [<ffffffff8020b9ab>] ? system_call_fastpath+0x16/0x1b
> > > > > 
> > > > > I don't think it is your backport, for some reason the v10 missed a
> > > > > change that I think could solve this race. If not, there's another in
> > > > > there that I need to look at.
> > > > > 
> > > > > So against your current base, could you try with the below added as
> > > > > well? The printk() is just so we can see if this triggers for you or
> > > > > not.
> > > > 
> > > > OK that wont work, since we need to actually wait for the work to be
> > > > flushed, otherwise we wreak things when we free the bdi immediately
> > > > after that.
> > > > 
> > > > Can you try with this patch?
> > > Jens,
> > > 
> > > I tested below patch on 4 machines (run all fio sub-test cases twice which
> > > need more than 10 hours). The previous 2 machines don't stop this time.
> > > Unfortunately, the 3rd machine stops. I double-check the disassembled codes
> > > of kernel and make sure bdi_start_fn really calls wb_do_writeback.
> > 
> > Sorry I should have made that more clear when posting v11. This patch
> > wont fully solve the problem, however the v11 patch series should. So if
> > you test with that, hopefully all soft hangs should be gone.
> Ok. I will start new testing against V11. I also add some debugging codes into
> V11.

Great, thanks! There's a small issue with v11 that you should be aware
of. The test for bdi_add_default_flusher_task() was inverted. I'm
attaching a diff at the end. The interesting bit is the 2nd hunk of
backing-dev.c, the others are just a cleanup.

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 6815f8b..e623c57 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -107,7 +107,6 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages, enum writeback_sync_modes sync_mode);
 int bdi_writeback_task(struct bdi_writeback *wb);
 void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc);
-void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b4517ee..c2eec72 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -37,6 +37,8 @@ static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
 static void arm_supers_timer(void);
 
+static void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
+
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -496,7 +498,7 @@ static int bdi_forker_task(void *ptr)
 		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
 			if (bdi->wb.task)
 				continue;
-			if (!list_empty(&bdi->work_list) &&
+			if (list_empty(&bdi->work_list) &&
 			    !bdi_has_dirty_io(bdi))
 				continue;
 
@@ -607,7 +609,7 @@ static int flusher_add_helper_test(struct backing_dev_info *bdi)
  * Add the default flusher task that gets created for any bdi
  * that has dirty data pending writeout
  */
-void bdi_add_default_flusher_task(struct backing_dev_info *bdi)
+void static bdi_add_default_flusher_task(struct backing_dev_info *bdi)
 {
 	bdi_add_one_flusher_task(bdi, flusher_add_helper_test);
 }

-- 
Jens Axboe

