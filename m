Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbYBYWD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbYBYWD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYBYWDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:03:17 -0500
Received: from www.tglx.de ([62.245.132.106]:56513 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYBYWDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:03:17 -0500
Date: Mon, 25 Feb 2008 23:01:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeff Garzik <jgarzik@pobox.com>,
       =?ISO-8859-15?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
In-Reply-To: <20080225124054.9b69e9f0.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080225195924.GA23176@atjola.homenet> <47C32043.6090809@pobox.com> <20080225124054.9b69e9f0.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Andrew Morton wrote:
> On Mon, 25 Feb 2008 15:08:35 -0500 Jeff Garzik <jgarzik@pobox.com> wrote:
> > There are plenty of drivers that do the same thing that ahci does, in 
> > terms of interrupt handler locking...  and I will definitely push back 
> > on efforts to convert otherwise-100%-safe spin_lock() into 
> > spin_lock_irqsave() just to quiet lockdep.
> > 
> > Very interesting email, thanks...
> > 
> 
> I suspect this is a bug in my old kmap_atomic debugging patch.  It doesn't
> know about the implicit irq-disablememnt which interrupt handlers enjoy.  I
> don't think...

I suspect here is confusion. The implicit irq-disablement of lockdep
is actually hiding the warning.

The code which emits the warning is:

        if (type == KM_IRQ0 || type == KM_IRQ1 || type == KM_BOUNCE_READ ||
                        type == KM_BIO_SRC_IRQ || type == KM_BIO_DST_IRQ) {
                if (!irqs_disabled()) {
                        WARN_ON(1);
                        warn_count--;
                }

It checks for _NOT_ irqs_disabled. The calling code is
ata_scsi_rbuf_get() which calls with:

     buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;

This happens with interrupts enabled. So the warning is according to
the well documented km_type enum and the equally well documented
highmem debug code correct.

Bjoern decoded it very well, just Jeff jumped to very interesting
conclusions.

Thanks,

	tglx
