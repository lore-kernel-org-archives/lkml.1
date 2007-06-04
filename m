Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbXFDUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbXFDUX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbXFDUXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:23:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:19050 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbXFDUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=pSqXAdCJalYqqUlQgIr2ugiCwh9KKs/3AbFOHKXdEXV4EBkbzRt+pJL43o9lc7lNADpoxG5uUcw95jOtrs9QbOh8hnLO4UqBVYfj+icRzd3oZzctTE87jBZzjdKzx0V44D6n155s9kyzhWK1VlG7sWoIpdp+hWE8GK3lKeCQGLY=
Date: Mon, 4 Jun 2007 22:22:49 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Message-ID: <20070604202248.GA18668@dreamland.darkstar.lan>
References: <20070603213432.GA3075@dreamland.darkstar.lan> <4663DCE9.3000107@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4663DCE9.3000107@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Il Mon, Jun 04, 2007 at 12:35:37PM +0300, Avi Kivity ha scritto: 
> Luca Tettamanti wrote:
> >Hello,
> >my kernel just exploded :)
> >
> >The host is running 2.6-git-current, with KVM modules from KVM-27
> >package. kernel is 32bit, SMP, with PREEMPT enabled, no HIGHMEM (but I'm
> >using CONFIG_VMSPLIT_3G_OPT=y). The CPU is a Core2 (hence I'm using
> >kvm-intel).
> >Guest was a Fedora7 setup DVD, which died somewhere during the
> >installation (anaconda was already active at that point). Bad news is
> >that I cannot reproduce the bug :|
> >  
> Fortunately the trace clearly shows the problem (out of mmu working 
> memory on guest context switch).  The attached patch should fix it.  Let 
> me know if it works for you.

It turned out that it was somewhat reproducible with fedora installer.
With your patch it doesn't oops anymore.

While doing repeated tests with the installer I ran into another
(unrelated) problem. Sometimes the guest kernel hangs at boot at:

NET: Registered protocol family 2

with any kind of networking options (except for -net none, which works).
With -no-kvm it boots with any networking option.

The only difference in dmesg is that when KVM is enable the guest uses
the TSC:

 NetLabel:  unlabeled traffic allowed by default
-Time: tsc clocksource has been installed.
 PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0

For reference this is the command line that I'm using:

./kvm-27/qemu/i386-softmmu/qemu -hda /home/kronos/tmp/fedora.img
  -cdrom /home/kronos/tmp/boot.iso -boot d -net tap -net nic -m 256

and boot.iso is the fedora7 net install image (you can find it on any
mirror: fedora/linux/releases/7/Fedora/arch/os/images/boot.iso).

The guest kernel doesn't respond to sysrq, so I don't known exactly
where it's hanging. The stack trace on the host seems rather
uninteresting:

qemu          S 00000002  2404 18905   7312 (NOTLB)
       dca4db48 00000086 00000000 00000002 b0478900 eec4a0f0 b02f418b b0478900 
       0000000a 00000000 eec4a0f0 ef31ca70 267db8c3 000008c7 00003ea3 eec4a1fc 
       b1810980 efcc62a0 b0478900 b0129580 00000000 00000292 dca4db58 0023935c 
Call Trace:
 [<b02f418b>] _spin_unlock_irqrestore+0x34/0x58
 [<b0129580>] __mod_timer+0x9d/0xa7
 [<b02f2258>] schedule_timeout+0x70/0x8d
 [<b02f418b>] _spin_unlock_irqrestore+0x34/0x58
 [<b01291e0>] process_timeout+0x0/0x5
 [<b02f2253>] schedule_timeout+0x6b/0x8d
 [<b0171eb1>] do_select+0x399/0x3e7
 [<b0172496>] __pollwait+0x0/0xac
 [<b011c720>] default_wake_function+0x0/0xc
 [<b0171766>] free_poll_entry+0xe/0x16
 [<b0171786>] poll_freewait+0x18/0x4c
 [<b0171abc>] do_sys_poll+0x302/0x327
 [<b0172496>] __pollwait+0x0/0xac
 [<b011c720>] default_wake_function+0x0/0xc
 [<b011b26a>] task_rq_lock+0x36/0x5d
 [<b02f3c59>] _spin_lock+0x33/0x3e
 [<b02f4197>] _spin_unlock_irqrestore+0x40/0x58
 [<b011c716>] try_to_wake_up+0x325/0x32f
 [<b013b017>] mark_held_locks+0x39/0x53
 [<b02f418b>] _spin_unlock_irqrestore+0x34/0x58
 [<b0103ec0>] restore_nocheck+0x12/0x15
 [<b013b1ee>] trace_hardirqs_on+0x11a/0x13d
 [<b010679a>] do_IRQ+0xc4/0xde
 [<b0103ec0>] restore_nocheck+0x12/0x15
 [<b01721ed>] core_sys_select+0x2ee/0x30f
 [<b0103189>] setup_sigcontext+0x105/0x189
 [<b02f41cf>] _spin_unlock_irq+0x20/0x41
 [<b013b1ee>] trace_hardirqs_on+0x11a/0x13d
 [<b0103a56>] do_notify_resume+0x5d1/0x611
 [<b02f41da>] _spin_unlock_irq+0x2b/0x41
 [<b01039b4>] do_notify_resume+0x52f/0x611
 [<b0103ec0>] restore_nocheck+0x12/0x15
 [<b010898b>] convert_fxsr_from_user+0x26/0xe6
 [<b01725e6>] sys_select+0xa4/0x187
 [<b0103ec0>] restore_nocheck+0x12/0x15
 [<b013b1ee>] trace_hardirqs_on+0x11a/0x13d
 [<b0103e78>] syscall_call+0x7/0xb
 =======================
qemu          S CF9E5DC0  2996 18911   7312 (NOTLB)
       cf9e5dd4 00000082 00000002 cf9e5dc0 cf9e5dbc 00000000 b013b1ee cf9e5ea0 
       00000007 00000001 d252b4f0 b194c030 70a8bf29 000008ac 0000a554 d252b5fc 
       b181a980 efcc62a0 00232330 00000003 00000000 00000000 cf9e5ea0 efcc62d4 
Call Trace:
 [<b013b1ee>] trace_hardirqs_on+0x11a/0x13d
 [<b013de28>] futex_wait+0x251/0x3ed
 [<b0134156>] hrtimer_wakeup+0x0/0x18
 [<b013de19>] futex_wait+0x242/0x3ed
 [<b011c720>] default_wake_function+0x0/0xc
 [<b013e906>] do_futex+0x6c/0xaad
 [<b012acf7>] sys_rt_sigqueueinfo+0x44/0x4e
 [<b0135a4e>] getnstimeofday+0x30/0xbe
 [<b0134627>] ktime_get_ts+0x16/0x44
 [<b013f40f>] sys_futex+0xc8/0xda
 [<b0103e78>] syscall_call+0x7/0xb
 =======================

I'm attaching the dmesg for both -kvm and -no-kvm cases.

Luca
-- 
"La teoria e` quando sappiamo come funzionano le cose ma non funzionano.
 La pratica e` quando le cose funzionano ma non sappiamo perche`.
 Abbiamo unito la teoria e la pratica: le cose non funzionano piu` e non
 sappiamo il perche`." -- A. Einstein

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="serial-kvm.txt"

Linux version 2.6.21-1.3194.fc7 (kojibuilder@xenbuilder3.fedora.phx.redhat.com) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP Wed May 23 22:11:19 EDT 2007

BIOS-provided physical RAM map:

sanitize start

sanitize end

copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1

copy_e820_map() type is E820_RAM

copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2

copy_e820_map() start: 00000000000e8000 size: 0000000000018000 end: 0000000000100000 type: 2

copy_e820_map() start: 0000000000100000 size: 000000000ff00000 end: 0000000010000000 type: 1

copy_e820_map() type is E820_RAM

copy_e820_map() start: 00000000fffc0000 size: 0000000000040000 end: 0000000100000000 type: 2

 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)

 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)

 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)

 BIOS-e820: 0000000000100000 - 0000000010000000 (usable)

 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)

0MB HIGHMEM available.

256MB LOWMEM available.

Using x86 segment limits to approximate NX protection

Entering add_active_range(0, 0, 65536) 0 entries of 256 used

Zone PFN ranges:

  DMA             0 ->     4096

  Normal       4096 ->    65536

  HighMem     65536 ->    65536

early_node_map[1] active PFN ranges

    0:        0 ->    65536

On node 0 totalpages: 65536

  DMA zone: 32 pages used for memmap

  DMA zone: 0 pages reserved

  DMA zone: 4064 pages, LIFO batch:0

  Normal zone: 480 pages used for memmap

  Normal zone: 60960 pages, LIFO batch:15

  HighMem zone: 0 pages used for memmap

DMI not present or invalid.

Using APIC driver default

ACPI: no DMI BIOS year, acpi=force is required to enable ACPI

ACPI: Disabling ACPI support

Allocating PCI resources starting at 20000000 (gap: 10000000:effc0000)

Built 1 zonelists.  Total pages: 65024

Kernel command line: initrd=initrd.img console=tty0 console=ttyS0 debug BOOT_IMAGE=vmlinuz 

Found and enabled local APIC!

mapped APIC to ffffd000 (fee00000)

Enabling fast FPU save and restore... done.

Enabling unmasked SIMD FPU exception support... done.

Initializing CPU#0

CPU 0 irqstacks, hard=c076e000 soft=c074e000

PID hash table entries: 1024 (order: 10, 4096 bytes)

Detected 2135.363 MHz processor.

Console: colour VGA+ 80x25

Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)

Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)

Memory: 249556k/262144k available (2037k kernel code, 12036k reserved, 1069k data, 236k init, 0k highmem)

virtual kernel memory layout:

    fixmap  : 0xffc55000 - 0xfffff000   (3752 kB)

    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)

    vmalloc : 0xd0800000 - 0xff7fe000   ( 751 MB)

    lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)

      .init : 0xc070e000 - 0xc0749000   ( 236 kB)

      .data : 0xc05fd722 - 0xc0708cb4   (1069 kB)

      .text : 0xc0400000 - 0xc05fd722   (2037 kB)

Checking if this processor honours the WP bit even in supervisor mode... Ok.

Calibrating delay using timer specific routine.. 17122.84 BogoMIPS (lpj=8561424)

Security Framework v1.0.0 initialized

SELinux:  Initializing.

SELinux:  Starting in permissive mode

selinux_register_security:  Registering secondary module capability

Capability LSM initialized as secondary

Mount-cache hash table entries: 512

CPU: After generic identify, caps: 0781abfd 00000000 00000000 00000000 00000001 00000000 00000000

CPU: L1 I cache: 8K

CPU: L2 cache: 128K

CPU: After all inits, caps: 0781a3fd 00000000 00000000 00000040 00000001 00000000 00000000

Checking 'hlt' instruction... OK.

SMP alternatives: switching to UP code

Freeing SMP alternatives: 13k freed

CPU0: Intel Pentium II (Klamath) stepping 03

SMP motherboard not detected.

Brought up 1 CPUs

sizeof(vma)=84 bytes

sizeof(page)=32 bytes

sizeof(inode)=336 bytes

sizeof(dentry)=132 bytes

sizeof(ext3inode)=488 bytes

sizeof(buffer_head)=56 bytes

sizeof(skbuff)=176 bytes

sizeof(task_struct)=1376 bytes

Time: 19:24:25  Date: 05/04/107

NET: Registered protocol family 16

PCI: PCI BIOS revision 2.10 entry at 0xf9fa0, last bus=0

PCI: Using configuration type 1

Setting up standard PCI resources

ACPI: Interpreter disabled.

Linux Plug and Play Support v0.97 (c) Adam Belay

pnp: PnP ACPI: disabled

usbcore: registered new interface driver usbfs

usbcore: registered new interface driver hub

usbcore: registered new device driver usb

PCI: Probing PCI hardware

PCI: Probing PCI hardware (bus 00)

* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,

* this clock source is slow. Consider trying other clock sources

PCI quirk: region b100-b10f claimed by PIIX4 SMB

Boot video device is 0000:00:02.0

PCI: Using IRQ router PIIX/ICH [8086/7000] at 0000:00:01.0

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

NetLabel: Initializing

NetLabel:  domain hash size = 128

NetLabel:  protocols = UNLABELED CIPSOv4

NetLabel:  unlabeled traffic allowed by default

PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0

NET: Registered protocol family 2


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=UTF8
Content-Disposition: attachment; filename="serial-nokvm.txt"
Content-Transfer-Encoding: 8bit

Linux version 2.6.21-1.3194.fc7 (kojibuilder@xenbuilder3.fedora.phx.redhat.com) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP Wed May 23 22:11:19 EDT 2007

BIOS-provided physical RAM map:

sanitize start

sanitize end

copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1

copy_e820_map() type is E820_RAM

copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2

copy_e820_map() start: 00000000000e8000 size: 0000000000018000 end: 0000000000100000 type: 2

copy_e820_map() start: 0000000000100000 size: 000000000ff00000 end: 0000000010000000 type: 1

copy_e820_map() type is E820_RAM

copy_e820_map() start: 00000000fffc0000 size: 0000000000040000 end: 0000000100000000 type: 2

 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)

 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)

 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)

 BIOS-e820: 0000000000100000 - 0000000010000000 (usable)

 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)

0MB HIGHMEM available.

256MB LOWMEM available.

Using x86 segment limits to approximate NX protection

Entering add_active_range(0, 0, 65536) 0 entries of 256 used

Zone PFN ranges:

  DMA             0 ->     4096

  Normal       4096 ->    65536

  HighMem     65536 ->    65536

early_node_map[1] active PFN ranges

    0:        0 ->    65536

On node 0 totalpages: 65536

  DMA zone: 32 pages used for memmap

  DMA zone: 0 pages reserved

  DMA zone: 4064 pages, LIFO batch:0

  Normal zone: 480 pages used for memmap

  Normal zone: 60960 pages, LIFO batch:15

  HighMem zone: 0 pages used for memmap

DMI not present or invalid.

Using APIC driver default

ACPI: no DMI BIOS year, acpi=force is required to enable ACPI

ACPI: Disabling ACPI support

Allocating PCI resources starting at 20000000 (gap: 10000000:effc0000)

Built 1 zonelists.  Total pages: 65024

Kernel command line: initrd=initrd.img console=tty0 console=ttyS0 debug BOOT_IMAGE=vmlinuz 

Found and enabled local APIC!

mapped APIC to ffffd000 (fee00000)

Enabling fast FPU save and restore... done.

Enabling unmasked SIMD FPU exception support... done.

Initializing CPU#0

CPU 0 irqstacks, hard=c076e000 soft=c074e000

PID hash table entries: 1024 (order: 10, 4096 bytes)

Detected 2135.092 MHz processor.

Console: colour VGA+ 80x25

Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)

Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)

Memory: 249556k/262144k available (2037k kernel code, 12036k reserved, 1069k data, 236k init, 0k highmem)

virtual kernel memory layout:

    fixmap  : 0xffc55000 - 0xfffff000   (3752 kB)

    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)

    vmalloc : 0xd0800000 - 0xff7fe000   ( 751 MB)

    lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)

      .init : 0xc070e000 - 0xc0749000   ( 236 kB)

      .data : 0xc05fd722 - 0xc0708cb4   (1069 kB)

      .text : 0xc0400000 - 0xc05fd722   (2037 kB)

Checking if this processor honours the WP bit even in supervisor mode... Ok.

Calibrating delay using timer specific routine.. 17104.71 BogoMIPS (lpj=8552357)

Security Framework v1.0.0 initialized

SELinux:  Initializing.

SELinux:  Starting in permissive mode

selinux_register_security:  Registering secondary module capability

Capability LSM initialized as secondary

Mount-cache hash table entries: 512

CPU: After generic identify, caps: 0781abfd 00000000 00000000 00000000 00000001 00000000 00000000

CPU: L1 I cache: 8K

CPU: L2 cache: 128K

CPU: After all inits, caps: 0781a3fd 00000000 00000000 00000040 00000001 00000000 00000000

Checking 'hlt' instruction... OK.

SMP alternatives: switching to UP code

Freeing SMP alternatives: 13k freed

CPU0: Intel Pentium II (Klamath) stepping 03

SMP motherboard not detected.

Brought up 1 CPUs

sizeof(vma)=84 bytes

sizeof(page)=32 bytes

sizeof(inode)=336 bytes

sizeof(dentry)=132 bytes

sizeof(ext3inode)=488 bytes

sizeof(buffer_head)=56 bytes

sizeof(skbuff)=176 bytes

sizeof(task_struct)=1376 bytes

Time: 19:26:14  Date: 05/04/107

NET: Registered protocol family 16

PCI: PCI BIOS revision 2.10 entry at 0xf9fa0, last bus=0

PCI: Using configuration type 1

Setting up standard PCI resources

ACPI: Interpreter disabled.

Linux Plug and Play Support v0.97 (c) Adam Belay

pnp: PnP ACPI: disabled

usbcore: registered new interface driver usbfs

usbcore: registered new interface driver hub

usbcore: registered new device driver usb

PCI: Probing PCI hardware

PCI: Probing PCI hardware (bus 00)

* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,

* this clock source is slow. Consider trying other clock sources

PCI quirk: region b100-b10f claimed by PIIX4 SMB

Boot video device is 0000:00:02.0

PCI: Using IRQ router PIIX/ICH [8086/7000] at 0000:00:01.0

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

PCI: BIOS reporting unknown device 01:00

NetLabel: Initializing

NetLabel:  domain hash size = 128

NetLabel:  protocols = UNLABELED CIPSOv4

NetLabel:  unlabeled traffic allowed by default

Time: tsc clocksource has been installed.

PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0

NET: Registered protocol family 2

IP route cache hash table entries: 2048 (order: 1, 8192 bytes)

TCP established hash table entries: 8192 (order: 4, 98304 bytes)

TCP bind hash table entries: 8192 (order: 4, 65536 bytes)

TCP: Hash tables configured (established 8192 bind 8192)

TCP reno registered

checking if image is initramfs... it is

Freeing initrd memory: 5541k freed

apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)

audit: initializing netlink socket (disabled)

audit(1180985175.184:1): initialized

Total HugeTLB memory allocated, 0

VFS: Disk quotas dquot_6.5.1

Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)

SELinux:  Registering netfilter hooks

ksign: Installing public key data

Loading keyring

- Added public key C3680E46D35DB7E1

- User ID: Red Hat, Inc. (Kernel Module GPG key)

io scheduler noop registered

io scheduler anticipatory registered

io scheduler deadline registered

io scheduler cfq registered (default)

Limiting direct PCI/PCI transfers.

PCI: PIIX3: Enabling Passive Release on 0000:00:01.0

Activating ISA DMA hang workarounds.

isapnp: Scanning for PnP cards...

isapnp: No Plug & Play device found

Real Time Clock Driver v1.12ac

Non-volatile memory driver v1.2

Linux agpgart interface v0.102 (c) Dave Jones

Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled

ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450

Clocksource tsc unstable (delta = 1700358775 ns)

RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize

Time: pit clocksource has been installed.

input: Macintosh mouse button emulation as /class/input/input0

usbcore: registered new interface driver libusual

usbcore: registered new interface driver hiddev

usbcore: registered new interface driver usbhid

drivers/usb/input/hid-core.c: v2.6:USB HID core driver

PNP: No PS/2 controller found. Probing ports directly.

serio: i8042 KBD port at 0x60,0x64 irq 1

serio: i8042 AUX port at 0x60,0x64 irq 12

mice: PS/2 mouse device common for all mice

input: AT Translated Set 2 keyboard as /class/input/input1

TCP bic registered

Initializing XFRM netlink socket

NET: Registered protocol family 1

NET: Registered protocol family 17

Using IPI No-Shortcut mode

  Magic number: 11:688:444

drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

Freeing unused kernel memory: 236k freed

Write protecting the kernel read-only data: 803k

Greetings.

anaconda installer init version 11.2.0.66 starting

mounting /proc filesystem... done

creating /dev filesystem... done

mounting /dev/pts (unix98 pty) filesystem... done

mounting /sys filesystem... done

input: ImExPS/2 Generic Explorer Mouse as /class/input/input2

anaconda installer init version 11.2.0.66 using a serial console

trying to remount root filesystem read write... done

mounting /tmp as ramfs... done

running install...

running /sbin/loader


--J/dobhs11T7y2rNN--
