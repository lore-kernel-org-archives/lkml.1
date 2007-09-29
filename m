Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbXI2PYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbXI2PYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 11:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXI2PYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 11:24:39 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:50946 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754420AbXI2PYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 11:24:39 -0400
Message-ID: <46FE6E17.6070109@suse.de>
Date: Sat, 29 Sep 2007 19:24:07 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: regression in 2.6.23-rc8 - power off failed
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com> <20070929093553.GA4451@erig.dyndns.org> <46FE47C7.6070901@rtr.ca>
In-Reply-To: <46FE47C7.6070901@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Wolfgang Erig wrote:
>> On Sat, Sep 29, 2007 at 01:30:33AM -0700, H. Peter Anvin wrote:
>>> Wolfgang Erig wrote:
>>>> Both are bad.
>>>> Two different systems and two different bisections.
>>>> I sent the last step of each.
>>>>>> $ git bisect good Bisecting: 0 revisions left to test after this 
>>>>>> [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and 
>>>>>> main routine for new x86 setup code 
>>>>> OK, so which one is the bad one?
>>>> This problem (no power off) persists after pull some minutes ago.
>>>> Sorry for the confusion.
>>>>
>>> I believe there must have been something wrong here (possibly
>>> inconsistent experiments?)  This checkin has *zero code changes* from
>>> the previous one (and next one) -- the kernel should have been binarily
>>> identical to the previous one.  The code introduced in this checkin
>>> doesn't even get compiled until two checkins later,
>>> 4fd06960f120e02e9abc802a09f9511c400042a5.
>>
>> I have done two bisections simultanously and it was late at night.
>> I start again with a fresh tree and better controlled experiments.
> 
> If this is an SMP system, then you could just be getting random results,
> depending upon which CPU is attempting the poweroff.
> 
> I have a newish patch in Andrew's tree now to fix SMP poweroff
> (has been broken forever), reproduced here below in case you missed it.
> 
> * * *
> We need to disable all CPUs other than the boot CPU (usually 0)
> before attempting to power-off modern SMP machines.
> This fixes the hang-on-poweroff issue on my MythTV SMP box,
> and also on Thomas Gleixner's new toybox.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> 
> --- linux/kernel/sys.c.orig    2007-09-13 09:49:11.000000000 -0400
> +++ linux/kernel/sys.c    2007-09-28 15:48:54.000000000 -0400
> @@ -32,6 +32,7 @@
> #include <linux/getcpu.h>
> #include <linux/task_io_accounting_ops.h>
> #include <linux/seccomp.h>
> +#include <linux/cpu.h>
> 
> #include <linux/compat.h>
> #include <linux/syscalls.h>
> @@ -878,6 +879,7 @@
>     kernel_shutdown_prepare(SYSTEM_POWER_OFF);
>     if (pm_power_off_prepare)
>         pm_power_off_prepare();
> +    disable_nonboot_cpus();
>     sysdev_shutdown();
>     printk(KERN_EMERG "Power down.\n");
>     machine_power_off();

-static void
-acpi_power_off (void)
-{
-       printk("%s called\n",__FUNCTION__);
-       /* Some SMP machines only can poweroff in boot CPU */
-       set_cpus_allowed(current, cpumask_of_cpu(0));
ACPI in kernel 2.6.12 did disable non-boot cpus too in powe_off.
Later only comment was left for some reason...
Regards,
Alex. 


