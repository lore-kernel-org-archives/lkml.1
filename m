Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZH0Vsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZH0Vsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZH0Vsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:48:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35849 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbZH0Vsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:48:51 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5722"; a="22737649"
Message-ID: <4A96FF44.8060208@codeaurora.org>
Date: Thu, 27 Aug 2009 17:48:52 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: [RFC] [PATCH 0/1] hrtimers: Remove unnecessary clock events device
 programming
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hrtimer_force_reprogram() was being called quite often unnecessarily. 
The following patch caches the hrtimer that causes the 
cpu_base->expires_next value to change. This way, we force the reprogram 
only when remove_hrtimer() finds that its going to remove an hrtimer 
which was about expire next. IOW, we forgo reprogramming the clock 
events device, if the current timer to be removed isn't at the root of 
the expires tree.

Also removed the hrtimer_is_queued check from remove_hrtimer and made 
appropriate changes to all callers. That check seemed redundant.


Results:

Shows ~60% reduction in the following calls to program clock events device.
-  tick_nohz_restart_sched_tick (tick_sched_timer)
-  hrtimer_start (tick_sched_timer)

I haven't traced all the callers yet, this was from a hack to 
timer_stats. If you guys have a better way to test this, I'll give that 
a go.

Tested on v2.6.29 on an ARM based embedded device.

Cheers,
Ashwin
