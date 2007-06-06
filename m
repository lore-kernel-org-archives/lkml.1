Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbXFFKhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbXFFKhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbXFFKhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:37:09 -0400
Received: from aun.it.uu.se ([130.238.12.36]:58788 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbXFFKhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:37:07 -0400
Date: Wed, 6 Jun 2007 12:36:41 +0200 (MEST)
Message-Id: <200706061036.l56AafXS003241@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: htejun@gmail.com, jeff@garzik.org
Subject: Re: Linux 2.6.22-rc4 - sata_promise regression since -rc3
Cc: akpm@linux-foundation.org, david@dgreaves.com, jean.luc.coulon@gmail.com,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, mikpe@it.uu.se,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 15:56:53 +0900, Tejun Heo wrote:
> Jeff Garzik wrote:
> > On Tue, Jun 05, 2007 at 11:31:46PM +0200, Mikael Pettersson wrote:
> >> I can easily reproduce the problem in 2.6.22-rc4. There are no
> >> sata_promise changes between rc3 and rc4, but Tejun's libata
> >> polling SETXFER change was included in rc4. Reverting it makes
> >> sata_promise work again for me.
> > 
> > Ugh.
> 
> Ugh...
> 
> >> I suspect that sata_promise.c:pdc_interrupt() should detect
> >> a qc w/ ATA_TFLAG_POLLING, treat the interrupt as spurious,
> >> and just call ata_chk_status(qc), similar to how sata_inic162x.c,
> >> sata_nv.c, sata_sil.c, and sata_vsc.c do things.
> > 
> > Yes, highly likely.
> 
> I'm not sure whether that will work.  I'll give a shot at it here.

I tried it and it didn't work. The qc:s never got completed, so
they timed out and the ports got disabled.

Calling pdc_host_intr() instead, which calls ata_qc_complete(),
did work (see hack below). However, this means that pdc_interrupt()
should ignore ATA_TFLAG_POLLING, which seems strange and unsafe.

I'm just guessing here, but maybe pdc_interrupt()'s clearing of
PDC_INT_SEQMASK also affects whatever legacy ATA status bit libata
is polling to detect completion of the qc?

--- linux-2.6.22-rc4/drivers/ata/sata_promise.c.~1~	2007-06-05 22:21:39.000000000 +0200
+++ linux-2.6.22-rc4/drivers/ata/sata_promise.c	2007-06-06 12:04:38.000000000 +0200
@@ -748,6 +748,11 @@
 			qc = ata_qc_from_tag(ap, ap->active_tag);
 			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
 				handled += pdc_host_intr(ap, qc);
+			else if (qc) {
+				printk("%s: stray irq on port %u\n", __FUNCTION__, i);
+				//ata_check_status(ap);
+				handled += pdc_host_intr(ap, qc);
+			}
 		}
 	}
 

> > SFF-like controllers (and in this case, Promise is included in that
> > list) with their own interrupt handlers need their own polling handling
> > code.
> 
> One thing I don't understand is why IDENTIFY works.  IDENTIFY uses
> polling too.  Hmm...

SETXFER is special: Promise chips snoop the commands and automatically
update internal timing registers when they see XFER MODE changes. They
may be hardwired to raise interrupts after these commands.

/Mikael
