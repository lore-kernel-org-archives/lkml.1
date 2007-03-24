Return-Path: <linux-kernel-owner+w=401wt.eu-S1750865AbXCXHbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865AbXCXHbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbXCXHbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:31:23 -0400
Received: from peabody.ximian.com ([130.57.169.10]:36810 "EHLO
	peabody.ximian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXCXHbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:31:21 -0400
Subject: [RFC][PATCH 0/3] A Dynticks Aware Processor Idle PM Governor
From: Adam Belay <abelay@novell.com>
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Shaohua Li <shaohua.li@intel.com>, Pallipadi@vger.kernel.org,
       Venkatesh <venkatesh.pallipadi@intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Sat, 24 Mar 2007 03:46:52 -0400
Message-Id: <1174722412.32554.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Here is my first take at implementing an idle PM governor that takes
full advantage of NO_HZ.  I call it the 'menu' governor because it
considers the full list of idle states before each entry.

I've kept the implementation fairly simple.  It attempts to guess the
next residency time and then chooses a state that would meet at least
the break-even point between power savings and entry cost.  To this end,
it selects the deepest idle state that satisfies the following
constraints:
     1. If the idle time elapsed since bus master activity was detected
        is below a threshold (currently 20 ms), then limit the selection
        to C2-type or above.
     2. Do not choose a state with a break-even residency that exceeds
        the expected time remaining until the next timer interrupt.
     3. Do not choose a state with a break-even residency that exceeds
        the elapsed time between the last pair of break events,
        excluding timer interrupts.

This governor has an advantage over "ladder" governor because it
proactively checks how much time remains until the next timer interrupt
using the tick infrastructure.  Also, it handles device interrupt
activity more intelligently by not including timer interrupts in break
event calculations.  Finally, it doesn't make policy decisions using the
number of state entries, which can have variable residency times (NO_HZ
makes these potentially very large), and instead only considers sleep
time deltas.

The menu governor can be selected during runtime using the cpuidle sysfs
interface like so:
"echo "menu" > /sys/devices/system/cpu/cpuidle/current_governor"

This patchset applies against 2.6.21-rc4 plus the latest from the acpi
testing tree, which is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/test/2.6.21/acpi-test-20070126-2.6.21-rc4.diff.bz2

I'd really appreciate any comments, benchmarks, or suggestions.

Cheers,
Adam


