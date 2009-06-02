Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZFBUS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZFBUS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZFBURl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:17:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:39504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbZFBURg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:17:36 -0400
Date: Tue, 2 Jun 2009 20:17:03 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eranian@googlemail.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add ioctl for changing the sample period/frequency
Message-ID: <tip-08247e31ca79b8f02cce47b7e8120797a8726606@git.kernel.org>
Git-Commit-ID: 08247e31ca79b8f02cce47b7e8120797a8726606
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:17:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08247e31ca79b8f02cce47b7e8120797a8726606
Gitweb:     http://git.kernel.org/tip/08247e31ca79b8f02cce47b7e8120797a8726606
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 16:46:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:32 +0200

perf_counter: Add ioctl for changing the sample period/frequency

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    9 +++++----
 kernel/perf_counter.c        |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c046f7d..45bdd3b 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -164,10 +164,11 @@ struct perf_counter_hw_event {
 /*
  * Ioctls that can be done on a perf counter fd:
  */
-#define PERF_COUNTER_IOC_ENABLE		_IOW('$', 0, u32)
-#define PERF_COUNTER_IOC_DISABLE	_IOW('$', 1, u32)
-#define PERF_COUNTER_IOC_REFRESH	_IOW('$', 2, u32)
-#define PERF_COUNTER_IOC_RESET		_IOW('$', 3, u32)
+#define PERF_COUNTER_IOC_ENABLE		_IO ('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO ('$', 1)
+#define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
+#define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
+#define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 3f11a2b..abe2f3b 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1604,6 +1604,43 @@ static void perf_counter_for_each(struct perf_counter *counter,
 	mutex_unlock(&counter->child_mutex);
 }
 
+static int perf_counter_period(struct perf_counter *counter, u64 __user *arg)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	unsigned long size;
+	int ret = 0;
+	u64 value;
+
+	if (!counter->hw_event.sample_period)
+		return -EINVAL;
+
+	size = copy_from_user(&value, arg, sizeof(value));
+	if (size != sizeof(value))
+		return -EFAULT;
+
+	if (!value)
+		return -EINVAL;
+
+	spin_lock_irq(&ctx->lock);
+	if (counter->hw_event.freq) {
+		if (value > sysctl_perf_counter_limit) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+
+		counter->hw_event.sample_freq = value;
+	} else {
+		counter->hw_event.sample_period = value;
+		counter->hw.sample_period = value;
+
+		perf_log_period(counter, value);
+	}
+unlock:
+	spin_unlock_irq(&ctx->lock);
+
+	return ret;
+}
+
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_counter *counter = file->private_data;
@@ -1623,6 +1660,10 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case PERF_COUNTER_IOC_REFRESH:
 		return perf_counter_refresh(counter, arg);
+
+	case PERF_COUNTER_IOC_PERIOD:
+		return perf_counter_period(counter, (u64 __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
