Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYGCQcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYGCQcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYGCQci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:32:38 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:40182 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbYGCQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:32:37 -0400
Date: Thu, 3 Jul 2008 22:00:48 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [x86-tip] panic during cpu_up
Message-ID: <20080703163048.GC4468@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080702190651.GA13252@linux.vnet.ibm.com> <20080702205544.GB13252@linux.vnet.ibm.com> <20080703070242.GA16379@elte.hu> <20080703080625.GB4065@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703080625.GB4065@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > The other suspect would be acpi idle:
> > 
> >         /* Fall back to the default idle loop */
> >         pm_idle = pm_idle_save;
> > 

Yep, you are right.

> > Could you try latest tip/master or the debug patch below? It should show 
> > where the NULL comes from, without crashing.
> > 
> 
> Sure, will give it a run sometime soon.
> 

------------[ cut here ]------------
WARNING: at drivers/acpi/processor_idle.c:1316
acpi_processor_cst_has_changed+0x64/0xc0()
Modules linked in:
Pid: 4433, comm: bash Not tainted 2.6.26-rc8-tip #15
 [<c0127a0a>] warn_on_slowpath+0x41/0x60
 [<c0393a00>] ? __cpufreq_set_policy+0x135/0x1bf
 [<c0141c28>] ? mark_held_locks+0x46/0x61
 [<c0141d7d>] ? trace_hardirqs_on+0xb/0xd
 [<c0141d4a>] ? trace_hardirqs_on_caller+0xe9/0x111
 [<c0141d7d>] ? trace_hardirqs_on+0xb/0xd
 [<c027fc1d>] ? acpi_processor_get_platform_limit+0x9f/0xac
 [<c027f285>] acpi_processor_cst_has_changed+0x64/0xc0
 [<c027cadd>] acpi_cpu_soft_notify+0x2a/0x39
 [<c041193c>] notifier_call_chain+0x32/0x64
 [<c013b87f>] __raw_notifier_call_chain+0xe/0x10
 [<c013b88d>] raw_notifier_call_chain+0xc/0xe
 [<c040cb33>] _cpu_up+0xb3/0xdc
 [<c040cb9e>] cpu_up+0x42/0x52
 [<c03fab35>] store_online+0x39/0x5d
 [<c03faafc>] ? store_online+0x0/0x5d
 [<c02c1e6c>] sysdev_store+0x20/0x25
 [<c01b2190>] flush_write_buffer+0x3e/0x53
 [<c01b21e3>] sysfs_write_file+0x3e/0x5d
 [<c017e281>] vfs_write+0x8d/0x105
 [<c017e394>] sys_write+0x3b/0x60
 [<c0103931>] sysenter_past_esp+0x6a/0xa5
 =======================
---[ end trace 987615de2ae7cfa5 ]---

Which corresponds to 

        /* Fall back to the default idle loop */
        WARN_ON_ONCE(!pm_idle_save);
        if (pm_idle_save)
                pm_idle = pm_idle_save;
        synchronize_sched();    /* Relies on interrupts forcing exit from idle. */


-- 
regards,
Dhaval
