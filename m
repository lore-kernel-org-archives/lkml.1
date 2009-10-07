Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbZJGDFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbZJGDFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZJGDFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:05:42 -0400
Received: from lo.gmane.org ([80.91.229.12]:56672 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZJGDFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:05:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Neumann <tneumann@users.sourceforge.net>
Subject: deadlock with fallocate
Followup-To: gmane.linux.kernel
Date: Wed, 07 Oct 2009 05:00:36 +0200
Message-ID: <hah08m$p1a$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-76-22-14-176.hsd1.wa.comcast.net
User-Agent: KNode/4.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under 2.6.32rc1 I observe a very annoying deadlock in fallocate calls with 
XFS. When running a very I/O intensive workload (using posix_fallocate and a 
lot of mmaps) the kernel deadlocks semi-reproducible (ca. 60% of the time). 
I included an excerpt from dmesg below, but I am not sure how useful it is 
for debugging.
Is there any way to isolate the problem? Unfortunately it is not 100% 
reproducible and it takes a while to reach the deadlock.

[36600.700131] INFO: task xfsconvertd/0:411 blocked for more than 120 
seconds.
[36600.700138] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[36600.700143] xfsconvertd/0 D 0000000000000000     0   411      2 
0x00000000
[36600.700153]  ffff88007b21d3e0 0000000000000046 ffff88007d4e8c40 
ffff88007b21dfd8
[36600.700163]  ffff88007adfdb40 0000000000015980 0000000000015980 
ffff88007b21dfd8
[36600.700171]  0000000000015980 ffff88007b21dfd8 0000000000015980 
ffff88007adfdf00
[36600.700180] Call Trace:
[36600.700195]  [<ffffffff81526162>] io_schedule+0x42/0x60
[36600.700204]  [<ffffffff810df6d5>] sync_page+0x35/0x50
[36600.700211]  [<ffffffff815268e5>] __wait_on_bit+0x55/0x80
[36600.700218]  [<ffffffff810df6a0>] ? sync_page+0x0/0x50
[36600.700225]  [<ffffffff810df7f0>] wait_on_page_bit+0x70/0x80
[36600.700233]  [<ffffffff8107afb0>] ? wake_bit_function+0x0/0x30
[36600.700242]  [<ffffffff810ecce8>] shrink_page_list+0x3d8/0x550
[36600.700249]  [<ffffffff8107b0de>] ? finish_wait+0x5e/0x80
[36600.700258]  [<ffffffff810f85da>] ? congestion_wait+0x7a/0x90
[36600.700265]  [<ffffffff8107af70>] ? autoremove_wake_function+0x0/0x40
[36600.700273]  [<ffffffff810ed7e6>] shrink_inactive_list+0x6b6/0x700
[36600.700281]  [<ffffffff81044250>] ? wake_affine+0x220/0x240
[36600.700289]  [<ffffffff81048210>] ? __enqueue_entity+0x80/0x90
[36600.700296]  [<ffffffff810ed881>] shrink_list+0x51/0xb0
[36600.700303]  [<ffffffff810eddea>] shrink_zone+0x1ea/0x200
[36600.700311]  [<ffffffff810ee823>] shrink_zones+0x63/0xf0
[36600.700318]  [<ffffffff810ee920>] do_try_to_free_pages+0x70/0x280
[36600.700325]  [<ffffffff810eec9c>] try_to_free_pages+0x9c/0xc0
[36600.700332]  [<ffffffff810ed0e0>] ? isolate_pages_global+0x0/0x50
[36600.700340]  [<ffffffff810e6342>] __alloc_pages_slowpath+0x232/0x520
[36600.700347]  [<ffffffff810e6776>] __alloc_pages_nodemask+0x146/0x180
[36600.700355]  [<ffffffff811143f7>] alloc_pages_current+0x87/0xd0
[36600.700363]  [<ffffffff8111939c>] allocate_slab+0x11c/0x1b0
[36600.700369]  [<ffffffff8111945b>] new_slab+0x2b/0x190
[36600.700376]  [<ffffffff8111b641>] __slab_alloc+0x121/0x230
[36600.700422]  [<ffffffffa009b57d>] ? kmem_zone_alloc+0x5d/0xd0 [xfs]
[36600.700452]  [<ffffffffa009b57d>] ? kmem_zone_alloc+0x5d/0xd0 [xfs]
[36600.700459]  [<ffffffff8111b980>] kmem_cache_alloc+0xf0/0x130
[36600.700489]  [<ffffffffa009b57d>] kmem_zone_alloc+0x5d/0xd0 [xfs]
[36600.700519]  [<ffffffffa009b609>] kmem_zone_zalloc+0x19/0x50 [xfs]
[36600.700550]  [<ffffffffa009368f>] _xfs_trans_alloc+0x2f/0x70 [xfs]
[36600.700580]  [<ffffffffa0093832>] xfs_trans_alloc+0x92/0xa0 [xfs]
[36600.700588]  [<ffffffff810f7710>] ? __dec_zone_page_state+0x30/0x40
[36600.700619]  [<ffffffffa0083691>] xfs_iomap_write_unwritten+0x71/0x200 
[xfs]
[36600.700627]  [<ffffffff810e1ad2>] ? mempool_free_slab+0x12/0x20
[36600.700634]  [<ffffffff810e1b6a>] ? mempool_free+0x8a/0xa0
[36600.700663]  [<ffffffffa009c3d0>] ? xfs_end_bio_unwritten+0x0/0x80 [xfs]
[36600.700692]  [<ffffffffa009c435>] xfs_end_bio_unwritten+0x65/0x80 [xfs]
[36600.700701]  [<ffffffff81075c47>] run_workqueue+0xb7/0x190
[36600.700707]  [<ffffffff81076fa6>] worker_thread+0x96/0xf0
[36600.700714]  [<ffffffff8107af70>] ? autoremove_wake_function+0x0/0x40
[36600.700721]  [<ffffffff81076f10>] ? worker_thread+0x0/0xf0
[36600.700727]  [<ffffffff8107ab8e>] kthread+0x8e/0xa0
[36600.700735]  [<ffffffff81012f8a>] child_rip+0xa/0x20
[36600.700742]  [<ffffffff8107ab00>] ? kthread+0x0/0xa0
[36600.700748]  [<ffffffff81012f80>] ? child_rip+0x0/0x20
[36600.700784] INFO: task dataload:3947 blocked for more than 120 seconds.
[36600.700788] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[36600.700792] dataload     D 0000000000000001     0  3947   2121 0x00000000
[36600.700801]  ffff880074f37ce8 0000000000000082 0000000000000086 
ffff880074f37fd8
[36600.700810]  ffff88007b0316d0 0000000000015980 0000000000015980 
ffff880074f37fd8
[36600.700818]  0000000000015980 ffff880074f37fd8 0000000000015980 
ffff88007b031a90
[36600.700826] Call Trace:
[36600.700859]  [<ffffffffa009c0e5>] xfs_ioend_wait+0x85/0xc0 [xfs]
[36600.700868]  [<ffffffff8107af70>] ? autoremove_wake_function+0x0/0x40
[36600.700899]  [<ffffffffa0097d1d>] xfs_setattr+0x85d/0xb20 [xfs]
[36600.700930]  [<ffffffffa0094aa8>] ? xfs_trans_unlocked_item+0x38/0x50 
[xfs]
[36600.700960]  [<ffffffffa00a2ebd>] xfs_vn_fallocate+0xed/0x100 [xfs]
[36600.700968]  [<ffffffff810334a9>] ? default_spin_lock_flags+0x9/0x10
[36600.700976]  [<ffffffff81527ecf>] ? _spin_lock_irqsave+0x2f/0x50
[36600.700984]  [<ffffffff8112556d>] do_fallocate+0xfd/0x110
[36600.700990]  [<ffffffff811255c9>] sys_fallocate+0x49/0x70
[36600.700998]  [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b

I have also opened a bug here

http://oss.sgi.com/bugzilla/show_bug.cgi?id=852


