Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbZASVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbZASVVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZASVVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:21:43 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50738 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZASVVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:21:42 -0500
Date: Mon, 19 Jan 2009 16:21:27 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       horms@verge.net.au, akpm@linux-foundation.org, nhorman@tuxdriver.com
Subject: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
Message-ID: <20090119212127.GA13157@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	It would be nice to be able to extract the dmesg log from a vmcore file
without needing to keep the debug symbols for the running kernel handy all the
time.  We have a facility to do this in /proc/vmcore.  This patch adds the
log_buf and log_end symbols to the vmcoreinfo area so that tools (like
makedumpfile) can easily extract the dmesg logs from a vmcore image.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 include/linux/kernel.h |    2 ++
 kernel/kexec.c         |    3 +++
 kernel/printk.c        |    8 ++++++++
 3 files changed, 13 insertions(+)


diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 343df9e..a7f3e8a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -242,6 +242,7 @@ extern struct ratelimit_state printk_ratelimit_state;
 extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
+void log_buf_kexec_setup(void);
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -253,6 +254,7 @@ static inline int printk_ratelimit(void) { return 0; }
 static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
+#define log_buf_kexec_setup() do {} while(0)
 #endif
 
 extern int printk_needs_cpu(int cpu);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 8a6d7b0..bee284d 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1409,6 +1409,9 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_OFFSET(list_head, prev);
 	VMCOREINFO_OFFSET(vm_struct, addr);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
+#ifdef CONFIG_PRINTK
+	log_buf_kexec_setup();
+#endif
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
diff --git a/kernel/printk.c b/kernel/printk.c
index 69188f2..79e9e05 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <linux/kexec.h>
 
 #include <asm/uaccess.h>
 
@@ -136,6 +137,13 @@ static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
+void log_buf_kexec_setup(void)
+{
+	VMCOREINFO_SYMBOL(log_buf);
+	VMCOREINFO_SYMBOL(log_end);
+}
+
+
 static int __init log_buf_len_setup(char *str)
 {
 	unsigned size = memparse(str, &str);
