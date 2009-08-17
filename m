Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZHQQDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZHQQDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbZHQQDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:03:24 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34849 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbZHQQDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:03:23 -0400
Date: Mon, 17 Aug 2009 09:03:19 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: clocksource changes in 2.6.31 - possible regression
Message-ID: <20090817090319.20979986@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit causes a change for kernels built with HRT but
not actually using HRT.  I typically use the generic kernel we ship
on test machines, and that kernel has NOHZ and HRT (for power savings/virt
and HRT for QoS), but I want to be able to enable TSC as a clock source
when doing performance tests with pktgen.

The machine in question is a several year old Opteron box, that
normally reports clocksources: acpi_pm jiffies tsc
but now with 2.6.31-rc6, it only has acpi_pm.

Since HRT/NOHZ is not really runtime configurable, I think the
proper behavior is:

  * kernel reports all possible clocksources and chooses the best
    by default
  * if user demands a different clocksource, the kernel should use that
    but degrade if necessary: ie. high-res timers have less (maybe even
    only HZ accuracy), and nohz should be automatically disabled if
    needed

commit 3f68535adad8dd89499505a65fb25d0e02d118cc
Author: john stultz <johnstul@us.ibm.com>
Date:   Wed Jan 21 22:53:22 2009 -0700

    clocksource: sanity check sysfs clocksource changes
    
    Thomas, Andrew and Ingo pointed out that we don't have any safety checks
    in the clocksource sysfs entries to make sure sysadmins don't try to
    change the clocksource to a non high-res timer capable clocksource (such
    as jiffies) when high-res timers (HRT) is enabled.  Doing so will likely
    hang a system.
    
    Correct this by filtering non HRT clocksources from available_clocksources
    and not accepting non HRT clocksources with HRT enabled.
    
    Signed-off-by: John Stultz <johnstul@us.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
