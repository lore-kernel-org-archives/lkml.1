Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYGKTQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYGKTQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYGKTQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:16:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42680 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYGKTQm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:16:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Marcin Obara <marcin_obara@users.sourceforge.net>,
       Marcel Selhorst <tpm@selhorst.net>, Kylene Jo Hall <kjhall@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: patch tpm-correct-tpm-timeouts-to-jiffies-conversion.patch breaks stuff
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215803534_7279P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jul 2008 15:12:14 -0400
Message-ID: <18107.1215803534@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215803534_7279P
Content-Type: text/plain; charset=us-ascii

With tpm-correct-tpm-timeouts-to-jiffies-conversion.patch reverted, I
get -ETIME errors from libtpm2.0/utils/tpm_demo:

With the patch in place, the first read dies horribly, as reported by
strace -T -r utils/tpm_demo:

0.000969 open("/dev/tpm0", O_RDWR) = 3 <0.000080>
0.000237 write(3, "\0\301\0\0\0\22\0\0\0e\0\0\0\6\0\0\0\0", 18) = 18 <0.012652>
0.012814 read(3, 0x7fffd26cd430, 4096) = -1 ETIME (Timer expired) <0.000068>
0.000168 close(3)                  = 0 <0.000041>
0.000132 exit_group(-1)            = ?

Note that the write() call took 0.012 seconds, but the read() was hit with
a -ETIME after only 0.000068 seconds, so it's obviously too short.  With
the patch reverted, the timings look like:

0.000237 open("/dev/tpm0", O_RDWR) = 3 <0.000044>
0.000195 write(3, "\0\301\0\0\0\22\0\0\0e\0\0\0\6\0\0\0\0", 18) = 18 <0.012048>
0.012221 read(3, "\0\304\0\0\0\22\0\0\0\0\0\0\0\4\1\1\0\0", 4096) = 18 <0.000049>
0.000172 close(3)                  = 0 <0.000029>

and things continue merrily along...

Dumping the raw values in the 'data + TPM_GET_CAP_mumble' I see:

[ 2170.060661] timeout 1 = 750000
[ 2170.060866] timeout 2 = 2000000
[ 2170.060994] timeout 3 = 750000
[ 2170.061119] timeout 4 = 750000
[ 2170.072437] raw durations are 1000 2000000 120000000

(all values are before application of foo_to_jiffies)

So is the spec wrong, or is my chipset on drugs, or?

--==_Exmh_1215803534_7279P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFId7COcC3lWbTT17ARAjVmAKC1JjhcY2XQ8d992ZxVqIQK0yAOWwCg7FvA
WVVgrXtbH4375NRUH1Mmojo=
=1Kny
-----END PGP SIGNATURE-----

--==_Exmh_1215803534_7279P--
