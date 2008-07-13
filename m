Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYGMLrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYGMLrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 07:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYGMLrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 07:47:22 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:51069 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYGMLrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 07:47:21 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_it821x completely broken
Date: Sun, 13 Jul 2008 13:47:12 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <20080711211409.2eef4ddb@lxorguk.ukuu.org.uk> <200807122342.12841.linux@rainbow-software.org>
In-Reply-To: <200807122342.12841.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131347.14045.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 July 2008 23:42:10 Ondrej Zary wrote:
> On Friday 11 July 2008 22:14:09 Alan Cox wrote:
> > > > commenting out the error check after ata_dev_init_params() call in
> > > > ata_dev_read_id() function (libata-core.c), I got at least the device
> > > > name. The capacity is 0 so it doesn't work, obviously:
> >
> > If you don't read the ID then it wouldn't.
> >
> > > I captured the IDENTIFY data from the virtual device. I'm not ATA guru
> > > but looking at the data, there are zeros at many places where something
> > > should be. That number starting at 0x78 looks like size of the array in
> > > sectors (0x4C726C or 0x4C6C72 - the array is built from 2.5GB and 6.4GB
> > > drives).
> >
> > The Ident data for the virtual device is fairly sparse but the specs
> > don't require a lot of the field are filled in and only the LBA really
> > matters.
>
> The problem is that ata_id_n_sectors() function:
>
> static u64 ata_id_n_sectors(const u16 *id)
> {
>         if (ata_id_has_lba(id)) {
>                 if (ata_id_has_lba48(id))
>                         return ata_id_u64(id, 100);
>                 else
>                         return ata_id_u32(id, 60);
>         } else {
>                 if (ata_id_current_chs_valid(id))
>                         return ata_id_u32(id, 57);
>                 else
>                         return id[1] * id[3] * id[6];
>         }
> }
>
> fails to retrieve the LBA48 value.
>
>
> This is because the ata_id_has_lba() test
>
> #define ata_id_has_lba(id)      ((id)[49] & (1 << 9))
>
> fails as the identify data contains only zeros at word 49 (byte 0x62).
>
> Another problem is that ata_id_has_lba48() would fail too - that will break
> array over 2TB (if the controller BIOS and firmware can do it).
>
> Looks like this needs to force LBA48 with these virtual drives.

The patch below fixes the IDENTIFY problem for me and makes the RAID array accessible.
Is it OK or is there a better way to do it?

--- linux-2.6.25.3-orig/drivers/ata/libata-core.c	2008-07-13 12:27:56.000000000 +0200
+++ linux-2.6.25.3-pentium/drivers/ata/libata-core.c	2008-07-13 13:30:51.000000000 +0200
@@ -2217,7 +2217,8 @@
 		 * Note that ATA4 says lba is mandatory so the second check
 		 * shoud never trigger.
 		 */
-		if (ata_id_major_version(id) < 4 || !ata_id_has_lba(id)) {
+		if ((ata_id_major_version(id) < 4 || !ata_id_has_lba(id)) &&
+		    id[3] != 0 && id[6] != 0) {
 			err_mask = ata_dev_init_params(dev, id[3], id[6]);
 			if (err_mask) {
 				rc = -EIO;
@@ -2375,18 +2376,23 @@
 					       "not be fully accessable.\n");
 		}
 
-		dev->n_sectors = ata_id_n_sectors(id);
+		if (dev->horkage & ATA_HORKAGE_LBA48_FORCE)
+			dev->n_sectors = ata_id_u64(id, 100);
+		else
+			dev->n_sectors = ata_id_n_sectors(id);
 
 		if (dev->id[59] & 0x100)
 			dev->multi_count = dev->id[59] & 0xff;
 
-		if (ata_id_has_lba(id)) {
+		if (ata_id_has_lba(id) ||
+		    dev->horkage & ATA_HORKAGE_LBA48_FORCE) {
 			const char *lba_desc;
 			char ncq_desc[20];
 
 			lba_desc = "LBA";
 			dev->flags |= ATA_DFLAG_LBA;
-			if (ata_id_has_lba48(id)) {
+			if (ata_id_has_lba48(id) ||
+			    dev->horkage & ATA_HORKAGE_LBA48_FORCE) {
 				dev->flags |= ATA_DFLAG_LBA48;
 				lba_desc = "LBA48";
 
@@ -4452,6 +4458,9 @@
 	{ "TSSTcorp CDDVDW SH-S202N", "SB00",	  ATA_HORKAGE_IVB, },
 	{ "TSSTcorp CDDVDW SH-S202N", "SB01",	  ATA_HORKAGE_IVB, },
 
+	/* Has LBA48 but advertises neither LBA nor LBA48 */
+	{ "Integrated Technology Express Inc", NULL, ATA_HORKAGE_LBA48_FORCE, },
+
 	/* End Marker */
 	{ }
 };
--- linux-2.6.25.3-orig/include/linux/libata.h	2008-07-13 12:28:50.000000000 +0200
+++ linux-2.6.25.3-pentium/include/linux/libata.h	2008-07-13 11:29:39.000000000 +0200
@@ -339,6 +339,7 @@
 	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
 	ATA_HORKAGE_STUCK_ERR	= (1 << 9),	/* stuck ERR on next PACKET */
+	ATA_HORKAGE_LBA48_FORCE = (1 << 10),	/* Has hidden LBA48 */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */


-- 
Ondrej Zary
