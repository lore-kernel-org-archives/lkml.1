Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYFWKvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYFWKvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbYFWKvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:51:22 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:39860 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbYFWKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:51:20 -0400
Message-ID: <485F8028.1070302@linux.vnet.ibm.com>
Date: Mon, 23 Jun 2008 16:21:20 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rnsastry@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
Subject: [BUG] While changing the cpufreq governor, kernel hits a bug in workqueue.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While changing the cpufreq governor with the following script for about 
30 minutes, the kernel hits a BUG in workqueue.c.  Detailed trace attached.

Script:
#!/bin/bash

while [ 1 ]
do
	for govnrs in ondemand conservative
	do
		for cpu in 0 1 2 3
		do
		echo $govnrs > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor
		if ! [ -d /sys/devices/system/cpu/cpu${cpu}/cpufreq/${govnrs} ] ; then
			echo "Error: Enable to create dir $govnrs"
		fi
		done
	done
done

Kernel stack trace:
------------[ cut here ]------------
kernel BUG at kernel/workqueue.c:223!
invalid opcode: 0000 [#1] SMP
Modules linked in: cpufreq_powersave cpufreq_conservative 
cpufreq_userspace usb_storage usbhid ehci_hcd ohci_hcd uhci_hcd usbcore

Pid: 232, comm: kondemand/1 Not tainted (2.6.25.7 #1)
EIP: 0060:[<c012f61a>] EFLAGS: 00010286 CPU: 1
EIP is at queue_delayed_work_on+0x20/0x97
EAX: 00000000 EBX: c483ba94 ECX: c483ba94 EDX: 00000000
ESI: c483bab0 EDI: f7a3f708 EBP: 00000001 ESP: f7a69f40
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kondemand/1 (pid: 232, ti=f7a68000 task=f794d020 task.ti=f7a68000)
Stack: 00000000 f7a3e7b0 c483ba80 f7ab5e98 c041e54d 00000040 00000000 
00000001
        00000040 00000246 00000000 00000002 00000000 c012ee7f c483ba98 
f7a3e7b0
        c483ba94 f7a69f9c c012eeba 00000000 00000002 c012ee7f c041e31e 
c099e2a8
Call Trace:
  [<c041e54d>] do_dbs_timer+0x22f/0x24f
  [<c012ee7f>] run_workqueue+0x81/0x187
  [<c012eeba>] run_workqueue+0xbc/0x187
  [<c012ee7f>] run_workqueue+0x81/0x187
  [<c041e31e>] do_dbs_timer+0x0/0x24f
  [<c012f6fa>] worker_thread+0x0/0xbd
  [<c012f7ad>] worker_thread+0xb3/0xbd
  [<c0131acc>] autoremove_wake_function+0x0/0x2d
  [<c0131a1b>] kthread+0x38/0x5d
  [<c01319e3>] kthread+0x0/0x5d
  [<c0105527>] kernel_thread_helper+0x7/0x10
  =======================
Code: c3 a1 dc da 6a c0 e9 78 ff ff ff 55 89 c5 57 89 d7 56 53 89 cb 8d 
71 1c f0 0f ba 29 00 19 c0 31 d2 85 c0 75 76 83 79 1c 00 74 04 <0f> 0b 
eb fe 8d 41 04 39 41 04 74 04 0f 0b eb fe 89 f8 64 8b 15
EIP: [<c012f61a>] queue_delayed_work_on+0x20/0x97 SS:ESP 0068:f7a69f40
---[ end trace 40ca209e9f1ab79d ]---


Kernel tainted:
# cat /proc/sys/kernel/tainted
128

# /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz
stepping	: 6
cpu MHz		: 1992.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 
cx16 xtpr dca lahf_lm
bogomips	: 5990.92
clflush size	: 64
power management:

This machine is having two Dual core. Core 0 information provided above.

CPUID information:
# ./cpuid
CPU:
    vendor_id = "GenuineIntel"
    version information (1/eax):
       processor type  = primary processor (0)
       family          = Intel Pentium Pro/II/III/Celeron, AMD 
Athlon/Duron, Cyrix M2, VIA C3 (6)
       model           = 0xf (15)
       stepping id     = 0x6 (6)
       extended family = 0x0 (0)
       extended model  = 0x0 (0)
       (simple synth)  = Intel Core 2 Duo (Conroe/Allendale B2) / Core 2 
Extreme Processor (Conroe B2) / Dual-Core Xeon Processor 5100 (Woodcrest 
B2), 65nm

[...]

    feature information (1/ecx):
       PNI/SSE3: Prescott New Instructions    = true
       MONITOR/MWAIT                          = true
       CPL-qualified debug store              = true
       VMX: virtual machine extensions        = true
       Enhanced Intel SpeedStep Technology    = true
       thermal monitor 2                      = true
       context ID: adaptive or shared L1 data = false
       cmpxchg16b available                   = true
       xTPR disable                           = true

[...]

Kernel configuration used:
# CPU Frequency scaling
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

# rpm -qa | egrep "binutils|gcc"
binutils-2.17.50.0.6-2.el5
gcc-c++-4.1.1-52.el5
gcc-4.1.1-52.el5
libgcc-4.1.1-52.el5
gcc-gfortran-4.1.1-52.el5

# uname -a
Linux x3550 2.6.25.7 #1 SMP Thu Jun 19 17:24:06 IST 2008 i686 i686 i386 
GNU/Linux

Could be able to reproduce the same on 2.6.26-rc6.

Please let me know if you need more information.
Please CC me as I am not subscribed.

Thanks in advance.

Regards
R.Nageswara Sastry, CSTE®,C|EH®,CSTM®
Linux Technology Center
IBM India System & Technology Lab
