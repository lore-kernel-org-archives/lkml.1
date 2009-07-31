Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZGaDJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZGaDJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 23:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbZGaDI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 23:08:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52425 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZGaDI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 23:08:58 -0400
Message-ID: <4A7260A5.2040502@cn.fujitsu.com>
Date: Fri, 31 Jul 2009 11:10:29 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH]cfq: add the document of the tuning parameters
References: <4A715DB5.1020502@cn.fujitsu.com> <4A7160B5.8010301@cn.fujitsu.com>
In-Reply-To: <4A7160B5.8010301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This little file attempts to document how the cfq io scheduler works.
In particular, it will clarify the meaning of the tuning parameters. 


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>

---
 Documentation/block/00-INDEX        |    2 +
 Documentation/block/cfq-iosched.txt |   82 +++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/block/cfq-iosched.txt

diff --git a/Documentation/block/00-INDEX b/Documentation/block/00-INDEX
index 961a051..2ce5c7a 100644
--- a/Documentation/block/00-INDEX
+++ b/Documentation/block/00-INDEX
@@ -8,6 +8,8 @@ biodoc.txt
 	- Notes on the Generic Block Layer Rewrite in Linux 2.5
 capability.txt
 	- Generic Block Device Capability (/sys/block/<disk>/capability)
+cfq-iosched.txt
+	- CFQ(Complete Fairness Queueing) IO scheduler tunables
 deadline-iosched.txt
 	- Deadline IO scheduler tunables
 ioprio.txt
diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
new file mode 100644
index 0000000..ccf5c61
--- /dev/null
+++ b/Documentation/block/cfq-iosched.txt
@@ -0,0 +1,82 @@
+CFQ(Complete Fairness Queueing) IO scheduler tunables
+=====================================================
+Shan Wei <shanwei@cn.fujitsu.com>         30 Jun 2009
+
+
+The main goal of he "Complete Fairness Queueing" elevator is ensuring
+a fair allocation of the disk I/O bandwidth among all the processes
+that trigger the I/O requests.
+
+For synchronous requests, CFQ creates per-process queues to manage the requests.
+But asynchronous requests are batched together in fewer queues,
+one per IO priority. See Documentation/block/ioprio.txt for details
+of the IO priority. CFQ schedules queues in a round-robin manner and
+dispatches requests in queue's time slice, so that it can ensure that
+every process accesses the disk fairly.
+
+Now, CFQ is the default IO scheduler.
+
+
+Selecting IO schedulers
+-----------------------
+Refer to Documentation/block/switching-sched.txt for information on
+selecting an io scheduler on a per-device basis.
+
+
+Tuning the CFQ IO scheduler
+---------------------------
+When using 'cfq', there are 9 parameters under /sys/block/*/queue/iosched/.
+
+The parameters are:
+* back_seek_max 	(in KByte)
+    The parameter sets the max distance for backward seeking,
+    default is 16MBytes. The idea comes from the AS scheduler.
+    Like forward requests, CFQ may dispatch a back request that accesses sector
+    at the backward of current magnetic head.
+
+* back_seek_penalty
+    The parameter is used to calculate the cost of backward seeking,
+    default is 2. Relative to front request, if the backward distance of
+    a request is just 1/2 (1/back_seek_penalty) of it,
+    the seeking cost of the two requests is considered equivalent.
+
+* fifo_expire_async	(in ms)
+    The parameter is used to set the timeout of asynchronous requests,
+    default is 250ms. CFQ maintains a fifo list to manage timeout requests.
+    CFQ doesn't check the expired requests from the fifo queue, after one
+    timeout request is dispatched.
+
+* fifo_expire_sync	(in ms)
+    Same as fifo_expire_async, but the parameter is for synchronous requests,
+    default is 125ms.
+
+* slice_sync	(in ms)
+    The parameter is used to calculate time slice of synchronous queue,
+    default is 100ms. But the actual time slice also depends on
+    the io priority. The formula is:
+    time_slice = slice_sync + (slice_sync / 5 * (4 - io_priority)).
+
+* slice_async	(in ms)
+    Same as slice_sync, but the parameter is for asynchronous queue,
+    default is 40ms.
+
+* slice_async_rq
+    The parameter is used to limit dispatching of asynchronous requests
+    to the device request-queue in queue's slice time, default is 2.
+    The max number of requests that are allowed to be dispatched also
+    depends on the io priority. The formula is: max_nr_requests =
+    2 * (slice_async_rq + slice_async_rq * (7 - io_priority)).
+
+* slice_idle	(in ms)
+    The parameter is the idle time for synchronous queue only, default is 8ms.
+    In queue's time slice, when there is no request in the synchronous queue,
+    CFQ will not switch to another queue, but idle to wait for process creating
+    more requests. If no new requests are submitted, the queue will expire.
+
+* quantum	(number of requests)
+    The number of dispatched requests to the device request-queue is restricted
+    by this parameter, default is 4. In queue's time slice, request will not be
+    dispatched if the number of requests in the device request-queue
+    exceeds the limit. For asynchronous queue, dispatching is also
+    restricted by slice_async_rq. Note, the parameter has no effect
+    on the IDLE queue(IDLE is the class of the IO priority).
-- 
1.6.0.4
