Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYBJUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYBJUXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYBJUXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:23:08 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:50679 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYBJUXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:23:07 -0500
Message-ID: <47AF5D21.6010400@web.de>
Date: Sun, 10 Feb 2008 21:22:57 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
References: <20080210071304.GA3788@elte.hu>  <20080210104709.GB10790@uranus.ravnborg.org>  <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com> <47AF483E.10905@web.de> <alpine.LFD.1.00.0802101134470.2896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802101134470.2896@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB212984CBE10AC0BC5FDE9B"
X-Provags-ID: V01U2FsdGVkX1/x8N9eYXdjxHrPBfqo817os5s3guHTN7Tknaqb
	JuL3fLXWwsQBcIR10dU4zfbEXJdZ9RxiqYX9SvB22l6BFxYLyO
	jw6XkEa6s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB212984CBE10AC0BC5FDE9B
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Linus Torvalds wrote:
>=20
> On Sun, 10 Feb 2008, Jan Kiszka wrote:
>> +static int kgdb_get_mem(char *addr, unsigned char *buf, int count)
>>  {
>> +	if ((unsigned long)addr < TASK_SIZE)
>> +		return -EFAULT;
>> =20
>> +	return probe_kernel_read(buf, addr, count);
>>  }
>=20
> Ok, so this is a pretty function after all the cleanups, but I actually=
=20
> don't think that "if ((unsigned long)addr < TASK_SIZE)" is really even =

> asked for.
>=20
> Why not let kgdb look at user memory? I'd argue that in a lot of cases,=
 it=20
> might be quite nice to do, to see what user arguments in memory are etc=
=20
> etc (think things like futexes, where user memory contents really do=20
> matter).
>=20
> So I'd suggest getting rid of the whole "kgdb_{get|set}_mem()" function=
s,=20
> and just using "probe_kernel_{read|write}()" directly instead.

Makes indeed more sense.

>=20
> (Not that I necessarily love those names either, but whatever..)
>=20
> The TASK_SIZE checks make more sense in kgdb_validate_break_address() a=
nd=20
> friends, where it actually does make sense to check that it's really a =

> *kernel* address.
>=20
> But even there, I'm not sure if the right check is to compare against=20
> TASK_SIZE, since kernel and user memory addresses can in theory be=20
> distinct (that's why we have "set_fs()" historically, and while it's no=
=20
> longer true on x86 and hasn't been in a long time, the kernel conceptua=
lly=20
> allows it - see my previous reply about that whole get_fs/set_fs thing =
in=20
> the definition of probe_kernel_read/write).
>=20
>> +	if (count =3D=3D 2 && ((long)mem & 1) =3D=3D 0)
>> +		err =3D probe_kernel_read(tmp, mem, 2);
>> +	else if (count =3D=3D 4 && ((long)mem & 3) =3D=3D 0)
>> +		err =3D probe_kernel_read(tmp, mem, 4);
>> +	else if (count =3D=3D 8 && ((long)mem & 7) =3D=3D 0)
>> +		err =3D probe_kernel_read(tmp, mem, 8);
>> +	else
>> +		err =3D probe_kernel_read(tmp, mem, count);
>=20
> There's absolutely no reason to care about the alignment, since if you =
now=20
> use "probe_kernel_read()", the sane thing to do is to just do
>=20
> 	err =3D probe_kernel_read(tmp, mem, count);
> 	if (!err) {
> 		while (count > 0) {
> 			buf =3D pack_hex_byte(buf, *tmp);
> 			tmp++;
> 			count--;
> 	}
>=20
> and you're all done. No?

Maybe, maybe not. I followed the comment in the original code, saying=20
that we need word-wise access for I/O memory poking. Can I assume across =

a all archs that __copy_to/from_user will not perform byte accesses if=20
count is 2, 4, or 8? I would be glad if we can kill other couple of line.=


Ingo, if you are close to an editor, please pick those up? Here are some =

offline things cooking on my side...

Jan


--------------enigEB212984CBE10AC0BC5FDE9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHr10hniDOoMHTA+kRAh1pAJwKR6O5zfakW/3t6xN1eJZSeKa5FgCfdnAy
g+gD2VZOk0LsN2xRb5DRRfI=
=1Ilc
-----END PGP SIGNATURE-----

--------------enigEB212984CBE10AC0BC5FDE9B--
