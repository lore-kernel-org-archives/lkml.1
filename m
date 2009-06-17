Return-Path: <linux-kernel-owner+w=401wt.eu-S1764524AbZFQEbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764524AbZFQEbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZFQEbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:31:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34184 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZFQEa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:30:59 -0400
Date: Wed, 17 Jun 2009 06:21:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, dedekind1@gmail.com, fweisbec@gmail.com
Subject: Re: [PATCH 0/15] Per-bdi writeback flusher threads v10
Message-ID: <20090617042111.GS11363@kernel.dk>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com> <1245114397.2560.368.camel@ymzhang> <20090616080036.GO11363@kernel.dk> <1245202532.2560.402.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245202532.2560.402.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17 2009, Zhang, Yanmin wrote:
> On Tue, 2009-06-16 at 10:00 +0200, Jens Axboe wrote:
> > On Tue, Jun 16 2009, Zhang, Yanmin wrote:
> > > On Fri, 2009-06-12 at 14:54 +0200, Jens Axboe wrote:
> > > > Hi,
> > > > 
> > > > Here's the 10th version of the writeback patches. Changes since v9:
> > > > 
> > > > - Fix bdi task exit race leaving work on the list, flush it after we
> > > >   know we cannot be found anymore.
> > > > - Rename flusher tasks from bdi-foo to flush-foo. Should make it more
> > > >   clear to the casual observer.
> > > > - Fix a problem with the btrfs bdi register patch that would spew
> > > >   warnings for > 1 mounted btrfs file system.
> > > > - Rebase to current -git, there were some conflicts with the latest work
> > > >   from viro/hch.
> > > > - Fix a block layer core problem were stacked devices would overwrite
> > > >   the bdi state, causing problems and warning spew.
> > > > - In bdi_writeback_all(), in the race occurence of a work allocation
> > > >   failure, restart scanning from the beginning. Then we can drop the
> > > >   bdi_lock mutex before diving into bdi specific writeback.
> > > > - Convert bdi_lock to a spinlock.
> > > > - Use spin_trylock() in bdi_writeback_all(), if this isn't a data
> > > >   integrity writeback. Debatable, I kind of like it...
> > > > - Get rid of BDI_CAP_FLUSH_FORKER, just check for match with the
> > > >   default_backing_dev_info.
> > > > - Fix race in list checking in bdi_forker_task().
> > > > 
> > > > 
> > > > For ease of patching, I've put the full diff here:
> > > > 
> > > >   http://kernel.dk/writeback-v10.patch
> > > Jens,
> > > 
> > > I applied the patch to 2.6.30 and got a confliction. The attachment is
> > > the patch I ported to 2.6.30. Did I miss anything?
> > > 
> > > 
> > > With the patch, kernel reports below messages on 2 machines.
> > > 
> > > INFO: task sync:29984 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > sync          D ffff88002805e300  6168 29984  24581
> > >  ffff88022f84b780 0000000000000082 7fffffffffffffff ffff880133dbfe70
> > >  0000000000000000 ffff88022e2b4c50 ffff88022e2b4fd8 00000001000c7bb8
> > >  ffff88022f513fd0 ffff880133dbfde8 ffff880133dbfec8 ffff88022d5d13c8
> > > Call Trace:
> > >  [<ffffffff802b69e4>] ? bdi_sched_wait+0x0/0xd
> > >  [<ffffffff80780fde>] ? schedule+0x9/0x1d
> > >  [<ffffffff802b69ed>] ? bdi_sched_wait+0x9/0xd
> > >  [<ffffffff8078158d>] ? __wait_on_bit+0x40/0x6f
> > >  [<ffffffff802b69e4>] ? bdi_sched_wait+0x0/0xd
> > >  [<ffffffff80781628>] ? out_of_line_wait_on_bit+0x6c/0x78
> > >  [<ffffffff8024a426>] ? wake_bit_function+0x0/0x23
> > >  [<ffffffff802b67ac>] ? bdi_writeback_all+0x12a/0x152
> > >  [<ffffffff802b6805>] ? generic_sync_sb_inodes+0x31/0xde
> > >  [<ffffffff802b6935>] ? sync_inodes_sb+0x83/0x88
> > >  [<ffffffff802b6980>] ? __sync_inodes+0x46/0x8f
> > >  [<ffffffff802b94f2>] ? do_sync+0x36/0x5a
> > >  [<ffffffff802b9538>] ? sys_sync+0xe/0x12
> > >  [<ffffffff8020b9ab>] ? system_call_fastpath+0x16/0x1b
> > 
> > I don't think it is your backport, for some reason the v10 missed a
> > change that I think could solve this race. If not, there's another in
> > there that I need to look at.
> > 
> > So against your current base, could you try with the below added as
> > well? The printk() is just so we can see if this triggers for you or
> > not.
> > 
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index b3e80c5..a065da5 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -384,6 +384,15 @@ static int bdi_start_fn(void *ptr)
> >  	 */
> >  	synchronize_srcu(&bdi->srcu);
> >  
> > +	/*
> > +	 * Flush any pending work. No more can be added, since
> > +	 * the bdi is no longer discoverable.
> > +	 */
> > +	if (!list_empty(&bdi->work_list)) {
> > +		printk("bdi: flushing racy work\n");
> I ran testings with the patch. 2 machines reported the same issues
> when do sync just after mounting filesystems for testing.
> 
> These 2 machines did print out above info. One printed it just before
> dumping the blocking info.

Great, then I'm pretty confident that this is the issue. When if you
have, it help if you could try the 2nd patch and see if it resolves the
issue.

-- 
Jens Axboe

