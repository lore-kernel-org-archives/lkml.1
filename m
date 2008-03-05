Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYCEQbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYCEQbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYCEQa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:30:59 -0500
Received: from hc65212de.dhcp.vt.edu ([198.82.18.222]:44941 "EHLO
	hc65212de.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYCEQa6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:30:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc3-mm1 - PROFILE_LIKELY redux..
In-Reply-To: Your message of "Tue, 04 Mar 2008 01:19:28 PST."
             <20080304011928.e8c82c0c.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204701694_3825P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Mar 2008 02:21:34 -0500
Message-ID: <4911.1204701694@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204701694_3825P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Mar 2008 01:19:28 PST, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/

x86_64, mostly 64-bit userspace, Dell Latitude D820, T7200 Core2 Duo...

So I gave CONFIG_PROFILE_LIKELY another try, and this time the thing actually
booted and got into userspace, but stuff started dying in rc.sysinit.

According to dmesg, they all died at the same place:

[    4.841459] rename_device[686]: segfault at ffffffffff7009be ip ffffffffff7009be sp 7fff7ccfb958 error 14
[    4.842384] rename_device[984]: segfault at ffffffffff7009be ip ffffffffff7009be sp 7fffb6fe9c68 error 14
[    4.843298] rename_device[981]: segfault at ffffffffff7009be ip ffffffffff7009be sp 7fffc18504c8 error 14
[    4.844184] rename_device[983]: segfault at ffffffffff7009be ip ffffffffff7009be sp 7fff512c8f48 error 14
[    6.099486] rename_device[1513]: segfault at ffffffffff7009be ip ffffffffff7009be sp 7fff47e88ad8 error 14
[    5.769289] rename_device[1516]: segfault at ffffffffff7009be ip ffffffffff7009be sp 7fffa317edd8 error 14
[    7.457229] fsck.ext3[1576]: segfault at ffffffffff7009be ip ffffffffff7009be sp 7fff3be947f8 error 14

(Note that not everything died - some renames, an fsck, and maybe I missed
something - but a lot of other stuff worked (dmesg, grep, cat, uname that I
ran, and a lot of things that rc.sysinit invoked - so that may tell us
something...)

/proc/self/maps says that's near:

ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

And my System.map says:

ffffffff80855a0c A __bss_stop
ffffffff80855a0c A _end
ffffffffff600000 T vgettimeofday
ffffffffff600100 t vread_tsc
ffffffffff600122 t vread_hpet
ffffffffff600140 D __vsyscall_gtod_data
ffffffffff600400 T vtime
ffffffffff600800 T vgetcpu
ffffffffff600870 D __vgetcpu_mode
ffffffffff600880 D __jiffies
ffffffffff600c00 T venosys_1
ffffffffff700000 A VDSO64_PRELINK
ffffffffff7005b0 A VDSO64_jiffies
ffffffffff7005b8 A VDSO64_vgetcpu_mode
ffffffffff7005c0 A VDSO64_vsyscall_gtod_data
<file ends there>

So we're in the same 4K as the VDSO64_* values, but some 0x4fe past the
gtod_data.  Anybody got a hint as to what the heck it was doing?



--==_Exmh_1204701694_3825P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHzkn+cC3lWbTT17ARAlGWAJ9GPaDTfnDxR91y82O/o3vUpfxhnACfeU8K
poiCYrZ5aigNyUgCKmmEKtc=
=F/90
-----END PGP SIGNATURE-----

--==_Exmh_1204701694_3825P--
