Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZL2FW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZL2FW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZL2FW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:22:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52070 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZL2FW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:22:57 -0500
Message-ID: <4B3991C1.6060303@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 13:21:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/5] perf_event: introduce 'inject' event and get HZ
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
In-Reply-To: <20091228075417.GB20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'inject' event is a very useful feature and it's suggested by Ingo
[ See http://lkml.org/lkml/2009/12/28/31 ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/perf_event.h  |   13 +++++++++++
 kernel/perf_event.c         |   47 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-record.c |   13 +++++++++++
 tools/perf/util/session.c   |    5 ++++
 tools/perf/util/session.h   |    3 +-
 5 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9a1d276..6c93f88 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -228,6 +228,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_INJECT		_IO ('$', 7)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -413,10 +414,22 @@ enum perf_event_type {
 	 * };
 	 */
 	PERF_RECORD_SAMPLE		= 9,
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32 inject_event_id;
+	 * 	u64 value;
+	 * };
+	 */
+	PERF_RECORD_INJECT		= 10,
 
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
+enum perf_inject_event {
+	PERF_INJECT_HZ = 0x01,
+};
+
 enum perf_callchain_context {
 	PERF_CONTEXT_HV			= (__u64)-32,
 	PERF_CONTEXT_KERNEL		= (__u64)-128,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8984afd..9343c6c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2012,6 +2012,50 @@ unlock:
 	return ret;
 }
 
+static int perf_inject_get_hz(u64 *hz)
+{
+	*hz = HZ;
+	return 0;
+}
+
+static int perf_inject_event(struct perf_event *event, u32 inject_event_id,
+			     int (*get_value)(u64 *))
+{
+	struct perf_output_handle handle;
+	struct perf_inject_event {
+		struct perf_event_header header;
+		u32 inject_event_id;
+		u64 value;
+	} inject_event;
+	int ret = 0;
+
+	inject_event.header.type = PERF_RECORD_INJECT;
+	inject_event.header.misc = 0;
+	inject_event.header.size = sizeof(inject_event);
+	inject_event.inject_event_id = inject_event_id;
+
+	ret = get_value(&inject_event.value);
+	if (ret)
+		goto exit;
+
+	ret = perf_output_begin(&handle, event, inject_event.header.size, 0, 0);
+	if (ret)
+		goto exit;
+
+	perf_output_put(&handle, inject_event);
+	perf_output_end(&handle);
+exit:
+	return ret;
+}
+
+static int perf_inject_ioctl(struct perf_event *event, unsigned int arg)
+{
+	if (!arg || arg & ~PERF_INJECT_HZ)
+		return -EINVAL;
+
+	return perf_inject_event(event, PERF_INJECT_HZ, perf_inject_get_hz);
+}
+
 static int perf_event_set_output(struct perf_event *event, int output_fd);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 
@@ -2044,6 +2088,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_INJECT:
+		return perf_inject_ioctl(event, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2654253..d13601d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -65,6 +65,8 @@ static int			file_new			=      1;
 
 static struct perf_session	*session;
 
+u32 inject_events;
+
 struct mmap_data {
 	int			counter;
 	void			*base;
@@ -381,6 +383,17 @@ try_again:
 		}
 	}
 
+	if (inject_events) {
+		ret = ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_INJECT,
+			    inject_events);
+		if (ret) {
+			error("failed to inject event(%u) with %d (%s)\n",
+			      inject_events, errno, strerror(errno));
+			exit(-1);
+		}
+		inject_events = 0;
+	}
+
 	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7f0537d..74f43af 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -179,6 +179,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->throttle = process_event_stub;
 	if (handler->unthrottle == NULL)
 		handler->unthrottle = process_event_stub;
+	if (handler->inject == NULL)
+		handler->inject = process_event_stub;
 }
 
 static const char *event__name[] = {
@@ -192,6 +194,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_FORK]	 = "FORK",
 	[PERF_RECORD_READ]	 = "READ",
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+	[PERF_RECORD_INJECT]	 = "INJECT",
 };
 
 unsigned long event__total[PERF_RECORD_MAX];
@@ -239,6 +242,8 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->throttle(event, self);
 	case PERF_RECORD_UNTHROTTLE:
 		return ops->unthrottle(event, self);
+	case PERF_RECORD_INJECT:
+		return ops->inject(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 77c5ee2..8742354 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -40,7 +40,8 @@ struct perf_event_ops {
 		 lost,
 		 read,
 		 throttle,
-		 unthrottle;
+		 unthrottle,
+		 inject;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
-- 
1.6.1.2


