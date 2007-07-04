Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbXGDHgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbXGDHgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 03:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXGDHgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 03:36:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:3540 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXGDHge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 03:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W6H9+isYdmUJ/d6bpG9BgtAJhadqAtxDsxX8sC6f79POXlo/fm70Plx6IboYuG4nvOAfYiGFMaiWXZDY/yGibwdgdIV2ImoHL8FTYuGnB63AgIuqxJSxNZwpn+WEsU34S9hOSuBvwalUq5g+mCHc5y7F6pn1qFWP2bnmMWjuFgE=
Message-ID: <a44ae5cd0707040036x74c82dcci12b0a3f83a27af56@mail.gmail.com>
Date: Wed, 4 Jul 2007 00:36:33 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226 SS:ESP 0068:c5ff9db8
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       jketreno@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <468B3CFF.7020903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>
	 <20070703094916.e60d4df7.akpm@linux-foundation.org>
	 <468B3CFF.7020903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/07, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> Andrew Morton wrote:
> >> EIP is at sysfs_addrm_finish+0x1c2/0x226
> >> eax: 00000001   ebx: c5ff9dc0   ecx: c058aa40   edx: 00000001
> >> esi: c5ff9de8   edi: c37c3240   ebp: c5ff9e1c   esp: c5ff9db8
> >> ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> >> Process modprobe (pid: 3519, ti=c5ff9000 task=c5ef15e0 task.ti=c5ff9000)
> >> Stack: c03a3eda c5ff9e24 00000000 00000001 dead4ead ffffffff ffffffff c0657cf0
> >>        00000000 c046359d c5ff9de0 c5ff9de0 00000000 00000001 dead4ead ffffffff
> >>        ffffffff c0657cf0 00000000 c046359d c5ff9de0 c5ff9de0 c37c3240 c5ff9e24
> >> Call Trace:
> >>  [<c01a7833>] remove_dir+0x2e/0x35
> >>  [<c01a7894>] __sysfs_remove_dir+0x5a/0x61
> >>  [<c01a78d1>] sysfs_remove_dir+0x2c/0x30
>
> Hmm... That's weird.  I tried to regenerate it here but mine unloads
> happily.  Can you apply the attached patch and report the resulting
> messages when oops happens?
>
> Thanks.
>
> --
> tejun
>
> ---
>  fs/sysfs/dir.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> Index: tree0/fs/sysfs/dir.c
> ===================================================================
> --- tree0.orig/fs/sysfs/dir.c
> +++ tree0/fs/sysfs/dir.c
> @@ -268,6 +268,9 @@ static void sysfs_deactivate(struct sysf
>         DECLARE_COMPLETION_ONSTACK(wait);
>         int v;
>
> +       if (sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED))
> +               printk("XXX sysfs_deactivate: sd=%p s_sibling=%p s_flags=0x%x\n",
> +                      sd, sd->s_sibling, sd->s_flags);
>         BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
>         sd->s_sibling = (void *)&wait;
>
> @@ -530,6 +533,9 @@ void sysfs_remove_one(struct sysfs_addrm
>                 drop_nlink(acxt->parent_inode);
>
>         acxt->cnt++;
> +
> +       printk("XXX sysfs_remove_one: acxt=%p sd=%p s_flags=0x%x cnt=%d\n",
> +              acxt, sd, sd->s_flags, acxt->cnt);
>  }
>
>  /**
> @@ -624,6 +630,8 @@ int sysfs_addrm_finish(struct sysfs_addr
>                 acxt->removed = sd->s_sibling;
>                 sd->s_sibling = NULL;
>
> +               printk("XXX sysfs_addrm_finish: acxt=%p sd=%p s_sibling=%p s_flags=0x%x\n",
> +                      acxt, sd, sd->s_sibling, sd->s_flags);
>                 sysfs_drop_dentry(sd);
>                 sysfs_deactivate(sd);
>                 sysfs_put(sd);
>
>

I know this is a long log chunk, but I don't want to miss the
significant part.  I am starting with the first message from your
modified code.

io scheduler anticipatory registered (default)
Boot video device is 0000:00:02.0
XXX sysfs_remove_one: acxt=c2448e1c sd=c346cd80 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448e1c sd=c346cd80 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c2448e1c sd=c346cde0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448e1c sd=c346cde0 s_sibling=00000000
s_flags=0x120
ACPI: AC Adapter [ACAD] (off-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating
_PTC [20070126]
ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating
_TSS [20070126]
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
XXX sysfs_remove_one: acxt=c2448e9c sd=c25e8a20 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448e9c sd=c25e8a20 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c2448e9c sd=c25e8a80 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448e9c sd=c25e8a80 s_sibling=00000000
s_flags=0x120
ACPI: Thermal Zone [THRM] (63 C)
Real Time Clock Driver v1.12ac
intel_rng: FWH not detected
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
agpgart: Detected an Intel 855GM Chipset.
agpgart: Detected 32636K stolen memory.
agpgart: AGP aperture is 128M @ 0xe8000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
ACPI: PCI Interrupt 0000:00:1f.6[B] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
XXX sysfs_remove_one: acxt=c2448e90 sd=c34d3960 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448e90 sd=c34d3960 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c2448e90 sd=c34d39c0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448e90 sd=c34d39c0 s_sibling=00000000
s_flags=0x120
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 18
eth0: RealTek RTL8139 at 0xf882a800, 00:c0:9f:95:18:1b, IRQ 18
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
netconsole: not configured, aborting
ata_piix 0000:00:1f.1: version 2.11
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011810 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011818 irq 15
Switched to high resolution mode on CPU 0
ata1.00: ATA-6: FUJITSU MHU2100AT, 00000008, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA
ata1.00: configured for UDMA/100
ata2.00: ATAPI: HL-DT-ST DVDRAM GMA-4080N, 0S35, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHU2100A 0000 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GMA-4080N 0S35 PQ: 0 ANSI: 5
XXX sysfs_remove_one: acxt=c2448b3c sd=c3462ae0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448b3c sd=c3462ae0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c2448b3c sd=c3462b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2448b3c sd=c3462b40 s_sibling=00000000
s_flags=0x120
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PSM1] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
XXX sysfs_remove_one: acxt=c2510efc sd=c3489000 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2510efc sd=c3489000 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c2510efc sd=c3489060 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2510efc sd=c3489060 s_sibling=00000000
s_flags=0x120
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
Synaptics Touchpad, model: 1, fw: 5.10, id: 0x258eb1, caps: 0xa04713/0x0
input: SynPS/2 Synaptics TouchPad as /class/input/input4
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 204k freed
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c34949c0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c34949c0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494900 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494900 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494a20 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494a20 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494b40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494b40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494c60 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494c60 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c2da0 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2da0 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c2db0 sd=c3494b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2db0 sd=c3494b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34c2da0 sd=c3494c60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2da0 sd=c3494c60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c2d70 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2d70 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c2d7c sd=c3494c00 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2d7c sd=c3494c00 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c2d80 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2d80 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c2da0 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2da0 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c2db0 sd=c3494900 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2db0 sd=c3494900 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34c2da0 sd=c3494a20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2da0 sd=c3494a20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c2d70 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2d70 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c2d7c sd=c34949c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2d7c sd=c34949c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c2d80 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c2d80 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494a20 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494a20 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c34949c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c34949c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494900 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494900 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c60 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c60 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494c00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494c00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494b40 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494b40 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494b40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494b40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494c60 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494c60 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c34949c0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c34949c0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494900 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494900 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494a20 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494a20 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463db0 sd=c3494900 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3463db0 sd=c3494900 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494a20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494a20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d70 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d70 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d7c sd=c34949c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d7c sd=c34949c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463d80 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d80 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463db0 sd=c3494b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3463db0 sd=c3494b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494c60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494c60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d70 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d70 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d7c sd=c3494c00 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d7c sd=c3494c00 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463d80 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d80 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c60 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c60 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494c00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494c00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494b40 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494b40 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494a20 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494a20 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c34949c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c34949c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494900 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494900 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c34949c0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c34949c0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494900 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494900 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494a20 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494a20 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494b40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494b40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494c60 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494c60 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c2587da0 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c2587da0 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c2587db0 sd=c3494b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2587db0 sd=c3494b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c2587da0 sd=c3494c60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c2587da0 sd=c3494c60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c2587d70 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c2587d70 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c2587d7c sd=c3494c00 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c2587d7c sd=c3494c00 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c2587d80 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c2587d80 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c2587da0 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c2587da0 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c2587db0 sd=c3494900 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c2587db0 sd=c3494900 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c2587da0 sd=c3494a20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c2587da0 sd=c3494a20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c2587d70 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c2587d70 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c2587d7c sd=c34949c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c2587d7c sd=c34949c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c2587d80 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c2587d80 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494a20 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494a20 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c34949c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c34949c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494900 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494900 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c60 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c60 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494c00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494c00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494b40 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494b40 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494b40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494b40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494c60 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494c60 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c34949c0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c34949c0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494900 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494900 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494a20 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494a20 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c6da0 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6da0 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c6db0 sd=c3494900 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6db0 sd=c3494900 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34c6da0 sd=c3494a20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6da0 sd=c3494a20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c6d70 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6d70 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c6d7c sd=c34949c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6d7c sd=c34949c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c6d80 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6d80 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c6da0 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6da0 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c6db0 sd=c3494b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6db0 sd=c3494b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34c6da0 sd=c3494c60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6da0 sd=c3494c60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c6d70 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6d70 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34c6d7c sd=c3494c00 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6d7c sd=c3494c00 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34c6d80 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34c6d80 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c60 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c60 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494c00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494c00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494b40 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494b40 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494a20 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494a20 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c34949c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c34949c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494900 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494900 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c34949c0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c34949c0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494900 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494900 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494a20 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494a20 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494b40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494b40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494c60 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494c60 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463db0 sd=c3494b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3463db0 sd=c3494b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494c60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494c60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d70 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d70 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d7c sd=c3494c00 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d7c sd=c3494c00 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463d80 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d80 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463db0 sd=c3494900 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3463db0 sd=c3494900 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3463da0 sd=c3494a20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463da0 sd=c3494a20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d70 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d70 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3463d7c sd=c34949c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d7c sd=c34949c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3463d80 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3463d80 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494a20 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494a20 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c34949c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c34949c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494900 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494900 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c34948a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c34948a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfe18 sd=c3494c60 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe18 sd=c3494c60 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c34cfe08 sd=c3494c00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfe08 sd=c3494c00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfdd8 sd=c3494cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfdd8 sd=c3494cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c34cfde4 sd=c3494b40 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde4 sd=c3494b40 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c34cfde8 sd=c3494ae0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c34cfde8 sd=c3494ae0 s_sibling=00000000
s_flags=0x102
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
Clocksource tsc unstable (delta = -400590185 ns)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 18, io base 0x00001820
usb usb1: new device found, idVendor=0000, idProduct=0000
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc6-mm1 uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0100000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc6-mm1 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:01:09.2[C] -> GSI 22 (level, low) -> IRQ 21
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001840
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc6-mm1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
firewire_ohci: Added fw-ohci device 0000:01:09.2, OHCI version 1.10
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 19, io base 0x00001860
usb usb4: new device found, idVendor=0000, idProduct=0000
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.22-rc6-mm1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ACPI: EC: Handler for query 0x9 is not found!
firewire_core: created new fw device fw0 (0 config rom retries, S400)
eth0 renamed to eth2
XXX sysfs_remove_one: acxt=c353fe14 sd=c348ade0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c353fe14 sd=c348ade0 s_sibling=00000000
s_flags=0x120
net eth2: device_rename: sysfs_create_symlink failed (-17)
eth2: link down
ADDRCONF(NETDEV_UP): eth2: link is not ready
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Yenta: CardBus bridge found at 0000:01:09.0 [103c:3080]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:01:09.0, mfunc 0x01a01b22, devctl 0x64
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.0kmr
ipw2200: Copyright(c) 2003-2006 Intel Corporation
Yenta: ISA IRQ mask 0x0cf8, PCI irq 16
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
pcmcia: parent PCI bridge Memory window: 0xe0200000 - 0xe02fffff
pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
sdhci: SDHCI controller found at 0000:01:09.4 [104c:8034] (rev 0)
sdhci [sdhci_probe()]: found 3 slot(s)
ACPI: PCI Interrupt 0000:01:09.4[A] -> GSI 20 (level, low) -> IRQ 16
sdhci [sdhci_probe_slot()]: slot 0 at 0xe0208400, irq 16
sdhci: ============== REGISTER DUMP ==============
sdhci: Sys addr: 0x00000000 | Version:  0x00008400
sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
sdhci: Present:  0x00020000 | Host ctl: 0x00000000
sdhci: Power:    0x00000000 | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00000002
sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
sdhci: Caps:     0x01821090 | Max curr: 0x00000000
sdhci: ===========================================
mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
mmc0: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc0: clock 62500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
mmc0: starting CMD0 arg 00000000 flags 00000040
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
mmc0: req done (CMD0): 1/0/0: 00000000 00000000 00000000 00000000
mmc0: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc0: starting CMD8 arg 000001aa flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
mmc0: req done (CMD8): 1/0/0: 00000000 00000000 00000000 00000000
mmc0: SDHCI at 0xe0208400 irq 16 DMA
sdhci [sdhci_probe_slot()]: slot 1 at 0xe0208000, irq 16
sdhci: ============== REGISTER DUMP ==============
sdhci: Sys addr: 0x00000000 | Version:  0x00008400
sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
sdhci: Present:  0x00020000 | Host ctl: 0x00000000
sdhci: Power:    0x00000000 | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00000002
sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
sdhci: Caps:     0x01821090 | Max curr: 0x00000000
sdhci: ===========================================
mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
mmc1: SDHCI at 0xe0208000 irq 16 DMA
sdhci [sdhci_probe_slot()]: slot 2 at 0xe0207c00, irq 16
sdhci: ============== REGISTER DUMP ==============
sdhci: Sys addr: 0x00000000 | Version:  0x00008400
sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
sdhci: Present:  0x000a0000 | Host ctl: 0x00000000
sdhci: Power:    0x00000000 | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00000002
sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
sdhci: Caps:     0x01821898 | Max curr: 0x00000000
sdhci: ===========================================
mmc2: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
mmc2: SDHCI at 0xe0207c00 irq 16 DMA
mmc0: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc0: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc0: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc0: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc0: starting CMD1 arg 00000000 flags 00000061
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (1)
mmc0: req done (CMD1): 1/0/0: 00000000 00000000 00000000 00000000
mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
mmc1: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
mmc1: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc1: clock 62500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
mmc1: starting CMD0 arg 00000000 flags 00000040
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
mmc1: req done (CMD0): 1/0/0: 00000000 00000000 00000000 00000000
mmc1: clock 62500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc1: starting CMD8 arg 000001aa flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
mmc1: req done (CMD8): 1/0/0: 00000000 00000000 00000000 00000000
mmc1: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc1: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc1: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc1: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc1: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc1: starting CMD1 arg 00000000 flags 00000061
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (1)
mmc1: req done (CMD1): 1/0/0: 00000000 00000000 00000000 00000000
mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
mmc2: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
mmc2: clock 93750Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc2: clock 93750Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
mmc2: starting CMD0 arg 00000000 flags 00000040
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
mmc2: req done (CMD0): 1/0/0: 00000000 00000000 00000000 00000000
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.5 to 64
mmc2: clock 93750Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc2: starting CMD8 arg 000001aa flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
mmc2: req done (CMD8): 1/0/0: 00000000 00000000 00000000 00000000
mmc2: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc2: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc2: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc2: starting CMD55 arg 00000000 flags 00000075
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
mmc2: req done (CMD55): 1/0/0: 00000000 00000000 00000000 00000000
mmc2: starting CMD1 arg 00000000 flags 00000061
sdhci [sdhci_tasklet_finish()]: Ending request, cmd (1)
mmc2: req done (CMD1): 1/0/0: 00000000 00000000 00000000 00000000
mmc2: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
intel8x0_measure_ac97_clock: measured 52056 usecs
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:01:06.0[A] -> GSI 18 (level, low) -> IRQ 19
ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
XXX sysfs_remove_one: acxt=c3598c0c sd=c36ba780 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3598c0c sd=c36ba780 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3598c0c sd=c36ba840 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3598c0c sd=c36ba840 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3598c0c sd=c36ba7e0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3598c0c sd=c36ba7e0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3598bfc sd=c36ba720 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3598bfc sd=c36ba720 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3598bcc sd=c36ba900 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3598bcc sd=c36ba900 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3598bd8 sd=c36ba8a0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3598bd8 sd=c36ba8a0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3598bfc sd=c36ba9c0 s_flags=0x104 cnt=1
XXX sysfs_remove_one: acxt=c3598bfc sd=c36ba960 s_flags=0x108 cnt=2
XXX sysfs_addrm_finish: acxt=c3598bfc sd=c36ba960 s_sibling=00000000
s_flags=0x108
XXX sysfs_addrm_finish: acxt=c3598bfc sd=c36ba9c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3598bdc sd=c36ba6c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3598bdc sd=c36ba6c0 s_sibling=00000000
s_flags=0x102
ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a channels)
eth0 renamed to eth3
XXX sysfs_remove_one: acxt=c36b0e14 sd=c36ba900 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c36b0e14 sd=c36ba900 s_sibling=00000000
s_flags=0x120
net eth3: device_rename: sysfs_create_symlink failed (-17)
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b09c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b09c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0ba0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0ba0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682da0 sd=c36b0ae0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da0 sd=c36b0ae0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682d9c sd=c36b0c60 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d9c sd=c36b0c60 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682d9c sd=c36b0cc0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d9c sd=c36b0cc0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682d94 sd=c36b0a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d94 sd=c36b0a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682da0 sd=c36b0a20 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da0 sd=c36b0a20 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3682da4 sd=c36b0960 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da4 sd=c36b0960 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0a20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0a20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0ae0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0ae0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682da0 sd=c36b0c60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da0 sd=c36b0c60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682d9c sd=c36b0ba0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d9c sd=c36b0ba0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682d9c sd=c36b09c0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d9c sd=c36b09c0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682d94 sd=c36b0cc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d94 sd=c36b0cc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682da0 sd=c36b0a80 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da0 sd=c36b0a80 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3682da4 sd=c36b0960 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da4 sd=c36b0960 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0ae0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0ae0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0c00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0c00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682dc4 sd=c36b0c60 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682dc4 sd=c36b0c60 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682da0 sd=c36b0ba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da0 sd=c36b0ba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682d9c sd=c36b0b40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d9c sd=c36b0b40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682d9c sd=c36b0a20 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d9c sd=c36b0a20 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c3682d94 sd=c36b09c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c3682d94 sd=c36b09c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c3682da0 sd=c36b0cc0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da0 sd=c36b0cc0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c3682da4 sd=c36b0960 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c3682da4 sd=c36b0960 s_sibling=00000000
s_flags=0x102
lp: driver loaded but no devices found
EXT3 FS on sda10, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a4000 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a4000 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a4060 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a4060 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a40c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a40c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a4120 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a4120 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a4180 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a4180 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a41e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a41e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a4240 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a4240 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a42a0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a42a0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a4300 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a4300 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a4360 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a4360 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee6c sd=c37a43c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee6c sd=c37a43c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee78 sd=c36bdf60 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee78 sd=c36bdf60 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c36aee84 sd=c36bdea0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee84 sd=c36bdea0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee84 sd=c36bdf00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee84 sd=c36bdf00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c36aee5c sd=c36bde40 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee5c sd=c36bde40 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c36aee5c sd=c36bdde0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c36aee5c sd=c36bdde0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c373be08 sd=c37a4300 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c373be08 sd=c37a4300 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c373be18 sd=c37a42a0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c373be18 sd=c37a42a0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c373be08 sd=c37a4360 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c373be08 sd=c37a4360 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c373bdd8 sd=c37a41e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c373bdd8 sd=c37a41e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c373bde4 sd=c37a4240 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c373bde4 sd=c37a4240 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c373bde8 sd=c37a43c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c373bde8 sd=c37a43c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c373be08 sd=c37a40c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c373be08 sd=c37a40c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c373be18 sd=c37a4060 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c373be18 sd=c37a4060 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c373be08 sd=c37a4120 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c373be08 sd=c37a4120 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c373bdd8 sd=c37a4420 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c373bdd8 sd=c37a4420 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c373bde4 sd=c37a4000 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c373bde4 sd=c37a4000 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c373bde8 sd=c37a4180 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c373bde8 sd=c37a4180 s_sibling=00000000
s_flags=0x102
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 18
[drm] Initialized i915 1.6.0 20060119 on minor 0
[drm] Initialized i915 1.6.0 20060119 on minor 1
XXX sysfs_remove_one: acxt=c58aed70 sd=c346b4e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c58aed70 sd=c346b4e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5898d54 sd=c370ba20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5898d54 sd=c370ba20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5898d54 sd=c370ba80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5898d54 sd=c370ba80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5898d54 sd=c370bae0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5898d54 sd=c370bae0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5898d54 sd=c370bb40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5898d54 sd=c370bb40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5898d54 sd=c370bba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5898d54 sd=c370bba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5898d54 sd=c370bc00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5898d54 sd=c370bc00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5898d60 sd=c370b9c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c5898d60 sd=c370b9c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c5bcaf14 sd=c37b6ea0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcaf14 sd=c37b6ea0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcaee0 sd=c37b6de0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcaee0 sd=c37b6de0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcaee0 sd=c37b6d80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcaee0 sd=c37b6d80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcaec0 sd=c3774e40 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcaec0 sd=c3774e40 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c5bcaec0 sd=c3774ea0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcaec0 sd=c3774ea0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c5bcae74 sd=c3774f00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c3774f00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c3774f60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c3774f60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba000 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba000 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba060 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba060 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba0c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba0c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba120 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba120 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba180 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba180 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba1e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba1e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba240 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba240 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba2a0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba2a0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba300 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba300 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba360 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba360 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba3c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba3c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba420 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba420 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba480 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba480 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba4e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba4e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba540 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba540 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba5a0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba5a0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba600 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba600 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae74 sd=c36ba660 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae74 sd=c36ba660 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae54 sd=c36ba960 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae54 sd=c36ba960 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c5bcae54 sd=c37b6f00 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae54 sd=c37b6f00 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c5bcae54 sd=c36ba8a0 s_flags=0x120 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae54 sd=c36ba8a0 s_sibling=00000000
s_flags=0x120
XXX sysfs_remove_one: acxt=c5bcae44 sd=c36ba9c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae44 sd=c36ba9c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c36baea0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c36baea0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c36baf00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c36baf00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c36baf60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c36baf60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6000 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6000 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6060 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6060 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b60c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b60c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6120 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6120 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6180 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6180 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b61e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b61e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6240 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6240 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b62a0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b62a0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6300 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6300 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6360 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6360 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b63c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b63c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6420 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6420 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6480 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6480 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b64e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b64e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6540 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6540 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b65a0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b65a0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6600 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6600 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6660 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6660 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b66c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b66c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6720 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6720 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae10 sd=c36bae40 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae10 sd=c36bae40 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b67e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b67e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6840 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6840 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b68a0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b68a0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6900 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6900 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6960 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6960 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b69c0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b69c0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6a20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6a20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6a80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6a80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6ae0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6ae0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae04 sd=c37b6b40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae04 sd=c37b6b40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae10 sd=c37b6780 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae10 sd=c37b6780 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36ba720 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36ba720 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36ba7e0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36ba7e0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36ba840 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36ba840 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36ba780 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36ba780 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36baa20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36baa20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36baa80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36baa80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36baae0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36baae0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36bab40 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36bab40 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36baba0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36baba0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36bac00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36bac00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36bac60 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36bac60 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36bacc0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36bacc0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36bad20 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36bad20 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36bad80 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36bad80 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c36bade0 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c36bade0 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae14 sd=c37b6c00 s_flags=0x104 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae14 sd=c37b6c00 s_sibling=00000000
s_flags=0x104
XXX sysfs_remove_one: acxt=c5bcae20 sd=c37b6ba0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae20 sd=c37b6ba0 s_sibling=00000000
s_flags=0x102
XXX sysfs_remove_one: acxt=c5bcae24 sd=c36ba6c0 s_flags=0x102 cnt=1
XXX sysfs_addrm_finish: acxt=c5bcae24 sd=c36ba6c0 s_sibling=00000000
s_flags=0x102
XXX sysfs_deactivate: sd=c36ba6c0 s_sibling=6b6b6b6b s_flags=0x6b6b6b6b
------------[ cut here ]------------
kernel BUG at fs/sysfs/dir.c:274!
invalid opcode: 0000 [#1]
PREEMPT
Modules linked in: i915 drm cpufreq_conservative cpufreq_powersave
cpufreq_performance firewire_sbp2 parport_pc lp parport pcmcia
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
ipw2200 snd_seq_dummy sdhci yenta_socket rsrc_nonstatic pcmcia_core
ieee80211 ieee80211_crypt mmc_core snd_seq_oss snd_seq_midi_event
snd_seq snd_timer snd_seq_device iTCO_wdt iTCO_vendor_support snd
soundcore snd_page_alloc firewire_ohci firewire_core crc_itu_t
ehci_hcd uhci_hcd usbcore
CPU:    0
EIP:    0060:[<c01a7813>]    Not tainted VLI
EFLAGS: 00010202   (2.6.22-rc6-mm1 #6)
EIP is at sysfs_addrm_finish+0x20b/0x278
eax: 00000001   ebx: c5bcadc0   ecx: c058aa40   edx: 00000001
esi: c5bcade8   edi: c36ba6c0   ebp: c5bcae1c   esp: c5bcada8
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process modprobe (pid: 3648, ti=c5bca000 task=c5af6d60 task.ti=c5bca000)
Stack: c046b41c c36ba6c0 6b6b6b6b 6b6b6b6b 00000102 c5bcae24 00000000 00000001
       dead4ead ffffffff ffffffff c0657cf0 00000000 c04635a1 c5bcade0 c5bcade0
       00000000 00000001 dead4ead ffffffff ffffffff c0657cf0 00000000 c04635a1
Call Trace:
 [<c01a78ae>] remove_dir+0x2e/0x35
 [<c01a790f>] __sysfs_remove_dir+0x5a/0x61
 [<c01a794c>] sysfs_remove_dir+0x2c/0x30
 [<c0239402>] kobject_del+0xf/0x19
 [<c02b7746>] device_del+0x254/0x27a
 [<c0321295>] netdev_unregister_sysfs+0x1b/0x1e
 [<c031692f>] unregister_netdevice+0x1c3/0x1fe
 [<c031697c>] unregister_netdev+0x12/0x1a
 [<f89ab02f>] ipw_pci_remove+0x59/0x1c4 [ipw2200]
 [<c0252ca8>] pci_device_remove+0x19/0x39
 [<c02b96ee>] __device_release_driver+0x74/0x90
 [<c02b9ba3>] driver_detach+0x9a/0xd7
 [<c02b926f>] bus_remove_driver+0x5d/0x79
 [<c02b9c07>] driver_unregister+0x8/0xa
 [<c0252e12>] pci_unregister_driver+0x13/0x55
 [<f89abc51>] ipw_exit+0x1c/0x1e [ipw2200]
 [<c0144427>] sys_delete_module+0x1bd/0x22a
 [<c01040be>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Code: c7 04 24 1c b4 46 c0 e8 6a 85 f7 ff 83 7f 0c 00 75 06 f6 47 1d
01 75 6e ba 01 00 00 00 b8 40 aa 58 c0 e8 9d 5e 0a 00 85 c0 74 04 <0f>
0b eb fe 8d 55 a4 89 57 0c b8 00 00 00 80 0f c1 47 04 85 c0
EIP: [<c01a7813>] sysfs_addrm_finish+0x20b/0x278 SS:ESP 0068:c5bcada8
