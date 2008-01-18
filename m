Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYARNn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYARNn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYARNnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:43:20 -0500
Received: from pan.madism.org ([88.191.52.104]:57041 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYARNnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:43:20 -0500
Date: Fri, 18 Jan 2008 14:43:18 +0100
From: Pierre Habouzit <madcoder@debian.org>
To: linux-kernel@vger.kernel.org
Cc: madcoder@debian.org
Subject: epoll and shared fd's
Message-ID: <20080118134318.GD9607@artemis.madism.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="ieNMXl1Fr3cevapt";
	protocol="application/pgp-signature"; micalg=SHA1
Content-Disposition: inline
User-Agent: Madmutt/devel (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

  Hi,

  I just came across a strange behavior of epoll that seems to
contradict the documentation. Here is what happens:

* I have two processes P1 and P2, P1 accept()s connections, and send the
  resulting file descriptors to P2 through a unix socket.

* P2 registers the received socket in his epollfd.

  [time passes]

* P2 is done with the socket and closes it

* P2 gets events for the socket again !


  Though the documentation says that if a process closes a file
descriptor, it gets unregistered. And yes I'm sure that P2 doens't dup()
the file descriptor. Though (because of a bug) it was still open in
P1[0], hence the referenced socket still live at the kernel level.

  Of course the userland workaround is to force the EPOLL_CTL_DEL before
the close, which I now do, but costs me a syscall where I wanted to
spare one :|

  I _believe_ this is if not a bug, at least a misfeature, hence I'm
reporting the issue :)


PS: please Cc: on answers me I'm not subscribed.


  [0] and despite the bug in our software that leaked the socket, P1
      is supposed to only close the socket when P2 acks the fact that it
      received a valid fd (else P1 tries to send it to a P2'), and there
      may be uncontrollable races that could trigger the issue again
      (with P2 closing the socket before P1 had time to process the ACK
      and close the socket on its end).
--=20
=C2=B7O=C2=B7  Pierre Habouzit
=C2=B7=C2=B7O                                                madcoder@debia=
n.org
OOO                                                http://www.madism.org

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHkKz2vGr7W6HudhwRAvmRAJ9Wqmj/urNEXymJJzfOHa6Vaf+xGgCgn9xH
NUExjiTWWJ9/9ZVaxPYhSyw=
=Nrje
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
