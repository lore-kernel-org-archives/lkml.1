Return-Path: <linux-kernel-owner+w=401wt.eu-S1762668AbXF0Roa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668AbXF0Roa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbXF0RoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:44:22 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:32786 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXF0RoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:44:22 -0400
Date: Wed, 27 Jun 2007 19:45:40 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070627174537.GM13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com> <1182855427.12109.203.camel@pmac.infradead.org> <20070626170622.GA13886@enneenne.com> <1182879520.3263.19.camel@shinybook.infradead.org> <20070627101449.GH13886@enneenne.com> <1182939510.6409.17.camel@pmac.infradead.org> <20070627125802.GI13886@enneenne.com> <1182960660.1170.12.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x+RZeZVNR8VILNfK"
Content-Disposition: inline
In-Reply-To: <1182960660.1170.12.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 27, 2007 at 05:11:00PM +0100, David Woodhouse wrote:

> No, because you're passing a _kernel_ pointer to sys_time_pps_fetch()
> where it expects a userspace pointer. Use compat_alloc_user_space() to
> find somewhere to put it in user space, instead. Or change your internal
> __sys_time_pps_fetch() function to take a number of ticks instead of a
> pointer to a timespec, then call that directly with appropriate
> arguments, from both the normal and compat syscall routines.

Ok. Please see the attached patch.

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index befe292..820cc9a 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 #include <linux/pps.h>
 #include <asm/uaccess.h>
 
@@ -284,13 +285,12 @@ sys_time_pps_getcap_exit:
 	return ret;
 }
 
-asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
+static long __sys_time_pps_fetch(int source, const int tsformat,
 					struct pps_info __user *info, 
-					const struct timespec __user *timeout)
+					const struct timespec *timeout)
 {
 	unsigned long ticks;
 	struct pps_info pi;
-	struct timespec to;
 	int ret;
 
 	pps_dbg("%s: source %d", __FUNCTION__, source);
@@ -317,24 +317,19 @@ asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
 	pps_source[source].go = 0;
 
  	/* Manage the timeout */
-	if (timeout) {
-		ret = copy_from_user(&to, timeout, sizeof(struct timespec));
-		if (ret)
-			goto sys_time_pps_fetch_exit;
-		if (to.tv_sec != -1) {
-			pps_dbg("timeout %ld.%09ld", to.tv_sec, to.tv_nsec);
-			ticks = to.tv_sec * HZ;
-			ticks += to.tv_nsec / (NSEC_PER_SEC / HZ);
-
-			if (ticks != 0) {
-				ret = wait_event_interruptible_timeout(
-					pps_source[source].queue,
-					pps_source[source].go, ticks);
-  				if (ret == 0) {
-					pps_dbg("timeout expired");
-					ret = -ETIMEDOUT;
-					goto sys_time_pps_fetch_exit;
-				}
+	if (timeout->tv_sec != -1) {
+		pps_dbg("timeout %ld.%09ld", timeout->tv_sec, timeout->tv_nsec);
+		ticks = timeout->tv_sec * HZ;
+		ticks += timeout->tv_nsec / (NSEC_PER_SEC / HZ);
+
+		if (ticks != 0) {
+			ret = wait_event_interruptible_timeout(
+				pps_source[source].queue,
+				pps_source[source].go, ticks);
+  			if (ret == 0) {
+				pps_dbg("timeout expired");
+				ret = -ETIMEDOUT;
+				goto sys_time_pps_fetch_exit;
 			}
 		}
  	} else
@@ -362,6 +357,44 @@ sys_time_pps_fetch_exit:
 	return ret;
 }
 
+asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
+					struct pps_info __user *info, 
+					const struct timespec __user *timeout)
+{
+	int ret;
+	struct timespec to;
+
+	if (timeout) {
+		ret = copy_from_user(&to, timeout, sizeof(struct timespec));
+		if (ret)
+			return ret;
+	}
+	else
+		to.tv_sec = -1;	
+
+	return __sys_time_pps_fetch(source, tsformat, info, timeout);
+}
+
+#ifdef CONFIG_COMPAT
+asmlinkage long compat_sys_time_pps_fetch(int source, const int tsformat,
+				struct pps_info __user *info, 
+				const struct compat_timespec __user *timeout)
+{
+	int ret;
+	struct timespec to;
+
+	if (timeout) {
+		ret = get_compat_timespec(&to, timeout);
+		if (ret)
+			return -EFAULT;
+	}
+	else
+		to.tv_sec = -1;	
+	
+	return __sys_time_pps_fetch(source, tsformat, info, &to);
+}
+#endif
+
 /*
  * Module staff
  */

--x+RZeZVNR8VILNfK--
