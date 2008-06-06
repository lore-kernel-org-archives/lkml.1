Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYFGI3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYFGI3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 04:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYFGI26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 04:28:58 -0400
Received: from [78.13.70.189] ([78.13.70.189]:47940 "EHLO linux.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752810AbYFGI2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 04:28:54 -0400
X-Greylist: delayed 36085 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2008 04:28:53 EDT
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com, menage@google.com
Cc: matt@bluehost.com, roberto@unbit.it, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] i/o bandwidth controller documentation
Date: Sat,  7 Jun 2008 00:27:28 +0200
Message-Id: <1212791250-32320-2-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation of the block device I/O bandwidth controller: description, usage,
advantages and design.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 Documentation/controllers/io-throttle.txt |  150 +++++++++++++++++++++++++++++
 1 files changed, 150 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/controllers/io-throttle.txt

diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
new file mode 100644
index 0000000..5373fa8
--- /dev/null
+++ b/Documentation/controllers/io-throttle.txt
@@ -0,0 +1,150 @@
+
+               Block device I/O bandwidth controller
+
+1. Description
+
+This controller allows to limit the I/O bandwidth of specific block devices for
+specific process containers (cgroups) imposing additional delays on I/O
+requests for those processes that exceed the limits defined in the control
+group filesystem.
+
+Bandwidth limiting rules offer better control over QoS with respect to priority
+or weight-based solutions that only give information about applications'
+relative performance requirements.
+
+The goal of the I/O bandwidth controller is to improve performance
+predictability and QoS of the different control groups sharing the same block
+devices.
+
+NOTE: if you're looking for a way to improve the overall throughput of the
+system probably you should use a different solution.
+
+2. User Interface
+
+A new I/O bandwidth limitation rule is described using the file
+blockio.bandwidth.
+
+The same file can be used to set multiple rules for different block devices
+relatively to the same cgroup.
+
+The syntax is the following:
+# /bin/echo DEVICE:BANDWIDTH > CGROUP/blockio.bandwidth
+
+- DEVICE is the name of the device the limiting rule is applied to,
+- BANDWIDTH is the maximum I/O bandwidth on DEVICE allowed by CGROUP,
+- CGROUP is the name of the limited process container.
+
+Examples:
+
+* Mount the cgroup filesystem (blockio subsystem):
+  # mkdir /mnt/cgroup
+  # mount -t cgroup -oblockio blockio /mnt/cgroup
+
+* Instantiate the new cgroup "foo":
+  # mkdir /mnt/cgroup/foo
+  --> the cgroup foo has been created
+
+* Add the current shell process to the cgroup "foo":
+  # /bin/echo $$ > /mnt/cgroup/foo/tasks
+  --> the current shell has been added to the cgroup "foo"
+
+* Give maximum 1MiB/s of I/O bandwidth on /dev/sda1 for the cgroup "foo":
+  # /bin/echo /dev/sda1:1024 > /mnt/cgroup/foo/blockio.bandwidth
+  # sh
+  --> the subshell 'sh' is running in cgroup "foo" and it can use a maximum I/O
+      bandwidth of 1MiB/s on /dev/sda1 (blockio.bandwidth is expressed in
+      KiB/s).
+
+* Give maximum 8MiB/s of I/O bandwidth on /dev/sdb for the cgroup "foo":
+  # /bin/echo /dev/sdb:8192 > /mnt/cgroup/foo/blockio.bandwidth
+  # sh
+  --> the subshell 'sh' is running in cgroup "foo" and it can use a maximum I/O
+      bandwidth of 1MiB/s on /dev/sda1 and 8MiB/s on /dev/sdb.
+      NOTE: each partition needs its own limitation rule! In this case, for
+      example, there's no limitation on /dev/sdb1 for cgroup "foo".
+
+* Show the I/O limits defined for cgroup "foo":
+  # cat /mnt/cgroup/foo/blockio.bandwidth
+  === device (8,1) ===
+  bandwidth-max: 1024 KiB/sec
+      requested: 0 bytes
+   last request: 4294933948 jiffies
+          delta: 2660 jiffies
+  === device (8,5) ===
+  bandwidth-max: 8192 KiB/sec
+      requested: 0 bytes
+   last request: 4294935736 jiffies
+          delta: 872 jiffies
+
+  Devices are reported using (major, minor) numbers when reading
+  blockio.bandwidth.
+
+  The corresponding device names can be retrieved in /proc/diskstats (or in
+  other places as well).
+
+  For example to find the name of the device (8,5):
+  # sed -ne 's/^ \+8 \+5 \([^ ]\+\).*/\1/p' /proc/diskstats
+  sda5
+
+* Extend the maximum I/O bandwidth for the cgroup "foo" to 8MiB/s:
+  # /bin/echo /dev/sda1:8192 > /mnt/cgroup/foo/blockio-bandwidth
+
+* Remove limiting rule on /dev/sda1 for cgroup "foo":
+  # /bin/echo /dev/sda1:0 > /mnt/cgroup/foo/blockio-bandwidth
+
+3. Advantages of providing this feature
+
+* Allow QoS for block device I/O among different cgroups
+* Improve I/O performance predictability on block devices shared between
+  different cgroups
+* Limiting rules do not depend of the particular I/O scheduler (anticipatory,
+  deadline, CFQ, noop) and/or the type of the underlying block devices
+* The bandwidth limitations are guaranteed both for synchronous and
+  asynchronous operations, even the I/O passing through the page cache or
+  buffers and not only direct I/O (see below for details)
+* It is possible to implement a simple user-space application to dynamically
+  adjust the I/O workload of different process containers at run-time,
+  according to the particular users' requirements and applications' performance
+  constraints
+* It is even possible to implement event-based performance throttling
+  mechanisms; for example the same user-space application could actively
+  throttle the I/O bandwidth to reduce power consumption when the battery of a
+  mobile device is running low (power throttling) or when the temperature of a
+  hardware component is too high (thermal throttling)
+
+4. Design
+
+The I/O throttling is performed imposing an explicit timeout, via
+schedule_timeout_killable() on the processes that exceed the I/O bandwidth
+dedicated to the cgroup they belong to.
+
+It just works as expected for read operations: the real I/O activity is reduced
+synchronously according to the defined limitations.
+
+Write operations, instead, are modeled depending of the dirty pages ratio
+(write throttling in memory), since the writes to the real block devices are
+processed asynchronously by different kernel threads (pdflush). However, the
+dirty pages ratio is directly proportional to the actual I/O that will be
+performed on the real block device. So, due to the asynchronous transfers
+through the page cache, the I/O throttling in memory can be considered a form
+of anticipatory throttling to the underlying block devices.
+
+Multiple re-writes in already dirtied page cache areas are not considered for
+accounting the I/O activity. This is valid for multiple re-reads of pages
+already present in the page cache as well.
+
+This means that a process that re-writes and/or re-reads multiple times the
+same blocks in a file (without re-creating it by truncate(), ftrunctate(),
+creat(), etc.) is affected by the I/O limitations only for the actual I/O
+performed to (or from) the underlying block devices.
+
+Multiple rules for different block devices are stored in a rbtree, using the
+dev_t number of each block device as key. This allows to reduce the controller
+overhead on systems with many LUNs and different per-LUN I/O bandwidth rules
+(exploiting the worst case complexity of O(log n) for search operations in the
+rbtree structure).
+
+WARNING: per-block device limiting rules always refer to the dev_t device
+number. If a block device is unplugged (i.e. a USB device) the limiting rules
+associated to that device persist and they are still valid if a new device is
+plugged in the system and it uses the same major and minor numbers.
-- 
1.5.4.3

