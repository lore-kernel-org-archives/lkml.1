Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbXHBJC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbXHBJC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXHBJCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:02:21 -0400
Received: from mailout03.sul.t-online.de ([194.25.134.81]:52966 "EHLO
	mailout03.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbXHBJCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:02:20 -0400
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 05:02:20 EDT
Message-ID: <46B1988C.3090302@t-online.de>
Date: Thu, 02 Aug 2007 10:40:44 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, trenn@suse.de, pavel@ucw.cz,
       mjg59@srcf.ucam.org, lenb@kernel.org
Subject: 2.6.22 regression: thermal trip points
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-ID: V+eJ8ZZeQeqx5K0KTMBEjEUc8N2mqIbGbh-ZcRpAKpCJKIit7FZFkO
X-TOI-MSGID: 8ea7915c-6580-41ec-a7a7-0e6aa4919e49
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody!

Kernel 2.6.22 decreases performance by about 50% on my system.
No, I do not like that. The reason is a broken BIOS, granted, but there
was a perfect workaround in the kernel that has been dropped.

mainboard: AOpen i915GMm-hfs, AWARD BIOS
cpu: Pentium-M 750 (0.8 to 1.86 MHz)
openSuSE 10.2 with kernel 2.6.22.1

The cpu fan can not be controled by linux kernel.
The BIOS will switch on the cpu fan a bit above 50 deg. Celsius.
The active and passive trip points both are set to 50 deg. Celsius.
Temperature of the idle cpu at 800 Mhz: 34 to 42 deg. C.
The BIOS never changes the trip points.
Cpufreq does work perfectly.

Previously there was the possibility  to add something like

echo  "100:0:65:70:0" > /proc/acpi/thermal_zone/THRM/trip_points
echo  2 > /proc/acpi/thermal_zone/THRM/polling_frequency
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

to e.g. /etc/init.d/boot.local. With 2.6.22 that solution does not exist
any longer. Now the code in thermal.c slows down the cpu under load
to prevent "overheating". Kernel compile time increases from about 12
to 18 minutes. No, I don´t like that, nobody would.

Possible solutions:

1. Get a better BIOS! --- There is none.

2. Fix DSDT!  --- Recompiling gives a number of errors ... I do not  know
how to fix it.

3. Don´t include thermal.c! --- That does help, but as this is a 24/7
system, the
cpu fan could break. At that time I do not want to rely on the BIOS to
save my
system (the next trip point is at 100 deg. Celsius).

4. Revert Len Browns commit 11ccc0f249cb01a129f54760b8ff087f242935d4

I would vote for option 4, but I do understand some of the arguments of
Len in
the 2.6.22-rc1-mm1 discussion in May. Yes, communicating trip points to
thermal.c is a hack, it will fail on systems that change trip points
dynamically
and it might be dangerous for the machine if unreasonable trip points
are chosen.
But it does help to keep the machine quiet, and to work around a too low
or too
trip points defined by the BIOS.

If it should be not acceptable to revert the questionable commit without
changes,
would it be acceptable to make rw trip_points a kernel config option?

cu,
 Knut Petersen
