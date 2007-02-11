Return-Path: <linux-kernel-owner+w=401wt.eu-S1750752AbXBKRhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750752AbXBKRhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbXBKRhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:37:07 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:47221 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbXBKRhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:37:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=FbU0DobYp3K+l2K1Zy1/s5bE2yEUPALW2rmdTXy32NYLzk81YEt3J1BDIbR5/e75+WqDmHtWaH65f8uFj3zFx6sI0tEomdBfyhmtOrqoOa7aAFxIO5c0Ma7mIxPyoEFV;
Message-ID: <45CF4DFD.7000703@simon.arlott.org.uk>
Date: Sun, 11 Feb 2007 17:10:21 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cxacru: Store all device status information and report
 it when atm_proc_read is called.
References: <45BFB8F5.5010607@simon.arlott.org.uk> <20070131153914.eb693314.akpm@osdl.org> <200702011015.32238.duncan.sands@math.u-psud.fr>
In-Reply-To: <200702011015.32238.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig35890CAD9873B1BF9160FB5E"
Reply-To: Simon Arlott <643cc8da41fc265a9f1hgidx0007flhv@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig35890CAD9873B1BF9160FB5E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/02/07 09:15, Duncan Sands wrote:
> On Thursday 1 February 2007 00:39:14 you wrote:
>> On Tue, 30 Jan 2007 21:30:29 +0000
>> Simon Arlott <simon@arlott.org> wrote:
>>
>>> +static int cxacru_proc_read(struct usbatm_data *usbatm_instance,
>>> +	struct atm_dev *atm_dev, loff_t * pos, char *page)
>>> +{
>>> +	struct cxacru_data *instance =3D usbatm_instance->driver_data;
>>> +	u32 *cxinf =3D instance->cxinf_status;
>>> +	int left =3D *pos;
>>> +
>>> +	if (!left--)
>>> +		return sprintf(page, "# %s\n", usbatm_instance->description);
>>> +
>>> +	if (!left--) {
>>> +		if (cxinf[CXINF_LINE_STATUS] =3D=3D 5) {
>>> +			return sprintf(page, "# UP %u/%u\n",
>>> +				cxinf[CXINF_DOWNSTREAM_RATE],
>>> +				cxinf[CXINF_UPSTREAM_RATE]);
>>> +		} else {
>>> +			return sprintf(page, "# DOWN\n");
>>> +		}
>>> +	}
>> hm, how well-tested was this proc interface?  The pread() and lseek()
>> behaviour might be strange.
>>
>> I guess as long as it doesn't oops, hang or anything like that then it=
'll
>> be OK.  Anyone who does anything apart from a single big-fat-read from=
 a=20
>> procfile has a good chance of getting into trouble :(

Well, several reads of at least 172B... but that scenario works without a=
ny problems.

> All the ATM drivers seem to do it like this.  That doesn't mean they ar=
e
> right of course!  But I never saw anyone complain on the ATM mailing li=
st.

I just copied it from usbatm; it looks like this could be done using seq_=
file instead.

> On the other hand, why does Simon want this?  If he has written a user =
space
> tool that extracts bits from the proc file (eg: to tell users what's go=
ing
> on) then he could run into trouble, depending on how he implements it.

No special user space tool, I just want other people to be able to get th=
e same useful line information from cxacru that most ADSL driver have. (I=
 do have a small "cxacru-watch" program which execs "cmd.up" etc. on stat=
us changes, but that is just sent printks via syslog-ng).


It looks like the weird proc interface prevents my intention to allow ". =
/proc/net/atm/cxacru\:0" to work and set $LINE_STATUS etc., at least with=
 bash:
open("/proc/net/atm/cxacru:0", O_RDONLY|O_LARGEFILE) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
read(3, "", 0)                          =3D 0
close(3)                                =3D 0

Does anyone have any thoughts on the output format? The standard usbatm o=
utput isn't going to be compatible with the above if a common MAC/AAL5 he=
ader were used.


When I have the time and can acquire another conexant usb modem for testi=
ng I'll fix the usbatm /proc interfaces. It would be also good if the mod=
ule could reliably be reloaded - most (but not all) of the time it fails =
to initialise the device again.

There's still an issue with khubd going into a loop if the firmware doesn=
't exist or if the device is unplugged.

--=20
Simon Arlott


--------------enig35890CAD9873B1BF9160FB5E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRc9N/aRtx1WjQ8ihAQqr1xAAiV7jpxfhKL5ALxSQm7Ys8Xqcber6aAzY
naLnvvkYRuXFXN6b1kJc7aIZMbFYUhUXpmNMMabmpcISsM1ot9YJSD3FPZWClS17
oQwu3iPIylK1DkKSAspFbOHzSQ5vnR9bbv19tdgkzi9YgVdjmzN+t1Ykt/aBC05d
3H/KADQDzg2iAl46EHOMGgBRULmyHQlkTWV8dz9I1gnSG695b6tggku1Gz1Ru8w2
qfNeBTUs/5m+5fkW+4MNJQiXgYNqnnXgP3foLXAHgNH/tsdvPhysaT1zUvgSauRh
sF3NAb1its+RdWtQsEktSy8FfaxXq+UWkm1oE8FJ/xNokAIMH0utCjfv68EMYlPk
gVlbFOspT+ulR1sUhiUuycbvucnyH+HkmJEHyBxbm+YgvjVnc9OoHobdQi++BXIo
qC2C2UYjz6caaztZz+BA1VcdZEpzJPW2KDdPgcmgQ16q063kIRmProzjS/Xolgxk
fFUGnCQrlGCjGzQc7wv2oSWgO7H0G+S3QR1K/78fUHNo5PC3y+WUzfYgCJhh0woL
hRxR2gQzSK2QUdz2mg580ATYDwITxFS7JHJWE3OmXoCovwHVFwOupXI0aHripyw9
uTPL8xv5ymej+mmEsYmH7B4XemZCWR61HD2QxoO+bNgAHvdMTDiYEHru3IySo9K5
JbTOejegMGw=
=sj5n
-----END PGP SIGNATURE-----

--------------enig35890CAD9873B1BF9160FB5E--
