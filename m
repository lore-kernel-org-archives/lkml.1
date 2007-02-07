Return-Path: <linux-kernel-owner+w=401wt.eu-S965623AbXBGBFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965623AbXBGBFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965620AbXBGBFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:05:50 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50139 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965623AbXBGBFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:05:49 -0500
Message-ID: <45C925EC.2010504@vmware.com>
Date: Tue, 06 Feb 2007 17:05:48 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 6/11] Vmi timer no idle hz fixes.patch
References: <200702060353.l163r9ec000751@zach-dev.vmware.com> <20070206122917.GD47229@muc.de>
In-Reply-To: <20070206122917.GD47229@muc.de>
Content-Type: multipart/mixed;
 boundary="------------040800080204080008080705"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040800080204080008080705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
>> -#ifdef CONFIG_S390
>> -#ifdef CONFIG_MATHEMU
>> -	{
>> -		.ctl_name	= KERN_IEEE_EMULATION_WARNINGS,
>> -		.procname	= "ieee_emulation_warnings",
>> -		.data		= &sysctl_ieee_emulation_warnings,
>> -		.maxlen		= sizeof(int),
>> -		.mode		= 0644,
>> -		.proc_handler	= &proc_dointvec,
>> -	},
>>     
>
> I think there needs to be a way to have this syctl only
> when it's really implemented for the paravirt ops.
>   

Alright, lets drop that part of the patch for now.  Here's an update.  
Please apply.

> I suppose you should move it to dynamic registration on demand.
>   

And start working on this.

Zach

--------------040800080204080008080705
Content-Type: text/plain;
 name="vmi-timer-no-idle-hz-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmi-timer-no-idle-hz-fixes.patch"

Fix the VMI-Timer no-idle-hz code.

Do not setup a one shot alarm if we are keeping the periodic alarm
armed.  Additionally, since the periodic alarm can be run at a lower
rate than HZ, let's fixup the guard to the no-idle-hz mode appropriately.
This fixes the bug where the no-idle-hz mode might have a higher interrupt
rate than the non-idle case.

Signed-off-by: Dan Hecht <dhecht@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 9d107b81bb7d arch/i386/kernel/vmitime.c
--- a/arch/i386/kernel/vmitime.c	Thu Feb 01 23:43:37 2007 -0800
+++ b/arch/i386/kernel/vmitime.c	Thu Feb 01 23:52:59 2007 -0800
@@ -374,7 +374,6 @@ int vmi_stop_hz_timer(void)
 	unsigned long seq, next;
 	unsigned long long real_cycles_expiry;
 	int cpu = smp_processor_id();
-	int idle;
 
 	BUG_ON(!irqs_disabled());
 	if (sysctl_hz_timer != 0)
@@ -382,13 +381,13 @@ int vmi_stop_hz_timer(void)
 
 	cpu_set(cpu, nohz_cpu_mask);
 	smp_mb();
+
 	if (rcu_needs_cpu(cpu) || local_softirq_pending() ||
-	    (next = next_timer_interrupt(), time_before_eq(next, jiffies))) {
+	    (next = next_timer_interrupt(), 
+	     time_before_eq(next, jiffies + HZ/CONFIG_VMI_ALARM_HZ))) {
 		cpu_clear(cpu, nohz_cpu_mask);
-		next = jiffies;
-		idle = 0;
-	} else
-		idle = 1;
+		return 0;
+	}
 
 	/* Convert jiffies to the real cycle counter. */
 	do {
@@ -398,17 +397,13 @@ int vmi_stop_hz_timer(void)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	/* This cpu is going idle. Disable the periodic alarm. */
-	if (idle) {
-		vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
-		per_cpu(idle_start_jiffies, cpu) = jiffies;
-	}
-
+	vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
+	per_cpu(idle_start_jiffies, cpu) = jiffies;
 	/* Set the real time alarm to expire at the next event. */
 	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
-		      real_cycles_expiry, 0);
-
-	return idle;
+		VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
+		real_cycles_expiry, 0);
+	return 1;
 }
 
 static void vmi_reenable_hz_timer(int cpu)

--------------040800080204080008080705--
