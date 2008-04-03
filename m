Return-Path: <linux-kernel-owner+w=401wt.eu-S1759223AbYDCSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223AbYDCSeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYDCSeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:34:11 -0400
Received: from mx5.mail.ru ([194.67.23.25]:22722 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbYDCSeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:34:10 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: rc6+ regression - backlight reset to 0 on boot after 7c0ea45be4f114d85ee35caeead8e1660699c46f
Date: Thu, 3 Apr 2008 22:34:01 +0400
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200804022253.17862.arvidjaar@mail.ru> <1207187979.25346.8.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1207187979.25346.8.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1389143.uqrbbUgXvt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804032234.03605.arvidjaar@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1389143.uqrbbUgXvt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 03 April 2008, Zhao Yakui wrote:
> On Wed, 2008-04-02 at 22:53 +0400, Andrey Borzenkov wrote:
> > Commit 7c0ea45be4f114d85ee35caeead8e1660699c46f registers ACPI backlight
> > even if _BQC method (query current backlight level) is missing. The eff=
ect is:
> >=20
> > during initialization video.c:acpi_video_device_find_cap() calls backli=
ght_update_status(). It tries to fetch actual level via acpi_video_get_brig=
htness() - but as _BQC is missing it just returns current value
> > as stored in memory - i.e. zero, because it was never set. So effective=
ly
> > backlight_update_status() reset brightness to minimal value =3D=3D 0.
> >=20
> > This happens on Toshiba Portege 4000. Verified by reverting commit on t=
op of
> > rc8.
> It seems that _BQC object is missing on the Toshiba Portege 4000. And
> acpi video driver will continue to update the status of backlight even
> when _BQC object is missing, which is inappropriate.=20
> Maybe it is more appropriate that OS doesn't update the status of
> backlight in boot phase when _BQC object is missing.
>=20
> Of course please attach the output of acpidump in kernel bugzilla.
> http://bugzilla.kernel.org/show_bug.cgi?id=3D10387

While patch in this bugzilla fixes this immediate regression, I still think
this commit should be reverted for 2.6.25 to discuss design a bit more.
Rationale:

=2D on systems without _BQC it makes sysfs attribute actual_brightness usel=
ess.
Semantic of this is to return *real* brightness as reported by hardware; but
this is noop without _BQC. So currently ACPI simply lies about its value.
If we are going support hardware without _BQC we probably should not define
=2D>get_brightness at all allowing read of actual_brightness to fail.

=2D on at least some Toshibas we already have brightness control via HCI
(toshiba_acpi):

{pts/0}% ll /sys/class/backlight
=D0=B8=D1=82=D0=BE=D0=B3=D0=BE 0
lrwxrwxrwx 1 root root 0 2008-04-03 22:20 acpi_video0 -> ../../devices/virt=
ual/backlight/acpi_video0/
lrwxrwxrwx 1 root root 0 2008-04-03 22:19 toshiba -> ../../devices/virtual/=
backlight/toshiba/

both of them refer to exactly the same hardware which is rather confusing.
Something has to be done about it. This is even more confusing because ...

=2D ... on those old Toshibas ACPI brightness control is far inferior. It
effectively supports only three level of brightness while tochiba_acpi
supports seven of them. So there is no need to keep inferior implementation
if more advanced already exists and works just fine.

This has strong chances of confusing user space about which control is real.
So I think we really have to refrain from pushing this unless the issues ab=
ove
are settled.

--nextPart1389143.uqrbbUgXvt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkf1IxsACgkQR6LMutpd94yc+QCgxQh8NF76h4rUOL9llue+zSzr
TyQAoJibtaEVipkPZi1HOtgG3W17jV+8
=hazl
-----END PGP SIGNATURE-----

--nextPart1389143.uqrbbUgXvt--
