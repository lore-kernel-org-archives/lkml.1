Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXJ1IeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXJ1IeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 04:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXJ1IeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 04:34:08 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:12412 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbXJ1IeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 04:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:sender;
        b=ehckpxZigOEqWVMgtGhlPstgZbE+0Tubfz6hbWxcHKmQvnzQJ6045pGlsAe4/uWya0uqemRAQrlFUq2h7x6+OvU3h6VGgzvD1AYu6BsLyYvTqtapkJWUvYK4R2BpVksljNdn/gCc02BV/abkxO2HGElS0D/1nOKIpXq85DFq3go=
Subject: Re: regression(?): starting with 2.6.21 sending packets became
	broken.
From: Peter Volkov <pva@gentoo.org>
To: David <david@unsolicited.net>, Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4711159D.1010305@unsolicited.net>
References: <1192299385.31908.8.camel@localhost>
	 <4711159D.1010305@unsolicited.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FbAjRVLjgeUwyEVEUPTB"
Date: Sun, 28 Oct 2007 11:33:58 +0300
Message-Id: <1193560438.13141.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FbAjRVLjgeUwyEVEUPTB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello, David, Jan.

=D0=92 =D0=A1=D0=B1=D1=82, 13/10/2007 =D0=B2 19:59 +0100, David =D0=BF=D0=
=B8=D1=88=D0=B5=D1=82:
> Try
>=20
> echo 0 > /proc/sys/net/ipv4/tcp_window_scaling
>=20
> I bet you have broken router(s) between your machine and the problem
> site(s).

Thank you for your help, but it occurs that the problem comes from IMQ
patch. I've reported that on imqlinux mailing list, but seems that it's
closed for those who do not have yahoo ID so I copy my report there and
answer here.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dmy investigation of the problem=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This bug was reported in our bugzilla ( bugs.gentoo.org/195731 ) but as
I found that IMQ is the root of problems I wanted to share my experience
here.

Starting with 2.6.21 (or may be 2.6.20 as I have not tried it) kernel I
have problem that most tcp based services freeze at some point of
operation. I've noticed this first on ssh but then found out that at
lease one other service
became similarly. The problem sites somewhere in the kernel as I've
compiled 2.6.19, 2.6.21, and 2.6.22 with the similar .config options (of
course not exact, as some options does not exist in some kernels, but
seems that
enabled options are all the same) but I have this problem only with the
21 and 22. I've tried to debug the problem a bit, but not a lot as that
is production box working as linux based firewall/router.

First I took tcpdump. Although ssh connection to the router is not
always possible as it often hangs before I get into router, after some
attempts ssh connection was established. On client computer I've started
tcpdump and worked a bit until hang. tcpdump output showed me that when
I press any keys the packets are sent to the server and proper ack are
received. Later I found that all commands I enter blindly are executed
on router but I receive no reply packets with some data in them (pure
ack). That's why nothing happens on the screen and it looks like
hanging.

Now I've got to the router started ssh connection from router to some
other server. It hanged too. I attached strace and found that ssh
receive keyboard pressings (read() calls in the output) and writes them
further
to the kernel (write() calls) but tcpdump on the router shows no
packets. So packets enter kernel and lost somewhere inside.

This problem was reproduced both on single core amd64 system and on x86
system with hyper threading. So I suspect everybody could reproduce this
problem. Just start `yes` which produce a lot of output and then press
Ctrl+C to interupt. It hanged here somewhere at this moment.

Suggestion "echo 0 > /proc/sys/net/ipv4/tcp_window_scaling" does not
helped here.

The end of the story is that if I localized that the problem sites in
this http://www.linuximq.net/patchs/linux-2.6.21-img2.diff IMQ patch.
If I install clean gentoo sources then connection does not freeze and
with this patch I have problems. BTW. This patch
http://www.actusa.net/~linuximq/linux-2.6.23-imq.diff does not have this
problem here too.

Thank you for your attention. I think may be it's good idea to mark that
patch as questionable on site?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D


=3D=3D=3D=3D=3D=3D=3D=3D vlad031 answer on linuximq mailing list=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D

Re: regression(?): starting with 2.6.21 sending packets became broken=20

We allready know that ... almost everybody does ... that's why we have
uploaded the good patches here:
http://www.actusa.net/~linuximq/

Andree isn't seem to take care of this project anymore...

Please note that 2.6.23 kernel has a lot of bugs and we don't recommend
using it yet as we had some imq problems related too (however, it doesnt
seem to be from imq patch)

Cheers!

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

--=20
Peter.

--=-FbAjRVLjgeUwyEVEUPTB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: =?UTF-8?Q?=D0=AD=D1=82=D0=B0?=
	=?UTF-8?Q?_=D1=87=D0=B0=D1=81=D1=82=D1=8C?=
	=?UTF-8?Q?_=D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D1=8F?=
	=?UTF-8?Q?_=D0=BF=D0=BE=D0=B4=D0=BF=D0=B8=D1=81=D0=B0=D0=BD=D0=B0?=
	=?UTF-8?Q?_=D1=86=D0=B8=D1=84=D1=80=D0=BE=D0=B2=D0=BE=D0=B9?=
	=?UTF-8?Q?_=D0=BF=D0=BE=D0=B4=D0=BF=D0=B8=D1=81=D1=8C=D1=8E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJElvz6tlgEWSarMRAhaqAJ9BhpUIbYuHflxfiKES0F7qnIPGAACgmckE
pDBciOPHrC5h20cMbKxfhfU=
=DSR1
-----END PGP SIGNATURE-----

--=-FbAjRVLjgeUwyEVEUPTB--

