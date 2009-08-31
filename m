Return-Path: <linux-kernel-owner+w=401wt.eu-S1751543AbZHaWBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbZHaWBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 18:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZHaWBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 18:01:37 -0400
Received: from server1.wserver.cz ([82.113.45.157]:58060 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZHaWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 18:01:37 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/1] hw_breakpoints: fix locking in load_debug_registers
Date: Tue,  1 Sep 2009 00:01:38 +0200
Message-Id: <1251756098-22852-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

load_debug_registers is called with interrupts disabled from
many contexts and causes a warning to be dropped, e.g.:
------------[ cut here ]------------
WARNING: at kernel/softirq.c:143 local_bh_enable_ip+0x75/0xa0()
Hardware name: To Be Filled By O.E.M.
Modules linked in: nfs lockd auth_rpcgss sunrpc ath5k ath
Pid: 15083, comm: pm-suspend Tainted: G        W  2.6.31-rc7-mm1_64 #687
Call Trace:
 [<ffffffff8103f6c8>] warn_slowpath_common+0x78/0xb0
 [<ffffffff8103f70f>] warn_slowpath_null+0xf/0x20
 [<ffffffff81045875>] local_bh_enable_ip+0x75/0xa0
 [<ffffffff8142feff>] _spin_unlock_bh+0xf/0x20
 [<ffffffff81089141>] load_debug_registers+0x51/0x60
 [<ffffffff8134fa93>] restore_processor_state+0x1b3/0x240
 [<ffffffff8119ba54>] acpi_suspend_enter+0x56/0xaf
 [<ffffffff8106e66d>] suspend_devices_and_enter+0x14d/0x1a0
 [<ffffffff8106e79b>] enter_state+0xdb/0xf0
 [<ffffffff8106ded1>] state_store+0x91/0x100
 [<ffffffff8116ac77>] kobj_attr_store+0x17/0x20
 [<ffffffff8111b2e0>] sysfs_write_file+0xe0/0x160
 [<ffffffff810c33e8>] vfs_write+0xb8/0x1b0
 [<ffffffff81432735>] ? do_page_fault+0x185/0x350
 [<ffffffff810c3a4c>] sys_write+0x4c/0x80
 [<ffffffff8100beeb>] system_call_fastpath+0x16/0x1b
---[ end trace fc3dd2304adb23aa ]---

Fix it by switching from spin_lock_bh to spin_lock_irqsave and
removing nested local_irq_save.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hw_breakpoint.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index c1f64e6..bc5368d 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -80,17 +80,15 @@ void load_debug_registers(void)
 	unsigned long flags;
 	struct task_struct *tsk = current;
 
-	spin_lock_bh(&hw_breakpoint_lock);
+	spin_lock_irqsave(&hw_breakpoint_lock, flags);
 
 	/* Prevent IPIs for new kernel breakpoint updates */
-	local_irq_save(flags);
 	arch_update_kernel_hw_breakpoint(NULL);
-	local_irq_restore(flags);
 
 	if (test_tsk_thread_flag(tsk, TIF_DEBUG))
 		arch_install_thread_hw_breakpoint(tsk);
 
-	spin_unlock_bh(&hw_breakpoint_lock);
+	spin_unlock_irqrestore(&hw_breakpoint_lock, flags);
 }
 
 /*
-- 
1.6.3.3

