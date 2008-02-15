Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYBOUb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYBOUb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYBOUbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:31:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:44681 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYBOUbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:31:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W9dAGjFXsT1UK7yfNWKBLKNpBKu52TlCH1ihFv/4pSLqjKD5eivb0kgSoVgftNJG1QRzAyOfJ3/v/FcFOWtQzzNFvf3FxK5CEzZQai+Zr++v8Z5KCl0498G3dgVoAFRlxHmXl4zauGUPT9FV40EXNgpRQgTekv5Benfnz5QBHuc=
Message-ID: <86802c440802151231t449af94fm97d003af10c758f2@mail.gmail.com>
Date: Fri, 15 Feb 2008 12:31:15 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Frans Pop" <elendil@planet.nl>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <86802c440802151138i303c58a2m2eca9e97566c3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <86802c440802141538m44d64b6as827426174874979d@mail.gmail.com>
	 <20080215065746.GA8916@suse.de> <200802151119.23325.elendil@planet.nl>
	 <86802c440802151138i303c58a2m2eca9e97566c3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 11:38 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Fri, Feb 15, 2008 at 2:19 AM, Frans Pop <elendil@planet.nl> wrote:
>  > On Friday 15 February 2008, Greg KH wrote:
>  >  > I swear someone sent this patch in before.  Can you try this one below,
>  >  > there seems to be an imbalance with kobject_get and _put.
>  >
>  >  I did remember seeing this patch before [1] and can confirm that it does
>  >  indeed fix the issue: with this patch applied to 2.6.25 git head my system
>  >  powers off correctly.
>  >
>  >  [1] See http://lkml.org/lkml/2008/2/8/342; also added to #9960.
>  >
>  >
>  >
>  >  > ---
>  >  >  drivers/cpufreq/cpufreq.c |    8 --------
>  >  >  1 file changed, 8 deletions(-)
>  >  >
>  >  > --- a/drivers/cpufreq/cpufreq.c
>  >  > +++ b/drivers/cpufreq/cpufreq.c
>  >  > @@ -1006,14 +1006,6 @@ static int __cpufreq_remove_dev (struct
>  >  >       }
>  >  >  #endif
>  >  >
>  >  > -
>  >  > -     if (!kobject_get(&data->kobj)) {
>  >  > -             spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  >  > -             cpufreq_debug_enable_ratelimit();
>  >  > -             unlock_policy_rwsem_write(cpu);
>  >  > -             return -EFAULT;
>  >  > -     }
>  >  > -
>  >  >  #ifdef CONFIG_SMP
>  >  >
>  >  >  #ifdef CONFIG_HOTPLUG_CPU
>  >
>  >
>
>  confirmed, with this patch, i still need disable CONFIG_DETECT_SOFTLOCKUP
>
>  assume watchdog thread for the dead cpu can not be stopped. hang somewhere.

Ingo,

with patch (http://lkml.org/lkml/2008/2/8/342) and following patch, it
could power off with CONFIG_DETECT_SOFTLOCKUP config

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 7c2da88..c16a658 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -282,12 +282,12 @@ cpu_callback(struct notifier_block *nfb,
unsigned long action, void *hcpu)
        case CPU_UP_CANCELED_FROZEN:
                if (!per_cpu(watchdog_task, hotcpu))
                        break;
-               /* Unbind so it can run.  Fall thru. */
-               kthread_bind(per_cpu(watchdog_task, hotcpu),
-                            any_online_cpu(cpu_online_map));
+               /* Fall thru. */
        case CPU_DEAD:
        case CPU_DEAD_FROZEN:
                p = per_cpu(watchdog_task, hotcpu);
+               /* Unbind so it can run. */
+               kthread_bind(p, any_online_cpu(cpu_online_map));
                per_cpu(watchdog_task, hotcpu) = NULL;
                kthread_stop(p);
                break;

but got WARN on every CPU.

ACPI: Preparing to enter system sleep state S5
Disabling non-boot CPUs ...
kvm: disabling virtualization on CPU1
CPU 1 is now offline
------------[ cut here ]------------
WARNING: at kernel/kthread.c:176 cpu_callback+0x14f/0x177()
Modules linked in:
Pid: 7224, comm: halt Not tainted 2.6.25-rc1-smp-00266-g4ee29f6-dirty #110

Call Trace:
 [<ffffffff80243c61>] warn_on_slowpath+0x51/0x63
 [<ffffffff80257e00>] ktime_get_ts+0x3d/0x48
 [<ffffffff8023b160>] hrtick_start_fair+0xe1/0x129
 [<ffffffff8023a049>] enqueue_task+0x4d/0x58
 [<ffffffff8023ceda>] try_to_wake_up+0x1ae/0x1bf
 [<ffffffff80848796>] cpu_callback+0x14f/0x177
 [<ffffffff802747e4>] writeback_set_ratelimit+0x17/0x5d
 [<ffffffff8084dd78>] notifier_call_chain+0x29/0x4c
 [<ffffffff8026083c>] _cpu_down+0x18e/0x251
 [<ffffffff80260a3d>] disable_nonboot_cpus+0x50/0xd7
 [<ffffffff8024feb4>] kernel_power_off+0x21/0x3a
 [<ffffffff802500de>] sys_reboot+0xee/0x187
 [<ffffffff8024de0a>] group_send_sig_info+0x62/0x6f
 [<ffffffff8024de64>] kill_pid_info+0x4d/0x6b
 [<ffffffff8024e5e6>] sys_kill+0x70/0x13e
 [<ffffffff8084d990>] do_page_fault+0x3a9/0x768
 [<ffffffff80464205>] __up_read+0x13/0x8a
 [<ffffffff8084bc39>] error_exit+0x0/0x51
 [<ffffffff8021ee4b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 7098a44b4633d8ed ]---
CPU1 is down
kvm: disabling virtualization on CPU2
CPU 2 is now offline
------------[ cut here ]------------
WARNING: at kernel/kthread.c:176 cpu_callback+0x14f/0x177()
Modules linked in:
Pid: 7224, comm: halt Not tainted 2.6.25-rc1-smp-00266-g4ee29f6-dirty #110

Call Trace:
 [<ffffffff80243c61>] warn_on_slowpath+0x51/0x63
 [<ffffffff80257e00>] ktime_get_ts+0x3d/0x48
 [<ffffffff8023b160>] hrtick_start_fair+0xe1/0x129
 [<ffffffff8023a049>] enqueue_task+0x4d/0x58
 [<ffffffff8023ceda>] try_to_wake_up+0x1ae/0x1bf
 [<ffffffff80848796>] cpu_callback+0x14f/0x177
 [<ffffffff802747e4>] writeback_set_ratelimit+0x17/0x5d
 [<ffffffff8084dd78>] notifier_call_chain+0x29/0x4c
 [<ffffffff8026083c>] _cpu_down+0x18e/0x251
 [<ffffffff80260a3d>] disable_nonboot_cpus+0x50/0xd7
 [<ffffffff8024feb4>] kernel_power_off+0x21/0x3a
 [<ffffffff802500de>] sys_reboot+0xee/0x187
 [<ffffffff8024de0a>] group_send_sig_info+0x62/0x6f
 [<ffffffff8024de64>] kill_pid_info+0x4d/0x6b
 [<ffffffff8024e5e6>] sys_kill+0x70/0x13e
 [<ffffffff8084d990>] do_page_fault+0x3a9/0x768
 [<ffffffff80464205>] __up_read+0x13/0x8a
 [<ffffffff8084bc39>] error_exit+0x0/0x51
 [<ffffffff8021ee4b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 7098a44b4633d8ed ]---
CPU2 is down
kvm: disabling virtualization on CPU3
CPU 3 is now offline
------------[ cut here ]------------
WARNING: at kernel/kthread.c:176 cpu_callback+0x14f/0x177()
Modules linked in:
Pid: 7224, comm: halt Not tainted 2.6.25-rc1-smp-00266-g4ee29f6-dirty #110

Call Trace:
 [<ffffffff80243c61>] warn_on_slowpath+0x51/0x63
 [<ffffffff80257e00>] ktime_get_ts+0x3d/0x48
 [<ffffffff8023b160>] hrtick_start_fair+0xe1/0x129
 [<ffffffff8023a049>] enqueue_task+0x4d/0x58
 [<ffffffff8023ceda>] try_to_wake_up+0x1ae/0x1bf
 [<ffffffff80848796>] cpu_callback+0x14f/0x177
 [<ffffffff802747e4>] writeback_set_ratelimit+0x17/0x5d
 [<ffffffff8084dd78>] notifier_call_chain+0x29/0x4c
 [<ffffffff8026083c>] _cpu_down+0x18e/0x251
 [<ffffffff80260a3d>] disable_nonboot_cpus+0x50/0xd7
 [<ffffffff8024feb4>] kernel_power_off+0x21/0x3a
 [<ffffffff802500de>] sys_reboot+0xee/0x187
 [<ffffffff8024de0a>] group_send_sig_info+0x62/0x6f
 [<ffffffff8024de64>] kill_pid_info+0x4d/0x6b
 [<ffffffff8024e5e6>] sys_kill+0x70/0x13e
 [<ffffffff8084d990>] do_page_fault+0x3a9/0x768
 [<ffffffff80464205>] __up_read+0x13/0x8a
 [<ffffffff8084bc39>] error_exit+0x0/0x51
 [<ffffffff8021ee4b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 7098a44b4633d8ed ]---
CPU3 is down
kvm: disabling virtualization on CPU4
CPU 4 is now offline
------------[ cut here ]------------
WARNING: at kernel/kthread.c:176 cpu_callback+0x14f/0x177()
Modules linked in:
Pid: 7224, comm: halt Not tainted 2.6.25-rc1-smp-00266-g4ee29f6-dirty #110

Call Trace:
 [<ffffffff80243c61>] warn_on_slowpath+0x51/0x63
 [<ffffffff80257e00>] ktime_get_ts+0x3d/0x48
 [<ffffffff8023b160>] hrtick_start_fair+0xe1/0x129
 [<ffffffff8023a049>] enqueue_task+0x4d/0x58
 [<ffffffff8023ceda>] try_to_wake_up+0x1ae/0x1bf
 [<ffffffff80848796>] cpu_callback+0x14f/0x177
 [<ffffffff802747e4>] writeback_set_ratelimit+0x17/0x5d
 [<ffffffff8084dd78>] notifier_call_chain+0x29/0x4c
 [<ffffffff8026083c>] _cpu_down+0x18e/0x251
 [<ffffffff80260a3d>] disable_nonboot_cpus+0x50/0xd7
 [<ffffffff8024feb4>] kernel_power_off+0x21/0x3a
 [<ffffffff802500de>] sys_reboot+0xee/0x187
 [<ffffffff8024de0a>] group_send_sig_info+0x62/0x6f
 [<ffffffff8024de64>] kill_pid_info+0x4d/0x6b
 [<ffffffff8024e5e6>] sys_kill+0x70/0x13e
 [<ffffffff8084d990>] do_page_fault+0x3a9/0x768
 [<ffffffff80464205>] __up_read+0x13/0x8a
 [<ffffffff8084bc39>] error_exit+0x0/0x51
 [<ffffffff8021ee4b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 7098a44b4633d8ed ]---
CPU4 is down
kvm: disabling virtualization on CPU5
CPU 5 is now offline
------------[ cut here ]------------
WARNING: at kernel/kthread.c:176 cpu_callback+0x14f/0x177()
Modules linked in:
Pid: 7224, comm: halt Not tainted 2.6.25-rc1-smp-00266-g4ee29f6-dirty #110

Call Trace:
 [<ffffffff80243c61>] warn_on_slowpath+0x51/0x63
 [<ffffffff80257e00>] ktime_get_ts+0x3d/0x48
 [<ffffffff8023b160>] hrtick_start_fair+0xe1/0x129
 [<ffffffff8023a049>] enqueue_task+0x4d/0x58
 [<ffffffff8023ceda>] try_to_wake_up+0x1ae/0x1bf
 [<ffffffff80848796>] cpu_callback+0x14f/0x177
 [<ffffffff802747e4>] writeback_set_ratelimit+0x17/0x5d
 [<ffffffff8084dd78>] notifier_call_chain+0x29/0x4c
 [<ffffffff8026083c>] _cpu_down+0x18e/0x251
 [<ffffffff80260a3d>] disable_nonboot_cpus+0x50/0xd7
 [<ffffffff8024feb4>] kernel_power_off+0x21/0x3a
 [<ffffffff802500de>] sys_reboot+0xee/0x187
 [<ffffffff8024de0a>] group_send_sig_info+0x62/0x6f
 [<ffffffff8024de64>] kill_pid_info+0x4d/0x6b
 [<ffffffff8024e5e6>] sys_kill+0x70/0x13e
 [<ffffffff8084d990>] do_page_fault+0x3a9/0x768
 [<ffffffff80464205>] __up_read+0x13/0x8a
 [<ffffffff8084bc39>] error_exit+0x0/0x51
 [<ffffffff8021ee4b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 7098a44b4633d8ed ]---
CPU5 is down
kvm: disabling virtualization on CPU6
CPU 6 is now offline
------------[ cut here ]------------
WARNING: at kernel/kthread.c:176 cpu_callback+0x14f/0x177()
Modules linked in:
Pid: 7224, comm: halt Not tainted 2.6.25-rc1-smp-00266-g4ee29f6-dirty #110

Call Trace:
 [<ffffffff80243c61>] warn_on_slowpath+0x51/0x63
 [<ffffffff80257e00>] ktime_get_ts+0x3d/0x48
 [<ffffffff8023b160>] hrtick_start_fair+0xe1/0x129
 [<ffffffff8023a049>] enqueue_task+0x4d/0x58
 [<ffffffff8023ceda>] try_to_wake_up+0x1ae/0x1bf
 [<ffffffff80848796>] cpu_callback+0x14f/0x177
 [<ffffffff802747e4>] writeback_set_ratelimit+0x17/0x5d
 [<ffffffff8084dd78>] notifier_call_chain+0x29/0x4c
 [<ffffffff8026083c>] _cpu_down+0x18e/0x251
 [<ffffffff80260a3d>] disable_nonboot_cpus+0x50/0xd7
 [<ffffffff8024feb4>] kernel_power_off+0x21/0x3a
 [<ffffffff802500de>] sys_reboot+0xee/0x187
 [<ffffffff8024de0a>] group_send_sig_info+0x62/0x6f
 [<ffffffff8024de64>] kill_pid_info+0x4d/0x6b
 [<ffffffff8024e5e6>] sys_kill+0x70/0x13e
 [<ffffffff8084d990>] do_page_fault+0x3a9/0x768
 [<ffffffff80464205>] __up_read+0x13/0x8a
 [<ffffffff8084bc39>] error_exit+0x0/0x51
 [<ffffffff8021ee4b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 7098a44b4633d8ed ]---
CPU6 is down
kvm: disabling virtualization on CPU7
CPU 7 is now offline
SMP alternatives: switching to UP code
------------[ cut here ]------------
WARNING: at kernel/kthread.c:176 cpu_callback+0x14f/0x177()
Modules linked in:
Pid: 7224, comm: halt Not tainted 2.6.25-rc1-smp-00266-g4ee29f6-dirty #110

Call Trace:
 [<ffffffff80243c61>] warn_on_slowpath+0x51/0x63
 [<ffffffff80257e00>] ktime_get_ts+0x3d/0x48
 [<ffffffff8023b160>] hrtick_start_fair+0xe1/0x129
 [<ffffffff8023a049>] enqueue_task+0x4d/0x58
 [<ffffffff8023ceda>] try_to_wake_up+0x1ae/0x1bf
 [<ffffffff80848796>] cpu_callback+0x14f/0x177
 [<ffffffff802747e4>] writeback_set_ratelimit+0x17/0x5d
 [<ffffffff8084dd78>] notifier_call_chain+0x29/0x4c
 [<ffffffff8026083c>] _cpu_down+0x18e/0x251
 [<ffffffff80260a3d>] disable_nonboot_cpus+0x50/0xd7
 [<ffffffff8024feb4>] kernel_power_off+0x21/0x3a
 [<ffffffff802500de>] sys_reboot+0xee/0x187
 [<ffffffff8024de0a>] group_send_sig_info+0x62/0x6f
 [<ffffffff8024de64>] kill_pid_info+0x4d/0x6b
 [<ffffffff8024e5e6>] sys_kill+0x70/0x13e
 [<ffffffff8084d990>] do_page_fault+0x3a9/0x768
 [<ffffffff80464205>] __up_read+0x13/0x8a
 [<ffffffff8084bc39>] error_exit+0x0/0x51
 [<ffffffff8021ee4b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 7098a44b4633d8ed ]---
CPU7 is down
Power down.
acpi_power_off called
 hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S5]
