Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZJRWQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZJRWQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZJRWQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:16:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50878 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbZJRWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:16:51 -0400
X-Sasl-enc: vUVv3e2pDLw9vmVstH2iAEo61byyf4O3l81LjWkPuJmv 1255904215
Message-ID: <4ADB93C4.4090607@imap.cc>
Date: Mon, 19 Oct 2009 00:16:36 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       Netdev <netdev@vger.kernel.org>
Subject: possible circular locking dependency in ISDN PPP
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig76E76DB8A384B495F208F952"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig76E76DB8A384B495F208F952
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

A test of PPP over ISDN with ipppd, capidrv and the so far unmerged
CAPI port of the Gigaset driver produced the following lockdep
message:

 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 [ INFO: possible circular locking dependency detected ]
 2.6.32-rc4-testing #7
 -------------------------------------------------------
 ipppd/28379 is trying to acquire lock:
  (&netdev->queue_lock){......}, at: [<e62ad0fd>] isdn_net_device_busy+0x=
2c/0x74 [isdn]
=20
 but task is already holding lock:
  (&netdev->local->xmit_lock){+.....}, at: [<e62aefc2>] isdn_net_write_su=
per+0x3f/0x6e [isdn]
=20
 which lock already depends on the new lock.=20
 =20
 =20
 the existing dependency chain (in reverse order) is:
 =20
 -> #1 (&netdev->local->xmit_lock){+.....}:
        [<c0157e9c>] __lock_acquire+0xa12/0xb99
        [<c01580ac>] lock_acquire+0x89/0xa0
        [<c0373249>] _spin_lock+0x1b/0x2a
        [<e62b9d1c>] isdn_ppp_xmit+0xf0/0x5b0 [isdn]
        [<e62b03f0>] isdn_net_start_xmit+0x4c6/0x66b [isdn]
        [<c0307e75>] dev_hard_start_xmit+0x251/0x2e4
        [<c0317bcc>] sch_direct_xmit+0x4f/0x122
        [<c030829c>] dev_queue_xmit+0x2ae/0x412
        [<c030d748>] neigh_resolve_output+0x1f2/0x23c
        [<c0329b9c>] ip_finish_output2+0x1b1/0x1db
        [<c0329c25>] ip_finish_output+0x5f/0x62
        [<c0329cb5>] ip_output+0x8d/0x92
        [<c03290c0>] ip_local_out+0x18/0x1b
        [<c032932c>] ip_push_pending_frames+0x269/0x2c1
        [<c033fd78>] raw_sendmsg+0x618/0x6b0
        [<c0347ac9>] inet_sendmsg+0x3b/0x48
        [<c02fa5b5>] __sock_sendmsg+0x45/0x4e
        [<c02fad4b>] sock_sendmsg+0xb8/0xce
        [<c02faea0>] sys_sendmsg+0x13f/0x192
        [<c02fbeb2>] sys_socketcall+0x157/0x18e
        [<c0102974>] sysenter_do_call+0x12/0x32
 =20
 -> #0 (&netdev->queue_lock){......}:
        [<c0157da9>] __lock_acquire+0x91f/0xb99
        [<c01580ac>] lock_acquire+0x89/0xa0
        [<c03732db>] _spin_lock_irqsave+0x24/0x34
        [<e62ad0fd>] isdn_net_device_busy+0x2c/0x74 [isdn]
        [<e62aeee3>] isdn_net_writebuf_skb+0x6e/0xc2 [isdn]
        [<e62aefd4>] isdn_net_write_super+0x51/0x6e [isdn]
        [<e62bc26f>] isdn_ppp_write+0x3a8/0x3bc [isdn]
        [<e62b785a>] isdn_write+0x1d9/0x1f9 [isdn]
        [<c01c42c5>] vfs_write+0x84/0xdf
        [<c01c43b9>] sys_write+0x3b/0x60
        [<c0102974>] sysenter_do_call+0x12/0x32
 =20
 other info that might help us debug this:
 =20
 1 lock held by ipppd/28379:
  #0:  (&netdev->local->xmit_lock){+.....}, at: [<e62aefc2>] isdn_net_wri=
te_super+0x3f/0x6e [isdn]
 =20
 stack backtrace:
 Pid: 28379, comm: ipppd Not tainted 2.6.32-rc4-testing #7
 Call Trace:
  [<c03710dc>] ? printk+0xf/0x13
  [<c015714d>] print_circular_bug+0x90/0x9c
  [<c0157da9>] __lock_acquire+0x91f/0xb99
  [<c01580ac>] lock_acquire+0x89/0xa0
  [<e62ad0fd>] ? isdn_net_device_busy+0x2c/0x74 [isdn]
  [<c03732db>] _spin_lock_irqsave+0x24/0x34
  [<e62ad0fd>] ? isdn_net_device_busy+0x2c/0x74 [isdn]
  [<e62ad0fd>] isdn_net_device_busy+0x2c/0x74 [isdn]
  [<e62aeee3>] isdn_net_writebuf_skb+0x6e/0xc2 [isdn]
  [<e62aefd4>] isdn_net_write_super+0x51/0x6e [isdn]
  [<e62bc26f>] isdn_ppp_write+0x3a8/0x3bc [isdn]
  [<e62b785a>] isdn_write+0x1d9/0x1f9 [isdn]
  [<c01c3b6c>] ? rw_verify_area+0x8a/0xad
  [<e62b7681>] ? isdn_write+0x0/0x1f9 [isdn]
  [<c01c42c5>] vfs_write+0x84/0xdf
  [<c01c43b9>] sys_write+0x3b/0x60
  [<c0102974>] sysenter_do_call+0x12/0x32

The message appeared shortly after initiating the connection,
during the PPP negotiation, just when the IP address was assigned.
The system continued to run normally, and the connection was
successfully established. Full log showing the entire connection
(with capidrv and Gigaset driver debugging output enabled, 70 kB),
available at http://www.phoenixsoftware.de/~ts/ppp-lockprob-full.log
in case someone's interested. It shows the messages from ipppd
about the IP address assignment arriving in the middle of the
lockdep message.

I cannot say whether this is a regression. My previous tests of
that scenario were done on a machine with an Nvidia graphics card
where the lockdep machinery would refuse to run because of the
kernel being tainted by the Nvidia driver, so I wouldn't have seen
anything one way or another.

Btw, one of those "NOHZ: local_softirq_pending 08" messages is also
present in the log, but that's 28 seconds later so I'd be surprised
if the two were related.

Any hints about the possible cause and seriousness of that
message would be welcome. I'm particularly interested, of course,
in finding out whether the Gigaset driver might somehow be causing
it, even though it doesn't appear anywhere in the backtraces.

aTdHvAaNnKcSe
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig76E76DB8A384B495F208F952
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK25PUQ3+did9BuFsRAjffAJ0Q68oQRTIgMiu0vaAOdB0Dzi/PJwCaAiCS
Kwc4NBDQpLYMaOzudXkPy9g=
=yXsr
-----END PGP SIGNATURE-----

--------------enig76E76DB8A384B495F208F952--
