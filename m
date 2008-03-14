Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbYCNVGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbYCNVGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYCNVGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:06:43 -0400
Received: from smtp7-g19.free.fr ([212.27.42.64]:35072 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649AbYCNVGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:06:40 -0400
X-Greylist: delayed 82745 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 17:06:39 EDT
Message-ID: <47DAE8DB.4040606@free.fr>
Date: Fri, 14 Mar 2008 22:06:35 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       roland@redhat.com, mingo@elte.hu, xemul@openvz.org
Subject: Re: 2.6.25-rc5-mm1: "consolechars" hangs on boot
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D9A5A2.4000009@free.fr> <20080313153851.2023980c.akpm@linux-foundation.org> <20080314052606.GA226@tv-sign.ru>
In-Reply-To: <20080314052606.GA226@tv-sign.ru>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060609050309070801040503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060609050309070801040503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Le 14.03.2008 06:26, Oleg Nesterov a écrit :
> On 03/13, Andrew Morton wrote:
>> On Thu, 13 Mar 2008 23:07:30 +0100
>> Laurent Riffard <laurent.riffard@free.fr> wrote:
>>
>>> Le 11.03.2008 09:14, Andrew Morton a __crit :
>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
>>>>
>>> With 2.6.25-rc5-mm1, my system (Ubuntu 7.10/Gutsy) reliably hangs on
>>> boot. Sysrq-T shows 12 "consolechars" processes stuck in do_exit call.
>>>
>>> The bisection said "Sucker is
>>> patches/signals-send_signal-factor-out-signal_group_exit-checks.patch"
>>>
>>> Actually, it's 2.6.25-rc5-mm1 + add-warn_on_secs-macro-fix-fix.patch,
>>> I guess this patch is innocent.
> 
> Laurent, thanks a lot!
> 
> What was the state of consolechars? Where exactly did it hang? do_exit+??

(hand-copied data)
=================
consolechars ? de8925bc  3432 2795 1
 .
 .
 .
Call Trace:
	do_exit+0x5dd/0x5e1
	do_group_exit+0x5e/0x86
	sys_exit_group+0xf/0x11
	sysenter_past_esp+0x5f/0xa5
=================

On first line, last number is always "1" for each of the 12 consolechars.
The call trace is always the same for each of the 12 consolechars.

>> Actually I later dropped
>> signals-send_signal-factor-out-signal_group_exit-checks.patch at Oleg's
>> request.
>>
>> But I don't think we did that because it was known to be buggy, so perhaps
>> the same bug crept back in in another form..
> 
> Yes, currently I suspect we have another bug.
> 
> And. While doing this patch I forgot we should fix the bugs with init first!
> (will try to make the patch soon).
> 
> Laurent, any chance you can try 2.6.25-rc5-mm1 + the patch below?
> Unlikely it can help, but would be great to be sure.

Yes it does help ! Thanks.

Despite a big ERR in dmesg, the system now runs fine.

[   26.536458] ReiserFS: sda7: Using r5 hash to sort names
[   26.780261] ERR!! init is killed by 10
[   26.781486] ------------[ cut here ]------------
[   26.781492] WARNING: at kernel/signal.c:724 complete_signal+0x163/0x1eb()
[   26.781497] Modules linked in: nls_iso8859_1 nls_cp850 vfat fat reiserfs eeprom w83781d hwmon_vid ipv6 snd_ens1371 firewire_ohci firewire_core gameport crc_itu_t snd_ac97_codec 8250_pnp ac97_bus snd_pcm_oss snd_mixer_oss 8250 serial_core snd_pcm snd_seq_oss floppy snd_seq_midi snd_rawmidi rtc snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr snd uhci_hcd sr_mod cdrom soundcore snd_page_alloc ohci1394 sg via686a ne2k_pci 8390 ieee1394 i2c_viapro usbcore ata_generic parport_pc parport via_agp agpgart evdev dm_snapshot reiser4 lzo_decompress lzo_compress sd_mod pata_via libata scsi_mod dm_mirror dm_log dm_mod
[   26.781609] Pid: 2590, comm: sh Not tainted 2.6.25-rc5-mm1 #18
[   26.781619]  [<c01188bd>] warn_on_slowpath+0x41/0x6d
[   26.781640]  [<c0119200>] ? vprintk+0x289/0x3b6
[   26.781650]  [<c01cc3a8>] ? number+0x10d/0x1cd
[   26.781671]  [<c0158db9>] ? cache_free_debugcheck+0x1e1/0x1ec
[   26.781699]  [<c0119342>] ? printk+0x15/0x17
[   26.781709]  [<c0120fa9>] complete_signal+0x163/0x1eb
[   26.781719]  [<c01211d4>] send_signal+0x1a3/0x1cf
[   26.781729]  [<c0121216>] __group_send_sig_info+0xa/0xc
[   26.781737]  [<c01217cc>] group_send_sig_info+0x44/0x62
[   26.781747]  [<c0121de4>] kill_pid_info+0x33/0x47
[   26.781757]  [<c0122443>] sys_kill+0x73/0x145
[   26.781767]  [<c014c655>] ? handle_mm_fault+0x21d/0x4f6
[   26.781791]  [<c012af3c>] ? up_read+0x16/0x2a
[   26.781803]  [<c011214c>] ? do_page_fault+0x25a/0x4da
[   26.781815]  [<c0103906>] sysenter_past_esp+0x5f/0xa5
[   26.781834]  =======================
[   26.781838] ---[ end trace c053f6e3c5b0fb23 ]---
[   26.827206] Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k

(full dmesg attached)

> Oleg.
> 
> --- MM/kernel/signal.c~	2008-03-14 08:08:07.000000000 +0300
> +++ MM/kernel/signal.c	2008-03-14 08:08:17.000000000 +0300
> @@ -719,6 +719,10 @@ static void complete_signal(int sig, str
>  		/*
>  		 * This signal will be fatal to the whole group.
>  		 */
> +if (is_global_init(p)) {
> +	printk(KERN_CRIT "ERR!! init is killed by %d\n", sig);
> +	WARN_ON_ONCE(1);
> +} else
>  		if (!sig_kernel_coredump(sig)) {
>  			/*
>  			 * Start a group exit and wake everybody up.
> 

--------------060609050309070801040503
Content-Type: text/plain;
 name="dmesg-2.6.25-rc5-mm1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-2.6.25-rc5-mm1"

[    0.000000] Linux version 2.6.25-rc5-mm1 (laurent@calimero) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #18 PREEMPT Fri Mar 14 21:41:35 CET 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
[    0.000000]  BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
[    0.000000]  BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] 511MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Entering add_active_range(0, 0, 131052) 0 entries of 256 used
[    0.000000] sizeof(struct page) = 32
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   131052
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   131052
[    0.000000] On node 0 totalpages: 131052
[    0.000000] Node 0 memmap at 0xc1000000 size 4194304 first pfn 0xc1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 991 pages used for memmap
[    0.000000]   Normal zone: 125965 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F6A80, 0014 (r0 ASUS  )
[    0.000000] ACPI: RSDT 1FFEC000, 002C (r1 ASUS   A7V133-C 30303031 MSFT 31313031)
[    0.000000] ACPI: FACP 1FFEC080, 0074 (r1 ASUS   A7V133-C 30303031 MSFT 31313031)
[    0.000000] ACPI: DSDT 1FFEC100, 2CE1 (r1   ASUS A7V133-C     1000 MSFT  100000B)
[    0.000000] ACPI: FACS 1FFFF000, 0040
[    0.000000] ACPI: BOOT 1FFEC040, 0028 (r1 ASUS   A7V133-C 30303031 MSFT 31313031)
[    0.000000] ACPI: PM-Timer IO Port: 0xe408
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130029
[    0.000000] Kernel command line: root=/dev/mapper/vglinux1-lv_ubuntu2 ro locale=fr_FR video=radeonfb:1280x1024@60 resume=/dev/mapper/vglinux1-lvswap
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] mapped APIC to ffffb000 (01406000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=c03c4000 soft=c03c3000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1410.227 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        2048
[    0.004000] ... CLASSHASH_SIZE:           1024
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 992 kB
[    0.004000]  per task-struct memory footprint: 1920 bytes
[    0.004000] ------------------------
[    0.004000] | Locking API testsuite:
[    0.004000] ----------------------------------------------------------------------------
[    0.004000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.004000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.004000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.004000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.004000]   --------------------------------------------------------------------------
[    0.004000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.004000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.004000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.004000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.004000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.004000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.004000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.004000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.004000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.004000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.004000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.004000]       hard-irq read-recursion/123:  ok  |
[    0.004000]       soft-irq read-recursion/123:  ok  |
[    0.004000]       hard-irq read-recursion/132:  ok  |
[    0.004000]       soft-irq read-recursion/132:  ok  |
[    0.004000]       hard-irq read-recursion/213:  ok  |
[    0.004000]       soft-irq read-recursion/213:  ok  |
[    0.004000]       hard-irq read-recursion/231:  ok  |
[    0.004000]       soft-irq read-recursion/231:  ok  |
[    0.004000]       hard-irq read-recursion/312:  ok  |
[    0.004000]       soft-irq read-recursion/312:  ok  |
[    0.004000]       hard-irq read-recursion/321:  ok  |
[    0.004000]       soft-irq read-recursion/321:  ok  |
[    0.004000] -------------------------------------------------------
[    0.004000] Good, all 218 testcases passed! |
[    0.004000] ---------------------------------
[    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.004000] Memory: 510720k/524208k available (1723k kernel code, 12920k reserved, 895k data, 192k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[    0.004000]     vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
[    0.004000]       .init : 0xc0390000 - 0xc03c0000   ( 192 kB)
[    0.004000]       .data : 0xc02aee60 - 0xc038eca0   ( 895 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02aee60   (1723 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084010] Calibrating delay using timer specific routine.. 2824.51 BogoMIPS (lpj=5649035)
[    0.084406] Mount-cache hash table entries: 512
[    0.085740] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.085808] CPU: L2 Cache: 256K (64 bytes/line)
[    0.085867] Intel machine check architecture supported.
[    0.085927] Intel machine check reporting enabled on CPU#0.
[    0.085993] Compat vDSO mapped to ffffe000.
[    0.086056] CPU: AMD Athlon(TM) XP 1600+ stepping 02
[    0.086189] Checking 'hlt' instruction... OK.
[    0.100255] Freeing SMP alternatives: 0k freed
[    0.100313] ACPI: Core revision 20070126
[    0.100435] INFO: trying to register non-static key.
[    0.100494] the code is fine but needs lockdep annotation.
[    0.100554] turning off the locking correctness validator.
[    0.100616] Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1 #18
[    0.100680]  [<c0132021>] __lock_acquire+0x13d/0xac0
[    0.100783]  [<c01d9c47>] ? __spin_lock_init+0x27/0x51
[    0.100920]  [<c0158b5c>] ? cache_alloc_debugcheck_after+0xe9/0x165
[    0.101061]  [<c0159e1b>] ? kmem_cache_alloc+0x81/0xcf
[    0.101537]  [<c0132d04>] lock_acquire+0x4c/0x67
[    0.101631]  [<c012b378>] ? down_trylock+0xc/0x27
[    0.101764]  [<c02adc7f>] _spin_lock_irqsave+0x2c/0x3c
[    0.101866]  [<c012b378>] ? down_trylock+0xc/0x27
[    0.101995]  [<c012b378>] down_trylock+0xc/0x27
[    0.102089]  [<c01fdd69>] acpi_os_wait_semaphore+0x70/0x14b
[    0.102190]  [<c0218b0f>] acpi_ut_acquire_mutex+0x64/0xd1
[    0.102292]  [<c020e7f9>] acpi_ns_root_initialize+0x1a/0x279
[    0.102393]  [<c0218aa4>] ? acpi_ut_mutex_initialize+0x75/0x7c
[    0.102527]  [<c03a3dea>] acpi_initialize_subsystem+0x47/0x6a
[    0.102625]  [<c03a4079>] acpi_early_init+0x57/0xf8
[    0.102719]  [<c03909a4>] start_kernel+0x254/0x25e
[    0.102816]  [<c039029d>] i386_start_kernel+0x8/0xa
[    0.102916]  =======================
[    0.112671] Parsing all Control Methods:
[    0.112976] Table [DSDT](id 0001) - 356 Objects with 38 Devices 115 Methods 24 Regions
[    0.113092]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.113243] ACPI: setting ELCR to 0200 (from 0820)
[    0.113399] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[    0.114291] khelper used greatest stack depth: 3252 bytes left
[    0.114739] net_namespace: 300 bytes
[    0.115389] NET: Registered protocol family 16
[    0.116689] ACPI: bus type pci registered
[    0.116912] khelper used greatest stack depth: 3156 bytes left
[    0.119498] PCI: PCI BIOS revision 2.10 entry at 0xf1180, last bus=1
[    0.119562] PCI: Using configuration type 1
[    0.119618] Setting up standard PCI resources
[    0.129006] khelper used greatest stack depth: 3124 bytes left
[    0.133951] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0x9
[    0.136703] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 4 Wake, Enabled 0 Runtime GPEs in this block
[    0.136863] ACPI: EC: Look up EC in DSDT
[    0.141645] Completing Region/Field/Buffer/Package initialization:................................................
[    0.149429] Initialized 16/24 Regions 2/2 Fields 19/19 Buffers 11/14 Packages (365 nodes)
[    0.149545] Initializing Device/Processor/Thermal objects by executing _INI methods:
[    0.149647] Executed 0 _INI methods requiring 0 _STA executions (examined 41 objects)
[    0.149840] ACPI: Interpreter enabled
[    0.149895] ACPI: (supports S0 S1 S3 S4 S5)
[    0.150200] ACPI: Using PIC for interrupt routing
[    0.176842] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.177611] pci 0000:00:04.4: quirk: region e200-e27f claimed by vt82c686 HW-mon
[    0.177688] pci 0000:00:04.4: quirk: region e800-e80f claimed by vt82c686 SMB
[    0.178189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.322052] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.322837] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.323679] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.324579] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.325666] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.325911] pnp: PnP ACPI init
[    0.326004] ACPI: bus type pnp registered
[    0.335951] pnp: PnP ACPI: found 14 devices
[    0.336031] ACPI: ACPI bus type pnp unregistered
[    0.337705] PCI: Using ACPI for IRQ routing
[    0.356375] Time: tsc clocksource has been installed.
[    0.380461] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.380461] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.380461] system 00:00: iomem range 0x100000-0x1fffffff could not be reserved
[    0.380461] system 00:00: iomem range 0xfffe0000-0xffffffff could not be reserved
[    0.380461] system 00:02: ioport range 0x3f0-0x3f1 has been reserved
[    0.380461] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.380461] system 00:03: ioport range 0xe400-0xe47f has been reserved
[    0.380461] system 00:03: ioport range 0xe800-0xe80f has been reserved
[    0.409540] PCI: Bridge: 0000:00:01.0
[    0.409600]   IO window: d000-dfff
[    0.409658]   MEM window: 0xb7000000-0xb7ffffff
[    0.409718]   PREFETCH window: 0x00000000b8000000-0x00000000cfffffff
[    0.409806] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.409950] NET: Registered protocol family 2
[    0.484570] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.484570] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.484570] TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
[    0.484570] TCP: Hash tables configured (established 16384 bind 16384)
[    0.484570] TCP reno registered
[    0.508580] checking if image is initramfs... it is
[    0.912640] Switched to NOHz mode on CPU #0
[    1.010956] Freeing initrd memory: 3283k freed
[    1.011609] Simple Boot Flag at 0x3a set to 0x1
[    1.014941] msgmni has been set to 1004 for ipc namespace c0379000
[    1.015151] io scheduler noop registered
[    1.015208] io scheduler anticipatory registered
[    1.015266] io scheduler deadline registered
[    1.015343] io scheduler cfq registered (default)
[    1.015421] pci 0000:00:00.0: Applying VIA southbridge workaround
[    1.015488] PCI: VIA PCI bridge detected. Disabling DAC.
[    1.015552] pci 0000:00:04.0: Disabling VIA external APIC routing
[    1.015666] pci 0000:01:00.0: Boot video device
[    1.017331] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    1.017396] PCI: setting IRQ 11 as level-triggered
[    1.017458] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[    1.018346] radeonfb: Found Intel x86 BIOS ROM Image
[    1.018410] radeonfb: Retrieved PLL infos from BIOS
[    1.018469] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=250.00 Mhz, System=166.00 MHz
[    1.018544] radeonfb: PLL min 20000 max 40000
[    1.177376] i2c-adapter i2c-1: unable to read EDID block.
[    1.394439] i2c-adapter i2c-1: unable to read EDID block.
[    1.634350] i2c-adapter i2c-1: unable to read EDID block.
[    1.874262] i2c-adapter i2c-3: unable to read EDID block.
[    2.102195] i2c-adapter i2c-3: unable to read EDID block.
[    2.342091] i2c-adapter i2c-3: unable to read EDID block.
[    2.684899] radeonfb: Monitor 1 type CRT found
[    2.684910] radeonfb: EDID probed
[    2.684963] radeonfb: Monitor 2 type no found
[    2.747641] Console: switching to colour frame buffer device 160x64
[    2.786206] radeonfb (0000:01:00.0): ATI Radeon 5961 "Ya"
[    2.787714] input: Power Button (FF) as /class/input/input0
[    2.788009] ACPI: Power Button (FF) [PWRF]
[    2.788579] input: Power Button (CM) as /class/input/input1
[    2.788876] ACPI: Power Button (CM) [PWRB]
[    2.789965] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    2.790514] ACPI: ACPI0007:00 is registered as cooling_device0
[    2.790825] ACPI: Processor [CPU0] (supports 16 throttling states)
[    2.799218] khelper used greatest stack depth: 3116 bytes left
[    2.847070] Marking TSC unstable due to: possible TSC halt in C2.
[    2.851055] Time: acpi_pm clocksource has been installed.
[    2.859787] brd: module loaded
[    2.860437] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.861580] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.861852] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.862813] mice: PS/2 mouse device common for all mice
[    2.884324] input: AT Translated Set 2 keyboard as /class/input/input2
[    2.912025] TCP cubic registered
[    2.912237] NET: Registered protocol family 1
[    2.912507] Using IPI Shortcut mode
[    2.913688] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    2.915592] Freeing unused kernel memory: 192k freed
[    2.915896] Write protecting the kernel text: 1724k
[    2.916164] Write protecting the kernel read-only data: 736k
[    2.918840] busybox used greatest stack depth: 2908 bytes left
[    2.933385] exe used greatest stack depth: 2896 bytes left
[    3.103442] input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
[    3.120152] consolechars used greatest stack depth: 2460 bytes left
[    3.324518] device-mapper: uevent: version 1.0.3
[    3.325101] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    3.348866] SCSI subsystem initialized
[    3.361212] libata version 3.00 loaded.
[    3.364405] pata_via 0000:00:04.1: version 0.3.3
[    3.365150] scsi0 : pata_via
[    3.365667] scsi1 : pata_via
[    3.368214] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xb800 irq 14
[    3.368576] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xb808 irq 15
[    3.551419] ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
[    3.552279] ata1.00: 78165360 sectors, multi 16: LBA 
[    3.553326] ata1.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[    3.554241] ata1.01: 160086528 sectors, multi 16: LBA 
[    3.579144] ata1.00: configured for UDMA/100
[    3.602850] ata1.01: configured for UDMA/100
[    4.109645] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4165B, DL05, max UDMA/33
[    4.110649] ata2.01: ATAPI: CD-950E/AKU, A4Q, max MWDMA2, CDB intr
[    4.289087] ata2.00: configured for UDMA/33
[    4.464807] ata2.01: configured for MWDMA2
[    4.484559] scsi 0:0:0:0: Direct-Access     ATA      ST340016A        3.75 PQ: 0 ANSI: 5
[    4.486403] scsi 0:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
[    4.491762] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4165B DL05 PQ: 0 ANSI: 5
[    4.493905] scsi 1:0:1:0: CD-ROM            E-IDE    CD-950E/AKU      A4Q  PQ: 0 ANSI: 5
[    4.496087] modprobe used greatest stack depth: 2128 bytes left
[    4.509243] Driver 'sd' needs updating - please use bus_type methods
[    4.510791] sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors (40021 MB)
[    4.511976] sd 0:0:0:0: [sda] Write Protect is off
[    4.513020] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.514222] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.515673] sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors (40021 MB)
[    4.516894] sd 0:0:0:0: [sda] Write Protect is off
[    4.518104] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.519273] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.520600]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 > sda4
[    4.575675] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.577205] sd 0:0:1:0: [sdb] 160086528 512-byte hardware sectors (81964 MB)
[    4.578522] sd 0:0:1:0: [sdb] Write Protect is off
[    4.579655] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.580852] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.582644] sd 0:0:1:0: [sdb] 160086528 512-byte hardware sectors (81964 MB)
[    4.583938] sd 0:0:1:0: [sdb] Write Protect is off
[    4.585096] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.586318] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.587735]  sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 >
[    4.633294] sd 0:0:1:0: [sdb] Attached SCSI disk
[    4.634908] modprobe used greatest stack depth: 1824 bytes left
[    4.653883] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    7.483006] PM: Starting manual resume from disk
[    7.678628] kjournald starting.  Commit interval 5 seconds
[    7.680220] EXT3-fs: mounted filesystem with ordered data mode.
[   14.869482] Linux agpgart interface v0.103
[   14.887631] agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
[   14.985698] agpgart: AGP aperture is 256M @ 0xd0000000
[   15.294566] parport_pc: VIA 686A/8231 detected
[   15.295704] parport_pc: probing current configuration
[   15.296840] parport_pc: Current parallel port base: 0x378
[   15.298104] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   15.362723] <3>ACPI: I/O resource vt596_smbus [0xe800-0xe807] conflicts with ACPI region SM00 [0xe800-0xe806]
[   15.364105] ACPI: Device needs an ACPI driver
[   15.365204] vt596_smbus: probe of 0000:00:04.4 failed with error -16
[   15.386243] usbcore: registered new interface driver usbfs
[   15.387761] usbcore: registered new interface driver hub
[   15.391634] parport_pc: VIA parallel port: io=0x378, irq=7
[   15.416757] ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
[   15.418002] ne2k-pci 0000:00:0b.0: enabling device (0000 -> 0001)
[   15.420362] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   15.421501] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[   15.424021] usbcore: registered new device driver usb
[   15.453345] eth0: RealTek RTL-8029 found at 0x9400, IRQ 11, 00:40:95:46:6e:2d.
[   15.454664] via686a 0000:00:04.4: Forcing ISA address 0xe200
[   15.455850] via686a 0000:00:04.4: Enabling sensors
[   15.474374] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.475643] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   15.477033] scsi 1:0:0:0: Attached scsi generic sg2 type 5
[   15.478253] scsi 1:0:1:0: Attached scsi generic sg3 type 5
[   15.491339] ohci1394 0000:00:09.0: enabling device (0014 -> 0016)
[   15.493413] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
[   15.494510] PCI: setting IRQ 5 as level-triggered
[   15.495553] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
[   15.548299] USB Universal Host Controller Interface driver v3.0
[   15.557542] Driver 'sr' needs updating - please use bus_type methods
[   15.578224] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   15.579460] Uniform CD-ROM driver Revision: 3.20
[   15.581018] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   15.589475] sr1: scsi3-mmc drive: 0x/48x cd/rw xa/form2 cdda tray
[   15.600304] sr 1:0:1:0: Attached scsi CD-ROM sr1
[   15.664086] input: PC Speaker as /class/input/input4
[   15.880138] Real Time Clock Driver v1.12ac
[   15.900335] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[5]  MMIO=[b6800000-b68007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[   15.972889] Floppy drive(s): fd0 is 1.44M
[   16.008178] FDC 0 is a post-1991 82077
[   16.023321] ACPI: PCI Interrupt 0000:00:04.2[D] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
[   16.024698] uhci_hcd 0000:00:04.2: UHCI Host Controller
[   16.026809] uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
[   16.028116] uhci_hcd 0000:00:04.2: irq 5, io base 0x0000b400
[   16.029874] usb usb1: configuration #1 chosen from 1 choice
[   16.031290] hub 1-0:1.0: USB hub found
[   16.032388] hub 1-0:1.0: 2 ports detected
[   16.098646] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   16.116179] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   16.124625] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   16.136700] ACPI: PCI Interrupt 0000:00:04.3[D] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
[   16.138122] uhci_hcd 0000:00:04.3: UHCI Host Controller
[   16.139414] uhci_hcd 0000:00:04.3: new USB bus registered, assigned bus number 2
[   16.140902] uhci_hcd 0000:00:04.3: irq 5, io base 0x0000b000
[   16.142623] usb usb2: configuration #1 chosen from 1 choice
[   16.143959] hub 2-0:1.0: USB hub found
[   16.145183] hub 2-0:1.0: 2 ports detected
[   16.377409] usb 1-1: new full speed USB device using uhci_hcd and address 2
[   16.475002] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   16.476602] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   16.544039] usb 1-1: configuration #1 chosen from 1 choice
[   16.548978] hub 1-1:1.0: USB hub found
[   16.551753] hub 1-1:1.0: 4 ports detected
[   16.911471] ENS1371 0000:00:0d.0: enabling device (0004 -> 0005)
[   16.912808] ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
[   17.299209] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00308d0120e085ca]
[   17.591475] NET: Registered protocol family 10
[   24.933074] EXT3 FS on dm-10, internal journal
[   25.809923] ReiserFS: dm-0: found reiserfs format "3.6" with standard journal
[   25.809956] ReiserFS: dm-0: using ordered data mode
[   25.814985] ReiserFS: dm-0: journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   25.818453] ReiserFS: dm-0: checking transaction log (dm-0)
[   25.884446] ReiserFS: dm-0: Using r5 hash to sort names
[   25.961670] reiser4: dm-5: found disk format 4.0.0.
[   26.203312] reiser4: dm-4: found disk format 4.0.0.
[   26.396289] kjournald starting.  Commit interval 5 seconds
[   26.396317] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   26.396638] EXT3 FS on sda5, internal journal
[   26.396652] EXT3-fs: mounted filesystem with ordered data mode.
[   26.500551] ReiserFS: sda7: found reiserfs format "3.6" with standard journal
[   26.500592] ReiserFS: sda7: using ordered data mode
[   26.506362] ReiserFS: sda7: journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   26.510054] ReiserFS: sda7: checking transaction log (sda7)
[   26.536458] ReiserFS: sda7: Using r5 hash to sort names
[   26.780261] ERR!! init is killed by 10
[   26.781486] ------------[ cut here ]------------
[   26.781492] WARNING: at kernel/signal.c:724 complete_signal+0x163/0x1eb()
[   26.781497] Modules linked in: nls_iso8859_1 nls_cp850 vfat fat reiserfs eeprom w83781d hwmon_vid ipv6 snd_ens1371 firewire_ohci firewire_core gameport crc_itu_t snd_ac97_codec 8250_pnp ac97_bus snd_pcm_oss snd_mixer_oss 8250 serial_core snd_pcm snd_seq_oss floppy snd_seq_midi snd_rawmidi rtc snd_seq_midi_event snd_seq snd_timer snd_seq_device pcspkr snd uhci_hcd sr_mod cdrom soundcore snd_page_alloc ohci1394 sg via686a ne2k_pci 8390 ieee1394 i2c_viapro usbcore ata_generic parport_pc parport via_agp agpgart evdev dm_snapshot reiser4 lzo_decompress lzo_compress sd_mod pata_via libata scsi_mod dm_mirror dm_log dm_mod
[   26.781609] Pid: 2590, comm: sh Not tainted 2.6.25-rc5-mm1 #18
[   26.781619]  [<c01188bd>] warn_on_slowpath+0x41/0x6d
[   26.781640]  [<c0119200>] ? vprintk+0x289/0x3b6
[   26.781650]  [<c01cc3a8>] ? number+0x10d/0x1cd
[   26.781671]  [<c0158db9>] ? cache_free_debugcheck+0x1e1/0x1ec
[   26.781699]  [<c0119342>] ? printk+0x15/0x17
[   26.781709]  [<c0120fa9>] complete_signal+0x163/0x1eb
[   26.781719]  [<c01211d4>] send_signal+0x1a3/0x1cf
[   26.781729]  [<c0121216>] __group_send_sig_info+0xa/0xc
[   26.781737]  [<c01217cc>] group_send_sig_info+0x44/0x62
[   26.781747]  [<c0121de4>] kill_pid_info+0x33/0x47
[   26.781757]  [<c0122443>] sys_kill+0x73/0x145
[   26.781767]  [<c014c655>] ? handle_mm_fault+0x21d/0x4f6
[   26.781791]  [<c012af3c>] ? up_read+0x16/0x2a
[   26.781803]  [<c011214c>] ? do_page_fault+0x25a/0x4da
[   26.781815]  [<c0103906>] sysenter_past_esp+0x5f/0xa5
[   26.781834]  =======================
[   26.781838] ---[ end trace c053f6e3c5b0fb23 ]---
[   26.827206] Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k
[   27.762345] eth0: no IPv6 routers present
[   32.522353] lp0: using parport0 (interrupt-driven).
[   32.840715] [drm] Initialized drm 1.1.0 20060810
[   32.892406] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[   34.604435] agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
[   34.604475] agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
[   34.604604] agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[   36.796991] [drm] Setting GART location based on new memory map
[   36.797011] [drm] Loading R200 Microcode
[   36.797055] [drm] writeback test succeeded in 1 usecs
[   37.919570] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   53.671327] gpg-agent used greatest stack depth: 1692 bytes left
[   65.797323] ed used greatest stack depth: 1600 bytes left
[  237.574866] reiser4[pdflush(139)]: disable_write_barrier (fs/reiser4/wander.c:234)[zam-1055]:
[  237.574872] NOTICE: dm-4 does not support write barriers, using synchronous write instead.

--------------060609050309070801040503--
