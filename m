Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbYKYHJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbYKYHJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYKYHJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:09:43 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:22098 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbYKYHJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:09:43 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-nfs@vger.kernel.org
Cc: Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1225546878.4390.3.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6b1jhfOm3xmsjk4QJplq"
Date: Tue, 25 Nov 2008 07:09:22 +0000
Message-Id: <1227596962.16868.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=6OAc2UI1ETEA:10 a=Gm1qT94b7fUA:10 a=QStd48bC5YiHwJ9Wd80A:9 a=ZX-gGUZOZfwIHXuMtPRGNGT2yMkA:4 a=Hf6muOzgCGQA:10 a=LY0hPdMaydYA:10 a=eZEE8z_ioiMgLW-9jC8A:9 a=4GE1xqV1A-q3dVtfJ-omsfAFkOwA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6b1jhfOm3xmsjk4QJplq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 09:41 -0400, Trond Myklebust wrote:
> On Sat, 2008-11-01 at 11:45 +0000, Ian Campbell wrote:
> > On Mon, 2008-10-20 at 07:27 +0100, Ian Campbell wrote:
> > > So far I have bisected down to this range and am currently testing
> > > acee478 which has been up for >4days.
> >=20
> > Another update. It has now bisected down to a small range=20
> >=20
> > 7272dcd31d56580dee7693c21e369fd167e137fe SUNRPC: xprt_autoclose() shoul=
d not call xprt_disconnect()
> > e06799f958bf7f9f8fae15f0c6f519953fb0257c SUNRPC: Use shutdown() instead=
 of close() when disconnecting a TCP socket
> > ef80367071dce7d2533e79ae8f3c84ec42708dc8 SUNRPC: TCP clear XPRT_CLOSE_W=
AIT when the socket is closed for writes
> > 3b948ae5be5e22532584113e2e02029519bbad8f SUNRPC: Allow the client to de=
tect if the TCP connection is closed
> > 67a391d72ca7efb387c30ec761a487e50a3ff085 SUNRPC: Fix TCP rebinding logi=
c
> > 66af1e558538137080615e7ad6d1f2f80862de01 SUNRPC: Fix a race in xs_tcp_s=
tate_change()
> >=20
> > I'm currently testing 3b948ae5be5e22532584113e2e02029519bbad8f.
> >=20
> > 7272dcd31d56580dee7693c21e369fd167e137fe repro'd in half a day while
> > ef818a28fac9bd214e676986d8301db0582b92a9 (parent of
> > 66af1e558538137080615e7ad6d1f2f80862de01) survived for 7 days.

According to bisect:

e06799f958bf7f9f8fae15f0c6f519953fb0257c is first bad commit
commit e06799f958bf7f9f8fae15f0c6f519953fb0257c
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon Nov 5 15:44:12 2007 -0500

    SUNRPC: Use shutdown() instead of close() when disconnecting a TCP sock=
et
   =20
    By using shutdown() rather than close() we allow the RPC client to wait
    for the TCP close handshake to complete before we start trying to recon=
nect
    using the same port.
    We use shutdown(SHUT_WR) only instead of shutting down both directions,
    however we wait until the server has closed the connection on its side.
   =20
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

I've started testing 2.6.26 + revert. It's been a long while since I
started this process so I'll also have a go at an up to date version.

Cheers,
Ian.
--=20
Ian Campbell

By failing to prepare, you are preparing to fail.

--=-6b1jhfOm3xmsjk4QJplq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkrpKIACgkQM0+0qS9rzVnVIQCcCLhKGIQDhnZHI+acfuPCOkFK
9ZEAnRRrd+75WYK9/xSiOnz0fdPUNXbR
=xhmF
-----END PGP SIGNATURE-----

--=-6b1jhfOm3xmsjk4QJplq--

