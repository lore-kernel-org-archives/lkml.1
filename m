Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZIGIOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZIGIOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZIGIOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:14:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZIGIOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:14:52 -0400
Message-ID: <4AA4C0B3.3070300@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 16:13:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
References: <4AA4C04D.1050201@cn.fujitsu.com>
In-Reply-To: <4AA4C04D.1050201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to set profile filter via ioctl.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |   40 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 972f90d..7a750b3 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -217,6 +217,7 @@ struct perf_counter_attr {
 #define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
 #define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
 #define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
+#define PERF_COUNTER_IOC_SET_FILTER	_IOW('$', 6, char *)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e0d91fd..3fd65e8 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1988,7 +1988,9 @@ unlock:
 	return ret;
 }
 
-int perf_counter_set_output(struct perf_counter *counter, int output_fd);
+static int perf_counter_set_output(struct perf_counter *counter, int output_fd);
+static int perf_counter_set_filter(struct perf_counter *counter,
+				   void __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -2016,6 +2018,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_COUNTER_IOC_SET_OUTPUT:
 		return perf_counter_set_output(counter, arg);
 
+	case PERF_COUNTER_IOC_SET_FILTER:
+		return perf_counter_set_filter(counter, (void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -3964,6 +3969,7 @@ EXPORT_SYMBOL_GPL(perf_tpcounter_event);
 
 extern int ftrace_profile_enable(int);
 extern void ftrace_profile_disable(int);
+extern int ftrace_profile_set_filter(int, char *);
 
 static void tp_perf_counter_destroy(struct perf_counter *counter)
 {
@@ -3988,12 +3994,40 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 
 	return &perf_ops_generic;
 }
+
+static int perf_counter_set_filter(struct perf_counter *counter,
+				   void __user *arg)
+{
+	char *filter_str;
+	int ret;
+
+	if (counter->attr.type != PERF_TYPE_TRACEPOINT)
+		return -EINVAL;
+
+	filter_str = strndup_user(arg, PAGE_SIZE);
+	if (IS_ERR(filter_str))
+		return PTR_ERR(filter_str);
+
+	ret = ftrace_profile_set_filter(counter->attr.config, filter_str);
+
+	kfree(filter_str);
+	return ret;
+}
+
 #else
+
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
 	return NULL;
 }
-#endif
+
+static int perf_counter_set_filter(struct perf_counter *counter,
+				   void __user *arg)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_EVENT_PROFILE */
 
 atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
 
@@ -4246,7 +4280,7 @@ err_size:
 	goto out;
 }
 
-int perf_counter_set_output(struct perf_counter *counter, int output_fd)
+static int perf_counter_set_output(struct perf_counter *counter, int output_fd)
 {
 	struct perf_counter *output_counter = NULL;
 	struct file *output_file = NULL;
-- 
1.6.3

