Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYEJOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYEJOw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYEJOwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 10:52:20 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:35347 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYEJOwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 10:52:18 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 May 2008 10:52:18 EDT
Date: Sat, 10 May 2008 16:42:01 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: linux-kernel@vger.kernel.org
cc: mingo@elte.hu
Subject: Regression caused by bf726e "semaphore: fix"
Message-ID: <Pine.LNX.4.64.0805101615210.3629@titan.stealer.net>
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sat, 10 May 2008 14:42:16 +0000
	Bayes: 0.0000 Tokens: new, 256; hammy, 8; neutral, 1; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
X-Spam-Signature: e091e91a45509b91f04e62f355d60cb7ec856dee
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm currently investigating a regression that has showed up with my last 
git pull yesterday. Bisecting the commits showed bf726e "semaphore: fix" 
to be the culprit, reverting it fixed the issue.

Symptoms: During heavy filesystem usage (e.g. a kernel compile) I get 
several compiler processes in uninterruptible sleep, blocking all i/o on 
the filesystem. System is an Intel Core 2 Quad running a 64bit kernel and 
userspace. Filesystem is xfs on top of lvm. See below for the output of 
sysrq-w.

Sven



   task                        PC stack   pid father
gcc           D ffff81000105c100     0 13923  13913
  ffff8101ed51be18 0000000000000082 ffff8101ed51beb0 00000010802bf7b8
  ffffffff807d7100 ffffffff807d7100 ffffffff807d7100 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d3ca0 ffffffff807d7100
Call Trace:
  [<ffffffff80585ad8>] __mutex_lock_slowpath+0xd8/0x270
  [<ffffffff802bfa81>] ? do_path_lookup+0x91/0x220
  [<ffffffff803d86ba>] ? strncpy_from_user+0x3a/0x50
  [<ffffffff80585c79>] mutex_lock+0x9/0x10
  [<ffffffff802c008a>] do_unlinkat+0xaa/0x1d0
  [<ffffffff80254cf9>] ? up_read+0x9/0x10
  [<ffffffff80589a5c>] ? do_page_fault+0x3ec/0x850
  [<ffffffff802c01c1>] sys_unlink+0x11/0x20
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80

gcc           D ffff810001070100     0 13924  13920
  ffff8101f6971e18 0000000000000082 ffff8101f6971eb0 00000010802bf7b8
  ffffffff807d7100 ffffffff807d7100 ffffffff807d7100 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d3ca0 ffffffff807d7100
Call Trace:
  [<ffffffff80585ad8>] __mutex_lock_slowpath+0xd8/0x270
  [<ffffffff802bfa81>] ? do_path_lookup+0x91/0x220
  [<ffffffff803d86ba>] ? strncpy_from_user+0x3a/0x50
  [<ffffffff80585c79>] mutex_lock+0x9/0x10
  [<ffffffff802c008a>] do_unlinkat+0xaa/0x1d0
  [<ffffffff80254cf9>] ? up_read+0x9/0x10
  [<ffffffff80589a5c>] ? do_page_fault+0x3ec/0x850
  [<ffffffff802c01c1>] sys_unlink+0x11/0x20
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80

gcc           D ffff81000107a100     0 13932  13931
  ffff8101ed447e18 0000000000000086 ffff8101ed447eb0 00000010802bf7b8
  ffffffff807d7100 ffffffff807d7100 ffffffff807d7100 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d3ca0 ffffffff807d7100
Call Trace:
  [<ffffffff80585ad8>] __mutex_lock_slowpath+0xd8/0x270
  [<ffffffff802bfa81>] ? do_path_lookup+0x91/0x220
  [<ffffffff803d86ba>] ? strncpy_from_user+0x3a/0x50
  [<ffffffff80585c79>] mutex_lock+0x9/0x10
  [<ffffffff802c008a>] do_unlinkat+0xaa/0x1d0
  [<ffffffff80254cf9>] ? up_read+0x9/0x10
  [<ffffffff80589a5c>] ? do_page_fault+0x3ec/0x850
  [<ffffffff802c01c1>] sys_unlink+0x11/0x20
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80

sync          D ffff81000105c100     0 13996   9142
  ffff8101ed481d48 0000000000000086 0000000000000000 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d7100 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d3ca0 ffffffff807d7100
Call Trace:
  [<ffffffff80586d79>] __down_read+0x79/0xb7
  [<ffffffff805860a9>] down_read+0x9/0x10
  [<ffffffff80371254>] xfs_ilock+0x44/0x80
  [<ffffffff8038bfb8>] xfs_sync_inodes+0x3e8/0x6b0
  [<ffffffff8038c3de>] xfs_syncsub+0x15e/0x2d0
  [<ffffffff805871f9>] ? _spin_unlock+0x9/0x40
  [<ffffffff8038c594>] xfs_sync+0x44/0x60
  [<ffffffff8039cd07>] xfs_fs_sync_super+0x37/0x100
  [<ffffffff80587309>] ? _spin_unlock_irq+0x9/0x40
  [<ffffffff80586da5>] ? __down_read+0xa5/0xb7
  [<ffffffff803d5946>] ? __up_read+0x46/0xb0
  [<ffffffff802b5c7f>] sync_filesystems+0xdf/0x130
  [<ffffffff802da0e9>] do_sync+0x39/0x80
  [<ffffffff802da13e>] sys_sync+0xe/0x20
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80

gcc           D ffff810001066100     0 14008  14007
  ffff8101f69b5898 0000000000000086 ffff8101fb9e4de0 0000000100000000
  ffffffff807d7100 ffffffff807d7100 ffffffff807d7100 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d3ca0 ffffffff807d7100
Call Trace:
  [<ffffffff802554f6>] ? down_trylock+0x36/0x50
  [<ffffffff805851c5>] schedule_timeout+0x95/0xd0
  [<ffffffff80396d38>] ? xfs_buf_get_flags+0xa8/0x170
  [<ffffffff805861ca>] __down+0x5a/0x90
  [<ffffffff80255605>] down+0x45/0x50
  [<ffffffff8037d152>] xlog_state_get_iclog_space+0xa2/0x200
  [<ffffffff8037d3cc>] xlog_write+0x11c/0x530
  [<ffffffff8037d990>] xfs_log_write+0x40/0x70
  [<ffffffff803897d8>] _xfs_trans_commit+0x2e8/0x3d0
  [<ffffffff802c9f8f>] ? igrab+0x2f/0x50
  [<ffffffff8038fe56>] xfs_create+0x426/0x480
  [<ffffffff8039b00b>] xfs_vn_mknod+0x15b/0x2a0
  [<ffffffff8039b16b>] xfs_vn_create+0xb/0x10
  [<ffffffff802bd688>] vfs_create+0xe8/0x180
  [<ffffffff802c114f>] do_filp_open+0x69f/0x9c0
  [<ffffffff805871f9>] ? _spin_unlock+0x9/0x40
  [<ffffffff802b1e65>] ? get_unused_fd_flags+0x105/0x130
  [<ffffffff802b1eec>] do_sys_open+0x5c/0xf0
  [<ffffffff802b1fab>] sys_open+0x1b/0x20
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80

gcc           D ffff81000105c100     0 14011  14010
  ffff8101ed51fe18 0000000000000082 0000000000000000 00000010802b1704
  ffffffff807d7100 ffffffff807d7100 ffffffff807d7100 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d3ca0 ffffffff807d7100
Call Trace:
  [<ffffffff80585ad8>] __mutex_lock_slowpath+0xd8/0x270
  [<ffffffff802bfa81>] ? do_path_lookup+0x91/0x220
  [<ffffffff803d86ba>] ? strncpy_from_user+0x3a/0x50
  [<ffffffff80585c79>] mutex_lock+0x9/0x10
  [<ffffffff802c008a>] do_unlinkat+0xaa/0x1d0
  [<ffffffff80254cf9>] ? up_read+0x9/0x10
  [<ffffffff80589a5c>] ? do_page_fault+0x3ec/0x850
  [<ffffffff802c01c1>] sys_unlink+0x11/0x20
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80

gcc           D ffff81000107a100     0 14012  13987
  ffff8101ed409e18 0000000000000082 0000000000000000 00000010802b1704
  ffffffff807d7100 ffffffff807d7100 ffffffff807d7100 ffffffff807d7100
  ffffffff807d7100 ffffffff807d7100 ffffffff807d3ca0 ffffffff807d7100
Call Trace:
  [<ffffffff80585ad8>] __mutex_lock_slowpath+0xd8/0x270
  [<ffffffff802bfa81>] ? do_path_lookup+0x91/0x220
  [<ffffffff803d86ba>] ? strncpy_from_user+0x3a/0x50
  [<ffffffff80585c79>] mutex_lock+0x9/0x10
  [<ffffffff802c008a>] do_unlinkat+0xaa/0x1d0
  [<ffffffff80254cf9>] ? up_read+0x9/0x10
  [<ffffffff80589a5c>] ? do_page_fault+0x3ec/0x850
  [<ffffffff802c01c1>] sys_unlink+0x11/0x20
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80
