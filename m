Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYDKROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYDKROR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbYDKROC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:14:02 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:46262 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760404AbYDKROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:14:01 -0400
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2008 13:14:01 EDT
Date: Fri, 11 Apr 2008 18:54:17 +0200 (CEST)
From: Erik Bosman <ebn310@few.vu.nl>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Add prctl commands PR_GET_TSC and PR_SET_TSC
Message-ID: <Pine.GSO.4.56.0804111850060.16609@keg.few.vu.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    This patch adds prctl commands that make it possible
    to deny the execution of timestamp counters in userspace.
    If this is not implemented on a specific architecture,
    prctl will return -EINVAL.

	Signed-off-by: Erik Bosman <ejbosman@cs.vu.nl>
---
 include/linux/prctl.h |    6 ++++++
 kernel/sys.c          |   13 ++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 3800639..5c80b19 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -67,4 +67,10 @@
 #define PR_CAPBSET_READ 23
 #define PR_CAPBSET_DROP 24

+/* Get/set the process' ability to use the timestamp counter instruction */
+#define PR_GET_TSC 25
+#define PR_SET_TSC 26
+# define PR_TSC_ENABLE		1	/* allow the use of the timestamp counter */
+# define PR_TSC_SIGSEGV		2	/* throw a SIGSEGV instead of reading the TSC */
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index a626116..6a0cc71 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -67,6 +67,12 @@
 #ifndef SET_ENDIAN
 # define SET_ENDIAN(a,b)	(-EINVAL)
 #endif
+#ifndef GET_TSC_CTL
+# define GET_TSC_CTL(a)		(-EINVAL)
+#endif
+#ifndef SET_TSC_CTL
+# define SET_TSC_CTL(a)		(-EINVAL)
+#endif

 /*
  * this is where the system-wide overflow UID and GID are defined, for
@@ -1737,7 +1743,12 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 #else
 			return -EINVAL;
 #endif
-
+		case PR_GET_TSC:
+			error = GET_TSC_CTL(arg2);
+			break;
+		case PR_SET_TSC:
+			error = SET_TSC_CTL(arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;
