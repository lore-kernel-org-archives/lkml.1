Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZKBItH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZKBItH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 03:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZKBItH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 03:49:07 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:39517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbZKBItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 03:49:05 -0500
Subject: Re: wpa2 hangs v2.6.32-rc5-402-gb6727b1. Revert
 7d930bc33653d5592dc386a76a38f39c2e962344  fixed it.
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0911011641101.31845@localhost.localdomain>
References: <Pine.LNX.4.64.0911012318000.3549@boston.corp.fedex.com>
	 <1257089345.3555.158.camel@johannes.local>
	 <b6a2187b0911011612v4a874640s62105a7323b01ad0@mail.gmail.com>
	 <alpine.LFD.2.01.0911011641101.31845@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-elZN6w29KY27Tk89Read"
Date: Mon, 02 Nov 2009 09:49:02 +0100
Message-ID: <1257151742.3555.165.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-elZN6w29KY27Tk89Read
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-01 at 16:53 -0800, Linus Torvalds wrote:

> That decodes to=20
>=20
> cfg80211_conn_work+89:
>=20
>    3:	89 ef                	mov    %ebp,%edi
>    5:	e8 6f be 41 e1       	callq  0xffffffffe141be79
>    a:	48 8b 43 20          	mov    0x20(%rbx),%rax
>    e:	f6 40 48 01          	testb  $0x1,0x48(%rax)
>   12:	74 5d                	je     0x71
>   14:	83 bb 8c 00 00 00 01 	cmpl   $0x1,0x8c(%rbx)
>   1b:	75 54                	jne    0x71
>   1d:	48 ?? 50 08          	???    0x8(%rax) ???? uncertain instruction ?=
???
>   21:*	8b 02                	mov    (%rdx),%eax     <-- trapping instruct=
ion
>   23:	41 89 45 00          	mov    %eax,0x0(%r13)
>   27:	66 8b 42 04          	mov    0x4(%rdx),%ax
>   2b:	66 41 89 45 04       	mov    %ax,0x4(%r13)
>   30:	e8 f5 ea ff ff       	callq  0xffffffffffffeb2a
>=20
> trace:
>   __cfg80111_scan_done
>   worker_thread
>=20
> which looks like it matches this code:
>=20
>         movq    %r14, %rdi      # D.43604,
>         call    mutex_lock      #
>         movq    32(%rbx), %rax  # <variable>.netdev, <variable>.netdev
>         testb   $1, 72(%rax)    #, <variable>.state
>         je      .L215   #,
>         cmpl    $1, 140(%rbx)   #, <variable>.sme_state
>         jne     .L215   #,
>         movq    144(%rbx), %rax # <variable>.conn, <variable>.conn
>         movq    %rbx, %rdi      # wdev,
>         movq    8(%rax), %rax   # <variable>.params.bssid, <variable>.par=
ams.bssid
>         movl    (%rax), %edx    #* <variable>.params.bssid, tmp74
>         movl    %edx, 0(%r13)   # tmp74, bssid
>         movw    4(%rax), %ax    #, tmp75
>         movw    %ax, 4(%r13)    # tmp75, bssid
>         call    cfg80211_conn_do_work   #
>=20
> ie it looks like 'conn->params.bssid' is NULL and we oops when we try to=20
> load bssid from there. The code is:
>=20
> 	memcpy(bssid, wdev->conn->params.bssid, ETH_ALEN);
>=20
> where ETH_ALEN is 6 bytes, so the memcpy is inlined..
>=20
> And yes, that "memcpy()" was added in that buggy commit.=20

Indeed, thank you. I'd analysed this before but not made the connection
with Jeff's report.

> So reverting 7d930bc33653d5592dc386a76a38f39c2e962344 is the correct thin=
g=20
> to do. Or somebody needs to fix that piece-of-shit code.

Yes ... that params.bssid was !=3D NULL was a bad assumption in that
commit. The right thing to do is to add a check and pass NULL through,
like I did here:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/41695

johannes

--=-elZN6w29KY27Tk89Read
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7pz7AAoJEODzc/N7+QmaptEP/RTQCj09kY1236bG+AMudX3X
m78Wzd1AzaX6Sz3uHBqg/eqCvy/EYt/yWmEYrEZOM4TAbx3YLKXU6nmQqn1mnWxb
wpLssm7E8QoEYLyF0k7vHVi9hByxe1+/HBJ3RunIZ1u9r9Vb3zS1DnfUQwcabXc1
pB9AbDjxbprORhTYTBmlC4rAtv/pJXxDyhveoJs5xDPO/OLaoy0yCaLk+gOiqOE3
1qlJW0NBpvM4cqBM1JiRITvvUq6OoMmvKmOowKEc6gUrVRj/4NB0O1ZkIebdCA+1
w8P3n3ETuDXIYXonQcn8zaFLf8aGrSYKqjdp6ZyaoFdAxiw0h9q5/5G1s1DycGHE
MP78R0E8EzyB/VDzfLlzre/WN0q9vh6f2ASz46tabj7KVnOunp1F9NqxY2nxEeZI
Hml9gbWNf+P4MmDYVCW3Q8Z9/wJ4rHj3QpaqQB9UTwxN58QPG7dn7EJG8HRIdA3J
iKdNmQUIVJzincyrJikGbkDBfMMKRW3JdAxprIXiM39Urt3cmPUn0D5HPogNLU8D
GBGg3dBjbDZ+s9MsCPoTgikXOyqCI8oCpRN9eYhKhD/ygoyOQPHO0oWtT+m9LFFT
8eRfPzi6efgTM2yP4NVk5JErZBcGznNjLXPfUWicdCsc5IQ3tupR5QH/4+BcO7Ig
ildfnce4nNvVgqkQzTHz
=Ncqn
-----END PGP SIGNATURE-----

--=-elZN6w29KY27Tk89Read--

