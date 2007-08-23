Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXHWJIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXHWJIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbXHWJIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:08:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46972 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbXHWJIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:08:35 -0400
Date: Thu, 23 Aug 2007 14:38:45 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
Message-ID: <20070823090845.GA13065@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 08:55:30PM +0400, Konstantin Baydarov wrote:
> Hi, I've faced problem:
> I have two x86_64 kernels with HPET enabled:
> kernel 1 - with PM enabled,
> kernel 2 - with PM disabled.
> When I execute kernel 2 from kernel 1 on pentiumd based PC, kernel 2 hangs
> during boot:
> root@192.168.40.10:~#
> root@192.168.40.10:~# ./kexec.sh ./ko_bzImage_x86_64_nopm
> + kexec -l ././ko_bzImage_x86_64_nopm '--command-line=kdb=on kdb=early
> apic=debug nmi_watchdog=0 console=ttyS0
> ,115200 ip=bootp root=/dev/nfs rw'
> + kexec -e
> md: stopping all md devices.
> sd 1:0:0:0: [sda] Synchronizing SCSI cache
> ACPI: PCI interrupt for device 0000:01:00.0 disabled
> Starting new kernel
> Linux version 2.6.23-rc2 (root@pentiumdcge.dev.rtsoft.ru) (gcc version 4.2.0
> (MontaVista 4.2.0-8.0.0.0703430 2
> 007-06-22)) #3 SMP PREEMPT Mon Aug 20 20:26:17 MSD 2007
> Command line: kdb=on kdb=early apic=debug nmi_watchdog=0 console=ttyS0,115200
> ip=bootp root=/dev/nfs rw
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000100 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000001f790000 (usable)
>  BIOS-e820: 000000001f790000 - 000000001f79e000 (ACPI data)
>  BIOS-e820: 000000001f79e000 - 000000001f7e0000 (ACPI NVS)
>  BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
>  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
> end_pfn_map = 1048576
> DMI 2.3 present.
> Zone PFN ranges:
>   DMA             1 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0:        1 ->      159
>     0:      256 ->   128912
> Intel MultiProcessor Specification v1.4
> MPTABLE: OEM ID: INTEL    MPTABLE: Product ID:  MPTABLE: APIC at: 0xFEE00000
> Processor #0 (Bootup-CPU)
> Processor #1
> I/O APIC #2 at 0xFEC00000.
> Setting APIC routing to flat
> Processors: 2
> mapped APIC to ffffffffff5fb000 (        fee00000)
> mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
> Allocating PCI resources starting at 20000000 (gap: 1f800000:e0380000)
> PERCPU: Allocating 31696 bytes of per cpu data
> Built 1 zonelists in Zone order.  Total pages: 125250
> Kernel command line: kdb=on kdb=early apic=debug nmi_watchdog=0
> console=ttyS0,115200 ip=bootp root=/dev/nfs rw
> Initializing CPU#0
> PID hash table entries: 2048 (order: 11, 16384 bytes)
> time.c: Detected 3000.006 MHz processor.
> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> Checking aperture...
> Memory: 500048k/515648k available (4577k kernel code, 15136k reserved, 1755k
> data, 280k init)
> -------------------------------- kernel hangs here --------------------------
> 
> Root case:
> When kernel 1 switches to Local APIC timer It disables HPET.
> When kernel 1 executes kernel 2, HPET isn't reenabled early during boot, because
> PM and ACPI is disabled and kernel 2 doesn't search for HPET in ACPI tables.
> HPET is disabled, so kernel enables PIT timer, but it doesn't work on pentiumd
> (don't know why).

Does your kernel 2 boot normally? I mean through BIOS and boot-loader?
This explanation seems to be suggesting that because PM and ACPI is disabled,
kernel 2 does not search for HPET. If this is the case, this kernel will
not boot even through normal boot-loader and will try to use PIT instead?

If so, it is not an kexec issue at all.

Thanks
Vivek
