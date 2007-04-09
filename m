Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbXDIBDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbXDIBDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 21:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXDIBDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 21:03:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50822 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbXDIBDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 21:03:15 -0400
Message-ID: <461990CE.8080609@pobox.com>
Date: Sun, 08 Apr 2007 21:03:10 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] pata_icside driver
References: <20070330110022.GA21653@flint.arm.linux.org.uk>	<20070330110800.GB21653@flint.arm.linux.org.uk>	<20070408101826.GA5431@flint.arm.linux.org.uk> <20070408195956.4e7d50c0@the-village.bc.nu>
In-Reply-To: <20070408195956.4e7d50c0@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The second FIXME area is ata_irq_ack - it is unconditionally coded
>> for SFF-type interfaces.  I believe that using this function in
>> non-BMDMA interfaces is wrong - it attempts to read from the BMDMA
>> registers irrespective of whether ap->ioaddr.bmdma_addr is set or
>> not.  The question this poses is: what should non-BMDMA implementations
>> use for this method?  Note that pata_platform also uses this
>> function despite not supporting BMDMA which seems even more suspicious.
> 
> Thats a bug that has arrived again. The older code was corrected to
> handle this properly but the fix appears to have become lost. The
> ioread/iowrite code actually made quite a mess (all the address reporting
> is also broken) and we do some iffy things like compare the iomap result
> with zero and assume thats the same as checking for true bus zero
> addresses.
> 
> ata_irq_ack is part of the SFF layer so its fine that it assumes SFF but
> its wrong that it is used unconditionally and it shouldn't be used this
> way. It just needs a (!ap->ioaddr.bmdma_addr) test adding (assuming thats
> valid for iomap)

No.  It does not need such a test, as it requires BMDMA, not just an 
SFF-style Status register.  It is up to the driver to decide whether or 
not ata_irq_ack() is appropriate for your hardware.

pata_icside needs its own ata_irq_ack -- which may just be as simple as 
reading the Status register to clear the interrupt condition.

If others need this as well, ata_sff_irq_ack() would be a good generic 
function to create.

	Jeff



