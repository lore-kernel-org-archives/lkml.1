Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbXI0OxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbXI0OxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbXI0Ow6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:52:58 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:37685 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbXI0Ow5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:52:57 -0400
Message-ID: <46FBC3C4.3030600@hp.com>
Date: Thu, 27 Sep 2007 10:52:52 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@hp.com
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Some IO scheduler cleanup in Documentation/block
Content-Type: multipart/mixed;
 boundary="------------090406020205090208090507"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090406020205090208090507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------090406020205090208090507
Content-Type: text/x-patch;
 name*0="0001-Some-IO-scheduler-cleanup-in-Documentation-block.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Some-IO-scheduler-cleanup-in-Documentation-block.patch"

[PATCH] Some IO scheduler cleanup in Documentation/block

as-iosched.txt:
  o  Changed IO scheduler selection text to a reference to the
     switching-sched.txt file.

  o  Fixed typo: 'for up time...' -> 'for up to...'

  o  Added short description of the est_time file.

deadline-iosched.txt:
  o  Changed IO scheduler selection text to a reference to the
     switching-sched.txt file.

  o  Removed references to non-existent seek-cost and stream_unit.

  o  Fixed typo: 'write_starved' -> 'writes_starved'

switching-sched.txt:
  o  Added in boot-time argument to set the default IO scheduler. (From
     as-iosched.txt)

  o  Added in sysfs mount instructions. (From deadline-iosched.txt)

Signed-off-by: Alan D. Brunelle <Alan.Brunelle@hp.com>
---
 Documentation/block/as-iosched.txt       |   21 +++++++++++++--------
 Documentation/block/deadline-iosched.txt |   23 +++++++----------------
 Documentation/block/switching-sched.txt  |   21 +++++++++++++++++++++
 3 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/Documentation/block/as-iosched.txt b/Documentation/block/as-iosched.txt
index a598fe1..738b72b 100644
--- a/Documentation/block/as-iosched.txt
+++ b/Documentation/block/as-iosched.txt
@@ -20,15 +20,10 @@ actually has a head for each physical device in the logical RAID device.
 However, setting the antic_expire (see tunable parameters below) produces
 very similar behavior to the deadline IO scheduler.
 
-
 Selecting IO schedulers
 -----------------------
-To choose IO schedulers at boot time, use the argument 'elevator=deadline'.
-'noop', 'as' and 'cfq' (the default) are also available. IO schedulers are
-assigned globally at boot time only presently. It's also possible to change
-the IO scheduler for a determined device on the fly, as described in
-Documentation/block/switching-sched.txt.
-
+Refer to Documentation/block/switching-sched.txt for information on
+selecting an io scheduler on a per-device basis.
 
 Anticipatory IO scheduler Policies
 ----------------------------------
@@ -115,7 +110,7 @@ statistics (average think time, average seek distance) on the process
 that submitted the just completed request are examined.  If it seems
 likely that that process will submit another request soon, and that
 request is likely to be near the just completed request, then the IO
-scheduler will stop dispatching more read requests for up time (antic_expire)
+scheduler will stop dispatching more read requests for up to (antic_expire)
 milliseconds, hoping that process will submit a new request near the one
 that just completed.  If such a request is made, then it is dispatched
 immediately.  If the antic_expire wait time expires, then the IO scheduler
@@ -165,3 +160,13 @@ The parameters are:
     for big seek time devices though not a linear correspondence - most
     processes have only a few ms thinktime.
 
+In addition to the tunables above there is a read-only file named est_time
+which, when read, will show:
+
+    - The probability of a task exiting without a cooperating task
+      submitting an anticipated IO.
+
+    - The current mean think time.
+
+    - The seek distance used to determine if an incoming IO is better.
+
diff --git a/Documentation/block/deadline-iosched.txt b/Documentation/block/deadline-iosched.txt
index be08ffd..0a89839 100644
--- a/Documentation/block/deadline-iosched.txt
+++ b/Documentation/block/deadline-iosched.txt
@@ -5,16 +5,10 @@ This little file attempts to document how the deadline io scheduler works.
 In particular, it will clarify the meaning of the exposed tunables that may be
 of interest to power users.
 
-Each io queue has a set of io scheduler tunables associated with it. These
-tunables control how the io scheduler works. You can find these entries
-in:
-
-/sys/block/<device>/queue/iosched
-
-assuming that you have sysfs mounted on /sys. If you don't have sysfs mounted,
-you can do so by typing:
-
-# mount none /sys -t sysfs
+Selecting IO schedulers
+-----------------------
+Refer to Documentation/block/switching-sched.txt for information on
+selecting an io scheduler on a per-device basis.
 
 
 ********************************************************************************
@@ -41,14 +35,11 @@ fifo_batch
 
 When a read request expires its deadline, we must move some requests from
 the sorted io scheduler list to the block device dispatch queue. fifo_batch
-controls how many requests we move, based on the cost of each request. A
-request is either qualified as a seek or a stream. The io scheduler knows
-the last request that was serviced by the drive (or will be serviced right
-before this one). See seek_cost and stream_unit.
+controls how many requests we move.
 
 
-write_starved	(number of dispatches)
--------------
+writes_starved	(number of dispatches)
+--------------
 
 When we have to move requests from the io scheduler queue to the block
 device dispatch queue, we always give a preference to reads. However, we
diff --git a/Documentation/block/switching-sched.txt b/Documentation/block/switching-sched.txt
index 5fa130a..634c952 100644
--- a/Documentation/block/switching-sched.txt
+++ b/Documentation/block/switching-sched.txt
@@ -1,3 +1,18 @@
+To choose IO schedulers at boot time, use the argument 'elevator=deadline'.
+'noop', 'as' and 'cfq' (the default) are also available. IO schedulers are
+assigned globally at boot time only presently.
+
+Each io queue has a set of io scheduler tunables associated with it. These
+tunables control how the io scheduler works. You can find these entries
+in:
+
+/sys/block/<device>/queue/iosched
+
+assuming that you have sysfs mounted on /sys. If you don't have sysfs mounted,
+you can do so by typing:
+
+# mount none /sys -t sysfs
+
 As of the Linux 2.6.10 kernel, it is now possible to change the
 IO scheduler for a given block device on the fly (thus making it possible,
 for instance, to set the CFQ scheduler for the system default, but
@@ -20,3 +35,9 @@ noop anticipatory deadline [cfq]
 # echo anticipatory > /sys/block/hda/queue/scheduler
 # cat /sys/block/hda/queue/scheduler
 noop [anticipatory] deadline cfq
+
+Each io queue has a set of io scheduler tunables associated with it. These
+tunables control how the io scheduler works. You can find these entries
+in:
+
+/sys/block/<device>/queue/iosched
-- 
1.5.2.5


--------------090406020205090208090507--
