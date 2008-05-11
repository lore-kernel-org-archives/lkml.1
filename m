Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYEKTz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYEKTz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYEKTzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:55:48 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:43527 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYEKTzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:55:47 -0400
Date: Sun, 11 May 2008 16:55:19 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Henny Wilbrink <wsdwhw@win.tue.nl>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, liml@rtr.ca
Subject: Re: 2.6.26-rc1 fails to boot
Message-ID: <20080511195519.GA4774@beyonder.ift.unesp.br>
Mail-Followup-To: Henny Wilbrink <wsdwhw@win.tue.nl>,
	linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
	tglx@linutronix.de, liml@rtr.ca
References: <18470.968.939325.722176@gargle.gargle.HOWL> <20080510222201.GA3754@beyonder.ift.unesp.br> <18470.48583.228614.436610@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18470.48583.228614.436610@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 11.May'08 at 11:35:03 +0200, Henny Wilbrink wrote:
> Carlos R. Mafra wrote:
> > On Sat 10.May'08 at 22:21:28 +0200, Henny Wilbrink wrote:
> > Content-Description: message body text
> > > Hello,
> > > 
> > > Kernel 2.6.26-rc1 completely fails to boot on my laptop. The last line
> > > appearing on the console is:
> > > 
> > > ACPI: Processor [CPU1] (supports 8 throttling states)
> > 
> > Does booting with hpet=disable help?
> 
> No, 2.6.26-rc1 with hpet=disable now stops at
> 
> ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> 
> However, with idle=mwait as suggested by Venkatesh Pallipadi it did
> boot in 2 out of 2 attempts.

Ah, this bug is definitely tricky! 

> > 
> > > Kernel 2.6.25 fails to boot in an estimated 1 in 2 attempts.  The last
> > > line on the console if this one fails is:
> > > 
> > > ACPI: LNXTHERM:01 is registered as thermal_zone0
> > > 
> > > I did a git bisection with "fails to boot in the first three attempts"
> > > as the definition of "bad" between 2.6.26-rc1 and 2.6.25-rc3 which I
> > > believed to be free of this problem.  The many reboots in the
> > > bisection process however showed me that 2.6.25-rc3 also has an
> > > estimated 1 in 10 chance of failing.  Anyway, the bisection ended
> > > with:
> > > 
> > > 8a3227268877b81096d7b7a841aaf51099ad2068 is first bad commit
> > > 
> > > The bisection log and dmesg are attached.
> > 
> > I have this boot problem since before 2.6.25-rc1 but it is
> > very difficult to do a bisection. Sometimes the probability
> > of hanging was 1:30 and what I thought was a good kernel in
> > fact was bad.
> > 
> > In fact the commit you got is a "merge commit" which does not
> > change the source code so it is clearly bogus.
> > 
> > Mark Lord points out that this bug comes and goes with slight
> > modifications in the .config, and in fact very recently 
> > the probability of hanging changed dramatically for me.
> > 
> > I have already booted the kernel afa26be86b65 (six commits
> > after 2.6.26-rc1) more than 30 times and it did not hang.
> > 
> > You can also take a look at some discussion here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=10117
> > 
> 
> Yes this definitely looks like the same problem.

I think so too, but it is difficult to really find where
is problem is (hpet?, nohz?, cpuidle? etc) 

So today I tried to humbly hack a bit to get a trace, and I think
I managed to do it.

The observation in my notes was that with 2.6.25-rc9 the 
kernel printed two lines when I pressed the power button 
when the boot hung:

evmisc-0145 [00] ev_queue_notify_reques: Dispatching Notify(80) on node ffff81007f04ee30
evmisc-0154 [00] ev_queue_notify_reques: Notify value: 0x80 **Device Specific*

so the kernel was not completely hung. Sometimes lines similar to the above (I
don't remember the numbers anymore) were being printed continuosly after the
hang for more than 15 minutes at a rate of more or less 1 per minute.

So my idea was to insert a WARN_ON(1) in a few places, and in particular the
function which had those evmisc printk's.

Then I got some traces before and after the hang point, and another trace when
I pressed the power button! I don't know if they will reveal something
interesting to kernel hackers, but I will transcribe them here (I lost my
digital camera, so it took me a long time to write them).

This is how the screen looked like when the boot hung (caveat lector: it
was all copied by hand, so there may be typos):

[<ffffffff8022a909>] ? update_rq_clock+0x19/0x20
[<ffffffff8023fbfa>] run_timer_softirq+0x2a/0x230
[<ffffffff8022a81a>] ? __update_rq_clock+0x2a/0x100
[<ffffffff8023bc44>] __do_softirq+0x74/0xf0
[<ffffffff8020fcca>] ? profile_pc+0x3a/0x70
[<ffffffff8020d45c>] call_softirq+0x1c/0x30
[<ffffffff8020faed>] do_softirq+0x3d/0x80
[<ffffffff8023bbc5>] irq_exit+0x85/0x90
[<ffffffff8021f4de>] smp_apic_timer_interrupt+0x7e/0xc0
[<ffffffff8020b260>] ? mwait_idle+0x0/0x50
[<ffffffff8020b0e0>] ? default_idle+0x0/0x70
[<ffffffff8020cf06>] apic_timer_interrupt+0x66/0x70
<EOI>  [<ffffffff8020b2a0>] ? mwait_idle+0x40/0x50
[<ffffffff8020a882>] ? enter_idle+0x22/0x30
[<ffffffff8020b192>] ? cpu_idle+0x42/0xc0
[<ffffffff8047e16e>] ? start_secondary+0x2fe/0x430
--- [ end trace ca143223eefdc828 ] ---
hpet_legacy_set_mode
hpet_legacy_set_mode: oneshot
Switched to high resolution mode on CPU 1
--- [ end trace ca143223eefdc828 ] ---
ACPI: SSDT 7F6D8EF3, 00E4 (r1 Sony VAIO 20070704 PTL 20050624)
ACPI: SSDT 7F6D8BC0, 0092 (r1 Sony VAIO 20070704 PTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device2
ACPI: Processor [CPU1] (supports 8 throttling states)
----------------[cut here]---------------------------
WARNING: at drivers/acpi/processor_core.c:699 acpi_processor_start+0x8a7/0x8d2()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc9-00011-g8145619-dirty #81
Call Trace:
[<ffffffff80235d4f>] warn_on_slowpath+0x5f/0x80
[<ffffffff80236ea7>] ? printk+0x67/0x70
[<ffffffff802dee22>] ? sysfs_create_link+0xb2/0x150
[<ffffffff80480d07>] acpi_processor_start+0x8a7/0x8d2
[<ffffffff8036921e>] acpi_start_single_object+0x2d/0x52
[<ffffffff8036a87a>] acpi_device_probe+0xba/0x10a
[<ffffffff8039f6ab>] driver_probe_device+0x9b/0x1a0
[<ffffffff8039f96d>] __driver_attach+0xcd/0xd0
[<ffffffff8039f8a0>] ? __driver_attach+0x0/0xd0
[<ffffffff8039e84d>] bus_for_each_dev+0x5d/0x90
[<ffffffff803227ea>] ? kobject_get+0x1a/0x30
[<ffffffff8039f4ec>] driver_attach+0x1c/0x20
[<ffffffff8039f242>] bus_add_driver+0xc2/0x240
[<ffffffff8039fb98>] driver_register+0x48/0x110
[<ffffffff8036ac13>] acpi_bus_register_driver+0x3e/0x43
[<ffffffff805fb38b>] acpi_processor_init+0x93/0x106
[<ffffffff80484289>] ? spin_unlock_irq+0x09/0x10
[<ffffffff8022f5d8>] ? finish_task_switch+0x48/0xc0
[<ffffffff8020d0e8>] child_rip+0xa/0x12
[<ffffffff805e46e0>] ? kernel_init+0x0/0x340
[<ffffffff8020d0de>] ? child_rip+0x0/0x12
---[ end trace ca143223eetdc8283 ] -----


This is were the laptop was kept hung indefinitely. Note that
the usual line were it hangs is

ACPI: Processor [CPU1] (supports 8 throttling states)

and right after that the WARN_ON(1) which I wrote in processor_core.c
triggered with acpi_processor_start(). 

I think it is worth mentioning that when the laptop hangs there is always
only one "Switched to high resolution mode on CPU #" before the hang point,
and when it succeeds there are always two such messages in sequence.

Ok, the laptop was hung in that state and then I pressed the power button
which triggered the WARN_ON(1) I wrote in evmisc.c

--------------- [cut here] ---------------------
WARNING: at drivers/acpi/events/evmisc.c:142 acpi_ev_queue_notify_request+0x36/0x210
Modules linked in:
Pid: 59, comm: kacpid Not taited 2.6.25-rc9-00011-g8145619-dirty #81
Call trace:
[<ffffffff80235d4f>] warn_on_slowpath+0x5f/0x80
[<ffffffff80236ea7>] ? printk+0x67/0x70
[<ffffffff80353b54>] ? acpi_ex_resolve_to_value+0x314/0x324
[<ffffffff803500cc>] acpi_ev_queue_notify_request+0x36/0x210
[<ffffffff80358f7d>] ? acpi_ex_dump_operands+0xc6/0xd5
[<ffffffff8035753b>] acpi_ex_opcode_2A_0T_OR+0x67/0x90
[<ffffffff8034b531>] acpi_ds_exec_end_op+0x132/0x575
[<ffffffff8036022a>] acpi_ps_parse_loop+0x6d6/0x8e0
[<ffffffff8035f399>] acpi_ps_parse_aml+0xf1/0x354
[<ffffffff80360b4d>] acpi_ps_execute_method+0x17d/0x268
[<ffffffff8035c7c1>] acpi_ns_evaluate+0x165/0x238
[<ffffffff80290033>] ? kmem_cache_alloc+0x73/0xb0
[<ffffffff8035c17d>] acpi_evaluate_object+0x1a2/0x2a5
[<ffffffff803486b3>] ? acpi_os_execute_deferred+0x0/0x39
[<ffffffff8036b214>] acpi_ec_gpe_query+0xa0/0xc3
[<ffffffff80481833>] ? thread_return+0x62/0x52f
[<ffffffff803486df>] acpi_os_execute_deferred+0x2c/0x39
[<ffffffff802478f9>] run_workqueue+0x99/0x140
[<ffffffff80248463>] worker_thread+0xa3/0x110
[<ffffffff8024b870>] ? autoremove_wake_function+0x0/0x40
[<ffffffff802483c0>] ? worker_thread+0x0/0x110
[<ffffffff8024b44d>] kthread+0x4d/0x80
[<ffffffff8020d0e8>] child_rip+0xa/0x12
[<ffffffff8024b400>] ? kthread+0x0/0x80
[<ffffffff8020d0de>] ? child_rip+0x0/0x12
---[ end trace ca143223eefdc828 ] ----
evmisc-0145 [00] ev_queue_notify_reques: Dispatching Notify(80) on node ffff81007f04ee30
evmisc-0154 [00] ev_queue_notify_reques: Notify value: 0x80 **Device Specific*

It ends here. If I press the power button again yet another trace is 
generated, but there are the same functions in there. I was wondering
how I could patch the kernel such that when I press the power button 
instead of printing the WARN_ON(1) it would generate the equivalent of
Sysrq+t, but I couldn't do it yet.

I think I have to get another digital camera, my fingers hurt...

