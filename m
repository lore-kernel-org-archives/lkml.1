Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZDWNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZDWNMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZDWNMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:12:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40649 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbZDWNMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=sUFSQ2sheL0BBaFoB9qTjdRo6SSmEsMT8DB2uE35zAbvi1x1aWuQawR7i0CrY+7W+l
         47FXMI1kp7SITvGxf9Oca7x1vsvglCv8yNaGtV6KvcFEoun2swno42Zu71F3U7omp2CQ
         NilPDTtKnV+em3Vi3UEyXrHG095iSaCnCjZF4=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH -tip] md: Avoid to call flush_scheduled_work() with BKL held
Date: Thu, 23 Apr 2009 15:11:53 +0200
Message-Id: <1240492313-6560-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: =?ISO-8859-1?Q?=20<=1B[5~>?=
References: =?ISO-8859-1?Q?=20<=1B[5~>?=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    1.479872] ------------[ cut here ]------------
[    1.483391] WARNING: at kernel/workqueue.c:408 flush_workqueue+0x7b/0x11f()
[    1.489948] Hardware name:
[    1.491779] Modules linked in:
[    1.493306] Pid: 1, comm: swapper Not tainted 2.6.30-rc1 #67
[    1.495767] Call Trace:
[    1.496974]  [<ffffffff810451a4>] warn_slowpath+0xd8/0x10c
[    1.503432]  [<ffffffff810176d1>] ? save_stack_trace+0x2f/0x4d
[    1.509724]  [<ffffffff8106983d>] ? mark_lock+0x22/0x22c
[    1.515412]  [<ffffffff8106b364>] ? __lock_acquire+0xc36/0xc45
[    1.521448]  [<ffffffff81069e9b>] ? debug_check_no_locks_freed+0x120/0x12f
[    1.525189]  [<ffffffff8106874c>] ? get_lock_stats+0x19/0x4c
[    1.527172]  [<ffffffff810687a7>] ? put_lock_stats+0x28/0x33
[    1.533316]  [<ffffffff81056d7f>] flush_workqueue+0x7b/0x11f
[    1.539224]  [<ffffffff8139ffe8>] ? mddev_find+0xe2/0x2e5
[    1.544826]  [<ffffffff81056e38>] flush_scheduled_work+0x15/0x17
[    1.551262]  [<ffffffff813a0239>] md_alloc+0x4e/0x2b0
[    1.556505]  [<ffffffff813a04ab>] md_probe+0x10/0x14
[    1.561939]  [<ffffffff812c6a90>] kobj_lookup+0x150/0x194
[    1.566607]  [<ffffffff813a049b>] ? md_probe+0x0/0x14
[    1.570519]  [<ffffffff811f6f3c>] get_gendisk+0x30/0xc1
[    1.573948]  [<ffffffff81105821>] __blkdev_get+0x3a/0x338
[    1.577537]  [<ffffffff81105b31>] ? blkdev_open+0x0/0xab
[    1.581293]  [<ffffffff81105b2f>] blkdev_get+0x10/0x12
[    1.584922]  [<ffffffff81105ba7>] blkdev_open+0x76/0xab
[    1.588661]  [<ffffffff810dd7fa>] __dentry_open+0x194/0x2b9
[    1.592615]  [<ffffffff810dd9f6>] nameidata_to_filp+0x46/0x57
[    1.596730]  [<ffffffff810e9f8f>] do_filp_open+0x417/0x83e
[    1.600651]  [<ffffffff8106874c>] ? get_lock_stats+0x19/0x4c
[    1.604597]  [<ffffffff810f3fe7>] ? alloc_fd+0x122/0x133
[    1.608424]  [<ffffffff810dd59a>] do_sys_open+0x58/0xd8
[    1.612233]  [<ffffffff810dd64d>] sys_open+0x20/0x22
[    1.615671]  [<ffffffff818a94f1>] md_run_setup+0x64/0x8e
[    1.619496]  [<ffffffff818a8251>] prepare_namespace+0x3a/0x19d
[    1.623239]  [<ffffffff818a765e>] kernel_init+0x16e/0x17e
[    1.626923]  [<ffffffff8100cf3a>] child_rip+0xa/0x20
[    1.629504]  [<ffffffff8103ba79>] ? finish_task_switch+0x40/0xe8
[    1.642356]  [<ffffffff8100c900>] ? restore_args+0x0/0x30
[    1.643802]  [<ffffffff818a74f0>] ? kernel_init+0x0/0x17e
[    1.645276]  [<ffffffff8100cf30>] ? child_rip+0x0/0x20
[    1.648839] ---[ end trace 6fa921fb3766f01d ]---

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/md/md.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ed5727c..e6c039c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -45,6 +45,7 @@
 #include <linux/reboot.h>
 #include <linux/file.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
 #include "md.h"
@@ -3830,6 +3831,7 @@ static int md_alloc(dev_t dev, char *name)
 	int shift;
 	int unit;
 	int error;
+	int bkl = kernel_locked();
 
 	if (!mddev)
 		return -ENODEV;
@@ -3841,7 +3843,11 @@ static int md_alloc(dev_t dev, char *name)
 	/* wait for any previous instance if this device
 	 * to be completed removed (mddev_delayed_delete).
 	 */
+	if (bkl)
+		unlock_kernel();
 	flush_scheduled_work();
+	if (bkl)
+		lock_kernel();
 
 	mutex_lock(&disks_mutex);
 	if (mddev->gendisk) {
-- 
1.6.0.4

