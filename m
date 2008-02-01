Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbYBANgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbYBANgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbYBANfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:35:41 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57840 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555AbYBANfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:35:40 -0500
Date: Fri, 1 Feb 2008 16:38:03 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Toyo Abe <toyoa@mvista.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] compat_sys_clock_nanosleep: fix *rmtp handling for -EINTR case
Message-ID: <20080201133803.GA25629@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

COMPLETELY UNTESTED.

compat_sys_clock_nanosleep() update rmtp only if err == -ERESTART_RESTARTBLOCK.
This is wrong, nanosleep() can return -EINTR if flags & TIMER_ABSTIME.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/kernel/compat.c~4_COMPAT_CLOCK	2008-02-01 14:50:01.000000000 +0300
+++ MM/kernel/compat.c	2008-02-01 15:05:28.000000000 +0300
@@ -618,8 +618,7 @@ static long compat_clock_nanosleep_resta
 	err = clock_nanosleep_restart(restart);
 	set_fs(oldfs);
 
-	if ((err == -ERESTART_RESTARTBLOCK) && rmtp &&
-	    put_compat_timespec(&tu, rmtp))
+	if (err && rmtp && put_compat_timespec(&tu, rmtp))
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {
@@ -648,8 +647,7 @@ long compat_sys_clock_nanosleep(clockid_
 				  (struct timespec __user *) &out);
 	set_fs(oldfs);
 
-	if ((err == -ERESTART_RESTARTBLOCK) && rmtp &&
-	    put_compat_timespec(&out, rmtp))
+	if (err && rmtp && put_compat_timespec(&out, rmtp))
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {

