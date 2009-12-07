Return-Path: <linux-kernel-owner+w=401wt.eu-S935390AbZLGQdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935390AbZLGQdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935373AbZLGQdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:33:05 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:4710 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935370AbZLGQdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:33:03 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: =?iso-8859-9?Q?Ozan_=C7a=F0layan?= <ozan@pardus.org.tr>,
       linux-kernel <linux-kernel@vger.kernel.org>
CC: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Date: Mon, 7 Dec 2009 16:32:36 +0000
Subject: RE: CCISS performance drop in buffered disk reads in newer kernels
Thread-Topic: CCISS performance drop in buffered disk reads in newer kernels
Thread-Index: Acp3KaQKPtaA/rJJS8CZ3lHJWvO95wAKOu7Q
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778869941207A5@GVW0547EXC.americas.hpqcorp.net>
References: <4B1CDCE6.5040502@pardus.org.tr>
In-Reply-To: <4B1CDCE6.5040502@pardus.org.tr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_0F5B06BAB751E047AB5C87D1F77A778869941207A5GVW0547EXCame_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_0F5B06BAB751E047AB5C87D1F77A778869941207A5GVW0547EXCame_
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable

=20

> -----Original Message-----
> From: Ozan =C7a=F0layan [mailto:ozan@pardus.org.tr]=20
> Sent: Monday, December 07, 2009 4:46 AM
> To: linux-kernel
> Cc: scameron@beardog.cce.hp.com; Miller, Mike (OS Dev);=20
> jens.axboe@oracle.com
> Subject: CCISS performance drop in buffered disk reads in=20
> newer kernels
>=20
> Hi,
>=20
> We have 2 HP Proliant DL380G5 server running with different kernels.
>=20
> I was inspecting a basic kernel-compile time. On the one with=20
> 2.6.25.20 kernel, the compilation took ~1.5 minutes. On the=20
> one with 2.6.30.9 kernel, it took ~6 minutes. Both systems=20
> are using ccache as a build helper.
>=20
> Then I ran hdparm on both systems, the results are below.
>=20
> I'd like to help debugging this issue through bisect or=20
> another method but since there are more parameters that=20
> differ from one to the other server than only the kernel=20
> version, I'm a little bit stuck.
>=20
> Thanks,
> Ozan
>=20

Ozan,
I'm aware of the performance drop. Please see: http://bugzilla.kernel.org/s=
how_bug.cgi?id=3D13127. I removed the huge read ahead value of 1024 that we=
 used because users were complaining about small writes being starved. That=
 was back around the 2.6.25 timeframe. Since that timeframe there have no c=
hanges in the main i/o path. I'll get back on this as time allows.

Meanwhile, you can tweak some of the block layer tunables as such.

    echo 64 > /sys/block/cciss\!c0d1/queue/read_ahead_kb
OR
    blockdev --setra 128 /dev/cciss/c0d1

These are just example values. There is also max_hw_sectors_kb and max_sect=
ors_kb that be adjusted.

-- mikem

>=20
> ### 2.6.30.9 (Slow one, compiled with PAE support, FS is ext4) ###
>=20
> # sync; sleep 2; echo 3 > /proc/sys/vm/drop_caches; hdparm -tT -vvvv
> /dev/cciss/c0d0p5
>=20
> /dev/cciss/c0d0p5:
>  HDIO_DRIVE_CMD(identify) failed: Invalid exchange
>  readonly      =3D  0 (off)
>  readahead     =3D 256 (on)
>  geometry      =3D 245410/255/32, sectors =3D 2002550382, start =3D 42251=
58
>  Timing cached reads:   12038 in  2.00 seconds =3D 6027.00 MB/sec
>  Timing buffered disk reads:  184 MB in  3.00 seconds =3D  61.31
> MB/sec             <------ Note the drop here!
>=20
> # dmesg | grep cciss
> [    0.000000] Kernel command line: root=3DLABEL=3DPARDUS_ROOT vga=3D791
> splash=3Dsilent quiet resume=3D/dev/cciss/c0d0p1
> [    6.023542] cciss 0000:18:08.0: PCI INT A -> GSI 19 (level, low) ->
> IRQ 19
> [    6.023566] cciss: MSI init failed
> [    6.053008] IRQ 19/cciss0: IRQF_DISABLED is not guaranteed=20
> on shared IRQs
> [    6.053015] cciss0: <0x3238> at PCI 0000:18:08.0 IRQ 19 using DAC
> [    6.053918]  cciss/c0d0: p1 p2 < p5 >
> [    6.320852] kjournald2 starting: pid 190, dev=20
> cciss!c0d0p5:8, commit
> interval 5 seconds
> [    6.322344] EXT4-fs: mounted filesystem cciss!c0d0p5 with ordered
> data mode
> [   10.994505] EXT4 FS on cciss!c0d0p5, internal journal on=20
> cciss!c0d0p5:8
> [   11.783302] Adding 2112508k swap on /dev/cciss/c0d0p1.  Priority:-1
> extents:1 across:2112508k
> [   16.696090] JBD: barrier-based sync failed on cciss!c0d0p5:8 -
> disabling barriers
>=20
>=20
> ### 2.6.25.20 (Fast one, no PAE support, FS is ext3) ###
>=20
> # sync;sleep 2; echo 3 > /proc/sys/vm/drop_caches; hdparm -tT -vvv
> /dev/cciss/c0d0p5
>=20
> /dev/cciss/c0d0p5:
>  readonly      =3D  0 (off)
>  readahead     =3D 256 (on)
>  geometry      =3D 245426/255/32, sectors =3D 2002678902, start =3D 40966=
38
>  Timing cached reads:   10650 MB in  2.00 seconds =3D 5334.38 MB/sec
>  Timing buffered disk reads:  420 MB in  3.01 seconds =3D 139.72 MB/sec
>=20
> # dmesg | grep cciss
> Kernel command line: root=3DLABEL=3DPARDUS_ROOT vga=3D791=20
> splash=3Dsilent quiet
> resume=3D/dev/cciss/c0d0p1
> cciss0: <0x3238> at PCI 0000:18:08.0 IRQ 212 using DAC
>  cciss/c0d0: p1 p2 < p5 >
> EXT3 FS on cciss/c0d0p5, internal journal Adding 2048248k=20
> swap on /dev/cciss/c0d0p1.  Priority:-1 extents:1 across:2048248k
>=20
> =

--_002_0F5B06BAB751E047AB5C87D1F77A778869941207A5GVW0547EXCame_
Content-Type: message/rfc822

Received: from g1t0039.austin.hp.com (16.236.32.45) by
 G3W0060.americas.hpqcorp.net (16.232.1.155) with Microsoft SMTP Server id
 8.2.176.0; Mon, 7 Dec 2009 15:33:53 +0000
Received: from g2u0301c.austin.hp.com (g2u0301c.austin.hp.com [16.238.112.31])
	by g1t0039.austin.hp.com (Postfix) with ESMTP id 3590C340A3	for
 <MIKE.MILLER@hp.com>; Mon,  7 Dec 2009 15:29:58 +0000 (UTC)
Received: (from d7cadm@localhost)	by g2u0301c.austin.hp.com (@(#)Sendmail
 version 8.13.3 - Revision 1.004 - 12 January 2007/8.11.1) id nB7FTwv8024947
	for MIKE.MILLER@hP.COM; Mon, 7 Dec 2009 15:29:58 GMT
From: "Rodriguez, Jennifer (JCI)" <rodriguez.jennifer@hp.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Date: Mon, 7 Dec 2009 15:29:58 +0000
Subject: Notification number 001000029587 put in process
Thread-Topic: Notification number 001000029587 put in process
Thread-Index: Acp3Uq8hXoZtgpVRTFuB18azS09K4g==
Message-ID: <ADR34000001442227D7C300@hp.com>
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: G3W0060.americas.hpqcorp.net
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-authentication-warning: g2u0301c.austin.hp.com: d7cadm set sender to
 rodriguez.jennifer@hp.com using -f
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

Notification number 001000029587 put in process for user  phone number  Sho=
rt Desc Hot spot in lab M71B276


--_002_0F5B06BAB751E047AB5C87D1F77A778869941207A5GVW0547EXCame_--
