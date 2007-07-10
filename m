Return-Path: <linux-kernel-owner+w=401wt.eu-S1763917AbXGJSJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763917AbXGJSJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761972AbXGJSJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:09:39 -0400
Received: from users.crfreenet.org ([81.92.145.1]:41163 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761298AbXGJSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:09:37 -0400
X-Greylist: delayed 1133 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 14:09:37 EDT
Date: Tue, 10 Jul 2007 19:50:39 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: Re: [Linux-fbdev-devel] [GEODE] Add framebuffer support for the AMD Geode LX
Message-ID: <20070710175039.GB32055@localhost.localdomain>
References: <20070709173211.GA6157@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20070709173211.GA6157@cosmic.amd.com>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 09, 2007 at 11:32:11AM -0600, Jordan Crouse wrote:
> +const struct fb_videomode geode_modedb[] __initdata =3D {
> +	/* 640x480-60 */
> +	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
> +	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
> +	  FB_VMODE_NONINTERLACED, 0 },
> +	/* 640x400-70 */
> +	{ NULL, 70, 640, 400, 39770, 40, 8, 28, 5, 96, 2,
> +	  FB_SYNC_HOR_HIGH_ACT,
> +	  FB_VMODE_NONINTERLACED, 0 },
> +	/* 640x480-70 */

This looks like standard timings, is there any reason why not
use modes from modedb.c?

> +static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info =
*info)
> +{
> +	if (var->xres > 1920 || var->yres > 1440)
> +		return -EINVAL;
> +
> +	if (var->bits_per_pixel =3D=3D 32) {
> +		var->red.offset   =3D 16; var->red.length   =3D 8;
> +		var->green.offset =3D  8; var->green.length =3D 8;
> +		var->blue.offset  =3D  0; var->blue.length  =3D 8;
> +	} else if (var->bits_per_pixel =3D=3D 16) {
> +		var->red.offset   =3D 11; var->red.length   =3D 5;
> +		var->green.offset =3D  5; var->green.length =3D 6;
> +		var->blue.offset  =3D  0; var->blue.length  =3D 5;
> +	} else if (var->bits_per_pixel =3D=3D 8) {
> +		var->red.offset   =3D 0; var->red.length   =3D 8;
> +		var->green.offset =3D 0; var->green.length =3D 8;
> +		var->blue.offset  =3D 0; var->blue.length  =3D 8;
> +	} else
> +		return -EINVAL;

Clear var->{color}.msb_right ?

If don't support panning, it should ensure that
xres_virtual =3D=3D xres and yres_virtual =3D=3D yres

> +static int __init lxfb_map_video_memory(struct fb_info *info,
> +					struct pci_dev *dev)
> +{
> +	struct lxfb_par *par =3D info->par;
> +	int ret;
> +
> +	ret =3D pci_enable_device(dev);
> +
> +	if (ret)
> +		return ret;
> +
> +	ret =3D pci_request_region(dev, 0, "lxfb-framebuffer");
> +
> +	if (ret)
> +		return ret;
> +
> +	ret =3D pci_request_region(dev, 1, "lxfb-gp");
> +
> +	if (ret)
> +		return ret;
> +
=2E..

Free allocated regions in a case of a error?

> +
> +	ret =3D -ENOMEM;
> +
> +	if (info->screen_base =3D=3D NULL)
> +		return ret;
> +
> +	par->gp_regs =3D ioremap(pci_resource_start(dev, 1),
> +				pci_resource_len(dev, 1));

pci_iomap(dev, 1, 0) ?

> +static struct fb_info * __init lxfb_init_fbinfo(struct device *dev)
> +{
> +	struct lxfb_par *par;
> +	struct fb_info *info;
> +
> +	/* Alloc enough space for the pseudo palette. */
> +	info =3D framebuffer_alloc(sizeof(struct lxfb_par) + sizeof(u32) * 16,
> +				 dev);

What about adding u32 pseudo_palette[16] at the end of struct lxfb_par
instead of that trick?

> +module_param(mode_option, charp, 0);
> +MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
> +
> +module_param(fbsize, int, 0);
> +MODULE_PARM_DESC(fbsize, "video memory size");

What about adding module params for noclear, nopanel and nocrt ?


> +static void lx_set_clock(struct fb_info *info)
> +{
> +	unsigned int diff, min, best =3D 0;
> +	unsigned int freq, i;
> +
> +	freq =3D (unsigned int) (0x3b9aca00 / info->var.pixclock);

Here using 0x3b9aca00 instead of 1000000000 is obscuring.

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org, jabber: santiago@=
njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkaTxu8ACgkQw1GB2RHercNKmwCdFUc3zIt5adxAoJw1uWiqCPZ+
KWUAn1yrqJNf5ebeXAFtqYevxfpiAHZ/
=2YQa
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
