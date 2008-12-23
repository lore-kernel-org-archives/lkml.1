Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYLWDYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYLWDYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 22:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYLWDYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 22:24:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:64912 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYLWDYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 22:24:02 -0500
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 1/1] EDAC: fix edac core deadlock when removing a device
Date: Tue, 23 Dec 2008 11:13:48 +0800
Message-Id: <1230002028-13362-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1230002028-13362-1-git-send-email-qingtao.cao@windriver.com>
References: <1230002028-13362-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 23 Dec 2008 03:25:11.0241 (UTC) FILETIME=[1001CB90:01C964AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remove an edac device, all pending work must be complete. At that point, 
it is safe to remove the edac_dev structure.

If the pending work is not properly cleared and proper care is not taken 
when waiting for it's completion, the following stack trace result:

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
...
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
...

To wait for pending work to complete, flush_cpu_workqueue() is used to 
wait for all works in edac_poller's workqueue to be processed, by inserting
a wq_barrier into the tail of the workqueue, then sleeping on the completion
of this wq_barrier, the edac_poller will wake up sleepers when it is found.

There is a potential deadlock between edac_poller and rmmod - on one hand
rmmod would sleep on the completion of a wq_barrier, holding 
device_ctls_mutex; on the other hand edac_poller would be blocked on the 
same mutex when it's running any one of works of existing edac evices
(Note, this edac_dev.work is likely to be totally irrelevant to the one 
that is being removed right now)and never would have a chance to run the
work of above wq_barrier to wake rmmod up.

To avoid this situation edac_device_workq_teardown() should be moved outside
of the critical region of device_ctls_mutex. Moreover, an edac_dev.work should
bail out immediately if it is being removed.

Signed-off-by: Harry Ciao<qingtao.cao@windriver.com>
---
 drivers/edac/edac_device.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 5fcd3d8..4041e91 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -394,6 +394,12 @@ static void edac_device_workq_function(struct work_struct *work_req)
 
 	mutex_lock(&device_ctls_mutex);
 
+	/* If we are being removed, bail out immediately */
+	if (edac_dev->op_state == OP_OFFLINE) {
+		mutex_unlock(&device_ctls_mutex);
+		return;
+	}
+
 	/* Only poll controllers that are running polled and have a check */
 	if ((edac_dev->op_state == OP_RUNNING_POLL) &&
 		(edac_dev->edac_check != NULL)) {
@@ -585,14 +591,14 @@ struct edac_device_ctl_info *edac_device_del_device(struct device *dev)
 	/* mark this instance as OFFLINE */
 	edac_dev->op_state = OP_OFFLINE;
 
-	/* clear workq processing on this instance */
-	edac_device_workq_teardown(edac_dev);
-
 	/* deregister from global list */
 	del_edac_device_from_global_list(edac_dev);
 
 	mutex_unlock(&device_ctls_mutex);
 
+	/* clear workq processing on this instance */
+	edac_device_workq_teardown(edac_dev);
+
 	/* Tear down the sysfs entries for this instance */
 	edac_device_remove_sysfs(edac_dev);
 
-- 
1.5.6.2

