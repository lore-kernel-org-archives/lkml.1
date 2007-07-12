Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbXGLIyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbXGLIyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXGLIyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:54:04 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:54620 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbXGLIyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:54:01 -0400
Message-ID: <4695EC25.6050003@arcor.de>
Date: Thu, 12 Jul 2007 10:53:57 +0200
From: Timo Lindemann <tlindemann@arcor.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel hang in ohci init
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

a problem report to something giving me a real headache:

[1.] Kernel hangs when initializing ohci-controller

[2.] The version 2.6.22 of the linux kernel hangs when initializing the
integrated ohci controller of the nvidia MCP51 chipset (pci device ids
vendor:product == 10de:26d). I have traced through various printks that
pci_init calls pci_fixup_device, later on in quirk_usb_ohci_handoff
(file linux/drivers/usb/host/pci-quirks.c) kernel freezes in this
section:
...
if (control & OHCI_CTRL_IR) {
        int wait_time = 500;
        writel(OHCI_INTR_OC, base + OHCI_INTRENABLE);
        writel(OHCI_ORC, base + OHCI_CMDSTATUS); // this never returns
...
after this, kernel apparently goes into busy waiting (fans gradually
turn louder) and hangs indefinitely. I have also made sure that writel
(in linux/include/asm/io.h) really is entered, but never returns.

[3.] keywords: pci ohci kernel

[4.] /proc/version can not be read, as kernel freezes in startup

[5.] No Oops, no panic

[6.] Reproducible by booting any version 2.6.21+ on that machine
(nvidia MCP51-Chipset, see the lspci output)

[7.1] the ver_linux output under 2.6.20.6, in the directory of 2.6.22,
says:

Gnu C                  4.2.1
Gnu make               3.81
binutils               2.17.50.0.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.40
jfsutils               1.1.11
reiserfsprogs          3.6.20
xfsprogs               2.8.21
pcmciautils            014
PPP                    2.4.4
Linux C Library        > libc.2.6
Dynamic linker (ldd)   2.6
Linux C++ Library      so.6.0
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   113
wireless-tools         29
Modules Loaded         rt2500* nvidia* forcedeth

* nvidia and rt2500 are most assuredly not involved in this. They are
not loaded by that kernel.

[7.2] Processor information:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 36
model name      : AMD Turion(tm) 64 Mobile Technology ML-37
stepping        : 2
cpu MHz         : 800.000
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt
lm 3dnowext 3dnow pni lahf_lm ts fid vid ttp tm stc
bogomips        : 1608.22
clflush size    : 64

[7.3] no modules have been configured (all in-kernel)

[7.4] n/a

[7.5] (I cannot run this with 2.6.22. In 2.6.20.6, the output can be
retrieved from http://cip.uni-trier.de/~lindem/lspci.txt as this is
really large)

[7.6] (I have SATA, but again, I don't reach /proc from within that
kernel)

[7.7] What is striking about that problem is that kernel 2.6.20.6 does
not even enter the section mentioned in [2.]. If booted, serial console
and netconsole do not work either, nor does magic sysrq key. Also, this
is a 64bit cpu, running a 32bit linux distro, and it happens regardless
whether 64bit resources are activated or not.

[X.] I tried hard to understand what's going on, but ultimately, I could
not yet write a fix, workaround, or anything like that, so I am asking
for help/enlightenment, or even an already-done fix. Really very
sorry. Also, different options like noapic, nolapic, acpi=off,
pci=routeirq|biosirq|usepirqmask were already tried; I also tried
disabling quirks for that particular vendor:device-combination, which
leads to another freeze further along. Also, commenting the writel()
will hang indefinitely in the following wait_time loop.

I can only guess that it might
have to do with the patch
"commit 4302a595cd9c6363b495460497ecbda49fa16858
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Fri Dec 15 06:53:55 2006 +1100
USB: Rework the OHCI quirk mecanism as suggested by David
"
but I don't really have a clue, so this might be groundless suspicion.
If so, I apologize about that.

Greetings and thanks for all the work with the kernel!

-- 
Timo Lindemann
