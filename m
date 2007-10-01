Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbXJAPz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbXJAPz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXJAPzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:55:49 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57289
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXJAPzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:55:48 -0400
Date: Mon, 1 Oct 2007 08:57:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: OOM killer invoked on 2.6.20.3, need help understanding why
Message-ID: <Pine.LNX.4.64.0710010810170.20712@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a dual dual-core Opteron box running a 32 bit 2.6.20.3 kernel with 
4G himem (16G in the box) serving as a iptables firewall. I's got E1000 
network cards and a LSI raid controller.

this morning it died with the message 'kernel panic, out of memory and no 
process to kill'

gong back through it's syslogs I've got quite a few logs, but I need help 
in understanding what went wrong (and if it's preventable)

the process that was running and triggered the OOM is a script

#!/bin/bash

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

while :
do
   logger -t maxconns `cat /proc/sys/net/ipv4/netfilter/ip_conntrack_count`
   logger -t afdslog `cat /proc/sys/fs/file-nr |awk '{print $1}'`

   sleep 5
done

since the box is a dedicated firewall there is very little running on it 
(a few other monitoring scripts like this)

the conntrack count that was being reported was relativly low (around 
34k, the max is set at 1m)

if I'm reading the logs correctly it looks like it ran out of lowmem, but 
had a lot of himem still available. but I don't know what would have eaten 
up the lowmem.

now the logs and other info

Oct  1 06:01:04 g1a-c maxconns: 34317
Oct  1 06:01:05 g1a-c kernel: printk: 1887 messages suppressed.
Oct  1 06:01:05 g1a-c kernel: maxconns invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Oct  1 06:01:05 g1a-c kernel:  [<c0147850>] out_of_memory+0x100/0x130
Oct  1 06:01:05 g1a-c kernel:  [<c0148b2b>] __alloc_pages+0x22b/0x2d0
Oct  1 06:01:05 g1a-c kernel:  [<c01135b1>] pte_alloc_one+0x11/0x20
Oct  1 06:01:05 g1a-c kernel:  [<c014feaa>] __pte_alloc+0x1a/0xb0
Oct  1 06:01:05 g1a-c kernel:  [<c0150369>] copy_pte_range+0x289/0x2b0
Oct  1 06:01:05 g1a-c kernel:  [<c01504b9>] copy_page_range+0x129/0x170
Oct  1 06:01:05 g1a-c kernel:  [<c011e024>] dup_mm+0x214/0x2e0
Oct  1 06:01:05 g1a-c kernel:  [<c011e179>] copy_mm+0x89/0xa0
Oct  1 06:01:05 g1a-c kernel:  [<c011e91a>] copy_process+0x33a/0xc60
Oct  1 06:01:05 g1a-c kernel:  [<c011f2a5>] do_fork+0x65/0x1f0
Oct  1 06:01:05 g1a-c kernel:  [<c027e2c2>] copy_to_user+0x32/0x50
Oct  1 06:01:05 g1a-c kernel:  [<c0101722>] sys_clone+0x32/0x40
Oct  1 06:01:05 g1a-c kernel:  [<c0102a8e>] syscall_call+0x7/0xb
Oct  1 06:01:05 g1a-c kernel:  =======================
Oct  1 06:01:05 g1a-c kernel: Mem-info:
Oct  1 06:01:05 g1a-c kernel: DMA per-cpu:
Oct  1 06:01:05 g1a-c kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Oct  1 06:01:05 g1a-c kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Oct  1 06:01:05 g1a-c kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Oct  1 06:01:05 g1a-c kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Oct  1 06:01:05 g1a-c kernel: Normal per-cpu:
Oct  1 06:01:05 g1a-c kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  58
Oct  1 06:01:05 g1a-c kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  52
Oct  1 06:01:05 g1a-c kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  58
Oct  1 06:01:05 g1a-c kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:   62, btch:  15 usd:  60
Oct  1 06:01:05 g1a-c kernel: HighMem per-cpu:
Oct  1 06:01:05 g1a-c kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:   8
Oct  1 06:01:05 g1a-c kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:   3
Oct  1 06:01:05 g1a-c kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:   0
Oct  1 06:01:05 g1a-c kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:   0
Oct  1 06:01:05 g1a-c kernel: Active:3496 inactive:616 dirty:16 writeback:0 unstable:0
Oct  1 06:01:05 g1a-c kernel:  free:3941515 slab:6779 mapped:843 pagetables:48 bounce:0
Oct  1 06:01:05 g1a-c kernel: DMA free:3548kB min:68kB low:84kB high:100kB active:16kB inactive:0kB present:16256kB pages_scanned:56 all_unreclaimable? yes
Oct  1 06:01:05 g1a-c kernel: lowmem_reserve[]: 0 873 16240
Oct  1 06:01:05 g1a-c kernel: Normal free:3640kB min:3744kB low:4680kB high:5616kB active:148kB inactive:0kB present:894080kB pages_scanned:7196 all_unreclaimable? yes
Oct  1 06:01:05 g1a-c kernel: lowmem_reserve[]: 0 0 122936
Oct  1 06:01:05 g1a-c kernel: HighMem free:15758872kB min:512kB low:17000kB high:33492kB active:13820kB inactive:2464kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Oct  1 06:01:05 g1a-c kernel: lowmem_reserve[]: 0 0 0
Oct  1 06:01:05 g1a-c kernel: DMA: 3*4kB 2*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3532kB
Oct  1 06:01:05 g1a-c kernel: Normal: 0*4kB 23*8kB 6*16kB 1*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3640kB
Oct  1 06:01:05 g1a-c kernel: HighMem: 122*4kB 658*8kB 622*16kB 464*32kB 391*64kB 336*128kB 277*256kB 226*512kB 169*1024kB 135*2048kB 3668*4096kB = 15758872kB
Oct  1 06:01:05 g1a-c kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Oct  1 06:01:05 g1a-c kernel: Free swap  = 2048276kB
Oct  1 06:01:05 g1a-c kernel: Total swap = 2048276kB
Oct  1 06:01:05 g1a-c kernel: Free swap:       2048276kB
Oct  1 06:01:05 g1a-c kernel: cat invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
Oct  1 06:01:05 g1a-c kernel:  [<c0147850>] out_of_memory+0x100/0x130
Oct  1 06:01:05 g1a-c kernel:  [<c0148b2b>] __alloc_pages+0x22b/0x2d0
Oct  1 06:01:05 g1a-c kernel:  [<c01135b1>] pte_alloc_one+0x11/0x20
Oct  1 06:01:05 g1a-c kernel:  [<c014feaa>] __pte_alloc+0x1a/0xb0
Oct  1 06:01:05 g1a-c kernel:  [<c0154016>] __vma_link+0x36/0x70
Oct  1 06:01:05 g1a-c kernel:  [<c01512e7>] get_locked_pte+0xa7/0xd0
Oct  1 06:01:05 g1a-c kernel:  [<c0166ef3>] install_arg_page+0x33/0xe0
Oct  1 06:01:05 g1a-c kernel:  [<c01670f7>] setup_arg_pages+0x157/0x1b0
Oct  1 06:01:05 g1a-c kernel:  [<c018eda4>] load_elf_binary+0x434/0xd30
Oct  1 06:01:05 g1a-c kernel:  [<c014f360>] page_address+0xb0/0xc0
Oct  1 06:01:05 g1a-c kernel:  [<c014f04a>] kmap_high+0x1a/0x1c0
Oct  1 06:01:05 g1a-c kernel:  [<c014f360>] page_address+0xb0/0xc0
Oct  1 06:01:05 g1a-c kernel:  [<c0166e37>] copy_strings+0x1c7/0x210
Oct  1 06:01:05 g1a-c kernel:  [<c0167de4>] search_binary_handler+0x54/0x100
Oct  1 06:01:05 g1a-c kernel:  [<c0167fc8>] do_execve+0x138/0x1b0
Oct  1 06:01:05 g1a-c kernel:  [<c0101795>] sys_execve+0x35/0x90
Oct  1 06:01:05 g1a-c kernel:  [<c0102a8e>] syscall_call+0x7/0xb
Oct  1 06:01:05 g1a-c kernel:  =======================


processes running under normal conditions
  ps ax |grep -v "\["
   PID TTY      STAT   TIME COMMAND
  1587 ?        Ss     0:00 /sbin/syslogd
  1590 ?        Ss     0:00 /sbin/klogd
  1723 ?        Ss     0:00 /usr/sbin/inetd
  1733 ?        Ss     0:00 /usr/sbin/sshd
  1811 ?        Ss     0:00 sendmail: MTA: accepting connections
  1826 ?        SLs    0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid
  1836 ?        S      0:00 /usr/sbin/ntpd -p /var/run/ntpd.pid
  1889 ?        SLs    0:00 heartbeat: heartbeat: master control process
  1893 ?        Ss     0:00 /usr/sbin/atd
  1896 ?        Ss     0:00 /usr/sbin/cron
  1898 ?        S      0:00 /bin/bash /usr/local/bin/maxconns
  1916 ?        S      0:00 /usr/bin/perl /usr/nagios/sch/garbage_collection.pl
  1917 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_disk_usage_root
  1918 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_disk_usage_var
  1919 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_cpu_idle
  1920 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_load
  1921 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_descriptors
  1922 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_processes
  1923 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_concurrent_connections
  1924 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_log_sizes
  1925 ?        S      0:00 /bin/bash /usr/nagios/sch/controls/control_mqueue
  2023 ?        SL     0:00 heartbeat: heartbeat: FIFO reader
  2024 ?        SL     0:00 heartbeat: heartbeat: write: bcast eth13
  2025 ?        SL     0:00 heartbeat: heartbeat: read: bcast eth13
  2026 ?        SL     0:00 heartbeat: heartbeat: write: bcast eth14
  2027 ?        SL     0:00 heartbeat: heartbeat: read: bcast eth14
  2064 tty2     Ss+    0:00 /sbin/getty 38400 tty2
  2065 tty3     Ss+    0:00 /sbin/getty 38400 tty3
  2066 tty4     Ss+    0:00 /sbin/getty 38400 tty4
  2067 tty5     Ss+    0:00 /sbin/getty 38400 tty5
  2068 tty6     Ss+    0:00 /sbin/getty 38400 tty6
  2069 ttyS0    Ss+    0:00 /sbin/getty -L ttyS0 38400 vt100
  2070 ttyS1    Ss+    0:00 /sbin/getty -L ttyS1 9600 vt100
  2071 tty7     Ss+    0:01 /usr/bin/top -s
  2672 tty1     Ss+    0:00 /sbin/getty 38400 tty1
10896 ?        S      0:00 /usr/local/etc/tn-gw
11075 ?        S      0:00 in.telnetd: localhost.localdomain
11076 pts/0    Ss     0:00 -bash
11102 pts/0    S      0:00 bash
14981 ?        S      0:00 sleep 30
15033 ?        S      0:00 sleep 30
15035 ?        S      0:00 sleep 30
15049 ?        S      0:00 sleep 30
15053 ?        S      0:00 sleep 30
15086 ?        S      0:00 sleep 30
15087 ?        S      0:00 sleep 30
15109 ?        S      0:00 sleep 30
15116 ?        S      0:00 sleep 30
15123 ?        S      0:00 sleep 5
15124 pts/0    R+     0:00 ps ax

lspci
0000:00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
0000:00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
0000:00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
0000:00:07.2 SMBus: Advanced Micro Devices [AMD] AMD-8111 SMBus 2.0 (rev 02)
0000:00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
0000:00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13)
0000:00:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X APIC (rev 01)
0000:00:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13)
0000:00:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X APIC (rev 01)
0000:00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 NorthBridge
0000:01:01.0 PCI bridge: Pericom Semiconductor: Unknown device 01a7 (rev 01)
0000:01:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
0000:02:04.0 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:02:04.1 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:02:06.0 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:02:06.1 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:03:02.0 PCI bridge: Pericom Semiconductor: Unknown device 01a7 (rev 01)
0000:03:03.0 PCI bridge: Pericom Semiconductor: Unknown device 01a7 (rev 01)
0000:03:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
0000:03:09.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
0000:04:04.0 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:04:04.1 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:04:06.0 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:04:06.1 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:05:04.0 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:05:04.1 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:05:06.0 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:05:06.1 Ethernet controller: Intel Corp.: Unknown device 10b5 (rev 03)
0000:06:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
0000:06:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
0000:06:06.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
0000:06:08.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 10)

David Lang
