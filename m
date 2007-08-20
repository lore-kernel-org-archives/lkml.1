Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXHTOWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXHTOWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbXHTOWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:22:01 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41067 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbXHTOWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:22:00 -0400
Message-ID: <46C9A38D.6090509@bull.net>
Date: Mon, 20 Aug 2007 16:22:05 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH 4/4] Modify KVM to update guest time	accounting.
References: <46C993A6.3060001@bull.net> <46C999C8.4080307@qumranet.com>	<46C99C05.90701@bull.net> <46C9A057.6060303@qumranet.com>
In-Reply-To: <46C9A057.6060303@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 16:27:13,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 16:27:14,
	Serialize complete at 20/08/2007 16:27:14
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4CA1BD24A2EA73E7114FD475"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4CA1BD24A2EA73E7114FD475
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>> Avi Kivity wrote:
>>  =20
>>> Laurent Vivier wrote:
>>>    =20
>>>> [PATCH 4/4] Modify KVM to update guest time accounting.
>>>>
>>>>  =20
>>>>      =20
>>>> Index: kvm/drivers/kvm/kvm.h
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> --- kvm.orig/drivers/kvm/kvm.h    2007-08-20 13:23:53.000000000 +020=
0
>>>> +++ kvm/drivers/kvm/kvm.h    2007-08-20 13:23:58.000000000 +0200
>>>> @@ -589,6 +589,17 @@ void kvm_mmu_unload(struct kvm_vcpu *vcp
>>>> =20
>>>>  int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>>> =20
>>>> +static inline void kvm_guest_enter(void)
>>>> +{
>>>> +#ifdef CONFIG_GUEST_ACCOUNTING
>>>> +    current->flags |=3D PF_VCPU;
>>>> +#endif
>>>>  =20
>>>>      =20
>>> Since you select GUEST_ACCOUNTING, the #ifdef is always true?
>>>    =20
>> It is just to avoid error if we compile kvm module outside of the kern=
el, with
>> kernel without support of guest accounting. Can be removed if you want=
=2E
>>
>>  =20
>=20
> Ah okay.  We take care of the external module in=20
> external-module-compat.h (in this case, we can #define PF_VCPU to 0 if =

> it is undefined).

OK

>>>> +}
>>>> +
>>>> +static inline void kvm_guest_exit(void)
>>>> +{
>>>>  =20
>>>>      =20
>>> Missing content?
>>>    =20
>> No, empty function.
>>
>> It is just to introduce "symmetry" in code, the VCPU code begins with
>> "kvm_guest_start()" and ends with "kvm_guest_exit()". And we have no o=
peration
>> to do in kvm_guest_exit() (the PF_VCPU is cleared by account_system_ti=
me()), so
>> "empty function", removed by the optimizer (I hope).
>>  =20
>=20
> But what if account_system_time() is not called (because we exited=20
> before the timer interrupt hit)?

account_system_time() is called by the scheduler on tick. If we clear PF_=
VCPU in
kvm_guest_exit(), the flag is always cleared when account_system_time() i=
s
executed, so we account "0", if we call account_system_time() directly fr=
om
kvm_guest_exit() we account "1", so we subtract 1 to system time, and we =
have
perhaps not used 1 tick in system: in my opinion this implies wrong resul=
ts.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig4CA1BD24A2EA73E7114FD475
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGyaON9Kffa9pFVzwRAiZBAKCjIrPZ45pCUxY3DBByFsTxzjdE0wCfYUVe
m6tAzCpP/yiMXV1etLLs1EQ=
=IQR8
-----END PGP SIGNATURE-----

--------------enig4CA1BD24A2EA73E7114FD475--
