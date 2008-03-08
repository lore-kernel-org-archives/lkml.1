Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYCHSbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYCHSbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYCHSba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:31:30 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:45422
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbYCHSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:31:29 -0500
Date: Sat, 8 Mar 2008 10:31:25 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with ATACB
Message-ID: <20080308183125.GB2820@one-eyed-alien.net>
Mail-Followup-To: matthieu castet <castet.matthieu@free.fr>,
	linux-usb@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <47D2CD95.9070701@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <47D2CD95.9070701@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Sat, 08 Mar 2008 10:31:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Why are you using an initializer instead of a new protocol code?

Most of this should probably be moved into it's own file, just like all of
the other protocol handlers.

Actually, why do you even have a separate 'dispatcher' function?  Why not
just one protocol handler function which checks the command at the top and
calls invoke_transport there?

Also, unless ATACB is a new standard (and I don't think it is, as the
Cypress datasheet uses the term 'vendor specific'), then your functions
need renaming.  Instead of 'emulate_pass_thru_with_atacb', how about
something like 'cypress_atacb' --  since it's already a protocol handler,
everyone already knows it's for passing commands.

Matt

On Sat, Mar 08, 2008 at 06:32:05PM +0100, matthieu castet wrote:
> Hi,
>=20
> I have got a cypress usb-ide bridge and I would like to tune or monitor
> my disk with tools like hdparm, hddtemp or smartctl.
>=20
> My controller support a way to send raw ATA command to the disk with
> something call atacb (see
> http://download.cypress.com.edgesuite.net/design_resources/datasheets/con=
tents/cy7c68300c_8.pdf).
>=20
> Atacb support can be added for each application, but there is some=20
> disadvantages :
> - all application need to be patched
> - A race is possible if there other accesses, because the emulation can
> be split in 2 atacb scsi transactions. One for sending the command, one
> for reading the register (if ck_cond is set).
>=20
> I have implemented the emulation in usb-storage with a special=20
> proto_handler,
> and an unsual entry.
>=20
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
>=20
> Index: linux-2.6.24.2/drivers/usb/storage/protocol.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24.2.orig/drivers/usb/storage/protocol.c	2008-02-29=20
> 22:14:09.000000000 +0100
> +++ linux-2.6.24.2/drivers/usb/storage/protocol.c	2008-03-08=20
> 18:18:22.000000000 +0100
> @@ -47,6 +47,8 @@
>  #include <linux/highmem.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_eh.h>
> +#include <linux/ata.h>
>=20
>  #include "usb.h"
>  #include "protocol.h"
> @@ -144,6 +146,179 @@
>  	usb_stor_invoke_transport(srb, us);
>  }
>=20
> +/*
> + * ATACB is a protocol used on cypress usb<->ata bridge to
> + * send raw ATA command over mass storage
> + * There is a ATACB2 protocol that support LBA48 on newer chip.
> + * More info that be found on cy7c68310_8.pdf and cy7c68300c_8.pdf
> + * datasheet from cypress.com.
> + */
> +static void emulate_pass_thru_with_atacb(struct scsi_cmnd *srb,
> +				       struct us_data *us)
> +{
> +	unsigned char save_cmnd[MAX_COMMAND_SIZE];
> +	memcpy(save_cmnd, srb->cmnd, sizeof(save_cmnd));
> +	memset(srb->cmnd, 0, sizeof(srb->cmnd));
> +
> +	/* check if we support the command */
> +	if (save_cmnd[1] >> 5) /* MULTIPLE_COUNT */
> +		goto invalid_fld;
> +	/* check protocol */
> +	switch((save_cmnd[1] >> 1) & 0xf) {
> +		case 3:
> +		case 4:
> +		case 5:
> +			break;
> +		default:
> +			goto invalid_fld;
> +	}
> +
> +	/* first build the ATACB command */
> +	srb->cmd_len =3D 16;
> +
> + 	/* this value can change, but most(all ?) manufacturers keep the=20
> cypress
> +	 * default : 0x24
> +	 */
> +	srb->cmnd[0] =3D 0x24;
> +	srb->cmnd[1] =3D 0x24;
> +	srb->cmnd[2] =3D 0;
> +
> +	srb->cmnd[3] =3D 0xff - 1;
> +	srb->cmnd[4] =3D 1;
> +
> +	if (save_cmnd[0] =3D=3D ATA_16) {
> +		srb->cmnd[6] =3D save_cmnd[4]; /* features */
> +		srb->cmnd[7] =3D save_cmnd[6]; /* sector count */
> +		srb->cmnd[8] =3D save_cmnd[8]; /* lba low */
> +		srb->cmnd[9] =3D save_cmnd[10]; /* lba med */
> +		srb->cmnd[10] =3D save_cmnd[12]; /* lba high */
> +		srb->cmnd[11] =3D save_cmnd[13]; /* device */
> +		srb->cmnd[12] =3D save_cmnd[14]; /* command */
> +
> +		if (save_cmnd[1] & 0x01) {/* extended bit set for LBA48 */
> +			/* this could be supported by atacb2 */
> +			if (save_cmnd[3] || save_cmnd[5] || save_cmnd[7] ||=20
> save_cmnd[9]
> +					|| save_cmnd[11])
> +				goto invalid_fld;
> +		}
> +	}
> +	else { /* ATA12 */
> +		srb->cmnd[6] =3D save_cmnd[3]; /* features */
> +		srb->cmnd[7] =3D save_cmnd[4]; /* sector count */
> +		srb->cmnd[8] =3D save_cmnd[5]; /* lba low */
> +		srb->cmnd[9] =3D save_cmnd[6]; /* lba med */
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
> +	if (srb->cmnd[12] =3D=3D ATA_CMD_ID_ATA || srb->cmnd[12] =3D=3D=20
> ATA_CMD_ID_ATAPI)
> +		srb->cmnd[2] |=3D (1<<7);
> +
> +
> +	usb_stor_invoke_transport(srb, us);
> +
> +	/* if the device doesn't support ATACB
> +	 * abort and register usb_stor_transparent_scsi_command
> +	 * callback
> +	 */
> +	if (srb->result =3D=3D SAM_STAT_CHECK_CONDITION &&
> +			memcmp(srb->sense_buffer, usb_stor_sense_invalidCDB,
> +				sizeof(usb_stor_sense_invalidCDB)) =3D=3D 0) {
> +		us->proto_handler =3D usb_stor_transparent_scsi_command;
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
> +		unsigned char sk, asc, ascq;
> +		unsigned char regs[8];
> +		unsigned char *sb =3D srb->sense_buffer;
> +		unsigned char *desc =3D sb + 8;
> +		int tmp_result;
> +
> +		sk =3D RECOVERED_ERROR;
> +		asc =3D 0; /* ATA PASS THROUGH INFORMATION AVAILABLE */
> +		ascq =3D 0x1D;
> +
> +		/* read registers */
> +		srb->cmnd[2] =3D 1;
> +		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, 0);
> +		srb->request_buffer =3D regs;
> +		srb->request_bufflen =3D sizeof(regs);
> +		srb->sc_data_direction =3D DMA_FROM_DEVICE;
> +
> +		usb_stor_invoke_transport(srb, us);
> +		tmp_result =3D srb->result;
> +		scsi_eh_restore_cmnd(srb, &ses);
> +		/* we fail to get registers, report invalid command */
> +		if (tmp_result !=3D SAM_STAT_GOOD)
> +			goto invalid_fld;
> +
> +		/* build the sense */
> +		memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
> +
> +		/* XXX we should generate sk, asc, ascq from status and error
> +		 * regs
> +		 * (see 11.1 Error translation =AD ATA device error to SCSI=20
> error map)
> +		 * and ata_to_sense_error from libata.
> +		 */
> +		sb[1] =3D sk;
> +		sb[2] =3D asc;
> +		sb[3] =3D ascq;
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
> +		desc[2] =3D 0x00;
> +		desc[3] =3D regs[1];
> +		desc[5] =3D regs[2];
> +		desc[7] =3D regs[3];
> +		desc[9] =3D regs[4];
> +		desc[11] =3D regs[5];
> +		desc[12] =3D regs[6];
> +		desc[13] =3D regs[7];
> +
> +		srb->result =3D (DRIVER_SENSE << 24) |=20
> SAM_STAT_CHECK_CONDITION;
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
> +
> +void usb_stor_transparent_scsi_command_atacb(struct scsi_cmnd *srb,
> +				       struct us_data *us)
> +{
> +	if (srb->cmnd[0] !=3D ATA_16 && srb->cmnd[0] !=3D ATA_12)
> +		usb_stor_invoke_transport(srb, us);
> +	else
> +		emulate_pass_thru_with_atacb(srb, us);
> +}
> +
>  /***********************************************************************
>   * Scatter-gather transfer buffer access routines
>   ***********************************************************************/
> Index: linux-2.6.24.2/drivers/usb/storage/initializers.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24.2.orig/drivers/usb/storage/initializers.c	2008-02-29=20
> 22:14:09.000000000 +0100
> +++ linux-2.6.24.2/drivers/usb/storage/initializers.c	2008-03-08=20
> 18:30:00.000000000 +0100
> @@ -43,6 +43,7 @@
>  #include "initializers.h"
>  #include "debug.h"
>  #include "transport.h"
> +#include "protocol.h"
>=20
>  /* This places the Shuttle/SCM USB<->SCSI bridge devices in multi-target
>   * mode */
> @@ -104,3 +105,11 @@
>  	US_DEBUGP("usb_control_msg performing result is %d\n", result);
>  	return (result ? 0 : -1);
>  }
> +
> +/* This function register the atacb proto callback */
> +int usb_atacb_init(struct us_data *us)
> +{
> +	us->proto_handler =3D usb_stor_transparent_scsi_command_atacb;
> +	US_DEBUGP("atacb proto_handler is set\n");
> +	return 0;
> +}
> Index: linux-2.6.24.2/drivers/usb/storage/initializers.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24.2.orig/drivers/usb/storage/initializers.h	2008-02-29=20
> 22:14:09.000000000 +0100
> +++ linux-2.6.24.2/drivers/usb/storage/initializers.h	2008-03-08=20
> 18:28:33.000000000 +0100
> @@ -50,3 +50,6 @@
>=20
>  /* This places the HUAWEI E220 devices in multi-port mode */
>  int usb_stor_huawei_e220_init(struct us_data *us);
> +
> +/* This function register the atacb proto callback */
> +int usb_atacb_init(struct us_data *us);
> Index: linux-2.6.24.2/drivers/usb/storage/protocol.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24.2.orig/drivers/usb/storage/protocol.h	2008-02-29=20
> 22:14:09.000000000 +0100
> +++ linux-2.6.24.2/drivers/usb/storage/protocol.h	2008-02-29=20
> 22:16:03.000000000 +0100
> @@ -47,6 +47,8 @@
>  extern void usb_stor_ufi_command(struct scsi_cmnd*, struct us_data*);
>  extern void usb_stor_transparent_scsi_command(struct scsi_cmnd*,
>  		struct us_data*);
> +extern void usb_stor_transparent_scsi_command_atacb(struct scsi_cmnd*,
> +		struct us_data*);
>=20
>  /* struct scsi_cmnd transfer buffer access utilities */
>  enum xfer_buf_dir	{TO_XFER_BUF, FROM_XFER_BUF};
> Index: linux-2.6.24.2/drivers/usb/storage/unusual_devs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24.2.orig/drivers/usb/storage/unusual_devs.h	2008-02-29=20
> 22:14:09.000000000 +0100
> +++ linux-2.6.24.2/drivers/usb/storage/unusual_devs.h	2008-02-29=20
> 22:16:03.000000000 +0100
> @@ -1588,6 +1588,12 @@
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_CAPACITY_HEURISTICS),
>=20
> +UNUSUAL_DEV(  0x04b4, 0x6830, 0x0000, 0x9999,
> +		"Cypress",
> +		"Cypress AT2LP",
> +		US_SC_SCSI, US_PR_BULK, usb_atacb_init,
> +		US_FL_NEED_OVERRIDE),
> +
>  /* Control/Bulk transport for all SubClass values */
>  USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
>  USUAL_DEV(US_SC_8020, US_PR_CB, USB_US_TYPE_STOR),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH0tt9HL9iwnUZqnkRAlMiAKCLRD1Nh5IamwAhXAnD0im2vIwwxQCcCIk/
n6nsa9YmDmo4QLVP6qSN414=
=iW6+
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
