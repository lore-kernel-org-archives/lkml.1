Return-Path: <linux-kernel-owner+w=401wt.eu-S1423328AbXDYIyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423328AbXDYIyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423326AbXDYIyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:54:40 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:12503 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423324AbXDYIyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FLcruWhwmowxuysy/Dp9OADgWK47tuOnzq4b+zJGVX6vH8aQ7623BBDMoFbhcM8rCZAAYfeETcpOUdV7IWvkNdmHCOYXkWFZvnq8zJOmWFlZTKnmWpUaDHQj72FDXJ+nF/1pOzvHBRb10VGsjmo+U+2a6xlUjlmsS/otgiFopWg=
Date: Wed, 25 Apr 2007 17:54:32 +0900
From: Tejun Heo <htejun@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
Message-ID: <20070425085432.GD17130@htj.dyndns.org>
References: <462E4C4D.9020806@gmail.com> <20070425011654.222a2b4b.akpm@linux-foundation.org> <462F1481.8010807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462F1481.8010807@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 05:42:41PM +0900, Tejun Heo wrote:
> Andrew Morton wrote:
> >> [    2.953862] RIP: 0010:[<ffffffff803ae98b>]  [<ffffffff803ae98b>] scsi_schedule_eh+0xa/0x57
> >> [    3.058672]  [<ffffffff803e1e01>] ata_port_schedule_eh+0x4c/0x50
> >> [    3.064725]  [<ffffffff803e1ea7>] ata_port_abort+0xa2/0xae
> >> [    3.070248]  [<ffffffff803e1ef9>] ata_port_freeze+0x46/0x57
> >> [    3.075853]  [<ffffffff803e4c39>] ahci_interrupt+0x300/0x47a
> >> [    3.081552]  [<ffffffff8020eb83>] handle_IRQ_event+0x27/0x57
> >> [    3.087253]  [<ffffffff8029a021>] handle_edge_irq+0xee/0x133
> >> [    3.092960]  [<ffffffff8025f4e1>] do_IRQ+0x6d/0xd5
> >> [    3.097793]  [<ffffffff80255071>] ret_from_intr+0x0/0xa
> >> [    3.103059]  [<ffffffff8024e88b>] mwait_idle+0x46/0x4b
> >> [    3.108231]  [<ffffffff802422f4>] cpu_idle+0x87/0xaa
> >> [    3.113227]  [<ffffffff8025c988>] rest_init+0x49/0x4b
> >> [    3.118322]  [<ffffffff805dca5d>] start_kernel+0x291/0x29c
> >> [    3.123837]  [<ffffffff805dc13a>] _sinittext+0x13a/0x141
> >>
> > 
> > So we took an AHCI interrupt when ata_port.scsi_host was still NULL.
> > 
> > It appears that ATA is presently requesting its IRQ before allocating all
> > the resources which are needed to handle an interrupt.  Does this
> > (resource-leaky) patch fix things?
> 
> No, that would break host probing.  The port is in frozen (controller
> initialized and IRQs masked off) state, so it's not allowed to take
> interrupt.  If interrupt triggers at this point, it's low level driver
> bug.  Berck, how reliably can you reproduce this problem?  Can you post
> the result of 'lspci -nn'?

Berck, does this patch fix your problem?

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 72c286e..a128717 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1369,10 +1369,14 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 
 static void ahci_freeze(struct ata_port *ap)
 {
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	void __iomem *port_mmio = ahci_port_base(ap);
 
 	/* turn IRQ off */
 	writel(0, port_mmio + PORT_IRQ_MASK);
+
+	/* clear IRQ pending bit */
+	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
 }
 
 static void ahci_thaw(struct ata_port *ap)
