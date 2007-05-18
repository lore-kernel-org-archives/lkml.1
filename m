Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbXERCZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbXERCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbXERCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:25:20 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42423 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbXERCZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:25:19 -0400
Subject: [PATCH] vsyscall time() fix
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Sripathi Kodi <sripathi@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 17 May 2007 19:25:10 -0700
Message-Id: <1179455110.6177.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew, Andi,

	The vsyscall time() function basically returns the second portion of
xtime directly. This however means that there is about a ticks worth of
time each second where time() will return a second value less then what
gettimeofday() does.

Additionally, this window where vtime() is behind vgettimeofday() grows
when dynticks is enabled, so its probably good to get this in before
dynticks lands.

Big thanks to Sripathi for noticing this issue and creating a test case
to work with!

Andi: I can rediff this against 2.6.21-stable as well if you want,
although the behavior has been around for awhile, so I'm not sure how
urgent you feel it is.

thanks
-john


This patch changes the vtime() implemenation to call vgettimeofday(),
much as syscall time() implementation calls gettimeofday().


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 51d4c6f..57660d5 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -175,10 +175,13 @@ int __vsyscall(0) vgettimeofday(struct timeval * tv, struct timezone * tz)
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
+	struct timeval tv;
 	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
-	result = __vsyscall_gtod_data.wall_time_sec;
+
+	vgettimeofday(&tv, 0);
+	result = tv.tv_sec;
 	if (t)
 		*t = result;
 	return result;



