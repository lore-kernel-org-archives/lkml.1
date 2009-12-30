Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbZL3DTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbZL3DTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZL3DTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:19:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbZL3DTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:19:43 -0500
Message-ID: <4B3AC65F.8090005@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 11:17:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] perf_event: support getting relocation offset
References: <4B3AC5CD.1000502@cn.fujitsu.com>
In-Reply-To: <4B3AC5CD.1000502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support getting relocation offset by using 'inject' event

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kernel/cpu/perf_event.c |    6 ++++++
 include/linux/perf_event.h       |    1 +
 kernel/perf_event.c              |   23 +++++++++++++++++++++--
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 11d2a7d..fbb39f6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2470,3 +2470,9 @@ void hw_perf_event_setup_online(int cpu)
 {
 	init_debug_store_on_cpu(cpu);
 }
+
+int perf_inject_get_relocate_offset(u64 *offset)
+{
+	*offset = relocate_offset;
+	return 0;
+}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6c93f88..2671234 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -428,6 +428,7 @@ enum perf_event_type {
 
 enum perf_inject_event {
 	PERF_INJECT_HZ = 0x01,
+	PERF_INJECT_RELOCATE_OFFSET = 0x02,
 };
 
 enum perf_callchain_context {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9343c6c..9331426 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2012,6 +2012,12 @@ unlock:
 	return ret;
 }
 
+extern __weak int perf_inject_get_relocate_offset(u64 *offset)
+{
+	*offset = 0;
+	return 0;
+}
+
 static int perf_inject_get_hz(u64 *hz)
 {
 	*hz = HZ;
@@ -2050,10 +2056,23 @@ exit:
 
 static int perf_inject_ioctl(struct perf_event *event, unsigned int arg)
 {
-	if (!arg || arg & ~PERF_INJECT_HZ)
+	int ret = 0;
+
+	if (!arg || arg & ~(PERF_INJECT_HZ | PERF_INJECT_RELOCATE_OFFSET))
 		return -EINVAL;
 
-	return perf_inject_event(event, PERF_INJECT_HZ, perf_inject_get_hz);
+	if (arg & PERF_INJECT_HZ) {
+		ret = perf_inject_event(event, PERF_INJECT_HZ,
+					perf_inject_get_hz);
+		if (ret)
+			goto exit;
+	}
+
+	if (arg & PERF_INJECT_RELOCATE_OFFSET)
+		ret = perf_inject_event(event, PERF_INJECT_RELOCATE_OFFSET,
+					perf_inject_get_relocate_offset);
+exit:
+	return ret;
 }
 
 static int perf_event_set_output(struct perf_event *event, int output_fd);
-- 
1.6.1.2


