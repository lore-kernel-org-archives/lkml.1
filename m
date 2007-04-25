Return-Path: <linux-kernel-owner+w=401wt.eu-S1030829AbXDYKSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030829AbXDYKSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXDYKSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:18:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40108 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042AbXDYKSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:18:21 -0400
Date: Wed, 25 Apr 2007 11:21:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175
 init_sched_clock()
Message-ID: <20070425112146.16d076c0@the-village.bc.nu>
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


Neither of those two are going to help in all cases. They are PCI writes
to mmio so they are posted. You don't know they hit the device until a
read cycle coming back has completed, so you need to read something after
doing this to be sure.
