Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbYA2Glt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbYA2Glt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYA2Gli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:41:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:34932 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYA2Glg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:41:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type;
        b=o5HOqcRnJsiWeLtygQZRkUZOb8OIRDWiuAziyQG5H4PzNSwH3Js6CfJz+od6SB6Ecxh6f/rTWbuDpWHoZTDpovcBFih0kUSPP6gM/c/DvTyWN5dt6AZ8xHnJhxsNsBgsuHv0PFWbKCcqIcKc6jB5mCivSfzLEiJyCQ2cF2bw5sA=
Date: Tue, 29 Jan 2008 07:41:27 +0100
From: Florian Attenberger <valdyn@gmail.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Message-Id: <20080129074127.5699afcf.valdyn@gmail.com>
In-Reply-To: <200801281413.21347.gene.heskett@gmail.com>
References: <200801272122.21823.gene.heskett@gmail.com>
	<479E2832.3070006@garzik.org>
	<200801281413.21347.gene.heskett@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jan_2008_07_41_27_+0100_XIPigDGHs5fxfvA5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jan_2008_07_41_27_+0100_XIPigDGHs5fxfvA5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Jan 2008 14:13:21 -0500
Gene Heskett <gene.heskett@gmail.com> wrote:


> >> I had to reboot early this morning due to a freezeup, and I had a
> >> bunch of these in the messages log:
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> Jan 27 19:42:11 coyote kernel: [42461.915961] ata1.00: exception Emask=
 0x0
> >> SAct 0x0 SErr 0x0 action 0x2 frozen Jan 27 19:42:11 coyote kernel:
> >> [42461.915973] ata1.00: cmd ca/00:08:b1:66:46/00:00:00:00:00/e8 tag 0 =
dma
> >> 4096 out Jan 27 19:42:11 coyote kernel: [42461.915974]          res
> >> 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout) Jan 27 19:42:11
> >> coyote kernel: [42461.915978] ata1.00: status: { DRDY } Jan 27 19:42:11
> >> coyote kernel: [42461.916005] ata1: soft resetting link Jan 27 19:42:12
> >> coyote kernel: [42462.078216] ata1.00: configured for UDMA/100 Jan 27
> >> 19:42:12 coyote kernel: [42462.078232] ata1: EH complete
> >> Jan 27 19:42:12 coyote kernel: [42462.090700] sd 0:0:0:0: [sda] 390721=
968
> >> 512-byte hardware sectors (200050 MB) Jan 27 19:42:12 coyote kernel:
> >> [42462.114230] sd 0:0:0:0: [sda] Write Protect is off Jan 27 19:42:12
> >> coyote kernel: [42462.115079] sd 0:0:0:0: [sda] Write cache: enabled, =
read
> >> cache: enabled, doesn't support DPO or FUA
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


I had this error too, or maybe only a similar one, and another, neither
of which of i still have the error output laying around, so I'm posting both
fixes, that i found here on lkml:
1) disabling ncq like that:
"echo 1 > /sys/block/sda/device/queue_depth"=20
2) this patch: libata_drain_fifo_on_stuck_drq_hsm.patch=20
( applies to 2.6.24 too )

Signed-off-by: Mark Lord <mlord@pobox.com>
---

--- old/drivers/ata/libata-sff.c	2007-09-28 09:29:22.000000000 -0400
+++ linux/drivers/ata/libata-sff.c	2007-09-28 09:39:44.000000000 -0400
@@ -420,6 +420,28 @@
 	ap->ops->irq_on(ap);
 }
=20
+static void ata_drain_fifo(struct ata_port *ap, struct ata_queued_cmd *qc)
+{
+	u8 stat =3D ata_chk_status(ap);
+	/*
+	 * Try to clear stuck DRQ if necessary,
+	 * by reading/discarding up to two sectors worth of data.
+	 */
+	if ((stat & ATA_DRQ) && (!qc || qc->dma_dir !=3D DMA_TO_DEVICE)) {
+		unsigned int i;
+		unsigned int limit =3D qc ? qc->sect_size : ATA_SECT_SIZE;
+
+		printk(KERN_WARNING "Draining up to %u words from data FIFO.\n",
+									limit);
+		for (i =3D 0; i < limit ; ++i) {
+			ioread16(ap->ioaddr.data_addr);
+			if (!(ata_chk_status(ap) & ATA_DRQ))
+				break;
+		}
+		printk(KERN_WARNING "Drained %u/%u words.\n", i, limit);
+	}
+}
+
 /**
  *	ata_bmdma_drive_eh - Perform EH with given methods for BMDMA controller
  *	@ap: port to handle error for
@@ -476,7 +498,7 @@
 	}
=20
 	ata_altstatus(ap);
-	ata_chk_status(ap);
+	ata_drain_fifo(ap, qc);
 	ap->ops->irq_clear(ap);
=20
 	spin_unlock_irqrestore(ap->lock, flags);
-





--=20
Florian Attenberger <valdyn@gmail.com>

--Signature=_Tue__29_Jan_2008_07_41_27_+0100_XIPigDGHs5fxfvA5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHnsqa2VhSN8sRLIwRAjwUAJ9pMY+Qqzw/38WAlqAGGa/NsteyaQCgsJne
ntkK7ss5b5qVKoq2HMPE8og=
=4xgP
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jan_2008_07_41_27_+0100_XIPigDGHs5fxfvA5--
