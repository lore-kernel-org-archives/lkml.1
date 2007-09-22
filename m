Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbXIVMIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbXIVMIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 08:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXIVMIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 08:08:38 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:4640 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbXIVMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 08:08:38 -0400
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
From: richard kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070921033336.c327ffd9.akpm@linux-foundation.org>
References: <46B10BB7.60900@redhat.com>
	 <20070803113407.0b04d44e.akpm@linux-foundation.org>
	 <20070804084426.GA20464@kobayashi-maru.wspse.de>
	 <20070809095943.GA7763@kobayashi-maru.wspse.de>
	 <20070809095534.25ae1c42.akpm@linux-foundation.org>
	 <46F2E103.8000907@redhat.com>
	 <20070920142927.d87ab5af.akpm@linux-foundation.org>
	 <46F2EE76.4000203@redhat.com>
	 <20070920153654.b9e90616.akpm@linux-foundation.org>
	 <1190370341.3121.35.camel@castor.rsk.org>
	 <20070921033336.c327ffd9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 13:08:35 +0100
Message-Id: <1190462915.3156.5.camel@castor.rsk.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 03:33 -0700, Andrew Morton wrote:
> On Fri, 21 Sep 2007 11:25:41 +0100 richard kennedy <richard@rsk.demon.co.uk> wrote:
> 
> > > That's all a bit crappy if the wrong races happen and some other task is
> > > somehow exceeding the dirty limits each time this task polls them.  Seems
> > > unlikely that such a condition would persist forever.
> > > 
> > > So the question is, why do we have large amounts of dirty pages for one
> > > disk which appear to be sitting there not getting written?
> > 
> > The lockup I'm seeing intermittently occurs when I have 2+ tasks copying
> > large files (1Gb+) on sda & a small read-mainly mysql db app running on
> > sdb. The lockup seems to happen just after the copies finish -- there
> > are lots of dirty pages but nothing left to write them until kupdate
> > gets round to it. 
> 
> Then what happens?  The system recovers?
when my system is locked up I get this from sysrq-w
(2.6.23-rc7)

SysRq : Show Blocked State
auditd        D ffff8100b422fd28     0  1999      1
 ffff8100b422fd78 0000000000000086 0000000000000000 ffff8100b4103020
 0000000000000286 ffff8100b4103020 ffff8100bf8af020 ffff8100b41032b8
 0000000100000000 0000000000000001 ffffffffffffffff 0000000000000003
Call Trace:
 [<ffffffff8802c8e9>] :jbd:log_wait_commit+0xa3/0xf5
 [<ffffffff810482d9>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8802770b>] :jbd:journal_stop+0x1be/0x1ee
 [<ffffffff810a79f7>] __writeback_single_inode+0x1f4/0x332
 [<ffffffff8108c0b0>] vfs_statfs_native+0x29/0x34
 [<ffffffff810a8362>] sync_inode+0x24/0x36
 [<ffffffff8803c350>] :ext3:ext3_sync_file+0xb4/0xc8
 [<ffffffff81240730>] mutex_lock+0x1e/0x2f
 [<ffffffff810aa7fa>] do_fsync+0x52/0xa4
 [<ffffffff810aa86f>] __do_fsync+0x23/0x36
 [<ffffffff8100bc8e>] system_call+0x7e/0x83

syslogd       D ffff8100b3f67d28     0  2022      1
 ffff8100b3f67d78 0000000000000086 0000000000000000 0000000100000000
 0000000000000003 ffff810037c66810 ffff8100bf8af020 ffff810037c66aa8
 0000000100000000 0000000000000001 ffffffffffffffff 0000000000000003
Call Trace:
 [<ffffffff8802c8e9>] :jbd:log_wait_commit+0xa3/0xf5
 [<ffffffff810482d9>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8802770b>] :jbd:journal_stop+0x1be/0x1ee
 [<ffffffff810a79f7>] __writeback_single_inode+0x1f4/0x332
 [<ffffffff810a8362>] sync_inode+0x24/0x36
 [<ffffffff8803c350>] :ext3:ext3_sync_file+0xb4/0xc8
 [<ffffffff81240730>] mutex_lock+0x1e/0x2f
 [<ffffffff810aa7fa>] do_fsync+0x52/0xa4
 [<ffffffff810aa86f>] __do_fsync+0x23/0x36
 [<ffffffff8100be0c>] tracesys+0xdc/0xe1


