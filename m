Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYAEEzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYAEEzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 23:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYAEEyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 23:54:53 -0500
Received: from smtp-out.google.com ([216.239.45.13]:62110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYAEEyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 23:54:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:from:organization:to:subject:date:user-agent:cc:
	references:in-reply-to:mime-version:content-type:
	content-transfer-encoding:message-id;
	b=PVdAGx6K28nxFnxjqG5lokPRBHLyelRv3qJ+O95svAUBiTBHNnKp43p1qT73EsqE2
	eQOxChF9Nwzwrg/cmTbLQ==
From: David Smith <dds@google.com>
Organization: Google
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [tpmdd-devel] [PATCH] - TPM save state before suspending to ram
Date: Sat, 5 Jan 2008 13:54:36 +0900
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Kent Yoder <shpedoikal@gmail.com>, Marcel Selhorst <tpm@selhorst.net>,
       Andrew Morton <akpm@osdl.org>,
       TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
References: <477D491F.1060001@selhorst.net> <499d6ed30801041209o4da54b3bw39335f3342e528f0@mail.gmail.com> <20080104234413.GB800@elf.ucw.cz>
In-Reply-To: <20080104234413.GB800@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3194139.FxmvEUIGc7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801051354.37843.dds@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3194139.FxmvEUIGc7
Content-Type: multipart/mixed;
  boundary="Boundary-01=_M2wfHEhkBTgXZI3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_M2wfHEhkBTgXZI3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> On Fri 2008-01-04 14:09:01, Kent Yoder wrote:
> > On Jan 4, 2008 10:39 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > > On Thu 2008-01-03 21:44:15, Marcel Selhorst wrote:
> > > > Dear list,
> > > >
> > > > this patch fixes a bug, that prevents the TPM chip to resume
> > > > correctly from a suspended state.
> > > >
> > > > Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
> >
> > [cut]
> >
> > > I'm not sure if we want to use variable-size array on stack. What
> > > hacks are you doing with max_t/max?
> > >                                                                      =
 =20
> > > Pavel
> >
> > Hi Pavel,
> >
> >   Here's an alternate solution from David, signoffs pending --
> >
> > commit 058f1e3c4d4e2de5a7188608a1c2e0722498fd4b
> > Author: David Smith <davidsmith@acm.org>
> > Date:   Fri Jan 4 03:33:11 2008 +0900
> >
> >     Fix for TPM suspend/resume failure
> >
> > diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> > index 9bb5429..79d2fd5 100644
> > --- a/drivers/char/tpm/tpm.c
> > +++ b/drivers/char/tpm/tpm.c
> > @@ -1046,12 +1046,6 @@ void tpm_remove_hardware(struct device *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_remove_hardware);
> >
> > -static u8 savestate[] =3D {
> > -	0, 193,			/* TPM_TAG_RQU_COMMAND */
> > -	0, 0, 0, 10,		/* blob length (in bytes) */
> > -	0, 0, 0, 152		/* TPM_ORD_SaveState */
> > -};
> > -
> >  /*
> >   * We are about to suspend. Save the TPM state
> >   * so that it can be restored.
> > @@ -1059,8 +1053,14 @@ static u8 savestate[] =3D {
> >  int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
> >  {
> >  	struct tpm_chip *chip =3D dev_get_drvdata(dev);
> > +        u8 savestate[] =3D {
> > +          0, 193,		/* TPM_TAG_RQU_COMMAND */
> > +          0, 0, 0, 10,		/* blob length (in bytes) */
> > +          0, 0, 0, 152		/* TPM_ORD_SaveState */
> > +        };
> > +
> >  	if (chip =3D=3D NULL)
> > -		return -ENODEV;
> > +          return -ENODEV;
> >
> >  	tpm_transmit(chip, savestate, sizeof(savestate));
> >  	return 0;
>
> Yep, but please fix the whitespace.
> 									Pavel

OK, attached.
=2D-=20
man perl | tail -6 | head -2

--Boundary-01=_M2wfHEhkBTgXZI3
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="tpm-suspend.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="tpm-suspend.patch"

commit a17f28b93a6e11097ea806d576eb317263aa8768
Author: David Smith <dds@toriatama.tok.corp.google.com>
Date:   Fri Jan 4 16:12:58 2008 +0900

    Fix TPM suspend and resume failure.
   =20
    The savestate command structure was being overwritten by the
    result of running the TPM_SaveState command after one run, so
    make it a local variable to the function instead of a global
    variable that gets overwritten.

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 9bb5429..4f18ddf 100644
=2D-- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1046,12 +1046,6 @@ void tpm_remove_hardware(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
=20
=2Dstatic u8 savestate[] =3D {
=2D	0, 193,			/* TPM_TAG_RQU_COMMAND */
=2D	0, 0, 0, 10,		/* blob length (in bytes) */
=2D	0, 0, 0, 152		/* TPM_ORD_SaveState */
=2D};
=2D
 /*
  * We are about to suspend. Save the TPM state
  * so that it can be restored.
@@ -1059,6 +1053,12 @@ static u8 savestate[] =3D {
 int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
 {
 	struct tpm_chip *chip =3D dev_get_drvdata(dev);
+	u8 savestate[] =3D {
+		0, 193,		/* TPM_TAG_RQU_COMMAND */
+		0, 0, 0, 10,	/* blob length (in bytes) */
+		0, 0, 0, 152	/* TPM_ORD_SaveState */
+	};
+
 	if (chip =3D=3D NULL)
 		return -ENODEV;
=20

--Boundary-01=_M2wfHEhkBTgXZI3--

--nextPart3194139.FxmvEUIGc7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUAR38NjMB87lqChsqOAQIGfQf+Jaowf+IABXISvdXoI5YG/TK6VPI9bX88
koDsS6IScs84SN5/ksE39PfV9voCZv+1Eu38zayS2tzeQtDaSH/WKL0DI1f3jlry
Id++2IfuO/bTqjSlDDhTUSsu0KEWl8u/WojvE3Za7O020HCsf291OKNToluqU8RN
SJSn1tDxNVvid68vhp1H1dt/gnZRPPMiOsYHJwCckKNuHBnpinQC4CPeSG8dC5cP
uGh/0twQCbW+ij0BwftoHQ0rY3kI0hluzD/sEaGAUvVhLh/w2DNk5c/cyiW9smFy
T8TWZUD1WedJYHEeAcHKBHJPK4qK51M6E+OXQSytpIFXu9+xP0OxHA==
=drXP
-----END PGP SIGNATURE-----

--nextPart3194139.FxmvEUIGc7--
