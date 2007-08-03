Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbXHCREU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbXHCREU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXHCREL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:04:11 -0400
Received: from pat.uio.no ([129.240.10.15]:39878 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbXHCREK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:04:10 -0400
Subject: Re: [NFS] 2.6.23-rc1-mm2
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Neil Brown <neilb@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20070803093830.39852a01.akpm@linux-foundation.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de>
	 <20070803093830.39852a01.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 13:03:28 -0400
Message-Id: <1186160608.7255.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.078)
X-UiO-Scanned: C10AD0DCD392A7501FEB4128D9614A6B9A2ACA2F
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 27 total 3083739 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 09:38 -0700, Andrew Morton wrote:
> On Fri, 3 Aug 2007 13:00:46 +0200 Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
> 
> > 
> > Hi,
> > 
> > Am Wednesday 01 August 2007 08:09 schrieb Andrew Morton:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.
> > >6.23-rc1-mm2/
> > >
> > >
> > > - the git-block tree remains dropped due to disageement with the Vaio
> > >
> > > - git-e1000new was withdrawn by the authors
> > >
> > > - git-wireless is back.  It is still a >3MB diff, and appears to compile.
> > >
> > > - Is anyone testing the kgdb code in here?
> > 
> > I still get some nfs related locking bug.
> > 
> > I applied 
> > 
> > linux-2.6.23-001-fix_rpciod_down_race.dif
> > linux-2.6.23-003-fix_locking_regression.dif
> > linux-2.6.23-004-fix_stateid_regression.dif
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.23-rc1-mm2 #3
> > ---------------------------------------------
> > events/0/5 is trying to acquire lock:
> >  (events){--..}, at: [<c012ed90>] flush_workqueue+0x0/0x70
> > 
> > but task is already holding lock:
> >  (events){--..}, at: [<c012e5c4>] run_workqueue+0xd4/0x1e0
> > 
> > other info that might help us debug this:
> > 2 locks held by events/0/5:
> >  #0:  (events){--..}, at: [<c012e5c4>] run_workqueue+0xd4/0x1e0
> >  #1:  ((nfs_automount_task).work){--..}, at: [<c012e5c4>] 
> > run_workqueue+0xd4/0x1e0
> > 
> > stack backtrace:
> >  [<c0104fda>] show_trace_log_lvl+0x1a/0x30
> >  [<c0105c02>] show_trace+0x12/0x20
> >  [<c0105d15>] dump_stack+0x15/0x20
> >  [<c013ee42>] __lock_acquire+0xc22/0x1030
> >  [<c013f2b1>] lock_acquire+0x61/0x80
> >  [<c012edd9>] flush_workqueue+0x49/0x70
> >  [<c012ee0d>] flush_scheduled_work+0xd/0x10
> >  [<dcf55c0c>] nfs_release_automount_timer+0x2c/0x30 [nfs]
> >  [<dcf45d8e>] nfs_free_server+0x9e/0xd0 [nfs]
> >  [<dcf4e626>] nfs_kill_super+0x16/0x20 [nfs]
> >  [<c017b38d>] deactivate_super+0x7d/0xa0
> >  [<c018f94b>] mntput_no_expire+0x4b/0x80
> >  [<c018fd94>] expire_mount_list+0xe4/0x140
> >  [<c0191219>] mark_mounts_for_expiry+0x99/0xb0
> >  [<dcf55d1d>] nfs_expire_automounts+0xd/0x40 [nfs]
> >  [<c012e61b>] run_workqueue+0x12b/0x1e0
> >  [<c012f05b>] worker_thread+0x9b/0x100
> >  [<c0131c72>] kthread+0x42/0x70
> >  [<c0104c0f>] kernel_thread_helper+0x7/0x18
> >  =======================
> > 
> 
> There is new debugging stuff in -mm: deadlockable usage of workqueue
> primitives will now trigger lockdep warnings.  See
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/broken-out/workqueue-debug-flushing-deadlocks-with-lockdep.patch
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/broken-out/workqueue-debug-work-related-deadlocks-with-lockdep.patch
> 
> I am suspecting that running flush_scheduled_work() from within run_workqueue()
> isn't good.

I'll have a look at this. I suspect that most if not all of our calls to
run_workqueue()/flush_scheduled_work() can now be replaced by more
targeted calls to cancel_work_sync() and cancel_delayed_work_sync().

Trond

