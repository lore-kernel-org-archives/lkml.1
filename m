Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXI2Mkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXI2Mkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXI2Mkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:40:41 -0400
Received: from rtr.ca ([76.10.145.34]:3377 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbXI2Mkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:40:40 -0400
Message-ID: <46FE47C7.6070901@rtr.ca>
Date: Sat, 29 Sep 2007 08:40:39 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com> <20070929093553.GA4451@erig.dyndns.org>
In-Reply-To: <20070929093553.GA4451@erig.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> On Sat, Sep 29, 2007 at 01:30:33AM -0700, H. Peter Anvin wrote:
>> Wolfgang Erig wrote:
>>> Both are bad.
>>> Two different systems and two different bisections.
>>> I sent the last step of each.
>>>>> $ git bisect good 
>>>>> Bisecting: 0 revisions left to test after this 
>>>>> [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 
>>>> OK, so which one is the bad one?
>>> This problem (no power off) persists after pull some minutes ago.
>>> Sorry for the confusion.
>>>
>> I believe there must have been something wrong here (possibly
>> inconsistent experiments?)  This checkin has *zero code changes* from
>> the previous one (and next one) -- the kernel should have been binarily
>> identical to the previous one.  The code introduced in this checkin
>> doesn't even get compiled until two checkins later,
>> 4fd06960f120e02e9abc802a09f9511c400042a5.
> 
> I have done two bisections simultanously and it was late at night.
> I start again with a fresh tree and better controlled experiments.

If this is an SMP system, then you could just be getting random results,
depending upon which CPU is attempting the poweroff.

I have a newish patch in Andrew's tree now to fix SMP poweroff
(has been broken forever), reproduced here below in case you missed it.

* * *
We need to disable all CPUs other than the boot CPU (usually 0)
before attempting to power-off modern SMP machines.
This fixes the hang-on-poweroff issue on my MythTV SMP box,
and also on Thomas Gleixner's new toybox.

Signed-off-by: Mark Lord <mlord@pobox.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---

--- linux/kernel/sys.c.orig	2007-09-13 09:49:11.000000000 -0400
+++ linux/kernel/sys.c	2007-09-28 15:48:54.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
+#include <linux/cpu.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -878,6 +879,7 @@
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
+	disable_nonboot_cpus();
 	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
