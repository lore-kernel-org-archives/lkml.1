Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZKROxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZKROxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbZKROxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:53:03 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51261 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZKROwB (ORCPT
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
Subject: [PATCH 15/16] COMPAT: add get/put_compat_rlimit
Date: Wed, 18 Nov 2009 15:52:01 +0100
Message-Id: <1258555922-2064-15-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract those functions from compat_sys_[gs]etrlimit for later
use with newly added rlimit syscalls.

Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/compat.c |   61 ++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index f6c204f..af15719 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -274,6 +274,39 @@ asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *set,
 	return ret;
 }
 
+static int get_compat_rlimit(struct rlimit *dst,
+		const struct compat_rlimit __user *src)
+{
+	if (!access_ok(VERIFY_READ, src, sizeof(*src)) ||
+			__get_user(dst->rlim_cur, &src->rlim_cur) ||
+			__get_user(dst->rlim_max, &src->rlim_max))
+		return -EFAULT;
+
+	if (dst->rlim_cur == COMPAT_RLIM_INFINITY)
+		dst->rlim_cur = RLIM_INFINITY;
+	if (dst->rlim_max == COMPAT_RLIM_INFINITY)
+		dst->rlim_max = RLIM_INFINITY;
+	return 0;
+}
+
+static int put_compat_rlimit(const struct rlimit *src,
+		struct compat_rlimit __user *dst)
+{
+	struct rlimit r = *src;
+
+	if (r.rlim_cur > COMPAT_RLIM_INFINITY)
+		r.rlim_cur = COMPAT_RLIM_INFINITY;
+	if (r.rlim_max > COMPAT_RLIM_INFINITY)
+		r.rlim_max = COMPAT_RLIM_INFINITY;
+
+	if (!access_ok(VERIFY_WRITE, dst, sizeof(*dst)) ||
+	    __put_user(r.rlim_cur, &dst->rlim_cur) ||
+	    __put_user(r.rlim_max, &dst->rlim_max))
+		return -EFAULT;
+
+	return 0;
+}
+
 asmlinkage long compat_sys_setrlimit(unsigned int resource,
 		struct compat_rlimit __user *rlim)
 {
@@ -284,17 +317,12 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
 
-	if (!access_ok(VERIFY_READ, rlim, sizeof(*rlim)) ||
-	    __get_user(r.rlim_cur, &rlim->rlim_cur) ||
-	    __get_user(r.rlim_max, &rlim->rlim_max))
-		return -EFAULT;
+	ret = get_compat_rlimit(&r, rlim);
+	if (ret)
+		return ret;
 
-	if (r.rlim_cur == COMPAT_RLIM_INFINITY)
-		r.rlim_cur = RLIM_INFINITY;
-	if (r.rlim_max == COMPAT_RLIM_INFINITY)
-		r.rlim_max = RLIM_INFINITY;
 	set_fs(KERNEL_DS);
-	ret = sys_setrlimit(resource, (struct rlimit __user *) &r);
+	ret = sys_setrlimit(resource, (struct rlimit __force __user *)&r);
 	set_fs(old_fs);
 	return ret;
 }
@@ -336,19 +364,10 @@ asmlinkage long compat_sys_getrlimit (unsigned int resource,
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = sys_getrlimit(resource, (struct rlimit __user *) &r);
+	ret = sys_getrlimit(resource, (struct rlimit __force __user *)&r);
 	set_fs(old_fs);
-	if (!ret) {
-		if (r.rlim_cur > COMPAT_RLIM_INFINITY)
-			r.rlim_cur = COMPAT_RLIM_INFINITY;
-		if (r.rlim_max > COMPAT_RLIM_INFINITY)
-			r.rlim_max = COMPAT_RLIM_INFINITY;
-
-		if (!access_ok(VERIFY_WRITE, rlim, sizeof(*rlim)) ||
-		    __put_user(r.rlim_cur, &rlim->rlim_cur) ||
-		    __put_user(r.rlim_max, &rlim->rlim_max))
-			return -EFAULT;
-	}
+	if (!ret)
+		ret = put_compat_rlimit(&r, rlim);
 	return ret;
 }
 
-- 
1.6.4.2

