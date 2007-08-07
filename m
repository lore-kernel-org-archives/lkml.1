Return-Path: <linux-kernel-owner+w=401wt.eu-S937309AbXHGWeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937309AbXHGWeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbXHGWdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:33:08 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33460 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756883AbXHGWdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:33:05 -0400
Subject: Re: why are some atomic_t's not volatile, while most are?
From: Zan Lynx <zlynx@acm.org>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46B8E64E.7010708@nortel.com>
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
	 <20070806123551.a6c3c154.wjiang@resilience.com>
	 <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com>
	 <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com>
	 <46B8E1D3.8050501@redhat.com>  <46B8E64E.7010708@nortel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8k3eNpcqmiPOymInSpsM"
Date: Tue, 07 Aug 2007 16:32:57 -0600
Message-Id: <1186525977.232321.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20070807/1IIXbm-0001C1-UA-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8k3eNpcqmiPOymInSpsM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-07 at 15:38 -0600, Chris Friesen wrote:
> Chris Snook wrote:
>=20
> > That's why we define atomic_read like so:
> >=20
> > #define atomic_read(v)          ((v)->counter)
> >=20
> > This avoids the aliasing problem, because the compiler must de-referenc=
e=20
> > the pointer every time, which requires a memory fetch.
>=20
> Can you guarantee that the pointer dereference cannot be optimised away=20
> on any architecture?  Without other restrictions, a suficiently=20
> intelligent optimiser could notice that the address of v doesn't change=20
> in the loop and the destination is never written within the loop, so the=20
> read could be hoisted out of the loop.
>=20
> Even now, powerpc (as an example) defines atomic_t as:
>=20
> typedef struct { volatile int counter; } atomic_t
>=20
>=20
> That volatile is there precisely to force the compiler to dereference it=20
> every single time.

I just tried this with GCC 4.2 on x86_64 because I was curious.

struct counter_t { volatile int counter; } test;
struct counter_t *tptr =3D &test;

int main() {
        int i;

        tptr->counter =3D 0;
        i =3D 0;
        while(tptr->counter < 100) {
                i++;
        }
        return 0;
}

$ gcc -O3 -S t.c

a snippet of t.s:
main:
.LFB2:
        movq    tptr(%rip), %rdx
        movl    $0, (%rdx)
        .p2align 4,,7
.L2:
        movl    (%rdx), %eax
        cmpl    $99, %eax
        jle     .L2


Now with the volatile removed:
main:
.LFB2:
        movq    tptr(%rip), %rax
        movl    $0, (%rax)
.L2:
        jmp     .L2

If the compiler can see it clearly, it will optimize out the load
without the volatile.
--=20
Zan Lynx <zlynx@acm.org>

--=-8k3eNpcqmiPOymInSpsM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGuPMZG8fHaOLTWwgRAiwxAJsFNNeJHK+5zHcpwgBmXF1mvpIorACfd/PR
AMz9FHLheVCpKXkWs5d8YYg=
=axXW
-----END PGP SIGNATURE-----

--=-8k3eNpcqmiPOymInSpsM--

