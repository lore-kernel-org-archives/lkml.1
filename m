Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYHQT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYHQT3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYHQT27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:28:59 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41836 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYHQT25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:28:57 -0400
Date: Sun, 17 Aug 2008 22:26:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, Greg Donald <gdonald@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: INFO: task blocked for more than 120 seconds
Message-ID: <20080817192644.GE24619@cs181140183.pp.htv.fi>
References: <20080811112712.f858d77c.randy.dunlap@oracle.com> <20080812181735.GA6476@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080812181735.GA6476@skywalker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 11:47:35PM +0530, Aneesh Kumar K.V wrote:
> On Mon, Aug 11, 2008 at 11:27:12AM -0700, Randy Dunlap wrote:
> > On 2.6.27-rc2-git4 and several previous kernels, I see several
> > of these messages.  E.g.:
> > 
> > INFO: task kjournald:665 blocked for more than 120 seconds.
> > INFO: task stress:17797 blocked for more than 120 seconds.
> > INFO: task stress:17805 blocked for more than 120 seconds.
> > 
> > 
> > Has anyone tracked this down?  Should I attempt to bisect it?
> > (on x86_64, SMP, 8 GB RAM)
> > 
> > 
> > 
> > INFO: task kjournald:665 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > kjournald     D ffff88027e04be30  4592   665      2
> >  ffff88027e04bdd0 0000000000000046 ffff88027e04bd90 ffffffff8022b5f8
> >  ffff88027e703090 ffff880178c91bc0 ffff88027e7033d0 0000000178c91c08
> >  ffff88027e04bdb0 ffff88027e04be30 ffff88017eaf80f0 0000000000000246
> > Call Trace:
> >  [<ffffffff8022b5f8>] ? __wake_up_common+0x41/0x74
> >  [<ffffffff802f6eef>] journal_commit_transaction+0xe9/0xd7e
> >  [<ffffffff8023db06>] ? lock_timer_base+0x26/0x4a
> >  [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
> >  [<ffffffff8023db80>] ? try_to_del_timer_sync+0x56/0x62
> >  [<ffffffff802fa388>] kjournald+0xc3/0x1fb
> >  [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
> >  [<ffffffff802fa2c5>] ? kjournald+0x0/0x1fb
> >  [<ffffffff80247107>] kthread+0x49/0x76
> >  [<ffffffff8020ce39>] child_rip+0xa/0x11
> >  [<ffffffff802470be>] ? kthread+0x0/0x76
> >  [<ffffffff8020ce2f>] ? child_rip+0x0/0x11
> > 
> > INFO: task stress:17797 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > stress        D ffff88017eaf8024  5088 17797  17795
> >  ffff8801f4055cd8 0000000000000082 0000000000000086 ffff88027e04bec0
> >  ffff880178c93090 ffff88017faf75f0 ffff880178c933d0 0000000300000001
> >  0000000000000292 ffff8801f4055ce8 ffff88017eaf80a8 0000000000000246
> > Call Trace:
> >  [<ffffffff802f9c04>] log_wait_commit+0xa4/0xf4
> >  [<ffffffff80247240>] ? autoremove_wake_function+0x0/0x38
> >  [<ffffffff802f5798>] journal_stop+0x17c/0x1a9
> >  [<ffffffff802f5fe6>] journal_force_commit+0x23/0x25
> >  [<ffffffff802eee53>] ext3_force_commit+0x26/0x28
> >  [<ffffffff802e91d2>] ext3_write_inode+0x39/0x3f
> >  [<ffffffff802b58cf>] __writeback_single_inode+0x180/0x284
> >  [<ffffffff80247278>] ? wake_bit_function+0x0/0x2a
> >  [<ffffffff802b5db1>] generic_sync_sb_inodes+0x1c3/0x29e
> >  [<ffffffff802b5e95>] sync_sb_inodes+0x9/0xb
> >  [<ffffffff802b5f2c>] sync_inodes_sb+0x95/0x9c
> >  [<ffffffff802b5f95>] __sync_inodes+0x62/0xaf
> >  [<ffffffff802b6010>] sync_inodes+0x2e/0x33
> >  [<ffffffff802b8908>] do_sync+0x34/0x59
> >  [<ffffffff802b893b>] sys_sync+0xe/0x13
> >  [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b
> > 
> 
> Committing a transaction would means writing rest of the meta-data in
> the transaction. And that would imply forcing most of the buffer_heads
> to disk in ordered mode. This can result a lot of seeks and make take
> more thatn 120 seconds.


Both Randy and Greg reported getting this for 2.6.27-rc but not
for 2.6.26.

Why are people getting such messages for 2.6.27-rc but not for 2.6.26?


> -aneesh

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

