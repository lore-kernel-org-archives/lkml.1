Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZBHXXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZBHXXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZBHXX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:23:26 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42494 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbZBHXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:23:25 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 8 Feb 2009 15:23:23 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Michael Kerrisk <mtk.manpages@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/2] timerfd extend clockid support
Message-ID: <alpine.DEB.1.10.0902081510150.18839@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch extends timerfd clockid support to cover the ones 
supported by timer_create(). 
It exports the invalid_clockid() function outside posix-timers.c to allow 
timerfd to properly check input parameters.
Andrew, this is (eventually) .30 material, and do not take the patch 
until you have Thomas sign off.
Thomas, timerfd uses core hrtimer functions for its tasks. By extending 
the clockid support, I assume that the clockids other than CLOCK_MONOTONIC 
and CLOCK_REALTIME, behaves the same from a hrtimer caller POV. Right?



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/timerfd.c                 |    3 +--
 include/linux/posix-timers.h |    1 +
 kernel/posix-timers.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2009-02-08 15:02:06.000000000 -0800
+++ linux-2.6.mod/fs/timerfd.c	2009-02-08 15:03:43.000000000 -0800
@@ -187,8 +187,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
 
 	if ((flags & ~TFD_CREATE_FLAGS) ||
-	    (clockid != CLOCK_MONOTONIC &&
-	     clockid != CLOCK_REALTIME))
+	    invalid_clockid(clockid))
 		return -EINVAL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
Index: linux-2.6.mod/include/linux/posix-timers.h
===================================================================
--- linux-2.6.mod.orig/include/linux/posix-timers.h	2009-02-08 15:02:06.000000000 -0800
+++ linux-2.6.mod/include/linux/posix-timers.h	2009-02-08 15:02:53.000000000 -0800
@@ -84,6 +84,7 @@ struct k_clock {
 			   struct itimerspec * cur_setting);
 };
 
+int invalid_clockid(const clockid_t which_clock);
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* error handlers for timer_create, nanosleep and settime */
Index: linux-2.6.mod/kernel/posix-timers.c
===================================================================
--- linux-2.6.mod.orig/kernel/posix-timers.c	2009-02-08 15:02:06.000000000 -0800
+++ linux-2.6.mod/kernel/posix-timers.c	2009-02-08 15:02:53.000000000 -0800
@@ -205,7 +205,7 @@ static int no_timer_create(struct k_itim
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
-static inline int invalid_clockid(const clockid_t which_clock)
+int invalid_clockid(const clockid_t which_clock)
 {
 	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
 		return 0;
