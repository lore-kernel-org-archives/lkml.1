Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXDDR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXDDR3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXDDR3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:29:20 -0400
Received: from holomorphy.com ([66.93.40.71]:43727 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXDDR3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:29:20 -0400
Date: Wed, 4 Apr 2007 10:29:31 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: linux-kernel@vger.kernel.org
Subject: per-thread rusage
Message-ID: <20070404172931.GM2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is not now possible for a thread to retrieve its own rusage in
isolation. Its rusage is nowhere exposed without being intermixed with
that of its sibling threads. This patch adds support for an
RUSAGE_THREAD who argument that returns rusage for only the desired
thread.

Untested.


-- wli


Index: anon/include/linux/resource.h
===================================================================
--- anon.orig/include/linux/resource.h	2007-04-04 09:57:41.239118534 -0700
+++ anon/include/linux/resource.h	2007-04-04 09:57:59.840178548 -0700
@@ -18,7 +18,8 @@
  */
 #define	RUSAGE_SELF	0
 #define	RUSAGE_CHILDREN	(-1)
-#define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
+#define RUSAGE_THREAD	(-2)
+#define RUSAGE_BOTH	(-3)		/* sys_wait4() uses this */
 
 struct	rusage {
 	struct timeval ru_utime;	/* user time used */
Index: anon/kernel/sys.c
===================================================================
--- anon.orig/kernel/sys.c	2007-04-04 09:58:03.964413575 -0700
+++ anon/kernel/sys.c	2007-04-04 10:11:22.417914846 -0700
@@ -2013,6 +2013,14 @@
 	}
 
 	switch (who) {
+		case RUSAGE_THREAD:
+			utime = p->utime;
+			stime = p->stime;
+			r->ru_nvcsw = p->nvcsw;
+			r->ru_nivcsw = p->nivcsw;
+			r->ru_minflt = p->min_flt;
+			r->ru_majflt = p->maj_flt;
+			break;
 		case RUSAGE_BOTH:
 		case RUSAGE_CHILDREN:
 			utime = p->signal->cutime;
@@ -2064,7 +2072,8 @@
 
 asmlinkage long sys_getrusage(int who, struct rusage __user *ru)
 {
-	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
+	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
+						who != RUSAGE_THREAD)
 		return -EINVAL;
 	return getrusage(current, who, ru);
 }
