Return-Path: <linux-kernel-owner+w=401wt.eu-S1765322AbYBZVPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765322AbYBZVPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbYBZVPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:15:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:43771 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbYBZVPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=KEvqbX80yVyGwhEggZkxJ0JiDMw9Fan/fPzGUrxvWQ9pFr2IaqPrK6tsBWvSAQhVUEpLrLhL2d3Oy6fkxJXlRPkGsAaSITLL5rJ3UnZej6w/5CvrDapzcr8aTn5oV8oMhW89GyoVlWixBgX8nF72+rNbz26nmipWh5SubET3Y1k=
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: 2.6.25-rc2 rcupreempt WARN after suspend to ram
Date: Tue, 26 Feb 2008 22:15:10 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Rafael Wysocki <rjw@sisk.pl>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@osdl.org
References: <200802231341.02597.fzu@wemgehoertderstaat.de> <20080224182800.GA10194@linux.vnet.ibm.com> <200802260309.36360.fzu@wemgehoertderstaat.de>
In-Reply-To: <200802260309.36360.fzu@wemgehoertderstaat.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262215.10869.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Februar 2008 schrieb Karsten Wiese:
> Am Sonntag, 24. Februar 2008 schrieb Paul E. McKenney:
> > On Sun, Feb 24, 2008 at 04:38:15PM +0100, Karsten Wiese wrote:
> > > Am Samstag, 23. Februar 2008 schrieb Karsten Wiese:
> > > > Am Samstag, 23. Februar 2008 schrieb Paul E. McKenney:
> > > > > On Sat, Feb 23, 2008 at 01:41:02PM +0100, Karsten Wiese wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > This appeared in dmesg after
> > > > > > 	$ echo core > /sys/power/pm_test
> > > > > > followed by 3 cycles of
> > > > > > 	$ echo mem > /sys/power/state
> > > > > > . .config attached.
> > > > > > 
> > > > > > dmesg excerpt (, full ~1MByte available):
> > > > > 
> > > > > Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?
> > > > 
> > > > Yes. This tree was linus' git head as of yesterday or the day before.
> > > 
> > > Updated to git-head of today, same test and .config, different symptoms
> > > like in this thread: http://lkml.org/lkml/2008/2/23/260
> > > Later in this thread, Alan Cox said it looked like irq problems.
> > > Maybe also the rcupreemt related WARN_ON I saw are caused by irq problems.
> > 
> > Might be, but am taking a closer look at the interaction between irq,
> > dynticks, and rcupreempt in any case.
> 
> [Added Rafael, Thomas and Steven to CC]
> 
> The "different symptoms" above are indeed unrelated and solved by reverting
> 	"commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
>     	 power_state: get rid of write-only variable in SATA"
> 
> The cpu_hotplug code used by suspend together with hr_timer and nohz looks
> suspicious:
> 	$ echo 0 > /sys/devices/system/cpu/cpu1/online
> 	$ echo 1 > /sys/devices/system/cpu/cpu1/online
> 	(repeat until dmesg|tail shows WARNs; here it took 2 iterations)
> causes symptoms like in 1st message of this thread again.

[Added Andrew]

This fixes it, not sure if its not just papering over, though it seams to be
likely for an offlined CPU to have ticks stopped.

Thanks,
      Karsten
---

Don't touch an offlined CPU's ts->tick_stopped in tick_cancel_sched_timer()

Silences WARN_ONs in rcu_enter_nohz() and rcu_exit_nohz(), which appeared
before caused by (repeated) calls to:
        $ echo 0 > /sys/devices/system/cpu/cpu1/online
        $ echo 1 > /sys/devices/system/cpu/cpu1/online

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2968298..686da82 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -640,7 +640,7 @@ void tick_cancel_sched_timer(int cpu)
 
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
-	ts->tick_stopped = 0;
+
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
 #endif /* HIGH_RES_TIMERS */
-- 
1.5.3.3

