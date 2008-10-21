Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYJUH6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYJUH6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYJUH6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:58:10 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37173 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYJUH6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:58:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18685.35653.125899.390135@harpo.it.uu.se>
Date: Tue, 21 Oct 2008 09:56:53 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
In-Reply-To: <48FD580E.4080101@gmail.com>
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
	<48EBFE9B.9070503@gmail.com>
	<18674.4081.839329.116533@harpo.it.uu.se>
	<48F2D9A8.1030502@gmail.com>
	<18683.50533.786782.474536@harpo.it.uu.se>
	<48FD580E.4080101@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo writes:
 > Hello, Mikael.
 > 
 > > --- linux-2.6.27/drivers/ata/sata_promise.c.~1~	2008-07-14 10:22:36.000000000 +0200
 > > +++ linux-2.6.27/drivers/ata/sata_promise.c	2008-10-20 00:20:58.000000000 +0200
 > > @@ -153,6 +153,7 @@ static void pdc_freeze(struct ata_port *
 > >  static void pdc_sata_freeze(struct ata_port *ap);
 > >  static void pdc_thaw(struct ata_port *ap);
 > >  static void pdc_sata_thaw(struct ata_port *ap);
 > > +static int pdc_prereset(struct ata_link *link, unsigned long deadline);
 > >  static void pdc_error_handler(struct ata_port *ap);
 > >  static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
 > >  static int pdc_pata_cable_detect(struct ata_port *ap);
 > > @@ -175,6 +176,7 @@ static const struct ata_port_operations 
 > >  	.sff_irq_clear		= pdc_irq_clear,
 > >  
 > >  	.post_internal_cmd	= pdc_post_internal_cmd,
 > > +	.prereset		= pdc_prereset,
 > >  	.error_handler		= pdc_error_handler,
 > >  };
 > >  
 > > @@ -691,6 +693,12 @@ static void pdc_sata_thaw(struct ata_por
 > >  	readl(host_mmio + hotplug_offset); /* flush */
 > >  }
 > >  
 > > +static int pdc_prereset(struct ata_link *link, unsigned long deadline)
 > > +{
 > > +	pdc_reset_port(link->ap);
 > 
 > I would put this into ->hardreset itself as the controller can also
 > get out of sync with reality during reset.

The only thing I see going on between prereset and (hard/soft)reset
is an optional freeze, so I don't see why moving the pdc_reset_port()
into the beginning of hardreset() would make any difference.

sata_promise currently uses the ->hardreset and ->softreset inherited
from ata_sff_port_ops, so it would need to override both to ensure that
we always do pdc_reset_port() before libata does its thing. That's why
I felt doing that in ->prereset would be the right solution.

/Mikael
