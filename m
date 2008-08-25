Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYHYGfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYHYGfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYHYGfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:35:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:36725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYHYGfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:35:10 -0400
Subject: [BUG] cpufreq: constant cpu_khz
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, davej <davej@codemonkey.org.uk>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 08:33:52 +0200
Message-Id: <1219646032.20732.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I noticed that my sched_clock() was slow on a number of machine, so I
started looking at cpufreq. I inserted the following printk in the
set_cyc2ns_scale() function, which is called from the cpufreq change
notifier:

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 46af716..8dffd82 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -261,6 +263,9 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	if (cpu_khz)
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
 
+	printk(KERN_DEBUG "set_cyc2ns_scale: %lu %lu %d\n",
+			*scale, cpu_khz, cpu);
+
 	sched_clock_idle_wakeup_event(0);
 	local_irq_restore(flags);
 }


And on my laptop:

root@lappy:~# dmesg | grep cyc2ns | tail -10
[   91.378693] set_cyc2ns_scale: 854 1198980 0
[   91.378713] set_cyc2ns_scale: 854 1198980 0
[  110.548064] set_cyc2ns_scale: 854 1198980 0
[  110.548106] set_cyc2ns_scale: 854 1198980 0
[  110.756121] set_cyc2ns_scale: 854 1198980 0
[  110.756135] set_cyc2ns_scale: 854 1198980 0
[  440.812063] set_cyc2ns_scale: 854 1198980 0
[  440.812106] set_cyc2ns_scale: 854 1198980 0
[  441.593140] set_cyc2ns_scale: 854 1198980 0
[  441.593159] set_cyc2ns_scale: 854 1198980 0

even though I'm sure there were some 800 <-> 1200 MHz changes there
esp. as:

root@lappy:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Pentium(R) III Mobile CPU      1200MHz
stepping        : 1
cpu MHz         : 798.000
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse up nopl
bogomips        : 1598.64
clflush size    : 32
power management:


On my opteron:

[root@opteron ~]# dmesg | grep cyc2ns | tail -10
[    0.000000] set_cyc2ns_scale: 427 2394004 0
[    0.000000] set_cyc2ns_scale: 427 2394004 1
[   14.784154] set_cyc2ns_scale: 427 2394004 0
[   14.788342] set_cyc2ns_scale: 427 2394004 1
[   14.792789] set_cyc2ns_scale: 427 2394004 0
[   14.797028] set_cyc2ns_scale: 427 2394004 1
[   15.841049] set_cyc2ns_scale: 427 2394004 0
[   15.845250] set_cyc2ns_scale: 427 2394004 1
[   15.849503] set_cyc2ns_scale: 427 2394004 0
[   15.853785] set_cyc2ns_scale: 427 2394004 1
[root@opteron ~]# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : Dual-Core AMD Opteron(tm) Processor 1216
stepping        : 2
cpu MHz         : 1000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 1995.00
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : Dual-Core AMD Opteron(tm) Processor 1216
stepping        : 2
cpu MHz         : 1000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 1995.00
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


