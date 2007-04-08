Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbXDHS5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbXDHS5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXDHS5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:57:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36953 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbXDHS5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:57:41 -0400
Date: Sun, 8 Apr 2007 19:59:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070408195956.4e7d50c0@the-village.bc.nu>
In-Reply-To: <20070408101826.GA5431@flint.arm.linux.org.uk>
References: <20070330110022.GA21653@flint.arm.linux.org.uk>
	<20070330110800.GB21653@flint.arm.linux.org.uk>
	<20070408101826.GA5431@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The second FIXME area is ata_irq_ack - it is unconditionally coded
> for SFF-type interfaces.  I believe that using this function in
> non-BMDMA interfaces is wrong - it attempts to read from the BMDMA
> registers irrespective of whether ap->ioaddr.bmdma_addr is set or
> not.  The question this poses is: what should non-BMDMA implementations
> use for this method?  Note that pata_platform also uses this
> function despite not supporting BMDMA which seems even more suspicious.

Thats a bug that has arrived again. The older code was corrected to
handle this properly but the fix appears to have become lost. The
ioread/iowrite code actually made quite a mess (all the address reporting
is also broken) and we do some iffy things like compare the iomap result
with zero and assume thats the same as checking for true bus zero
addresses.

ata_irq_ack is part of the SFF layer so its fine that it assumes SFF but
its wrong that it is used unconditionally and it shouldn't be used this
way. It just needs a (!ap->ioaddr.bmdma_addr) test adding (assuming thats
valid for iomap)


Alan
