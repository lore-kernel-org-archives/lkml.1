Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYHLDQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYHLDQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYHLDOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:14:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:3597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbYHLDOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,192,1217833200"; 
   d="scan'208";a="428377147"
Subject: [PATCH -v3 6/7] kexec jump: __ftrace_enabled_save/restore
From: Huang Ying <ying.huang@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 11:14:36 +0800
Message-Id: <1218510876.24951.45.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __ftrace_enabled_save/restore, used to disable ftrace for a
while. Now, this is used by kexec jump, which need a version without
lock, for general situation, a locked version should be used.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/linux/ftrace.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -98,6 +98,27 @@ static inline void tracer_disable(void)
 #endif
 }
 
+/* Ftrace disable/restore without lock. Some synchronization mechanism
+ * must be used to prevent ftrace_enabled to be changed between
+ * disable/restore. */
+static inline int __ftrace_enabled_save(void)
+{
+#ifdef CONFIG_FTRACE
+	int saved_ftrace_enabled = ftrace_enabled;
+	ftrace_enabled = 0;
+	return saved_ftrace_enabled;
+#else
+	return 0;
+#endif
+}
+
+static inline void __ftrace_enabled_restore(int enabled)
+{
+#ifdef CONFIG_FTRACE
+	ftrace_enabled = enabled;
+#endif
+}
+
 #ifdef CONFIG_FRAME_POINTER
 /* TODO: need to fix this for ARM */
 # define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))


