Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbXEJXHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbXEJXHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXEJXHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:07:03 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbXEJXHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:07:01 -0400
Date: Thu, 10 May 2007 16:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Komuro <komurojun-mbn@nifty.com>, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [FW  ide-cs] Re: jvc cdrom drive lockup
Message-Id: <20070510160615.6aa9cef6.akpm@linux-foundation.org>
In-Reply-To: <1178777214.2951.18.camel@ymzhang>
References: <1178202559.3767.21.camel@localhost.localdomain>
	<20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
	<1178463619.3793.14.camel@localhost.localdomain>
	<1178777214.2951.18.camel@ymzhang>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 14:06:54 +0800
"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> On Sun, 2007-05-06 at 16:00 +0100, Richard Kennedy wrote:
> > On Fri, 2007-05-04 at 23:32 +0900, Komuro wrote:
> > > On Thu, 03 May 2007 15:29:19 +0100
> > > Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> > > 
> > > 
> > > IDE bugs should be posted to the linux-ide mailing list.
> > > 
> > > 
> > > > Hi all, 
> > > > I have a JVC MP-CDX1 cdrom drive that came with my laptop which used to
> > > > work with ide-cs but stopped working with newer kernels.
> > > > 
> > > > I added its ident to ide-cs.c (see patch below) and the drive now is
> > > > detected and gets mounted when plugged in and seems to work correctly.
> > > > 
> > > > But when I eject the card, pccardctl eject 0, the laptop locks up
> > > > completely, there are no messages in the log, and the fan goes to full
> > > > speed so I guess the cpu is running at 100%.
> > > > Any ideas what's going wrong or how to debug it ? 
> > > > Is there anything else I need to patch to get this working ?
> > > > 
> > > > Thanks
> > > > Richard
> > > > 
> > > > card info :- 
> > > > 
> > > > May  3 11:22:52 mininote kernel: pccard: PCMCIA card inserted into slot 0
> > > > May  3 11:22:52 mininote kernel: cs: memory probe 0xa0000000-0xa0ffffff: clean.
> > > > May  3 11:22:52 mininote kernel: pcmcia: registering new device pcmcia0.0
> > > > May  3 11:22:53 mininote kernel: hdc: UJDB130, ATAPI CD/DVD-ROM drive
> > > > May  3 11:22:53 mininote kernel: ide1 at 0x190-0x197,0x396 on irq 3
> > > > May  3 11:22:53 mininote kernel: ide-cs: hdc: Vpp = 0.0
> > > > May  3 11:22:54 mininote kernel: hdc: ATAPI 20X CD-ROM drive, 128kB Cache
> > > > May  3 11:22:54 mininote kernel: Uniform CD-ROM driver Revision: 3.20
> > > > May  3 11:23:04 mininote hald: mounted /dev/hdc on behalf of uid 500
> > > > May  3 11:23:34 mininote hald: unmounted /dev/hdc from '/media/FC_4 i386 ftp #1' on behalf of uid 500
> > > > May  3 11:24:17 mininote kernel: pccard: card ejected from slot 0
> > > > << lockup happened here >>
> 
> > I rebuilt the kernel with the lock dependency checking turned on, which
> > shows up 2 problems (and also breaks the deadlock).
> > 
> > kernel: pccard: card ejected from slot 0
> > kernel: 
> 
> > kernel: BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> > kernel: in_atomic():0, irqs_disabled():1
> > kernel: INFO: lockdep is turned off.
> > kernel: irq event stamp: 2258
> > kernel: hardirqs last  enabled at (2257): [<c0462050>] kfree+0x78/0x7f
> > kernel: hardirqs last disabled at (2258): [<c0600db5>] _spin_lock_irq+0xc/0x3a
> > kernel: softirqs last  enabled at (2252): [<c0406b41>] do_softirq+0x4d/0xb6
> > kernel: softirqs last disabled at (2243): [<c0406b41>] do_softirq+0x4d/0xb6
> > kernel:  [<c042fda6>] down_read+0x15/0x4d
> > kernel:  [<c04e2498>] pci_get_subsys+0x68/0xea
> > kernel:  [<c04e2530>] pci_get_device+0x16/0x19
> > kernel:  [<c054b6f6>] init_hwif_default+0x28/0xf0
> > kernel:  [<c054c3d5>] ide_unregister+0x242/0x573
> > kernel:  [<d7b68018>] ide_release+0x18/0x28 [ide_cs]
> > kernel:  [<d7b68030>] ide_detach+0x8/0x14 [ide_cs]
> > kernel:  [<c055cd0c>] pcmcia_device_remove+0x50/0xb5
> > kernel:  [<c0543c50>] __device_release_driver+0x71/0x8e
> > kernel:  [<c05440a5>] device_release_driver+0x31/0x46
> > kernel:  [<c0543678>] bus_remove_device+0x70/0x80
> > kernel:  [<c0541d87>] device_del+0x162/0x1c6
> > kernel:  [<c0541df3>] device_unregister+0x8/0x10
> > kernel:  [<c055c95c>] pcmcia_card_remove+0x58/0x77
> > kernel:  [<c055d4da>] ds_event+0x56/0x87
> > kernel:  [<c04d5181>] kobject_get+0xf/0x13
> > kernel:  [<c05590e2>] send_event+0x31/0x49
> > kernel:  [<c05592c1>] socket_shutdown+0xc/0xb3
> > kernel:  [<c0559384>] socket_remove+0x1c/0x26
> > kernel:  [<c05593cd>] pcmcia_eject_card+0x3f/0x4c
> > kernel:  [<c055bcfc>] pccard_store_eject+0x1b/0x22
> > kernel:  [<c055bce1>] pccard_store_eject+0x0/0x22
> > kernel:  [<c054172b>] dev_attr_store+0x27/0x2c
> > kernel:  [<c049b74b>] sysfs_write_file+0xbf/0xe8
> > kernel:  [<c049b68c>] sysfs_write_file+0x0/0xe8
> > kernel:  [<c0465ef1>] vfs_write+0xa8/0x154
> > kernel:  [<c0466430>] sys_write+0x41/0x67
> > kernel:  [<c0404c1a>] sysenter_past_esp+0x5f/0x99
> > kernel:  =======================
> Before calling init_hwif_default, ide_unregister gets lock ide_lock and disables irq.
> init_hwif_default calls ide_default_io_base which calls pci_get_device and later
> pci_get_subsys tries to apply for semaphore pci_bus_sem and goes to sleep.
> 
> Mostly, pci_get_device should be called when irq is turned on.
> 
> I still don't understand an issue. If you test it on a mobile, mostly, the process won't
> sleep when applying for pci_bus_sem because there is no too many opportunities for 2 processes
> to apply for the semaphore at the same time.
> 
> As just needing know if pci is initiated, ide_default_io_base just needs find if list
> pci_devices is empty.
> 
> Could you try below patch against 2.6.21?
> 
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> ---
> 
> diff -Nraup linux-2.6.21/drivers/pci/probe.c linux-2.6.21_fix/drivers/pci/probe.c
> --- linux-2.6.21/drivers/pci/probe.c	2007-05-10 11:35:06.000000000 +0800
> +++ linux-2.6.21_fix/drivers/pci/probe.c	2007-05-10 13:33:57.000000000 +0800
> @@ -22,6 +22,18 @@ EXPORT_SYMBOL(pci_root_buses);
>  
>  LIST_HEAD(pci_devices);
>  
> +/*
> + * Some device drivers need know if pci is initiated.
> + * Basically, we think pci is not initiated when there
> + * is no device in list of pci_devices.
> + */
> +int no_pci_devices(void)
> +{
> +	return list_empty(&pci_devices);
> +}
> +
> +EXPORT_SYMBOL(no_pci_devices);
> +
>  #ifdef HAVE_PCI_LEGACY
>  /**
>   * pci_create_legacy_files - create legacy I/O port and memory files
> diff -Nraup linux-2.6.21/include/asm-i386/ide.h linux-2.6.21_fix/include/asm-i386/ide.h
> --- linux-2.6.21/include/asm-i386/ide.h	2007-02-05 02:44:54.000000000 +0800
> +++ linux-2.6.21_fix/include/asm-i386/ide.h	2007-05-10 13:15:57.000000000 +0800
> @@ -40,14 +40,13 @@ static __inline__ int ide_default_irq(un
>  
>  static __inline__ unsigned long ide_default_io_base(int index)
>  {
> -	struct pci_dev *pdev;
>  	/*
>  	 *	If PCI is present then it is not safe to poke around
>  	 *	the other legacy IDE ports. Only 0x1f0 and 0x170 are
>  	 *	defined compatibility mode ports for PCI. A user can 
>  	 *	override this using ide= but we must default safe.
>  	 */
> -	if ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL)) == NULL) {
> +	if (no_pci_devices()) {
>  		switch(index) {
>  			case 2: return 0x1e8;
>  			case 3: return 0x168;
> @@ -55,7 +54,6 @@ static __inline__ unsigned long ide_defa
>  			case 5: return 0x160;
>  		}
>  	}
> -	pci_dev_put(pdev);
>  	switch (index) {
>  		case 0:	return 0x1f0;
>  		case 1:	return 0x170;
> diff -Nraup linux-2.6.21/include/linux/pci.h linux-2.6.21_fix/include/linux/pci.h
> --- linux-2.6.21/include/linux/pci.h	2007-05-10 11:35:07.000000000 +0800
> +++ linux-2.6.21_fix/include/linux/pci.h	2007-05-10 13:33:43.000000000 +0800
> @@ -424,6 +424,8 @@ extern struct bus_type pci_bus_type;
>   * code, or pci core code. */
>  extern struct list_head pci_root_buses;	/* list of all known PCI buses */
>  extern struct list_head pci_devices;	/* list of all devices */
> +/* Some device drivers need know if pci is initiated */
> +extern int no_pci_devices(void);
>  
>  void pcibios_fixup_bus(struct pci_bus *);
>  int __must_check pcibios_enable_device(struct pci_dev *, int mask);
> @@ -709,6 +711,7 @@ static inline struct pci_dev *pci_get_cl
>  { return NULL; }
>  
>  #define pci_dev_present(ids)	(0)
> +#define no_pci_devices()	(1)
>  #define pci_find_present(ids)	(NULL)
>  #define pci_dev_put(dev)	do { } while (0)
>  

yeah, we already fixed this twice.  Please see the list_empty(&pci_devices)
tests in drivers/pci/search.c, added by the below patch.

I'd suggest that we consolidate that change and yours together.  I'll do
a separate patch for that.


commit 6ae4adf50380d0fc5176a76d98d324f8fa491a8f
Author: Ard van Breemen <ard@telegraafnet.nl>
Date:   Fri Jan 5 16:36:21 2007 -0800

    [PATCH] PCI: prevent down_read when pci_devices is empty
    
    The pci_find_subsys gets called very early by obsolete ide setup parameters.
    This is a bogus call since pci is not initialized yet, so the list is empty.
    But in the mean time, interrupts get enabled by down_read.  This can result in
    a kernel panic when the irq controller gets initialized.
    
    This patch checks if the device list is empty before taking the semaphore, and
    hence will not enable irq's.  Furthermore it will inform that it is called
    while pci_devices is empty as a reminder that the ide code needs to be fixed.
    
    The pci_get_subsys can get called in the same manner, and as such is patched
    in the same manner.
    
    [akpm@osdl.org: cleanups]
    Signed-off-by: Ard van Breemen <ard@telegraafnet.nl>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 45f2b20..fab381e 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -193,6 +193,18 @@ static struct pci_dev * pci_find_subsys(
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_find_subsys() can be called on the ide_setup() path, super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_INFO "pci_find_subsys() called while pci_devices "
+				"is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 
@@ -259,6 +271,18 @@ pci_get_subsys(unsigned int vendor, unsi
 	struct pci_dev *dev;
 
 	WARN_ON(in_interrupt());
+
+	/*
+	 * pci_get_subsys() can potentially be called by drivers super-early
+	 * in boot.  But the down_read() will enable local interrupts, which
+	 * can cause some machines to crash.  So here we detect and flag that
+	 * situation and bail out early.
+	 */
+	if (unlikely(list_empty(&pci_devices))) {
+		printk(KERN_NOTICE "pci_get_subsys() called while pci_devices "
+				"is still empty\n");
+		return NULL;
+	}
 	down_read(&pci_bus_sem);
 	n = from ? from->global_list.next : pci_devices.next;
 

