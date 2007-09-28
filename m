Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbXI1Xqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbXI1Xqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbXI1Xqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:46:35 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:52929 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbXI1Xqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:46:32 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH] Generic compat_sys_fallocate
Date: Fri, 28 Sep 2007 18:33:52 -0400
Message-Id: <1191018832-18069-2-git-send-email-kyle@mcmartin.ca>
X-Mailer: git-send-email 1.5.3.2
In-Reply-To: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca>
References: <1191018832-18069-1-git-send-email-kyle@mcmartin.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Basically everyone is using the same sys32_fallocate. Delete a whole bunch of
archdep code and move the compat wrapper to fs/compat.c

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
 arch/mips/kernel/linux32.c        |    7 -------
 arch/mips/kernel/scall64-o32.S    |    2 +-
 arch/powerpc/kernel/sys_ppc32.c   |    7 -------
 arch/sparc64/kernel/sys_sparc32.c |    6 ------
 arch/x86_64/ia32/ia32entry.S      |    2 +-
 arch/x86_64/ia32/sys_ia32.c       |    7 -------
 fs/compat.c                       |   10 ++++++++++
 include/linux/compat.h            |    2 ++
 8 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 135d9a5..c37568d 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -566,13 +566,6 @@ asmlinkage long sys32_fadvise64_64(int fd, int __pad,
 			flags);
 }
 
-asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_a2,
-	unsigned offset_a3, unsigned len_a4, unsigned len_a5)
-{
-	return sys_fallocate(fd, mode, merge_64(offset_a2, offset_a3),
-	                     merge_64(len_a4, len_a5));
-}
-
 save_static_function(sys32_clone);
 static int noinline __used
 _sys32_clone(nabi_no_regargs struct pt_regs regs)
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index b3ed731..bb724cc 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -525,5 +525,5 @@ sys_call_table:
 	PTR	compat_sys_signalfd
 	PTR	compat_sys_timerfd
 	PTR	sys_eventfd
-	PTR	sys_fallocate			/* 4320 */
+	PTR	compat_sys_fallocate		/* 4320 */
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index bd85b5f..b42cbf1 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -773,13 +773,6 @@ asmlinkage int compat_sys_truncate64(const char __user * path, u32 reg4,
 	return sys_truncate(path, (high << 32) | low);
 }
 
-asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offhi, u32 offlo,
-				     u32 lenhi, u32 lenlo)
-{
-	return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
-			     ((loff_t)lenhi << 32) | lenlo);
-}
-
 asmlinkage int compat_sys_ftruncate64(unsigned int fd, u32 reg4, unsigned long high,
 				 unsigned long low)
 {
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index e8dce90..5d60883 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -1028,9 +1028,3 @@ long compat_sync_file_range(int fd, unsigned long off_high, unsigned long off_lo
 				   flags);
 }
 
-asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offhi, u32 offlo,
-				     u32 lenhi, u32 lenlo)
-{
-	return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
-			     ((loff_t)lenhi << 32) | lenlo);
-}
diff --git a/arch/x86_64/ia32/ia32entry.S b/arch/x86_64/ia32/ia32entry.S
index 18b2318..28d8fff 100644
--- a/arch/x86_64/ia32/ia32entry.S
+++ b/arch/x86_64/ia32/ia32entry.S
@@ -732,5 +732,5 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
-	.quad sys32_fallocate
+	.quad compat_sys_fallocate
 ia32_syscall_end:
diff --git a/arch/x86_64/ia32/sys_ia32.c b/arch/x86_64/ia32/sys_ia32.c
index bee96d6..ca8deac 100644
--- a/arch/x86_64/ia32/sys_ia32.c
+++ b/arch/x86_64/ia32/sys_ia32.c
@@ -880,10 +880,3 @@ asmlinkage long sys32_fadvise64(int fd, unsigned offset_lo, unsigned offset_hi,
 				len, advice);
 }
 
-asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
-				unsigned offset_hi, unsigned len_lo,
-				unsigned len_hi)
-{
-	return sys_fallocate(fd, mode, ((u64)offset_hi << 32) | offset_lo,
-			     ((u64)len_hi << 32) | len_lo);
-}
diff --git a/fs/compat.c b/fs/compat.c
index 15078ce..9093915 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -2226,3 +2226,13 @@ asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
 }
 
 #endif /* CONFIG_TIMERFD */
+
+asmlinkage long compat_sys_fallocate(int fd, int mode,
+				     u32 offset_lo, u32 offset_hi,
+				     u32 len_lo, u32 len_hi)
+{
+	u64 offset = compat_merge64(offset_lo, offset_hi);
+	u64 len = compat_merge64(len_lo, len_hi);
+
+	return sys_fallocate(fd, mode, offset, len);
+}
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 07bcc3c..49401a9 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -266,6 +266,8 @@ asmlinkage long compat_sys_signalfd(int ufd,
                                 compat_size_t sigsetsize);
 asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
 				const struct compat_itimerspec __user *utmr);
+asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offset_lo,
+				u32 offset_hi, u32 len_lo, u32 len_hi);
 
 static inline u64 compat_merge64(u32 left, u32 right)
 {
-- 
1.5.3.2

