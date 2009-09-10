Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbZIJFrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbZIJFrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZIJFrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:47:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:20530 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752146AbZIJFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:47:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,362,1249282800"; 
   d="asc'?scan'208";a="447277543"
Date: Thu, 10 Sep 2009 13:47:05 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>, Keith Packard <keithp@keithp.com>,
       intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Linux 2.6.31-rc7
Message-ID: <20090910054705.GA1014@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
	Ma Ling <ling.ma@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Zhao, Yakui" <yakui.zhao@intel.com>,
	Keith Packard <keithp@keithp.com>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
 <4A941E8B.8080902@plzk.org>
 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
 <4A94599F.9020508@plzk.org>
 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
 <1251239637.26348.20.camel@gaiman.anholt.net>
 <20090826015127.GA1402@zhen-devel.sh.intel.com>
 <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
 <20090826035840.GA16894@zhen-devel.sh.intel.com>
 <alpine.LFD.2.01.0908252114130.3218@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908252114130.3218@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.08.25 21:20:18 -0700, Linus Torvalds wrote:
>
> And how about MacBook 2.1, which apparently also goes black?
>=20

Linus, sorry for reply this old thread.=20

I just handed on one MacBook with 945GM, and tried to find out
the reason of black screen. It is TV detection that caused it.

MacBook routes integrated TV DAC to mini-DVI port too, like for VGA.
Our TV detect does load detect, which trys to set a mode onto TV port
and checked back its status. This TV load-detect makes the LVDS black
on MacBook.

It looks our load detect function has problem that when we pick
up one crtc, we don't check if its has a fb. During first TV detect,
choosed crtc obviously has no fb, it would fail in modesetting when
setting plane surface. This might have effect on the purpose of load-
detect process. I'll see how it should be fixed. But even if I hacked
plane setting with all zeros, screen still goes black on my MacBook,
although TV detect return is right that there's none found.=20

So this blank issue is within detect process, if you try to load fbcon
or X later, setting mode is fine on LVDS. That's why build fbcon in
kernel might workaround this issue.

I don't know much about our TV detect method details, but looks like
here we should check current TV status when system start. Otherwise
it seems we can't stopping blank the screen...So I did a temp hacking
like,

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_t=
v.c
index 5b1c9e9..f3ecbaa 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1451,8 +1451,18 @@ intel_tv_detect(struct drm_connector *connector)
 	struct intel_output *intel_output =3D to_intel_output(connector);
 	struct intel_tv_priv *tv_priv =3D intel_output->dev_priv;
 	struct drm_encoder *encoder =3D &intel_output->enc;
+	struct drm_i915_private *dev_priv =3D connector->dev->dev_private;
 	int dpms_mode;
 	int type =3D tv_priv->type;
+	static int first_detect =3D 1;
+
+	if (first_detect) {
+		first_detect =3D 0;
+		if (!(I915_READ(TV_CTL) & TV_ENC_ENABLE))
+			return connector_status_disconnected;
+		else
+			return connector_status_connected;
+	}
=20
 	mode =3D reported_modes[0];
 	drm_mode_set_crtcinfo(&mode, CRTC_INTERLACE_HALVE_V);

which makes LVDS working, but I haven't tested with mini-DVI <-> S-Video.
I'm not sure if this is ideal enough for this, but first get port states in
system startup for initial setup, and userspace could check and set required
config later seems sane to me, as you have also suggested to do.

This patch doesn't aim to be upstream, we may set the state in priv struct
to check boot state, but I'd like to hear others' comment about this.

thanks.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqoktkACgkQsQQaM014GCcBKgCffNoV+IcDqFuNVmibKt9qTrSW
K7IAn1w2Pup4pYyvGAIoH80hXYZeR4Qa
=038D
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
