Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYLWDYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYLWDYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 22:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYLWDYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 22:24:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:64925 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbYLWDYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 22:24:08 -0500
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 0/1] fix EDAC core deadlock when removes an edac device 
Date: Tue, 23 Dec 2008 11:13:47 +0800
Message-Id: <1230002028-13362-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 23 Dec 2008 03:25:09.0178 (UTC) FILETIME=[0EC701A0:01C964AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When deleting an edac device, we have to wait for its edac_dev.work to
be completed before deleting the whole edac_dev structure. Since
we have no idea which work in current edac_poller's workqueue is the
work we are conerned about, we wait for all work in the edac_poller's
workqueue to be proceseed. This is done via flush_cpu_workqueue() which
inserts a wq_barrier into the tail of the workqueue and then
sleeping on the completion of this wq_barrier. The edac_poller will
wake up sleepers when it is found.

EDAC core creates only one kernel worker thread, edac_poller, to run the
works of all current edac devices. They share the same callback function of
edac_device_workq_function(), which would grab the mutex of device_ctls_mutex
first before it checks the device. This is exactly where edac_poller and rmmod
would have a great chance to deadlock.

In below call trace of rmmod > ... >
edac_device_del_device >
edac_device_workq_teardown > flush_workqueue > flush_cpu_workqueue,

device_ctls_mutex would have already been grabbed by edac_device_del_device().
So, on one hand rmmod would sleep on the completion of a wq_barrier, holding
device_ctls_mutex; on the other hand edac_poller would be blocked on the same
mutex when it's running any one of works of existing edac evices(Note, this
edac_dev.work is likely to be totally irrelevant to the one that is being
removed right now)and never would have a chance to run the work of above
wq_barrier to wake rmmod up.

edac_device_workq_teardown() should not be called within the critical region
of device_ctls_mutex. Just like is done in edac_pci_del_device() and 
edac_mc_del_mc(), where edac_pci_workq_teardown() and edac_mc_workq_teardown()
are called after related mutex are released.

Moreover, an edac_dev.work should check first if it is being removed. 
If this is the case, then it should bail out immediately.  Since not all of
existing edac devices are to be removed, this "shutting flag" should be 
contained to edac device being removed. The current edac_dev.op_state
can be used to serve this purpose.

The original deadlock problem and the solution have been witnessed and tested
on actual hardware. Without the solution, rmmod an edac driver would result in
below deadlock:

root@localhost:/root> rmmod mv64x60_edac
EDAC DEBUG: mv64x60_dma_err_remove()
EDAC DEBUG: edac_device_del_device()
EDAC DEBUG: find_edac_device_by_dev()

(hang for a moment)

INFO: task edac-poller:2030 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
edac-poller   D 00000000     0  2030      2
Call Trace:
[df159dc0] [c0071e3c] free_hot_cold_page+0x17c/0x304 (unreliable)
[df159e80] [c000a024] __switch_to+0x6c/0xa0
[df159ea0] [c03587d8] schedule+0x2f4/0x4d8
[df159f00] [c03598a8] __mutex_lock_slowpath+0xa0/0x174
[df159f40] [e1030434] edac_device_workq_function+0x28/0xd8 [edac_core]
[df159f60] [c003beb4] run_workqueue+0x114/0x218
[df159f90] [c003c674] worker_thread+0x5c/0xc8
[df159fd0] [c004106c] kthread+0x5c/0xa0
[df159ff0] [c0013538] original_kernel_thread+0x44/0x60
INFO: task rmmod:2062 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rmmod         D 0ff2c9fc     0  2062   1839
Call Trace:
[df119c00] [c0437a74] 0xc0437a74 (unreliable)
[df119cc0] [c000a024] __switch_to+0x6c/0xa0
[df119ce0] [c03587d8] schedule+0x2f4/0x4d8
[df119d40] [c03591dc] schedule_timeout+0xb0/0xf4
--- Exception: df119e00 at 0xdfaaf834
    LR = 0xdf119d94
[df119d80] [c0358f1c] wait_for_common+0xd8/0x218 (unreliable)
[df119dc0] [c003c110] flush_cpu_workqueue+0x94/0xd8
[df119df0] [e102fe68] edac_device_workq_teardown+0x30/0x70 [edac_core]
[df119e00] [e102ff6c] edac_device_del_device+0xc4/0x14c [edac_core]
[df119e20] [e1022404] mv64x60_dma_err_remove+0x34/0x74 [mv64x60_edac]
[df119e30] [c0200730] platform_drv_remove+0x20/0x30
[df119e40] [c01ff060] __device_release_driver+0xa0/0xe8
[df119e60] [c01ff1d0] driver_detach+0x128/0x13c
[df119e80] [c01fe008] bus_remove_driver+0xa8/0xf0
[df119ea0] [c01ff7ec] driver_unregister+0x50/0x68
[df119eb0] [c020090c] platform_driver_unregister+0x14/0x24
[df119ec0] [e1022e80] mv64x60_edac_exit+0x20/0x74 [mv64x60_edac]
[df119ee0] [c0056568] sys_delete_module+0x1ac/0x268
[df119f40] [c0013714] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff2c9fc
    LR = 0x100012c4

This patch removes the deadlock and the edac driver module can be insmod/rmmod
as many times as you like. 
