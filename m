Return-Path: <linux-kernel-owner+w=401wt.eu-S1030441AbXBGNfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030441AbXBGNfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 08:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXBGNfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 08:35:20 -0500
Received: from mkedef1.rockwellautomation.com ([208.22.104.18]:19199 "EHLO
	ramilwsmtp01.ra.rockwell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030441AbXBGNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 08:35:18 -0500
To: linux-kernel@vger.kernel.org
Subject: posix-timers overrun broken?
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5  CCH1 March 07, 2006
Message-ID: <OFA77229BB.3038F286-ONC125727B.0048DC3E-C125727B.004AA20A@ra.rockwell.com>
From: Milan Svoboda <msvoboda@ra.rockwell.com>
Date: Wed, 7 Feb 2007 14:36:12 +0100
X-MIMETrack: Serialize by Router on RAMilwSMTP01/Milwaukee/RA/Rockwell(Release 6.5.4FP1|June
 19, 2005) at 02/07/2007 07:36:19 AM,
	Serialize complete at 02/07/2007 07:36:19 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm creating a driver for timer on ixp4xx (there are two hardware timers). 
It shall use posix api
so I looked at the only driver that implements it in kernel: 
drivers/char/mmtimer.c. My driver uses almost the
same logic that handles overruns.

However, I found that receiving of number of overruns in waitsiginfo is 
somewhat broken.

Linux-2.6.20:

Look at posix_timer_event - this is called when interrupt wants to signal 
the thread that
event happend. The very first operation there is
        memset(&timr->sigq->info, 0, sizeof(siginfo_t));
this clears all info members - si.overrun included.
Then send_sigqueue or send_group_sigqueue is called. They both check if 
it's
SI_TIMER and if so, they increase si.overrun if the signal is already 
queued.

But if the next interrupt arrives before function collect_signal is called 
to actually deliver the
siginfo_t to userspace, the si.overrun is cleared in posix_timer_event and 
we have just forgotten
one overrun...

Am I wrong?

Patch follows, but please note that it is more to describe the problem 
than solve the problem in proper
way...

Please, CC me, I'm not subscribed on the list.

Signed-off-by: Milan Svoboda <msvoboda@ra.rockwell.com>

Index: linux/kernel/posix-timers.c
===================================================================
--- linux.orig/kernel/posix-timers.c
+++ linux/kernel/posix-timers.c
@@ -298,7 +298,10 @@ void do_schedule_next_timer(struct sigin
 
 int posix_timer_event(struct k_itimer *timr,int si_private)
 {
+       int overrun = timr->sigq->info.si_overrun;
        memset(&timr->sigq->info, 0, sizeof(siginfo_t));
+       timr->sigq->info.si_overrun = overrun;
+
        timr->sigq->info.si_sys_private = si_private;
        /* Send signal to the process that owns this timer.*/
 
@@ -407,6 +410,7 @@ static struct k_itimer * alloc_posix_tim
                kmem_cache_free(posix_timers_cache, tmr);
                tmr = NULL;
        }
+       tmr->sigq->info.si_overrun = 0;
        return tmr;
 }
 
Index: linux/kernel/signal.c
===================================================================
--- linux.orig/kernel/signal.c
+++ linux/kernel/signal.c
@@ -402,6 +402,7 @@ static int collect_signal(int sig, struc
        if (first) {
                list_del_init(&first->list);
                copy_siginfo(info, &first->info);
+               first->info.si_overrun = 0;
                __sigqueue_free(first);
                if (!still_pending)
                        sigdelset(&list->signal, sig);

