Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZAJPXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZAJPXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZAJPW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:22:59 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57944 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbZAJPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:22:58 -0500
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
	ata_sff_hsm_move+0x45e/0x750()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090110151248.063199d2@lxorguk.ukuu.org.uk>
References: <200901091334.55823.borntraeger@de.ibm.com>
	 <200901101009.13699.borntraeger@de.ibm.com>
	 <20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	 <200901101242.05203.borntraeger@de.ibm.com>
	 <49688B63.5030105@ru.mvista.com>
	 <20090110122130.318cf168@lxorguk.ukuu.org.uk>
	 <1231598170.3642.12.camel@localhost.localdomain>
	 <20090110151248.063199d2@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 09:22:51 -0600
Message-Id: <1231600972.3642.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-10 at 15:12 +0000, Alan Cox wrote:
> O> Your problem is that the *device* is wanting to transfer a set of bytes
> > not divisible by four.  If you want to use word based PIO, you'll have
> > to fall back to collecting bytes for the last two.  Alternatively, you
> 
> Nope.. you can't do that with ATA block transfers - it isn't the same as
> SCSI

Well, in that case you'll have to do byte PIO for all ATAPI devices,
because this is an expected device to host transfer length.

> > could just do byte PIO for all reply lengths like this ... they occur
> > all over the SCSI standard, but not usually in critical paths.
> 
> The problem we have is that the sg list the drivers were given had a
> segment which was not divisible in length by four and was *NOT* the last
> segment in the sg list

Yes it was, look at the debugging info:

Christian Borntraeger wrote:

> [    1.499843] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM
> GSA-U10N  1.05 PQ: 0 ANSI: 5
> [    1.508389] count: 18 sg->length: 96 qc->cursg_ofs: 0 bytes: 18
> [    1.509369] qc->cdb[]:03000000600000000000000000000000
> That one is broken.

That's a single element sg list with a 96 byte buffer.  That's precisely
what SCSI sets up to receive incoming sense data.  There's basically no
setup commands which are multiple element because the sg list is set up
on a kmalloc'd buffer.

The problem is that bytes is 18 and that comes from this:

	ap->ops->sff_tf_read(ap, &qc->result_tf);
	ireason = qc->result_tf.nsect;
	bc_lo = qc->result_tf.lbam;
	bc_hi = qc->result_tf.lbah;
	bytes = (bc_hi << 8) | bc_lo;

So we're asking the device how much data it wants to transfer. It said
18 bytes.  There's nothing padding or aligning in block can do about
this.

> The logic in the ATA PIO code is basically
> 
> 
> 	for each sg entry
> 
> 		compute the number of bytes to transfer staying within
> the page
> 		transfer that many bytes (but may be more)
> 
> 		if and only if the transfer is NOT the last segment but is
> 			more than the bytes requested - WARN
> 
> 
> The block alignment is set to 4 bytes so the block code should be handing
> down stuff which is safe. Some of the sense and other stuff is "adjusted"
> by the libata-scsi conversion code which at this point I suspect is the
> offender.

It is.  The receive buffer is 96 bytes.  It will be page aligned and 96
is divisible by 4.

> This is why libata uses the pad buffers we don't get to be quite so exact
> about transfer sizes as SCSI is.

The block layer does do pad buffers, but in this case there was no need
of one.

James


