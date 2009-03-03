Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZCCNH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZCCNH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZCCNHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:07:19 -0500
Received: from mail.gmx.net ([213.165.64.20]:39937 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750944AbZCCNHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:07:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/hTJEoyWLhKKVv6KzWOYGky9JV17aQ6Hg9CEuGyM
	AOCt5T97rsag+e
Subject: x86-tip: cpufreq breakage - bisection fingers
	89c9215165ca609096e845926d9a18f1306176a4
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 14:07:12 +0100
Message-Id: <1236085632.5958.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Box is Q6600, X86_64.  I haven't poked at it other than to verify the
bisection result via patchlet below data.

[    1.672700] overflow in relocation type 11 val 3a000f06b588
[    1.681051] `processor' likely not compiled with -mcmodel=kernel
[    1.693753] overflow in relocation type 11 val 3a000f06b588
[    1.693755] `processor' likely not compiled with -mcmodel=kernel
[    1.720399] thermal: Unknown symbol acpi_processor_set_thermal_limit
[    5.569294] overflow in relocation type 11 val 3a000f06b6d8
[    5.578042] `processor' likely not compiled with -mcmodel=kernel
[    5.619269] overflow in relocation type 11 val 3a000f06b6e0
[    5.619271] `processor' likely not compiled with -mcmodel=kernel
[    5.646081] overflow in relocation type 11 val 3a000f06b6e0
[    5.655513] `processor' likely not compiled with -mcmodel=kernel
[    5.700693] overflow in relocation type 11 val 3a000f06b7c8
[    5.700695] `processor' likely not compiled with -mcmodel=kernel
[    5.744519] overflow in relocation type 11 val 3a000f06b7c8
[    5.772634] `processor' likely not compiled with -mcmodel=kernel
[    6.010536] thermal: Unknown symbol acpi_processor_set_thermal_limit
[    6.188154] overflow in relocation type 11 val 3a000f06b9f8
[    6.188156] `processor' likely not compiled with -mcmodel=kernel
[    6.212162] thermal: Unknown symbol acpi_processor_set_thermal_limit
[   10.143511] overflow in relocation type 11 val 3a000f06ba98
[   10.152509] `processor' likely not compiled with -mcmodel=kernel
[   10.612100] overflow in relocation type 11 val 3a000f06ddc8
[   10.621221] `processor' likely not compiled with -mcmodel=kernel
[   10.731705] overflow in relocation type 11 val 3a000f06deb8
[   10.740753] `processor' likely not compiled with -mcmodel=kernel
[   10.755799] overflow in relocation type 11 val 3a000f06deb8
[   10.764934] `processor' likely not compiled with -mcmodel=kernel
[   10.967668] thermal: Unknown symbol acpi_processor_set_thermal_limit
[   11.019259] overflow in relocation type 11 val 3a000f06ded8
[   11.028755] `processor' likely not compiled with -mcmodel=kernel
[   11.123935] overflow in relocation type 11 val 3a000f06def0
[   11.133523] `processor' likely not compiled with -mcmodel=kernel
[   11.207454] thermal: Unknown symbol acpi_processor_set_thermal_limit
[   18.805201] overflow in relocation type 11 val 3a000f06f9a0
[   18.813655] `processor' likely not compiled with -mcmodel=kernel
[   18.919112] overflow in relocation type 11 val 3a000f06f998
[   18.927626] `freq_table' likely not compiled with -mcmodel=kernel
[   19.256349] acpi_cpufreq: Unknown symbol cpufreq_frequency_table_target
[   19.266022] acpi_cpufreq: Unknown symbol cpufreq_frequency_table_get_attr
[   19.275759] acpi_cpufreq: Unknown symbol acpi_processor_notify_smm
[   19.284741] acpi_cpufreq: Unknown symbol acpi_processor_unregister_performance
[   19.294857] acpi_cpufreq: Unknown symbol acpi_processor_preregister_performance
[   19.304938] acpi_cpufreq: Unknown symbol acpi_processor_register_performance
[   19.314833] acpi_cpufreq: Unknown symbol cpufreq_freq_attr_scaling_available_freqs
[   19.325205] acpi_cpufreq: Unknown symbol cpufreq_frequency_table_cpuinfo
[   19.334698] acpi_cpufreq: Unknown symbol cpufreq_frequency_table_put_attr
[   19.344204] acpi_cpufreq: Unknown symbol cpufreq_frequency_table_verify

89c9215165ca609096e845926d9a18f1306176a4 is first bad commit
commit 89c9215165ca609096e845926d9a18f1306176a4
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Feb 24 11:57:21 2009 +0900

    x86: add embedding percpu first chunk allocator
    
    Impact: add better first percpu allocation for !NUMA
    
    On !NUMA, we can simply allocate contiguous memory and use it for the
    first chunk without mapping it into vmalloc area.  As the memory area
    is covered by the large page physical memory mapping, it allows the
    dynamic perpcu allocator to not add any TLB overhead for the static
    percpu area and whatever falls into the first chunk and the
    implementation is very simple too.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>

:040000 040000 2c918c6a40167d3ee5a86272682ed404ded599b6 7e1a548ab4aec547905ca35ea6a964c7241264a7 M	arch

git bisect start
# good: [2450cf51a1bdba7037e91b1bcc494b01c58aaf66] Revert "menu: fix embedded menu snafu"
git bisect good 2450cf51a1bdba7037e91b1bcc494b01c58aaf66
# bad: [2b42bd438d4002ad42494f746f723f8d38320df1] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip into x86-tip
git bisect bad 2b42bd438d4002ad42494f746f723f8d38320df1
# good: [31526355272dfebdf1ad8cd0f452fc47c59ca221] manual merge of auto-iommu-next
git bisect good 31526355272dfebdf1ad8cd0f452fc47c59ca221
# good: [a131dd32f2409df645863e3e210ef1462ba8d6fa] Merge branch 'out-of-tree'
git bisect good a131dd32f2409df645863e3e210ef1462ba8d6fa
# bad: [680305b987ea818d995760040f813547a2712ff9] Merge branch 'x86/mm'
git bisect bad 680305b987ea818d995760040f813547a2712ff9
# good: [b95dcd235cbbd01c356e586b77ab8208a762a819] Merge branch 'x86/apic'
git bisect good b95dcd235cbbd01c356e586b77ab8208a762a819
# good: [96dfd063990da3be59093cd9a7f1af8981ad5b27] Merge branch 'warnings/complex'
git bisect good 96dfd063990da3be59093cd9a7f1af8981ad5b27
# good: [c6a8e0a97d660a9eb29808eb67adacb6b1bab373] Merge branch 'tracing/ftrace'
git bisect good c6a8e0a97d660a9eb29808eb67adacb6b1bab373
# good: [8d408b4be37bc49c9086531f2ebe411cf5731746] percpu: give more latitude to arch specific first chunk initialization
git bisect good 8d408b4be37bc49c9086531f2ebe411cf5731746
# bad: [56becc479934e00ec6ee7abfb6aec5e9bd744b39] Merge branch 'core/percpu'
git bisect bad 56becc479934e00ec6ee7abfb6aec5e9bd744b39
# bad: [40150d37be7f7949b2ec07d511244da856647d84] percpu: add __read_mostly to variables which are mostly read only
git bisect bad 40150d37be7f7949b2ec07d511244da856647d84
# bad: [89c9215165ca609096e845926d9a18f1306176a4] x86: add embedding percpu first chunk allocator
git bisect bad 89c9215165ca609096e845926d9a18f1306176a4
# good: [5f5d8405d1c50f5cf7e1dbfe9c9b44e2f015c8fd] x86: separate out setup_pcpu_4k() from setup_per_cpu_areas()
git bisect good 5f5d8405d1c50f5cf7e1dbfe9c9b44e2f015c8fd

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index c29f301..ad3a470 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -392,8 +392,10 @@ void __init setup_per_cpu_areas(void)
 	 * each allocator for details.
 	 */
 	ret = setup_pcpu_remap(static_size);
+#if 0
 	if (ret < 0)
 		ret = setup_pcpu_embed(static_size);
+#endif
 	if (ret < 0)
 		ret = setup_pcpu_4k(static_size);
 	if (ret < 0)




