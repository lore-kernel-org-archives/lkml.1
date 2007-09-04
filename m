Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXIDSoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXIDSoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 14:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXIDSoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 14:44:00 -0400
Received: from aun.it.uu.se ([130.238.12.36]:53820 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbXIDSn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 14:43:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18141.42848.537873.349518@alkaid.it.uu.se>
Date: Tue, 4 Sep 2007 20:43:44 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jeff Norden <jeff@math.tntech.edu>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] pata_it821x: fix lost interrupt with atapi devices
In-Reply-To: <200709041607.l84G7KsT032647@norden.math.tntech.edu>
References: <200709041607.l84G7KsT032647@norden.math.tntech.edu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Norden writes:
 >  From: Jeff Norden <jnorden@math.tntech.edu>
 > 
 > Fix "lost" interrupt problem when using dma with CD/DVD drives in some
 > configurations.  This problem can make installing linux from media
 > impossible for distro's that have switched to libata-only configurations.
 > 
 > The simple fix is to eliminate the use of dma for reading drive status, etc,
 > by checking the number of bytes to transferred.
 > 
 > This change will only affect the behavior of atapi devices, not disks.
 > There is more info at http://bugzilla.redhat.com/show_bug.cgi?id=242229
 > This patch is for 2.6.22.1
 > 
 > Signed-off-by: Jeff Norden <jnorden@math.tntech.edu>
 > 
 > ---
 > 
 > --- pata_it821x.c.orig	2007-08-16 14:20:49.000000000 -0500
 > +++ pata_it821x.c	2007-08-31 16:09:22.000000000 -0500
 > @@ -533,6 +533,10 @@ static int it821x_check_atapi_dma(struct
 >  	struct ata_port *ap = qc->ap;
 >  	struct it821x_dev *itdev = ap->private_data;
 >  
 > +	/* Only use dma for transfers to/from the media. */
 > +	if (qc->nbytes < 2048)
 > +		return -EOPNOTSUPP;
 > +
 >  	/* No ATAPI DMA in smart mode */
 >  	if (itdev->smart)
 >  		return -EOPNOTSUPP;
 > 

This looks like a gross hack. Aren't you supposed to inspect
the command instead and whitelist the ones you know are OK,
like pata_pdc2027x.c and sata_promise.c do?
