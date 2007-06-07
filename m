Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXFGGTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXFGGTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXFGGTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:19:04 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:26628 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXFGGTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=U14MrsoDuNb3hlsfUaSizq6jm+V7zkBMTqcuq98FwEKqrxxJq5OuNikCQU7ZL8806j6VVGeamIBSosONhzI9YBVkPnmUVRKtAdxtd4xOvLV6zAwjWiCqVYLFFZlaEmzsRNt6bsWQQoUvn65VSEA/A+UplfpAa5AbhI9vGGmXD6Q=
Message-ID: <e9f486400706062319h2ac76e7td4b300deb49b3569@mail.gmail.com>
Date: Thu, 7 Jun 2007 08:19:00 +0200
From: "Henri Hunnekens" <henrihunnekens@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       unionfs@filer.fsl.cs.sunysb.edu
Subject: BUG: Unionfs 2.0 on kernel version 2.6.20-rt8 reports: circular locking deadlock detected during boot.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

============================================
[ BUG: circular locking deadlock detected! ]
--------------------------------------------
udev_run_hotplu/720 is deadlocking current task modprobe/690


1) modprobe/690 is trying to acquire this lock:
 [f7019558] {&info->lock}
.. ->owner: f6e52032
.. held by:   udev_run_hotplu:  720 [f6e52030, 121]

2) udev_run_hotplu/720 is blocked on this lock:
 [c2718348] {(struct rw_semaphore *)(&((struct unionfs_sb_info *)(sb)->s_fs_info
)->rwsem)}
.. ->owner: f6d9d932
.. held by:          modprobe:  690 [f6d9d930, 120]

udev_run_hotplu/720's [blocked] stackdump:

       f6e5fe38 00000086 ffa94000 c0542500 c2718358 f6d45d50 c2718358 f6e5fdc4
       00000283 f6e5fe08 c0142382 f6e5fe70 f6e5fde0 c02b4056 00000001 f6e52148
       f6e52030 c060ed2b 00000007 0000078c c23edda0 00000000 00000001 00000001
Call Trace:
 [<c043760e>] schedule+0x2e/0x110
 [<c04386fd>] rt_mutex_slowlock+0xcd/0x29c
 [<c0438489>] rt_mutex_lock+0x19/0x20
 [<c014334e>] __rt_down_read+0x2e/0x50
 [<c014338a>] rt_down_read+0xa/0x10
 [<c02778f8>] unionfs_show_options+0xd8/0x150
 [<c018c3f5>] show_vfsmnt+0x115/0x130
 [<c018eda7>] seq_read+0x157/0x290
 [<c01741df>] vfs_read+0xaf/0x180
 [<c017473d>] sys_read+0x3d/0x70
 [<c0105260>] sysenter_past_esp+0x5d/0x81
 =======================

modprobe/690's [current] stackdump:

 [<c01062aa>] show_trace_log_lvl+0x1a/0x30
 [<c0106972>] show_trace+0x12/0x20
 [<c0106a46>] dump_stack+0x16/0x20
 [<c01430fc>] debug_rt_mutex_print_deadlock+0x14c/0x160
 [<c04386f1>] rt_mutex_slowlock+0xc1/0x29c
 [<c0438489>] rt_mutex_lock+0x19/0x20
 [<c0438d08>] _mutex_lock+0x8/0x10
 [<c027925a>] create_parents_named+0x13a/0x5b0
 [<c02797ab>] copyup_named_dentry+0xbb/0xb70
 [<c027a29a>] copyup_dentry+0x3a/0x50
 [<c027a2eb>] copyup_file+0x3b/0xa0
 [<c027d268>] unionfs_file_revalidate+0x728/0xbe0
 [<c027d756>] unionfs_flush+0x36/0x140
 [<c0171fbc>] filp_close+0x2c/0x70
 [<c01731e9>] sys_close+0x69/0xc0
 [<c0105260>] sysenter_past_esp+0x5d/0x81
 =======================
[ turning off deadlock detection.Please report this trace. ]
