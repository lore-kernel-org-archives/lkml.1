Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbXLGXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbXLGXXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXLGXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:23:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXLGXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:23:02 -0500
Date: Fri, 7 Dec 2007 15:22:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
Message-Id: <20071207152249.360af326.akpm@linux-foundation.org>
In-Reply-To: <1197068983.15428.29.camel@localhost>
References: <1197059904.15428.15.camel@localhost>
	<20071207150251.a0dbae23.akpm@linux-foundation.org>
	<1197068983.15428.29.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 23:09:43 +0000
Zan Lynx <zlynx@acm.org> wrote:

> 
> On Fri, 2007-12-07 at 15:02 -0800, Andrew Morton wrote:
> > On Fri, 07 Dec 2007 20:38:24 +0000
> > Zan Lynx <zlynx@acm.org> wrote:
> > 
> > > While I'm reporting problems I'll get this one out there.
> > > 
> > > I normally use a USB-2 memory card reader but I also have a PCMCIA
> > > CompactFlash adapter that I use occasionally.  During the MM series
> > > kernels 2.6.22 and 23 (I am pretty sure) this didn't work at all.  I
> > > don't know about vanilla since I don't run that.
> > > 
> > > Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, but I
> > > only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I got
> > > at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
> > > reader.
> > >
> 
> > Are we talking about this?
> [cut]
> > > It might be that it auto-configures for PIO-0.  I have no idea why it
> > > does that.
> > > 
> > > Another interesting thing is that doing a dd to or from the card brings
> > > the rest of the system to a nearly complete halt.  Interrupt problem?
> > 
> > Where are you seeing the evidence that it autoconfigures for PIO-0?
> 
> No, this:
> pccard: PCMCIA card inserted into slot 0
> cs: memory probe 0x50000000-0x57ffffff: excluding 0x50000000-0x57ffffff
> cs: memory probe 0xe0100000-0xe17fffff: excluding 0xe0100000-0xe026ffff 0xe03e0000-0xe082ffff 0xe0b10000-0xe10cffff
> pcmcia: registering new device pcmcia0.0
> scsi2 : pata_pcmcia
> ata3: PATA max PIO0 cmd 0x3100 ctl 0x310e irq 19
> ata3.00: CFA: LEXAR ATA FLASH, V2.00, max PIO6
> ata3.00: 8018640 sectors, multi 0: LBA 
> ata3.00: configured for PIO0
> ata3.00: configured for PIO0
> ata3: EH complete
> isa bounce pool size: 16 pages
> scsi 2:0:0:0: Direct-Access     ATA      LEXAR ATA FLASH  V2.0 PQ: 0 ANSI: 5
> sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 2:0:0:0: [sdb] 8018640 512-byte hardware sectors (4106 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA sdb: sdb1
> sd 2:0:0:0: [sdb] Attached SCSI removable disk
> 
> Specifically:
> ata3.00: configured for PIO0
> ata3.00: configured for PIO0

Oh, OK.  Hopefully the ata guys can help out with this.

I don't know if it actually strictly a regression?  Did libata ever support
that device in any earlier kernels?

Alan will be non-respnosive for a few weeks.

<looks>


Maybe pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch?

Could you try a `patch -R' of the below?


From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_pcmcia.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/ata/pata_pcmcia.c~pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards drivers/ata/pata_pcmcia.c
--- a/drivers/ata/pata_pcmcia.c~pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards
+++ a/drivers/ata/pata_pcmcia.c
@@ -42,7 +42,7 @@
 
 
 #define DRV_NAME "pata_pcmcia"
-#define DRV_VERSION "0.3.2"
+#define DRV_VERSION "0.3.3"
 
 /*
  *	Private data structure to glue stuff together
@@ -198,7 +198,6 @@ do { last_fn = (fn); if ((last_ret = (re
 /**
  *	pcmcia_init_one		-	attach a PCMCIA interface
  *	@pdev: pcmcia device
- *	@ops: operations for this device
  *
  *	Register a PCMCIA IDE interface. Such interfaces are PIO 0 and
  *	shared IRQ.
@@ -217,9 +216,10 @@ static int pcmcia_init_one(struct pcmcia
 		cistpl_cftable_entry_t dflt;
 	} *stk = NULL;
 	cistpl_cftable_entry_t *cfg;
-	int pass, last_ret = 0, last_fn = 0, is_kme = 0, ret = -ENOMEM;
+	int pass, last_ret = 0, last_fn = 0, is_kme = 0, ret = -ENOMEM, p;
 	unsigned long io_base, ctl_base;
 	void __iomem *io_addr, *ctl_addr;
+	int n_ports = 1;
 
 	struct ata_port_operations *ops = &pcmcia_port_ops;
 
@@ -348,7 +348,7 @@ next_entry:
 	/* FIXME: Could be more ports at base + 0x10 but we only deal with
 	   one right now */
 	if (pdev->io.NumPorts1 >= 0x20)
-		printk(KERN_WARNING DRV_NAME ": second channel not yet supported.\n");
+		n_ports = 2;
 
 	if (pdev->manf_id == 0x0097 && pdev->card_id == 0x1620)
 		ops = &pcmcia_8bit_port_ops;
@@ -357,20 +357,23 @@ next_entry:
 	 *	sane.
 	 */
 	ret = -ENOMEM;
-	host = ata_host_alloc(&pdev->dev, 1);
+	host = ata_host_alloc(&pdev->dev, n_ports);
 	if (!host)
 		goto failed;
-	ap = host->ports[0];
 
-	ap->ops = ops;
-	ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
-	ap->flags |= ATA_FLAG_SLAVE_POSS;
-	ap->ioaddr.cmd_addr = io_addr;
-	ap->ioaddr.altstatus_addr = ctl_addr;
-	ap->ioaddr.ctl_addr = ctl_addr;
-	ata_std_ports(&ap->ioaddr);
+	for (p = 0; p < n_ports; p++) {
+		ap = host->ports[p];
 
-	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io_base, ctl_base);
+		ap->ops = ops;
+		ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
+		ap->flags |= ATA_FLAG_SLAVE_POSS;
+		ap->ioaddr.cmd_addr = io_addr + 0x10 * p;
+		ap->ioaddr.altstatus_addr = ctl_addr + 0x10 * p;
+		ap->ioaddr.ctl_addr = ctl_addr + 0x10 * p;
+		ata_std_ports(&ap->ioaddr);
+
+		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io_base, ctl_base);
+	}
 
 	/* activate */
 	ret = ata_host_activate(host, pdev->irq.AssignedIRQ, ata_interrupt,
_

