Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZIYQBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZIYQBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZIYQBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:01:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:55375 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZIYQBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:01:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKeFvEqrR7PE/2dsb2JhbAC+R4hTAZAABYQegV0
X-IronPort-AV: E=Sophos;i="4.44,452,1249257600"; 
   d="scan'208";a="396136828"
From: Roland Dreier <rdreier@cisco.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: Len Brown <lenb@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi\@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Kill overly verbose "power state" log messages
References: <adapr9gypqz.fsf@cisco.com>
	<1253839597.3609.459.camel@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 25 Sep 2009 09:01:43 -0700
In-Reply-To: <1253839597.3609.459.camel@localhost.localdomain> (ykzhao's
	message of "Fri, 25 Sep 2009 08:46:37 +0800")
Message-ID: <adak4znypw8.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Sep 2009 16:01:44.0319 (UTC) FILETIME=[7A66D0F0:01CA3DF9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len, I see I messed up editing my changelog message, see below...

 > > I was recently lucky enough to get a 64-CPU system.  The processors
 > > actually have T-states, so my kernel log ends up with 64 lines like:
 > > 
 > >     ACPI: CPU0 (power states: C1[C1] C2[C3])
 > > 
 > > This is pretty useless clutter because this info is already available
 > > after boot from both /sys/devices/system/cpu/cpu*/cpuidle/state?/ as
 > > well as /proc/acpi/processor/CPU*/power.
 > > 
 > > So just delete the code that prints the throttling states in
 > > processor_idle.c.

 > It seems that it is unnecessary to delete the C-state info.

Sorry, this is a little too terse for me to know what you mean.
Certainly it's not useful to have 64 copies of

    ACPI: CPU0 (power states: C1[C1] C2[C3])

in the kernel log on a big box, when all 64 processors are going to
support the same C-states.  However, I don't see what the use of having
even one copy in the boot log is, when I can easily get that info at
runtime from /proc/acpi/processor/CPU*/power.


Anyway, Len, I see I copy-and-pasted too quickly from my T-state patch
submission... if you want to apply, a version with better changelog would be:

<--- snip --->

I was recently lucky enough to get a 64-CPU system, so my kernel log
ends up with 64 lines like:

    ACPI: CPU0 (power states: C1[C1] C2[C3])

This is pretty useless clutter because this info is already available
after boot from both /sys/devices/system/cpu/cpu*/cpuidle/state?/ as
well as /proc/acpi/processor/CPU*/power.

So just delete the code that prints the C-states in processor_idle.c.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/acpi/processor_idle.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index cc61a62..706eacf 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1214,13 +1214,6 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
 		acpi_processor_setup_cpuidle(pr);
 		if (cpuidle_register_device(&pr->power.dev))
 			return -EIO;
-
-		printk(KERN_INFO PREFIX "CPU%d (power states:", pr->id);
-		for (i = 1; i <= pr->power.count; i++)
-			if (pr->power.states[i].valid)
-				printk(" C%d[C%d]", i,
-				       pr->power.states[i].type);
-		printk(")\n");
 	}
 #ifdef CONFIG_ACPI_PROCFS
 	/* 'power' [R] */
