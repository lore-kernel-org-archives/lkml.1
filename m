Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbXHCRT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbXHCRT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbXHCRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:19:48 -0400
Received: from mail.screens.ru ([213.234.233.54]:48311 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbXHCRTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:19:47 -0400
Date: Fri, 3 Aug 2007 21:21:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Neil Brown <neilb@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] 2.6.23-rc1-mm2
Message-ID: <20070803172137.GA3783@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de> <20070803093830.39852a01.akpm@linux-foundation.org> <1186160608.7255.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186160608.7255.10.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Trond Myklebust wrote:
>
> On Fri, 2007-08-03 at 09:38 -0700, Andrew Morton wrote:
> > > stack backtrace:
> > >  [<c0104fda>] show_trace_log_lvl+0x1a/0x30
> > >  [<c0105c02>] show_trace+0x12/0x20
> > >  [<c0105d15>] dump_stack+0x15/0x20
> > >  [<c013ee42>] __lock_acquire+0xc22/0x1030
> > >  [<c013f2b1>] lock_acquire+0x61/0x80
> > >  [<c012edd9>] flush_workqueue+0x49/0x70
> > >  [<c012ee0d>] flush_scheduled_work+0xd/0x10
> > >  [<dcf55c0c>] nfs_release_automount_timer+0x2c/0x30 [nfs]
> > >  [<dcf45d8e>] nfs_free_server+0x9e/0xd0 [nfs]
> > >  [<dcf4e626>] nfs_kill_super+0x16/0x20 [nfs]
> > >  [<c017b38d>] deactivate_super+0x7d/0xa0
> > >  [<c018f94b>] mntput_no_expire+0x4b/0x80
> > >  [<c018fd94>] expire_mount_list+0xe4/0x140
> > >  [<c0191219>] mark_mounts_for_expiry+0x99/0xb0
> > >  [<dcf55d1d>] nfs_expire_automounts+0xd/0x40 [nfs]
> > >  [<c012e61b>] run_workqueue+0x12b/0x1e0
> > >  [<c012f05b>] worker_thread+0x9b/0x100
> > >  [<c0131c72>] kthread+0x42/0x70
> > >  [<c0104c0f>] kernel_thread_helper+0x7/0x18
> > >  =======================
> > > 
> > 
> > There is new debugging stuff in -mm: deadlockable usage of workqueue
> > primitives will now trigger lockdep warnings.  See
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/broken-out/workqueue-debug-flushing-deadlocks-with-lockdep.patch
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/broken-out/workqueue-debug-work-related-deadlocks-with-lockdep.patch
> > 
> > I am suspecting that running flush_scheduled_work() from within run_workqueue()
> > isn't good.
> 
> I'll have a look at this. I suspect that most if not all of our calls to
> run_workqueue()/flush_scheduled_work() can now be replaced by more
> targeted calls to cancel_work_sync() and cancel_delayed_work_sync().

Yes, please, if possible.

To avoid a possible confusion: it is still OK if work->func() flushes
its own workqueue, so strictly speaking this trace is false positive,
but it would be very nice if we can get rid of this practice.

Oleg.

