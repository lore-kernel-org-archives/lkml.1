Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZAJLmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZAJLmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZAJLmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:42:10 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:47109 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZAJLmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:42:09 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Date: Sat, 10 Jan 2009 12:42:05 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
References: <200901091334.55823.borntraeger@de.ibm.com> <200901101009.13699.borntraeger@de.ibm.com> <20090110104114.633cacd8@lxorguk.ukuu.org.uk>
In-Reply-To: <20090110104114.633cacd8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101242.05203.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 10 Januar 2009 schrieb Alan Cox:
> > I did some printk debugging. 
> > __atapi_pio_bytes is called with bytes=18. That means with 32bit transfers
> > there is a 2 byte trailing transfer, which triggers this WARN_ON.
> 
> Ouch.. that means all that someone issued a multiple segment data
> transfer with a 2 byte aligned chunk in the middle.
> 
> That is a bit of a suprise because we set blk_queue_dma_alignment to 3 so
> the block layer should never hand us an sg list in that form. That means
> we've either got a block layer bug or someone somewhere is generating
> invalid sg lists internally to libata.
> 
> Can you dump qc->cdb[] and see what command is getting issued in the
> broken form ?

I instrumented __atapi_pio_bytes to print some variables. This is the dump of
the first two:

[    1.484730] count: 36 sg->length: 36 qc->cursg_ofs: 0 bytes: 36
[    1.485709] qc->cdb[]:12000000240000000000000000000000
That works fine.

[    1.499843] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
[    1.508389] count: 18 sg->length: 96 qc->cursg_ofs: 0 bytes: 18
[    1.509369] qc->cdb[]:03000000600000000000000000000000
That one is broken.

[    1.509369] ------------[ cut here ]------------
[    1.509369] WARNING: at drivers/ata/libata-sff.c:1024 ata_sff_hsm_move+0x69b/0x810()

