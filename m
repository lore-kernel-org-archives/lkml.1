Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbYBTTef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbYBTTef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYBTTd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:33:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:53038 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbYBTTdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:33:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/3] kgdb: fix optional arch functions and probe_kernel_*
Date: Wed, 20 Feb 2008 13:33:38 -0600
Message-Id: <1203536020-20102-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com>
References: <1203536020-20102-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Feb 2008 19:33:41.0328 (UTC) FILETIME=[7F802500:01C873F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two regressions dealing with the kgdb core.

1) kgdb_skipexception and kgdb_post_primary_code are optional
functions that are only required on archs that need special exception
fixups.

2) The kernel address space scope must be set on any probe_kernel_*
function or archs such as ARCH=arm will not allow access to the kernel
memory space.  As an example, it is required to allow the full kernel
address space is when you the kernel debugger to inspect a system
call.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |   11 +++++++++++
 mm/maccess.c  |    6 ++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 68aea78..31425e0 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -200,6 +200,17 @@ int __weak kgdb_arch_init(void)
 	return 0;
 }
 
+int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
+{
+	return 0;
+}
+
+void __weak
+kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
+{
+	return;
+}
+
 /**
  *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
  *	@regs: Current &struct pt_regs.
diff --git a/mm/maccess.c b/mm/maccess.c
index 24f81b9..ac40796 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -17,11 +17,14 @@
 long probe_kernel_read(void *dst, void *src, size_t size)
 {
 	long ret;
+	mm_segment_t old_fs = get_fs();
 
+	set_fs(KERNEL_DS);
 	pagefault_disable();
 	ret = __copy_from_user_inatomic(dst,
 			(__force const void __user *)src, size);
 	pagefault_enable();
+	set_fs(old_fs);
 
 	return ret ? -EFAULT : 0;
 }
@@ -39,10 +42,13 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
 long probe_kernel_write(void *dst, void *src, size_t size)
 {
 	long ret;
+	mm_segment_t old_fs = get_fs();
 
+	set_fs(KERNEL_DS);
 	pagefault_disable();
 	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
 	pagefault_enable();
+	set_fs(old_fs);
 
 	return ret ? -EFAULT : 0;
 }
-- 
1.5.4

