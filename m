Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZIVJI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZIVJI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZIVJI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:08:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:58518 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496AbZIVJI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:08:56 -0400
Message-ID: <4AB89417.7090005@kernel.org>
Date: Tue, 22 Sep 2009 18:08:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tony Vroon <tony@linx.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
References: <1253560490.2934.42.camel@localhost>	 <4AB7D349.4000802@zytor.com> <1253566046.2773.10.camel@localhost>
In-Reply-To: <1253566046.2773.10.camel@localhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 09:08:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> Thanks Ingo. 11-step bisection reveals:
> 
> chainsaw@prometheus /cvs/linux-2.6 $ git bisect bad
> fd1e8a1fe2b54df6c185b4fa65f181f50b9c4d4e is the first bad commit
> commit fd1e8a1fe2b54df6c185b4fa65f181f50b9c4d4e
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Aug 14 15:00:51 2009 +0900
> 
>     percpu: introduce pcpu_alloc_info and pcpu_group_info
> 
> I will repeat the early exception here:
> IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x10de8201 base: 0xfed00000
> SMP: allowing 12 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at b00000000 (gap:b00000000:3000000
> NR_CPUS: 12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:2
> PERCPU: Embedded 23 pages/cpu @ffff880028200000 s73688 r0 d20520 u262
> PANIC: early exception 06 rip 10:ffffffff815a50e6 error 0 cr2 d0fff6
> Pid: 0, comm: swapper Not tained 2.6.31-07068-g43c266 #1
> Call Trace:
> [<ffffffff81591175>] early_idt_handler+0x55/0x68
> [<ffffffff815a50e6>] ? pcpu_setup_first_chunk+0x40b/0x692
> [<ffffffff815a50ff>] ? pcpu_setup_first_chunk+0x424/0x692
> [<ffffffff815a5867>] pcpu_embed_first_chunk+0x1e2/0x241
> [<ffffffff81598c14>] ? pcpu_fc_alloc+0x0/0xac
> [<ffffffff81598bf5>] ? pcpu_fc_free+0x0/0x1f
> [<ffffffff81598a36>] setup_per_cpu_areas+0x65/0x219
> [<ffffffff815919bf>] start_kernel+0x124/0x2c5
> [<ffffffff81591252>] x86_64_start_reservations+0x82/0x86
> [<ffffffff8159133a>] x86_64_start_kernel+0xe4/0xeb
> RIP pcpu_setup_first_chunk+0x40b/0x692

Can you please try the patch below?  Also, please build the kernel
with debug info and ask gdb which line the crash corresponds to?
ie. l *pcpu_embed_first_chunk+0x1e2

Thanks.

diff --git a/mm/percpu.c b/mm/percpu.c
index 43d8cac..66b7d5e 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1812,6 +1812,9 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
 		/* allocate space for the whole group */
 		ptr = alloc_fn(cpu, gi->nr_units * ai->unit_size, atom_size);
 		if (!ptr) {
+			printk("PERCPU: failed to allocate %zu bytes for "
+			       "group %d from cpu%u\n",
+			       gi->nr_units * ai->unit_size, group, cpu);
 			rc = -ENOMEM;
 			goto out_free_areas;
 		}
@@ -1844,8 +1847,9 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,

 out_free_areas:
 	for (group = 0; group < ai->nr_groups; group++)
-		free_fn(areas[group],
-			ai->groups[group].nr_units * ai->unit_size);
+		if (areas[group])
+			free_fn(areas[group],
+				ai->groups[group].nr_units * ai->unit_size);
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)
@@ -1956,7 +1960,8 @@ int __init pcpu_page_first_chunk(size_t reserved_size,

 enomem:
 	while (--j >= 0)
-		free_fn(page_address(pages[j]), PAGE_SIZE);
+		if (pages[j])
+			free_fn(page_address(pages[j]), PAGE_SIZE);
 	rc = -ENOMEM;
 out_free_ar:
 	free_bootmem(__pa(pages), pages_size);


-- 
tejun
