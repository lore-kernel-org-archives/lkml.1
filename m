Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZK3DBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZK3DBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZK3DBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZK3DAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 21/21] blkio: Documentation
Date: Sun, 29 Nov 2009 21:59:28 -0500
Message-Id: <1259549968-10369-22-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/cgroups/blkio-controller.txt |  135 ++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/cgroups/blkio-controller.txt

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
new file mode 100644
index 0000000..630879c
--- /dev/null
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -0,0 +1,135 @@
+				Block IO Controller
+				===================
+Overview
+========
+cgroup subsys "blkio" implements the block io controller. There seems to be
+a need of various kinds of IO control policies (like proportional BW, max BW)
+both at leaf nodes as well as at intermediate nodes in a storage hierarchy.
+Plan is to use the same cgroup based management interface for blkio controller
+and based on user options switch IO policies in the background.
+
+In the first phase, this patchset implements proportional weight time based
+division of disk policy. It is implemented in CFQ. Hence this policy takes
+effect only on leaf nodes when CFQ is being used.
+
+HOWTO
+=====
+You can do a very simple testing of running two dd threads in two different
+cgroups. Here is what you can do.
+
+- Enable group scheduling in CFQ
+	CONFIG_CFQ_GROUP_IOSCHED=y
+
+- Compile and boot into kernel and mount IO controller (blkio).
+
+	mount -t cgroup -o blkio none /cgroup
+
+- Create two cgroups
+	mkdir -p /cgroup/test1/ /cgroup/test2
+
+- Set weights of group test1 and test2
+	echo 1000 > /cgroup/test1/blkio.weight
+	echo 500 > /cgroup/test2/blkio.weight
+
+- Create two same size files (say 512MB each) on same disk (file1, file2) and
+  launch two dd threads in different cgroup to read those files.
+
+	sync
+	echo 3 > /proc/sys/vm/drop_caches
+
+	dd if=/mnt/sdb/zerofile1 of=/dev/null &
+	echo $! > /cgroup/test1/tasks
+	cat /cgroup/test1/tasks
+
+	dd if=/mnt/sdb/zerofile2 of=/dev/null &
+	echo $! > /cgroup/test2/tasks
+	cat /cgroup/test2/tasks
+
+- At macro level, first dd should finish first. To get more precise data, keep
+  on looking at (with the help of script), at blkio.disk_time and
+  blkio.disk_sectors files of both test1 and test2 groups. This will tell how
+  much disk time (in milli seconds), each group got and how many secotors each
+  group dispatched to the disk. We provide fairness in terms of disk time, so
+  ideally io.disk_time of cgroups should be in proportion to the weight.
+
+Various user visible config options
+===================================
+CONFIG_CFQ_GROUP_IOSCHED
+	- Enables group scheduling in CFQ. Currently only 1 level of group
+	  creation is allowed.
+
+CONFIG_DEBUG_CFQ_IOSCHED
+	- Enables some debugging messages in blktrace. Also creates extra
+	  cgroup file blkio.dequeue.
+
+Config options selected automatically
+=====================================
+These config options are not user visible and are selected/deselected
+automatically based on IO scheduler configuration.
+
+CONFIG_BLK_CGROUP
+	- Block IO controller. Selected by CONFIG_CFQ_GROUP_IOSCHED.
+
+CONFIG_DEBUG_BLK_CGROUP
+	- Debug help. Selected by CONFIG_DEBUG_CFQ_IOSCHED.
+
+Details of cgroup files
+=======================
+- blkio.weight
+	- Specifies per cgroup weight.
+
+	  Currently allowed range of weights is from 100 to 1000.
+
+- blkio.time
+	- disk time allocated to cgroup per device in milliseconds. First
+	  two fields specify the major and minor number of the device and
+	  third field specifies the disk time allocated to group in
+	  milliseconds.
+
+- blkio.sectors
+	- number of sectors transferred to/from disk by the group. First
+	  two fields specify the major and minor number of the device and
+	  third field specifies the number of sectors transferred by the
+	  group to/from the device.
+
+- blkio.dequeue
+	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
+	  gives the statistics about how many a times a group was dequeued
+	  from service tree of the device. First two fields specify the major
+	  and minor number of the device and third field specifies the number
+	  of times a group was dequeued from a particular device.
+
+CFQ sysfs tunable
+=================
+/sys/block/<disk>/queue/iosched/group_isolation
+
+If group_isolation=1, it provides stronger isolation between groups at the
+expense of throughput. By default group_isolation is 0. In general that
+means that if group_isolation=0, expect fairness for sequential workload
+only. Set group_isolation=1 to see fairness for random IO workload also.
+
+Generally CFQ will put random seeky workload in sync-noidle category. CFQ
+will disable idling on these queues and it does a collective idling on group
+of such queues. Generally these are slow moving queues and if there is a
+sync-noidle service tree in each group, that group gets exclusive access to
+disk for certain period. That means it will bring the throughput down if
+group does not have enough IO to drive deeper queue depths and utilize disk
+capacity to the fullest in the slice allocated to it. But the flip side is
+that even a random reader should get better latencies and overall throughput
+if there are lots of sequential readers/sync-idle workload running in the
+system.
+
+If group_isolation=0, then CFQ automatically moves all the random seeky queues
+in the root group. That means there will be no service differentiation for
+that kind of workload. This leads to better throughput as we do collective
+idling on root sync-noidle tree.
+
+By default one should run with group_isolation=0. If that is not sufficient
+and one wants stronger isolation between groups, then set group_isolation=1
+but this will come at cost of reduced throughput.
+
+What works
+==========
+- Currently only sync IO queues are support. All the buffered writes are
+  still system wide and not per group. Hence we will not see service
+  differentiation between buffered writes between groups.
-- 
1.6.2.5

