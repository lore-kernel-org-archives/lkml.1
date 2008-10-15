Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYJOSJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYJOSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYJOSJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:09:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59750 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYJOSJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:09:48 -0400
Message-ID: <48F631E9.1010707@linux.vnet.ibm.com>
Date: Wed, 15 Oct 2008 12:09:45 -0600
From: Chris J Arges <arges@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
CC: Robert Richter <robert.richter@amd.com>,
       Maynard Johnson <maynardj@us.ibm.com>
Subject: [PATCH] oprofile: hotplug cpu fix
Content-Type: multipart/mixed;
 boundary="------------040003040704030604010502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040003040704030604010502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch addresses crashes when hotplugging cpus while profiling.
I used the following script to test :

    #!/bin/bash
    startup()
    {
      opcontrol --init
      opcontrol --vmlinux=/boot/vmlinux
      opcontrol --reset
      opcontrol  --start
      opcontrol --dump
    }
    shutdown()
    {
      opcontrol --dump
      opcontrol -h
    }
    startup
    echo 0 > /sys/devices/system/cpu/cpu2/online
    echo 0 > /sys/devices/system/cpu/cpu1/online
    shutdown
    startup
    echo 1 > /sys/devices/system/cpu/cpu2/online
    echo 1 > /sys/devices/system/cpu/cpu1/online
    shutdown
    startup
    echo 0 > /sys/devices/system/cpu/cpu2/online
    shutdown
    startup
    echo 1 > /sys/devices/system/cpu/cpu2/online
    echo 0 > /sys/devices/system/cpu/cpu2/online
    shutdown
    echo 1 > /sys/devices/system/cpu/cpu2/online

Without the patch on my Power machine (ppc970mp) I get the following error:

    Vector: 300 (Data Access) at [c000000276143950]
    pc: d0000000000366e8: .add_event_entry+0x60/0xb0 [oprofile]
    lr: d000000000035e60: .sync_buffer+0x68/0x4ac [oprofile]

Without the patch on my x86 (Core 2 Duo) machine:

    mutex_lock +0x8/0x20
    sync_buffer +0x29/0x3e0
    wq_sync_buffer +0x0/0x70

Since I'm guessing hotplugging cpus and using oprofile is not a common 
occurrence, this patch is just a do-no-harm fix, instead
of a full solution with a hotplug callback, etc.

Thanks,
--chris


--------------040003040704030604010502
Content-Type: text/x-patch;
 name="0001-oprofile-hotplug-cpu-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-oprofile-hotplug-cpu-fix.patch"

>From 60f07301d3c387a0405becccbdc0cfb7e99ecf39 Mon Sep 17 00:00:00 2001
From: Chris J Arges <arges@linux.vnet.ibm.com>
Date: Wed, 15 Oct 2008 11:03:39 -0500
Subject: [PATCH] oprofile: hotplug cpu fix
 This patch addresses problems when hotplugging cpus while profiling.
 Instead of allocating only online cpus, all possible cpu buffers are
 allocated, which allows cpus to be onlined during operation. If a cpu is
 offlined before profiling is shutdown wq_sync_buffer checks for this
 condition then cancels this work and does not sync this buffer.

---
 drivers/oprofile/cpu_buffer.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index e1bd5a9..8bb030b 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -39,7 +39,7 @@ void free_cpu_buffers(void)
 {
 	int i;
  
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		vfree(per_cpu(cpu_buffer, i).buffer);
 		per_cpu(cpu_buffer, i).buffer = NULL;
 	}
@@ -51,7 +51,7 @@ int alloc_cpu_buffers(void)
  
 	unsigned long buffer_size = fs_cpu_buffer_size;
  
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
  
 		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
@@ -368,6 +368,11 @@ static void wq_sync_buffer(struct work_struct *work)
 	if (b->cpu != smp_processor_id()) {
 		printk(KERN_DEBUG "WQ on CPU%d, prefer CPU%d\n",
 		       smp_processor_id(), b->cpu);
+
+		if (!cpu_online(b->cpu)) {
+			cancel_delayed_work(&b->work);
+			return;
+		}
 	}
 	sync_buffer(b->cpu);
 
-- 
1.5.4.5

Signed-off-by: Chris J Arges <arges@linux.vnet.ibm.com>




--------------040003040704030604010502--
