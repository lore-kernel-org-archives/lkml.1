Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbYEFNKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbYEFNKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761506AbYEFNKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:10:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58926 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759758AbYEFNKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:10:10 -0400
Message-ID: <482058AA.3050402@gentoo.org>
Date: Tue, 06 May 2008 15:10:02 +0200
From: =?ISO-8859-1?Q?Ra=FAl_Porcel?= <armin76@gentoo.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 hangs during boot on UltraSPARC 5
References: <18464.3741.133714.308327@harpo.it.uu.se> <20080506.010523.113767579.davem@davemloft.net>
In-Reply-To: <20080506.010523.113767579.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mikael Pettersson <mikpe@it.uu.se>
> Date: Tue, 6 May 2008 09:54:05 +0200
> 
>> OF stdout device is: /pci@1f,0/pci@1,1/SUNW,m64B@2
>> PROM: Built device tree with 46848 bytes of memory.
>> On node 0 totalpages: 32298
>>   Normal zone: 335 pages used for memmap
>>   Normal zone: 0 pages reserved
>>   Normal zone: 31963 pages, LIFO batch:7
>>   Movable zone: 0 pages used for memmap
>> Booting Linux...
>> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 31963
>> Kernel command line: ro root=/dev/sda5
>> PID hash table entries: 1024 (order: 10, 8192 bytes)
>> clocksource: mult[28000] shift[16]
>> clockevent: mult[66666666] shift[32]
>> Console: colour dummy device 80x25
>> console handover: boot [earlyprom0] -> real [tty0]
>>
>> *** 2.6.26-rc1 gets as far as the line above, then hangs
> 
> It's possible your machine does boot up all the way.
> The video driver simply isn't registerring for whatever
> reason.
> 
> Can you ping the box if you wait a minute or two after the
> messages stop?
> 
> The only patch to the aty driver since 2.6.25 is the
> following, below, which you can try reverting.
> 
> Another thing you can do is edit arch/sparc64/kernel/setup.c
> and in the prom_early_console struct initializer, remove the
> "CON_BOOT" bit from the .flags setting.  That will keep the
> PROM console enabled even when another console wants to
> register.  We'll get more messages that way.
> 
> commit 21b4d1db84a70175251d86078123cc27e46ff69d
> Author: Roel Kluin <12o3l@tiscali.nl>
> Date:   Mon Apr 28 02:15:04 2008 -0700
> 
>     video/aty/atyfb_base.c: free when fb can't be registered
>     
>     Free buffer when the framebuffer can't be registered
>     
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>     Cc: "Antonino A. Daplas" <adaplas@pol.net>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
> index 62f9c6e..e4bcf53 100644
> --- a/drivers/video/aty/atyfb_base.c
> +++ b/drivers/video/aty/atyfb_base.c
> @@ -2621,10 +2621,13 @@ static int __devinit aty_init(struct fb_info *info)
>  #endif /* CONFIG_FB_ATY_CT */
>  	info->var = var;
>  
> -	fb_alloc_cmap(&info->cmap, 256, 0);
> +	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
> +		goto aty_init_exit;
>  
> -	if (register_framebuffer(info) < 0)
> +	if (register_framebuffer(info) < 0) {
> +		fb_dealloc_cmap(&info->cmap);
>  		goto aty_init_exit;
> +	}
>  
>  	fb_list = info;
>  

I've got the same issue on a Sun Blade 1000, doing the CON_BOOT thing 
this is what i get, obviously it just hangs and i can't return to OBP.

Allocated 8 Megs of memory at 0x40000000 for kernel
Loaded kernel version 2.6.26
Loading initial ramdisk (755279 bytes at 0x3F800000 phys, 0x40C00000 
virt)...
|
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.16.4 2004/12/18 05:18'
[    0.000000] PROMLIB: Root node compatible:
[    0.000000] Linux version 2.6.26-rc1-git3 (root@monchisun) (gcc 
version 4.1.2 (Gentoo 4.1.2 p1.08
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Kernel: Using 2 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /pci@8,700000/ebus@5/serial@1,400000:a
[    0.000000] PROM: Built device tree with 64227 bytes of memory.
[    0.000000] Top of RAM: 0x3ff0e000, Total RAM: 0x3fee0000
[    0.000000] Memory hole size: 0MB
[    0.000000] [0000000200000000-fffff80000400000] page_structs=131072 
node=0 entry=0/0
[    0.000000] [0000000200000000-fffff80000800000] page_structs=131072 
node=0 entry=1/0
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal          0 ->   130951
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0:        0 ->   129023
[    0.000000]     0:   129024 ->   130914
[    0.000000]     0:   130916 ->   130928
[    0.000000]     0:   130944 ->   130946
[    0.000000]     0:   130950 ->   130951
[    0.000000] Booting Linux...
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 130033
[    0.000000] Kernel command line: root=/dev/sda4 doscsi 
rdinit=/linuxrc real_root=/dev/sda4
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.004000] clocksource: mult[c80000] shift[16]
[    0.004000] clockevent: mult[147ae14] shift[32]
[    0.004000] ------------[ cut here ]------------
[    0.004000] WARNING: at drivers/cpufreq/cpufreq.c:1391 
cpufreq_register_notifier+0x2c/0x74()
[    0.004000] Modules linked in:
[    0.004000] Call Trace:
[    0.004000]  [000000000065dd14] cpufreq_register_notifier+0x34/0x74
[    0.004000]  [00000000007f87f8] start_kernel+0x1a0/0x2f0
[    0.004000]  [00000000006d3330] auxio_probe+0x0/0xd0
[    0.004000]  [0000000000000000] 0x8
[    0.004000] ---[ end trace 139ce121c98e96c9 ]---
[    0.004089] Console: colour dummy device 80x25
[    0.011699] Dentry cache hash table entries: 131072 (order: 7, 
1048576 bytes)
[    0.014788] Inode-cache hash table entries: 65536 (order: 6, 524288 
bytes)
[    0.045548] Memory: 1024960k available (2912k kernel code, 1104k 
data, 152k init) [fffff80000000]
[    0.128012] Calibrating delay using timer specific routine.. 10.01 
BogoMIPS (lpj=20020)
[    0.136221] Mount-cache hash table entries: 512
[    0.141496] net_namespace: 344 bytes
[    0.144700] NET: Registered protocol family 16
[    0.159101] PCI: Probing for controllers.
[    0.160130] /pci@8,700000: SCHIZO PCI Bus Module ver[4:0]
[    0.164024] /pci@8,700000: PCI IO[7ffef000000] MEM[7fe00000000]
[    0.172817] /pci@8,600000: SCHIZO PCI Bus Module ver[4:0]
[    0.176023] /pci@8,600000: PCI IO[7ffed000000] MEM[7fd00000000]
[    0.184840] PCI: Scanning PBM /pci@8,600000
[    0.188459] PCI: Scanning PBM /pci@8,700000
[    0.193337] ebus0: [flashprom] [i2c -> (nvram) (idprom) (dimm-fru) 
(dimm-fru) (dimm-fru) (dimm-f]
[    0.302973] SCSI subsystem initialized
[    0.304403] usbcore: registered new interface driver usbfs
[    0.308301] usbcore: registered new interface driver hub
[    0.312205] usbcore: registered new device driver usb
[    0.344297] /pci@8,700000/ebus@5/rtc@1,300070: Clock regs at 
000007fe7e300070
[    0.349715] NET: Registered protocol family 2
[    0.388211] IP route cache hash table entries: 8192 (order: 3, 65536 
bytes)
[    0.468847] TCP established hash table entries: 32768 (order: 6, 
524288 bytes)
[    0.557836] TCP bind hash table entries: 32768 (order: 5, 262144 bytes)
[    0.636590] TCP: Hash tables configured (established 32768 bind 32768)
[    0.712052] TCP reno registered
[    0.760209] NET: Registered protocol family 1
[    0.808403] Unpacking initramfs...<1>Unable to handle kernel paging 
request at virtual address 00
[    0.928065] tsk->{mm,active_mm}->context = 0000000000000000
[    0.996069] tsk->{mm,active_mm}->pgd = fffff8003f4217d4
[    1.060074]               \|/ ____ \|/
[    1.060079]               "@'/ .. \`@"
[    1.060082]               /_| \__/ |_\
[    1.060086]                  \__U_/
[    1.236087] swapper(1): Oops [#1]
[    1.276091] TSTATE: 0000000080001606 TPC: 00000000007fad00 TNPC: 
00000000007fad04 Y: 00000041   W
[    1.400109] TPC: <unpack_to_rootfs+0xac/0xa28>
[    1.452097] g0: 0000000000000001 g1: 0000000000000001 g2: 
0000000000000001 g3: 0000000000000000
[    1.556104] g4: fffff8003e02d860 g5: 0000000000000000 g6: 
fffff8003e03c000 g7: 0000000000000000
[    1.660111] o0: fffff8003e160000 o1: 00000000000000d0 o2: 
0000000000000001 o3: 0000000000000001
[    1.764117] o4: 0000000000000000 o5: 00000000bde9fd0b sp: 
fffff8003e03f431 ret_pc: 00000000007fac
[    1.876125] RPC: <unpack_to_rootfs+0x58/0xa28>
[    1.928127] l0: 00000000007c2800 l1: 0000000000814400 l2: 
0000000000814400 l3: 0000000000000000
[    2.032134] l4: 0000000000000001 l5: 00000000007e4350 l6: 
fffff8003e11a420 l7: 000000000076b360
[    2.136141] i0: 000000003f800000 i1: 00000000000b864f i2: 
0000000000814400 i3: fffff8003e1becc0
[    2.240147] i4: 00000000000003f7 i5: 00000000007ed400 i6: 
fffff8003e03f4f1 i7: 00000000007fb6e0
[    2.344155] I7: <populate_rootfs+0x64/0xac>
[    2.396155] Caller[00000000007fb6e0]: populate_rootfs+0x64/0xac
[    2.466224] Caller[00000000007f819c]: kernel_init+0xac/0x208
[    2.534229] Caller[0000000000426cf8]: kernel_thread+0x38/0x48
[    2.602233] Caller[00000000006d1d34]: rest_init+0x18/0x60
[    2.666238] Instruction DUMP: 03002050  10680243  c07063a0 <c24e0000> 
05002051  80a06030  124800
[    2.796183] Kernel panic - not syncing: Attempted to kill init!
[    2.864187] Press Stop-A (L1-A) to return to the boot prom
