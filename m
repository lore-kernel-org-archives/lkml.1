Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXEANam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXEANam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbXEANam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:30:42 -0400
Received: from netblock-66-245-252-131.dslextreme.com ([66.245.252.131]:36110
	"EHLO Angel.zoy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbXEANak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:30:40 -0400
X-Greylist: delayed 1404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 09:30:40 EDT
Date: Tue, 1 May 2007 06:07:15 -0700
From: Michel Lespinasse <walken@zoy.org>
To: linux-kernel@vger.kernel.org
Subject: 24 lost ticks with 2.6.20.10 kernel
Message-ID: <20070501130715.GB29131@zoy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry if this is known, I am not on the list.

I'm having an issue with lost ticks, runnign linux 2.6.20.10 on an
intel DQ965GF motherboard. For some reason this occurs with clock-like
regularity, always exactly 24 lost ticks, about every two seconds.
This is running with 250-HZ ticks, and the small pause every two seconds
is also noticeable when using the console.


running with report_lost_ticks, I see the following:

May  1 12:58:57 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 12:58:59 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 12:59:01 server kernel: time.c: Lost 25 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 12:59:03 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 12:59:07 server last message repeated 2 times
May  1 12:59:10 server kernel: time.c: Lost 24 timer tick(s)! rip handle_IRQ_event+0x19/0x55)
May  1 12:59:12 server kernel: time.c: Lost 24 timer tick(s)! rip handle_IRQ_event+0x19/0x55)
May  1 12:59:14 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 12:59:16 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 12:59:18 server kernel: time.c: Lost 24 timer tick(s)! rip handle_IRQ_event+0x19/0x55)
May  1 12:59:20 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 12:59:52 server last message repeated 15 times
May  1 13:00:51 server last message repeated 28 times
May  1 13:01:47 server last message repeated 27 times
May  1 13:01:50 server kernel: time.c: Lost 25 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
May  1 13:01:56 server last message repeated 3 times
May  1 13:01:58 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)


Since the rip often mentions _spin_unlock_irqrestore, I figured maybe
someone sleeps for 25 ticks with the interrupts disabled. I tried
running with CONFIG_DEBUG_SPINLOCK_SLEEP but this did not uncover anything.


I also noticed this code in arch/x86_64/kernel/time.c. I'm not sure if it
has anything to do with my issue, but it might since I get lost_count==24...
I could not figure out what this code is trying to do though.

#ifdef CONFIG_CPU_FREQ
        /* In some cases the CPU can change frequency without us noticing
           Give cpufreq a change to catch up. */
        if ((lost_count+1) % 25 == 0)
                cpufreq_delayed_get();
#endif


I'm not sure where to go from here. Additional information about my system:

/proc/cpuinfo:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      :               Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping        : 5
cpu MHz         : 3196.804
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl est tm2 cid cx16
 xtpr lahf_lm
bogomips        : 6400.03
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      :               Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping        : 5
cpu MHz         : 3196.804
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl est tm2 cid cx16
 xtpr lahf_lm
bogomips        : 6393.97
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:


/proc/ioports:

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vga+
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-0420 : ACPI PM2_CNT_BLK
  0428-042f : ACPI GPE0_BLK
0500-053f : 0000:00:1f.0
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus #02
  1000-100f : 0000:02:00.0
  1010-1017 : 0000:02:00.0
  1018-101f : 0000:02:00.0
  1020-1023 : 0000:02:00.0
  1024-1027 : 0000:02:00.0
2000-201f : 0000:00:1f.3
2020-203f : 0000:00:1f.2
  2020-203f : ahci
2040-205f : 0000:00:1d.2
  2040-205f : uhci_hcd
2060-207f : 0000:00:1d.1
  2060-207f : uhci_hcd
2080-209f : 0000:00:1d.0
  2080-209f : uhci_hcd
20a0-20bf : 0000:00:1a.1
  20a0-20bf : uhci_hcd
20c0-20df : 0000:00:1a.0
  20c0-20df : uhci_hcd
20e0-20ff : 0000:00:19.0
  20e0-20ff : e1000
2400-240f : 0000:00:03.2
2410-2417 : 0000:00:1f.2
  2410-2417 : ahci
2418-241f : 0000:00:1f.2
  2418-241f : ahci
2420-2427 : 0000:00:03.3
2428-242f : 0000:00:03.2
2430-2437 : 0000:00:03.2
2438-243f : 0000:00:02.0
2440-2443 : 0000:00:1f.2
  2440-2443 : ahci
2444-2447 : 0000:00:1f.2
  2444-2447 : ahci
2448-244b : 0000:00:03.2
244c-244f : 0000:00:03.2


/proc/iomem:

00000000-0008efff : System RAM
0008f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cd800-000ce7ff : Adapter ROM
000ce800-000cf7ff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3e583fff : System RAM
  00200000-003f7a3d : Kernel code
  003f7a3e-004cd18f : Kernel data
3e584000-3e590fff : reserved
3e591000-3e649fff : System RAM
3e64a000-3e6a3fff : ACPI Non-volatile Storage
3e6a4000-3e6a8fff : ACPI Tables
3e6a9000-3e6f1fff : ACPI Non-volatile Storage
3e6f2000-3e6fefff : ACPI Tables
3e6ff000-3e6fffff : System RAM
3e700000-3effffff : reserved
40000000-4fffffff : 0000:00:02.0
50000000-500fffff : PCI Bus #02
  50000000-500001ff : 0000:02:00.0
50100000-501fffff : 0000:00:02.0
50200000-5021ffff : 0000:00:19.0
  50200000-5021ffff : e1000
50220000-50220fff : 0000:00:19.0
  50220000-50220fff : e1000
50221000-50221fff : 0000:00:03.3
50222000-502227ff : 0000:00:1f.2
  50222000-502227ff : ahci
50222800-50222bff : 0000:00:1d.7
  50222800-50222bff : ehci_hcd
50222c00-50222fff : 0000:00:1a.7
  50222c00-50222fff : ehci_hcd
50223000-502230ff : 0000:00:1f.3
50223100-5022310f : 0000:00:03.0
50300000-503fffff : PCI Bus #01
50400000-504fffff : PCI Bus #03
50500000-505fffff : PCI Bus #04
50600000-506fffff : PCI Bus #05
fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 0
fee00000-fee00fff : Local APIC
ffe00000-ffffffff : reserved


lspci:

00:00.0 Host bridge: Intel Corporation Q963/Q965 Memory Controller Hub (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Q963/Q965 Integrated Graphics Controller (rev 02)
00:03.0 Communication controller: Intel Corporation Q963/Q965 HECI Controller (rev 02)
00:03.2 IDE interface: Intel Corporation Q963/Q965 PT IDER Controller (rev 02)
00:03.3 Serial controller: Intel Corporation Q963/Q965 KT Controller (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DM Gigabit Network Connection (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #2 (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HO (ICH8DO) LPC Interface Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801HB (ICH8) SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
02:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device 6101 (rev b1)


/proc/interrupts:

           CPU0       CPU1       
  0:      68826          0   IO-APIC-edge      timer
  1:         30          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          3          0   IO-APIC-edge      i8042
 16:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 18:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6
 21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
313:       2356          0   PCI-MSI-edge      eth0
314:       2002          0   PCI-MSI-edge      libata
NMI:         81         60 
LOC:      68792      71817 
ERR:          0


One last thing: I have another box which is fairly similar, with a
DG965RY motherboard. That other box does *not* seem to lose any ticks,
running the same kernel that works so poorly on the DQ965GF board.
Does that point to a hardware/bios issue then ?????


Please help. I dont mind trying things, but I really dont know what to
try at this point...


-- 
Michel "Walken" Lespinasse
"Bill Gates is a monocle and a Persian cat away from being the villain
in a James Bond movie." -- Dennis Miller
