Return-Path: <linux-kernel-owner+w=401wt.eu-S1763595AbYBANfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763595AbYBANfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbYBANfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:35:39 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57827 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbYBANfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:35:38 -0500
Date: Fri, 1 Feb 2008 16:37:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@sw.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] hrtimer_nanosleep: use -EINTR, not -ERESTARTNOHAND
Message-ID: <20080201133755.GA25620@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_nanosleep:

	/* Absolute timers do not update the rmtp value and restart: */
	return -ERESTARTNOHAND;

This is not right, -ERESTARTNOHAND means we will do restart if there is no
in fact pending signal, and worse, this restart will use the same unchanged
"__user *rmtp" parameter.

Use -EINTR instead.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- MM/kernel/hrtimer.c~HRT_RMTP~	2008-01-27 17:07:39.000000000 +0300
+++ MM/kernel/hrtimer.c~HRT_RMTP	2008-02-01 13:43:52.000000000 +0300
@@ -1359,7 +1359,7 @@ long hrtimer_nanosleep(struct timespec *
 
 	/* Absolute timers do not update the rmtp value and restart: */
 	if (mode == HRTIMER_MODE_ABS)
-		return -ERESTARTNOHAND;
+		return -EINTR;
 
 	if (rmtp) {
 		rem = ktime_sub(t.timer.expires, t.timer.base->get_time());

