Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXHBTXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXHBTXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbXHBTXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:23:13 -0400
Received: from master.altlinux.org ([62.118.250.235]:1457 "EHLO
	master.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbXHBTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:23:12 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 15:23:12 EDT
Date: Thu, 2 Aug 2007 23:02:19 +0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       honza@jikos.cz, jkosina@suse.cz, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is PIE randomization breaking klibc binaries?
Message-Id: <20070802230219.97b7f7b5.vsu@altlinux.ru>
In-Reply-To: <20070725063243.GA25148@deine-taler.de>
References: <20070720211300.GA21644@deine-taler.de>
	<46A131BF.4080404@zytor.com>
	<46A6624E.60003@redhat.com>
	<46A667BD.5080106@redhat.com>
	<20070724220053.GA20531@deine-taler.de>
	<46A68003.6060901@redhat.com>
	<46A68118.9080902@zytor.com>
	<20070725063243.GA25148@deine-taler.de>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.6; x86_64-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Aug_2007_23_02_19_+0400_e97bJfoXaK=B3f=c"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Aug_2007_23_02_19_+0400_e97bJfoXaK=B3f=c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Wed, 25 Jul 2007 08:32:43 +0200 Ulrich Kunitz wrote:

[...]
> Here is some output from objdump:
>
> $ objdump -x bin/sleep
>
> bin/sleep:     file format elf64-x86-64
> bin/sleep
> architecture: i386:x86-64, flags 0x00000102:
> EXEC_P, D_PAGED
> start address 0x000000000040014c
>
> Program Header:
>     PHDR off    0x0000000000000040 vaddr 0x0000000000400040 paddr 0x0000000000400040 align 2**3
>          filesz 0x00000000000000e0 memsz 0x00000000000000e0 flags r-x
>   INTERP off    0x0000000000000120 vaddr 0x0000000000400120 paddr 0x0000000000400120 align 2**0
>          filesz 0x000000000000002a memsz 0x000000000000002a flags r--
>     LOAD off    0x0000000000000000 vaddr 0x0000000000400000 paddr 0x0000000000400000 align 2**21
>          filesz 0x00000000000001c3 memsz 0x00000000000001c3 flags r-x
>    STACK off    0x0000000000000000 vaddr 0x0000000000000000 paddr 0x0000000000000000 align 2**3
>          filesz 0x0000000000000000 memsz 0x0000000000000000 flags rwx
>
> Sections:
> Idx Name          Size      VMA               LMA               File off  Algn
>   0 .interp       0000002a  0000000000400120  0000000000400120  00000120  2**0
>                   CONTENTS, ALLOC, LOAD, READONLY, DATA
>   1 .text         00000059  000000000040014c  000000000040014c  0000014c  2**2
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>   2 .rodata       0000001e  00000000004001a5  00000000004001a5  000001a5  2**0
>                   CONTENTS, ALLOC, LOAD, READONLY, DATA
>   3 .gnu_debuglink 0000000c  0000000000000000  0000000000000000  000001c3  2**0
>                   CONTENTS, READONLY
> SYMBOL TABLE:
> no symbols
>
>
> $ objdump -x lib/klibc-7q-hWrI8UIRMp59zIo378Yl2X7A.so

What version of klibc is this?

>
> lib/klibc-7q-hWrI8UIRMp59zIo378Yl2X7A.so:     file format elf64-x86-64
> lib/klibc-7q-hWrI8UIRMp59zIo378Yl2X7A.so
> architecture: i386:x86-64, flags 0x00000102:
> EXEC_P, D_PAGED
> start address 0x0000000000200200
>
> Program Header:
>     LOAD off    0x0000000000000000 vaddr 0x0000000000200000 paddr 0x0000000000200000 align 2**21
>          filesz 0x000000000001197e memsz 0x000000000001197e flags r-x
>     LOAD off    0x0000000000011980 vaddr 0x0000000000411980 paddr 0x0000000000411980 align 2**21

Note that the vaddr here can overlap the binary which is linked starting
at 0x400000.

This is the bug which I have found and fixed some time ago:

http://git.kernel.org/?p=libs/klibc/klibc.git;a=commit;h=10df6dfb13ffefe716f12136bbc667f18ff64744

The fix was included in klibc-1.4.35, but does not seem to be applied in
your case (the alignment is still 2**21 - it should be 2**20) - so
either you are using an old klibc, or the "-z max-page-size=0x100000"
option does not take effect for some reason.

In my case the buggy klibc worked fine with a stock 2.6.18 kernel, but
broke when the execshield patch was applied - and the commit 60bfba7e
code comes from execshield, so it looks like the same problem.

>          filesz 0x0000000000000100 memsz 0x0000000000004288 flags rw-
>    STACK off    0x0000000000000000 vaddr 0x0000000000000000 paddr 0x0000000000000000 align 2**3
>          filesz 0x0000000000000000 memsz 0x0000000000000000 flags rwx
>
> Sections:
> Idx Name          Size      VMA               LMA               File off  Algn
>   0 .text         0000da94  0000000000200200  0000000000200200  00000200  2**2
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>   1 .rodata       00003cde  000000000020dca0  000000000020dca0  0000dca0  2**5
>                   CONTENTS, ALLOC, LOAD, READONLY, DATA
>   2 .data         00000100  0000000000411980  0000000000411980  00011980  2**5
>                   CONTENTS, ALLOC, LOAD, DATA
>   3 .bss          00004188  0000000000411a80  0000000000411a80  00011a80  2**5
>                   ALLOC
>   4 .gnu_debuglink 0000002c  0000000000000000  0000000000000000  00011a80  2**0
>                   CONTENTS, READONLY
> SYMBOL TABLE:
> no symbols
>

--Signature=_Thu__2_Aug_2007_23_02_19_+0400_e97bJfoXaK=B3f=c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQFGsio/W82GfkQfsqIRAv36AJ99rRaapzdtC313EoZjGrFo9hN+bQCaA236
1vTQkGB76v2Xw9nvdEr1Ftg=
=dJW0
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Aug_2007_23_02_19_+0400_e97bJfoXaK=B3f=c--
