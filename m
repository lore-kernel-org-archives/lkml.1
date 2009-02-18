Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZBRK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZBRK1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZBRK1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:27:04 -0500
Received: from ozlabs.org ([203.10.76.45]:40688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZBRK1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:27:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18843.57965.710475.395466@cargo.ozlabs.ibm.com>
Date: Wed, 18 Feb 2009 21:26:53 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perfcounters: allow sysadmin to restrict non-root counting of kernel events
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: security feature

This allows the sysadmin to prevent non-root users from counting
hardware events that occur in kernel or hypervisor mode via a sysfs file:

	/sys/devices/system/cpu/perf_counters/restrict_kernel_events

This defaults to off (0), allowing users to count kernel and hypervisor
events, but if the sysadmin writes 1 to that file, any new counters
created by non-root users will automatically be set to ignore kernel
and hypervisor events.

This could be useful if there is a concern that allowing non-root users
to count kernel or hypervisor events might leak sensitive information.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
This is available in my perfcounters.git tree master branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 kernel/perf_counter.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ad62965..7967272 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -31,6 +31,7 @@ DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
 int perf_max_counters __read_mostly = 1;
 static int perf_reserved_percpu __read_mostly;
 static int perf_overcommit __read_mostly = 1;
+static int perf_counters_strict __read_mostly;
 
 /*
  * Mutex for (sysadmin-configurable) counter reservations:
@@ -1670,8 +1671,21 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	hw_ops = NULL;
 	if (!hw_event->raw && hw_event->type < 0)
 		hw_ops = sw_perf_counter_init(counter);
-	else
+	else {
+		/*
+		 * If the user is not root and the restrict_kernel_events
+		 * policy is in force, make sure we exclude kernel and
+		 * hypervisor events from hardware events.  (We don't have
+		 * any capability to distinguish user, kernel and hypervisor
+		 * events in our software counters.)
+		 */
+		if (!capable(CAP_SYS_ADMIN) && perf_counters_strict) {
+			counter->hw_event.exclude_kernel = 1;
+			counter->hw_event.exclude_hv = 1;
+		}
+
 		hw_ops = hw_perf_counter_init(counter);
+	}
 
 	if (!hw_ops) {
 		kfree(counter);
@@ -2175,6 +2189,28 @@ perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
 	return count;
 }
 
+static ssize_t perf_show_strict(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_counters_strict);
+}
+
+static ssize_t
+perf_set_strict(struct sysdev_class *class, const char *buf, size_t count)
+{
+	unsigned long val;
+	int err;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > 1)
+		return -EINVAL;
+
+	perf_counters_strict = val;
+
+	return count;
+}
+
 static SYSDEV_CLASS_ATTR(
 				reserve_percpu,
 				0644,
@@ -2189,9 +2225,17 @@ static SYSDEV_CLASS_ATTR(
 				perf_set_overcommit
 			);
 
+static SYSDEV_CLASS_ATTR(
+				restrict_kernel_events,
+				0644,
+				perf_show_strict,
+				perf_set_strict
+			);
+
 static struct attribute *perfclass_attrs[] = {
 	&attr_reserve_percpu.attr,
 	&attr_overcommit.attr,
+	&attr_restrict_kernel_events.attr,
 	NULL
 };
 
-- 
1.5.6.3

