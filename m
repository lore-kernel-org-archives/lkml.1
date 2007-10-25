Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbXJYQvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbXJYQvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXJYQvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:51:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbXJYQvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:51:36 -0400
Message-ID: <4720C994.9060108@redhat.com>
Date: Thu, 25 Oct 2007 11:51:32 -0500
From: Clark Williams <williams@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>, Peter Zijlstra <pzijlstr@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] header fix for 2.6.23-rt3
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------020905040600070007090205"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020905040600070007090205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Steven/Peter,

There's a circular include problem with sched.h -> aio.h -> workqueues.h that
manifests in a couple of modules (net/rfkill/rfkill.c and drivers/hwmon/applesmc.c).

The attached patch factors out the priority #defines into <linux/sched_prio.h> which
is then included by <linux/sched.h> and <linux/workqueues.h>.

Clark
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHIMmTHyuj/+TTEp0RAj7uAJ95P4Pw44UC4iT2hhBy1D8K2JrfxQCdFax1
3Zsfku5WEMILcRxZCalkxe4=
=rc5L
-----END PGP SIGNATURE-----

--------------020905040600070007090205
Content-Type: text/x-patch;
 name="sched_prio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched_prio.patch"

factor out priorities for workqueue.h and sched.h

From: Clark Williams <williams@redhat.com>

This fixes a circular dependency between sched.h and workqueue.h by factoring out the common
defines to a new header which is included by both

Signed-off-by: Clark Williams <williams@redhat.com>
---

 include/linux/sched.h      |   19 +------------------
 include/linux/sched_prio.h |   23 +++++++++++++++++++++++
 include/linux/workqueue.h  |    1 +
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 42deb55..b7ab7ca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1428,24 +1428,7 @@ struct task_struct {
 # define set_printk_might_sleep(x) do { } while(0)
 #endif
 
-/*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
- * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
- * values are inverted: lower p->prio value means higher priority.
- *
- * The MAX_USER_RT_PRIO value allows the actual maximum
- * RT priority to be separate from the value exported to
- * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
- * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
- */
-
-#define MAX_USER_RT_PRIO	100
-#define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+#include <linux/sched_prio.h>
 
 static inline int rt_prio(int prio)
 {
diff --git a/include/linux/sched_prio.h b/include/linux/sched_prio.h
new file mode 100644
index 0000000..ec5114a
--- /dev/null
+++ b/include/linux/sched_prio.h
@@ -0,0 +1,23 @@
+#ifndef __SCHED_PRIO_H
+#define __SCHED_PRIO_H
+
+/*
+ * Priority of a process goes from 0..MAX_PRIO-1, valid RT
+ * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
+ * values are inverted: lower p->prio value means higher priority.
+ *
+ * The MAX_USER_RT_PRIO value allows the actual maximum
+ * RT priority to be separate from the value exported to
+ * user-space.  This allows kernel threads to set their
+ * priority to a value higher than any user task. Note:
+ * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ */
+
+#define MAX_USER_RT_PRIO	100
+#define MAX_RT_PRIO		MAX_USER_RT_PRIO
+
+#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+
+#endif
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index fbcbec6..4ea6292 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -9,6 +9,7 @@
 #include <linux/linkage.h>
 #include <linux/bitops.h>
 #include <linux/plist.h>
+#include <linux/sched_prio.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;

--------------020905040600070007090205--
