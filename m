Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZAJP2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZAJP2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZAJP2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:28:45 -0500
Received: from h155.mvista.com ([63.81.120.155]:64737 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751733AbZAJP2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:28:44 -0500
Message-ID: <4968BECE.8070304@ru.mvista.com>
Date: Sat, 10 Jan 2009 18:29:18 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com>	<200901101009.13699.borntraeger@de.ibm.com>	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>	<200901101242.05203.borntraeger@de.ibm.com>	<49688B63.5030105@ru.mvista.com>	<20090110122130.318cf168@lxorguk.ukuu.org.uk>	<1231598170.3642.12.camel@localhost.localdomain> <20090110151248.063199d2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090110151248.063199d2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> O> Your problem is that the *device* is wanting to transfer a set of bytes

>>not divisible by four.  If you want to use word based PIO, you'll have
>>to fall back to collecting bytes for the last two.  Alternatively, you

> Nope.. you can't do that with ATA block transfers - it isn't the same as
> SCSI

   ATA block transfers are always mutliple of 512 bytes (except read/write 
long), so this shouldn't be an issue... unless the code is trying to split a 
sector between 2 pages on an arbitrary boundary -- in this case, even if the 
both resulting byte counts divide by 2, you may be busted because of prefetch 
that (as the Intel docs say), should have the initial (start of sector) and 
all subsequent reads of the same size (either 16- or 32-bit). I don't know if 
this situation is actually possible with libata -- but beware...

>>could just do byte PIO for all reply lengths like this ... they occur
>>all over the SCSI standard, but not usually in critical paths.

> The problem we have is that the sg list the drivers were given had a
> segment which was not divisible in length by four and was *NOT* the last
> segment in the sg list

> The logic in the ATA PIO code is basically

> 	for each sg entry

> 		compute the number of bytes to transfer staying within
> the page
> 		transfer that many bytes (but may be more)
> 
> 		if and only if the transfer is NOT the last segment but is
> 			more than the bytes requested - WARN

    The ATAPI logic is more complex since it has to take into account the 
arbitrary byte count that a device want to transfer on each INTRQ (read from 
the byte count low/high regs).

> Alan

MBR, Sergei
