Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYGOFki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYGOFki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYGOFkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:40:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23996 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbYGOFkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=wYngGe2yYLKLNAK321LiQ6+H46vvITdtZE8ilWtI47iJnftcFXMWd+XynBy1FwL8Ii
         bU8YdEXHP7x4iDeQmmBYS+KXMDY/p5expymlNSQ17VYpddRBWw1pjpja0XK4zOGFTGlZ
         vNF66SZcWq9CioLjiqU7+kpQZK2EqSHmBUG38=
Date: Tue, 15 Jul 2008 07:40:40 +0200
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ide-floppy fix
Message-ID: <20080715054040.GA19532@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	stable@kernel.org
References: <20080715053356.GA18628@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080715053356.GA18628@gollum.tnic>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 07:33:56AM +0200, Borislav Petkov wrote:
> Hi Bart,
> 
> i broke ide-floppy for Iomega ZIP drives with the last round of generic patches
> and now it works only sometimes during write requests. The reason for it is that
> the command issue path is not being delayed with a 50msec timeout, for details
> see the comment in idefloppy_start_pc(). Anyway, attached is a fix that should
> go into the -stable kernel too since the driver is now broken in 2.6.26.
> 
> On a different note, the current pata tree on top of v2.6.25-2125-g50515af blows
> up here with the following error:
> 
> 
> [    4.296729] Uniform Multi-Platform E-IDE driver
> [    4.297905] ICH4: IDE controller (0x8086:0x24cb rev 0x02) at  PCI slot 0000:00:1f.1
> [    4.297986] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> [    4.298153] ICH4: not 100% native mode: will probe irqs later
> [    4.298213]     ide0: BM-DMA at 0xfc00-0xfc07
> [    4.298282]     ide1: BM-DMA at 0xfc08-0xfc0f
> [    4.561768] hda: QUANTUM FIREBALLlct10 20, ATA DISK drive
> [    4.816724] hdb: SAMSUNG SP2014N, ATA DISK drive
> [    4.867959] hda: drive side 80-wire cable detection failed, limiting max speed to UDMA33
> [    4.868027] hda: UDMA/33 mode selected
> [    4.868441] hdb: UDMA/100 mode selected
> [    5.540683] hdc: IOMEGA ZIP 100 ATAPI, ATAPI FLOPPY drive
> [    5.795564] hdd: IC35L120AVV207-0, ATA DISK drive
> [    5.847295] hdd: host side 80-wire cable detection failed, limiting max speed to UDMA33
> [    5.847362] hdd: UDMA/33 mode selected
> [    5.847715] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    5.855487] ide1 at 0x170-0x177,0x376 on irq 15
> [    5.875927] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    5.876012] ide_generic: I/O resource 0x1F0-0x1F7 not free.
> [    5.876074] ide_generic: I/O resource 0x170-0x177 not free.
> [   11.342504] hde: no response (status = 0xa1), resetting drive
> [   17.206535] hdf: no response (status = 0xa1), resetting drive
> [   17.614474] ------------[ cut here ]------------
> [   17.614528] WARNING: at lib/kref.c:43 kref_get+0x1a/0x20()
> [   17.614586] Modules linked in:
> [   17.614681] Pid: 1, comm: swapper Not tainted 2.6.26 #33
> [   17.614738]  [<c01220e9>] warn_on_slowpath+0x41/0x7b
> [   17.614839]  [<c02efa9a>] ? _spin_unlock_irq+0x2d/0x42
> [   17.614980]  [<c011d1e7>] ? finish_task_switch+0x47/0x94
> [   17.615118]  [<c011d1cb>] ? finish_task_switch+0x2b/0x94
> [   17.615257]  [<c02effa8>] ? __reacquire_kernel_lock+0x33/0x37
> [   17.615396]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.615552]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.615693]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.615830]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.615968]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.616107]  [<c01d86ae>] kref_get+0x1a/0x20
> [   17.616204]  [<c01d7c39>] kobject_get+0x12/0x17
> [   17.616301]  [<c01d7ce0>] kobject_add_internal+0x44/0x14f
> [   17.616399]  [<c01d7e69>] kobject_add_varg+0x4a/0x4c
> [   17.617153]  [<c01d7ed0>] kobject_add+0x43/0x49
> [   17.617252]  [<c022a5dd>] device_add+0x91/0x48e
> [   17.617353]  [<c022a2aa>] ? device_initialize+0xd7/0xf8
> [   17.617510]  [<c022a9ec>] device_register+0x12/0x15
> [   17.617606]  [<c02376b1>] ide_host_register+0x284/0x537
> [   17.617706]  [<c0237af8>] ? ide_host_alloc_all+0x123/0x178
> [   17.617845]  [<c04227ba>] ide_generic_init+0x142/0x1e7
> [   17.617946]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.618084]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.618226]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.618363]  [<c02efa9a>] ? _spin_unlock_irq+0x2d/0x42
> [   17.618516]  [<c011d1e7>] ? finish_task_switch+0x47/0x94
> [   17.618655]  [<c02effa8>] ? __reacquire_kernel_lock+0x33/0x37
> [   17.618796]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.618938]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.619077]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.619218]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.619357]  [<c02eeb4d>] ? mutex_unlock+0x8/0xa
> [   17.619512]  [<c01a0334>] ? sysfs_addrm_finish+0x17/0x1cd
> [   17.619649]  [<c02efb2e>] ? _spin_unlock+0x27/0x3c
> [   17.619788]  [<c017bad9>] ? ifind+0x7e/0x88
> [   17.619926]  [<c019fdd8>] ? sysfs_ilookup_test+0x0/0x11
> [   17.620068]  [<c019ffa7>] ? sysfs_find_dirent+0x16/0x27
> [   17.620206]  [<c01a00a0>] ? sysfs_add_one+0x14/0x85
> [   17.620344]  [<c019fc8e>] ? sysfs_add_file_mode+0x4e/0x6d
> [   17.620502]  [<c019fcbb>] ? sysfs_add_file+0xe/0x13
> [   17.620637]  [<c040d2eb>] kernel_init+0x127/0x257
> [   17.620739]  [<c0422678>] ? ide_generic_init+0x0/0x1e7
> [   17.620879]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.621019]  [<c01dbe18>] ? trace_hardirqs_on_thunk+0xc/0x10
> [   17.621159]  [<c0102eb6>] ? restore_nocheck_notrace+0x0/0xe
> [   17.621298]  [<c040d1c4>] ? kernel_init+0x0/0x257
> [   17.621438]  [<c040d1c4>] ? kernel_init+0x0/0x257
> [   17.621591]  [<c0103a8f>] kernel_thread_helper+0x7/0x10
> [   17.621691]  =======================
> [   17.621759] ---[ end trace 01bb572fb1fb92e8 ]---
> [   17.621835] BUG: unable to handle kernel paging request at 6f690074
> [   17.621968] IP: [<6f690074>]
> [   17.622060] *pde = 00000000 
> [   17.622153] Oops: 0000 [#1] PREEMPT SMP 
> [   17.622370] Modules linked in:
> [   17.622458] 
> [   17.622506] Pid: 1, comm: swapper Tainted: G        W (2.6.26 #33)
> [   17.622617] EIP: 0060:[<6f690074>] EFLAGS: 00010206 CPU: 0
> [   17.622670] EIP is at 0x6f690074
> [   17.622720] EAX: dfa1b5c8 EBX: c03e630c ECX: 6f690074 EDX: c01ec367
> [   17.622774] ESI: dfa1b5c8 EDI: c069bd4c EBP: df82fc24 ESP: df82fc14
> [   17.622884]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   17.622937] Process swapper (pid: 1, ti=df82e000 task=df830000 task.ti=df82e000)
> [   17.622992] Stack: c01ec382 c03e630c dfa1b614 00000000 df82fc34 c02e11c6 c03e630c dfa1b614 
> [   17.623379]        df82fc44 c02e1255 dfa1b5e8 dfa1b5e8 df82fc74 c022a8cf dfa1b6e4 dfa1b6c0 
> [   17.623379]        c03e630c dfa1b5e8 00000000 00000000 c022a2aa dfa1b5e8 dfa1b5e8 00000006 
> [   17.623379] Call Trace:
> [   17.623379]  [<c01ec382>] ? pci_device_suspend+0x1b/0x4d
> [   17.623379]  [<c02e11c6>] ? klist_node_init+0x36/0x3a
> [   17.623379]  [<c02e1255>] ? klist_add_tail+0x12/0x38
> [   17.623379]  [<c022a8cf>] ? device_add+0x383/0x48e
> [   17.623379]  [<c022a2aa>] ? device_initialize+0xd7/0xf8
> [   17.623379]  [<c022a9ec>] ? device_register+0x12/0x15
> [   17.623379]  [<c02376b1>] ? ide_host_register+0x284/0x537
> [   17.623379]  [<c0237af8>] ? ide_host_alloc_all+0x123/0x178
> [   17.623379]  [<c04227ba>] ? ide_generic_init+0x142/0x1e7
> [   17.623379]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.623379]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.623379]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.623379]  [<c02efa9a>] ? _spin_unlock_irq+0x2d/0x42
> [   17.623379]  [<c011d1e7>] ? finish_task_switch+0x47/0x94
> [   17.623379]  [<c02effa8>] ? __reacquire_kernel_lock+0x33/0x37
> [   17.623379]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.623379]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.623379]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.623379]  [<c013d1d9>] ? trace_hardirqs_on+0xb/0xd
> [   17.623379]  [<c02eeb4d>] ? mutex_unlock+0x8/0xa
> [   17.623379]  [<c01a0334>] ? sysfs_addrm_finish+0x17/0x1cd
> [   17.623379]  [<c02efb2e>] ? _spin_unlock+0x27/0x3c
> [   17.623379]  [<c017bad9>] ? ifind+0x7e/0x88
> [   17.623379]  [<c019fdd8>] ? sysfs_ilookup_test+0x0/0x11
> [   17.623379]  [<c019ffa7>] ? sysfs_find_dirent+0x16/0x27
> [   17.623379]  [<c01a00a0>] ? sysfs_add_one+0x14/0x85
> [   17.623379]  [<c019fc8e>] ? sysfs_add_file_mode+0x4e/0x6d
> [   17.623379]  [<c019fcbb>] ? sysfs_add_file+0xe/0x13
> [   17.623379]  [<c040d2eb>] ? kernel_init+0x127/0x257
> [   17.623379]  [<c0422678>] ? ide_generic_init+0x0/0x1e7
> [   17.623379]  [<c013d1ad>] ? trace_hardirqs_on_caller+0xe1/0x102
> [   17.623379]  [<c01dbe18>] ? trace_hardirqs_on_thunk+0xc/0x10
> [   17.623379]  [<c0102eb6>] ? restore_nocheck_notrace+0x0/0xe
> [   17.623379]  [<c040d1c4>] ? kernel_init+0x0/0x257
> [   17.623379]  [<c040d1c4>] ? kernel_init+0x0/0x257
> [   17.623379]  [<c0103a8f>] ? kernel_thread_helper+0x7/0x10
> [   17.623379]  =======================
> [   17.623379] Code:  Bad EIP value.
> [   17.623379] EIP: [<6f690074>] 0x6f690074 SS:ESP 0068:df82fc14
> [   17.630502] ---[ end trace 01bb572fb1fb92e8 ]---
> [   17.630557] Kernel panic - not syncing: Attempted to kill init!
> 
> I tracked the error down to the call to ide_register_port(hwif) in
> ide-probe.c:ide_host_register() which does device_register(&hwif->gendev) and
> the hwif->gendev->kobj seems unitialized thus the WARN_ON on its refcount in

i mean hwif->gendev->kobj->parent here.

> kref_get(). Will look into it more when i get some free time.
> 
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> 
> Check the correct flags-location for set features.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> ---
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index 97cabfd..ddabad9 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -257,7 +257,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
>  	}
>  
>  	/* Send the actual packet */
> -	if ((pc->flags & IDE_DFLAG_ZIP_DRIVE) == 0)
> +	if ((drive->dev_flags & IDE_DFLAG_ZIP_DRIVE) == 0)
>  		hwif->tp_ops->output_data(drive, NULL, rq->cmd, 12);
>  
>  	return ide_started;
> -- 
> Regards/Gruﬂ,
>     Boris.

-- 
Regards/Gruﬂ,
    Boris.
