Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYAOSol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYAOSol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYAOSod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:44:33 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:33938 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbYAOSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:44:32 -0500
Message-ID: <478CFF08.1090608@web.de>
Date: Tue, 15 Jan 2008 19:44:24 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: State of kgdb on x86-64
References: <478BB35B.9060507@siemens.com> <478BB74E.6020506@windriver.com> <478C786A.3090709@siemens.com> <478CB724.3000900@windriver.com>
In-Reply-To: <478CB724.3000900@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig88BCC8787000BCBE7C3C2DE3"
X-Provags-ID: V01U2FsdGVkX1+658zLvxC0m1JzC3vUO5zJX++k80oYELXMpIOc
	ceohbGcUgJ/4gWHKKgvIPAVcmDDbclV3Yt5tp0H8Gleoj7T3ds
	D6/GKwLCE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig88BCC8787000BCBE7C3C2DE3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Jason Wessel wrote:
> Jan Kiszka wrote:
>> Jason Wessel wrote:
>>  =20
>>> It was working at the point that I tested it with the 2.6.24-rc5 on
>>> x86_64.  However I suspect my kernel config may differ drastically fr=
om
>>> what you are using.
>>>
>>> Without any other context provided than the generic message, it is ha=
rd
>>> to know what might have happened.=20
>>>    =20
>> Here is the promised .config. I could also dig out the backtrace of th=
e
>> panic as kgdb sees it if that helps, just let me know.
>>
>> Jan
>>
>>  =20
> The backtrace might be very telling as to what happened.  More
> information is always better than less :-)
>=20

My primary test box is again out of reach, but meanwhile I was able to
reproduce some kind of problem under QEMU - that one at least is
triggered by SMP. With only one CPU -> all apparently fine. Once booting
QEMU with "-smp 2" -> this happens:

(gdb) tar remote /dev/pts/6
Remote debugging using /dev/pts/6
Not all CPUs have been synced for KGDB
breakpoint () at kernel/kgdb.c:1895
1895            wmb(); /* Sync point after breakpoint */
(gdb) c
Continuing.
Not all CPUs have been synced for KGDB
[New Thread 32769]

Program received signal SIGFPE, Arithmetic exception.
[Switching to Thread 32769]
0xffffffff8020adb7 in default_idle () at include/asm/irqflags_64.h:140
140             __asm__ __volatile__("sti; hlt" : : : "memory");
(gdb) bt
#0  0xffffffff8020adb7 in default_idle () at include/asm/irqflags_64.h:14=
0
#1  0xffffffff8020ae65 in cpu_idle () at arch/x86/kernel/process_64.c:225=

#2  0xffffffff8021ccb9 in start_secondary () at arch/x86/kernel/smpboot_6=
4.c:375
#3  0x0000000000000000 in ?? ()
(gdb)                                                                    =
                =20

The problem seems to be related to continuing SMP boxes. I'm able to
boot my box up if I leave kgdb unattached. But when I then later attach
and continue execution, I get the same crash. Any ideas what goes wrong,
any suggestion where to start digging? Maybe at "Not all CPUs have been
synched"?

Jan


--------------enig88BCC8787000BCBE7C3C2DE3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHjP8LniDOoMHTA+kRAlhpAJ4vXRYbKUIizXwQzAsiGGYYOqtpTQCcCYXq
K5YwAGnyyHg79TLMifKyCZM=
=qaED
-----END PGP SIGNATURE-----

--------------enig88BCC8787000BCBE7C3C2DE3--
