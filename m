Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZEOInT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZEOInT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZEOInB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:43:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:58892 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006AbZEOIm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:42:59 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [v0 PATCH 0/4] Add INT mode support for EDAC drivers on Maple
Date: Fri, 15 May 2009 16:43:50 +0800
Message-Id: <1242377034-7378-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 15 May 2009 08:42:48.0506 (UTC) FILETIME=[2017E9A0:01C9D539]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Comments:		
---------

What to be added
-----------------

1, Support EDAC INT mode on Maple platform, where CPC925 Hypertransport
hostbridge controller will latch MPIC INT0 pin on receiving upstream
NMI request messages with vector == 0 that posted from Hypertransport
southbridges such as AMD8131 & AMD8111 chips.

Since multiple southbridges could post NMI request messages, EDAC core
should be responsible for maintaining the mapping from hwirq == 0 to
the related virq, that's what edac_mpic_irq.c is for - on the very first
call to edac_get_mpic_irq() related mapping will be created, and the
same virq will be returned to caller on successive calls with its
reference count increased. On EDAC driver module removal the reference
count will be decreased by edac_put_mpic_irq() accordingly, and the 
mapping will be disposed if it reaches zero. 

edac_mpic_irq.c and its exported APIs will be controlled by CONFIG_MPIC
since it will be inert for EDAC drivers where related hardware doesn't
support MPIC.

Now AMD8111 & AMD8131 EDAC drivers could register their error handlers
to the virtual IRQ that maps to hardware IRQ == 0. If they ever adopted
on a new machine other than Maple or where MPIC is not supported, their
new EDAC driver should implement a machine-specific method to get a IRQ
from their NMI request messages.

2, Add a new EDAC MCE mode for CPC925 EDAC driver. CPC925 Hypertransport
hostbridge controller may generate MCE on memory ECC Errors and Processor
Interface Errors, their EDAC handlers could be hooked into the generic MCE
handler in MCE mode.


Known limitations
------------------
I once tried to trigger memory ECC errors by trying to mask two DIMM data
pins in the way described by the first test method on EDAC twiki page(
http://bluesmoke.sourceforge.net/testing.html), but only resulted in Maple's
FRU date being destroyed and only after reflashing FRU data could Maple
boot up normally when inserted back to chassis. Since Maple is locked in
the chassis the second approach of heat-lamp won't be applicable either.

As for the MCE/INT mode support for CPC925 EDAC driver, following aspects
have been tested:
1, module initialization and deletion in MCE/INT mode;
2, creation and deletion for the mapping between hwirq==2 to a virq
   for the Hypertransport Link Errors;
3, registration and unregistration for the EDAC MCE handler from the
   generic MCE handler on PPC;

Due to the difficulty and complexity to generate a real hardware
ECC/HT Link/CPU Errors, below aspects have not been tested yet:
1, if ECC or CPU Errors would generate MCE event;
2, if HT Link Error will indeed latch MPIC INT2 pin;
3, if EDAC isr/mce methods could handle errors correctly.

As for the INT mode support for AMD8111 & AMD87131 EDAC driver,
below aspects have not been tested yet:
1, code that controls the generation of the NMI Request Message;
2, the mapping from the NMI Request Messages to MPIC INT0 pin;
3, if EDAC isr methods could handle errors correctly.

I think I am at the point where I'd like to seek comments and ideas
from others about how to resolve above test issues, hope someone knows
a proper method or has an instrument to generate real hardware errors.

Any comments are welcomed!


Test steps:
-----------
CONFIG_EDAC=y
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD8111=m
CONFIG_EDAC_AMD8131=m
CONFIG_EDAC_CPC925=m

insmod edac_core.ko
insmod cpc925_edac.ko
insmod amd8111_edac.ko amd8111_op_state=1
insmod amd8131_edac.ko amd8131_op_state=1
cat /proc/interrupts

cd /sys/devices/system/edac/
cat cpu/poll_msec
cat htlink/poll_msec
cat lpc/poll_msec

rmmod cpc925_edac
rmmod amd8111_edac
rmmod amd8131_edac

insmod amd8111_edac.ko amd8111_op_state=1
insmod amd8131_edac.ko amd8131_op_state=1
insmod cpc925_edac.ko
cat /proc/interrupts

rmmod cpc925_edac
rmmod amd8111_edac
rmmod amd8131_edac
cat /proc/interrupts

insmod amd8131_edac.ko
insmod amd8111_edac.ko
cat /proc/interrupts
cd /sys/devices/system/edac/
cat lpc/poll_msec

rmmod amd8111_edac
rmmod amd8131_edac
rmmod edac_core

Test results:
-------------

root@localhost:/root> cd /int
root@localhost:/int> dmesg -n 8
root@localhost:/int> lsmod
Module                  Size  Used by
root@localhost:/int> insmod edac_core.ko 
EDAC MC: Ver: 2.1.0 May 12 2009
insmod used greatest stack depth: 4880 bytes left
root@localhost:/int> insmod amd8111_edac.ko amd8111_op_state=1
AMD8111 EDAC driver  Ver: 1.0.0 May 12 2009
	(c) 2008 Wind River Systems, Inc.
amd8111_lpc_bridge_init: port 97 is buggy, not supported by hardware?
amd8111_NMI_global_enable: PM48[NMI2SMI_EN] is cleared
EDAC DEVICE0: Giving out device to module 'amd8111_edac' controller 'lpc': DEV '0000:00:06.0' (INTERRUPT)
added one device on AMD8111 vendor 1022, device 7468, name lpc
EDAC PCI0: Giving out device to module 'amd8111_edac' controller 'AMD8111_PCI_Controller': DEV '0000:00:05.0' (INTERRUPT)
added one device on AMD8111 vendor 1022, device 7460, name AMD8111_PCI_Controller
irq: irq 0 on host /hostbridge@0/interrupt-controller@f8040000 mapped to virtual irq 18
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        120        300   MPIC      Edge      serial
 18:          0          0   MPIC      Edge      [EDAC] AMD8111
 22:       6020      23894   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       2912       2595   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> insmod amd8131_edac.ko amd8131_op_state=1
AMD8131 EDAC driver  Ver: 1.0.0 May 12 2009
	(c) 2008 Wind River Systems, Inc.
EDAC PCI1: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_NORTH_A': DEV '0000:00:01.0' (INTERRUPT)
added one device on AMD8131 vendor 1022, device 7451, devfn 8, name AMD8131_PCIX_NORTH_A
EDAC PCI2: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_NORTH_B': DEV '0000:00:02.0' (INTERRUPT)
added one device on AMD8131 vendor 1022, device 7451, devfn 10, name AMD8131_PCIX_NORTH_B
EDAC PCI3: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_SOUTH_A': DEV '0000:00:03.0' (INTERRUPT)
added one device on AMD8131 vendor 1022, device 7451, devfn 18, name AMD8131_PCIX_SOUTH_A
EDAC PCI4: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_SOUTH_B': DEV '0000:00:04.0' (INTERRUPT)
added one device on AMD8131 vendor 1022, device 7451, devfn 20, name AMD8131_PCIX_SOUTH_B
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        141        420   MPIC      Edge      serial
 18:          0          0   MPIC      Edge      [EDAC] AMD8111, [EDAC] AMD8131
 22:       6031      23955   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       2931       2608   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> insmod cpc925_edac.ko 
IBM CPC925 EDAC driver  Ver: 1.0.0 May 12 2009
	(c) 2008 Wind River Systems, Inc
EDAC MC0: Giving out device to 'cpc925_edac' 'cpc925_edac': DEV cpc925_edac.0
EDAC DEVICE1: Giving out device to module 'cpc925_edac' controller 'cpu': DEV 'cpu.0' (INTERRUPT)
irq: irq 2 on host /hostbridge@0/interrupt-controller@f8040000 mapped to virtual irq 19
EDAC DEVICE2: Giving out device to module 'cpc925_edac' controller 'htlink': DEV 'htlink.0' (INTERRUPT)
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        172        464   MPIC      Edge      serial
 18:          0          0   MPIC      Edge      [EDAC] AMD8111, [EDAC] AMD8131
 19:          0          0   MPIC      Edge      [EDAC] CPC925 
 22:       6186      24557   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       2971       2632   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> cd /sys/devices/system/edac/
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 Jan  1 05:46 cpu
drwxr-xr-x 3 root root 0 Jan  1 05:46 htlink
drwxr-xr-x 3 root root 0 Jan  1 05:46 lpc
drwxr-xr-x 3 root root 0 Jan  1 05:46 mc
drwxr-xr-x 7 root root 0 Jan  1 05:46 pci
root@localhost:/sys/devices/system/edac> cat cpu/poll_msec 
0
root@localhost:/sys/devices/system/edac> cat htlink/poll_msec 
0
root@localhost:/sys/devices/system/edac> cat lpc/poll_msec 
0
root@localhost:/sys/devices/system/edac> ls -lt mc/mc0
total 0
-r--r--r-- 1 root root 4096 Jan  1 05:46 ce_count
-r--r--r-- 1 root root 4096 Jan  1 05:46 ce_noinfo_count
drwxr-xr-x 2 root root    0 Jan  1 05:46 csrow0
drwxr-xr-x 2 root root    0 Jan  1 05:46 csrow4
lrwxrwxrwx 1 root root    0 Jan  1 05:46 device -> ../../../../platform/cpc925_edac.0
-r--r--r-- 1 root root 4096 Jan  1 05:46 mc_name
--w------- 1 root root 4096 Jan  1 05:46 reset_counters
-rw-r--r-- 1 root root 4096 Jan  1 05:46 sdram_scrub_rate
-r--r--r-- 1 root root 4096 Jan  1 05:46 seconds_since_reset
-r--r--r-- 1 root root 4096 Jan  1 05:46 size_mb
-r--r--r-- 1 root root 4096 Jan  1 05:46 ue_count
-r--r--r-- 1 root root 4096 Jan  1 05:46 ue_noinfo_count
root@localhost:/sys/devices/system/edac> ls -lt pci   
total 0
-rw-r--r-- 1 root root 4096 Jan  1 05:46 check_pci_errors
-rw-r--r-- 1 root root 4096 Jan  1 05:46 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 Jan  1 05:46 edac_pci_log_pe
-rw-r--r-- 1 root root 4096 Jan  1 05:46 edac_pci_panic_on_pe
drwxr-xr-x 2 root root    0 Jan  1 05:46 pci0
drwxr-xr-x 2 root root    0 Jan  1 05:46 pci1
drwxr-xr-x 2 root root    0 Jan  1 05:46 pci2
drwxr-xr-x 2 root root    0 Jan  1 05:46 pci3
drwxr-xr-x 2 root root    0 Jan  1 05:46 pci4
-r--r--r-- 1 root root 4096 Jan  1 05:46 pci_nonparity_count
-r--r--r-- 1 root root 4096 Jan  1 05:46 pci_parity_count
root@localhost:/sys/devices/system/edac> cd /int
root@localhost:/int> rmmod amd8111_edac.ko 
EDAC PCI: Removed device 0 for amd8111_edac AMD8111_PCI_Controller: DEV 0000:00:05.0
EDAC MC: Removed device 0 for amd8111_edac lpc: DEV 0000:00:06.0
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        278        792   MPIC      Edge      serial
 18:          0          0   MPIC      Edge      [EDAC] AMD8131
 19:          0          0   MPIC      Edge      [EDAC] CPC925 
 22:       6484      25426   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       3047       2707   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> rmmod amd8131_edac.ko 
EDAC PCI: Removed device 4 for amd8131_edac AMD8131_PCIX_SOUTH_B: DEV 0000:00:04.0
EDAC PCI: Removed device 3 for amd8131_edac AMD8131_PCIX_SOUTH_A: DEV 0000:00:03.0
EDAC PCI: Removed device 2 for amd8131_edac AMD8131_PCIX_NORTH_B: DEV 0000:00:02.0
EDAC PCI: Removed device 1 for amd8131_edac AMD8131_PCIX_NORTH_A: DEV 0000:00:01.0
root@localhost:/int> rmmod cpc925_edac.ko 
EDAC MC: Removed device 1 for cpc925_edac cpu: DEV cpu.0
EDAC MC: Removed device 2 for cpc925_edac htlink: DEV htlink.0
EDAC MC: Removed device 0 for cpc925_edac cpc925_edac: DEV cpc925_edac.0
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        305        890   MPIC      Edge      serial
 22:       6659      25995   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       3107       2766   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> ls -lt /sys/devices/system/edac/
total 0
drwxr-xr-x 2 root root 0 Jan  1 05:46 mc
root@localhost:/int> dmesg -n 4
root@localhost:/int> insmod cpc925_edac.ko 
root@localhost:/int> insmod amd8131_edac.ko amd8131_op_state=1
root@localhost:/int> insmod amd8111_edac.ko amd8111_op_state=1
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        404       1163   MPIC      Edge      serial
 18:          0          0   MPIC      Edge      [EDAC] CPC925 
 19:          0          0   MPIC      Edge      [EDAC] AMD8131, [EDAC] AMD8111
 22:       6946      27069   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       3244       2877   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> rmmod amd8131_edac.ko 
root@localhost:/int> rmmod amd8111_edac.ko 
root@localhost:/int> rmmod cpc925_edac.ko 
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        456       1268   MPIC      Edge      serial
 22:       7097      27525   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       3318       2936   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> dmesg -n 8
root@localhost:/int> insmod amd8131_edac.ko 
AMD8131 EDAC driver  Ver: 1.0.0 May 12 2009
	(c) 2008 Wind River Systems, Inc.
EDAC PCI10: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_NORTH_A': DEV '0000:00:01.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 8, name AMD8131_PCIX_NORTH_A
EDAC PCI11: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_NORTH_B': DEV '0000:00:02.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 10, name AMD8131_PCIX_NORTH_B
EDAC PCI12: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_SOUTH_A': DEV '0000:00:03.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 18, name AMD8131_PCIX_SOUTH_A
EDAC PCI13: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_SOUTH_B': DEV '0000:00:04.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 20, name AMD8131_PCIX_SOUTH_B
root@localhost:/int> insmod amd8111_edac.ko 
AMD8111 EDAC driver  Ver: 1.0.0 May 12 2009
	(c) 2008 Wind River Systems, Inc.
amd8111_lpc_bridge_init: port 97 is buggy, not supported by hardware?
EDAC DEVICE8: Giving out device to module 'amd8111_edac' controller 'lpc': DEV '0000:00:06.0' (POLLED)
added one device on AMD8111 vendor 1022, device 7468, name lpc
EDAC PCI14: Giving out device to module 'amd8111_edac' controller 'AMD8111_PCI_Controller': DEV '0000:00:05.0' (POLLED)
added one device on AMD8111 vendor 1022, device 7460, name AMD8111_PCI_Controller
root@localhost:/int> cat /proc/interrupts 
           CPU0       CPU1       
 16:        480       1393   MPIC      Edge      serial
 22:       7130      27610   MPIC      Level     eth6
 25:          0          0   MPIC      Level     ohci_hcd:usb1, ohci_hcd:usb2
251:          0          0   MPIC      Edge      ipi call function
252:       3346       2964   MPIC      Edge      ipi reschedule
253:          0          0   MPIC      Edge      ipi call function single
254:          0          0   MPIC      Edge      ipi debugger
BAD:          0
root@localhost:/int> cd /sys/devices/system/edac/
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 Jan  1 05:48 lpc
drwxr-xr-x 7 root root 0 Jan  1 05:48 pci
drwxr-xr-x 2 root root 0 Jan  1 05:48 mc
root@localhost:/sys/devices/system/edac> cat lpc/poll_msec 
1000
root@localhost:/sys/devices/system/edac> ls -lt pci
total 0
-rw-r--r-- 1 root root 4096 Jan  1 05:48 check_pci_errors
-rw-r--r-- 1 root root 4096 Jan  1 05:48 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 Jan  1 05:48 edac_pci_log_pe
-rw-r--r-- 1 root root 4096 Jan  1 05:48 edac_pci_panic_on_pe
drwxr-xr-x 2 root root    0 Jan  1 05:48 pci10
drwxr-xr-x 2 root root    0 Jan  1 05:48 pci11
drwxr-xr-x 2 root root    0 Jan  1 05:48 pci12
drwxr-xr-x 2 root root    0 Jan  1 05:48 pci13
drwxr-xr-x 2 root root    0 Jan  1 05:48 pci14
-r--r--r-- 1 root root 4096 Jan  1 05:48 pci_nonparity_count
-r--r--r-- 1 root root 4096 Jan  1 05:48 pci_parity_count
root@localhost:/sys/devices/system/edac> cd /int
root@localhost:/int> rmmod amd8111_edac.ko 
EDAC PCI: Removed device 14 for amd8111_edac AMD8111_PCI_Controller: DEV 0000:00:05.0
EDAC MC: Removed device 8 for amd8111_edac lpc: DEV 0000:00:06.0
root@localhost:/int> rmmod amd8131_edac.ko 
EDAC PCI: Removed device 13 for amd8131_edac AMD8131_PCIX_SOUTH_B: DEV 0000:00:04.0
EDAC PCI: Removed device 12 for amd8131_edac AMD8131_PCIX_SOUTH_A: DEV 0000:00:03.0
EDAC PCI: Removed device 11 for amd8131_edac AMD8131_PCIX_NORTH_B: DEV 0000:00:02.0
EDAC PCI: Removed device 10 for amd8131_edac AMD8131_PCIX_NORTH_A: DEV 0000:00:01.0
root@localhost:/int> rmmod edac_core.ko 
root@localhost:/int> lsmod
Module                  Size  Used by
root@localhost:/int> 


diffstat:
---------
0001-EDAC-MPIC-Hypertransport-IRQ-support.patch
 drivers/edac/Makefile        |    4 +
 drivers/edac/edac_mpic_irq.c |  145 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/edac.h         |   23 ++++++
 3 files changed, 172 insertions(+)

0002-EDAC-MCE-INT-mode-support-for-CPC925-driver.patch
 arch/powerpc/kernel/traps.c |   16 ++
 drivers/edac/cpc925_edac.c  |  280 +++++++++++++++++++++++++++++++++++++++++---
 drivers/edac/edac_stub.c    |    6 
 include/linux/edac.h        |    6 
 4 files changed, 289 insertions(+), 19 deletions(-)

0003-EDAC-INT-mode-support-for-AMD8111-driver.patch
 amd8111_edac.c |  352 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 amd8111_edac.h |   43 ++++++
 2 files changed, 347 insertions(+), 48 deletions(-)

0004-EDAC-INT-mode-support-for-AMD8131-driver.patch
 amd8131_edac.c |  173 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 amd8131_edac.h |   20 ++++++
 2 files changed, 174 insertions(+), 19 deletions(-)
