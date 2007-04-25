Return-Path: <linux-kernel-owner+w=401wt.eu-S1030892AbXDYKWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892AbXDYKWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030879AbXDYKWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:22:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39676 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030881AbXDYKWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:22:00 -0400
Date: Wed, 25 Apr 2007 11:25:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175
 init_sched_clock()
Message-ID: <20070425112533.19d4a1aa@the-village.bc.nu>
In-Reply-To: <20070425085432.GD17130@htj.dyndns.org>
References: <462E4C4D.9020806@gmail.com>
	<20070425011654.222a2b4b.akpm@linux-foundation.org>
	<462F1481.8010807@gmail.com>
	<20070425085432.GD17130@htj.dyndns.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 72c286e..a128717 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1369,10 +1369,14 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
>  
>  static void ahci_freeze(struct ata_port *ap)
>  {
> +	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
>  	void __iomem *port_mmio = ahci_port_base(ap);
>  
>  	/* turn IRQ off */
>  	writel(0, port_mmio + PORT_IRQ_MASK);
> +
> +	/* clear IRQ pending bit */
> +	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
>  }
>  

Actually now I think about it the problem is even worse. On older systems
IRQ delivery for SMP machines is asynchronous. So the following can occur


		device raises IRQ line
		IRQ request hits APIC bus

		We write IRQ off
		We clear IRQ pending

		We read back to ensure the write took
	

		IRQ arrives on CPU APIC

(and yes this happens on dual P3 boxes - NE2K has some fantastic bugs at
one point due to this)
