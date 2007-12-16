Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbXLPVDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbXLPVDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbXLPVDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:03:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:60647 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbXLPVDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:03:13 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
Date: Sun, 16 Dec 2007 16:01:34 -0500
User-Agent: KMail/1.9.7
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org, axboe@kernel.dk
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
In-Reply-To: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1459177.AS858I7ALR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200712161601.41785.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1459177.AS858I7ALR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 15 December 2007, Adrian McMenamin wrote:
> diff -ruN ./linux-2.6-orig/drivers/sh/gdrom/gdrom.c
> ./linux-2.6/drivers/sh/gdrom/gdrom.c

i think your e-mail client word wrapped a little ...

> +	if (gd.toc)
> +		kfree(gd.toc);

i dont know how the kernel functions, but in userspace, free(NULL) is=20
acceptable ...

> +		memcpy(gd.toc, tocB, sizeof (struct gdromtoc));
> +	else
> +		memcpy(gd.toc, tocA, sizeof (struct gdromtoc));

since gd.toc and toc[BA] are of the same type, cant you just:
*gd.toc =3D *tocA

also, since tocB/tocA only exist in this function (you kzalloc() at the top=
=20
and kfree() at the bottom), and you dont do something like "gd.toc =3D tocA=
",=20
why use the memory allocator at all ?  i dont think they are too large for=
=20
the stack (~400bytes a piece) ... maybe they are ...

> +static int gdrom_open(struct cdrom_device_info *cd_info, int purpose)
> +{
> +	int err;
> +	/* spin up the disk */
> +	err =3D gdrom_preparedisk_cmd();
> +	if (err)
> +		return -EIO;
> +
> +	return 0;
> +}

is it normal to normalize all errors like this ?  it'd be a much simpler=20
function like:
{ return gdrom_preparedisk_cmd(); }

> +static irqreturn_t gdrom_command_interrupt(int irq, void *dev_id)
> +{
> +	if (dev_id !=3D &gd)
> +		return IRQ_NONE;
> +	gd.status =3D ctrl_inb(GDROM_STATUSCOMMAND_REG);
> +	if (gd.pending !=3D 1)
> +		return IRQ_HANDLED;
> ....
> +static irqreturn_t gdrom_dma_interrupt(int irq, void *dev_id)
> +{
> +	if (dev_id !=3D &gd)
> +		return IRQ_NONE;
> +	gd.status =3D ctrl_inb(GDROM_STATUSCOMMAND_REG);
> +	if (gd.transfer !=3D 1)
> +		return IRQ_HANDLED;

if you dont have a pending interrupt, shouldnt it return IRQ_NONE here ?  P=
aul=20
already mentioned the weird dev_id check.

> +static int gdrom_readdisk_dma(int block, int block_cnt, char *buffer)
> +{
> +	int err;
> +	struct packet_command *read_command;
> +	/* release the spin lock but check later
> + 	 * we're not in the middle of some dma */
> +	spin_unlock(&gdrom_lock);
> +	ctrl_outl(0x8843407F, GDROM_DMA_ACCESS_CTRL_REG); /* memory setting */

it'd be nice if these magic #'s had more explanation behind them, but you m=
ay=20
simply not have that information :/

> +static void gdrom_request(struct request_queue *rq)
> +{
> +	struct request *req;
> +	unsigned long pages;
> +	pages =3D rq->backing_dev_info.ra_pages;
> +	while ((req =3D elv_next_request(rq)) !=3D NULL) {
> +		if (! blk_fs_request(req)) {
> +			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
> +			end_request(req, 0);
> +		}
> +		if (rq_data_dir(req)) {
> +			printk(KERN_NOTICE "GDROM: Read only device - write request
> ignored\n"); +			end_request(req, 0);
> +		}
> +		if (req->nr_sectors) {
> +			gdrom_request_handler_dma(req);
> +		}
> +	}
> +}

no need for all the {} in the last two if()'s

> +/* Print string identifying GD ROM device */
> +static void gdrom_outputversion(void)
> +{
> +	struct gdrom_id *id;
> +	char *model_name, *manuf_name, *firmw_ver;
> +	/* query device ID */
> +	id =3D kzalloc(sizeof(struct gdrom_id), GFP_KERNEL);

i dont know how other people feel, but i think the style:
sizeof(*id)
is cleaner and leads to less bitrot ... also, you dont have an "if (!id)"=20
check there ... Paul pointed out plenty of other stuff for this func ;)

also, wrt to sizes ("16" and "17"), arent there some defines you can key of=
f=20
of or something ?

> +MODULE_DESCRIPTION("GD-ROM Driver");

SEGA Dreamcast GD-ROM Driver ?
=2Dmike

--nextPart1459177.AS858I7ALR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR2WSNUFjO5/oN/WBAQLFzxAAg/1Wf6YX+tYtanqjCMUvsx+fYLkOFT35
xqeYbDvd6SQUSI2S2bhTDVSpDQK9TZIw34odME96ehF15dg0Us7XBI58PkqTOG7F
0hc9yV+X8VR6LDGW44UIHiNGZaUCIQFVCkgsSIc8QZ4Py67nMR0YC4xhTMzb8rVK
DgY5w1dpttyLKtKH74eMfnlfu/YLolA35q/ZbGsaOFDpfKR4B9zxr9KZMgXzblFx
dLQ89NplG6fV3VJwuH4ghQqwP0K7ghBcRqTX3gAZezbb1dGwvc3oGlI4ID3pTm1y
fPV2z9p03VRE4pP6CDGudbTMaE5+qRwpp/NVqb78ja+G6SGA8eHgAJbOleaHtgP0
EJBlvYzWYME1mDR4flxyVaMY9whTuww3Hgu23+P7vuBVS6i1BPitGPkX7GSSpQNN
9abN/+uEnMXqY1mm+6pP+o1S6VzNq1YbF3hrXaTfkS8gqYTdp51Uq0Z1Mz98YV7B
596ZNpjdK0EMbbVIhSz8rMG4CKxjxGrecvNo6F/Cv4sHUa6OOwyIFnTYl4CcqDJ2
tXtgIn/UqQyiVnHVCKcp568nHHzz6cwLrx12aVmw2XqWEpQNM2QfNXrT9njwG4S1
4S+uJkvmY8U12SR5v6LXNryxQdTViSuefhnDzmFkCfGR1Q0lbwshOz/iDJ/Aamyq
EvoH62cIzGA=
=bzUW
-----END PGP SIGNATURE-----

--nextPart1459177.AS858I7ALR--
