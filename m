Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZLASxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZLASxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZLASxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:53:06 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:20596 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbZLASxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:53:04 -0500
Message-ID: <4B1565D2.2030505@oracle.com>
Date: Tue, 01 Dec 2009 10:52:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>
Subject: [PATCH -next] kmsg_dump: fix build for CONFIG_PRINTK=n
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
In-Reply-To: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B1565EC.0136:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

kmsg_dump() fails to build when CONFIG_PRINTK=n; provide stubs
for the kmsg_dump*() functions when CONFIG_PRINTK=n.

kernel/printk.c: In function 'kmsg_dump':
kernel/printk.c:1501: error: 'log_buf_len' undeclared (first use in this function)
kernel/printk.c:1502: error: 'logged_chars' undeclared (first use in this function)
kernel/printk.c:1506: error: 'log_buf' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 include/linux/kmsg_dump.h |   16 ++++++++++++++++
 kernel/printk.c           |    2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- linux-next-20091201.orig/kernel/printk.c
+++ linux-next-20091201/kernel/printk.c
@@ -1406,7 +1406,6 @@ bool printk_timed_ratelimit(unsigned lon
 	return false;
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
-#endif
 
 static DEFINE_SPINLOCK(dump_list_lock);
 static LIST_HEAD(dump_list);
@@ -1525,3 +1524,4 @@ void kmsg_dump(enum kmsg_dump_reason rea
 		dumper->dump(dumper, reason, s1, l1, s2, l2);
 	spin_unlock_irqrestore(&dump_list_lock, flags);
 }
+#endif
--- linux-next-20091201.orig/include/linux/kmsg_dump.h
+++ linux-next-20091201/include/linux/kmsg_dump.h
@@ -35,10 +35,26 @@ struct kmsg_dumper {
 	int registered;
 };
 
+#ifdef CONFIG_PRINTK
 void kmsg_dump(enum kmsg_dump_reason reason);
 
 int kmsg_dump_register(struct kmsg_dumper *dumper);
 
 int kmsg_dump_unregister(struct kmsg_dumper *dumper);
+#else
+static inline void kmsg_dump(enum kmsg_dump_reason reason)
+{
+}
+
+static inline int kmsg_dump_register(struct kmsg_dumper *dumper)
+{
+	return -EINVAL;
+}
+
+static inline int kmsg_dump_unregister(struct kmsg_dumper *dumper)
+{
+	return -EINVAL;
+}
+#endif
 
 #endif /* _LINUX_KMSG_DUMP_H */
