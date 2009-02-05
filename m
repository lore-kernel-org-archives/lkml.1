Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbZBEBei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbZBEBei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZBEBea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:34:30 -0500
Received: from mailsrv1.zmi.at ([212.69.162.198]:37418 "EHLO mailsrv1.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbZBEBe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:34:29 -0500
X-Greylist: delayed 1532 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 20:34:28 EST
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
To: linux-kernel@vger.kernel.org
Subject: Poor performance on cp on kernel 2.6.27.7-9-xen (openSUSE 11.1)
Date: Thu, 5 Feb 2009 02:08:45 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-ZMI; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3182239.hr4LFiqveC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902050208.50490@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3182239.hr4LFiqveC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Dear list, (I'm no subscriber so please CC: me, thanks!)

I'm wondering about a problem that's not entirely clear to me. I have a=20
machine (hardware specs at the end) that basically has two test disks,=20
sdb and sdd. There's nobody logged in, no network activity (apart from=20
my ssh session to have a console), no other disk activity. The two disks=20
have empty XFS filesystems, and I create a big file with
dd if=3D/dev/zero of=3D/disk1/bigfile bs=3D1024k count=3D10000
which is quite fast:
10485760000 Bytes (10 GB) kopiert, 15,2056 s, 690 MB/s

Then I do "cp -a --sparse=3Dnever /disk1/bigfile /disk2/" and that's what=20
"iostat -kx 5 555" says (just a part of course):
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,02    0,00   10,31    5,36    0,00   84,57

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
sz avgqu-sz   await  svctm  %util
sdb               0,00     0,00 1268,40    0,00 162355,20     0,00  =20
256,00     1,12    0,87   0,52  65,68
sdd               0,00     0,80    0,00  913,80     0,00 162442,50  =20
355,53     1,59    1,74   0,16  15,04

And "top" says:
top - 06:36:43 up  9:30,  6 users,  load average: 1.65, 1.71, 1.84
Tasks: 209 total,   2 running, 207 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  9.3%sy,  0.0%ni, 84.7%id,  5.6%wa,  0.2%hi,  0.2%si, =20
0.0%st
Mem:  16504708k total, 16455832k used,    48876k free,      768k buffers
Swap:        0k total,        0k used,        0k free, 16133320k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 8534 root      20   0 14316 1284  744 R   48  0.0   3:09.19 cp
   59 root      15  -5     0    0    0 S   12  0.0  12:50.49 kswapd1
   58 root      15  -5     0    0    0 S   11  0.0  12:26.94 kswapd0
 8352 root      20   0     0    0    0 S    7  0.0   1:20.01 pdflush
 2360 root      15  -5     0    0    0 S    2  0.0   4:56.28 xfsdatad/7
   18 root      15  -5     0    0    0 S    1  0.0   0:03.68 ksoftirqd/7
 5709 root      20   0 53544 3184  556 S    1  0.0   0:37.80 archttp64
 8572 root      20   0 16940 1360  940 R    1  0.0   0:00.34 top
    1 root      20   0  1064  388  324 S    0  0.0   0:02.96 init

Now why doesn't Linux have 100 "%util" reported by iostat when I copy=20
from one disk to the other? It's a large file, no defragmentation, so it=20
should be fast as hell. Well, that depends of course, but at least it=20
should have 100% util at least on one disk. Because if there's only 80%=20
utilization, there are 20% left to use. Can somebody explain me why=20
Linux chooses to go on holidays instead of doing it's work? Is it a=20
member of labour?

I got a similar problem when copying between two XEN block devices:
xm block-attach 0 tap:aio:/disk1/test1.xen xvda w
xm block-attach 0 tap:aio:/disk1/test2.xen xvdb w
mount /dev/xvda1 /1
mount /dev/xvdb1 /2
cp -a --sparse=3Dnever /1/. /2/
(where /1 contains a root filesystem of an installed machine, about=20
1,5GB data, /2 is fresh created, /1 is reiserfs and /2 is XFS)

And one last thing:
rsync -aPv /disk1/bigfile /disk2/xxx
That copies at max. 50MB/s, because 2 rsync tasks are started each=20
taking 50% of 1 CPU - why doesn't the kernel switch the 2nd task to=20
another CPU? There are 8 cpus in that system - 7 of them idle.

Machine data:
2x quad core AMD Opteron 2350 (2GHz x 8)
sdb: 8 disks in RAID-50
sdd: 4 disks in RAID-5
disks are not shared between sdb and sdd, there are 16 disks in this=20
system.
Areca RAID 1680 16port SAS with 2GB Cache in writeback mode.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart3182239.hr4LFiqveC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmKPCIACgkQzhSR9xwSCbRf8gCglYDqzCjVXkPInXEagpUMZdHl
+uQAoMTz50Nf+DdFgCP+1aF03xAancIf
=m0Xa
-----END PGP SIGNATURE-----

--nextPart3182239.hr4LFiqveC--
