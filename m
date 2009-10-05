Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZJEQct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZJEQct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZJEQcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:32:48 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:55851 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZJEQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:32:47 -0400
Date: Mon, 5 Oct 2009 09:32:28 -0700 (PDT)
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
cc: Steven Noonan <steven@uplinklabs.net>,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [BISECTED] "conservative" cpufreq governor broken
Message-ID: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed on my machine that the "conservative" cpufreq governor wasn't 
working properly in v2.6.31.1 or Linus' latest tree, but it worked fine on 
v2.6.30.8, so I decided I should figure out where this issue was coming 
from. The issue is pretty clear...


Here's the expected:

cpufrequtils 005: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to cpufreq@vger.kernel.org, please.
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 1000 MHz - 2.33 GHz
  available frequency steps: 2.33 GHz, 2.17 GHz, 2.00 GHz, 1.83 GHz, 1.67 GHz, 1.50 GHz, 1.33 GHz, 1000 MHz
  available cpufreq governors: ondemand, userspace, powersave, conservative, performance
  current policy: frequency should be within 1000 MHz and 2.33 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 1000 MHz (asserted by call to hardware).
  cpufreq stats: 2.33 GHz:0.59%, 2.17 GHz:1.41%, 2.00 GHz:0.88%, 1.83 GHz:1.22%, 1.67 GHz:0.88%, 1.50 GHz:1.41%, 1.33 GHz:10.98%, 1000 MHz:82.63%  (33)
analyzing CPU 1:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 1
  hardware limits: 1000 MHz - 2.33 GHz
  available frequency steps: 2.33 GHz, 2.17 GHz, 2.00 GHz, 1.83 GHz, 1.67 GHz, 1.50 GHz, 1.33 GHz, 1000 MHz
  available cpufreq governors: ondemand, userspace, powersave, conservative, performance
  current policy: frequency should be within 1000 MHz and 2.33 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 1000 MHz (asserted by call to hardware).
  cpufreq stats: 2.33 GHz:0.40%, 2.17 GHz:0.16%, 2.00 GHz:0.16%, 1.83 GHz:0.35%, 1.67 GHz:0.16%, 1.50 GHz:0.35%, 1.33 GHz:0.16%, 1000 MHz:98.27%  (7)



And here is the broken version (note the 'cpufreq stats' line):

cpufrequtils 005: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to cpufreq@vger.kernel.org, please.
analyzing CPU 0:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 1000 MHz - 2.33 GHz
  available frequency steps: 2.33 GHz, 2.17 GHz, 2.00 GHz, 1.83 GHz, 1.67 GHz, 1.50 GHz, 1.33 GHz, 1000 MHz
  available cpufreq governors: ondemand, userspace, powersave, conservative, performance
  current policy: frequency should be within 1000 MHz and 2.33 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 2.33 GHz (asserted by call to hardware).
  cpufreq stats: 2.33 GHz:100.00%, 2.17 GHz:0.00%, 2.00 GHz:0.00%, 1.83 GHz:0.00%, 1.67 GHz:0.00%, 1.50 GHz:0.00%, 1.33 GHz:0.00%, 1000 MHz:0.00%
analyzing CPU 1:
  driver: acpi-cpufreq
  CPUs which need to switch frequency at the same time: 1
  hardware limits: 1000 MHz - 2.33 GHz
  available frequency steps: 2.33 GHz, 2.17 GHz, 2.00 GHz, 1.83 GHz, 1.67 GHz, 1.50 GHz, 1.33 GHz, 1000 MHz
  available cpufreq governors: ondemand, userspace, powersave, conservative, performance
  current policy: frequency should be within 1000 MHz and 2.33 GHz.
                  The governor "conservative" may decide which speed to use
                  within this range.
  current CPU frequency is 2.33 GHz (asserted by call to hardware).
  cpufreq stats: 2.33 GHz:100.00%, 2.17 GHz:0.00%, 2.00 GHz:0.00%, 1.83 GHz:0.00%, 1.67 GHz:0.00%, 1.50 GHz:0.00%, 1.33 GHz:0.00%, 1000 MHz:0.00%


So basically, it just never clocks down from the maximum frequency.


Here's the bisection log:

 # bad:  [2147b209] Linux 2.6.31.1
 # good: [a1c4c06a] Linux 2.6.30.8
 # good: [07a2039b] Linux 2.6.30
 # good: [452dac45] V4L/DVB (11761): dvb-ttpci: Fixed VIDEO_SLOWMOTION
 # bad:  [906e8d97] e1000e: delay second read of PHY_STATUS register o
 # good: [36e84467] Staging: heci: fix userspace pointer mess
 # bad:  [df36b439] Merge branch 'for-2.6.31' of git://git.linux-nfs.o
 # skip: [12e24f34] Merge branch 'perfcounters-fixes-for-linus' of git
 # good: [48c93112] powerpc: Fix invalid construct in our CPU selectio
 # bad:  [eca41044] n_r3964: fix lock imbalance
 # good: [93db6294] Merge branch 'for-linus' of git://git.kernel.org/p
 # bad:  [1eb51c33] Merge branch 'sched-fixes-for-linus' of git://git.
 # good: [1d991001] Merge branch 'x86/mce3' into x86/urgent
 # good: [71e308a2] function-graph: add stack frame test
 # bad:  [38df92b8] Merge branch 'timers-fixes-for-linus' of git://git
 # good: [ad5cf46b] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # good: [7fd5b632] Merge branch 'for-linus' of git://git.monstr.eu/li
 # good: [c4c5ab30] Merge branch 'x86-fixes-for-linus' of git://git.ke
 # bad:  [f2e21c96] NOHZ: Properly feed cpufreq ondemand governor


And finally, the commit that broke "conservative":

commit f2e21c9610991e95621a81407cdbab881226419b
Author: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Date:   Mon May 25 09:57:37 2009 +0300

    NOHZ: Properly feed cpufreq ondemand governor
    
    A call from irq_exit() may occasionally pause the timing
    info for cpufreq ondemand governor. This results in the
    cpufreq ondemand governor to fail to calculate the
    system load properly. Thus, relocate the checks for this
    particular case to keep the governor always functional.
    
    Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
    Reported-by: Tero Kristo <tero.kristo@nokia.com>
    Acked-by: Rik van Riel <riel@redhat.com>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


I'd work on fixing it myself and whip up a patch, but I'm going to be gone 
all day and I'm not too familiar with cpufreq anyway.

- Steven
