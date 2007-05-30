Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbXE3Sna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbXE3Sna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbXE3SnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:43:20 -0400
Received: from stinky.trash.net ([213.144.137.162]:45720 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbXE3SnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:43:19 -0400
Message-ID: <465DC598.5060407@trash.net>
Date: Wed, 30 May 2007 20:42:32 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] Make net watchdog timers 1 sec jiffy aligned
References: <20070529180112.GC5411@linux-os.sc.intel.com>	<20070530105936.6c988da5.akpm@linux-foundation.org> <20070530112056.0aeb9498@freepuppy>
In-Reply-To: <20070530112056.0aeb9498@freepuppy>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
>>>Index: linux-2.6.22-rc-mm/net/sched/sch_generic.c
>>>===================================================================
>>>--- linux-2.6.22-rc-mm.orig/net/sched/sch_generic.c	2007-05-24 11:16:03.000000000 -0700
>>>+++ linux-2.6.22-rc-mm/net/sched/sch_generic.c	2007-05-25 15:10:02.000000000 -0700
>>>@@ -224,7 +224,8 @@
>>> 	if (dev->tx_timeout) {
>>> 		if (dev->watchdog_timeo <= 0)
>>> 			dev->watchdog_timeo = 5*HZ;
>>>-		if (!mod_timer(&dev->watchdog_timer, jiffies + dev->watchdog_timeo))
>>>+		if (!mod_timer(&dev->watchdog_timer,
>>>+			       round_jiffies(jiffies + dev->watchdog_timeo)))
>>> 			dev_hold(dev);
>>> 	}
>>> }
>>
>>Please cc netdev on net patches.
>>
>>Again, I worry that if people set the watchdog timeout to, say, 0.1 seconds
>>then they will get one second, which is grossly different.
>>
>>And if they were to set it to 1.5 seconds, they'd get 2.0 which is pretty
>>significant, too.
> 
> 
> Alternatively, we could change to a timer that is pushed forward after each
> TX, maybe using hrtimer and hrtimer_forward().  That way the timer would
> never run in normal case.


It seems wasteful to add per-packet overhead for tx timeouts, which
should be an exception. Do drivers really care about the exact
timeout value? Compared to a packet transmission time its incredibly
long anyways ..

