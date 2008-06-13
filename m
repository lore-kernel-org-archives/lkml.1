Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYFMBHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYFMBHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbYFMBHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:07:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757724AbYFMBHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:07:20 -0400
Date: Thu, 12 Jun 2008 18:06:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Kidwell <benjkidwell@yahoo.com>
Cc: linux-kernel@vger.kernel.org, benjkidwell@yahoo.com,
       Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.26-rc5-mm3 reproducible BUG and build failures
Message-Id: <20080612180642.f92c3538.akpm@linux-foundation.org>
In-Reply-To: <314477.88718.qm@web53707.mail.re2.yahoo.com>
References: <314477.88718.qm@web53707.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 13:41:45 -0700 (PDT)
Benjamin Kidwell <benjkidwell@yahoo.com> wrote:

> Working with 2.6.26-rc5-mm3 on a pair of test x86 boxes (a p4 and a c2d) both
> running Ubuntu 8.04. I've had two issues.

Thanks for the report.

> 1) The build process fails with certain config options. I have reproduced this
> on 2 machines. 
> 
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> mm/built-in.o: In function `__munlock_vma_pages_range':
> mlock.c:(.text+0x11567): undefined reference to `walk_page_range'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2

Please send the offending .config.  Be sure to Cc Rik :)

> After changing a few .config options I have been able to compile successfully.
> I believe the setting that triggers the build failure is:
> # CONFIG_PROC_PAGE_MONITOR is not set
> With =y the make process went fine on both of my test boxes. If I'm mistaken
> on this, I can provide a full diff of the building/nonbuilding configs.
> 
> 2nd: I get the following BUG every startup on the P4. I think it triggers when
> GDM starts, triggered by playing back a sound sample. This box is known to
> have buggy sound controller, see http://lkml.org/lkml/2008/6/6/408 and
> followups. I think Takashi-san's sound-unstable tree already has some code
> relevant to this chip's issues, but I don't know if this BUG is related, or
> not. GDM login seems to work but it goes to a white screen when trying to load
> Gnome desktop. TTYs still work so I was able to save the following. 
> 
> [   33.165017] Kernel BUG at c0141256 [verbose debug info unavailable]
> [   33.165017] invalid opcode: 0000 [#1] SMP 
> [   33.165017] last sysfs file:
> /sys/devices/pci0000:00/0000:00:14.4/0000:01:03.0/resource
> [   33.165017] Modules linked in: ipv6 sbs sbshc container battery
> iptable_filter ip_tables x_tables ac loop af_packet snd_hda_intel snd_pcm
> serio_raw i2c_piix4 snd_timer psmouse i2c_core snd soundcore snd_page_alloc
> ati_agp agpgart button evdev ext3 jbd mbcache sd_mod ide_cd_mod cdrom
> pata_atiixp usbhid hid sata_sil pata_acpi 8139too ata_generic atiixp 8139cp
> mii ohci_hcd ehci_hcd libata scsi_mod dock ide_pci_generic ide_core usbcore
> thermal processor fan fuse
> [   33.165017] 
> [   33.165017] Pid: 5400, comm: aplay Not tainted (2.6.26-rc5-mm3mmtry #1)
> [   33.165017] EIP: 0060:[<c0141256>] EFLAGS: 00010246 CPU: 0
> [   33.165017] EIP is at unlock_page+0xe/0x23
> [   33.165017] EAX: 00000000 EBX: c14add60 ECX: 00000000 EDX: c14add60
> [   33.165017] ESI: 00000001 EDI: c14add60 EBP: eeed6630 ESP: eef79dec
> [   33.165017]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   33.165017] Process aplay (pid: 5400, ti=eef79000 task=eec6b960
> task.ti=eef79000)
> [   33.165017] Stack: 00000000 c0149c37 0000000e 000040ca c0131baf 00000000
> 00000000 00000000 
> [   33.165017]        ffffffff 0000000e 00000000 c14add60 c14add80 c14adda0
> c14addc0 c14adde0 
> [   33.165017]        c14ade00 c14aef00 c14aef20 c14aef40 c14aef60 c14aef80
> c14aefa0 c14aefc0 
> [   33.165017] Call Trace:
> [   33.165017]  [<c0149c37>] truncate_inode_pages_range+0xc4/0x336
> [   33.165017]  [<c0131baf>] getnstimeofday+0x37/0xdf
> [   33.165018]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
> [   33.165018]  [<c0149ec0>] truncate_inode_pages+0x17/0x27
> [   33.165018]  [<c015d60f>] shmem_delete_inode+0x48/0xb6
> [   33.165018]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
> [   33.165018]  [<c0172fc1>] generic_delete_inode+0x7f/0x100
> [   33.165018]  [<c01726c4>] iput+0x44/0x4a
> [   33.165018]  [<c017069a>] d_kill+0x2b/0x44
> [   33.165018]  [<c01717d6>] dput+0xc3/0x16f
> [   33.165018]  [<c016237d>] __fput+0x117/0x16f
> [   33.165018]  [<c01a373c>] shm_destroy+0x36/0x3e
> [   33.165018]  [<c01a43e1>] sys_shmctl+0x60b/0x61e
> [   33.165018]  [<c01764a7>] mnt_drop_write+0x1d/0xd4
> [   33.165018]  [<c01a364f>] sys_shmdt+0x10f/0x139
> [   33.165018]  [<c0106799>] sys_ipc+0x42/0x28e
> [   33.165018]  [<c01535e6>] sys_munmap+0x30/0x35
> [   33.165018]  [<c0102de1>] sysenter_past_esp+0x6a/0x91
> [   33.165018]  [<c0280000>] setup_local_APIC+0x3f/0x1aa
> [   33.165018]  =======================
> [   33.165018] Code: 74 09 8b 52 08 85 d2 74 02 ff d2 e8 37 0d 14 00 31 c0 8d
> 76 00 c3 ba a0 fa 2f c0 eb de 53 89 c3 f0 0f ba 30 00 19 c0 85 c0 75 04 <0f>
> 0b eb fe 89 d8 e8 7f f4 ff ff 31 c9 89 da 5b e9 9e b8 fe ff 
> [   33.165018] EIP: [<c0141256>] unlock_page+0xe/0x23 SS:ESP 0068:eef79dec
> [   33.165018] ---[ end trace f0d41f68fa3deb86 ]---

Yup, thanks, Kamalesh hit something that also.

