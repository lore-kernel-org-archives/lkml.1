Return-Path: <linux-kernel-owner+w=401wt.eu-S937278AbYCSV14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937278AbYCSV14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYCSUDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:03:09 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:34708
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbYCSUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:03:04 -0400
Date: Wed, 19 Mar 2008 13:02:58 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       USB Storage List <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with ATACB
Message-ID: <20080319200258.GZ2820@one-eyed-alien.net>
Mail-Followup-To: matthieu castet <castet.matthieu@free.fr>,
	linux-usb@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	USB Storage List <usb-storage@lists.one-eyed-alien.net>
References: <47D2F23A.4020103@free.fr> <20080308212148.GC2820@one-eyed-alien.net> <47D39E14.9050900@free.fr> <20080309184524.GF2820@one-eyed-alien.net> <47D459DA.20207@free.fr> <20080310012014.GG2820@one-eyed-alien.net> <47D99B01.1030709@free.fr> <20080314005139.GP2820@one-eyed-alien.net> <20080318221207.GY2820@one-eyed-alien.net> <47E15E34.4080204@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VIFPKPeEU/ajvd6j"
Content-Disposition: inline
In-Reply-To: <47E15E34.4080204@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 19 Mar 2008 13:02:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VIFPKPeEU/ajvd6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Looks good to me.  Greg, please apply.

Signed-off-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Matt

On Wed, Mar 19, 2008 at 07:40:52PM +0100, matthieu castet wrote:
>=20
> I have got a cypress usb-ide bridge and I would like to tune or monitor
> my disk with tools like hdparm, hddtemp or smartctl.
>=20
> My controller support a way to send raw ATA command to the disk with
> something call atacb (see
> http://download.cypress.com.edgesuite.net/design_resources/datasheets/con=
tents/cy7c68300c_8.pdf).
>=20
> Atacb support can be added for each application, but there is some disadv=
antages :
> - all application need to be patched
> - A race is possible if there other accesses, because the emulation can
> be split in 2 atacb scsi transactions. One for sending the command, one
> for reading the register (if ck_cond is set).=20
>=20
> I have implemented the emulation in usb-storage with a special proto_hand=
ler,
> and an unsual entry.
>=20
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
>=20
> Index: linux-2.6/drivers/usb/storage/unusual_devs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/usb/storage/unusual_devs.h	2008-02-28 11:21:20=
.000000000 +0100
> +++ linux-2.6/drivers/usb/storage/unusual_devs.h	2008-03-13 21:19:21.0000=
00000 +0100
> @@ -1620,6 +1620,14 @@
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_CAPACITY_HEURISTICS),
> =20
> +#ifdef CONFIG_USB_STORAGE_CYPRESS_ATACB
> +UNUSUAL_DEV(  0x04b4, 0x6830, 0x0000, 0x9999,
> +		"Cypress",
> +		"Cypress AT2LP",
> +		US_SC_CYP_ATACB, US_PR_BULK, NULL,
> +		0),
> +#endif
> +
>  /* Control/Bulk transport for all SubClass values */
>  USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
>  USUAL_DEV(US_SC_8020, US_PR_CB, USB_US_TYPE_STOR),
> Index: linux-2.6/drivers/usb/storage/cypress_atacb.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/usb/storage/cypress_atacb.c	2008-03-19 19:34:11.000=
000000 +0100
> @@ -0,0 +1,200 @@
> +/*
> + * Support for emulating SAT (ata pass through) on devices based
> + *       on the Cypress USB/ATA bridge supporting ATACB.
> + *
> + * Copyright (c) 2008 Matthieu Castet (castet.matthieu@free.fr)
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, write to the Free Software Foundation, Inc=
.,
> + * 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_eh.h>
> +#include <linux/ata.h>
> +
> +#include "usb.h"
> +#include "protocol.h"
> +#include "scsiglue.h"
> +#include "debug.h"
> +
> +/*
> + * ATACB is a protocol used on cypress usb<->ata bridge to
> + * send raw ATA command over mass storage
> + * There is a ATACB2 protocol that support LBA48 on newer chip.
> + * More info that be found on cy7c68310_8.pdf and cy7c68300c_8.pdf
> + * datasheet from cypress.com.
> + */
> +void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
> +{
> +	unsigned char save_cmnd[MAX_COMMAND_SIZE];
> +
> +	if (likely(srb->cmnd[0] !=3D ATA_16 && srb->cmnd[0] !=3D ATA_12)) {
> +		usb_stor_transparent_scsi_command(srb, us);
> +		return;
> +	}
> +
> +	memcpy(save_cmnd, srb->cmnd, sizeof(save_cmnd));
> +	memset(srb->cmnd, 0, sizeof(srb->cmnd));
> +
> +	/* check if we support the command */
> +	if (save_cmnd[1] >> 5) /* MULTIPLE_COUNT */
> +		goto invalid_fld;
> +	/* check protocol */
> +	switch((save_cmnd[1] >> 1) & 0xf) {
> +		case 3: /*no DATA */
> +		case 4: /* PIO in */
> +		case 5: /* PIO out */
> +			break;
> +		default:
> +			goto invalid_fld;
> +	}
> +
> +	/* first build the ATACB command */
> +	srb->cmd_len =3D 16;
> +
> +	srb->cmnd[0] =3D 0x24; /* bVSCBSignature : vendor-specific command
> +	                        this value can change, but most(all ?) manufact=
urers
> +							keep the cypress default : 0x24 */
> +	srb->cmnd[1] =3D 0x24; /* bVSCBSubCommand : 0x24 for ATACB */
> +
> +	srb->cmnd[3] =3D 0xff - 1; /* features, sector count, lba low, lba med
> +								lba high, device, command are valid */
> +	srb->cmnd[4] =3D 1; /* TransferBlockCount : 512 */
> +
> +	if (save_cmnd[0] =3D=3D ATA_16) {
> +		srb->cmnd[ 6] =3D save_cmnd[ 4]; /* features */
> +		srb->cmnd[ 7] =3D save_cmnd[ 6]; /* sector count */
> +		srb->cmnd[ 8] =3D save_cmnd[ 8]; /* lba low */
> +		srb->cmnd[ 9] =3D save_cmnd[10]; /* lba med */
> +		srb->cmnd[10] =3D save_cmnd[12]; /* lba high */
> +		srb->cmnd[11] =3D save_cmnd[13]; /* device */
> +		srb->cmnd[12] =3D save_cmnd[14]; /* command */
> +
> +		if (save_cmnd[1] & 0x01) {/* extended bit set for LBA48 */
> +			/* this could be supported by atacb2 */
> +			if (save_cmnd[3] || save_cmnd[5] || save_cmnd[7] || save_cmnd[9]
> +					|| save_cmnd[11])
> +				goto invalid_fld;
> +		}
> +	}
> +	else { /* ATA12 */
> +		srb->cmnd[ 6] =3D save_cmnd[3]; /* features */
> +		srb->cmnd[ 7] =3D save_cmnd[4]; /* sector count */
> +		srb->cmnd[ 8] =3D save_cmnd[5]; /* lba low */
> +		srb->cmnd[ 9] =3D save_cmnd[6]; /* lba med */
> +		srb->cmnd[10] =3D save_cmnd[7]; /* lba high */
> +		srb->cmnd[11] =3D save_cmnd[8]; /* device */
> +		srb->cmnd[12] =3D save_cmnd[9]; /* command */
> +
> +	}
> +	/* Filter SET_FEATURES - XFER MODE command */
> +	if ((srb->cmnd[12] =3D=3D ATA_CMD_SET_FEATURES)
> +			&& (srb->cmnd[6] =3D=3D SETFEATURES_XFER))
> +		goto invalid_fld;
> +
> +	if (srb->cmnd[12] =3D=3D ATA_CMD_ID_ATA || srb->cmnd[12] =3D=3D ATA_CMD=
_ID_ATAPI)
> +		srb->cmnd[2] |=3D (1<<7); /* set  IdentifyPacketDevice for these cmds =
*/
> +
> +
> +	usb_stor_transparent_scsi_command(srb, us);
> +
> +	/* if the device doesn't support ATACB
> +	 */
> +	if (srb->result =3D=3D SAM_STAT_CHECK_CONDITION &&
> +			memcmp(srb->sense_buffer, usb_stor_sense_invalidCDB,
> +				sizeof(usb_stor_sense_invalidCDB)) =3D=3D 0) {
> +		US_DEBUGP("cypress atacb not supported ???\n");
> +		goto end;
> +	}
> +
> +	/* if ck_cond flags is set, and there wasn't critical error,
> +	 * build the special sense
> +	 */
> +	if ((srb->result !=3D (DID_ERROR << 16) &&
> +				srb->result !=3D (DID_ABORT << 16)) &&
> +			save_cmnd[2] & 0x20) {
> +		struct scsi_eh_save ses;
> +		unsigned char regs[8];
> +		unsigned char *sb =3D srb->sense_buffer;
> +		unsigned char *desc =3D sb + 8;
> +		int tmp_result;
> +
> +		/* build the command for
> +		 * reading the ATA registers */
> +		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, 0);
> +		srb->sdb.length =3D sizeof(regs);
> +		sg_init_one(&ses.sense_sgl, regs, srb->sdb.length);
> +		srb->sdb.table.sgl =3D &ses.sense_sgl;
> +		srb->sc_data_direction =3D DMA_FROM_DEVICE;
> +		srb->sdb.table.nents =3D 1;
> +		/* we use the same command as before, but we set
> +		 * the read taskfile bit, for not executing atacb command,
> +		 * but reading register selected in srb->cmnd[4]
> +		 */
> +		srb->cmnd[2] =3D 1;
> +
> +		usb_stor_transparent_scsi_command(srb, us);
> +		tmp_result =3D srb->result;
> +		scsi_eh_restore_cmnd(srb, &ses);
> +		/* we fail to get registers, report invalid command */
> +		if (tmp_result !=3D SAM_STAT_GOOD)
> +			goto invalid_fld;
> +
> +		/* build the sense */
> +		memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
> +
> +		/* set sk, asc for a good command */
> +		sb[1] =3D RECOVERED_ERROR;
> +		sb[2] =3D 0; /* ATA PASS THROUGH INFORMATION AVAILABLE */
> +		sb[3] =3D 0x1D;
> +
> +		/* XXX we should generate sk, asc, ascq from status and error
> +		 * regs
> +		 * (see 11.1 Error translation ? ATA device error to SCSI error map)
> +		 * and ata_to_sense_error from libata.
> +		 */
> +
> +		/* Sense data is current and format is descriptor. */
> +		sb[0] =3D 0x72;
> +		desc[0] =3D 0x09; /* ATA_RETURN_DESCRIPTOR */
> +
> +		/* set length of additional sense data */
> +		sb[7] =3D 14;
> +		desc[1] =3D 12;
> +
> +		/* Copy registers into sense buffer. */
> +		desc[ 2] =3D 0x00;
> +		desc[ 3] =3D regs[1];  /* features */
> +		desc[ 5] =3D regs[2];  /* sector count */
> +		desc[ 7] =3D regs[3];  /* lba low */
> +		desc[ 9] =3D regs[4];  /* lba med */
> +		desc[11] =3D regs[5];  /* lba high */
> +		desc[12] =3D regs[6];  /* device */
> +		desc[13] =3D regs[7];  /* command */
> +
> +		srb->result =3D (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
> +	}
> +	goto end;
> +invalid_fld:
> +	srb->result =3D (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
> +
> +	memcpy(srb->sense_buffer,
> +			usb_stor_sense_invalidCDB,
> +			sizeof(usb_stor_sense_invalidCDB));
> +end:
> +	memcpy(srb->cmnd, save_cmnd, sizeof(save_cmnd));
> +	if (srb->cmnd[0] =3D=3D ATA_12)
> +		srb->cmd_len =3D 12;
> +}
> Index: linux-2.6/drivers/usb/storage/cypress_atacb.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/usb/storage/cypress_atacb.h	2008-03-13 21:19:21.000=
000000 +0100
> @@ -0,0 +1,25 @@
> +/*
> + * Support for emulating SAT (ata pass through) on devices based
> + *       on the Cypress USB/ATA bridge supporting ATACB.
> + *
> + * Copyright (c) 2008 Matthieu Castet (castet.matthieu@free.fr)
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, write to the Free Software Foundation, Inc=
.,
> + * 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _CYPRESS_ATACB_H_
> +#define _CYPRESS_ATACB_H_
> +extern void cypress_atacb_passthrough(struct scsi_cmnd*, struct us_data*=
);
> +#endif
> Index: linux-2.6/drivers/usb/storage/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/usb/storage/Kconfig	2007-11-29 11:03:48.000000=
000 +0100
> +++ linux-2.6/drivers/usb/storage/Kconfig	2008-03-13 21:19:21.000000000 +=
0100
> @@ -145,6 +145,17 @@
>  	  on the resulting scsi device node returns the Karma to normal
>  	  operation.
> =20
> +config USB_STORAGE_CYPRESS_ATACB
> +	bool "SAT emulation on Cypress USB/ATA Bridge with ATACB"
> +	depends on USB_STORAGE
> +	---help---
> +	  Say Y here if you want to use SAT (ata pass through) on devices based
> +	  on the Cypress USB/ATA bridge supporting ATACB. This will allow you
> +	  to use tools to tune and monitor your drive (like hdparm or smartctl).
> +
> +	  If you say no here your device will still work with the standard usb
> +	  mass storage class.
> +
>  config USB_LIBUSUAL
>  	bool "The shared table of common (or usual) storage devices"
>  	depends on USB
> Index: linux-2.6/drivers/usb/storage/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/usb/storage/Makefile	2007-06-08 14:22:39.00000=
0000 +0200
> +++ linux-2.6/drivers/usb/storage/Makefile	2008-03-13 21:19:21.000000000 =
+0100
> @@ -21,6 +21,7 @@
>  usb-storage-obj-$(CONFIG_USB_STORAGE_ALAUDA)	+=3D alauda.o
>  usb-storage-obj-$(CONFIG_USB_STORAGE_ONETOUCH)	+=3D onetouch.o
>  usb-storage-obj-$(CONFIG_USB_STORAGE_KARMA)	+=3D karma.o
> +usb-storage-obj-$(CONFIG_USB_STORAGE_CYPRESS_ATACB) +=3D cypress_atacb.o
> =20
>  usb-storage-objs :=3D	scsiglue.o protocol.o transport.o usb.o \
>  			initializers.o $(usb-storage-obj-y)
> Index: linux-2.6/drivers/usb/storage/scsiglue.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/usb/storage/scsiglue.c	2008-02-05 09:42:21.000=
000000 +0100
> +++ linux-2.6/drivers/usb/storage/scsiglue.c	2008-03-13 21:19:21.00000000=
0 +0100
> @@ -132,7 +132,7 @@
>  		/* Disk-type devices use MODE SENSE(6) if the protocol
>  		 * (SubClass) is Transparent SCSI, otherwise they use
>  		 * MODE SENSE(10). */
> -		if (us->subclass !=3D US_SC_SCSI)
> +		if (us->subclass !=3D US_SC_SCSI && us->subclass !=3D US_SC_CYP_ATACB)
>  			sdev->use_10_for_ms =3D 1;
> =20
>  		/* Many disks only accept MODE SENSE transfer lengths of
> Index: linux-2.6/drivers/usb/storage/transport.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/usb/storage/transport.c	2008-02-28 11:21:20.00=
0000000 +0100
> +++ linux-2.6/drivers/usb/storage/transport.c	2008-03-13 21:19:21.0000000=
00 +0100
> @@ -603,7 +603,8 @@
>  		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, US_SENSE_SIZE);
> =20
>  		/* FIXME: we must do the protocol translation here */
> -		if (us->subclass =3D=3D US_SC_RBC || us->subclass =3D=3D US_SC_SCSI)
> +		if (us->subclass =3D=3D US_SC_RBC || us->subclass =3D=3D US_SC_SCSI ||
> +				us->subclass =3D=3D US_SC_CYP_ATACB)
>  			srb->cmd_len =3D 6;
>  		else
>  			srb->cmd_len =3D 12;
> Index: linux-2.6/drivers/usb/storage/usb.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/usb/storage/usb.c	2007-11-29 11:03:48.00000000=
0 +0100
> +++ linux-2.6/drivers/usb/storage/usb.c	2008-03-13 21:19:21.000000000 +01=
00
> @@ -101,6 +101,9 @@
>  #ifdef CONFIG_USB_STORAGE_KARMA
>  #include "karma.h"
>  #endif
> +#ifdef CONFIG_USB_STORAGE_CYPRESS_ATACB
> +#include "cypress_atacb.h"
> +#endif
> =20
>  /* Some informational data */
>  MODULE_AUTHOR("Matthew Dharm <mdharm-usb@one-eyed-alien.net>");
> @@ -708,6 +711,13 @@
>  		break;
>  #endif
> =20
> +#ifdef CONFIG_USB_STORAGE_CYPRESS_ATACB
> +	case US_SC_CYP_ATACB:
> +		us->protocol_name =3D "Transparent SCSI with Cypress ATACB";
> +		us->proto_handler =3D cypress_atacb_passthrough;
> +		break;
> +#endif
> +
>  	default:
>  		return -EIO;
>  	}
> Index: linux-2.6/include/linux/usb_usual.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/usb_usual.h	2008-02-05 09:42:23.00000000=
0 +0100
> +++ linux-2.6/include/linux/usb_usual.h	2008-03-13 21:20:33.000000000 +01=
00
> @@ -83,6 +83,7 @@
>  #define US_SC_LOCKABLE	0x07		/* Password-protected */
> =20
>  #define US_SC_ISD200    0xf0		/* ISD200 ATA */
> +#define US_SC_CYP_ATACB 0xf1		/* Cypress ATACB */
>  #define US_SC_DEVICE	0xff		/* Use device's value */
> =20
>  /* Protocols */


--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I could always suspend a few hundred accounts and watch what happens.
					-- Tanya
User Friendly, 7/31/1998

--VIFPKPeEU/ajvd6j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH4XFyHL9iwnUZqnkRAiVeAJ0c5P8hCvFJZDcevLMRH1jp739CJACeKK1c
ZcfoPlDJCb1mlFMrgCfaDXY=
=vb65
-----END PGP SIGNATURE-----

--VIFPKPeEU/ajvd6j--
