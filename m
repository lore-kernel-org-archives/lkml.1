Return-Path: <linux-kernel-owner+w=401wt.eu-S1761250AbXJOLi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250AbXJOLi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763553AbXJOLiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:38:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50462 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763187AbXJOLiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:38:08 -0400
Message-ID: <4713510D.2050208@bull.net>
Date: Mon, 15 Oct 2007 13:37:49 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time	accounting.
References: <46E550EF.5080209@bull.net> <20071015093800.GA22818@elte.hu> <47133732.2090809@qumranet.com> <20071015095125.GB28367@elte.hu> <47133ABD.8050608@qumranet.com> <471346B0.8050102@bull.net> <47134BCE.1080306@qumranet.com>
In-Reply-To: <47134BCE.1080306@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 13:44:31,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 13:44:32,
	Serialize complete at 15/10/2007 13:44:32
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC95DDB272E55C48A04A35A59"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC95DDB272E55C48A04A35A59
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>> Avi Kivity wrote:
>> =20
>>> Ingo Molnar wrote:
>>>   =20
>>>> * Avi Kivity <avi@qumranet.com> wrote:
>>>>
>>>> =20
>>>>     =20
>>>>> This bit can go; for the external module I can add it back in
>>>>> external-module-compat.h.  No need to pollute mainline with backwar=
d
>>>>> compatibility stuff.
>>>>>            =20
>>>> hm:
>>>>
>>>> static inline void kvm_guest_enter(void)
>>>> {
>>>>         current->flags |=3D PF_VCPU;
>>>> }
>>>>
>>>> static inline void kvm_guest_exit(void)
>>>> {
>>>> }
>>>>
>>>> shouldnt PF_VCPU be cleared in kvm_guest_exit()?
>>>>        =20
>>> IIRC the accounting code clears it, but yes, it may not have been cal=
led
>>> at all, so clearing it here is needed.
>>>
>>>    =20
>>
>> No, It must not be cleared here because we can't enter in the
>> accounting code
>> between kvm_guest_enter(void) and kvm_guest_exit(void).
>>
>>  =20
>=20
> Right.
>=20
>> This is why the accounting code clears it.
>>  =20
>=20
> But if we didn't get an interrupt in that time?
>=20
> We can clear it a bit later, after local_irq_enable() in __vcpu_run(). =

> However we need a nop instruction first because "sti" keeps interrupts
> disabled for one more instruction.

IMHO, I think it is better to let kvm_guest_exit() empty (you can remove =
it, if
you want):

1st case:
- unset PF_VCPU in kvm_guest_exit(), all the tick is always for system ti=
me.
Guest time is always 0.

1st case and half:

- like 1st case but we move kvm_guest_exit() as you propose and the reaso=
n of
the interrupt is the tick interrupt. The tick is for guest time only. I t=
hink
the probability is very low.

2nd case:
- don't unset PF_VCPU in kvm_guest_exit(), all the tick is for guest time=
=2E

I proposed a patch allowing to be more accurate, but it introduces more
complexity and system and user time accounting are not very accurate too =
(the
tick if for system if it appears whereas we are in system, for user if it=

appears whereas we are in user).

Laurent
--=20
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond


--------------enigC95DDB272E55C48A04A35A59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFHE1ER9Kffa9pFVzwRAnuiAKDRndCRODu2xw0j1mSWPSMe05EaQgCfcuKG
BmIlWDWjdmttp1oSyFPY2TU=
=BDAq
-----END PGP SIGNATURE-----

--------------enigC95DDB272E55C48A04A35A59--
