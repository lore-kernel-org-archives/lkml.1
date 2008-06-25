Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYFYOto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYFYOto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYFYOtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:49:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:26189 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYFYOte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=AAGm0TWwL4YP17epn4LI8yew+/zgE9M69I8rl/Oz/NNWSb8PtUkbMcwPecVjEiMaOC
         W5U81JCXr8HDAaXK+YXRuPQRGhnecOHD1Onbg1a2LQa4WHDeIsiVtqS60Qnl9ShVtAKn
         v3NhBhy/+4sSCOTvJ915zR0VvdXSCBU/GWf5Y=
Message-ID: <cfd18e0f0806250749od875635r9e533d9f834bd8c4@mail.gmail.com>
Date: Wed, 25 Jun 2008 16:49:33 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: [patch] make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bart Van Assche" <bart.vanassche@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, Thomas,

In the switch to configurable HZ in 2.6, the treatment of the si_utime
and si_stime fields that are exposed to userland via the siginfo
structure looks to have been botched.  As things stand, these fields
report times in units of HZ, so that userland gets information that
varies depending on the HZ that the kernel was configured with.  This
(trivial, untested) patch changes the reported values to use USER_HZ
units.  What do you think of making this change?

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c.orig	2008-06-24
16:20:39.000000000 +0200
+++ /home/mtk/ARCHIVE/KERNEL/linux-2.6.26-rc7/kernel/signal.c	2008-06-24
16:22:17.000000000 +0200
@@ -1379,10 +1379,9 @@

 	info.si_uid = tsk->uid;

-	/* FIXME: find out whether or not this is supposed to be c*time. */
-	info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
+	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
 						       tsk->signal->utime));
-	info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
+	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
 						       tsk->signal->stime));

 	info.si_status = tsk->exit_code & 0x7f;
@@ -1450,9 +1449,8 @@

 	info.si_uid = tsk->uid;

-	/* FIXME: find out whether or not this is supposed to be c*time. */
-	info.si_utime = cputime_to_jiffies(tsk->utime);
-	info.si_stime = cputime_to_jiffies(tsk->stime);
+	info.si_utime = cputime_to_clock_t(tsk->utime);
+	info.si_stime = cputime_to_clock_t(tsk->stime);

  	info.si_code = why;
  	switch (why) {
