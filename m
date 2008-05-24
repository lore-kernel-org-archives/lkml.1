Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYEXRMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYEXRMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbYEXRMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:12:14 -0400
Received: from host135-133-dynamic.55-82-r.retail.telecomitalia.it ([82.55.133.135]:29433
	"EHLO linux.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752993AbYEXRMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:12:13 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 May 2008 13:12:12 EDT
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com, menage@google.com
Cc: matt@bluehost.com, roberto@unbit.it, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add io-throttle controller documentation
Date: Sat, 24 May 2008 18:56:55 +0200
Message-Id: <1211648217-13361-2-git-send-email-righi.andrea@gmail.com>
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
 Documentation/controllers/io-throttle.txt |   81 +++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
new file mode 100644
index 0000000..e7ab050
--- /dev/null
+++ b/Documentation/controllers/io-throttle.txt
@@ -0,0 +1,81 @@
+
+               Block device I/O bandwidth controller
+
+1. Description
+
+This controller allows to limit the block I/O bandwidth for specific process
+containers (cgroups) imposing additional delays on I/O requests for those
+processes that exceed the limits defined in the control group filesystem.
+
+Bandwidth limiting rules offers a better control over QoS respect to priority
+or weighted-based solutions, that only give information about applications'
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
+Example:
+
+* mount the cgroup filesystem (blockio subsystem):
+  # mkdir /mnt/cgroup
+  # mount -t cgroup -oblockio blockio /mnt/cgroup
+
+* Instantiate the new cgroup "foo":
+  # mkdir /mnt/cgroup/foo
+  --> the cgroup foo has been created
+
+* add the current shell process to the "foo" cgroup:
+  # /bin/echo $$ > /mnt/cgroup/foo/tasks
+  --> the current shell has been added to the cgroup "foo"
+
+* give maximum 1MiB/s of I/O bandwidth for the cgroup "foo":
+  # /bin/echo 1024 > /mnt/cgroup/foo/blockio.bandwidth
+  # sh
+  --> the subshell 'sh' is running in cgroup "foo" and it can use a maximum I/O
+      bandwidth of 1MiB/s (blockio.bandwidth is expressed in KiB/s).
+
+3. Advantages of providing this feature
+
+* Allow QoS for block device I/O among different cgroups
+* Improve I/O performance predictability on block devices shared between
+  different cgroups
+* It is independent on the particular I/O scheduler (anticipatory, deadline,
+  CFQ, noop) and/or the underlying block devices
+* The bandwidth limitations are guaranteed both for synchronous and
+  asynchronous operations, even the I/O passing through the page cache or
+  buffers and not only direct I/O (see below for details)
+
+4. Design
+
+The I/O throttling is performed imposing an explicit timeout, via
+schedule_timeout_killable() on the processes that exceed the I/O bandwidth
+dedicated to the cgroup they belong.
+
+It just works as expected for read operations: the real I/O activity is reduced
+synchronously according to the defined limitations.
+
+Write operations, instead, are modeled depending on the dirty pages ratio
+(write throttling in memory), since the writes to the real block device are
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
-- 
1.5.4.3

