Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbXITRZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbXITRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXITRZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:25:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718AbXITRZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:25:48 -0400
Date: Thu, 20 Sep 2007 10:25:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: ebiederm@xmission.com
cc: Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten
 (sysfs?)
In-Reply-To: <20070920075353.GA6781@localhost.sw.ru>
Message-ID: <Pine.LNX.4.64.0709201019510.8283@schroedinger.engr.sgi.com>
References: <20070919123907.GA15591@localhost.sw.ru> <20070919125918.GA6760@localhost.sw.ru>
 <20070919123954.fb552e80.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0709191432200.3111@schroedinger.engr.sgi.com>
 <20070920075353.GA6781@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1831669752-1190309023=:8283"
Content-ID: <Pine.LNX.4.64.0709201023530.8283@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1831669752-1190309023=:8283
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0709201023531.8283@schroedinger.engr.sgi.com>

On Thu, 20 Sep 2007, Alexey Dobriyan wrote:

> OK, I do clean boot, ssh to box, then sudo slabinfo -v.
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> BUG kmalloc-16: Object padding overwritten
> -------------------------------------------------------------------------=
----
>=20
> INFO: 0xffff810100fd8998-0xffff810100fd8999. First byte 0xa7 instead of 0=
x5a
> INFO: Allocated in sysfs_new_dirent+0x100/0x120 age=3D11055 cpu=3D0 pid=
=3D3474
> INFO: Freed in kobject_uevent_env+0x123/0x430 age=3D11055 cpu=3D0 pid=3D3=
474
> INFO: Slab 0xffff810004837740 used=3D28 fp=3D0xffff810100fd89a0 flags=3D0=
x8000000000000083
> INFO: Object 0xffff810100fd8948 @offset=3D2376 fp=3D0xffff810100fd89a0

Hmmm.. A corrupted sysfs object at an offset of one word from the end of=20
the object that could never have been caught by SLAB since it does not=20
check more than 4 bytes. Does the value 0x5ea7 tell us anything? Maybe a=20
counter was incremented a couple of times from the initial value of 0x5a5a=
=20
that was put there by SLUB?

> INFO: 0xffff810101b45310-0xffff810101b45311. First byte 0xd3 instead of 0=
x5a
> INFO: Allocated in kobject_get_path+0x57/0xc0 age=3D18405 cpu=3D1 pid=3D2=
006
> INFO: Freed in kobject_uevent_env+0x123/0x430 age=3D18405 cpu=3D1 pid=3D2=
006
> INFO: Slab 0xffff81000485f718 used=3D8 fp=3D0xffff810101b45318 flags=3D0x=
8000000000000083
> INFO: Object 0xffff810101b452c0 @offset=3D704 fp=3D0xffff810101b45370
>=20
> Bytes b4 0xffff810101b452b0:  db f9 fb ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5=
a 5a =DB=F9=FB=FF....ZZZZZZZZ
>   Object 0xffff810101b452c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b a5 kkkkkkkkkkkkkkk=A5
>  Redzone 0xffff810101b452d0:  bb bb bb bb bb bb bb bb                    =
     =BB=BB=BB=BB=BB=BB=BB=BB       =20
>  Padding 0xffff810101b45310:  d3 5e 5a 5a 5a 5a 5a 5a                    =
     =D3^ZZZZZZ       =20

Ditto.... but here we have a freed object in the above case the object is=
=20
still in use. Done by different processes at different times.

Eric: Anything that comes to mind in sysfs?
---1700579579-1831669752-1190309023=:8283--
