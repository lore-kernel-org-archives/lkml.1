Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZK0XHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZK0XHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZK0XHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:07:40 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60487 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbZK0XGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3 27/27] x86: add ia32 compat prlimit syscalls
Date: Sat, 28 Nov 2009 00:06:07 +0100
Message-Id: <1259363167-9347-27-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support 32/64-bit compatibility (rlimit structure contains 2 longs)
for prlimit syscalls, add compat wrappers for them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
index af15719..c1d5704 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -371,6 +371,38 @@ asmlinkage long compat_sys_getrlimit (unsigned int resource,
 	return ret;
 }
 
+asmlinkage long compat_sys_setprlimit(pid_t pid, unsigned int resource,
+		struct compat_rlimit __user *rlim)
+{
+	mm_segment_t old_fs = get_fs();
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
1.6.5.3

