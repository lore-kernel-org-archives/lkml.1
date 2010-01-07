Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515Ab0AGTBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0AGTBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553Ab0AGTBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:01:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:60329 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab0AGTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:01:28 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 1/4] maccess,probe_kernel: Allow arch specific override probe_kernel_(read|write)
Date: Thu,  7 Jan 2010 12:59:53 -0600
Message-Id: <1262890796-25053-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
References: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Jan 2010 19:00:40.0064 (UTC) FILETIME=[B45D8000:01CA8FCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some archs such as blackfin, would like to have an arch specific
probe_kernel_read() and probe_kernel_write() implementation which can
fall back to the generic implementation if no special operations are
needed.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/uaccess.h |    4 +++-
 mm/maccess.c            |   11 +++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 6b58367..d512d98 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -94,6 +94,7 @@ static inline unsigned long __copy_from_user_nocache(void *to,
  * happens, handle that and return -EFAULT.
  */
 extern long probe_kernel_read(void *dst, void *src, size_t size);
+extern long __probe_kernel_read(void *dst, void *src, size_t size);
 
 /*
  * probe_kernel_write(): safely attempt to write to a location
@@ -104,6 +105,7 @@ extern long probe_kernel_read(void *dst, void *src, size_t size);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-extern long probe_kernel_write(void *dst, void *src, size_t size);
+extern long notrace probe_kernel_write(void *dst, void *src, size_t size);
+extern long notrace __probe_kernel_write(void *dst, void *src, size_t size);
 
 #endif		/* __LINUX_UACCESS_H__ */
diff --git a/mm/maccess.c b/mm/maccess.c
index 9073695..4e348db 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -14,7 +14,11 @@
  * Safely read from address @src to the buffer at @dst.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long probe_kernel_read(void *dst, void *src, size_t size)
+
+long __weak probe_kernel_read(void *dst, void *src, size_t size)
+    __attribute__((alias("__probe_kernel_read")));
+
+long __probe_kernel_read(void *dst, void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
@@ -39,7 +43,10 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long notrace __weak probe_kernel_write(void *dst, void *src, size_t size)
+long __weak probe_kernel_write(void *dst, void *src, size_t size)
+    __attribute__((alias("__probe_kernel_write")));
+
+long __probe_kernel_write(void *dst, void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
-- 
1.6.3.1.9.g95405b

