Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZAUUMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZAUUMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:12:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZAUULw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:11:52 -0500
Received: from aun.it.uu.se ([130.238.12.36]:36197 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZAUULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:11:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18807.33113.550070.329912@harpo.it.uu.se>
Date: Wed, 21 Jan 2009 21:11:05 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Hugh Dickins <hugh@veritas.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
In-Reply-To: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins writes:
 > I've a Dell Precision 670 here (four-year-old EM64T Xeon with ata_piix)
 > which doesn't like your commit 871af1210f13966ab911ed2166e4ab2ce775b99d
 > libata: Add 32bit PIO support.  Full dmesg (and .config) attached, but
 > here's an extract showing the start of the error messages on ata2:
 > 
 > ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
 > ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
 > ata1: port disabled. ignoring.
 > ata2.00: ATAPI: GCR-8483B, 1.07, max UDMA/33
 > ata2.00: configured for UDMA/33
 > scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-ROM GCR-8483B 1.07 PQ: 0 ANSI: 5
 > ata2.00: qc timeout (cmd 0xa0)
 > ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
 > ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
 >          cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
 >          res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
 > ata2.00: status: { DRDY ERR }
 > ata2: soft resetting link
 > ata2.00: configured for UDMA/33
 > ata2: EH complete
 > 
 > linux-next behaved the same, so I played around, and the patch below seems
 > to fix it fine (though I've not yet tried it on other, working machines);
 > but I can well imagine you may prefer to do it differently.  Or was I just
 > wrong to move that box's CD handling from ide to libata a few months ago?
 > 
 > [PATCH] libata sff: 32bit PIO use 16bit on slop
 > 
 > 871af1210f13966ab911ed2166e4ab2ce775b99d libata: Add 32bit PIO support
 > causes errors on a four-year-old ata_piix Dell Precision 670.  Using
 > 16bit PIO instead of 32bit PIO on the odd 1, 2 or 3 chars fixes that.
 > 
 > Signed-off-by: Hugh Dickins <hugh@veritas.com>
 > ---
 > 
 >  drivers/ata/libata-sff.c |   18 +++++++++++-------
 >  1 file changed, 11 insertions(+), 7 deletions(-)
 > 
 > --- 2.6.29-rc2/drivers/ata/libata-sff.c	2009-01-17 10:40:12.000000000 +0000
 > +++ linux/drivers/ata/libata-sff.c	2009-01-21 12:32:01.000000000 +0000
 > @@ -774,17 +774,21 @@ unsigned int ata_sff_data_xfer32(struct 
 >  		iowrite32_rep(data_addr, buf, words);
 >  
 >  	if (unlikely(slop)) {
 > -		__le32 pad;
 > +		unsigned char slop_buf[4];
 > +		unsigned char *trailing_buf = buf + buflen - slop;
 > +
 > +		words = (slop + 1) >> 1;
 >  		if (rw == READ) {
 > -			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 > -			memcpy(buf + buflen - slop, &pad, slop);
 > +			ioread16_rep(data_addr, slop_buf, words);
 > +			memcpy(trailing_buf, slop_buf, slop);
 >  		} else {
 > -			memcpy(&pad, buf + buflen - slop, slop);
 > -			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 > +			memcpy(slop_buf, trailing_buf, slop);
 > +			slop_buf[slop] = 0;
 > +			iowrite16_rep(data_addr, slop_buf, words);
 >  		}
 > -		words++;
 >  	}
 > -	return words << 2;
 > +
 > +	return buflen + (slop & 1);
 >  }
 >  EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);

Thanks, this patch also fixes the 2.6.29-rc bmdma32-related ata_piix regression
I reported, where having a specific CD drive connected causes a complete system
hang when init starts udev <http://marc.info/?l=linux-ide&m=123244042628229&w=2>.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>
