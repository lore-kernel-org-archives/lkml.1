Return-Path: <linux-kernel-owner+w=401wt.eu-S966508AbXG3CyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966508AbXG3CyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbXG3CyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:54:16 -0400
Received: from zaphod.dth.net ([85.159.112.68]:49432 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbXG3CyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:54:15 -0400
Date: Mon, 30 Jul 2007 04:54:12 +0200
From: Danny ter Haar <dth@dth.net>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, len.brown@intel.com,
       linux-acpi@vger.kernel.org
Subject: Re: Update: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not:
Message-ID: <20070730025412.GA22888@dth.net>
References: <20070727193832.GA20289@dth.net> <200707290142.53689.bzolnier@gmail.com> <20070729012324.GA29723@dth.net> <46ABFFE4.3060703@googlemail.com> <20070729033030.GA24636@dth.net> <46AC0F6E.2000008@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AC0F6E.2000008@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gabriel C (nix.or.die@googlemail.com):
> Now while we think is ACPI this should be easy for you to bisect.
> This commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=39804b20f62532fa05c2a8c3e2d1ae551fd0327b
> merged ACPI so this one should be your first bad one.
> Maybe Len has some idea and you don't need to bisect :)

Thanks to personal coaching of Gabriel i bisected the last few days.

It looked like this was the cullprit:

22aadf8a07067644e101267ed5003043f2ad05bf is first bad commit

2.6.23-rc1-git[1-6] all lockup solid after either direct or
within a couple of minutes (less than 2) after reboot.

They all run fine with "acpi=off" as boot argument.


However, i'm currently running 2.6.23-rc1-git6 with this reverted:

diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
index 18c8b67..6f846be 100644 (file)
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -665,8 +665,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
        data->max_freq = perf->states[0].core_frequency * 1000;
        /* table init */
        for (i=0; i<perf->state_count; i++) {
-               if (i>0 && perf->states[i].core_frequency ==
-                   perf->states[i-1].core_frequency)
+               if (i>0 && perf->states[i].core_frequency >=
+                   data->freq_table[valid_states-1].frequency / 1000)
                        continue;

-----------

I could hardly believe this could be the cause.
And indeed after about 16 minutes the kernel froze again, though longer
uptime than other kernels :-(

This hardware is a via epia 5000 with latest bios available (2.07)

It's remarkable that with acpi=off the machine is rocksolid.
As is with 2.6.22* kernels _with_ acpi enabled!
weeks of uptime before i wanted to upgrade to a new kernel ;-)

I'm thinking of redoing the git disect but this time really powercycle
the unit between kernels since it "seems/feels" like a timer which 
really counts to 0 and then locks the machine. 
After a lockup/freeze i cant boot the kernel another time with acpi 
enabled: it will simply hang after booting init.
And again nobody home: no keyboard activity whatsoever.

I've put the dmesg of 2.6.23-rc1-git6 with and without acpi=off online:
http://www.dth.net/kernel/via_output_2.6.23-rc1-git6-acpi_off
http://www.dth.net/kernel/via_output_2.6.23-rc1-git6-acpi_on

I would like to hear if someone has an idea how to tackle this problem.

Danny
-- 
