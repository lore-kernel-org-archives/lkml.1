Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZKROxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZKROxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZKROxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:53:01 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51270 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbZKROwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:52:01 -0500
From: Jiri Slaby <jslaby@novell.com>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       Jiri Slaby <jslaby@novell.com>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 16/16] x86: add ia32 compat prlimit syscalls
Date: Wed, 18 Nov 2009 15:52:02 +0100
Message-Id: <1258555922-2064-16-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support 32/64-bit compatibility (rlimit structure contains 2 longs)
for prlimit syscalls, add compat wrappers for them.

Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/ia32/ia32entry.S |    2 ++
 kernel/compat.c           |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 581b056..c61ced2 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -841,4 +841,6 @@ ia32_sys_call_table:
 	.quad compat_sys_pwritev
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
+	.quad compat_sys_getprlimit
+	.quad compat_sys_setprlimit
 ia32_syscall_end:
diff --git a/kernel/compat.c b/kernel/compat.c
index af15719..97fda34 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -371,6 +371,38 @@ asmlinkage long compat_sys_getrlimit (unsigned int resource,
 	return ret;
 }
 
+asmlinkage long compat_sys_setprlimit(pid_t pid, unsigned int resource,
+		struct compat_rlimit __user *rlim)
+{
+	mm_segment_t old_fs = get_fs ();
+	struct rlimit r;
+	int ret;
+
+	ret = get_compat_rlimit(&r, rlim);
+	if (ret)
+		return ret;
+
+	set_fs(KERNEL_DS);
+	ret = sys_setprlimit(pid, resource, (struct rlimit __force __user *)&r);
+	set_fs(old_fs);
+	return ret;
+}
+
+asmlinkage long compat_sys_getprlimit(pid_t pid, unsigned int resource,
+		struct compat_rlimit __user *rlim)
+{
+	mm_segment_t old_fs = get_fs();
+	struct rlimit r;
+	int ret;
+
+	set_fs(KERNEL_DS);
+	ret = sys_getprlimit(pid, resource, (struct rlimit __force __user *)&r);
+	set_fs(old_fs);
+	if (!ret)
+		ret = put_compat_rlimit(&r, rlim);
+	return ret;
+}
+
 int put_compat_rusage(const struct rusage *r, struct compat_rusage __user *ru)
 {
 	if (!access_ok(VERIFY_WRITE, ru, sizeof(*ru)) ||
-- 
1.6.4.2

