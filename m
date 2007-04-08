Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbXDHRlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbXDHRlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 13:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXDHRlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 13:41:12 -0400
Received: from bravo.securenet-server.net ([207.210.84.244]:40384 "EHLO
	bravo.securenet-server.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbXDHRlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 13:41:10 -0400
X-Greylist: delayed 4624 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2007 13:41:10 EDT
From: Mircea Bardac <dev.list@mircea.bardac.net>
To: linux-kernel@vger.kernel.org
Subject: CPU off-on-off: lost CPU management?
Date: Sun, 8 Apr 2007 19:23:31 +0300
User-Agent: KMail/1.9.6
Cc: "Andika Triwidada" <andika@gmail.com>, linux@brodo.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704081923.35312.dev.list@mircea.bardac.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bravo.securenet-server.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - mircea.bardac.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

After reading "CPU offline but power consumption increased?" lkml thread I 
wanted to test CPU on-off on my Turion 64 X2.

I found out something strange, related to the way CPU is turned off and back 
on. I don't know if this is a kernel bug, but looks pretty suspicious.


**** The initial situation, both cores running at 1.6 GHz, full info displayed
**** /proc/cpuinfo

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 1600.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm 
stc
bogomips        : 3195.47
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 1600.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm 
stc
bogomips        : 3195.47
clflush size    : 64



**** The initial situation, both cores running at 1.6 GHz, full info displayed
**** cpufreq-info

# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0 1
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 1.60 GHz (asserted by call to hardware).
analyzing CPU 1:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0 1
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 1.60 GHz (asserted by call to hardware).



**** 2nd core is shut down

# echo 0 > /sys/devices/system/cpu/cpu1/online



**** Only 2nd core is now running, at 800 MHz, half bogomips
**** /proc/cpuinfo

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow up pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm 
stc
bogomips        : 1597.73
clflush size    : 64



**** Only 2nd core is now running, at 800 MHz, half bogomips
**** cpufreq-info

# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz (asserted by call to hardware).



**** Turning 2nd core back on

# echo 1 > /sys/devices/system/cpu/cpu1/online



**** /proc/cpuinfo shows again info about 2nd core
**** but some details are missing about 2nd core, such as "cache size"
**** (others might also be missing) - this makes me think something might not
**** be working right (cache not used maybe?)
**** Bogomips is still half (I'm not sure if this is directly proportional
**** with CPU frequency or with number of cores)

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm 
stc
bogomips        : 1597.73
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2
cpu MHz         : 1596.093
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8legacy ts fid vid ttp tm 
stc
bogomips        : 1596.01
clflush size    : 64


**** cpufreq-info shows info only about 1st core

# cpufreq-info
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to linux@brodo.de, please.
analyzing CPU 0:
  driver: powernow-k8
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 800 MHz - 1.60 GHz
  available frequency steps: 1.60 GHz, 800 MHz
  available cpufreq governors: powersave, performance
  current policy: frequency should be within 800 MHz and 1.60 GHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 800 MHz (asserted by call to hardware).
analyzing CPU 1:
  no or unknown cpufreq driver is active on this CPU



**** reloading powernow-k8 driver, to check if cpufreq-info gets back working

# rmmod powernow-k8

# modprobe powernow-k8
FATAL: Error inserting powernow_k8 
(/lib/modules/2.6.20-ARCH/kernel/arch/i386/kernel/cpu/cpufreq/powernow-k8.ko): 
No such device


Many thanks,
Mircea

-- 
http://mircea.bardac.net
