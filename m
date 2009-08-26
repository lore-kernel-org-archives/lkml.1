Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZHZWeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZHZWeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZHZWeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:34:20 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:37773 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZHZWeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:34:19 -0400
Date: Thu, 27 Aug 2009 00:34:15 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Subject: ksoftirqd/0 using 100% of CPU0 (Intel Atom N270, 2.6.30 kernel)
Message-ID: <20090826223415.GA27242@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently bought a QNAP TS-439 Pro Turbo NAS which uses an Intel Atom 
N270 processor. Hardware specs are here:
http://www.qnap.com/pro_detail_hardware.asp?p_id=110

Installed Debian Lenny with a backported 2.6.30 kernel. The problem is 
that ksoftirq/0 takes up 100% of CPU core 0 as shown by top:

top - 00:05:03 up 19 min,  1 user,  load average: 1.00, 0.99, 0.76
Tasks:  68 total,   2 running,  66 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.0%us,  1.4%sy,  0.0%ni, 48.5%id,  0.9%wa,  0.0%hi, 48.3%si,
0.0%st
Mem:   1033612k total,   193684k used,   839928k free,    32932k buffers
Swap:        0k total,        0k used,        0k free,   129280k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
     4 root      15  -5     0    0    0 R  100  0.0  19:02.23 ksoftirqd/0
     1 root      20   0  2100  684  588 S    0  0.1   0:00.98 init
     2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd
     3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 migration/0
     5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 watchdog/0
     6 root      RT  -5     0    0    0 S    0  0.0   0:00.00 migration/1
     7 root      15  -5     0    0    0 S    0  0.0   0:00.00 ksoftirqd/1
     8 root      RT  -5     0    0    0 S    0  0.0   0:00.00 watchdog/1
     9 root      15  -5     0    0    0 S    0  0.0   0:00.00 events/0
    10 root      15  -5     0    0    0 S    0  0.0   0:00.02 events/1
    11 root      15  -5     0    0    0 S    0  0.0   0:00.00 cpuset
    12 root      15  -5     0    0    0 S    0  0.0   0:00.00 khelper
    15 root      15  -5     0    0    0 S    0  0.0   0:00.00 netns
    18 root      15  -5     0    0    0 S    0  0.0   0:00.00 async/mgr
    70 root      15  -5     0    0    0 S    0  0.0   0:00.00 kintegrityd/0
    71 root      15  -5     0    0    0 S    0  0.0   0:00.00 kintegrityd/1

powertop says that hrtimer_start_range_ns causes 98% of all wakeups 
(this is on a completely idle system save for one ssh session running 
powertop):

Top causes for wakeups:
   98.2% (500.5)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer)
    0.4% (  2.0)     <kernel core> : clocksource_register (clocksource_watchdog)
    0.3% (  1.6)       <interrupt> : uhci_hcd:usb4, sata_mv
    0.2% (  1.1)             ata/0 : schedule_timeout (process_timeout)
    0.2% (  1.1)     <kernel core> : schedule_delayed_work_on (delayed_work_timer_fn)
    0.2% (  1.0)             ata/0 : queue_delayed_work (delayed_work_timer_fn)
    0.1% (  0.6)       <interrupt> : eth0-rx-0
    0.1% (  0.5)          ifconfig : e1000_msix_other (e1000_watchdog)
    0.1% (  0.5)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer)
    0.0% (  0.2)          events/0 : __netdev_watchdog_up (dev_watchdog)
    0.0% (  0.2)              init : hrtimer_start_range_ns (hrtimer_wakeup)
    0.0% (  0.1)     <kernel core> : enqueue_task_rt (sched_rt_period_timer)
    0.0% (  0.1)       <interrupt> : eth0-tx-0

/proc/interrupts seems to suggest that IRQ0 and LOC cause the majority of
all interrupts:

minime:~# cat /proc/interrupts && sleep 10 && cat /proc/interrupts
             CPU0       CPU1
    0:     342350          0   IO-APIC-edge      timer
    1:          2          0   IO-APIC-edge      i8042
    8:         99          0   IO-APIC-edge      rtc0
    9:          0          0   IO-APIC-fasteoi   acpi
   12:          4          0   IO-APIC-edge      i8042
   14:        107          0   IO-APIC-edge      ide0
   16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
   18:      11453          0   IO-APIC-fasteoi   uhci_hcd:usb4, sata_mv
   19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
   23:          2          0   IO-APIC-fasteoi   ehci_hcd:usb1,
uhci_hcd:usb2
   27:       2282          0   PCI-MSI-edge      eth0-rx-0
   28:       1358          0   PCI-MSI-edge      eth0-tx-0
   29:          3          0   PCI-MSI-edge      eth0
   33:          0          0   PCI-MSI-edge      ahci
  NMI:          0          0   Non-maskable interrupts
  LOC:     347397     347853   Local timer interrupts
  SPU:          0          0   Spurious interrupts
  RES:        580      10698   Rescheduling interrupts
  CAL:         54        133   Function call interrupts
  TLB:         61        123   TLB shootdowns
  TRM:          0          0   Thermal event interrupts
  ERR:          0
  MIS:          0
             CPU0       CPU1
    0:     344852          0   IO-APIC-edge      timer
    1:          2          0   IO-APIC-edge      i8042
    8:         99          0   IO-APIC-edge      rtc0
    9:          0          0   IO-APIC-fasteoi   acpi
   12:          4          0   IO-APIC-edge      i8042
   14:        107          0   IO-APIC-edge      ide0
   16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
   18:      11453          0   IO-APIC-fasteoi   uhci_hcd:usb4, sata_mv
   19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
   23:          2          0   IO-APIC-fasteoi   ehci_hcd:usb1,
uhci_hcd:usb2
   27:       2289          0   PCI-MSI-edge      eth0-rx-0
   28:       1360          0   PCI-MSI-edge      eth0-tx-0
   29:          3          0   PCI-MSI-edge      eth0
   33:          0          0   PCI-MSI-edge      ahci
  NMI:          0          0   Non-maskable interrupts
  LOC:     349898     350356   Local timer interrupts
  SPU:          0          0   Spurious interrupts
  RES:        580      10708   Rescheduling interrupts
  CAL:         54        133   Function call interrupts
  TLB:         61        123   TLB shootdowns
  TRM:          0          0   Thermal event interrupts
  ERR:          0
  MIS:          0

(2502 interrupts during 10 seconds on CPU0 for IRQ0, about the same
for LOC on both CPU cores).

Clocksource seems to be a hpet:

minime:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
hpet

ksoftirq/0 seems to spend an awful lot of time in e1000_clean, I've 
tried doing "echo t > /proc/sysrq-trigger" about 20 times and the trace 
for ksoftirq/0 looks the same every time (not sure if its due to the 
fact that I'm doing the debugging over the network):

[ 1950.373290] ksoftirqd/0   R running      0     4      2
[ 1950.373299]  f6900380 00000040 00000000 f6900464 f808428c f808007b f6900380 00000000
[ 1950.373317]  f6900464 00000040 00000000 00000000 c028e98e c1807b18 c1807b2c 00064bb3
[ 1950.373334]  0000002c 00000246 c04149cc 0000000c 0000000c c012b0d7 00000004 00000000
[ 1950.373351] Call Trace:
[ 1950.373391]  [<f808428c>] ? e1000_clean+0x60/0x1f9 [e1000e]
[ 1950.373426]  [<f808007b>] ? e1000_get_drvinfo+0x85/0xaa [e1000e]
[ 1950.373439]  [<c028e98e>] ? net_rx_action+0x90/0x159
[ 1950.373451]  [<c012b0d7>] ? __do_softirq+0x8e/0x135
[ 1950.373462]  [<c012b1ac>] ? do_softirq+0x2e/0x38
[ 1950.373472]  [<c012b200>] ? ksoftirqd+0x4a/0xb3
[ 1950.373482]  [<c012b1b6>] ? ksoftirqd+0x0/0xb3
[ 1950.373491]  [<c0136704>] ? kthread+0x42/0x67
[ 1950.373501]  [<c01366c2>] ? kthread+0x0/0x67
[ 1950.373511]  [<c0103ab7>] ? kernel_thread_helper+0x7/0x10

The machine has two Intel 82574L network controllers, one in use and one 
down (and physically disconnected). Using the e1000e driver.

Not sure how to proceed in debugging this...google provided lots of hits 
for reports of ksoftirqd/0 at 100% cpu usage but all reports seem to be 
around the 2.6.26/27 era and none with 2.6.30.

Suggestions?

-- 
David Härdeman
