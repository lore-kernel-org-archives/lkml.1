Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXEFPDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXEFPDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 11:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXEFPDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 11:03:03 -0400
Received: from anchor-fallback-93.mail.demon.net ([194.217.242.93]:53895 "EHLO
	anchor-fallback-93.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752AbXEFPDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 11:03:00 -0400
Subject: Re: [FW  ide-cs] Re: jvc cdrom drive lockup
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
References: <1178202559.3767.21.camel@localhost.localdomain>
	 <20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
Content-Type: text/plain
Date: Sun, 06 May 2007 16:00:19 +0100
Message-Id: <1178463619.3793.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 23:32 +0900, Komuro wrote:
> On Thu, 03 May 2007 15:29:19 +0100
> Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> 
> 
> IDE bugs should be posted to the linux-ide mailing list.
> 
> 
> > Hi all, 
> > I have a JVC MP-CDX1 cdrom drive that came with my laptop which used to
> > work with ide-cs but stopped working with newer kernels.
> > 
> > I added its ident to ide-cs.c (see patch below) and the drive now is
> > detected and gets mounted when plugged in and seems to work correctly.
> > 
> > But when I eject the card, pccardctl eject 0, the laptop locks up
> > completely, there are no messages in the log, and the fan goes to full
> > speed so I guess the cpu is running at 100%.
> > Any ideas what's going wrong or how to debug it ? 
> > Is there anything else I need to patch to get this working ?
> > 
> > Thanks
> > Richard
> > 
> > card info :- 
> > 
> > PRODID_1="KME"
> > PRODID_2="KXLC005"
> > PRODID_3="00"
> > PRODID_4=""
> > MANFID=0032,2904
> > FUNCID=8
> > 
> > log messages on insert :- 
> > 
> > May  3 11:22:52 mininote kernel: pccard: PCMCIA card inserted into slot 0
> > May  3 11:22:52 mininote kernel: cs: memory probe 0xa0000000-0xa0ffffff: clean.
> > May  3 11:22:52 mininote kernel: pcmcia: registering new device pcmcia0.0
> > May  3 11:22:53 mininote kernel: hdc: UJDB130, ATAPI CD/DVD-ROM drive
> > May  3 11:22:53 mininote kernel: ide1 at 0x190-0x197,0x396 on irq 3
> > May  3 11:22:53 mininote kernel: ide-cs: hdc: Vpp = 0.0
> > May  3 11:22:54 mininote kernel: hdc: ATAPI 20X CD-ROM drive, 128kB Cache
> > May  3 11:22:54 mininote kernel: Uniform CD-ROM driver Revision: 3.20
> > May  3 11:23:04 mininote hald: mounted /dev/hdc on behalf of uid 500
> > May  3 11:23:34 mininote hald: unmounted /dev/hdc from '/media/FC_4 i386 ftp #1' on behalf of uid 500
> > May  3 11:24:17 mininote kernel: pccard: card ejected from slot 0
> > << lockup happened here >>
> > 
> > patch
> > --- linux-2.6.21.1/drivers/ide/legacy/ide-cs.c.orig	2007-05-02 12:09:57.000000000 +0100
> > +++ linux-2.6.21.1/drivers/ide/legacy/ide-cs.c	2007-05-02 12:12:40.000000000 +0100
> > @@ -362,6 +362,7 @@
> >  	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
> >  	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
> >  	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
> > +	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x2904),        /* KME KXLCOO5 JVC MP-CDX1 */
> >  	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
> >  	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
> >  	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
> > 
> >    
> > 
> 
> Best Regards
> Komuro

I rebuilt the kernel with the lock dependency checking turned on, which
shows up 2 problems (and also breaks the deadlock).

kernel: pccard: card ejected from slot 0
kernel: 
kernel: ======================================================
kernel: [ INFO: hard-safe -> hard-unsafe lock order detected ]
kernel: 2.6.21.1rsk #2
kernel: ------------------------------------------------------
kernel: pccardctl/3066 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
kernel:  (resource_lock){--..}, at: [<c04222e4>] __release_region+0x32/0xff
kernel: 
kernel: and this task is already holding:
kernel:  (ide_lock){++..}, at: [<c054c2a5>] ide_unregister+0x112/0x573
kernel: which would create a new lock dependency:
kernel:  (ide_lock){++..} -> (resource_lock){--..}
kernel: 
kernel: but this new dependency connects a hard-irq-safe lock:
kernel:  (ide_lock){++..}
kernel: ... which became hard-irq-safe at:
kernel:   [<c0430cdb>] clocksource_get_next+0x39/0x3f
kernel:   [<c0430cac>] clocksource_get_next+0xa/0x3f
kernel:   [<c0434fce>] __lock_acquire+0x3b9/0xb83
kernel:   [<c054e236>] ide_intr+0x15/0x1ba
kernel:   [<c04356fe>] __lock_acquire+0xae9/0xb83
kernel:   [<c04083bd>] mask_and_ack_8259A+0x1b/0xce
kernel:   [<c04357ff>] lock_acquire+0x67/0x81
kernel:   [<c054e236>] ide_intr+0x15/0x1ba
kernel:   [<c0600e95>] _spin_lock_irqsave+0x32/0x41
kernel:   [<c054e236>] ide_intr+0x15/0x1ba
kernel:   [<c054e236>] ide_intr+0x15/0x1ba
kernel:   [<c0448299>] handle_level_irq+0x6c/0xbb
kernel:   [<c044701e>] handle_IRQ_event+0x13/0x3d
kernel:   [<c04482a2>] handle_level_irq+0x75/0xbb
kernel:   [<c044822d>] handle_level_irq+0x0/0xbb
kernel:   [<c0406c4f>] do_IRQ+0xa5/0xca
kernel:   [<ffffffff>] 0xffffffff
kernel: 
kernel: to a hard-irq-unsafe lock:
kernel:  (resource_lock){--..}
kernel: ... which became hard-irq-unsafe at:
kernel: ...  [<c0409ba5>] save_stack_trace+0x1c/0x37
kernel:   [<c0422290>] request_resource+0x10/0x32
kernel:   [<c043506b>] __lock_acquire+0x456/0xb83
kernel:   [<c0422290>] request_resource+0x10/0x32
kernel:   [<c04356fe>] __lock_acquire+0xae9/0xb83
kernel:   [<c05202bb>] tty_register_ldisc+0x1c/0x5d
kernel:   [<c0430df6>] clocksource_register+0x4a/0x16e
kernel:   [<c04357ff>] lock_acquire+0x67/0x81
kernel:   [<c0422290>] request_resource+0x10/0x32
kernel:   [<c0600bff>] _write_lock+0x29/0x34
kernel:   [<c0422290>] request_resource+0x10/0x32
kernel:   [<c0422290>] request_resource+0x10/0x32
kernel:   [<c04ef604>] vgacon_startup+0x171/0x2fe
kernel:   [<c0736e4f>] con_init+0x17/0x213
kernel:   [<c05202f5>] tty_register_ldisc+0x56/0x5d
kernel:   [<c073695f>] console_init+0x1b/0x28
kernel:   [<c071a940>] start_kernel+0x1a1/0x3c6
kernel:   [<c071a42b>] unknown_bootoption+0x0/0x202
kernel:   [<ffffffff>] 0xffffffff

<< snipped lots more lock info >>

kernel: BUG: sleeping function called from invalid context at kernel/rwsem.c:20
kernel: in_atomic():0, irqs_disabled():1
kernel: INFO: lockdep is turned off.
kernel: irq event stamp: 2258
kernel: hardirqs last  enabled at (2257): [<c0462050>] kfree+0x78/0x7f
kernel: hardirqs last disabled at (2258): [<c0600db5>] _spin_lock_irq+0xc/0x3a
kernel: softirqs last  enabled at (2252): [<c0406b41>] do_softirq+0x4d/0xb6
kernel: softirqs last disabled at (2243): [<c0406b41>] do_softirq+0x4d/0xb6
kernel:  [<c042fda6>] down_read+0x15/0x4d
kernel:  [<c04e2498>] pci_get_subsys+0x68/0xea
kernel:  [<c04e2530>] pci_get_device+0x16/0x19
kernel:  [<c054b6f6>] init_hwif_default+0x28/0xf0
kernel:  [<c054c3d5>] ide_unregister+0x242/0x573
kernel:  [<d7b68018>] ide_release+0x18/0x28 [ide_cs]
kernel:  [<d7b68030>] ide_detach+0x8/0x14 [ide_cs]
kernel:  [<c055cd0c>] pcmcia_device_remove+0x50/0xb5
kernel:  [<c0543c50>] __device_release_driver+0x71/0x8e
kernel:  [<c05440a5>] device_release_driver+0x31/0x46
kernel:  [<c0543678>] bus_remove_device+0x70/0x80
kernel:  [<c0541d87>] device_del+0x162/0x1c6
kernel:  [<c0541df3>] device_unregister+0x8/0x10
kernel:  [<c055c95c>] pcmcia_card_remove+0x58/0x77
kernel:  [<c055d4da>] ds_event+0x56/0x87
kernel:  [<c04d5181>] kobject_get+0xf/0x13
kernel:  [<c05590e2>] send_event+0x31/0x49
kernel:  [<c05592c1>] socket_shutdown+0xc/0xb3
kernel:  [<c0559384>] socket_remove+0x1c/0x26
kernel:  [<c05593cd>] pcmcia_eject_card+0x3f/0x4c
kernel:  [<c055bcfc>] pccard_store_eject+0x1b/0x22
kernel:  [<c055bce1>] pccard_store_eject+0x0/0x22
kernel:  [<c054172b>] dev_attr_store+0x27/0x2c
kernel:  [<c049b74b>] sysfs_write_file+0xbf/0xe8
kernel:  [<c049b68c>] sysfs_write_file+0x0/0xe8
kernel:  [<c0465ef1>] vfs_write+0xa8/0x154
kernel:  [<c0466430>] sys_write+0x41/0x67
kernel:  [<c0404c1a>] sysenter_past_esp+0x5f/0x99
kernel:  =======================

Cheers
Richard

