Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZKIWDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZKIWDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZKIWDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:03:01 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:59575
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466AbZKIWC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:02:59 -0500
Date: Mon, 9 Nov 2009 20:02:58 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, device@lanana.org, rubini@vision.unipv.it,
       gregkh@suse.de, cluster-devel@redhat.com
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic
	allocation
Message-ID: <20091109220257.GD12217@vespa.holoscopio.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com> <20091109132836.6cf7f559.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <20091109132836.6cf7f559.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 09, 2009 at 01:28:36PM -0800, Andrew Morton wrote:
> On Fri, 23 Oct 2009 21:28:17 -0200
> Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
>=20
> > The current dynamic allocation of minor number for misc devices has some
> > drawbacks.
> >=20
> > First of all, the range for dynamic numbers include some statically
> > allocated numbers. It goes from 63 to 0, and we have numbers in the
> > range from 1 to 15 already allocated. Although, it gives priority to the
> > higher and not allocated numbers, we may end up in a situation where we
> > must reject registering a driver which got a static number because a
> > driver got its number with dynamic allocation. Considering fs/dlm/user.c
> > allocates as many misc devices as lockspaces are created, and that we
> > have more than 50 users around, it's not unreasonable to reach that
> > situation.
>=20
> What is this DLM behaviour of which you speak?  It sounds broken.
>=20

I took a quick look at it, so I may be wrong. The code path is the
following: userspace writes command DLM_USER_CREATE_LOCKSPACE, which
calls device_create_lockspace, which calls dlm_device_register, which
does the following:

        ls->ls_device.fops =3D &device_fops;
        ls->ls_device.minor =3D MISC_DYNAMIC_MINOR;

        error =3D misc_register(&ls->ls_device);
        if (error) {
                kfree(ls->ls_device.name);
        }
fail:
        return error;

So, it will probably return EBUSY right now with about 64 devices at the
most. My patch does not fix this, but avoids conflicts with drivers with
statically allocated minors which come in late in the init process.

> > The proposed solution uses the not yet reserved range from 64 to 127. If
> > more devices are needed, we may push 64 to 16. Moreover, if we don't
> > need to give priority to the higher numbers anymore, we can start using
> > the bitmap/bitops functions.
>=20
> So...  misc minors 64 to 127 are presently unused?
>=20

As documented at Documentation/devices.txt, yes.

 10 char        Non-serial mice, misc features
[...]
                 15 =3D /dev/touchscreen/mk712    MK712 touchscreen
                128 =3D /dev/beep         Fancy beep device

> > Finally, if there's a failure creating the device (because there's
> > already one with the same name, for example), the current implementation
> > does not clear the bit for the allocated minor and that number is lost
> > for future allocations.
> >=20
>=20
> Is that a bugfix for the existing code?
>=20
> If so, please split that out into a separate patch which we can review
> and apply promptly while we consider the broader problem which you've
> identified.

We could consider buggy the caller which asks for the same device name
more than once, without unregistering the first device. But better safe
than sorry: we should protect the correct drivers from the buggy ones
and avoid a depletion of the minor numbers. And, in case the driver core
returns another error for another reason (from device_create), we do the
right thing.

I will send it right now.

Regards,
Cascardo.

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr4kZEACgkQyTpryRcqtS0PdACghmXzK2QNiFgy946U2dvm4HVw
QisAn229klkIGmfR3HFyYnQyKnS3HZko
=DZbp
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
