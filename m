Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbZJGIqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbZJGIqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbZJGIqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:46:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:36256 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbZJGIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:46:46 -0400
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: ext Steven Noonan <steven@uplinklabs.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <f488382f0910070124v6f1e1539gbeb7765ab6f32231@mail.gmail.com>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <f488382f0910060422t420ade8bvdefbf3e3d0720266@mail.gmail.com>
	 <1254832609.31336.290.camel@eenurkka-desktop>
	 <f488382f0910061754g6d15cf58v572e85701fc5aa4f@mail.gmail.com>
	 <f488382f0910061822wf8da0c1m7f118f04fe793abe@mail.gmail.com>
	 <1254893230.30157.28.camel@eenurkka-desktop>
	 <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
	 <1254901778.30157.62.camel@eenurkka-desktop>
	 <f488382f0910070105g19cbf75ci8034f2917b7e5606@mail.gmail.com>
	 <1254903263.30157.69.camel@eenurkka-desktop>
	 <f488382f0910070124v6f1e1539gbeb7765ab6f32231@mail.gmail.com>
Content-Type: text/plain
Organization: Nokia
Date: Wed, 07 Oct 2009 11:43:33 +0300
Message-Id: <1254905013.30157.75.camel@eenurkka-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2009 08:44:44.0060 (UTC) FILETIME=[6ADDCDC0:01CA472A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 10:24 +0200, ext Steven Noonan wrote:
> >
> > Steven, how do the cpu loads look like without the patch?
> 
> They're sane:
> 
> [   40.019381] cpufreq load = 100 * (66666 - 66337) / 66666 = 0
> [   40.019396] cpufreq load = 100 * (66666 - 66299) / 66666 = 0
> [   73.352580] cpufreq load = 100 * (66717 - 66349) / 66717 = 0
> [   73.352595] cpufreq load = 100 * (66634 - 63848) / 66634 = 4

Thank you. Could you please try the following:
Now, if ts->nohz_mode == NOHZ_MODE_INACTIVE, ts->inidle is not set
and all subsequent calls from irq_exit() think we weren't idling,
which is not true.

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -233,6 +233,8 @@ void tick_nohz_stop_sched_tick(int inidle)
 
        now = tick_nohz_start_idle(ts);
 
+       ts->inidle = 1;
+
        /*
         * If this cpu is offline and it is the one which updates
         * jiffies, then give up the assignment and let it be taken by
@@ -248,8 +250,6 @@ void tick_nohz_stop_sched_tick(int inidle)
        if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
                goto end;
 
-       ts->inidle = 1;
-
        if (need_resched())
                goto end;
 




