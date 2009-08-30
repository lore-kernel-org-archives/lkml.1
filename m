Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZH3SZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZH3SZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 14:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZH3SZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 14:25:00 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:36870 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZH3SY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 14:24:59 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2009 14:24:58 EDT
Date: Sun, 30 Aug 2009 20:16:37 +0200
From: Bastian Blank <waldi@debian.org>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       544145@bugs.debian.org
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
Message-ID: <20090830181637.GA7155@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
	544145@bugs.debian.org,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
	Keir Fraser <keir.fraser@eu.citrix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks

I upgraded one of my 32bit chroots on a x86-64 machine runing under Xen
lately. All binaries started to segfault. Some extensive checks later
show the vdso as the culprit. Later I found <gpe0vg$j67$1@ger.gmane.org>
with the same problem. The full story can be found in the Debian bug
544145[1].

It happens with Linux 2.6.30 and 2.6.31-rc8 on Xen 3.2 and 3.4.

For the tests I set the vdso to compat mode to have it loaded on a fixed
location.

The following program is a minimal test case for the vdso in compat
mode, it can be compiled against dietlibc to minimize other effects.

| int main() {
|   unsigned int resultvar;
|   asm volatile (
|     "movl %1, %%eax\n\t"
|     "call 0xffffe420\n\t"
|     : "=3Da" (resultvar) : "i" (0) : "memory", "cc");
| }
| (gdb) run
| Starting program: /test=20
|=20
| Program received signal SIGSEGV, Segmentation fault.
| 0xffffe42f in ?? ()
| (gdb) bt
| #0  0xffffe42f in ?? ()
| #1  0xf7eb17a5 in __libc_start_main (main=3D0x8048394 <main>, argc=3D1, u=
bp_av=3D0xffffd884, init=3D0x80483d0 <__libc_csu_init>,=20
|     fini=3D0x80483c0 <__libc_csu_fini>, rtld_fini=3D0xf7fee6e0 <_dl_fini>=
, stack_end=3D0xffffd87c) at libc-start.c:222
| #2  0x08048301 in _start () at ../sysdeps/i386/elf/start.S:119
| (gdb) disassemble 0xffffe420 0xffffe430
| Dump of assembler code from 0xffffe420 to 0xffffe430:
| 0xffffe420:     push   %ebp
| 0xffffe421:     mov    %ecx,%ebp
| 0xffffe423:     syscall=20
| 0xffffe425:     mov    $0x2b,%ecx
| 0xffffe42a:     mov    %ecx,%ss
| 0xffffe42c:     mov    %ebp,%ecx
| 0xffffe42e:     pop    %ebp
| 0xffffe42f:     ret   =20
| End of assembler dump.

It segfaults on the ret opcode, in some variants also directly after the
ret. If I single-step over the syscall opcode it works. The register
contents slightly differ in this case.

Break on last opcode, state at the last opcode:
| (gdb) b *0xffffe42f
| Breakpoint 7 at 0xffffe42f
| (gdb) run
| Starting program: /test
|=20
| Breakpoint 7, 0xffffe42f in ?? ()
| (gdb) info registers
| eax            0xfffffffc       -4
| ecx            0xffffd800       -10240
| edx            0xffffd820       -10208
| ebx            0xf7fd7ff4       -134381580
| esp            0xffffd7d0       0xffffd7d0
| ebp            0xffffd7e8       0xffffd7e8
| esi            0x80483d0        134513616
| edi            0x80482e0        134513376
| eip            0xffffe42f       0xffffe42f
| eflags         0x282    [ SF IF ]
| cs             0xe033   57395
| ss             0x2b     43
| ds             0x2b     43
| es             0x2b     43
| fs             0x0      0
| gs             0x63     99

Break on first opcode, state at the last opcode:
| (gdb) b *0xffffe420
| Breakpoint 8 at 0xffffe420
| (gdb) run
| Starting program: /test
|=20
| Breakpoint 8, 0xffffe420 in ?? ()
| (gdb) stepi
| 0xffffe421 in ?? ()
[...]
| 0xffffe42f in ?? ()
| (gdb) info registers
| eax            0xfffffffc       -4
| ecx            0xffffd800       -10240
| edx            0xffffd820       -10208
| ebx            0xf7fd7ff4       -134381580
| esp            0xffffd7cc       0xffffd7cc
| ebp            0xffffd7e8       0xffffd7e8
| esi            0x80483d0        134513616
| edi            0x80482e0        134513376
| eip            0xffffe42f       0xffffe42f
| eflags         0x282    [ SF IF ]
| cs             0x23     35
| ss             0x2b     43
| ds             0x2b     43
| es             0x2b     43
| fs             0x0      0
| gs             0x63     99

The stack pointer and code segment are different in this two cases.

I think I found the problem. In the normal codeflow, sysret is used to
return as expected. In the compat codeflow, iret is used.

Bastian

[1]: http://bugs.debian.org/544145
--=20
Wait!  You have not been prepared!
		-- Mr. Atoz, "Tomorrow is Yesterday", stardate 3113.2

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqawgEACgkQnw66O/MvCNHhIQCfd5mXou7H1y7eFiGQT0KzB/sF
0+wAoIgxyG0UKhfvuN/3S9ymdcCvncDu
=Cbi9
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
