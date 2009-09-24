Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZIXAF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZIXAF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZIXAFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:05:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:59690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbZIXAFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:05:21 -0400
Message-ID: <4ABAB7B2.9060603@kernel.org>
Date: Thu, 24 Sep 2009 09:05:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>	 <4AB89417.7090005@kernel.org> <1253648186.2766.5.camel@localhost>
In-Reply-To: <1253648186.2766.5.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 00:05:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tony Vroon wrote:
> Patch applied, no additional output visible:
> OAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x10de8201 base: 0xfed00000
> SMP: allowing 12 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at b00000000 (gap:b0000000:30000000)
> NR_CPUS: 12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:2
> PERCPU: Embedded 23 pages/cpu @ffff880028200000 s73688 r0 d20520 u26214
> PANIC: early exception 06 rip 10:ffffffff81598250 error 0 cr2 d0fff6
> Pid: 0, comm: swapper Not tainted 2.6.31-07068-g43c266-dirty #1
> Call Trace:
> [<ffffffff815719b5>] early_idt_handler+0x55/0x68
> [<ffffffff81587259>] ? pcpu_setup_first_chunk+0x40b/0x703
> [<ffffffff81587273>] ? pcpu_setup_first_chunk+0x427/0x703
> [<ffffffff81587a78>] pcpu_embed_first_chunk+0x1fd/0x261
> [<ffffffff8158a927>] ? pcpu_fc_alloc+0x0/0xac
> [<ffffffff8157a908>] ? pcpu_fc_free+0x0/0x1f
> [<ffffffff8157a749>] setup_per_cpu_areas+0x65/0x219
> [<ffffffff815721ff>] start_kernel+0x124/0x2c5
> [<ffffffff81571a92>] x86_64_start_reservations+0x82/0x86
> [<ffffffff81571b7a>] x86_64_start_kernel+0xe4/0xeb
> RIP pcpu_setup_first_chunk+0x40d/0x703

I'm a bit confused by the panic message.  The PANIC line says rip is
0xffffffff81598250 which is arch/x86/pci/amd_bus.c:315 which is in the
middle of early_fill_mp_bus_info() which happens way later during
initialization while the call stack shows pcpu_embed_first_chunk()
just called pcpu_setup_first_chunk.  You sure this is the right image?
Anyways, the last line "RIP pcpu_setup_first_chunk+0x40d/0x703"
combined with the exception number (#UD) indicates that it's probably
line 1635 in percpu.c.

Can you please apply the following patch and report the failing log?
Specifying earlyprintk=vga (or something like
earlyprintk=ttyS0,115200) should show you how pcpu initialization is
failing.

Thanks.

diff --git a/mm/percpu.c b/mm/percpu.c
index 43d8cac..d9a636f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1631,8 +1631,18 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_last_unit_cpu = cpu;
 	pcpu_nr_units = unit;

-	for_each_possible_cpu(cpu)
-		BUG_ON(unit_map[cpu] == NR_CPUS);
+	for_each_possible_cpu(cpu) {
+		static char cpus[4096] __initdata;
+
+		if (unit_map[cpu] != NR_CPUS)
+			continue;
+
+		printk(KERN_CRIT "PERCPU: unit missing for cpu%d\n", cpu);
+		cpumask_scnprintf(cpus, sizeof(cpus), cpu_possible_mask);
+		printk(KERN_CRIT "PERCPU: cpu_possible_mask=%s\n", cpus);
+		pcpu_dump_alloc_info(KERN_CRIT, ai);
+		BUG();
+	}

 	pcpu_nr_groups = ai->nr_groups;
 	pcpu_group_offsets = group_offsets;


-- 
tejun
