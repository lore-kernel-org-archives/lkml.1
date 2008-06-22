Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYFWISw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYFWISw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYFWISo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:18:44 -0400
Received: from mail.jambit.com ([62.245.207.83]:36572 "EHLO mail.jambit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbYFWISn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:18:43 -0400
Message-ID: <485E005F.5000903@gmail.com>
Date: Sun, 22 Jun 2008 09:33:51 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch] adjtimex() modes argument checking
References: <485DF41E.9020909@gmail.com>
In-Reply-To: <485DF41E.9020909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

I see you added a number of new modes to adtimex() in 2.6.26-rc.
Since these are userspace-visible changes, please CC me, so
that they stand a chance of getting documented in man-pages.
(I discovered these changes only by accident.)

I also have some changes to suggest for argument checking, which,
if I understand the code correctly, prevent obvious screw-ups by
callers of adjtimex().  What do you think of the patch below?

Cheers,

Michael

--- linux-2.6.26-rc6/kernel/time/ntp.c        2008-06-22 09:05:05.000000000 +0200
+++ linux-2.6.26-rc6-p/kernel/time/ntp.c       2008-06-22 09:04:31.000000000 +0200
@@ -292,6 +292,16 @@
                         return -EINVAL;
         }

+       /* These modes are the converse of one another  */
+
+       if ((txc->modes & ADJ_MICRO) && (txc->modes & ADJ_NANO))
+               return -EINVAL;
+
+       /* Both of the following want to use txc->constant */
+
+       if ((txc->modes & ADJ_TIMECONST) && (txc->modes & ADJ_TAI))
+               return -EINVAL;
+
         /* if the quartz is off by more than 10% something is VERY wrong ! */
         if (txc->modes & ADJ_TICK)
                 if (txc->tick <  900000/USER_HZ ||


