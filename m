Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbYD2Szz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbYD2Szz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764232AbYD2Sxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:53:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41485 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764215AbYD2Sxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:53:30 -0400
Message-ID: <48176EA6.8060506@sgi.com>
Date: Tue, 29 Apr 2008 11:53:26 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: fix remove cpu_pda table patch
References: <20080428210906.348866000@polaris-admin.engr.sgi.com> <20080428214541.GA16153@elte.hu> <48175CF8.4010105@sgi.com>
In-Reply-To: <48175CF8.4010105@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>> [Ingo - please replace "PATCH 07/11" with this one.]
>>>
>>>     *	Remove 544k bytes from the kernel by removing the boot_cpu_pda
>>> 	array from the data section and allocating it during startup.
>>>
>>> 	Fixed panic in setup_per_cpu_areas when HOTPLUG_CPU not set.
>>>
>>> For inclusion into sched-devel/latest tree.
>> sched-devel.git randconfig testing found another crash with your queue:
>>
>> [    0.111060] Brought up 1 CPUs
>> [    0.111986] Total of 1 processors activated (4022.73 BogoMIPS).
>> [    0.112987] Testing NMI watchdog ... <1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
>> [    0.114982] IP: [<ffffffff8180d4a0>] check_nmi_watchdog+0xb0/0x210
>> [    0.114982] PGD 0
>> [    0.114982] Oops: 0000 [1] SMP
>> [    0.114982] CPU 0
>> [............]
>>
>>  http://redhat.com/~mingo/misc/config-Mon_Apr_28_23_25_25_CEST_2008.bad
>>  http://redhat.com/~mingo/misc/log-Mon_Apr_28_23_25_25_CEST_2008.bad
>>
>> 	Ingo
> 
> Hi Ingo,
> 
> I need a bit more information on your hardware configuration.  Building a
> kernel with the above config file started up fine on both the Intel and AMD
> boxes.
> 
> Based on the above output it looks like it might be a UP machine?  
...

Ok, I think I found it.  In check_nmi_watchdog():


        for (cpu = 0; cpu < NR_CPUS; cpu++)
                prev_nmi_count[cpu] = cpu_pda(cpu)->__nmi_count;

As I mentioned it works fine on both of my systems so could you try it out?

Thanks!
Mike
--
Subject: [PATCH 1/1] x86: change check_nmi_watchdog to use nr_cpu_ids

  * Change function check_nmi_watchdog() to use nr_cpu_ids instead of NR_CPUS.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/nmi_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.sched.orig/arch/x86/kernel/nmi_64.c
+++ linux-2.6.sched/arch/x86/kernel/nmi_64.c
@@ -88,7 +88,7 @@ int __init check_nmi_watchdog(void)
 	if (!atomic_read(&nmi_active))
 		return 0;
 
-	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
+	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
 	if (!prev_nmi_count)
 		return -1;
 
@@ -99,7 +99,7 @@ int __init check_nmi_watchdog(void)
 		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
 #endif
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
 		prev_nmi_count[cpu] = cpu_pda(cpu)->__nmi_count;
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
