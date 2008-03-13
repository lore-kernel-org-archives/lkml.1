Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYCMIbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYCMIbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYCMIbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:31:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbYCMIbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:31:23 -0400
From: Roland McGrath <roland@redhat.com>
To: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH -mm 1/4] powerpc copy_siginfo_from_user32
Message-Id: <20080313083107.8BDE926F992@magilla.localdomain>
Date: Thu, 13 Mar 2008 01:31:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Define the copy_siginfo_from_user32 entry point for powerpc, so
that generic CONFIG_COMPAT code can call it.  We already had the
code rolled into compat_sys_rt_sigqueueinfo, this just moves it
out into the canonical function that other arch's define.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/signal_32.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index d840bc7..ad69434 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -621,6 +621,18 @@ int copy_siginfo_to_user32(struct compat_siginfo __user *d, siginfo_t *s)
 
 #define copy_siginfo_to_user	copy_siginfo_to_user32
 
+int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from)
+{
+	memset(to, 0, sizeof *to);
+
+	if (copy_from_user(to, from, 3*sizeof(int)) ||
+	    copy_from_user(to->_sifields._pad,
+			   from->_sifields._pad, SI_PAD_SIZE32))
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  * Note: it is necessary to treat pid and sig as unsigned ints, with the
  * corresponding cast to a signed int to insure that the proper conversion
@@ -634,9 +646,10 @@ long compat_sys_rt_sigqueueinfo(u32 pid, u32 sig, compat_siginfo_t __user *uinfo
 	int ret;
 	mm_segment_t old_fs = get_fs();
 
-	if (copy_from_user (&info, uinfo, 3*sizeof(int)) ||
-	    copy_from_user (info._sifields._pad, uinfo->_sifields._pad, SI_PAD_SIZE32))
-		return -EFAULT;
+	ret = copy_siginfo_from_user32(&info, uinfo);
+	if (unlikely(ret))
+		return ret;
+
 	set_fs (KERNEL_DS);
 	/* The __user pointer cast is valid becasuse of the set_fs() */
 	ret = sys_rt_sigqueueinfo((int)pid, (int)sig, (siginfo_t __user *) &info);
