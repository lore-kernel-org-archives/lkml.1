Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbZDRUZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbZDRUZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZDRUZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:25:38 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:33844 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZDRUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:25:37 -0400
Message-ID: <49EA373A.8060105@web.de>
Date: Sat, 18 Apr 2009 22:25:30 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
References: <49E89D1B.7060800@suse.com> <49E9904A.5030201@web.de> <49EA2F81.7030302@suse.com> <20090418200623.GA27294@elte.hu>
In-Reply-To: <20090418200623.GA27294@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig04C51E63D6FED72DABBFFDE2"
X-Provags-ID: V01U2FsdGVkX18rPgwPz8Iawu+rs+ZNPaJ6ScAYTY8pBUFBoiHW
	+o2aW/Y06zOz51y31ddhiuLXHSt2oAtpuvyuYBZKNXcBjnNXCC
	3lbF1qkQA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig04C51E63D6FED72DABBFFDE2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Jeff Mahoney <jeffm@suse.com> wrote:
>=20
>>> Hmmmmm. That somehow reminds me of what I thought I had to fix in the=

>>> HPET emulation of QEMU just recently [1] - because of 2.6.30-rc's beh=
avior.
>>>
>>> Could you try if writing 'delta' a second time makes any difference o=
n
>>> that box?
>>>
>>> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
>>> index 648b3a2..523d72b 100644
>>> --- a/arch/x86/kernel/hpet.c
>>> +++ b/arch/x86/kernel/hpet.c
>>> @@ -324,6 +324,7 @@ static void hpet_set_mode(enum clock_event_mode m=
ode,
>>>  		       HPET_TN_SETVAL | HPET_TN_32BIT;
>>>  		hpet_writel(cfg, HPET_Tn_CFG(timer));
>>>  		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>> +		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>>  		hpet_start_counter();
>>>  		hpet_print_config();
>>>  		break;
>>>
>> Thanks, Jan.
>>
>> That fixed it for me.
>=20
> I've queued it up (and i've got a test-system that might be affected=20
> by a similar problem - it shows a similar crash very rarely), but it=20
> would be nice to know why this duplicate writeout makes a=20
> difference. Jan?
>=20
> 	Ingo

Well, if you look at the HPET spec [1], you first find the explanation
of the Tn_VAL_SET_CNF bit (HPET_TN_SETVAL):

"[...] By writing this bit to a 1, the software is then allowed to
directly set a periodic timer's accumulator."

That may sound like "you write to the comparator register if 0, and if
1, you set the accumulator". That's also how HPET was emulated in QEMU
so far.

But then you read on about changing the period of a running timer:

"If the software resets the main counter, the value in the comparator=E2=80=
=99s
value register needs to reset as well. This can be done by setting the
Tn_VAL_SET_CNF bit. Again, to avoid race conditions, this should be
done with the main counter halted. The following usage model is expected:=

1) Software clears the GLOBAL_ENABLE_CNF bit to prevent any interrupts
2) Software Clears the main counter by writing a value of 00000000h to it=
=2E
3) Software sets the TIMER0_VAL_SET_CNF bit.
4) Software writes the new value in the TIMER0_COMPARATOR_VAL register
5) Software sets the GLOBAL_ENABLE_CNF bit to enable interrupts."

And that somehow sounds like you only need to write the new period once,
with Tn_VAL_SET_CNF =3D 1.

I bet now that both interpretations are implemented in silicon somewhere
out there - but I'm all ears to learn the right one (and potentially
re-fix QEMU).

Jan

[1] http://www.intel.com/hardwaredesign/hpetspec_1.pdf


--------------enig04C51E63D6FED72DABBFFDE2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknqNz8ACgkQniDOoMHTA+kKCQCfSYKqZxyFF+P+59uSDIRpU+5w
sPYAn05mNnI4Ahbxbtne6GW4PrO+GXSd
=7q8u
-----END PGP SIGNATURE-----

--------------enig04C51E63D6FED72DABBFFDE2--
