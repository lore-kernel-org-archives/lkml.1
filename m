Return-Path: <linux-kernel-owner+w=401wt.eu-S934594AbZHEPG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbZHEPG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934538AbZHEPGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:06:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519AbZHEPGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:06:24 -0400
Date: Wed, 5 Aug 2009 11:06:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: neilb@suse.de
Subject: 2.6.31-rc5-git2 MD raid regression
Message-ID: <20090805150620.GA21335@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems this commit is the cause of a deadlock during MD raid0 creation:
449aad3e25358812c43afc60918c5ad3819488e7

The mdadm --create command was invoked by a test that was recently added
to the LVM2 testsuite:
http://sources.redhat.com/git/?p=lvm2.git;a=commit;h=0d15d01b45

I started seeing the following with rawhide kernel
2.6.31-0.122.rc5.git2.fc12:

md: bind<dm-0>
md: bind<dm-1>
md: raid0 personality registered for level 0
raid0: looking at dm-1
raid0:   comparing dm-1(67456)
 with dm-1(67456)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at dm-0
raid0:   comparing dm-0(67456)
 with dm-1(67456)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 134912 sectors.
******* md127 configuration *********
zone0=[dm-0/dm-1/]
        zone offset=0kb device offset=0kb size=67456kb
**********************************

INFO: task mdadm:1132 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mdadm         D 0000000000000000  4408  1132   1072 0x00000080
 ffff88000fc27938 0000000000000086 ffff88001ec17790 0000000000000001
 ffff88001032c940 0000000000000007 0000000000000006 ffff88001ec17728
 ffff88001032cd30 000000000000fa20 ffff88001032cd30 00000000001d5bc0
Call Trace:
 [<ffffffff814fb066>] ? __mutex_lock_common+0x20e/0x3bf
 [<ffffffff81096566>] ? trace_hardirqs_on_caller+0x139/0x175
 [<ffffffff8116ed39>] ? revalidate_disk+0x5e/0x9d
 [<ffffffff814fb076>] __mutex_lock_common+0x21e/0x3bf
 [<ffffffff8116ed39>] ? revalidate_disk+0x5e/0x9d
 [<ffffffff814fb33a>] mutex_lock_nested+0x4f/0x6b
 [<ffffffff8116ed39>] revalidate_disk+0x5e/0x9d
 [<ffffffff813f34de>] do_md_run+0x886/0x92f
 [<ffffffff814fb266>] ? mutex_lock_interruptible_nested+0x4f/0x6a
 [<ffffffff813f5e40>] md_ioctl+0x11b6/0x142b
 [<ffffffff81038983>] ? pvclock_clocksource_read+0x56/0xa6
 [<ffffffff81095fcb>] ? mark_lock+0x3c/0x253
 [<ffffffff81263f2a>] __blkdev_driver_ioctl+0x36/0x95
 [<ffffffff812648ad>] blkdev_ioctl+0x8d6/0x925
 [<ffffffff8122bafe>] ? __rcu_read_unlock+0x34/0x4a
 [<ffffffff8122caa8>] ? avc_has_perm_noaudit+0x3c9/0x3ef
 [<ffffffff8122cb39>] ? avc_has_perm+0x6b/0x91
 [<ffffffff81094991>] ? lock_release_holdtime+0x3f/0x146
 [<ffffffff8116e5cc>] block_ioctl+0x4a/0x62
 [<ffffffff81150e1b>] vfs_ioctl+0x31/0xaa
 [<ffffffff811513dd>] do_vfs_ioctl+0x4aa/0x506
 [<ffffffff8115149e>] sys_ioctl+0x65/0x9c
 [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
2 locks held by mdadm/1132:
 #0:  (&new->reconfig_mutex#2){+.+.+.}, at: [<ffffffff813edbbb>] mddev_lock+0x2a/0x40
 #1:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8116ed39>] revalidate_disk+0x5e/0x9d
