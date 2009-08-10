Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZHJKbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZHJKbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 06:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZHJKbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 06:31:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39474 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZHJKbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:31:49 -0400
To: Johannes Stezenbach <js@sig21.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
From: Andi Kleen <andi@firstfloor.org>
References: <20090807170942.GB9177@sig21.net>
Date: Mon, 10 Aug 2009 12:31:47 +0200
In-Reply-To: <20090807170942.GB9177@sig21.net> (Johannes Stezenbach's message of "Fri, 7 Aug 2009 19:09:42 +0200")
Message-ID: <87k51cgdt8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach <js@sig21.net> writes:

> Hi,
>
> I'm currently running linux-2.6.31-rc5-246-g90bc1a6 on
> an old Thinkpad T42p.  During boot I get the following:

Thanks for the report.

>
>    Local APIC disabled by BIOS -- you can enable it with "lapic"
>    APIC: disable apic facility
>    ...
>    mce: CPU supports 5 MCE banks
>    Disabling lock debugging due to kernel taint
>    ------------[ cut here ]------------
>    WARNING: at arch/x86/kernel/apic/apic.c:247 native_apic_write_dummy+0x2d/0x39()
>    Hardware name: 2373Y4M
>    Modules linked in:
>    Pid: 0, comm: swapper Tainted: G   M       2.6.31-rc5 #1

The mcelog below is already worked around with Bart's patch he posted
the link to (it's really a BIOS bug in your case that the BIOS leaves
junks in the machine check registers on boot)

[for the x86 maintainers:]
One thing that would be good to make sure that Bart's patch is queued
for .31 too, not only for .32, since this BIOS problem seems
to be common (already two reports)

But still need to fix that warning too, which is independent
[another .31 candidate]

>    Call Trace:
>     [<c10248c1>] warn_slowpath_common+0x60/0x90
>     [<c10248fe>] warn_slowpath_null+0xd/0x10
>     [<c1013139>] native_apic_write_dummy+0x2d/0x39
>     [<c100dcd2>] intel_init_thermal+0xb6/0x144
>     [<c100d517>] ? mce_init+0x33/0xb0
>     [<c100db4b>] mce_intel_feature_init+0xb/0x4c
>     [<c14fc31e>] mcheck_init+0x1e2/0x253
>     [<c14faef4>] identify_cpu+0x30b/0x31b
>     [<c14d9af0>] identify_boot_cpu+0xd/0x23
>     [<c14d9b3c>] check_bugs+0xb/0xd4
>     [<c104f929>] ? delayacct_init+0x42/0x49
>     [<c14d493c>] start_kernel+0x25e/0x26d
>     [<c14d430b>] i386_start_kernel+0x65/0x6a
>    ---[ end trace 4eaa2a86a8e2da22 ]---


The appended patch should remove the warning. Can you please test it?

> 2.6.29.1 doesn't log any MCE events, so I doubt this is a HW problem.

It actually is a BIOS bug, but not really broken hardware.

-Andi

---

Don't try to enable thermal throttling on 32bit systems without apic

When the local APIC isn't enabled don't try to enable thermal throttling.
The APIC writes would WARN_ON.

Fixes 

>    Disabling lock debugging due to kernel taint
>    ------------[ cut here ]------------
>    WARNING: at arch/x86/kernel/apic/apic.c:247 native_apic_write_dummy+0x2d/0x39()
>    Hardware name: 2373Y4M
>    Modules linked in:
>    Pid: 0, comm: swapper Tainted: G   M       2.6.31-rc5 #1

Originally reported by Johannes Stezenbach 

This is a 2.6.31 candidate because it fixes a regression.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ linux/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -236,6 +236,9 @@ void intel_init_thermal(struct cpuinfo_x
 	int tm2 = 0;
 	u32 l, h;
 
+	if (!cpu_has_apic || disable_apic)
+		return;
+
 	/* Thermal monitoring depends on ACPI and clock modulation*/
 	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
 		return;



-- 
ak@linux.intel.com -- Speaking for myself only.
